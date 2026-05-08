// INPUT:   VI_correct_word: holds the correct word to check against    [must declare prior to calling function]
//          VI_entered_word: holds the entered word from the user       [must declare prior to calling function]
//          VI_word_length: the length of the word                      [must declare prior to calling function]

// OUTPUT:  VI_failed_word: 0 if word is correct and 1 if word is incorrect



VI_START                        cp VI_current_index VI_CONST_ZERO                           // resets the index to 0

                                call toUpper toUpper_returnAddress
                                
VI_validate_letter              cpfa VI_correct_letter VI_correct_word VI_current_index     // copies the correct letter at index to VI_correct_letter
                                cpfa VI_entered_letter VI_entered_word VI_current_index     // copies the entered letter at index to VI_entered_letter

                                bne VI_set_failure VI_correct_letter VI_entered_letter      // branches to VI_set_failure should the letter not match up
                                
                                add VI_current_index VI_current_index VI_CONST_ONE          // increments the counter by 1
                                bne VI_validate_letter VI_word_length VI_current_index      // keeps looping until VI_current_index equals VI_word_length
 
                                be VI_set_success VI_CONST_ZERO VI_CONST_ZERO               // if loops through entire word, the user's input is correct



VI_set_failure                  cp VI_failed_word VI_CONST_ONE                              // updates the VI_failed_word to 1 (word incorrect)
                                be VI_END VI_CONST_ZERO VI_CONST_ZERO                       // unconditionally branches to the end of module

VI_set_success                  cp VI_failed_word VI_CONST_ZERO                             // updates the VI_failed_word to 0 (word correct)
                                be VI_END VI_CONST_ZERO VI_CONST_ZERO                       // unconditionally branches to the end of module

VI_END                          ret VI_RETURN



// variables                 
VI_correct_letter               0
VI_entered_letter               0   

VI_failed_word                  1

// indexing variable
VI_current_index                0

// constant variables
VI_CONST_ONE                    1
VI_CONST_ZERO                   0

// return address variable
VI_RETURN                       0   // variable to hold the return address




// > TO UPPER FUNCTION <==================================================================================<//
// assumes array is lower
// only goes up to the length of the current word since that is all that should be relevant
// just uses the current word array only

toUpper_returnAddress 0
toUpper_i 0
toUpper_temp 0
ASCII_CAPITAL_OFFSET 32

toUpper         cp toUpper_i CONST_ZERO

toUpper_lStart  be toUpperEnd toUpper_i VI_word_length

                cpfa toUpper_temp VI_entered_word toUpper_i
                sub toUpper_temp toUpper_temp ASCII_CAPITAL_OFFSET
                cpta toUpper_temp VI_entered_word toUpper_i

                add toUpper_i toUpper_i CONST_ONE
                be toUpper_lStart 0 0

toUpperEnd      ret toUpper_returnAddress




// CHECKS FOR VALID INPUT (ONLY LETTERS)
// keyboard_ASCII
VI_LETTERS_START    cp VI_LETTERS_RESULT CONST_ZERO                          // first invalidate the letter input
                    cp VI_LETTERS_CI CONST_ZERO                             // reset the counter to zero


VI_LETTERS_LOOP     be VI_LETTERS_INVALID VI_LETTERS_CI alphabet_length     // if we've looped through the entire alphabet and couldn't find a match, input wasn't valid

                    cpfa VI_LETTERS_CI_CHAR alphabet VI_LETTERS_CI

                    be VI_LETTERS_VALID VI_LETTERS_CI_CHAR keyboard_ASCII   // branch to VI_LETTERS_VALID if keyboard input is matched

                    add VI_LETTERS_CI VI_LETTERS_CI CONST_ONE               // increment by 1
                    be VI_LETTERS_LOOP CONST_ZERO CONST_ZERO                // unconditionally branches back to VI_LETTERS_LOOP


VI_LETTERS_VALID    cp VI_LETTERS_RESULT CONST_ONE                          // the letter was matched 
                    ret VI_LETTERS_RETURN

VI_LETTERS_INVALID  cp VI_LETTERS_RESULT CONST_ZERO                         // the letter could not be matched
                    ret VI_LETTERS_RETURN


VI_LETTERS_RETURN   0

VI_LETTERS_CI       0
VI_LETTERS_CI_CHAR  0

VI_LETTERS_RESULT   0
