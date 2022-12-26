FROM node:19.3-bullseye-slim

# Container specific configurations that can be passed as ENV variables.
# If you change the web UI port in the configuration file, remember to expose it here too.
ENV PORT=5656
ENV HEALTHCHECK_PORT=3000

# Healthcheck, not needed or used by SPX
RUN apt-get update && apt-get install curl -y
HEALTHCHECK --timeout=2s --interval=3s --retries=3 CMD curl -f http://localhost:${HEALTHCHECK_PORT} || exit 1

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

EXPOSE ${PORT} ${HEALTHCHECK_PORT}

# Run your program under Tini
CMD ["node", "server.js", "config.json", "-i DATAROOT/*", "-i ASSETS/*"]
