/// PRE-DESTROY

//var winst = place_meeting(x,y,oWindow);
//if (winst) {
//	winst.broken = true;
//} else {
var s = instance_create_layer(x, y, layer, oPizzaSplatter)
s.target_id = target_id;
//}

instance_destroy()