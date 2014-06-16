server.log("Agent Started");

const FEED_ID = "REDACTED";
const API_KEY = "REDACTED";

function send_temp_xively(temp) {
    server.log("Sending Temp to Xively");
    //convert data to csv
    local feedCSV="tempSensor,"+temp.tostring();
    //send to xively
    local xively_url = "https://api.xively.com/v2/feeds/" + FEED_ID + ".csv";       //setup url for csv
    local req = http.put(xively_url, {"X-ApiKey":API_KEY, "Content-Type":"text/csv", "User-Agent":"Xively-Imp-Lib/1.0"}, feedCSV);     //add headers
    local res = req.sendsync();         //send request
    if(res.statuscode != 200) {
        server.log("error sending message: "+res.body);
    }
}

device.on("temp", send_temp_xively);
server.log("device sent temperature");
