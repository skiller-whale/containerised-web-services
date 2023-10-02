# --platform is needed to make the image runnable on Fargate when built on Apple M1
FROM --platform=linux/amd64 node:18.13-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 80

CMD [ "node", "server.js" ]
