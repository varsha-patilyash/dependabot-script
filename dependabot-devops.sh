#!/bin/bash

SYSTEM_COLLECTIONURI_TRIM=`echo "${SYSTEM_COLLECTIONURI:22}"`
PROJECT_PATH="$SYSTEM_COLLECTIONURI_TRIM$SYSTEM_TEAMPROJECT/_git/$BUILD_REPOSITORY_NAME"

echo "org: $SYSTEM_COLLECTIONURI_TRIM"
echo "project: $SYSTEM_TEAMPROJECT"
echo "repo: $BUILD_REPOSITORY_NAME"
echo "path: $PROJECT_PATH"

FILECOUNT="$(find . -name packages.config | wc -l)"
echo "Found $FILECOUNT dependency file(s)."

find . -name packages.config | while read path; do
  PARENTNAME="$(basename "$(dirname "$path")")"
  DIRECTORY_PATH="/"$PARENTNAME
  echo "directory: $DIRECTORY_PATH"

  echo "---[ Starting dependabot run: $path ]---"
  docker run  \
    -v "$(pwd)/dependabot-script:/home/dependabot/dependabot-script" \
    -v "$(pwd):/repo" \
    -w /home/dependabot/dependabot-script \
    -e AZURE_ACCESS_TOKEN="$AZURE_ACCESS_TOKEN" \
    -e PACKAGE_MANAGER="nuget" \
    -e PROJECT_PATH="$PROJECT_PATH" \
    -e DIRECTORY_PATH="$DIRECTORY_PATH" \
    dependabot-local \
    bundle exec ruby ./generic-update-script.rb
  echo "---[ Finished dependabot run ]---"
done
