 #!/bin/bash

filter="FILTERS\$1"
r_folder="$2"
l_folder="$3"
unzipAfter="$4"

# Step 0 - figure out where we are in relation to the Emulation folder
updir='.'
while [ -d "$updir" ]; do
  if [ -d "$updir/Emulation" ]; then
    l_folder="$updir/Emulation/roms/$l_folder"
    break
  fi
  updir="../$updir"
done

if [ ! -d "$l_folder" ]; then
  read -p "Can't find Emulation folder; Just download to ROMS folder here?" -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
  l_folder="ROMS/$l_folder"
fi

if [ -d "$updir" ]; then
  updir=".$updir"
# Step 1 - check for rclone and download/extract if missing

if [ ! -f "rclone" ]; then
    echo "Downloading rclone"
    t=$(mktemp -d 2> /dev/null)
    pushd "$t" > /dev/null
    curl -OfsS "https://downloads.rclone.org/rclone-current-linux-amd64.zip"
    unzip rclone-current-linux-amd64.zip > /dev/null
    mv */rclone . > /dev/null
    popd > /dev/null
    cp "$t/rclone" . > /dev/null
fi

# Step 2 - If zips were extracted, we need to filter the filter list

if [ -n "$unzipAfter" ] && [ -d "$l_folder" ]; then
    tempFilter=$(mktemp 2> /dev/null)
    while read z; do
        f=${z%.*}
        if [ ! -d "$l_folder/$f" ]; then
            echo "$z" >> "$tempFilter"
        fi
    done < "$filter"
    filter="$tempFilter"
fi

# Step 3 - download

./rclone copy -v --ignore-existing --http-no-head --include-from "$filter" ":http,url='https://myrient.erista.me':$r_folder" "$l_folder"

# Step 4 - Unzip if necessary

if [ -n "$unzipAfter" ]; then
    pushd "$l_folder" > /dev/null
    for zipped in *.zip; do
        [ -f "$zipped" ] || break
        echo "Unzipping $zipped"
        dest=$(basename "$zipped" .zip)
        unzip -u "$zipped" > /dev/null -d "$dest"
        rm "$zipped"
    done
    popd > /dev/null
fi
