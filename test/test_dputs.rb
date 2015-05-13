require 'helper_classes/dputs'

DEBUG_LVL = 5

include HelperClasses

DPuts.dputs(5){ 'Hello'
}

include DPuts

dputs( 5 ){ 'Hello there'
}

