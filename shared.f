( --== application-specific common stuff ==-- )

depend prg/gamester/lib/collisions.f
depend ramen/lib/std/rangetools.f
depend ramen/lib/std/kb.f
include prg/islandkid/lib/ui.f

cell global camera
cell global subject
cell global hunger
cell global health
cell global tutorial1-read
cell global time
cell global player1
cell global warp-src
cell global warp-dest

16 bank tilemap0   \ 16
32 bank world0     \ 16
48 bank ui-tilemap
49 bank aux        \ slew for title screen and menus etc
50 bank tilebox    \ destructible tilemap

: tilemap  /bank * tilemap0 + ;
: world    /bank * world0 + ;

: reset-map    0 tilemap tilebox /bank move ;

\ : coldata@  cells >pic @> >coldata + @ block ;
\ : coldata  1 coldata@ ;

create coldata
0 c, 0 c, #-1 c, #-1 c, #-1 c, #-1 c, 0 c, #-1 c,
0 c, #-1 c, #-1 c, #-1 c, #-1 c, 0 c, #-1 c, #-1 c, 
#-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c,
#-1 c, #-1 c, #-1 c, #-1 c, #-1 c, 0 c, #-1 c, #-1 c,

: map  stage layer2 >tilemap @> ;
: standard-physics  map coldata collide-tilemap ;


( --== CLI extensions ==-- )

: init-world  ( n -- )
    dup world over tilemap | t w n |
    w init-scene
    t w layer2 >tilemap >!
    w layer2 >tileset @ 0 = if
        pic( default ) w layer2 >tileset >!
    then
    w switchto
;

: save-template  ( -- <name> )
    >in @ template (?$) ?dup 0 = if
        >in !
        template one dup named
    else
        nip
    then ( template )
    me over copy
    { woke off }
;

: new-actor ( -- actor )
    stage one as 
    16 16 sbw 2!
    16 16 ibw 2!
    1 1 sx 2!
    stage scroll 2@ viewwh 2 2 2/ 2+ x 2!
    me
;

: (script)  s" .f" strjoin ;

: *script    w/o create-file throw >r  r> close-file throw ;

: ?role  ( -- <name> role )
    >in @ >r
    role (?$) ?dup 0 = if
        r@ >in !
        <name> (script) file-exists not if
            project count s[ s" roles/" +s <name> (script) +s ]s *script
        then
        s" add-role " s[ <name> +s bl +c <name> (script) +s ]s evaluate
        this ( role )
        skip
    then
    r> drop
;

: new-template  ( -- <name> )
    >in @ >r
    new-actor named
    r@ >in ! ?role >role >!
    r@ >in ! save-template
    r> drop
;

: outlier?  x 2@ stage main-bounds 4@ aabb within? not ;

: cull-outliers  ( -- )
    stage each> { outlier? if  me delete  then } ;

?action start ( -- )

: jumpcut  ( scene -- )
    stage copy                    \ overwrite the stage's header with the scene's.
    stage each>
        { outlier? important @ not and disabled ! }
;

: warp  ( scene -- )
    jumpcut
    
    \ if player is overlapping an event object with a warp destination ref, use that to reposition the player
    player1 ?@> ?dup if {
        warp-dest ?@> ?dup if
            { x 2@ } x 2!  \ TODO: add position relative to warp-src
            warp-dest off
        then
    } then
;

: load-scene  ( scene slew -- )  \ switches to given slew and loads the given scene into it
    switchto
    dup >slew @ ?dup if block then stage copy-bank
    stage copy                    \ overwrite the stage's header with the scene's.
    cull-outliers
;

: init  ['] start stage announce ;

: load  scene ($) playfield load-scene  init ;  \ CLI

: day?  time @ 5 21 inrange ;
: night?    day? not ;

( --== Health/hunger stuff ==-- )

: +health  health @ + 0 100 clamp health ! ;
: +hunger  hunger @ + 0 100 clamp hunger ! ;

: new-day  ( -- )
    hunger @ 50 - 10 / +health
;
