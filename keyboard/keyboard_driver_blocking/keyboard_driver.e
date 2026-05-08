// Check to see when it is the E100's turn to read the response parameters

                        // call keyboard_START from other modules for keyboard input
keyboard_START          cp 0x80000020 keyboard_CONST_ONE                                  // tells keyboard to get the next event

keyboard_wait           cp keyboard_V_turn 0x80000020                                     // copies ps2_turn to keyboard_V_turn
                        bne keyboard_wait keyboard_V_turn keyboard_CONST_ZERO             // loops back if not equal (1: keyboard turn, 0: E100 turn)

keyboard_check_press    cp keyboard_V_pressed 0x80000021                                  // copies ps2_pressed to keyboard_V_pressed
                        be keyboard_got_press keyboard_V_pressed keyboard_CONST_ONE       // if keyboard was pressed (1), jump down to keyboard_got_press to handle it
                        
                        // if it was a release (0)
                        be keyboard_START keyboard_CONST_ZERO keyboard_CONST_ZERO         // unconditionally loop back to keyboard_check_turn to wait for a real press

                        // if it was a press (1)
keyboard_got_press      cp keyboard_V_ascii 0x80000022                                    // copy the ASCII character into variable
                        ret keyboard_RETURN                                               // return execution to main function


// variables
keyboard_V_turn         0   // variable checking if it is E100's turn to read response parameters
keyboard_V_pressed      0   // variable checking if action was a press or release
keyboard_V_ascii        0   // variable holding the result of the keyboard press

// constant variables
keyboard_CONST_ZERO     0   
keyboard_CONST_ONE      1

// return address variable
keyboard_RETURN         0 // variable to hold the return address