#!/bin/bash

# Better be specific rather than using $HOME because it wouldn't work with all users.
GIT_REPO=/home/draga/go-web
WORKING_DIRECTORY=$GIT_REPO/public
PUBLIC_WWW=/home/draga/public_html
BACKUP_WWW=/home/draga/backup_html

set -e

# Clean working dir.
rm -rf $WORKING_DIRECTORY
# Backup current website. Use -z if moving across network to save bandwidth.
rsync -aq $PUBLIC_WWW/ $BACKUP_WWW
# Restore backup if an error occurs from now on.
trap "echo 'A problem occurred.  Reverting to backup.'; rsync -aq --del $BACKUP_WWW/ $PUBLIC_WWW; rm -rf $WORKING_DIRECTORY" EXIT

# fetch repo to make sure it's up to date if working with remote webhook.
cd $GIT_REPO
git fetch
# Build the website. GO HUGO!
/usr/bin/hugo -s $GIT_REPO -d $WORKING_DIRECTORY
# Copy the output of Hugo to the directory where the website is hosted.
# Use -c to copy only files that have changed to avoid messing with webhost caches.
# Use -z if moving across network to save bandwidth.
rsync -aqc $WORKING_DIRECTORY $PUBLIC_WWW
# Disable trap.
trap - EXIT

