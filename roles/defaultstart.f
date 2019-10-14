define-role defaultstart defaultstarting

action: start defaultstart
    player1 ?@> ?dup if x 2@ rot { x 2! } then
    hid on
;

