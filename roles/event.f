depend ramen/lib/std/kb.f

define-role event eventing

state: event state1
    [dev] [if] hid on [then]
;

action: event start  state1 ;
