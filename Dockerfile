FROM node:19.3-bullseye-slim

# Container specific configurations that can be passed as ENV variables.
# These are only used if no configuration file is provided during docker run.
# If you change the web UI port in the configuration file, remember to expose it here too.
# https://github.com/TuomoKu/SPX-GC#app-configuration-options-
ENV USERNAME=""
ENV PASSWORD=""
ENV HOSTNAME=""
ENV GREETING="Default configuration can be overridden by passing ENV variables to the Docker container.""
ENV LANGFILE="english.json"
ENV LOGLEVEL="info"
ENV LAUNCHCHROME="false"
ENV RESOLUTION="HD"
ENV PREVIEW="selected"
ENV RENDERER="normal"
ENV LOGFOLDER="/usr/src/app/LOG/"
ENV DATAROOT="/usr/src/app/DATAROOT/"
ENV TEMPLATESOURCE="spx-ip-address"
ENV PORT="5656"
ENV DISABLECONFIGUI="false"
ENV HEALTHCHECK_PORT="3000"

RUN apt-get update && apt-get install curl -y

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm ci --only=production
RUN npm audit fix

# Bundle app source
COPY . .

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

HEALTHCHECK --timeout=2s --interval=3s --retries=3 CMD curl -f http://localhost:${HEALTHCHECK_PORT} || exit 1

EXPOSE ${PORT} ${HEALTHCHECK_PORT}

# Run your program under Tini
CMD ["node", "server.js", "config.json", "-i DATAROOT/*", "-i ASSETS/*"]
