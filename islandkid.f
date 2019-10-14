include ramen/ramen.f
empty
s" islandkid.blk" include prg/gamester/gamester.f
get-order get-current common

displaywh 3 3 2/ resolution

: draw-status
    225 17 at  78 hunger @ 100 / * 3 lgreen rectf
    225 24 at  78 health @ 100 / * 3 orange rectf
;

: inrange  OVER - >R - R> U< ;

create multiply ALLEGRO_ADD , ALLEGRO_DEST_COLOR , ALLEGRO_ZERO , ALLEGRO_ADD , ALLEGRO_ONE , ALLEGRO_ONE  , 

$10 $30 $c0 createcolor nightblue

: 4f@  ( ALLEGRO_COLOR -- r g b a )
    a!> f@+ f>p f@+ f>p f@+ f>p f@+ f>p 
;

: allegro-color! ( r g b a ALLEGRO_COLOR -- )
    4af 4!
;

: allegro-color-lerp  ( src-allegro-color dest-allegro-color n -- )
    | n dest src |
    src color.r sf@ f>p dest color.r sf@ f>p n lerp 1af dest color.r !
    src color.g sf@ f>p dest color.g sf@ f>p n lerp 1af dest color.g !
    src color.b sf@ f>p dest color.b sf@ f>p n lerp 1af dest color.b !
    src color.a sf@ f>p dest color.a sf@ f>p n lerp 1af dest color.a !
;

: rgbalerp  ( src-color dest-color n -- )
    | n dest src |
    src color.r @ dest color.r @ n lerp dest color.r !
    src color.g @ dest color.g @ n lerp dest color.g !
    src color.b @ dest color.b @ n lerp dest color.b !
    src color.a @ dest color.a @ n lerp dest color.a !
;


create mycolor 1e sf, 1e sf, 1e sf, 1e sf, 

: amt
    night? if 0 ;then
    time @ 5 7 inrange if time @ 5 - 2 / ;then
    time @ 19 21 inrange if time @ 19 - 2 swap - 2 / ;then
    1 
;
    

: draw-night-filter
    white fore 4@ mycolor 4!
    ['] nightblue >body mycolor amt allegro-color-lerp
    multiply blend>
        0 0 at  mycolor 4f@ rgba  viewwh rectf
;

default-scene-options 2 :overlay
    draw-night-filter
;

default-scene-options 3 :overlay
    draw-ui-text
    draw-status
    [dev] [if] time @ 1i (.) s[ s" :" +s time @ 1 mod 60 * 1i #2 (.0) +s ]s rtype [then]
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


( --== Modes ==-- )


mode: game   ( -- )
    quit
    playfield switchto
    \ a( boksil ) subject >!
    tutorial1-read @ not if  tutorial1  tutorial1-read on  then
    step>
        <escape> pressed if bye then
\        <r> pressed ctrl? and if new-game then
        time @ #2 + 24 mod time !
;

create title-options 0 , 0 , 0 , 0 ,
mode: title  ( -- )
    scene( title ) aux load-scene
    title-options to scene-options
    step>
        <enter> pressed if game then
        <escape> pressed if bye then
;

: new-game
    100 health !
    2 hunger !
    17 time !
    reset-map
    scene( island ) playfield load-scene
    scene( test ) warp
    tilebox playfield layer2 >tilemap >!
    tutorial1-read off
    init game
;

:make warm
    title
;


\ Don't move this!  Should go at the bottom.
set-current set-order
resume-mode