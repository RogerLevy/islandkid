include ramen/ramen.f
empty
s" islandkid.blk" include prg/gamester/gamester.f
get-order get-current


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


dialog: mydialog
    textline: Hi this is a test
    textline: of the emergency barkcast system.
    textline: (kill me)


( --== Modes ==-- )

: mode>  step> ;

: game   ( -- )
    scene( island ) load-scene
    a( boksil ) subject >!
    mode>
        <escape> pressed if bye then
;

create title-options 0 , 0 , 0 , 0 ,
: title  ( -- )
    scene( title ) load-scene
    title-options to scene-options
    mode>
        <enter> pressed if game then
        <escape> pressed if bye then
;

: new-game  ( don't call this in WARM! )
    100 health !
    50 hunger !
    \ load world 0
;

:make warm
    title
;



( --== Testing ==-- )

\ mydialog

show-ui


\ Don't move this!  Should go at the bottom.
set-current set-order
