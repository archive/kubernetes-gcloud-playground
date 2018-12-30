FROM node:11.6.0 
#-alpine

WORKDIR /app

# Copy and install dependencies (as distinct layers)
COPY test-svc/package.json ./
COPY test-svc/yarn.lock ./
RUN yarn install
# RUN yarn install --production

# Bundle app source
COPY test-svc/. .

CMD [ "yarn", "start" ]