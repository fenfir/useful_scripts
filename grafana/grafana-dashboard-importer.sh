#/bin/bash

KEY=$1
HOST=$2
DASH_PATH=$3

declare -A folders
folders["General"]=0

for dash in $(find $DASH_PATH -type f -iname 'folder.json'); do
  d=$(jq '. | .uid = null | .id = null | .url = null  | .overwrite = true' $dash)
  id=$(curl -qk -H "Content-Type: application/json" -H "Authorization: Bearer $KEY" -XPOST $HOST/api/folders -d "$d" | jq -r '.id')
  name=$(jq -r '. | .title' $dash)

  echo -e "\nCreating folder $name\n\n"
done

for dash in $(curl -k -H "Authorization: Bearer $KEY" $HOST/api/folders | jq -r '.[].uid'); do
  curl -qk -H "Authorization: Bearer $KEY" $HOST/api/folders/$dash >/tmp/folder.json
  name=$(jq -r '. | .title' /tmp/folder.json)
  id=$(jq -r '. | .id' /tmp/folder.json)

  folders[$name]=$id
done

for dash in $(find $DASH_PATH -type f -iname '*-dashboard.json'); do
  folderName=$(jq -r '.meta.folderTitle' $dash)
  d=$(jq '. | .dashboard.uid = null | .dashboard.id = null | .overwrite = true | del(.meta) | .folderId = '${folders[$folderName]}'' $dash | sed 's/"datasource": "prometheus"/"datasource": "Prometheus"/g')

  echo -e "\nCreating dashboard $dash in $folderName\n\n"

  echo $d > /tmp/data.json
  curl -qk -H "Content-Type: application/json" -H "Authorization: Bearer $KEY" -XPOST $HOST/api/dashboards/db -d @/tmp/data.json
done
