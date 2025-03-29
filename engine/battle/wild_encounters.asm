; try to initiate a wild pokemon encounter
; returns success in Z
TryDoWildEncounter:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wMovementFlags]
	and a ; is player exiting a door, jumping over a ledge, or fishing?
	ret nz
	callfar IsPlayerStandingOnDoorTileOrWarpTile
	jr nc, .notStandingOnDoorOrWarpTile
.CantEncounter
	ld a, $1
	and a
	ret
.notStandingOnDoorOrWarpTile
	callfar IsPlayerJustOutsideMap
	jr z, .CantEncounter
	ld a, [wRepelRemainingSteps]
	and a
	jr z, .next
	dec a
	ld [wRepelRemainingSteps], a
	jr z, .lastRepelStep
.next
; determine if wild pokemon can appear in the half-block we're standing in
; is the bottom left tile (8,9) of the half-block we're standing in a grass/water tile?
; The original game loads the bottom right tile here, but that prevents encounters in
; the "star-grass" tiles in veridian forrest and the safari zone.
; This also prevents pokemon from spawning on eastern shores, but the original had the
; same issue with western shores, so it's fine.
	hlcoord 8, 9
	ld c, [hl]
	ld a, [wGrassTile]
	cp c
	ld a, [wGrassRate]
	jr z, .CanEncounter
	ld a, $14 ; in all tilesets with a water tile, this is its id
	cp c
	ld a, [wWaterRate]
	jr z, .CanEncounter
; even if not in grass/water, standing anywhere we can encounter pokemon
; so long as the map is "indoor" and has wild pokemon defined.
; ...as long as it's not Viridian Forest or Safari Zone.
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP ; is this an indoor map?
	jr c, .CantEncounter
	ld a, [wCurMapTileset]
	cp FOREST ; Viridian Forest/Safari Zone
	jr z, .CantEncounter
	ld a, [wGrassRate]
.CanEncounter
; compare encounter chance with a random number to determine if there will be an encounter
	ld b, a
	ldh a, [hRandomAdd]
	cp b
	jr nc, .CantEncounter
	ldh a, [hRandomSub]
	ld b, a
	ld hl, WildMonEncounterSlotChances
.determineEncounterSlot
	ld a, [hli]
	cp b
	jr nc, .gotEncounterSlot
	inc hl
	jr .determineEncounterSlot
.gotEncounterSlot
; determine which wild pokemon (grass or water) can appear in the half-block we're standing in
	ld a, c ; The (bottom left) tile the player is standing on
	ld c, [hl]
	ld hl, wGrassMons
	cp $14 ; is the bottom left tile of the half-block we're standing in a water tile?
	jr nz, .gotWildEncounterType ; else, it's treated as a grass tile by default
	ld hl, wWaterMons
.gotWildEncounterType
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wCurEnemyLevel], a
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wEnemyMonSpecies2], a
	ld a, [wRepelRemainingSteps]
	and a
	jr z, .willEncounter
	ld a, [wPartyMon1Level]
	ld b, a
	ld a, [wCurEnemyLevel]
	cp b
	jr c, .CantEncounter ; repel prevents encounters if the leading party mon's level is higher than the wild mon
.willEncounter
	xor a
	ret
.lastRepelStep
	ld a, TEXT_REPEL_WORE_OFF
	ldh [hTextID], a
	call EnableAutoTextBoxDrawing
	call DisplayTextID
	jp .CantEncounter

INCLUDE "data/wild/probabilities.asm"
