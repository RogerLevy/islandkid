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

: health--  now 1 and if  #-1 +health  then ;

: update-status
    -0.001 +hunger
    \ night? if  health-  then
    hunger @ 0 <= if  health--  then
;



dialog: easter-egg
            \ --------------------------------
    textline:
    textline: Please don't feed the dog sand.
    textline:
;dialog


: rem  ( adr - ) 1 swap ! ;

: interact-tile ( adr - )
    20 interact-cooldown !
    a!>
    @a case
        9 of easter-egg exit endof
        17 of a@ hunger @ 90 < if rem 50 +hunger then exit endof
    endcase
    0 interact-cooldown !
;

: ?map-interact ( relx rely - )
    x 2@ 2+ 16 16 2/ map tile interact-tile ;

state: state1 boksil
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

action: physics boksil  standard-physics ;
action: start   boksil  0 ?animate  state1  me subject >! ;
action: hit     boksil  ." HIT!" ;