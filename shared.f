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
    t w layer2 >tilemap >!
    w layer2 >tileset @ 0 = if
        pic( default ) w layer2 >tileset >!
    then
    w switchto
;

