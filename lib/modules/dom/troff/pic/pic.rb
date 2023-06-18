# possibility of using [].chunk_while to parse input?
#
#    .PS/.PE (or .PF - returns page position to where it was at .PS)
#
# TOKENS(ish)
#
#    ; separates multiple statements on single line
#    \ continues input line
#    internal unit is inches
#
# built-in variables:
#  - movewid, moveht
#  - ellipsewid, ellipseht
#  - textwid, textht
#  - boxht, boxwid
#  - linewid, lineht, dashwid
#  - arrowwid, arrowht, arrowhead
#  - arcrad, circlerad
#  - maxpsht, maxpswid, fillval (0 black, 1 white, default 0.3), scale
#
# labels:
#  - start with Uppercase letter (to distinguish from variables), end with ':'
#  - Name refers to "center" of object (geometric center for most things)
#  - named sequence of other normal drawing commands
#  - reserved name Here refers to current position
#  - can be redefined in terms of itself (Box1: Box1 + 1,1)
#
# objects:
#  - arrow (line ->), line (<-, <->, ->)
#  - spline - same as line, but tangent to midpoint of each segment
#  - box
#  - circle, ellipse, arc (<-, <->, ->)
#  - "text" (double quotes enclosing); standalone obj or as labels on other obj, may include troff escapes
#           effectively contained in invisible box of textwid x height n(lines)*textht
#  - [ ] - block, is object in its own right, referenced as "last []"
#          blocks are unit, "last box" does not refer to box inside block
#          can be placed with internal label at specific point (.Label, similar to .nw, etc.)
#          variables and places are block local. including built-in variables
#          blocks nest, but labels only work one level deep (though [].A.sw is legal)
#  - { } preserve current position and direction of motion on finish; nothing else is restored
#
# sizing:
#  - rad(ius) - of circle or arc
#  - wid(th), h(eigh)t - of box, ellipse
#
# positional/directional:
#  - up, down, left, right (also determine direction of join), up right, down left (etc.)
#  - top, bottom, center, end (of line/arrow), start (of line/arrow)
#  - n, s, e, w, nw, ne, sw, se
#  - .n, .s, .e, .w, .nw, .ne, .sw, .se (object-relative point of reference)
#  - .wid, .ht, .rad (object-relative size)
#  - .x, .y (single component of coordinate)
#  - at, from, to (some other point of reference)
#  - below, above (text position; one half line space in given direction)
#  - fraction of the way between obj1 and obj2 (yikes), shortened: fraction <pos1, pos2>
#  - cw (clockwise, for arc only)
#  - of (some other object)
#  - with (object-relative point of reference at some location)
#  - move (current insertion point to other location)
#
# other:
#  - fill (box, circle, or ellipse)
#  - then (sequencing line segments)
#  - ljust, rjust (text justification)
#  - 1st, 2nd, 3rd, last, 2nd last, 3rd last (referring to previously drawn object of whatever type/name)
#  - invis(ible), dashed, dotted
#  - chop (by circlerad at each end of line, or by specified rad, or with chop beginrad chop endrad)
#  - same (size of previously drawn object)
#  - copy "file" (thru macro-name, thru { macro replacement text }) inserts named file with .PS/.PE ignored
#  - copy thru { } (apply sequence as positional params $1,$2,$3... to provided block), read until .PE
#  - define word { } (function, with positional params)
#  - undef word
#  - for x to y (by n, by *n) do { } (loop)
#  - if cond then { } (loop)
#  - ==, != (string comparison)
#  - log(e), exp(e) - both base 10
#  - cos(e), sin(e), atan2(y,x), sqrt(e), max(e1,e2), min(e1,e2), int(e), rand()
#  - *, /, +, -, %, ^ (arithmetic), parens
#  - var = val (assignment)
#  - sprintf() (as clib?)
#  - reset (all variables, or namedvar1, namedvar2, ...)
#  - # (comment to end of line)
#  - sh (arbitrary shell command)
#
