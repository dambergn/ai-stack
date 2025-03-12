# Use an official Node.js runtime as the base image (Alpine version is lightweight)
FROM node:18-alpine AS development

# Set working directory in container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first to leverage Docker cache layers
COPY package*.json ./

# Install dependencies in production mode (no devDependencies)
RUN npm ci --production

# Copy the rest of your application code into the container
COPY . .

# Set environment variable for production (optional but common practice)
ENV NODE_ENV=production

# Expose port 3000 to the outside world (adjust based on your app's configured port)
EXPOSE 3000

# Command to start the server. Replace 'server.js' with your entry file if different
CMD [ "node", "index.js" ]