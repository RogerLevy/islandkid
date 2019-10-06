include ramen/ramen.f
empty
s" islandkid.blk" include prg/gamester/gamester.f
include prg/islandkid/lib/ui.f
displaywh 3 3 2/ resolution

: draw-status
    225 17 at  78 hunger @ 100 / * 3 green rectf
    225 24 at  78 health @ 100 / * 3 red rectf
;

3 :overlay
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
;

:make warm
    \ 0 world switchto  \ <--- this isn't necessary. 
    hide-ui
;

( --== Testing ==-- )

\ mydialog

show-ui