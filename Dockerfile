#The following is an example of a multi-step dockerfile

#This is the build phase
#FROM node:alpine
#Always specify the working directory
#WORKDIR '/app'
#Copy package.son to the container
#COPY package.json .
#Install all of the dependencies
#RUN npm install
#copy over everything else
#COPY . .

#RUN npm run build
FROM node:alpine
 
USER node

RUN mkdir -p /home/node/app

WORKDIR /home/node/app
 
COPY --chown=node:node ./package.json ./

RUN npm install
 
COPY --chown=node:node ./ ./

RUN npm run build


#This is the run phase
FROM nginx
#Running this within a docker container means nothing.
#It's only when AWS SERVICE(Elastic Bean Stalk) reads this expose command that something happens
#BeanStalk will now automatically map to port 8080
EXPOSE 80
#--from=-0 means copy from the first step
#the folder destination to pull from is then specified
#copy over to the nginx file that ctually serves up
COPY --from=0 home/node/app/build /usr/share/nginx/html