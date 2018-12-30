const http = require("http");
const fs = require("fs");
const path = require("path");

const port = 5010;

http
  .createServer(function(request, response) {
    console.log("request ", request.url);

    const pod = process.env.HOSTNAME;
    const content = {
      fooBar: "nodejs",
      timeStamp: new Date(),
      pod
    };

    response.writeHead(200, {
      "Content-Type": "application/json; charset=utf-8"
    });
    response.end(JSON.stringify(content), "utf-8");
  })
  .listen(port);

console.log(`Server running at http://127.0.0.1:${port}/`);
