include ramen/ramen.f
empty
s" islandkid.blk" include prg/gamester/gamester.f
get-order get-current

displaywh 3 3 2/ resolution

: draw-status
    225 17 at  78 hunger @ 100 / * 3 lgreen rectf
    225 24 at  78 health @ 100 / * 3 orange rectf
;

default-scene-options 3 :overlay
    draw-ui-text
    draw-status
;


dialog: tutorial1
            \ --------------------------------
    textline: Hey, welcome to Boksil demo.
    textline: This game saves automatically.
    textline: To reset the game, hit <ctrl-r>.

    textline: Find food and stay alive.
    textline: <z> = eat
    textline: To reset, hit <ctrl-r>.
;dialog


: new-game  ( don't call this in WARM! )
    100 health !
    0 hunger !
    scene( island ) playfield load
    tutorial1-read off
;

( --== Modes ==-- )

: mode>  postpone step> ; immediate

: game   ( -- )
    quit
    playfield switchto
    \ a( boksil ) subject >!
    tutorial1-read @ not if  tutorial1  tutorial1-read on  then
    mode>
        <escape> pressed if bye then
        <r> pressed ctrl? and if new-game then
;

create title-options 0 , 0 , 0 , 0 ,
: title  ( -- )
    scene( title ) aux load
    title-options to scene-options
    mode>
        <enter> pressed if game then
        <escape> pressed if bye then
;

:make warm
    title
;



( --== Testing ==-- )

\ mydialog

show-ui


\ Don't move this!  Should go at the bottom.
set-current set-order
