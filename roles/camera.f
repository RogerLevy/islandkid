depend ramen/lib/std/kb.f

define-role camera cameraing

: !scroll
    x 2@ stage layer1 limit-scroll x 2!
    x 2@ stage scroll 2!
;

state: camera state1
    subject @ if 
        subject @> { x 2@ viewwh 2 2 2/ 2- 8 8 2+ }  x 2! 
    then
    !scroll
;

action: camera stop   woke off ;
action: camera start  state1 ;
