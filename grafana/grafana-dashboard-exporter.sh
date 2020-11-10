# Source https://gist.github.com/crisidev/bd52bdcc7f029be2f295

KEY=$1
HOST=$2

mkdir -p dashboards

for dash in $(curl -k -H "Authorization: Bearer $KEY" $HOST/api/folders | jq -r '.[].uid'); do
    curl -k -H "Authorization: Bearer $KEY" $HOST/api/folders/$dash >dashboards/$dash.json

    name=$(jq -r '.title' dashboards/$dash.json | sed 's/ /_/g' | sed 's/\//_/g')
    mkdir -p dashboards/$name
    mv dashboards/$dash.json dashboards/$name/folder.json
done

for dash in $(curl -k -H "Authorization: Bearer $KEY" $HOST/api/search\?query\=\& | jq -r '.[].uid'); do
    curl -k -H "Authorization: Bearer $KEY" $HOST/api/dashboards/uid/$dash >dashboards/$dash.json

    name=$(jq -r '.dashboard.title' dashboards/$dash.json | sed 's/ /_/g' | sed 's/\//_/g')
    folder=$(jq -r '.meta.folderTitle' dashboards/$dash.json | sed 's/ /_/g' | sed 's/\//_/g')
    if [ "${folder}" = "General" ]; then
        mv dashboards/$dash.json dashboards/$name-dashboard.json
    else
        mv dashboards/$dash.json dashboards/$folder/$name-dashboard.json
    fi
done
