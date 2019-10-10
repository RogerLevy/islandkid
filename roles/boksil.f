define-role boksil boksiling


volatilevars
    actorvar walkctr
    actorvar dir
    actorvar interact-cooldown
drop

: ?animate  ( n -- )
    dup anim# @ = if drop ;then
    dup dir !
    anim# !  1 32 / rate !
;

: update-status
    -0.001 +hunger
    hunger @ 0 <= if  #-1 +health  then
;



dialog: easter-egg
            \ --------------------------------
    textline:
    textline: Please don't feed the dog sand.
    textline:
;dialog


: interact-tile ( adr - )
    20 interact-cooldown !
    @ case
        9 = if easter-egg ;then
    endcase
    0 interact-cooldown !
;

: ?map-interact ( relx rely - )
    x 2@ 2+ 16 16 2/ map adr interact-tile ;

state: boksil state1
    update-status
    1 walkctr +!
    vx 2@ or if
        walkctr @ 8 < ?exit
    then
    
    0 0 vx 2!
    <down> kstate if   1 vy !  0 walkctr !  0 ?animate ;then
    <up> kstate if    -1 vy !  0 walkctr !  1 ?animate ;then
    <right> kstate if  1 vx !  0 walkctr !  2 ?animate ;then
    <left> kstate if  -1 vx !  0 walkctr !  3 ?animate ;then
    
    -1 interact-cooldown +!
    interact-cooldown @ 0 < if
        <z> pressed if
            dir @ case
                0 of 0 16 ?map-interact endof
                1 of 0 -1 ?map-interact endof
                2 of 16 0 ?map-interact endof
                3 of -1 0 ?map-interact endof
            endcase
        then
    then
;

action: boksil physics  standard-physics ;
action: boksil start  0 ?animate  state1  me subject >! ;
action: boksil hit  ." HIT!" ;