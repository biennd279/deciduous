# Stage 1: Build TypeScript files
FROM node:20 AS build

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source files
COPY . ./

# Compile TypeScript to generate HTML/JS files
RUN npm run build

# Stage 2: Combine Nginx for serving and Node.js for CLI
FROM nginx:stable-alpine AS production

# TODO: Install Node.js
#RUN apk add --no-cache node

# Set working directory
WORKDIR /app

# Copy built web application files to Nginx's html directory
COPY --from=build /app/*.html /app/*.js /app/*.png /usr/share/nginx/html/


# Copy CLI file
#COPY --from=build /app/cli-cjs.js /app/cli-cjs.js

# Copy package.json for CLI dependencies
#COPY package*.json ./
#RUN npm install --production

# Expose Nginx port
EXPOSE 80

# Default command: Nginx serves the web app
CMD ["nginx", "-g", "daemon off;"]
