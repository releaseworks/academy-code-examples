# Set the base image to be the latest Node.js
FROM node:10.9.0

# Copy our application into the image
COPY . .

# Install dependencies using NPM
RUN npm install

# Document the port our app will be listening on
EXPOSE 8000

# Tell Docker what command to run when starting container
CMD npm start
