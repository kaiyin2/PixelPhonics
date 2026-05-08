// a % b

mod_returnAddress 0
mod_a 0
mod_b 0

mod_result 0


mod             div mod_result mod_a mod_b
                mult mod_result mod_result mod_b 

                sub mod_result mod_a mod_result 

                ret mod_returnAddress





rand_returnAddress 0
rand_result 0


// true prng? no. good enough? yes.
rand            call getTime getTime_returnAddress
                cp mod_a getTime_time
                cp mod_b CONST_SIX
                call mod mod_returnAddress
                cp rand_result mod_result

                ret rand_returnAddress




