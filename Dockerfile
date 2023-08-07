FROM node:18-slim

EXPOSE 8080 9000 9229
WORKDIR /app

# Install base dependencies
ADD yarn.lock package.json /app
RUN yarn install --frozen-lockfile

# Install website and its dependencies
ADD ./website/package.json /app/website/
RUN yarn install --frozen-lockfile

# Patch the website to listen on all interfaces
RUN sed -i 's/"dev": "vite"/"dev": "vite --host 0.0.0.0"/g' /app/website/package.json

# Install validator and its dependencies
ADD ./gbfs-validator/package.json /app/gbfs-validator/
RUN yarn install --frozen-lockfile

# Add the rest of the files
ADD . /app


CMD ["yarn", "run", "dev"]