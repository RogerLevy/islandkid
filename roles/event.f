depend ramen/lib/std/kb.f

define-role event eventing

state: state1 event
    [dev] [if] hid on [then]
;

action: start event  state1 ;
