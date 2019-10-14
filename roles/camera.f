depend ramen/lib/std/kb.f

define-role camera cameraing

: !scroll
    x 2@ stage layer1 limit-scroll x 2!
    x 2@ stage scroll 2!
;

state: state1 camera 
    9999 zorder !
    subject @ if 
        subject @> { x 2@ viewwh 2 2 2/ 2- 8 8 2+ }  x 2! 
    then
    !scroll
;

action: stop  camera  woke off ;
action: start camera  state1   hid on ;
    