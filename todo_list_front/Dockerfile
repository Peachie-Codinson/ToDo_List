# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory inside the container
WORKDIR /todo_list_front

# Copy package.json and package-lock.json
COPY package.json ./
COPY package-lock.json ./

# Install dependencies
RUN npm install --verbose --ignore-scripts

# Copy only the necessary application files
COPY src/ ./src/
COPY public/ ./public/

# Expose port 3000 (adjust according to your application's needs)
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
