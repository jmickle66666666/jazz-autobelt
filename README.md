# jazz-autobelt
queenjazz's autobelt factorio mod


Unfortunately I'm not continuing work on this mod, so what is here is a proof of concept.

## what

This is a mod for Factorio! It includes an item that automatically builds belts between two specified points.

## why

Because I'm super lazy and often can't be bothered with dragging a belt across my base. i love spaghetti

## why,,, not?

because it crashes pretty often :( I think it's just doing way too much in one frame for the game to handle
pathfinding is pretty dang expensive, especially when you're doing it all in a scripting language.

### did you say in one frame? does that mean if you managed to decouple the logic and had it spread itself over frames (i guess using a benchmark timer to do as much as it can in one frame then pick up where it left off on the next frame until it's done)

probably. i'm also unlikely to do it.
