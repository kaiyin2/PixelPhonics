// INPUT:   [None]
//
// OUTPUT:  keyboard_ready: 0 if the keyboard has no new key
//                          1 if the keyboard has a new key
//          keyboard_ASCII: the letter that was pressed by the user

keyboard_START                  cp keyboard_ready keyboard_CONST_ZERO                           // start by assuming no key is available

                                cp keyboard_turn 0x80000020                                     // copies ps2_turn to keyboard_turn (checks to see if it is keyboard's turn)
                                be keyboard_END keyboard_turn keyboard_CONST_ONE                // exit immediately if it's NOT our turn (when keyboard_turn = 1)

                                cp keyboard_pressed 0x80000021                                  // copies ps2_pressed to keyboard_pressed (checks to see if it iss a press/release)
                                be keyboard_is_release keyboard_pressed keyboard_CONST_ZERO     // exit immediately if keyboard is a release (when ps2_pressed = 0)


                                // Keyboard Pressed
keyboard_is_pressed             cp keyboard_ASCII 0x80000022                                    // copies the ASCII character from keyboard into keyboard_ASCII
                                cp keyboard_ready keyboard_CONST_ONE                            // the keyboard has a new key

                                cp 0x80000020 keyboard_CONST_ONE                                // tell keyboard hardware data has been read so it can reset
                                ret keyboard_RETURN


                                // Keyboard Not Pressed or Not Ready
keyboard_is_release             cp 0x80000020 keyboard_CONST_ONE                                // reset hardware turn even on release
                                be keyboard_END keyboard_CONST_ZERO keyboard_CONST_ZERO         // unconditionally branches to keyboard_END

keyboard_END                    cp keyboard_ready keyboard_CONST_ZERO                           // the keyboard has no new key
                                ret keyboard_RETURN


// variables
keyboard_turn                   0
keyboard_pressed                0

keyboard_ASCII                  0
keyboard_ready                  0


// constant variables
keyboard_CONST_ZERO             0
keyboard_CONST_ONE              1

// return address variable
keyboard_RETURN                 0   // variable to hold the return address