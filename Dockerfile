# Stage 1: Builder stage using Node.js image
FROM node:14 as builder

# Set a working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json /app/

# Install dependencies defined in package.json
RUN npm install

# Copy the rest of the application files to the working directory
COPY ./ /app/

# Build the application
RUN npm run build

# Serve stage
# Stage 2: Serve stage using Nginx image
FROM nginx:alpine as production-stage

# Copy the build output from the builder stage to the nginx default HTML directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx with the "daemon off;" option to run in the foreground
CMD ["nginx", "-g", "daemon off;"]
