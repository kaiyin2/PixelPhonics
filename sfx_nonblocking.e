// nonblocking for sfx

// variables and stuf
sfx_active      0
sfx_index       0
sfx_length      0
sfx_base        0

update_sfx_ra   0
start_corsfx_ra 0
start_incsfx_ra 0

// body
update_sfx
                // if no sound playing it return
                be      sfx_done   sfx_active speak_0

                cpfa    speak_val  sfx_base sfx_index

                call    speaker_send speaker_ra

                be      sfx_done   sp_sent speak_0

                // inedexing
                add     sfx_index  sfx_index speak_1

                // check if finished
                be      sfx_finish sfx_index sfx_length

sfx_done
                ret     update_sfx_ra

sfx_finish
                cp      sfx_active speak_0
                ret     update_sfx_ra

start_corsfx
                cp      sfx_base    corsfx_samples
                cp      sfx_length  corsfx_length
                cp      sfx_index   speak_0
                cp      sfx_active  speak_1
                ret     start_corsfx_ra

start_incsfx
                cp      sfx_base    incsfx_samples
                cp      sfx_length  incsfx_length
                cp      sfx_index   speak_0
                cp      sfx_active  speak_1
                ret     start_incsfx_ra


// correct buzzer sfx sample
corsfx_length   1615
corsfx_samples
#include NB_Speaker/correct.e

// incorrect buzzer sfx sample
incsfx_length   1881
incsfx_samples
#include NB_Speaker/incorrect.e

#include NB_Speaker/speaker_driver.e