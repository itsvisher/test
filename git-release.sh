#!/bin/bash

version=$1
text=$2
commit_message=$3
branch=$(git rev-parse --abbrev-ref HEAD)
repo_full_name=$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///;s/.git$//')
token=$(git config --global github.token)

echo "Adding commit: " $commit_message
git commit -m "$commit_message"
git push origin $branch

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
  "prerelease": false
}
EOF
}

echo "Commit message: $commit_message"

echo "Create release $version for repo: $repo_full_name branch: $branch"

echo $generate_post_data
curl --data "$(generate_post_data)" "https://api.github.com/repos/$repo_full_name/releases?access_token=$token"

