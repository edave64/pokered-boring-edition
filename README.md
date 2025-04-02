# Pokémon Red and Blue - Boring Edition ![Build Status](https://github.com/edave64/pokered-boring-edition/actions/workflows/main.yml/badge.svg)

This is a mod of Pokémon Red and Blue that aims to fix bugs present in the original game.

For documentation, please look at the original [pokered](https://github.com/pret/pokered) project.

## Fixed bugs

- [Wrong cry in intro cutscene](https://bulbapedia.bulbagarden.net/wiki/List_of_glitches_in_Generation_I#New-game_Nidorino_cry_oversight)
- [Gen1 Miss](https://bulbapedia.bulbagarden.net/wiki/List_of_battle_glitches_in_Generation_I#1/256_miss_glitch)
- [Oak Poké Ball delivery text overlapping](https://bulbapedia.bulbagarden.net/wiki/List_of_overworld_glitches_in_Generation_I#Oak_Pok%C3%A9_Ball_delivery_text_overlapping)
- [Badge boost](https://bulbapedia.bulbagarden.net/wiki/List_of_battle_glitches_in_Generation_I#Stat_modification_errors) (Fix may be incomplete)
- [Instant Text trick](https://bulbapedia.bulbagarden.net/wiki/List_of_glitches_in_Generation_I#Instant_Text_trick)
- [Mew glitch/Trainer-Fly](https://bulbapedia.bulbagarden.net/wiki/Mew_glitch)
- [Save corruption](https://bulbapedia.bulbagarden.net/wiki/List_of_glitches_in_Generation_I#Save_corruption)
- [Save data carryover](https://bulbapedia.bulbagarden.net/wiki/List_of_glitches_in_Generation_I#Save_data_carryover)
- [Surfing/Fishing in gym statues](https://bulbapedia.bulbagarden.net/wiki/List_of_overworld_glitches_in_Generation_I#Statue_water_tile_oversight)
- [Focus Energy and Dire Hits](https://bulbapedia.bulbagarden.net/wiki/List_of_battle_glitches_in_Generation_I#Critical_hit_ratio_error)
  - Some liberty was taken with this implementation.
  - It appears that originally, your critical hit chance was supposed to be
    divided by two without Focus Energy, and doubled with it. This was flipped.
  - To not disturb the critical hit chance that players are used to, it is now
    always doubled, and FE doubles it again if used.
- [Escaping from Sea Cottage and Pokémon Fan Club](https://bulbapedia.bulbagarden.net/wiki/List_of_overworld_glitches_in_Generation_I#Escaping_from_Sea_Cottage_and_Pok%C3%A9mon_Fan_Club)
- [Player sprite becoming ABCD when teleporting/digging/using escape rope](https://www.youtube.com/watch?v=Y0hvQZ8DxfI&pp=ygUTcG9rZW1vbiBBQkNEIGdsaXRjaA%3D%3D)
- [Ghost identity unveiling](https://bulbapedia.bulbagarden.net/wiki/List_of_battle_glitches_in_Generation_I#Ghost_identity_unveiling)
- [Ghost Marowak bypassing](https://bulbapedia.bulbagarden.net/wiki/List_of_battle_glitches_in_Generation_I#Ghost_Marowak_bypassing)
- Unidentified ghost Pokémon are not registered in the Pokédex anymore
- [Invisible PC access](https://bulbapedia.bulbagarden.net/wiki/List_of_overworld_glitches_in_Generation_I#Invisible_PC_access)
- [Glitch city](https://bulbapedia.bulbagarden.net/wiki/Glitch_City) and other glitches from Safari zone escape
- [Cycling Road access requirement bypassing](https://bulbapedia.bulbagarden.net/wiki/List_of_overworld_glitches_in_Generation_I#Cycling_Road_access_requirement_bypassing)
- [Old man glitch](https://bulbapedia.bulbagarden.net/wiki/Old_man_glitch)
  - Eastern shores (like the one of cinnabar island) cannot spawn Pokémon at all anymore
  - Spawning land encounters on shore tiles is fixed in general
  - All grass tiles in Veridian forrest now spawn wild encounters
- [Dual-type damage misinformation](https://bulbapedia.bulbagarden.net/wiki/Dual-type_damage_misinformation)
- Bide damage is properly reset at the begin of battles
- [Invulnerability glitch](https://bulbapedia.bulbagarden.net/wiki/List_of_battle_glitches_in_Generation_I#Invulnerability_glitch)
- Fixed PP restore not functioning with PP-Ups
- Fixed struggle not working if PP-Ups were used

## Not a bug
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
