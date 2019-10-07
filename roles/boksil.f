define-role boksil boksiling


volatilevars
    actorvar walkctr
drop

: ?animate  ( n -- )
    dup anim# @ = if drop ;then
    anim# !  1 32 / rate !
;

: update-status
    -0.001 +hunger
    hunger @ 0 <= if
        -0.0005 +health
    then
;

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
;

action: boksil physics  standard-physics ;
action: boksil start  0 ?animate  state1  me subject >! ;
action: boksil hit  ." HIT!" ;