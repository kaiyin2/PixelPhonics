
main        cp sdram_address sdram_CONST_ONE

            cp sdram_operation sdram_CONST_ONE
            cp sdram_write_data funny_number
            
            call sdram_START sdram_RETURN


            cp sdram_operation sdram_CONST_ZERO

            call sdram_START sdram_RETURN 

            cp test_variable sdram_read_data

            halt

            

test_variable   696969
funny_number    420420



#include sdram_driver.e