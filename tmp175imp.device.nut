//Device code
//mode <- -1;

//Address pins are left floating
//tmp175Address <- 0x37;
addr <- (0x37 << 1);

function tmpI2C() {
    //configure i2c bus
    i2c <- hardware.i2c12;
    i2c.configure(CLOCK_SPEED_10_KHZ);
    
    /*//set pointer register to read temp
    local ptr="\x00";
    //write temp read on i2c
    i2c.write(addr,ptr);*/
    
    //POR value of ptr register is already 00
    //thus, temp can be read instantly.
    //read temp
    local test1 = i2c.read(addr, "",2);
    if (test1=="\x0000") {
        test1 = i2c.read(addr, "", 2);
    }
    
    if (test1==null) {
        server.log("Read Error");
    }
    else {
        local temp = test1[0] + 0.0625*(test1[1]>>>4);
        agent.send("temp", temp);
    }
}

//Sleep 30 mins and wake up routine
imp.onidle(function() {
    tmpI2C();
    //agent.on("temp", tmpI2C);
    server.sleepfor(30*60);
});
