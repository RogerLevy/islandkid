include ramen/ramen.f
empty
s" islandkid.blk" include prg/gamester/gamester.f

include prg/islandkid/lib/ui.f

displaywh 3 3 2/ resolution

3 :overlay
    draw-ui-text
;

\ get-order get-current
\ set-current set-order

dialog: mydialog
    textline: Hi this is a test
    textline: of the emergency barkcast system.
    textline: (kill me)
    
mydialog