// Apply gravity
vsp += grav;
vsp = clamp(vsp, -vsp_max, vsp_max);

// Move horizontally based on current direction
hsp = hsp_max * current_dir;

// Horizontal collision
if (place_meeting(x + hsp, y, oWall)) {
    var _pixel = sign(hsp);
    while (!place_meeting(x + _pixel, y, oWall)) {
        x += _pixel;
    }
    hsp = 0;
    current_dir *= -1; // Flip direction on wall hit
}

// Vertical collision
if (place_meeting(x, y + vsp, oWall)) {
    var _pixel = sign(vsp);
    while (!place_meeting(x, y + _pixel, oWall)) {
        y += _pixel;
    }
    vsp = 0;
}

// Apply movement
x += hsp;
y += vsp;

// Optional: stop walking in air (keeps it grounded for patrolling only)
if (!place_meeting(x, y + 1, oWall)) {
    hsp = 0;
}
