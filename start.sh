#!/bin/bash

GHOST="/ghost"
OVERRIDE="/ghost-override"

CONFIG="config.js"
DATA="content/data"
IMAGES="content/images"
THEMES="content/themes"

# Symlink images directory
mkdir -p "$OVERRIDE/$IMAGES"
rm -rf "$GHOST/$IMAGES"
ln -s "$OVERRIDE/$IMAGES" "$IMAGES"

# Symlink data directory.
mkdir -p "$OVERRIDE/$DATA"
rm -fr "$GHOST/$DATA"
ln -s "$OVERRIDE/$DATA" "$DATA"

# Symlink themes directory.
# mkdir -p "$OVERRIDE/$THEMES"
rm -fr "$GHOST/$THEMES"
ln -s "$OVERRIDE/$THEMES" "$THEMES"

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
  rm -f "$CONFIG"
  ln -s "$OVERRIDE/$CONFIG" "$CONFIG"
fi

# # Symlink themes.
# if [[ -d "$OVERRIDE/$THEMES" ]]; then
#   for theme in $(find "$OVERRIDE/$THEMES" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
#   do
#     rm -fr "$THEMES/$theme"
#     ln -s "$OVERRIDE/$THEMES/$theme" "$THEMES/$theme"
#   done
# fi

# Change URL in config.js
/bin/bash -c "sed -i.bak s/my-ghost-blog.com/$BLOG_URL/g $GHOST/$CONFIG"

# Start Ghost
chown -R ghost:ghost /ghost /ghost-override
su ghost << EOF
cd "$GHOST"
NODE_ENV=${NODE_ENV:-production} npm start
EOF