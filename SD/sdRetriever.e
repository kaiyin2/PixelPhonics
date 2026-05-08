//        [1 word, integer use] [32 words, char use]           [384 * 216 words, color (int) use]
//        wordStringLength      wordStringCharacterArray       imageData
    
//        starts address 0, repeats every 1 + 32 + 384 * 216 words 
//        (82,977 words long, meaning last word is on 82976)
//        (331,908 bytes) = 332 KB

// prefix sdr for "sd retrieve"
// blocking cuz logic isn't allowed to run till this is done.

// pure copy to sdram

NUM_WORDS 12
WORD_STR_BUFFER_LENGTH 32
UNIT_SIZE 82977

TOTAL_SIZE 0

loadSDToRam_returnAddress 0
sdr_i 0

loadSDToRam     mult TOTAL_SIZE NUM_WORDS UNIT_SIZE

                cp sd_operation zero
                cp sdram_operation one

//////
sdr_for         be sdr_end sdr_i TOTAL_SIZE

                cp sd_address sdr_i
                call sd_START sd_RETURN

                cp sdram_address sdr_i
                cp sdram_write_data sd_read_data
                call sdram_START sdram_RETURN

                add sdr_i sdr_i one
                be sdr_for 0 0
/// endfor

sdr_end         ret loadSDToRam_returnAddress
