

                    // call sdram_START from other modules for SDRAM operations
sdram_START         cp sdram_read_data sdram_CONST_ZERO                 // clears sdram_read_data

                    cp 0x80000032 sdram_address                         // copies address from global environment to address

                    be sdram_write sdram_operation sdram_CONST_ONE      // branches to sdram_write if operation is write, otherwise continue to sdram_read


                    // read operations
sdram_read          cp 0x80000031 sdram_CONST_ZERO                      // sets operation to READ (sdram_write = 0)
                    cp 0x80000030 sdram_CONST_ONE                       // gives turn to SDRAM

                    be sdram_wait sdram_CONST_ZERO sdram_CONST_ZERO     // unconditionally branches to sdram_wait to wait until SDRAM returns

sdram_read_cont     cp sdram_read_data 0x80000034                       // copies read data into sdram_read_data
                    be sdram_END sdram_CONST_ZERO sdram_CONST_ZERO      // unconditionally branches to sdram_END


                    // write operations
sdram_write         cp 0x80000031 sdram_CONST_ONE                       // sets operation to WRITE (sdram_write = 1)
                    cp 0x80000033 sdram_write_data                      // write data to SDRAM
                    cp 0x80000030 sdram_CONST_ONE                       // gives turn to SDRAM

                    be sdram_wait sdram_CONST_ZERO sdram_CONST_ZERO     // unconditionally branches to sdram_wait to wait until SDRAM returns

sdram_write_cont    be sdram_END sdram_CONST_ZERO sdram_CONST_ZERO                // unconditionally branches to sdram_END



                    // waits for SDRAM to finish turn and give control back to E100
sdram_wait          be sdram_wait 0x80000030 sdram_CONST_ONE               // continuously loops if SDRAM is not finished yet

                    be sdram_read_cont sdram_operation sdram_CONST_ZERO    // returns to sdram_read_cont if operation is read
                    be sdram_write_cont sdram_operation sdram_CONST_ONE    // returns to sdram_write_cont if operation is write
                    

sdram_END           ret sdram_RETURN

// variables passed as parameters
sdram_address       0   // sets address to perform operation
sdram_operation     0   // read or write operation (READ = 0, WRITE = 1)
sdram_write_data    0   // data to write
sdram_read_data     0   // returns read data. DO NOT WRITE HERE.


// constant variables
sdram_CONST_ZERO    0
sdram_CONST_ONE     1
sdram_RETURN        0

// sdram_write: 0 to READ, 1 to WRITE
// sdram_address: exact SDRAM address to access
// sdram_data_write: data to write to SDRAM
// sdram_data_read: returned data after read operation