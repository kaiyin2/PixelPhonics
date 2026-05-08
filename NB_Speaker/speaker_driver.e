speaker_send    cp      speak_turn_val  0x80000040
                be      speaker_ready   speak_turn_val  speak_0

speaker_busy    cp      sp_sent         speak_0
                ret     speaker_ra

speaker_ready   cp      0x80000041      speak_val
                cp      0x80000040      speak_1
                cp      sp_sent         speak_1
                ret     speaker_ra

speak_turn_val  0
speak_val       0
sp_sent         0
speak_0         0
speak_1         1
speaker_ra      0
