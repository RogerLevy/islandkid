( --== application-specific common stuff ==-- )

depend prg/gamester/lib/collisions.f
depend ramen/lib/std/rangetools.f
depend ramen/lib/std/kb.f
include prg/islandkid/lib/ui.f

globals
    cell global camera
    cell global subject
    cell global hunger
    cell global health
    cell global tutorial1-read
    cell global time
    #16 global mode
drop

16 bank tilemap0   \ 16
32 bank world0     \ 16
48 bank ui-tilemap
49 bank aux        \ slew for title screen and menus etc
50 bank tilebox    \ destructible tilemap

: tilemap  /bank * tilemap0 + ;
: world    /bank * world0 + ;


\ : coldata@  cells >pic @> >coldata + @ block ;
\ : coldata  1 coldata@ ;

create coldata
0 c, 0 c, #-1 c, #-1 c, #-1 c, #-1 c, 0 c, #-1 c,
0 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, 
#-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c,
#-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c, #-1 c,

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

: cull-outliers  ( scene -- )
    | s | s each> {
        x 2@ s main-bounds 4@ aabb within? not if  me delete  then
    } ;

?action start ( -- )

: jumpcut  ( scene slew -- )
    switchto
    stage copy                    \ overwrite the stage's header with the scene's.
    
    \ TODO: disable actors outside the scene. (WOKE OFF)
    \ TODO: teleport Boksil...
    
;

: load  ( scene slew -- )  \ switches to given slew and loads the given scene into it
    switchto
    dup >slew @ ?dup if block then stage copy-bank
    stage copy                    \ overwrite the stage's header with the scene's.
    stage cull-outliers
    ['] start stage announce
; 

: create-mode   create does> dup body> >name ccount mode cplace  @ execute ;

: mode:  ( -- <name> <code> ; )
    get-order get-current common 
    create-mode here 0 , :noname swap !
    set-current set-order
;

: resume-mode
    tool @ ?exit
    mode c@ -exit
    mode find if execute else drop then
;



: day?  time @ 5 21 inrange ;
: night?    day? not ;


( --== Health/hunger stuff ==-- )

: +health  health @ + 0 100 clamp health ! ;
: +hunger  hunger @ + 0 100 clamp hunger ! ;

: new-day  ( -- )
    hunger @ 50 - 10 / +health
;
