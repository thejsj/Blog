#!/bin/bash

GHOST="/ghost"
OVERRIDE="/ghost-override"

CONFIG="config.js"

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
  rm -f "$CONFIG"
  ln -s "$OVERRIDE/$CONFIG" "$CONFIG"
fi

# Change URL in config.js
/bin/bash -c "sed -i.bak s/my-ghost-blog.com/$BLOG_URL/g $GHOST/$CONFIG"

# Start Ghost
chown -R ghost:ghost /ghost
su ghost << EOF
cd "$GHOST"
NODE_ENV=${NODE_ENV:-production} npm start
EOF
