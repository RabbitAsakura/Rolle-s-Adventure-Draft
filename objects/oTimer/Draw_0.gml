var minutes = floor(time_elapsed / 60);
var seconds = floor(time_elapsed) mod 60;
var milliseconds = floor((time_elapsed mod 1) * 100); // Two-digit ms

var time_string = string(minutes) + ":" +
                  string_format(seconds, 2, 0) + ":" +
                  string_format(milliseconds, 2, 0);

draw_text(x, y, "Time: " + time_string);
