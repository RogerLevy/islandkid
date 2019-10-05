include ramen/ramen.f
empty
s" islandkid.blk" include prg/gamester/gamester.f
displaywh 3 3 2/ resolution

get-order get-current

\ common
\ : init-world ( tileset n -- )
\     | n ts | 
\     n tilemap ts n world init-slew ;
    
set-current set-order