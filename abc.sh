#!/bin/bash
####################
##     VARS       ##
####################
# set this as your github username
username=stirtingale
password=qwerty
# automatically get existing git name 
function get_git_name() {
	git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p'
}
existin_repo_name=$(get_git_name)
test -z $existin_repo_name && echo "An existing repo name is required." 1>&2 && exit 1
####################
##    MOVE IT     ##
####################
# create new git rep
curl -u "${secrets.GIT_USERNAME}:${secrets.GIT_PASSWORD}" https://api.github.com/user/repos -d "{\"name\":\"$existin_repo_name\", \"private\":\"true\" , \"description\":\"Private Repo for ${username} Project - ${existin_repo_name}\" }"
echo "CREATED NEW GITHUB REPO"
echo "https://github.com/${username}/${existin_repo_name}"

# rename existin repo
git remote rename origin bitbucket
echo "RENAMED REMOTE"

# set new repo as git remote
git remote add origin git@github.com:${username}/${existin_repo_name}.git

echo "GITHUB SET AS REMOTE ORIGIN"

# lets double check it is set to ssh!
git remote set-url origin git@github.com:${username}/${existin_repo_name}.git
# push to new git
git push origin master

echo "PUSHING OLD REPO TO NEW"

# remove old bitbucket
git remote rm bitbucket

echo "REMOVING BITBUCKET REMOTE"

echo "END MIGRATION"