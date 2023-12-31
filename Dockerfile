# Build stage: Install dependencies and build the Svelte app
FROM node:18.18.2 AS build

# Set the working directory
WORKDIR /app

# Install debugging tools
RUN apt update && apt install -y curl nano

# Copy package.json and package-lock.json (if available) into the container
COPY package*.json ./

# Install project dependencies with verbose logging
RUN npm install --loglevel verbose

# Copy the rest of the application into the container
COPY . .

# Build the Svelte app
RUN npm run build

# Production stage: Serve the Svelte app using a lightweight node server (like serve)
FROM node:18.18.2

# Set the working directory
WORKDIR /app

# Install 'serve' locally instead of globally
COPY package*.json ./
RUN npm install serve --loglevel verbose

# Copy the build output from the previous stage into this container
COPY --from=build /app/public /app

# Expose the port the app runs on
EXPOSE 5000
# Command to run the application using local serve
CMD ["./node_modules/.bin/serve", "-s", ".", "-l", "5000"]
