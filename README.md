# Pokémon Red and Blue - Boring Edition [![Build Status][ci-badge]][ci]

This is a mod of Pokémon Red and Blue that aims to fix bugs present in the original game.

For documentation, please look at the original [pokered](https://github.com/pret/pokered) project.

## Not a glitch

Some things that are commonly reported as glitches are deemed "not glitches"
for this project. This is typically done because it has a minor effect on
gameplay and an argument is made that it was explicitly intended or
acknowledged by the programmers.

### Red bar
When the beeping sound plays that alerts you that your Pokémon has low
health, some effects are skipped, making battles faster.

This is often exploited in speedruns, much to the annoyance of anyone with ears
and is often reported as a bug, because the game simply ran out of sound
channels when the beeping is played.

However, the function `WaitForSoundToFinish` explicitly returns early when the
`wLowHealthAlarm` is set, making this actually intended behavior. Still born of
a limitation, but not happening by accident.

### No Pokémon encounters on some shore tiles

In the original game, the western shores and northern shores cannot spawn any
Pokémon. In this mod, as part of the star-grass fix, this now happens on
eastern and northern shores.

While the code for wild encounters was buggy and used to reference two
different tiles, it is very clear from how the mechanism functions that it
would always exclude some shore tiles. I believe this was an intentional
tradeoff.
