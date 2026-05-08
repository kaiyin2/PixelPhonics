

// loops continuously to see if keyboard has a new key
// if it doesn't, continue with test_SKIP_INPUT (continue with other tasks)
// otherwise, register the key input

START                   cp 0x80000020 keyboard_CONST_ONE                           // issue start command to device

test_START              call keyboard_START keyboard_RETURN                         // call the keyboard function

                        be test_SKIP_INPUT keyboard_ready keyboard_CONST_ZERO       // if keyboard isn't ready with a new letter, branch to test_SKIP_INPUT to perform other tasks



                        // if there is a keyboard input, copy it into the array and add one to index
handle_input            cpta keyboard_ASCII VI_entered_word current_index
                        add current_index current_index keyboard_CONST_ONE               

                        bne test_SKIP_INPUT current_index VI_word_length            // only check the word if they have typed all 10 letters



check_words             call VI_START VI_RETURN                                     // call validate_input to check input

                        be test_word_correct VI_failed_word keyboard_CONST_ZERO     // if correct, branch to test_word_correct

                        be test_word_incorrect VI_failed_word keyboard_CONST_ONE    // if incorrect, branch to test_word_incorrect



                        // continue with other tasks (updating screen, etc.)
test_SKIP_INPUT         be test_START keyboard_CONST_ZERO keyboard_CONST_ZERO      // do whatever else needs to be done           


test_word_correct       cp word_correct VI_word_length                              // if word is correct, set word_correct to word_length
                        halt

test_word_incorrect     cp word_correct keyboard_CONST_ZERO                         // if word is incorrect, set word_correct to 0
                        halt


word_correct            69696969
current_index           0


VI_correct_word         'w'
                        'o'
                        'l'
                        'v'
                        'e'
                        'r'
                        'i'
                        'n'
                        'e'
                        's'


VI_entered_word         420
                        420
                        420
                        420
                        420
                        420
                        420
                        420
                        420
                        420

VI_word_length          10


#include ../../validate_input.e
#include ../../keyboard/keyboard_driver.e