ClearVariablesOnEnterMap::
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	ldh [rWY], a
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld [wStepCounter], a
	ld [wLoneAttackNo], a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ldh [hJoyHeld], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wUnusedMapVariable], a
	ld hl, wCardKeyDoorY
	ld [hli], a
	ld [hl], a
	ld hl, wWhichTrade
	ld bc, wStandingOnWarpPadOrHole - wWhichTrade
	call FillMemory
	
	; Trainer fly fix
	ld hl, wStatusFlags5
	set BIT_RESET_NPC_ENCOUNTER, [hl] ; Tell the enemy trainer encounter to abort
	ld hl, wMiscFlags
	res BIT_SEEN_BY_TRAINER    , [hl] ; Release buttons from being blocked after trainer-fly
	ret
