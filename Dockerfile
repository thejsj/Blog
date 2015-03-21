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

# Set environment variables.
ENV NODE_ENV production

# Define working directory.
WORKDIR /ghost

# Define default command.
ENTRYPOINT ["/ghost-start"]

# Expose ports.
EXPOSE 2368
