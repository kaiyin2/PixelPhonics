
check_length_loop   be validate_input password_length current_index     // branch to validate_input if input length equals password length

                    call keyboard_START keyboard_RETURN                 // calls the keyboard function

                    cp entered_letter keyboard_V_ascii                  // copies the user entered letter to entered_letter
                    cpfa expected_letter password current_index         // copies the correct letter to expected_letter at index

                    add current_index current_index one_val             // increment the current index by 1

validate_letter     bne set_failure expected_letter entered_letter      // branches to set_failure should the current letter not be correct
                    be check_length_loop one_val one_val                // loops back to the top should the current letter be correct

set_failure         cp password_failed one_val                          // sets the password_failed variable to 1
                    be check_length_loop one_val one_val                // branch back to the loop



validate_input      be red_LED password_failed one_val                  // if password_failed is equal to 1, branch to red_LED. Otherwise branch to green_LED
green_LED           cp 0x80000002 one_val
                    be main_end one_val one_val
red_LED             cp 0x80000001 one_val

main_end            halt



password            'w'
                    'o'
                    'l'
                    'v'
                    'e'
                    'r'
                    'i'
                    'n'
                    'e'
                    's'
password_length     10
current_index       0

expected_letter     0
entered_letter      0
one_val             1

password_failed     0


#include keyboard_driver.e