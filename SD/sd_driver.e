

                // call sd_START from other modules for SD card operations
sd_START        cp sd_read_data sd_CONST_ZERO               // clears sd_read_data

                cp 0x80000082 sd_address                    // copies address from global environment to address
                
                be sd_write sd_operation sd_CONST_ONE       // branches to sd_write if operation is write, otherwise continue to sd_read


                // read operations               
sd_read         cp 0x80000081 sd_CONST_ZERO                 // sets operation to READ (sd_write = 0)
                cp 0x80000080 sd_CONST_ONE                  // gives turn to SD card

                be sd_wait sd_CONST_ZERO sd_CONST_ZERO      // unconditionally branches to sd_wait to wait until SD returns

sd_read_cont    cp sd_read_data 0x80000084                  // copies read data into sd_read_data
                be sd_END sd_CONST_ZERO sd_CONST_ZERO       // unconditionally branches to sd_END


                // write operations
sd_write        cp 0x80000081 sd_CONST_ONE                  // sets operation to WRITE (sd_write = 1)
                cp 0x80000083 sd_write_data                 // write data to SD card
                cp 0x80000080 sd_CONST_ONE                  // gives turn to SD card

                be sd_wait sd_CONST_ZERO sd_CONST_ZERO      // unconditionally branches to sd_wait to wait until SD returns

sd_write_cont   be sd_END sd_CONST_ZERO sd_CONST_ZERO       // unconditionally branches to sd_END



                // waits for SD card to finish turn and give control back to E100
sd_wait         be sd_wait 0x80000080 sd_CONST_ONE          // continuously loops if SD is not finished yet

                be sd_read_cont sd_operation sd_CONST_ZERO  // returns to sd_read_cont if operation is read
                be sd_write_cont sd_operation sd_CONST_ONE  // returns to sd_write_cont if operation is write


sd_END          ret sd_RETURN


// variables passed as parameters
sd_address          0   // sets address to perform operation
sd_operation        0   // read or write operation (READ = 0, WRITE = 1)
sd_write_data       0   // data to write
sd_read_data        0   // returns read data. DO NOT WRITE HERE.


// constant variables
sd_CONST_ZERO       0
sd_CONST_ONE        1
sd_RETURN           0

// sd_write: 0 to READ, 1 to WRITE
// sd_address: exact SD card address to access
// sd_data_write: data to write to SD card
// sd_data_read: returned data after read operation