

test_START              call VI_START VI_RETURN

test_END                halt


VI_correct_word         'D'
                        'O'
                        'G'
                        'G'
                        'Y'

VI_entered_word         'D'
                        'O'
                        'G'
                        'G'
                        'Z'

VI_word_length          5

VI_failed_word          69696969

#include ../../keyboard/keyboard_driver.e
#include ../../validate_input.e