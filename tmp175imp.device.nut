//Device code

temp <-0;
ptr <- "\x00";
cfg <- 0;
//Address pins are left floating
//tmp175Address <- 0x37;
addr <- (0x37 << 1);

//configure i2c bus
i2c <- hardware.i2c12;
i2c.configure(CLOCK_SPEED_10_KHZ);
//set pointer register to configure
ptr <- "\x01";
//conf register actions
//set resolution to 0.125 Celcius (115 ms)
//and enter shutdown (SD) mode
cfg = 0x41;    // 0b'01000001
i2c.write(addr, ptr+format("%c",cfg));
    
//TMP175 is shut down

function tmpI2C(var) {
    // One Shot Measurement
    cfg = cfg | 0x80;
    i2c.write(addr,ptr+format("%c",cfg));
    imp.sleep(0.15);    // conversion wait
    // Read temperature
    ptr <- "\x00";
    //i2c.write(addr,ptr);
    local data = i2c.read(addr,ptr,2);
    
    if (data!=null) {
        temp = data[0] + 0.0625*(data[1]>>>4);
        agent.send("temp", temp);
    }
    else {
        server.log("Read Error");
    }
    readCfg();
}

function readCfg() {
    server.log(i2c.read(addr,"\x01",1));
}

/*imp.onidle(function() {
    tmpI2C();
    server.sleepfor(20);    //sleep for 20 sec
});*/

//tmpI2C();
agent.on("temp", tmpI2C);
