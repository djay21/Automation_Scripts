from googleapiclient.discovery import build
import google.auth

credentials, _ = google.auth.default()

# V1 is needed to call all methods except for the ones related to folders
rm_v1_client = build('cloudresourcemanager', 'v1', credentials=credentials, cache_discovery=False) 

# V2 is needed to call folder-related methods
rm_v2_client = build('cloudresourcemanager', 'v2', credentials=credentials, cache_discovery=False) 

ORGANIZATION_ID = '234543243'

def listAllProjects():
    # Start by listing all the projects under the organization
    filter='parent.type="organization" AND parent.id="{}"'.format(ORGANIZATION_ID)
    projects_under_org = rm_v1_client.projects().list(filter=filter).execute()

    # Get all the project IDs
    all_projects = [p['projectId'] for p in projects_under_org['projects']]

    # Now retrieve all the folders under the organization
    parent="folders/"+ORGANIZATION_ID
    folders_under_org = rm_v2_client.folders().list(parent=parent).execute()

    # Make sure that there are actually folders under the org
    if not folders_under_org:
        return all_projects

    # Now sabe the Folder IDs
    folder_ids = [f['name'].split('/')[1] for f in folders_under_org['folders']]

    # Start iterating over the folders
    while folder_ids:
        # Get the last folder of the list
        current_id = folder_ids.pop()
        
        # Get subfolders and add them to the list of folders
        subfolders = rm_v2_client.folders().list(parent="folders/"+current_id).execute()
        
        if subfolders:
            folder_ids.extend([f['name'].split('/')[1] for f in subfolders['folders']])
        
        # Now, get the projects under that folder
        filter='parent.type="folder" AND parent.id="{}"'.format(current_id)
        projects_under_folder = rm_v1_client.projects().list(filter=filter).execute()
        
        # Add projects if there are any
        if projects_under_folder:
            all_projects.extend([p['projectId'] for p in projects_under_folder['projects']])

    # Finally, return all the projects
    return all_projects

if __name__=='__main__':
    print(listAllProjects())