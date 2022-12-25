FROM node:19.3-bullseye-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

#RUN npm install
RUN npm ci --only=production

# Bundle app source
COPY . .

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1

EXPOSE 5656
# Run your program under Tini
CMD ["node", "server.js", "config.json", "-i DATAROOT/*", "-i ASSETS/*"]
