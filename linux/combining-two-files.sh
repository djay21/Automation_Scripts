
cat << EOF > table.html
<table>
  <tr>
    <th>Image</th>
    <th>Gitsha</th>
    <th>Total</th>
    <th>Critical</th>
    <th>High</th>
    <th>Medium</th>
    <th>Low</th>
    <th>Result</th>
  </tr>
</table>
EOF
function create_row() {
cat << EOF > row.txt
  <tr>
    <td>image</th>
    <td>gitsha</th>
    <td>total</th>
    <td>critical</th>
    <td>high</th>
    <td>medium</th>
    <td>low</th>
    <td>result</th>
  </tr>
EOF
}
filename="abc.txt"

 while IFS= read -r line; do
        create_row
        image=$(echo "$line" | cut -d "," -f 1)
        result=$(echo "$line" | cut -d "," -f 8 | tr -d " ")
        gitsha=$(echo "$line" | cut -d "," -f 2 | tr -d " ")
        total=$(echo "$line" | cut -d "," -f 3 | tr -cd '[[:digit:]]')
        critical=$(echo "$line" | cut -d "," -f 4 | tr -cd '[[:digit:]]')
        high=$(echo "$line" | cut -d "," -f 5 | tr -cd '[[:digit:]]')
        medium=$(echo "$line" | cut -d "," -f 6 | tr -cd '[[:digit:]]')
        low=$(echo "$line" | cut -d "," -f 7 | tr -cd '[[:digit:]]')
        sed -i "s|result|${result}|g" row.txt
        sed -i "s|image|${image}|g" row.txt
        sed -i "s|gitsha|${gitsha}|g" row.txt
        sed -i "s|total|${total}|g" row.txt
        sed -i "s|critical|${critical}|g" row.txt
        sed -i "s|high|${high}|g" row.txt
        sed -i "s|medium|${medium}|g" row.txt
        sed -i "s|low|${low}|g" row.txt
        sed -i '$e cat row.txt' table.html
        rm -rf row.txt
    done < "$filename"