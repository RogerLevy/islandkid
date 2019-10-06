include ramen/ramen.f
empty
s" islandkid.blk" include prg/gamester/gamester.f
include prg/islandkid/lib/ui.f
displaywh 3 3 2/ resolution

: draw-status
    225 17 at  78 hunger @ 100 / * 3 lgreen rectf
    225 24 at  78 health @ 100 / * 3 orange rectf
;

default-scene-options 3 :overlay
    draw-ui-text
    draw-status
;

\ get-order get-current
\ set-current set-order

dialog: mydialog
    textline: Hi this is a test
    textline: of the emergency barkcast system.
    textline: (kill me)
    
: new-game  ( don't call this in WARM! )
    100 health !
    50 hunger !
    \ load world 0
;

:make warm
    \ playfield switchto
    0 world switchto
    hide-dialog
;

( --== Testing ==-- )

\ mydialog

show-ui