FROM node:19.3-bullseye-slim

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

HEALTHCHECK --timeout=2s --interval=3s --retries=3 CMD curl -f http://localhost:3000 || exit 1

EXPOSE 5656 3000

# Run your program under Tini
CMD ["node", "server.js", "config.json", "-i DATAROOT/*", "-i ASSETS/*"]
