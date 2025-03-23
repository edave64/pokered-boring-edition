PrintTrashText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump VermilionGymTrashText

VermilionGymTrashText::
	text_far _VermilionGymTrashText
	text_end

; How the trash can puzzle works:
; Every trash can is numbered from top-left, down and to the right. Giving these IDs:
; 0 3 6 9 C
; 1 4 7 A D
; 2 5 8 B E
;
; Step 0: At the begin of the puzzle, on map load (?) or after a wrong step 2 (?)
; - Select a random number between 00 and 0E.
; - Write it into wFirstLockTrashCanIndex
;
; Step 1: Player picks first trash can
; - Does the random number match [wFirstLockTrashCanIndex]
; -> Step 2
; -> Otherwise Step 1
;
; Step 2: When the player has found the first trash can:
; -> Take the current trash can and look it up in GymTrashCans
; -> Read how many neighbors it has
; -> Pick one from the list of neighbors
; -> Write that index into wSecondLockTrashCanIndex
;
; Step 3: Player picks second trash can
; - Does the random number match [wSecondLockTrashCanIndex]
; -> Solved
GymTrashScript:
	call EnableAutoTextBoxDrawing
	ld a, [wHiddenObjectFunctionArgument]
	ld [wGymTrashCanIndex], a

; Don't do the trash can puzzle if it's already been done.
	CheckEvent EVENT_2ND_LOCK_OPENED
	jr z, .ok

	tx_pre_jump VermilionGymTrashText

.ok
	CheckEventReuseA EVENT_1ST_LOCK_OPENED
	jr nz, .trySecondLock

	ld a, [wFirstLockTrashCanIndex]
	ld b, a
	ld a, [wGymTrashCanIndex]
	cp b
	jr z, .openFirstLock

	tx_pre_id VermilionGymTrashText
	jr .done

.openFirstLock
; Next can is trying for the second switch.
	SetEvent EVENT_1ST_LOCK_OPENED

	ld hl, GymTrashCans
	ld a, [wGymTrashCanIndex]
	; * 5
	ld b, a
	add a
	add a
	add b
	; a = wGymTrashCanIndex * 5
	; This is the trash can's offset within the GymTrashCans array

	ld d, 0
	ld e, a
	add hl, de ; Add trash can offset to the base address
	ld a, [hli] ; Load the first value from the GymTrashCans entry (Random Mask)
	ldh [hGymTrashCanNeighborCount], a

	; Neighbor count can have one of three values: 2, 3, 4
	; For each, we need to convert our random number 0 to 255 into the range of 0 to (neighbor count - 1)
	push hl
	call Random
	swap a
	ld b, a
	ldh a, [hGymTrashCanNeighborCount]
	cp $02
	jr z, .mod2
	cp $04
	jr z, .mod4
	; For 3, we check into which third of FF the number falls into. That's our neighbor number.
	ld a, b
	cp $55 ; 1 / 3
	ld b, 0
	jr c, .afterMod3
	cp $AA ; 2 / 3
	ld b, 1
	jr c, .afterMod3
	ld b, 2 ; 3 / 3
.afterMod3
	ld a, b
	jr .lookupIndex
.mod2:
	; For 2, we AND the random number by 1
	ld a, b
	and $01
	jr .lookupIndex
.mod4:
	; For 4, we AND the random number by 3
	ld a, b
	and $03
.lookupIndex:
	pop hl

	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	and $f
	ld [wSecondLockTrashCanIndex], a

	tx_pre_id VermilionGymTrashSuccessText1
	jr .done

.trySecondLock
	ld a, [wSecondLockTrashCanIndex]
	ld b, a
	ld a, [wGymTrashCanIndex]
	cp b
	jr z, .openSecondLock

; Reset the cans.
	ResetEvent EVENT_1ST_LOCK_OPENED
.roll
	call Random

	and $f
	cp $f
	jp z, .roll
	ld [wFirstLockTrashCanIndex], a

	tx_pre_id VermilionGymTrashFailText
	jr .done

.openSecondLock
; Completed the trash can puzzle.
	SetEvent EVENT_2ND_LOCK_OPENED
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_2, [hl]

	tx_pre_id VermilionGymTrashSuccessText3

.done
	jp PrintPredefTextID

GymTrashCans:
; byte 0: Number of neighboring trash cans
; bytes 1-4: indices of the trash cans that can have the second lock
; Note that the mask is simply the number of valid trash can indices that
; follow. The remaining bytes are filled with 0 to pad the length of each entry
; to 5 bytes.
	db 2,  1,  3,  0,  0 ; 0
	db 3,  0,  2,  4,  0 ; 1
	db 2,  1,  5,  0,  0 ; 2
	db 3,  0,  4,  6,  0 ; 3
	db 4,  1,  3,  5,  7 ; 4
	db 3,  2,  4,  8,  0 ; 5
	db 3,  3,  7,  9,  0 ; 6
	db 4,  4,  6,  8, 10 ; 7
	db 3,  5,  7, 11,  0 ; 8
	db 3,  6, 10, 12,  0 ; 9
	db 4,  7,  9, 11, 13 ; 10
	db 3,  8, 10, 14,  0 ; 11
	db 2,  9, 13,  0,  0 ; 12
	db 3, 10, 12, 14,  0 ; 13
	db 2, 11, 13,  0,  0 ; 14

VermilionGymTrashSuccessText1::
	text_far _VermilionGymTrashSuccessText1
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

; unused
VermilionGymTrashSuccessText2::
	text_far _VermilionGymTrashSuccessText2
	text_end

; unused
VermilionGymTrashSuccesPlaySfx:
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionGymTrashSuccessText3::
	text_far _VermilionGymTrashSuccessText3
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionGymTrashFailText::
	text_far _VermilionGymTrashFailText
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd
