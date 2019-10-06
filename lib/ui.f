\ TODO
\ [ ] - automatically setup tileset and layer etc

common

define uiing


common also uiing
variable ui
0 value dialog?
\ variable >text  
0 value &text

: ui-layer stage layer4 ;


: hide-dialog  160 ui-layer viewport h!   false to dialog? ;

: hide-ui  0   ui-layer viewport w!  ui off  hide-dialog ;
: show-ui  320 ui-layer viewport w!  ui on ;
show-ui

: show-dialog  240 ui-layer viewport h!  show-ui  true to dialog? ;


define uiing
: lines  ( adr #lines - )
    for
        dup
            #32 white text
            0 fnt @ fonth 2 * +at
        #32 +
    loop drop
;

common also uiing

: draw-ui-text
    ui @ -exit  dialog? -exit
    &text -exit
    default-font font>
    32 168 at   &text 3 lines
    
    now 16 and if 
        288 208 at   s" Z" text
    then
    
    <z> pressed if  paused off  hide-dialog  then
;

: dialog  ( adr -- )  \ adr = 5 rows x 32 chars
    to &text
    show-dialog
    paused on
;

: textline:  ( -- <text> )
    here  32 for bl c, loop  0 parse rot swap move ;

: dialog:  ( -- <name> ) ( -- )
    create  does> dialog ;