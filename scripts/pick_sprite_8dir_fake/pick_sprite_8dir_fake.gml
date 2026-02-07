function pick_sprite_8dir_fake(_ang)
{
    var a  = (_ang mod 360 + 360) mod 360;
    var d8 = (floor((a + 22.5) / 45)) mod 8;

    image_angle = 0;

    switch (d8) {
        case 0: sprite_index = spr_right; image_angle = 0;    break; // E
        case 1: sprite_index = spr_up;    image_angle = -45;  break; // NE
        case 2: sprite_index = spr_up;    image_angle = 0;    break; // N
        case 3: sprite_index = spr_up;    image_angle = 45;   break; // NW
        case 4: sprite_index = spr_left;  image_angle = 0;    break; // W
        case 5: sprite_index = spr_down;  image_angle = -45;  break; // SW
        case 6: sprite_index = spr_down;  image_angle = 0;    break; // S
        case 7: sprite_index = spr_down;  image_angle = 45;   break; // SE
    }
}
