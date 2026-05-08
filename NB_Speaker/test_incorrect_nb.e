        cp      sound_active    num1      // start playback immediately
        cp      sound_index     num0

main_loop
        // if no sound is active, stop here
        be      end             sound_active num0

        // load current sample into speak_val
        cpfa    speak_val       samples  sound_index

        // try to send one sample
        call    speaker_send    speaker_ra

        // if sample was accepted, advance index
        be      advance         sp_sent   num1
        be      main_loop       0         0

advance
        add     sound_index     sound_index num1

        // if all samples sent, finish playback
        be      finish          sound_index length
        be      main_loop       0         0

finish
        cp      sound_active    num0
        be      main_loop       0         0

end     halt

// ---------------- VARIABLES ----------------

sound_active    0
sound_index     0
num0            0
num1            1

// ---------------- SAMPLE DATA ----------------

length          1881
samples
#include incorrect.e
#include speaker_driver.e
