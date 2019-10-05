\ TODO
\ [ ] - automatically setup tileset and layer etc

common

define uiing

variable ui
\ variable >text  
0 value &text

: hide-ui  -9999 stage layer4 viewport x!  ui off ;
: show-ui  0 stage layer4 viewport x!      ui on ;
hide-ui

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
    ui @ -exit
    &text -exit
    default-font font>
    32 168 at   &text 3 lines
    
    now 16 and if 
        288 208 at   s" Z" text
    then
    
    <z> pressed if  paused off  hide-ui  then
;

: dialog  ( adr -- )  \ adr = 5 rows x 32 chars
    to &text
    show-ui
    paused on
;

: textline:  ( -- <text) >
    here  32 for bl c, loop  0 parse rot swap move ;

: dialog:  ( -- <name> ) ( -- )
    create  does> dialog ;