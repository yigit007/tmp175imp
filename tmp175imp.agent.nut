server.log("Agent Started");

function httpHandler(request, response) {
    if ("temp" in request.query) {
        device.send("temp",0);
        device.on("temp", function(temp) {
            response.send(200,"Temperature at the office: " + temp + " °C");
        });
    }
}

http.onrequest(httpHandler);
