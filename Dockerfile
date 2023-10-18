# Build stage: Install dependencies and build the Svelte app
FROM node:19.8.1 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available) into the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application into the container
COPY . .

# Build the Svelte app
RUN npm run build

# Production stage: Serve the Svelte app using a lightweight node server (like serve)
FROM node:19.8.1

# Install 'serve' to run our application
RUN npm install -g serve

# Set the working directory
WORKDIR /app

# Copy the build output from the previous stage into this container
COPY --from=build /app/public /app

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["serve", "-s", ".", "-l", "5000"]
