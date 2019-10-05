define-role boksil boksiling

state: boksil state1
    0 0 vx 2!
    <left> kstate if  -1 vx !  ;then
    <right> kstate if  1 vx !  ;then
    <up> kstate if    -1 vy !  ;then
    <down> kstate if   1 vy !  ;then
;
action: boksil physics  standard-physics ;
action: boksil start  0 1 32 / animate  state1 ;
action: boksil hit  ." HIT!" ;