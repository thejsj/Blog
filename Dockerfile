#
# Ghost Dockerfile
#
# https://github.com/dockerfile/ghost
#

# Pull base image.
FROM dockerfile/nodejs

# Install Ghost
RUN \
  cd /tmp && \
  wget https://ghost.org/zip/ghost-latest.zip && \
  unzip ghost-latest.zip -d /ghost && \
  rm -f ghost-latest.zip && \
  cd /ghost && \
  npm install --production && \
  sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js && \
  useradd ghost --home /ghost

# Add files.
ADD start.sh /ghost-start
RUN chmod +x /ghost-start
# RUN mkdir -p /ghost-override/content/themes
# ADD content/themes /ghost-override/content/themes

# Set environment variables.
ENV NODE_ENV production

# Define mountable directories.
# We load the volumes from the local directory
# That way, we don't have to worry about backups or lost files....
# like last time
# VOLUME ["/ghost-override/content/data", "/ghost-override/content/images"]

# Define working directory.
WORKDIR /ghost

# Define default command.
ENTRYPOINT ["/ghost-start"]

# Expose ports.
EXPOSE 2368
