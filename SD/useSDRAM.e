// //        [1 word, integer use] [32 words, char use]           [384 * 216 words, color (int) use]
//        wordStringLength      wordStringCharacterArray       imageData
    
//        starts address 0, repeats every 1 + 32 + 384 * 216 words 
//        (82,977 words long, meaning last word is on 82976)
//        (331,908 bytes) = 332 KB



//NUM_WORDS 3
//WORD_STR_BUFFER_LENGTH 32
//UNIT_SIZE 82977

// changed in sdRetrieve
//TOTAL_SIZE 0



// USE SD RAM FUNCTION =================================================================
// written at 3am, plz dont judge my inconsistencies :|

// PARAMETERS
useSDRAM_imageX 0
useSDRAM_imageY 0
useSDRAM_index 0 // which unit to use

// RETURNS
useSDRAM_returnAddress 0

// VARIABLES
use_endIndex 0
use_endIndexL 0
use_i 0 // 0 based for array indexing for picture
use_iL 0 // 0 based for array indexing for letters
use_j 0

useSDRAM        mult useSDRAM_index useSDRAM_index UNIT_SIZE
                cp use_i zero
                cp use_iL zero

                add use_endIndex useSDRAM_index UNIT_SIZE
                add use_endIndexL useSDRAM_index WORD_STR_BUFFER_LENGTH
            
                cp sdram_operation zero
                cp sdram_address useSDRAM_index
                call sdram_START sdram_RETURN

                cp VI_word_length sdram_read_data

                add useSDRAM_index useSDRAM_index CONST_ONE

useForL         be useForLEnd useSDRAM_index use_endIndexL // L = letters

                cp sdram_address useSDRAM_index
                call sdram_START sdram_RETURN
                cpta sdram_read_data VI_correct_word use_iL

                add useSDRAM_index useSDRAM_index one
                add use_iL use_iL one
                be useForL 0 0
        /////////////// index keeps its value

useForLEnd      cp use_i zero
                cp use_j zero

useForI         be useEnd use_i IMAGE_HEIGHT // image, i loop
                    cp use_j zero

useForJ             be useForJEnd use_j IMAGE_WIDTH
                    cp sdram_address useSDRAM_index
                    
                    call sdram_START sdram_RETURN
                    cp writeRect_color sdram_read_data

                    add writeRect_xStart useSDRAM_imageX use_j
                    add writeRect_yStart useSDRAM_imageY use_i
                    add writeRect_xEnd writeRect_xStart one
                    add writeRect_yEnd writeRect_yStart one

                    call writeRect writeRect_returnAddress

                    add useSDRAM_index useSDRAM_index one
                    add use_j use_j one
                    be useForJ 0 0
                
useForJEnd      add use_i use_i one
                be useForI 0 0

useEnd          ret useSDRAM_returnAddress
