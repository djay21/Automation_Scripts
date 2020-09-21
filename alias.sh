wget https://raw.githubusercontent.com/djay21/Automation_Scripts/master/alias.txt
sudo usermod -aG docker $USER
sed -i '/^alias/d' ~/.bashrc
cat alias.txt >> ~/.bashrc
source ~/.bashrc
rm -rf alias.txt
