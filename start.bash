#!/bin/bash

GHOST="/ghost"
OVERRIDE="/ghost-override"

CONFIG="config.js"
DATA="content/data"
IMAGES="content/images"
THEMES="content/themes"

# For some reason, something delete our content when we copy it in the Dockerfile
rm -rf /ghost-override/content
mv /_ghost-override/content "$OVERRIDE"
rm -rf /_ghost-override

# Link and Remove Directories
cd "$GHOST"

# Symlink data directory.
mkdir -p "$OVERRIDE/$DATA"
rm -fr "$DATA"
ln -s "$OVERRIDE/$DATA" "$DATA"

# Symlink images directory
mkdir -p "$OVERRIDE/$IMAGES"
rm -fr "$IMAGES"
ln -s "$OVERRIDE/$IMAGES" "$IMAGES"

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
  rm -f "$CONFIG"
  ln -s "$OVERRIDE/$CONFIG" "$CONFIG"
fi

# Symlink themes.
if [[ -d "$OVERRIDE/$THEMES" ]]; then
  for theme in $(find "$OVERRIDE/$THEMES" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
  do
    rm -fr "$THEMES/$theme"
    ln -s "$OVERRIDE/$THEMES/$theme" "$THEMES/$theme"
  done
fi

# Change URL in config.js
/bin/bash -c "sed -i.bak s/my-ghost-blog.com/$BLOG_URL/g $GHOST/$CONFIG"

# Start Ghost
chown -R ghost:ghost /data /ghost /ghost-override
su ghost << EOF
cd "$GHOST"
NODE_ENV=${NODE_ENV:-production} npm start
EOF