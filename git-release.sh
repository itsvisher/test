#!/bin/bash

version=$1
text=$2
#commit_message=$3
branch=$3
prerelease=$4
#branch=$(git rev-parse --abbrev-ref HEAD)
repo_full_name=$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///;s/.git$//')
token=$(git config --global github.token)

if [ "$#" -ne 4 ]; then
  echo 'Arguments missing. See usage below: '
  echo 'Usage: ./git-release.sh "<VERSION>" "<RELEASE TEXT>" "<BRANCH NAME>" "<PRERELEASE - true or false>". If pre-release argument is not provided, it will be considered as true.'
  exit 1
fi

if [ -z "$prerelease" ]
then
      echo "\$prerelease not provided. Assuming this release as a prerelease"
      prerelease=true
fi

# #echo "Adding commit: " $commit_message
# #git commit -m "$commit_message"
# #git push origin $branch

git tag -a $1 -m "$2"

generate_post_data()
{
  cat <<EOF
{
  "tag_name": "$version",
  "target_commitish": "$branch",
  "name": "$version",
  "body": "$text",
  "draft": false,
  "prerelease": $prerelease
}
EOF
}

# #echo "Commit message: $commit_message"

echo "Create release $version for repo: $repo_full_name branch: $branch"

echo 'Generating post data: $generate_post_data'
curl --data "$(generate_post_data)" "https://api.github.com/repos/$repo_full_name/releases?access_token=$token"

