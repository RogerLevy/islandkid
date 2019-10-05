( --== application-specific common stuff ==-- )

include prg/gamester/lib/collisions.f


globals
    cell global camera
drop

16 bank tilemap0  \ 16
32 bank world0    \ 16

: tilemap  /bank * tilemap0 + ;
: world    /bank * world0 + ;

\ : coldata@  cells >pic @> >coldata + @ block ;
\ : coldata  1 coldata@ ;
create coldata 0 c, 0 c, #-1 c, #-1 c, 0 c, 0 c,

: map  stage layer2 >tilemap @> ;
: standard-physics  map coldata collide-tilemap ;

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

