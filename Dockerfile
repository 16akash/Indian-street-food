# FROM node:18-alpine

# WORKDIR /app

# COPY package*.json ./

# RUN npm install

# COPY . .

# EXPOSE 2000

# CMD ["npm", "run", "dev", "--", "--host"]


# Stage 1: Build the React project
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy full project
COPY . .

# Build React app
RUN npm run build


# Stage 2: Run application using Tomcat
FROM tomcat:9.0-jdk17

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy React build files into ROOT
COPY --from=builder /app/dist /usr/local/tomcat/webapps/ROOT

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]