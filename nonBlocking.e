// *this file didn't get used*


// > Non-Blocking Driver Calls <================================================================================< // 

// no params

// VARIABLES
vgaTurn 0

// RETURNS
nonBlock_returnAddress 0

// BODY
nonBlock        cpfa vgaTurn 0 VGA_TURN_ADDRESS 
                be vgaCall VGA_ZERO vgaTurn 

nonBlockEnd     ret nonBlock_returnAddress

// CALLS
vgaCall         ret writeRectDelay_returnAddress





// > End Non-Blocking Driver Calls <================================================================================< // 


// > Write Rect Delay <========================================================================================< //
writeRectDelay_returnAddress 0

writeRectDelay     be nonBlock 0 0
                
// > End Write Rect Delay <========================================================================================< //
