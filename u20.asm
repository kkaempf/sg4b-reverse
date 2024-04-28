; z80dasm 1.2.0
; command line: z80dasm -l -a -t -g 0 -S U20.SYM --sym-comments U20.BIN

	org 00000h
; RAM base
RAM_BASE:	equ 0x4000
CUR_MAP:	equ 0x4122
; RAM TEST ADRES
RAM_TEST:	equ 0x4f8d
; Stack base
STACK_BASE:	equ 0x52ad
; Warm boot/cold boot -- contains aa in warm boots
WARM_FLAG:	equ 0x53bb


; Some sort of display control. If bit 4 is set, no display
DISP_MODE: equ 0x4f79

COLD_START:
	di
	jp BOOT
VERSION:
	db 0x57			;	Version number?
l0005h:
	db 0xff
l0006h:
	db 0xff
l0007h:
	db 0xff, 0xff, 0xff
l000ah:
	db 0xff
l000bh:
	db 0xff
l000ch:
	db 0xaa
l000dh:
	db 0xff, 0xff, 0xff, 0x73, 0x03, 0xff, 0xff, 0xff
	db 0xff, 0xff, 0xff, 0x04, 0x4c, 0x05, 0x60, 0x03
	db 0xc1, 0x01, 0x1c, 0x04, 0x84, 0x05, 0x68, 0x03
	db 0xc1, 0x01, 0x1c, 0x04, 0x4c, 0x05, 0xe8, 0x03
	db 0x01, 0x01, 0x1c, 0x04, 0x4c, 0x05, 0xe8, 0x03
	db 0x01, 0x01, 0x1c

; RST-38 entry point (warm boot?)
	di			;0038	f3		.
	jp BOOT			;0039	c3 8e 01	. . .
l003ch:
	cp e			;003c	bb		.
l003dh:
	nop			;003d	00		.
l003eh:
	rst 38h			;003e	ff		.
	nop			;003f	00		.
	inc b			;0040	04		.
	ld c,h			;0041	4c		L
	dec b			;0042	05		.
l0043h:
	ret pe			;0043	e8		.
	inc bc			;0044	03		.
	pop bc			;0045	c1		.
	ld bc,0041ch		;0046	01 1c 04	. . .
	ld c,h			;0049	4c		L
	dec b			;004a	05		.
l004bh:
	ret pe			;004b	e8		.
	inc bc			;004c	03		.
	pop bc			;004d	c1		.
	ld bc,0041ch		;004e	01 1c 04	. . .
	adc a,h			;0051	8c		.
	dec b			;0052	05		.
	ret pe			;0053	e8		.
	inc bc			;0054	03		.
	ld bc,01c01h		;0055	01 01 1c	. . .
	inc b			;0058	04		.
	call z,0e805h		;0059	cc 05 e8	. . .
	inc bc			;005c	03		.
	ld bc,01c01h		;005d	01 01 1c	. . .
	add a,d			;0060	82		.
	ld bc,l0182h		;0061	01 82 01	. . .
l0064h:
	xor h			;0064	ac		.
	nop			;0065	00		.
	jp pe,08200h		;0066	ea 00 82	. . .
	ld bc,l0182h		;0069	01 82 01	. . .
	rst 38h			;006c	ff		.
	nop			;006d	00		.
	dec bc			;006e	0b		.
	ld bc,l0182h		;006f	01 82 01	. . .
	add a,d			;0072	82		.
	ld bc,l0121h		;0073	01 21 01	. ! .
	dec l			;0076	2d		-
	ld bc,l0182h		;0077	01 82 01	. . .
	add a,d			;007a	82		.
	ld bc,l0110h		;007b	01 10 01	. . .
	inc e			;007e	1c		.
	ld bc,l0182h		;007f	01 82 01	. . .
	add a,d			;0082	82		.
	ld bc,l016fh		;0083	01 6f 01	. o .
	ld a,h			;0086	7c		|
	ld bc,l0182h		;0087	01 82 01	. . .
	add a,d			;008a	82		.
	ld bc,l0132h		;008b	01 32 01	. 2 .
	ld l,c			;008e	69		i
	ld bc,04404h		;008f	01 04 44	. . D
	dec b			;0092	05		.
	ld h,b			;0093	60		`
	inc bc			;0094	03		.
	add a,c			;0095	81		.
	ld bc,0041ch		;0096	01 1c 04	. . .
	ld c,h			;0099	4c		L
	dec b			;009a	05		.
	ret pe			;009b	e8		.
	inc bc			;009c	03		.
	ld b,c			;009d	41		A
	ld bc,l301ch		;009e	01 1c 30	. . 0
	djnz $+4		;00a1	10 02		. .
	ld h,b			;00a3	60		`
	jr nc,$+18		;00a4	30 10		0 .
	ld (bc),a		;00a6	02		.
	ld (hl),b		;00a7	70		p
	jr nc,l00bah		;00a8	30 10		0 .
	ld (bc),a		;00aa	02		.
	add a,b			;00ab	80		.
	exx			;00ac	d9		.
	push af			;00ad	f5		.
	ld c,001h		;00ae	0e 01		. .
	in a,(c)		;00b0	ed 78		. x
	ld b,a			;00b2	47		G
	cp 0d0h			;00b3	fe d0		. .
	jr nz,l00dch		;00b5	20 25		  %
	ld a,(05fd3h)		;00b7	3a d3 5f	: . _
l00bah:
	cp 091h			;00ba	fe 91		. .
	jr z,l00c6h		;00bc	28 08		( .
l00beh:
	ld a,(05cbah)		;00be	3a ba 5c	: . \
	cp 001h			;00c1	fe 01		. .
	jp nz,COLD_START	;00c3	c2 00 00	. . .
l00c6h:
	ld hl,040e4h		;00c6	21 e4 40	! . @
	ld a,b			;00c9	78		x
	call sub_0f09h		;00ca	cd 09 0f	. . .
l00cdh:
	bit 0,c			;00cd	cb 41		. A
	jr nz,l00d7h		;00cf	20 06		  .
	ld a,038h		;00d1	3e 38		> 8
	inc c			;00d3	0c		.
	inc c			;00d4	0c		.
	out (c),a		;00d5	ed 79		. y
l00d7h:
	exx			;00d7	d9		.
	pop af			;00d8	f1		.
	ei			;00d9	fb		.
	reti			;00da	ed 4d		. M
l00dch:
	ld a,b			;00dc	78		x
	cp 091h			;00dd	fe 91		. .
	jr nz,l00c6h		;00df	20 e5		  .
	ld a,(05fd3h)		;00e1	3a d3 5f	: . _
	cp 091h			;00e4	fe 91		. .
l00e6h:
	jr nz,l00c6h		;00e6	20 de		  .
	jr l00beh		;00e8	18 d4		. .
	push bc			;00ea	c5		.
	ld c,003h		;00eb	0e 03		. .
l00edh:
	ld b,030h		;00ed	06 30		. 0
l00efh:
	out (c),b		;00ef	ed 41		. A
	push af			;00f1	f5		.
	bit 0,c			;00f2	cb 41		. A
	jr nz,l00fah		;00f4	20 04		  .
	ld b,038h		;00f6	06 38		. 8
	out (c),b		;00f8	ed 41		. A
l00fah:
	pop af			;00fa	f1		.
	pop bc			;00fb	c1		.
	ei			;00fc	fb		.
	reti			;00fd	ed 4d		. M
	exx			;00ff	d9		.
	push af			;0100	f5		.
	ld c,000h		;0101	0e 00		. .
	ld hl,040e0h		;0103	21 e0 40	! . @
	call SERIAL_SOMETHING	;0106	cd 07 0f	. . .
	jr l00cdh		;0109	18 c2		. .
	push bc			;010b	c5		.
	ld c,002h		;010c	0e 02		. .
	jr l00edh		;010e	18 dd		. .
l0110h:
	exx			;0110	d9		.
	push af			;0111	f5		.
	ld c,010h		;0112	0e 10		. .
	ld hl,040e8h		;0114	21 e8 40	! . @
	call SERIAL_SOMETHING	;0117	cd 07 0f	. . .
	jr l00cdh		;011a	18 b1		. .
	push bc			;011c	c5		.
	ld c,012h		;011d	0e 12		. .
	jr l00edh		;011f	18 cc		. .
l0121h:
	exx			;0121	d9		.
	push af			;0122	f5		.
	ld c,011h		;0123	0e 11		. .
	ld hl,040ech		;0125	21 ec 40	! . @
	call SERIAL_SOMETHING	;0128	cd 07 0f	. . .
	jr l00cdh		;012b	18 a0		. .
	push bc			;012d	c5		.
	ld c,013h		;012e	0e 13		. .
	jr l00edh		;0130	18 bb		. .
l0132h:
	exx			;0132	d9		.
	push af			;0133	f5		.
	ld c,014h		;0134	0e 14		. .
	in a,(c)		;0136	ed 78		. x
	ld b,a			;0138	47		G
	cp 013h			;0139	fe 13		. .
	ld a,000h		;013b	3e 00		> .
	jr nz,l0140h		;013d	20 01		  .
	inc a			;013f	3c		<
l0140h:
	ld (05eabh),a		;0140	32 ab 5e	2 . ^
	ld a,b			;0143	78		x
l0144h:
	ld hl,040f0h		;0144	21 f0 40	! . @
l0147h:
	call sub_0f09h		;0147	cd 09 0f	. . .
	ld a,(05eaah)		;014a	3a aa 5e	: . ^
	and a			;014d	a7		.
	jp nz,l00cdh		;014e	c2 cd 00	. . .
	ld a,(hl)		;0151	7e		~
	and 01fh		;0152	e6 1f		. .
	ld b,a			;0154	47		G
	inc hl			;0155	23		#
	inc hl			;0156	23		#
	ld a,(hl)		;0157	7e		~
	dec a			;0158	3d		=
	and 01fh		;0159	e6 1f		. .
	cp b			;015b	b8		.
	jp z,08b49h		;015c	ca 49 8b	. I .
	dec a			;015f	3d		=
	and 01fh		;0160	e6 1f		. .
	cp b			;0162	b8		.
	jp z,08b49h		;0163	ca 49 8b	. I .
	jp l00cdh		;0166	c3 cd 00	. . .
	push bc			;0169	c5		.
	ld c,016h		;016a	0e 16		. .
	jp l00edh		;016c	c3 ed 00	. . .
l016fh:
	exx			;016f	d9		.
l0170h:
	push af			;0170	f5		.
	ld c,015h		;0171	0e 15		. .
	ld hl,040f4h		;0173	21 f4 40	! . @
	call SERIAL_SOMETHING	;0176	cd 07 0f	. . .
	jp l00cdh		;0179	c3 cd 00	. . .
	push bc			;017c	c5		.
	ld c,017h		;017d	0e 17		. .
	jp l00edh		;017f	c3 ed 00	. . .
l0182h:
	exx			;0182	d9		.
	push af			;0183	f5		.
	call sub_09b1h		;0184	cd b1 09	. . .
	nop			;0187	00		.
	ret nz			;0188	c0		.
	pop af			;0189	f1		.
	exx			;018a	d9		.
	ei			;018b	fb		.
	reti			;018c	ed 4d		. M
; Cold start boot
BOOT:
	di			;018e	f3		.
l018fh:
	ld sp,STACK_BASE	;018f	31 ad 52	1 . R
; Wait for RAM to stabilize
WAIT_RAM:
	ld a,0aah		;0192	3e aa		> .
	ld (RAM_TEST),a		;0194	32 8d 4f	2 . O
	ld a,(RAM_TEST)		;0197	3a 8d 4f	: . O
	cp 0aah			;019a	fe aa		. .
	jr nz,WAIT_RAM		;019c	20 f4		  .
	ld a,(WARM_FLAG)	;019e	3a bb 53	: . S
	cp 0aah			;01a1	fe aa		. .
	jp z,WARM_BOOT		;01a3	ca 58 02	. X .
; Cold boot, clear 0x4000-0x6fff
COLD_BOOT:
	ld bc,l3000h		;01a6	01 00 30	. . 0
	ld de,04001h		;01a9	11 01 40	. . @
	ld hl,RAM_BASE		;01ac	21 00 40	! . @
	ld (hl),000h		;01af	36 00		6 .
	ldir			;01b1	ed b0		. .
	ld a,003h		;01b3	3e 03		> .
	call SOMETHING_MEM	;01b5	cd 1a 0f	. . .
	ld hl,0c000h		;01b8	21 00 c0	! . .
	ld de,0c001h		;01bb	11 01 c0	. . .
	ld bc,l3fffh		;01be	01 ff 3f	. . ?
	ld (hl),000h		;01c1	36 00		6 .
	ldir			;01c3	ed b0		. .
	xor a			;01c5	af		.
	call sub_087ch		;01c6	cd 7c 08	. | .
	ld hl,003e7h		;01c9	21 e7 03	! . .
	ld (052c2h),hl		;01cc	22 c2 52	" . R
	call sub_22f0h		;01cf	cd f0 22	. . "
	call sub_2318h		;01d2	cd 18 23	. . #
	call sub_23d2h		;01d5	cd d2 23	. . #
	ld a,04eh		;01d8	3e 4e		> N
	ld (05b84h),a		;01da	32 84 5b	2 . [
	call sub_0968h		;01dd	cd 68 09	. h .
	ld (05b77h),hl		;01e0	22 77 5b	" w [
	ld hl,17		;01e3	21 11 00	! . .
	ld (05b79h),hl		;01e6	22 79 5b	" y [
	call 09edeh		;01e9	cd de 9e	. . .
	ld hl,053bdh		;01ec	21 bd 53	! . S
	ld a,00fh		;01ef	3e 0f		> .
	ld (hl),a		;01f1	77		w
	inc hl			;01f2	23		#
	inc hl			;01f3	23		#
	ld a,04eh		;01f4	3e 4e		> N
	ld (hl),a		;01f6	77		w
	inc hl			;01f7	23		#
	ld (hl),a		;01f8	77		w
	call 0b3a3h		;01f9	cd a3 b3	. . .
	ld a,(l000ah)		;01fc	3a 0a 00	: . .
	ld (05b88h),a		;01ff	32 88 5b	2 . [
	ld a,0aah		;0202	3e aa		> .
	ld (040fch),a		;0204	32 fc 40	2 . @
	ld (04f8ch),a		;0207	32 8c 4f	2 . O
	ld (WARM_FLAG),a	;020a	32 bb 53	2 . S
	ld a,01ah		;020d	3e 1a		> .
	ld (05b71h),a		;020f	32 71 5b	2 q [
	ld hl,(05b77h)		;0212	2a 77 5b	* w [
	dec hl			;0215	2b		+
	ld (05b77h),hl		;0216	22 77 5b	" w [
	ld d,h			;0219	54		T
	ld e,l			;021a	5d		]
	ld hl,COLD_START	;021b	21 00 00	! . .
	call 0b05ch		;021e	cd 5c b0	. \ .
	ld a,00fh		;0221	3e 0f		> .
	ld (053bdh),a		;0223	32 bd 53	2 . S
	ld hl,05eb3h		;0226	21 b3 5e	! . ^
	ld b,006h		;0229	06 06		. .
l022bh:
	ld (hl),020h		;022b	36 20		6  
	inc hl			;022d	23		#
	djnz l022bh		;022e	10 fb		. .
l0230h:
	ld hl,05eb3h		;0230	21 b3 5e	! . ^
	ld de,05ebdh		;0233	11 bd 5e	. . ^
	ld bc,l00e6h		;0236	01 e6 00	. . .
	ldir			;0239	ed b0		. .
	call sub_0849h		;023b	cd 49 08	. I .
	xor a			;023e	af		.
	call SOMETHING_MEM	;023f	cd 1a 0f	. . .
	ld hl,(0e000h)		;0242	2a 00 e0	* . .
	ld de,0aaaah		;0245	11 aa aa	. . .
	call sub_0f20h		;0248	cd 20 0f	.   .
	jr nz,WARM_BOOT		;024b	20 0b		  .
	ld hl,0e002h		;024d	21 02 e0	! . .
	ld (05bb0h),hl		;0250	22 b0 5b	" . [
	ld a,0aah		;0253	3e aa		> .
	ld (04f78h),a		;0255	32 78 4f	2 x O
; Warm boot
WARM_BOOT:
	ld sp,STACK_BASE	;0258	31 ad 52	1 . R
	call sub_09b1h		;025b	cd b1 09	. . .
	nop			;025e	00		.
	ret nz			;025f	c0		.
	ld hl,RAM_BASE		;0260	21 00 40	! . @
	ld (040e0h),hl		;0263	22 e0 40	" . @
	ld (040e2h),hl		;0266	22 e2 40	" . @
	ld hl,04020h		;0269	21 20 40	!   @
	ld (040e4h),hl		;026c	22 e4 40	" . @
	ld (040e6h),hl		;026f	22 e6 40	" . @
	ld hl,04040h		;0272	21 40 40	! @ @
	ld (040e8h),hl		;0275	22 e8 40	" . @
	ld (040eah),hl		;0278	22 ea 40	" . @
	ld hl,04060h		;027b	21 60 40	! ` @
	ld (040ech),hl		;027e	22 ec 40	" . @
l0281h:
	ld (040eeh),hl		;0281	22 ee 40	" . @
	ld hl,04080h		;0284	21 80 40	! . @
	ld (040f0h),hl		;0287	22 f0 40	" . @
	ld (040f2h),hl		;028a	22 f2 40	" . @
	ld hl,040a0h		;028d	21 a0 40	! . @
	ld (040f4h),hl		;0290	22 f4 40	" . @
	ld (040f6h),hl		;0293	22 f6 40	" . @
	ld hl,040c0h		;0296	21 c0 40	! . @
	ld (040f8h),hl		;0299	22 f8 40	" . @
	ld (040fah),hl		;029c	22 fa 40	" . @
	xor a			;029f	af		.
	ld (05b6eh),a		;02a0	32 6e 5b	2 n [
	ld (05cbah),a		;02a3	32 ba 5c	2 . \
	ld (05cbbh),a		;02a6	32 bb 5c	2 . \
	ld (05cbch),a		;02a9	32 bc 5c	2 . \
	ld (05eadh),a		;02ac	32 ad 5e	2 . ^
	ld (05eabh),a		;02af	32 ab 5e	2 . ^
	call 0b3a9h		;02b2	cd a9 b3	. . .
	ld a,(05b87h)		;02b5	3a 87 5b	: . [
	ld b,a			;02b8	47		G
	in a,(005h)		;02b9	db 05		. .
	and 030h		;02bb	e6 30		. 0
	ld (053bch),a		;02bd	32 bc 53	2 . S
	ld a,(053bdh)		;02c0	3a bd 53	: . S
	out (005h),a		;02c3	d3 05		. .
	xor a			;02c5	af		.
	ld (05fb6h),a		;02c6	32 b6 5f	2 . _
	ld de,052afh		;02c9	11 af 52	. . R
	ld hl,01766h		;02cc	21 66 17	! f .
l02cfh:
	ld sp,04ff1h		;02cf	31 f1 4f	1 . O
	call sub_034eh		;02d2	cd 4e 03	. N .
	ld hl,l24c1h		;02d5	21 c1 24	! . $
	ld sp,05055h		;02d8	31 55 50	1 U P
	call sub_034eh		;02db	cd 4e 03	. N .
	ld hl,l2b8ch		;02de	21 8c 2b	! . +
	ld sp,050b9h		;02e1	31 b9 50	1 . P
	call sub_034eh		;02e4	cd 4e 03	. N .
	ld hl,l3147h		;02e7	21 47 31	! G 1
	ld sp,0511dh		;02ea	31 1d 51	1 . Q
	call sub_034eh		;02ed	cd 4e 03	. N .
	ld hl,0914ah		;02f0	21 4a 91	! J .
	ld sp,05181h		;02f3	31 81 51	1 . Q
	call sub_034eh		;02f6	cd 4e 03	. N .
	ld hl,08b71h		;02f9	21 71 8b	! q .
	ld sp,051e5h		;02fc	31 e5 51	1 . Q
	call sub_034eh		;02ff	cd 4e 03	. N .
l0302h:
	ld hl,l08aeh		;0302	21 ae 08	! . .
	ld sp,05249h		;0305	31 49 52	1 I R
	call sub_034eh		;0308	cd 4e 03	. N .
	xor a			;030b	af		.
	ld (de),a		;030c	12		.
	inc de			;030d	13		.
	ld (de),a		;030e	12		.
	call sub_0364h		;030f	cd 64 03	. d .
	call 08b2eh		;0312	cd 2e 8b	. . .
l0315h:
	ld hl,052afh		;0315	21 af 52	! . R
	in a,(0ffh)		;0318	db ff		. .
l031ah:
	ld e,(hl)		;031a	5e		^
	inc hl			;031b	23		#
	ld d,(hl)		;031c	56		V
	ld a,d			;031d	7a		z
	or e			;031e	b3		.
	jr z,l0315h		;031f	28 f4		( .
	dec hl			;0321	2b		+
	ld (STACK_BASE),hl	;0322	22 ad 52	" . R
	ex de,hl		;0325	eb		.
	ld sp,hl		;0326	f9		.
	pop af			;0327	f1		.
	call SOMETHING_MEM	;0328	cd 1a 0f	. . .
	pop iy			;032b	fd e1		. .
	pop ix			;032d	dd e1		. .
	pop hl			;032f	e1		.
	pop de			;0330	d1		.
	pop bc			;0331	c1		.
	pop af			;0332	f1		.
	ret			;0333	c9		.
sub_0334h:
	push af			;0334	f5		.
	push bc			;0335	c5		.
	push de			;0336	d5		.
	push hl			;0337	e5		.
	push ix			;0338	dd e5		. .
	push iy			;033a	fd e5		. .
	ld a,(CUR_MAP)		;033c	3a 22 41	: " A
	push af			;033f	f5		.
	ld hl,COLD_START	;0340	21 00 00	! . .
	add hl,sp		;0343	39		9
	ex de,hl		;0344	eb		.
	ld hl,(STACK_BASE)	;0345	2a ad 52	* . R
	ld (hl),e		;0348	73		s
	inc hl			;0349	23		#
	ld (hl),d		;034a	72		r
	inc hl			;034b	23		#
	jr l031ah		;034c	18 cc		. .
sub_034eh:
	pop bc			;034e	c1		.
	push hl			;034f	e5		.
	push hl			;0350	e5		.
	push hl			;0351	e5		.
	push hl			;0352	e5		.
	push hl			;0353	e5		.
	push hl			;0354	e5		.
	push hl			;0355	e5		.
	ld hl,COLD_START	;0356	21 00 00	! . .
	push hl			;0359	e5		.
	add hl,sp		;035a	39		9
	ex de,hl		;035b	eb		.
	ld (hl),e		;035c	73		s
	inc hl			;035d	23		#
	ld (hl),d		;035e	72		r
	inc hl			;035f	23		#
	ex de,hl		;0360	eb		.
	ld h,b			;0361	60		`
	ld l,c			;0362	69		i
	jp (hl)			;0363	e9		.
sub_0364h:
	ei			;0364	fb		.
	reti			;0365	ed 4d		. M
	ld a,000h		;0367	3e 00		> .
	ld (05fcfh),a		;0369	32 cf 5f	2 . _
	ret			;036c	c9		.
	ld a,0aah		;036d	3e aa		> .
	ld (05fcfh),a		;036f	32 cf 5f	2 . _
	ret			;0372	c9		.
	push af			;0373	f5		.
	push bc			;0374	c5		.
	push de			;0375	d5		.
	push hl			;0376	e5		.
	push ix			;0377	dd e5		. .
	push iy			;0379	fd e5		. .
	ld a,(CUR_MAP)		;037b	3a 22 41	: " A
	push af			;037e	f5		.
	ld hl,OUT_DATA62	;037f	21 0a 07	! . .
	ld c,062h		;0382	0e 62		. b
	ld b,013h		;0384	06 13		. .
	otir			;0386	ed b3		. .
	ld hl,05fa3h		;0388	21 a3 5f	! . _
	inc (hl)		;038b	34		4
	ld hl,052bfh		;038c	21 bf 52	! . R
	inc (hl)		;038f	34		4
	call sub_1582h		;0390	cd 82 15	. . .
	call 0949bh		;0393	cd 9b 94	. . .
	ld a,005h		;0396	3e 05		> .
	out (003h),a		;0398	d3 03		. .
	ld a,(05fcfh)		;039a	3a cf 5f	: . _
	cp 0aah			;039d	fe aa		. .
	ld a,0e2h		;039f	3e e2		> .
	jr nz,l03a5h		;03a1	20 02		  .
	ld a,0e0h		;03a3	3e e0		> .
l03a5h:
	out (003h),a		;03a5	d3 03		. .
	ld a,(05b6eh)		;03a7	3a 6e 5b	: n [
	or a			;03aa	b7		.
	jp nz,l06fah		;03ab	c2 fa 06	. . .
	ld a,001h		;03ae	3e 01		> .
	ld (05b6eh),a		;03b0	32 6e 5b	2 n [
	ld a,006h		;03b3	3e 06		> .
	ld (05687h),a		;03b5	32 87 56	2 . V
	ld ix,05688h		;03b8	dd 21 88 56	. ! . V
	call sub_0364h		;03bc	cd 64 03	. d .
l03bfh:
	ld a,(ix+01dh)		;03bf	dd 7e 1d	. ~ .
	cp 002h			;03c2	fe 02		. .
	jp c,l06e8h		;03c4	da e8 06	. . .
	jp z,l062ch		;03c7	ca 2c 06	. , .
	cp 004h			;03ca	fe 04		. .
	jr c,l03d9h		;03cc	38 0b		8 .
	jp z,l0461h		;03ce	ca 61 04	. a .
	cp 006h			;03d1	fe 06		. .
	jp c,l062dh		;03d3	da 2d 06	. - .
	jp l06e8h		;03d6	c3 e8 06	. . .
l03d9h:
	ld a,(ix+001h)		;03d9	dd 7e 01	. ~ .
	or a			;03dc	b7		.
	jr z,l043eh		;03dd	28 5f		( _
	ld h,(ix+003h)		;03df	dd 66 03	. f .
	ld l,(ix+002h)		;03e2	dd 6e 02	. n .
	ld a,(hl)		;03e5	7e		~
	sub (ix+004h)		;03e6	dd 96 04	. . .
	ld (hl),a		;03e9	77		w
	ld d,(ix+008h)		;03ea	dd 56 08	. V .
	ld e,(ix+007h)		;03ed	dd 5e 07	. ^ .
	cp 038h			;03f0	fe 38		. 8
	jr nc,l03f8h		;03f2	30 04		0 .
	ex de,hl		;03f4	eb		.
	ld (hl),020h		;03f5	36 20		6  
	ex de,hl		;03f7	eb		.
l03f8h:
	cp 080h			;03f8	fe 80		. .
	jr c,l0401h		;03fa	38 05		8 .
	sub (ix+005h)		;03fc	dd 96 05	. . .
	jr l0409h		;03ff	18 08		. .
l0401h:
	sub (ix+005h)		;0401	dd 96 05	. . .
	jr z,l0409h		;0404	28 03		( .
	jp nc,l06e8h		;0406	d2 e8 06	. . .
l0409h:
	add a,(ix+006h)		;0409	dd 86 06	. . .
	ld (hl),a		;040c	77		w
	ld b,000h		;040d	06 00		. .
l040fh:
	ld c,(ix+009h)		;040f	dd 4e 09	. N .
	push de			;0412	d5		.
	pop hl			;0413	e1		.
	inc hl			;0414	23		#
	ldir			;0415	ed b0		. .
	ld a,(ix+000h)		;0417	dd 7e 00	. ~ .
	call SOMETHING_MEM	;041a	cd 1a 0f	. . .
	ld h,(ix+00ch)		;041d	dd 66 0c	. f .
	ld l,(ix+00bh)		;0420	dd 6e 0b	. n .
	ld a,(hl)		;0423	7e		~
	cp 0f0h			;0424	fe f0		. .
	jr nz,l042ah		;0426	20 02		  .
	ld a,020h		;0428	3e 20		>  
l042ah:
	cp 0f1h			;042a	fe f1		. .
	jr nz,l0430h		;042c	20 02		  .
	ld a,020h		;042e	3e 20		>  
l0430h:
	ld (de),a		;0430	12		.
	inc hl			;0431	23		#
	ld (ix+00ch),h		;0432	dd 74 0c	. t .
	ld (ix+00bh),l		;0435	dd 75 0b	. u .
	dec (ix+001h)		;0438	dd 35 01	. 5 .
	jp nz,l06e8h		;043b	c2 e8 06	. . .
l043eh:
	ld a,(ix+00dh)		;043e	dd 7e 0d	. ~ .
	or a			;0441	b7		.
	jp z,l06e8h		;0442	ca e8 06	. . .
	ld (ix+001h),a		;0445	dd 77 01	. w .
	xor a			;0448	af		.
	ld (ix+00dh),a		;0449	dd 77 0d	. w .
	ld a,(ix+00eh)		;044c	dd 7e 0e	. ~ .
	ld (ix+00bh),a		;044f	dd 77 0b	. w .
	ld a,(ix+00fh)		;0452	dd 7e 0f	. ~ .
	ld (ix+00ch),a		;0455	dd 77 0c	. w .
	ld a,(ix+010h)		;0458	dd 7e 10	. ~ .
	ld (ix+000h),a		;045b	dd 77 00	. w .
	jp l06e8h		;045e	c3 e8 06	. . .
l0461h:
	bit 7,(ix+000h)		;0461	dd cb 00 7e	. . . ~
	jp nz,l06e8h		;0465	c2 e8 06	. . .
	ld a,(ix+006h)		;0468	dd 7e 06	. ~ .
	cp 020h			;046b	fe 20		.  
	jr z,l0492h		;046d	28 23		( #
	cp 010h			;046f	fe 10		. .
	jr z,l047fh		;0471	28 0c		( .
	dec (ix+007h)		;0473	dd 35 07	. 5 .
	jp nz,l06e8h		;0476	c2 e8 06	. . .
	ld (ix+007h),003h	;0479	dd 36 07 03	. 6 . .
	jr l0492h		;047d	18 13		. .
l047fh:
	in a,(005h)		;047f	db 05		. .
	ld b,a			;0481	47		G
	ld a,(5)		;0482	3a 05 00	: . .
	cp 0aah			;0485	fe aa		. .
	jr nz,l048dh		;0487	20 04		  .
	ld a,0ffh		;0489	3e ff		> .
	xor b			;048b	a8		.
	ld b,a			;048c	47		G
l048dh:
	bit 6,b			;048d	cb 70		. p
	jp z,l06e8h		;048f	ca e8 06	. . .
l0492h:
	ld a,(ix+013h)		;0492	dd 7e 13	. ~ .
	and a			;0495	a7		.
	jr nz,l04aeh		;0496	20 16		  .
	ld a,(ix+008h)		;0498	dd 7e 08	. ~ .
	and a			;049b	a7		.
	jr nz,l04aeh		;049c	20 10		  .
	set 0,(ix+000h)		;049e	dd cb 00 c6	. . . .
	ld a,(ix+019h)		;04a2	dd 7e 19	. ~ .
	cp 00ah			;04a5	fe 0a		. .
	jp nz,l06e8h		;04a7	c2 e8 06	. . .
	set 6,(ix+000h)		;04aa	dd cb 00 f6	. . . .
l04aeh:
	ld h,(ix+002h)		;04ae	dd 66 02	. f .
	ld l,(ix+001h)		;04b1	dd 6e 01	. n .
	ld de,0x2e		;04b4	11 2e 00	. . .
	add hl,de		;04b7	19		.
	bit 6,(hl)		;04b8	cb 76		. v
	jp z,l0581h		;04ba	ca 81 05	. . .
	bit 5,(hl)		;04bd	cb 6e		. n
	jp z,l0560h		;04bf	ca 60 05	. ` .
	push hl			;04c2	e5		.
	ld h,(ix+004h)		;04c3	dd 66 04	. f .
	ld l,(ix+003h)		;04c6	dd 6e 03	. n .
	add hl,de		;04c9	19		.
	ld b,h			;04ca	44		D
	ld c,l			;04cb	4d		M
	pop hl			;04cc	e1		.
	ld d,(ix+002h)		;04cd	dd 56 02	. V .
	ld e,(ix+001h)		;04d0	dd 5e 01	. ^ .
	ldir			;04d3	ed b0		. .
l04d5h:
	ld a,(ix+013h)		;04d5	dd 7e 13	. ~ .
	and a			;04d8	a7		.
	jr nz,l0552h		;04d9	20 77		  w
	ld h,(ix+012h)		;04db	dd 66 12	. f .
	ld l,(ix+011h)		;04de	dd 6e 11	. n .
	bit 6,(ix+000h)		;04e1	dd cb 00 76	. . . v
	jr nz,l053dh		;04e5	20 56		  V
	ld a,(ix+00ch)		;04e7	dd 7e 0c	. ~ .
	ld (ix+013h),a		;04ea	dd 77 13	. w .
	ld a,(ix+009h)		;04ed	dd 7e 09	. ~ .
	call SOMETHING_MEM	;04f0	cd 1a 0f	. . .
	call sub_0607h		;04f3	cd 07 06	. . .
	call sub_061eh		;04f6	cd 1e 06	. . .
	inc de			;04f9	13		.
	ld bc,00028h		;04fa	01 28 00	. ( .
	ld h,(ix+00bh)		;04fd	dd 66 0b	. f .
	ld l,(ix+00ah)		;0500	dd 6e 0a	. n .
	ldir			;0503	ed b0		. .
	ex de,hl		;0505	eb		.
	ld a,(ix+010h)		;0506	dd 7e 10	. ~ .
	ld (hl),038h		;0509	36 38		6 8
	inc hl			;050b	23		#
	ld (hl),a		;050c	77		w
	inc hl			;050d	23		#
	ld a,(ix+01ch)		;050e	dd 7e 1c	. ~ .
	and 0c0h		;0511	e6 c0		. .
	or 03fh			;0513	f6 3f		. ?
	ld (hl),a		;0515	77		w
	ld (ix+008h),000h	;0516	dd 36 08 00	. 6 . .
	set 0,(ix+005h)		;051a	dd cb 05 c6	. . . .
	ld a,(ix+00dh)		;051e	dd 7e 0d	. ~ .
	ld (ix+011h),a		;0521	dd 77 11	. w .
	ld a,(ix+00eh)		;0524	dd 7e 0e	. ~ .
	ld (ix+012h),a		;0527	dd 77 12	. w .
	ld a,(ix+00fh)		;052a	dd 7e 0f	. ~ .
	ld (ix+014h),a		;052d	dd 77 14	. w .
	ld a,(ix+01ch)		;0530	dd 7e 1c	. ~ .
	ld (ix+01bh),a		;0533	dd 77 1b	. w .
l0536h:
	set 1,(ix+005h)		;0536	dd cb 05 ce	. . . .
	jp l06e8h		;053a	c3 e8 06	. . .
l053dh:
	call sub_0607h		;053d	cd 07 06	. . .
	call sub_061eh		;0540	cd 1e 06	. . .
	set 1,(ix+005h)		;0543	dd cb 05 ce	. . . .
	set 7,(ix+000h)		;0547	dd cb 00 fe	. . . .
	res 6,(ix+000h)		;054b	dd cb 00 b6	. . . .
	jp l06e8h		;054f	c3 e8 06	. . .
l0552h:
	dec (ix+013h)		;0552	dd 35 13	. 5 .
	ld h,(ix+012h)		;0555	dd 66 12	. f .
	ld l,(ix+011h)		;0558	dd 6e 11	. n .
	call sub_0607h		;055b	cd 07 06	. . .
	jr l0536h		;055e	18 d6		. .
l0560h:
	ld d,(ix+002h)		;0560	dd 56 02	. V .
	ld e,(ix+001h)		;0563	dd 5e 01	. ^ .
	call sub_05fch		;0566	cd fc 05	. . .
	ld bc,3		;0569	01 03 00	. . .
	ldir			;056c	ed b0		. .
	dec hl			;056e	2b		+
	dec hl			;056f	2b		+
	dec hl			;0570	2b		+
	ex de,hl		;0571	eb		.
	ld hl,0x2e		;0572	21 2e 00	! . .
	add hl,de		;0575	19		.
	ld b,(ix+004h)		;0576	dd 46 04	. F .
	ld c,(ix+003h)		;0579	dd 4e 03	. N .
	ldir			;057c	ed b0		. .
	jp l04d5h		;057e	c3 d5 04	. . .
l0581h:
	push hl			;0581	e5		.
	call sub_05fch		;0582	cd fc 05	. . .
	ld d,(ix+002h)		;0585	dd 56 02	. V .
	ld e,(ix+001h)		;0588	dd 5e 01	. ^ .
	ld bc,3		;058b	01 03 00	. . .
	ldir			;058e	ed b0		. .
	pop de			;0590	d1		.
	ld b,(ix+004h)		;0591	dd 46 04	. F .
	ld c,(ix+003h)		;0594	dd 4e 03	. N .
	ldir			;0597	ed b0		. .
	bit 1,(ix+005h)		;0599	dd cb 05 4e	. . . N
	jr z,l05f3h		;059d	28 54		( T
	dec de			;059f	1b		.
	dec de			;05a0	1b		.
	dec de			;05a1	1b		.
	ld a,(de)		;05a2	1a		.
	and 01fh		;05a3	e6 1f		. .
	ld (de),a		;05a5	12		.
	inc de			;05a6	13		.
	ld a,(de)		;05a7	1a		.
	and 01fh		;05a8	e6 1f		. .
	ld (de),a		;05aa	12		.
	inc de			;05ab	13		.
	inc de			;05ac	13		.
	bit 0,(ix+005h)		;05ad	dd cb 05 46	. . . F
	jr z,l05efh		;05b1	28 3c		( <
	ld a,060h		;05b3	3e 60		> `
l05b5h:
	ld h,(ix+012h)		;05b5	dd 66 12	. f .
	ld l,(ix+011h)		;05b8	dd 6e 11	. n .
	or (hl)			;05bb	b6		.
	ld (de),a		;05bc	12		.
	inc hl			;05bd	23		#
	inc de			;05be	13		.
	and 0e0h		;05bf	e6 e0		. .
	or (hl)			;05c1	b6		.
	ld (de),a		;05c2	12		.
	inc de			;05c3	13		.
	inc hl			;05c4	23		#
	ld (ix+012h),h		;05c5	dd 74 12	. t .
	ld (ix+011h),l		;05c8	dd 75 11	. u .
	and 060h		;05cb	e6 60		. `
	cp 060h			;05cd	fe 60		. `
	jr nz,l05e3h		;05cf	20 12		  .
	ld a,(ix+01bh)		;05d1	dd 7e 1b	. ~ .
	bit 4,a			;05d4	cb 67		. g
	jr z,l05e3h		;05d6	28 0b		( .
	and 007h		;05d8	e6 07		. .
	ld b,a			;05da	47		G
	ld a,(ix+014h)		;05db	dd 7e 14	. ~ .
	and 0f8h		;05de	e6 f8		. .
	or b			;05e0	b0		.
	jr l05e6h		;05e1	18 03		. .
l05e3h:
	ld a,(ix+014h)		;05e3	dd 7e 14	. ~ .
l05e6h:
	ld (de),a		;05e6	12		.
	ld a,000h		;05e7	3e 00		> .
	ld (ix+005h),a		;05e9	dd 77 05	. w .
	jp l06e8h		;05ec	c3 e8 06	. . .
l05efh:
	ld a,040h		;05ef	3e 40		> @
	jr l05b5h		;05f1	18 c2		. .
l05f3h:
	ld bc,0x2b		;05f3	01 2b 00	. + .
	ldir			;05f6	ed b0		. .
	ld a,000h		;05f8	3e 00		> .
	jr l05b5h		;05fa	18 b9		. .
sub_05fch:
	ld a,(hl)		;05fc	7e		~
	or 060h			;05fd	f6 60		. `
	ld (hl),a		;05ff	77		w
	inc hl			;0600	23		#
	ld a,(hl)		;0601	7e		~
	or 060h			;0602	f6 60		. `
	ld (hl),a		;0604	77		w
	dec hl			;0605	2b		+
l0606h:
	ret			;0606	c9		.
sub_0607h:
	ld a,(hl)		;0607	7e		~
	or 040h			;0608	f6 40		. @
	ld (de),a		;060a	12		.
	inc hl			;060b	23		#
	inc de			;060c	13		.
	ld a,(hl)		;060d	7e		~
	or 040h			;060e	f6 40		. @
	ld (de),a		;0610	12		.
	inc de			;0611	13		.
	inc hl			;0612	23		#
	ld (ix+012h),h		;0613	dd 74 12	. t .
	ld (ix+011h),l		;0616	dd 75 11	. u .
	ld a,(ix+014h)		;0619	dd 7e 14	. ~ .
	ld (de),a		;061c	12		.
	ret			;061d	c9		.
sub_061eh:
	and 0f8h		;061e	e6 f8		. .
	ld b,a			;0620	47		G
	ld a,(ix+01bh)		;0621	dd 7e 1b	. ~ .
	bit 3,a			;0624	cb 5f		. _
	ret z			;0626	c8		.
	and 007h		;0627	e6 07		. .
	or b			;0629	b0		.
	ld (de),a		;062a	12		.
	ret			;062b	c9		.
l062ch:
	nop			;062c	00		.
l062dh:
	dec (ix+000h)		;062d	dd 35 00	. 5 .
	jp nz,l06e8h		;0630	c2 e8 06	. . .
	ld a,(ix+009h)		;0633	dd 7e 09	. ~ .
	ld (ix+000h),a		;0636	dd 77 00	. w .
	ld h,(ix+002h)		;0639	dd 66 02	. f .
	ld l,(ix+001h)		;063c	dd 6e 01	. n .
	ld d,(ix+004h)		;063f	dd 56 04	. V .
	ld e,(ix+003h)		;0642	dd 5e 03	. ^ .
	ld a,(ix+00ah)		;0645	dd 7e 0a	. ~ .
	call SOMETHING_MEM	;0648	cd 1a 0f	. . .
	ld bc,1		;064b	01 01 00	. . .
	ld a,(ix+01dh)		;064e	dd 7e 1d	. ~ .
	cp 002h			;0651	fe 02		. .
	jr nz,l065ch		;0653	20 07		  .
	ld c,(ix+007h)		;0655	dd 4e 07	. N .
	ld (ix+006h),001h	;0658	dd 36 06 01	. 6 . .
l065ch:
	ldir			;065c	ed b0		. .
	call sub_06dbh		;065e	cd db 06	. . .
	dec (ix+006h)		;0661	dd 35 06	. 5 .
	jp nz,l06e8h		;0664	c2 e8 06	. . .
	ld b,(ix+007h)		;0667	dd 46 07	. F .
	ld a,028h		;066a	3e 28		> (
	sub b			;066c	90		.
	ld c,a			;066d	4f		O
	ld b,000h		;066e	06 00		. .
	add hl,bc		;0670	09		.
	call sub_06dbh		;0671	cd db 06	. . .
	ld hl,24		;0674	21 18 00	! . .
	add hl,bc		;0677	09		.
l0678h:
	add hl,de		;0678	19		.
	dec (ix+008h)		;0679	dd 35 08	. 5 .
	jr z,l06d5h		;067c	28 57		( W
	bit 5,(hl)		;067e	cb 6e		. n
	jr nz,l0687h		;0680	20 05		  .
	ld de,l0043h		;0682	11 43 00	. C .
	jr l0678h		;0685	18 f1		. .
l0687h:
	inc hl			;0687	23		#
	inc hl			;0688	23		#
	inc hl			;0689	23		#
	ld (ix+004h),h		;068a	dd 74 04	. t .
	ld (ix+003h),l		;068d	dd 75 03	. u .
	ld de,41		;0690	11 29 00	. ) .
	add hl,de		;0693	19		.
	ld a,(hl)		;0694	7e		~
	bit 3,a			;0695	cb 5f		. _
	jr nz,l069dh		;0697	20 04		  .
	ld a,028h		;0699	3e 28		> (
	jr l06a7h		;069b	18 0a		. .
l069dh:
	and 007h		;069d	e6 07		. .
	ld c,a			;069f	4f		O
	ld b,000h		;06a0	06 00		. .
	ld hl,l22e1h		;06a2	21 e1 22	! . "
	add hl,bc		;06a5	09		.
	ld a,(hl)		;06a6	7e		~
l06a7h:
	ld (ix+007h),a		;06a7	dd 77 07	. w .
	ld (ix+006h),a		;06aa	dd 77 06	. w .
	dec (ix+005h)		;06ad	dd 35 05	. 5 .
	jr nz,l06e8h		;06b0	20 36		  6
	ld h,(ix+002h)		;06b2	dd 66 02	. f .
	ld l,(ix+001h)		;06b5	dd 6e 01	. n .
	ld a,(ix+00ah)		;06b8	dd 7e 0a	. ~ .
	call sub_0f26h		;06bb	cd 26 0f	. & .
	ld (ix+00ah),a		;06be	dd 77 0a	. w .
	bit 1,(hl)		;06c1	cb 4e		. N
	jr z,l06d5h		;06c3	28 10		( .
	ld de,0x30		;06c5	11 30 00	. 0 .
	add hl,de		;06c8	19		.
	ld (ix+005h),008h	;06c9	dd 36 05 08	. 6 . .
	ld (ix+002h),h		;06cd	dd 74 02	. t .
	ld (ix+001h),l		;06d0	dd 75 01	. u .
	jr l06e8h		;06d3	18 13		. .
l06d5h:
	ld (ix+01dh),000h	;06d5	dd 36 1d 00	. 6 . .
	jr l06e8h		;06d9	18 0d		. .
sub_06dbh:
	ld (ix+002h),h		;06db	dd 74 02	. t .
	ld (ix+001h),l		;06de	dd 75 01	. u .
	ld (ix+004h),d		;06e1	dd 72 04	. r .
	ld (ix+003h),e		;06e4	dd 73 03	. s .
	ret			;06e7	c9		.
l06e8h:
	ld bc,30		;06e8	01 1e 00	. . .
	add ix,bc		;06eb	dd 09		. .
	ld hl,05687h		;06ed	21 87 56	! . V
	dec (hl)		;06f0	35		5
	jp nz,l03bfh		;06f1	c2 bf 03	. . .
	di			;06f4	f3		.
	ld a,000h		;06f5	3e 00		> .
	ld (05b6eh),a		;06f7	32 6e 5b	2 n [
l06fah:
	pop af			;06fa	f1		.
	call SOMETHING_MEM	;06fb	cd 1a 0f	. . .
	pop iy			;06fe	fd e1		. .
	pop ix			;0700	dd e1		. .
	pop hl			;0702	e1		.
	pop de			;0703	d1		.
	pop bc			;0704	c1		.
	pop af			;0705	f1		.
	call sub_0364h		;0706	cd 64 03	. d .
	ret			;0709	c9		.
; Out to port 0x62
OUT_DATA62:
	add a,e			;070a	83		.
	jp 0c3c3h		;070b	c3 c3 c3	. . .
	jp 0c3c3h		;070e	c3 c3 c3	. . .
	ld a,(hl)		;0711	7e		~
	inc hl			;0712	23		#
	ld b,c			;0713	41		A
	nop			;0714	00		.
	ld a,(bc)		;0715	0a		.
	inc d			;0716	14		.
	sub b			;0717	90		.
	rst 38h			;0718	ff		.
	pop bc			;0719	c1		.
	sub d			;071a	92		.
	rst 8			;071b	cf		.
	add a,a			;071c	87		.
	nop			;071d	00		.
	nop			;071e	00		.
sub_071fh:
	ld e,000h		;071f	1e 00		. .
	ld c,000h		;0721	0e 00		. .
	ld b,009h		;0723	06 09		. .
l0725h:
	call sub_0f20h		;0725	cd 20 0f	.   .
	ld a,001h		;0728	3e 01		> .
	scf			;072a	37		7
	jp p,l072fh		;072b	f2 2f 07	. / .
	xor a			;072e	af		.
l072fh:
	rl c			;072f	cb 11		. .
	jr nc,l073ah		;0731	30 07		0 .
	ld a,000h		;0733	3e 00		> .
	ld hl,COLD_START	;0735	21 00 00	! . .
	jr l0747h		;0738	18 0d		. .
l073ah:
	or a			;073a	b7		.
	jr z,l0740h		;073b	28 03		( .
	xor a			;073d	af		.
	sbc hl,de		;073e	ed 52		. R
l0740h:
	srl d			;0740	cb 3a		. :
	rr e			;0742	cb 1b		. .
	djnz l0725h		;0744	10 df		. .
	ld a,c			;0746	79		y
l0747h:
	ret			;0747	c9		.
sub_0748h:
	push bc			;0748	c5		.
	push de			;0749	d5		.
	push af			;074a	f5		.
	ld a,001h		;074b	3e 01		> .
	ld (0602ah),a		;074d	32 2a 60	2 * `
	ld de,(05b77h)		;0750	ed 5b 77 5b	. [ w [
	inc de			;0754	13		.
	call sub_0f20h		;0755	cd 20 0f	.   .
	pop bc			;0758	c1		.
	jp c,l0807h		;0759	da 07 08	. . .
	ld a,(05b84h)		;075c	3a 84 5b	: . [
	and 080h		;075f	e6 80		. .
	jp z,l0836h		;0761	ca 36 08	. 6 .
	push bc			;0764	c5		.
	push hl			;0765	e5		.
	ex de,hl		;0766	eb		.
	call sub_09e4h		;0767	cd e4 09	. . .
	ex de,hl		;076a	eb		.
	dec hl			;076b	2b		+
	xor a			;076c	af		.
	sbc hl,de		;076d	ed 52		. R
	jp c,l0834h		;076f	da 34 08	. 4 .
	inc hl			;0772	23		#
	pop de			;0773	d1		.
	ld (05fe5h),hl		;0774	22 e5 5f	" . _
	ld b,010h		;0777	06 10		. .
	ld c,000h		;0779	0e 00		. .
	ld hl,05fe9h		;077b	21 e9 5f	! . _
l077eh:
	ld a,(hl)		;077e	7e		~
	cp e			;077f	bb		.
	inc hl			;0780	23		#
	jr nz,l078fh		;0781	20 0c		  .
	ld a,(hl)		;0783	7e		~
	cp d			;0784	ba		.
	inc hl			;0785	23		#
	jr nz,l0790h		;0786	20 08		  .
	pop af			;0788	f1		.
	cp (hl)			;0789	be		.
	jr z,l07ceh		;078a	28 42		( B
	push af			;078c	f5		.
	jr l0790h		;078d	18 01		. .
l078fh:
	inc hl			;078f	23		#
l0790h:
	call sub_07eeh		;0790	cd ee 07	. . .
	djnz l077eh		;0793	10 e9		. .
	ld b,010h		;0795	06 10		. .
	ld c,000h		;0797	0e 00		. .
	ld hl,05fe9h		;0799	21 e9 5f	! . _
l079ch:
	ld a,(hl)		;079c	7e		~
	inc hl			;079d	23		#
	or (hl)			;079e	b6		.
	jr z,l07a9h		;079f	28 08		( .
	inc hl			;07a1	23		#
	call sub_07eeh		;07a2	cd ee 07	. . .
	djnz l079ch		;07a5	10 f5		. .
	jr l07e5h		;07a7	18 3c		. <
l07a9h:
	ld a,(05fe1h)		;07a9	3a e1 5f	: . _
	or a			;07ac	b7		.
	jr nz,l07e5h		;07ad	20 36		  6
	dec hl			;07af	2b		+
	ld (hl),e		;07b0	73		s
	inc hl			;07b1	23		#
	ld (hl),d		;07b2	72		r
	pop af			;07b3	f1		.
	inc hl			;07b4	23		#
	ld (hl),a		;07b5	77		w
	ld (05fe1h),a		;07b6	32 e1 5f	2 . _
	inc hl			;07b9	23		#
	ld (0602ch),hl		;07ba	22 2c 60	" , `
	ld hl,(05b85h)		;07bd	2a 85 5b	* . [
	ld b,000h		;07c0	06 00		. .
	add hl,bc		;07c2	09		.
	ld (05fe2h),hl		;07c3	22 e2 5f	" . _
	ld hl,(05fe5h)		;07c6	2a e5 5f	* . _
	ld (05fe7h),hl		;07c9	22 e7 5f	" . _
	jr l07e6h		;07cc	18 18		. .
l07ceh:
	ld a,(05fe1h)		;07ce	3a e1 5f	: . _
	cp (hl)			;07d1	be		.
	jr z,l07e6h		;07d2	28 12		( .
	inc hl			;07d4	23		#
	ld a,(hl)		;07d5	7e		~
	ld (0602ah),a		;07d6	32 2a 60	2 * `
	xor a			;07d9	af		.
	ld (0602bh),a		;07da	32 2b 60	2 + `
	ld hl,(05b85h)		;07dd	2a 85 5b	* . [
	ld b,000h		;07e0	06 00		. .
	add hl,bc		;07e2	09		.
	jr l0807h		;07e3	18 22		. "
l07e5h:
	pop hl			;07e5	e1		.
l07e6h:
	ld a,0feh		;07e6	3e fe		> .
	ld hl,COLD_START	;07e8	21 00 00	! . .
	pop de			;07eb	d1		.
	pop bc			;07ec	c1		.
	ret			;07ed	c9		.
sub_07eeh:
	inc hl			;07ee	23		#
	inc hl			;07ef	23		#
	ld a,c			;07f0	79		y
	add a,004h		;07f1	c6 04		. .
	ld c,a			;07f3	4f		O
	ret			;07f4	c9		.
sub_07f5h:
	push bc			;07f5	c5		.
	push de			;07f6	d5		.
	jr l0807h		;07f7	18 0e		. .
sub_07f9h:
	push bc			;07f9	c5		.
	push de			;07fa	d5		.
	ld de,(05b77h)		;07fb	ed 5b 77 5b	. [ w [
	dec de			;07ff	1b		.
	ex de,hl		;0800	eb		.
	call sub_0f20h		;0801	cd 20 0f	.   .
	ex de,hl		;0804	eb		.
	jr c,l0836h		;0805	38 2f		8 /
l0807h:
	ld de,21		;0807	11 15 00	. . .
	xor a			;080a	af		.
	sbc hl,de		;080b	ed 52		. R
	jp p,l0818h		;080d	f2 18 08	. . .
	add hl,de		;0810	19		.
	ld de,060deh		;0811	11 de 60	. . `
	push af			;0814	f5		.
	push hl			;0815	e5		.
	jr l0840h		;0816	18 28		. (
l0818h:
	ld d,02ch		;0818	16 2c		. ,
	call sub_071fh		;081a	cd 1f 07	. . .
	add a,004h		;081d	c6 04		. .
	ld c,a			;081f	4f		O
	ld a,(05b87h)		;0820	3a 87 5b	: . [
	inc a			;0823	3c		<
	ld b,a			;0824	47		G
	ld a,c			;0825	79		y
	cp b			;0826	b8		.
	jr c,l0830h		;0827	38 07		8 .
	ld c,b			;0829	48		H
	sub c			;082a	91		.
	inc a			;082b	3c		<
	cp 004h			;082c	fe 04		. .
	jr nc,l0836h		;082e	30 06		0 .
l0830h:
	push af			;0830	f5		.
	push hl			;0831	e5		.
	jr l083dh		;0832	18 09		. .
l0834h:
	pop hl			;0834	e1		.
	pop af			;0835	f1		.
l0836h:
	ld hl,COLD_START	;0836	21 00 00	! . .
	ld a,0ffh		;0839	3e ff		> .
	jr l0846h		;083b	18 09		. .
l083dh:
	ld de,0c000h		;083d	11 00 c0	. . .
l0840h:
	pop hl			;0840	e1		.
	call sub_0958h		;0841	cd 58 09	. X .
	pop af			;0844	f1		.
	add hl,de		;0845	19		.
l0846h:
	pop de			;0846	d1		.
	pop bc			;0847	c1		.
	ret			;0848	c9		.
sub_0849h:
	ld bc,1		;0849	01 01 00	. . .
	ld hl,1		;084c	21 01 00	! . .
	call sub_07f9h		;084f	cd f9 07	. . .
l0852h:
	ld de,l0170h		;0852	11 70 01	. p .
	add hl,de		;0855	19		.
	push hl			;0856	e5		.
	inc bc			;0857	03		.
	ld h,b			;0858	60		`
	ld l,c			;0859	69		i
	call SOMETHING_MEM	;085a	cd 1a 0f	. . .
	call sub_07f9h		;085d	cd f9 07	. . .
	cp 0ffh			;0860	fe ff		. .
	pop de			;0862	d1		.
	jr z,l086ah		;0863	28 05		( .
	call sub_0f20h		;0865	cd 20 0f	.   .
	jr z,l0852h		;0868	28 e8		( .
l086ah:
	ex de,hl		;086a	eb		.
	ld (hl),0ffh		;086b	36 ff		6 .
	inc hl			;086d	23		#
	ld (hl),0aah		;086e	36 aa		6 .
	inc hl			;0870	23		#
	ld (hl),a		;0871	77		w
	inc hl			;0872	23		#
	ld (hl),e		;0873	73		s
	inc hl			;0874	23		#
	ld (hl),d		;0875	72		r
	ex de,hl		;0876	eb		.
	cp 0ffh			;0877	fe ff		. .
	jr nz,l0852h		;0879	20 d7		  .
	ret			;087b	c9		.
sub_087ch:
	push bc			;087c	c5		.
	push de			;087d	d5		.
	push hl			;087e	e5		.
	ld b,010h		;087f	06 10		. .
	ex de,hl		;0881	eb		.
	ld hl,05fe9h		;0882	21 e9 5f	! . _
l0885h:
	and a			;0885	a7		.
	push af			;0886	f5		.
	jr z,l089ah		;0887	28 11		( .
	ld a,(hl)		;0889	7e		~
	cp e			;088a	bb		.
	inc hl			;088b	23		#
	jr nz,l08a4h		;088c	20 16		  .
	ld a,(hl)		;088e	7e		~
	cp d			;088f	ba		.
	jr nz,l08a4h		;0890	20 12		  .
	inc hl			;0892	23		#
	pop af			;0893	f1		.
	push af			;0894	f5		.
	cp (hl)			;0895	be		.
	jr nz,l08a5h		;0896	20 0d		  .
	dec hl			;0898	2b		+
	dec hl			;0899	2b		+
l089ah:
	xor a			;089a	af		.
	ld (hl),a		;089b	77		w
	inc hl			;089c	23		#
	ld (hl),a		;089d	77		w
	inc hl			;089e	23		#
	ld (hl),a		;089f	77		w
	inc hl			;08a0	23		#
	ld (hl),a		;08a1	77		w
	jr l08a6h		;08a2	18 02		. .
l08a4h:
	inc hl			;08a4	23		#
l08a5h:
	inc hl			;08a5	23		#
l08a6h:
	inc hl			;08a6	23		#
	pop af			;08a7	f1		.
	djnz l0885h		;08a8	10 db		. .
	pop hl			;08aa	e1		.
	pop de			;08ab	d1		.
	pop bc			;08ac	c1		.
	ret			;08ad	c9		.
l08aeh:
	ld sp,05249h		;08ae	31 49 52	1 I R
	ld b,007h		;08b1	06 07		. .
l08b3h:
	call sub_0334h		;08b3	cd 34 03	. 4 .
	djnz l08b3h		;08b6	10 fb		. .
	ld hl,l08aeh		;08b8	21 ae 08	! . .
	push hl			;08bb	e5		.
	ld a,(05fe1h)		;08bc	3a e1 5f	: . _
	or a			;08bf	b7		.
	ret z			;08c0	c8		.
	ld a,(05fe0h)		;08c1	3a e0 5f	: . _
	and a			;08c4	a7		.
	jr nz,l08dfh		;08c5	20 18		  .
	ld a,042h		;08c7	3e 42		> B
	ld (05cc1h),a		;08c9	32 c1 5c	2 . \
	call sub_094dh		;08cc	cd 4d 09	. M .
	ld a,003h		;08cf	3e 03		> .
	ld (05cbbh),a		;08d1	32 bb 5c	2 . \
	call 08910h		;08d4	cd 10 89	. . .
	and a			;08d7	a7		.
	ret nz			;08d8	c0		.
	ld a,001h		;08d9	3e 01		> .
	ld (05fe0h),a		;08db	32 e0 5f	2 . _
	ret			;08de	c9		.
l08dfh:
	ld a,(0602bh)		;08df	3a 2b 60	: + `
	and a			;08e2	a7		.
	jr nz,l08edh		;08e3	20 08		  .
	ld hl,(0602ch)		;08e5	2a 2c 60	* , `
	ld (hl),a		;08e8	77		w
	inc a			;08e9	3c		<
	ld (0602bh),a		;08ea	32 2b 60	2 + `
l08edh:
	ld a,007h		;08ed	3e 07		> .
	ld (05cbah),a		;08ef	32 ba 5c	2 . \
	ld hl,(05fe7h)		;08f2	2a e7 5f	* . _
	call sub_094dh		;08f5	cd 4d 09	. M .
	ld a,(05ea7h)		;08f8	3a a7 5e	: . ^
	ld (06029h),a		;08fb	32 29 60	2 ) `
	call 0887dh		;08fe	cd 7d 88	. } .
	cp 0feh			;0901	fe fe		. .
	ret z			;0903	c8		.
	push af			;0904	f5		.
	ld hl,(05fe2h)		;0905	2a e2 5f	* . _
	call sub_07f5h		;0908	cd f5 07	. . .
	call SOMETHING_MEM	;090b	cd 1a 0f	. . .
	ex de,hl		;090e	eb		.
	ld hl,05cc6h		;090f	21 c6 5c	! . \
	ld bc,l0170h		;0912	01 70 01	. p .
	ldir			;0915	ed b0		. .
	push hl			;0917	e5		.
	ld hl,(0602ch)		;0918	2a 2c 60	* , `
	inc (hl)		;091b	34		4
	ld a,(hl)		;091c	7e		~
	cp 004h			;091d	fe 04		. .
	pop hl			;091f	e1		.
	jr nc,l0941h		;0920	30 1f		0 .
	ld hl,(05fe2h)		;0922	2a e2 5f	* . _
	inc hl			;0925	23		#
	ld (05fe2h),hl		;0926	22 e2 5f	" . _
	call sub_07f5h		;0929	cd f5 07	. . .
	call SOMETHING_MEM	;092c	cd 1a 0f	. . .
	ld (hl),000h		;092f	36 00		6 .
	ld a,(05e36h)		;0931	3a 36 5e	: 6 ^
	bit 1,a			;0934	cb 4f		. O
	jr z,l0941h		;0936	28 09		( .
	ld hl,(05fe7h)		;0938	2a e7 5f	* . _
	inc hl			;093b	23		#
	ld (05fe7h),hl		;093c	22 e7 5f	" . _
	pop af			;093f	f1		.
	ret			;0940	c9		.
l0941h:
	xor a			;0941	af		.
	ld (0602bh),a		;0942	32 2b 60	2 + `
	ld (05fe1h),a		;0945	32 e1 5f	2 . _
	ld (05cbah),a		;0948	32 ba 5c	2 . \
	pop af			;094b	f1		.
	ret			;094c	c9		.
sub_094dh:
	ld a,044h		;094d	3e 44		> D
	ld (05cbfh),a		;094f	32 bf 5c	2 . \
	ld a,031h		;0952	3e 31		> 1
	ld (05cc0h),a		;0954	32 c0 5c	2 . \
	ret			;0957	c9		.
sub_0958h:
	push de			;0958	d5		.
	ld d,h			;0959	54		T
	ld e,l			;095a	5d		]
	add hl,hl		;095b	29		)
	add hl,hl		;095c	29		)
	add hl,de		;095d	19		.
	add hl,hl		;095e	29		)
	add hl,de		;095f	19		.
	add hl,hl		;0960	29		)
	add hl,de		;0961	19		.
	add hl,hl		;0962	29		)
	add hl,hl		;0963	29		)
	add hl,hl		;0964	29		)
	add hl,hl		;0965	29		)
	pop de			;0966	d1		.
	ret			;0967	c9		.
sub_0968h:
	push bc			;0968	c5		.
	push de			;0969	d5		.
	ld a,(CUR_MAP)		;096a	3a 22 41	: " A
	push af			;096d	f5		.
	ld a,002h		;096e	3e 02		> .
l0970h:
	push af			;0970	f5		.
	call SOMETHING_MEM	;0971	cd 1a 0f	. . .
	ld a,05ah		;0974	3e 5a		> Z
	ld hl,0fffbh		;0976	21 fb ff	! . .
	ld (hl),a		;0979	77		w
	ld a,(COLD_START)	;097a	3a 00 00	: . .
	ld a,(hl)		;097d	7e		~
	cp 05ah			;097e	fe 5a		. Z
	jr nz,l0995h		;0980	20 13		  .
	ld a,0a5h		;0982	3e a5		> .
	ld (hl),a		;0984	77		w
	ld a,(COLD_START)	;0985	3a 00 00	: . .
	ld a,(hl)		;0988	7e		~
	cp 0a5h			;0989	fe a5		. .
	jr nz,l0995h		;098b	20 08		  .
	pop af			;098d	f1		.
	inc a			;098e	3c		<
	jr nz,l0970h		;098f	20 df		  .
	ld a,0ffh		;0991	3e ff		> .
	jr l0997h		;0993	18 02		. .
l0995h:
	pop af			;0995	f1		.
	dec a			;0996	3d		=
l0997h:
	ld l,a			;0997	6f		o
	pop af			;0998	f1		.
	call SOMETHING_MEM	;0999	cd 1a 0f	. . .
	ld a,l			;099c	7d		}
	ld (05b87h),a		;099d	32 87 5b	2 . [
	ld c,000h		;09a0	0e 00		. .
	ld de,0x2c		;09a2	11 2c 00	. , .
	call sub_09b1h		;09a5	cd b1 09	. . .
	push hl			;09a8	e5		.
	ret nz			;09a9	c0		.
	ld de,20		;09aa	11 14 00	. . .
	add hl,de		;09ad	19		.
	pop de			;09ae	d1		.
	pop bc			;09af	c1		.
	ret			;09b0	c9		.
sub_09b1h:
	ld (05fd9h),a		;09b1	32 d9 5f	2 . _
	ld (05fdbh),de		;09b4	ed 53 db 5f	. S . _
	ld (05fddh),hl		;09b8	22 dd 5f	" . _
	ld a,(CUR_MAP)		;09bb	3a 22 41	: " A
	ld (05fdfh),a		;09be	32 df 5f	2 . _
	pop hl			;09c1	e1		.
	ld e,(hl)		;09c2	5e		^
	inc hl			;09c3	23		#
	ld d,(hl)		;09c4	56		V
	inc hl			;09c5	23		#
	push hl			;09c6	e5		.
	ld hl,l09dbh		;09c7	21 db 09	! . .
	push hl			;09ca	e5		.
	push de			;09cb	d5		.
	xor a			;09cc	af		.
	call SOMETHING_MEM	;09cd	cd 1a 0f	. . .
	ld a,(05fd9h)		;09d0	3a d9 5f	: . _
	ld de,(05fdbh)		;09d3	ed 5b db 5f	. [ . _
	ld hl,(05fddh)		;09d7	2a dd 5f	* . _
	ret			;09da	c9		.
l09dbh:
	push af			;09db	f5		.
	ld a,(05fdfh)		;09dc	3a df 5f	: . _
	call SOMETHING_MEM	;09df	cd 1a 0f	. . .
	pop af			;09e2	f1		.
	ret			;09e3	c9		.
sub_09e4h:
	push af			;09e4	f5		.
	push bc			;09e5	c5		.
	push de			;09e6	d5		.
	ld bc,003e8h		;09e7	01 e8 03	. . .
	ld hl,COLD_START	;09ea	21 00 00	! . .
	ld de,(05b77h)		;09ed	ed 5b 77 5b	. [ w [
l09f1h:
	add hl,bc		;09f1	09		.
	call sub_0f20h		;09f2	cd 20 0f	.   .
	jr c,l09f1h		;09f5	38 fa		8 .
	pop de			;09f7	d1		.
	pop bc			;09f8	c1		.
	pop af			;09f9	f1		.
	ret			;09fa	c9		.
sub_09fbh:
	ld l,a			;09fb	6f		o
	ld a,(CUR_MAP)		;09fc	3a 22 41	: " A
	push af			;09ff	f5		.
	ld a,l			;0a00	7d		}
	call sub_0a09h		;0a01	cd 09 0a	. . .
	pop af			;0a04	f1		.
	ld (CUR_MAP),a		;0a05	32 22 41	2 " A
	ret			;0a08	c9		.
sub_0a09h:
	ld (04105h),de		;0a09	ed 53 05 41	. S . A
	ld (04107h),bc		;0a0d	ed 43 07 41	. C . A
	ld (04102h),a		;0a11	32 02 41	2 . A
	ld a,000h		;0a14	3e 00		> .
	ld (0410fh),a		;0a16	32 0f 41	2 . A
	ld hl,04108h		;0a19	21 08 41	! . A
	add hl,bc		;0a1c	09		.
	ld a,(hl)		;0a1d	7e		~
	or a			;0a1e	b7		.
	ret z			;0a1f	c8		.
	ld (040fdh),a		;0a20	32 fd 40	2 . @
	ld a,(04102h)		;0a23	3a 02 41	: . A
	or a			;0a26	b7		.
	jr nz,l0a37h		;0a27	20 0e		  .
	ld hl,04a4eh		;0a29	21 4e 4a	! N J
	ld (040feh),hl		;0a2c	22 fe 40	" . @
	ld hl,04ac6h		;0a2f	21 c6 4a	! . J
	ld (04100h),hl		;0a32	22 00 41	" . A
	jr l0a54h		;0a35	18 1d		. .
l0a37h:
	ld hl,16		;0a37	21 10 00	! . .
	add hl,de		;0a3a	19		.
	ld (040feh),hl		;0a3b	22 fe 40	" . @
	ld a,(04102h)		;0a3e	3a 02 41	: . A
	cp 001h			;0a41	fe 01		. .
	jr nz,l0a4eh		;0a43	20 09		  .
	ld de,32		;0a45	11 20 00	.   .
	add hl,de		;0a48	19		.
	ld (04100h),hl		;0a49	22 00 41	" . A
	jr l0a54h		;0a4c	18 06		. .
l0a4eh:
	ld hl,0575bh		;0a4e	21 5b 57	! [ W
	ld (04100h),hl		;0a51	22 00 41	" . A
l0a54h:
	ld hl,04114h		;0a54	21 14 41	! . A
	call sub_0db5h		;0a57	cd b5 0d	. . .
	push de			;0a5a	d5		.
	pop ix			;0a5b	dd e1		. .
	ld iy,(04100h)		;0a5d	fd 2a 00 41	. * . A
	ld hl,(040feh)		;0a61	2a fe 40	* . @
	ld (04103h),hl		;0a64	22 03 41	" . A
l0a67h:
	ld a,(040fdh)		;0a67	3a fd 40	: . @
	ld d,a			;0a6a	57		W
	or a			;0a6b	b7		.
	jp z,l0e72h		;0a6c	ca 72 0e	. r .
	ld hl,(04103h)		;0a6f	2a 03 41	* . A
	inc hl			;0a72	23		#
	ld a,(hl)		;0a73	7e		~
	and 007h		;0a74	e6 07		. .
	inc a			;0a76	3c		<
	ld b,a			;0a77	47		G
	ld e,0ffh		;0a78	1e ff		. .
l0a7ah:
	inc e			;0a7a	1c		.
	dec d			;0a7b	15		.
	jr z,l0a80h		;0a7c	28 02		( .
	djnz l0a7ah		;0a7e	10 fa		. .
l0a80h:
	ld a,d			;0a80	7a		z
	ld (040fdh),a		;0a81	32 fd 40	2 . @
	dec hl			;0a84	2b		+
	ld c,(hl)		;0a85	4e		N
	inc hl			;0a86	23		#
	ld a,(hl)		;0a87	7e		~
	and 0f8h		;0a88	e6 f8		. .
	rrca			;0a8a	0f		.
	rrca			;0a8b	0f		.
	rrca			;0a8c	0f		.
	ld (05bb2h),a		;0a8d	32 b2 5b	2 . [
	inc hl			;0a90	23		#
	ld a,(hl)		;0a91	7e		~
	inc hl			;0a92	23		#
	ld b,a			;0a93	47		G
	ld a,(hl)		;0a94	7e		~
	ld (05fd4h),a		;0a95	32 d4 5f	2 . _
	ld a,b			;0a98	78		x
	inc hl			;0a99	23		#
	ld (04103h),hl		;0a9a	22 03 41	" . A
	ld b,e			;0a9d	43		C
	ld d,000h		;0a9e	16 00		. .
	ld hl,l0b65h		;0aa0	21 65 0b	! e .
	add hl,de		;0aa3	19		.
	add hl,de		;0aa4	19		.
	ld e,(hl)		;0aa5	5e		^
	inc hl			;0aa6	23		#
	ld d,(hl)		;0aa7	56		V
	inc b			;0aa8	04		.
	ex de,hl		;0aa9	eb		.
	ld e,a			;0aaa	5f		_
	ld d,008h		;0aab	16 08		. .
	ld a,000h		;0aad	3e 00		> .
l0aafh:
	add a,d			;0aaf	82		.
	djnz l0aafh		;0ab0	10 fd		. .
	ld b,a			;0ab2	47		G
	ld a,(hl)		;0ab3	7e		~
	or 060h			;0ab4	f6 60		. `
	ld (ix+000h),a		;0ab6	dd 77 00	. w .
	inc hl			;0ab9	23		#
	ld a,(hl)		;0aba	7e		~
	or 060h			;0abb	f6 60		. `
	ld (ix+001h),a		;0abd	dd 77 01	. w .
	ld a,(05bb2h)		;0ac0	3a b2 5b	: . [
	bit 4,a			;0ac3	cb 67		. g
	jr z,l0acch		;0ac5	28 05		( .
	call sub_0b51h		;0ac7	cd 51 0b	. Q .
	jr l0acfh		;0aca	18 03		. .
l0acch:
	call sub_0b46h		;0acc	cd 46 0b	. F .
l0acfh:
	push bc			;0acf	c5		.
	ld b,028h		;0ad0	06 28		. (
l0ad2h:
	ld a,(iy+000h)		;0ad2	fd 7e 00	. ~ .
	ld (ix+000h),a		;0ad5	dd 77 00	. w .
	inc ix			;0ad8	dd 23		. #
	inc iy			;0ada	fd 23		. #
	djnz l0ad2h		;0adc	10 f4		. .
	ld (ix+000h),038h	;0ade	dd 36 00 38	. 6 . 8
	ld (ix+001h),e		;0ae2	dd 73 01	. s .
	ld a,(05fd4h)		;0ae5	3a d4 5f	: . _
	or 03fh			;0ae8	f6 3f		. ?
	ld (ix+002h),a		;0aea	dd 77 02	. w .
	inc ix			;0aed	dd 23		. #
	inc ix			;0aef	dd 23		. #
	inc ix			;0af1	dd 23		. #
	pop bc			;0af3	c1		.
	dec b			;0af4	05		.
l0af5h:
	ld a,b			;0af5	78		x
	and 007h		;0af6	e6 07		. .
	jr nz,l0b11h		;0af8	20 17		  .
	ld a,(hl)		;0afa	7e		~
	or 040h			;0afb	f6 40		. @
	ld (ix+000h),a		;0afd	dd 77 00	. w .
	inc hl			;0b00	23		#
	ld a,(hl)		;0b01	7e		~
	or 040h			;0b02	f6 40		. @
	ld (ix+001h),a		;0b04	dd 77 01	. w .
	call sub_0b46h		;0b07	cd 46 0b	. F .
	ld de,0x2b		;0b0a	11 2b 00	. + .
	add ix,de		;0b0d	dd 19		. .
	djnz l0af5h		;0b0f	10 e4		. .
l0b11h:
	ld a,b			;0b11	78		x
	cp 001h			;0b12	fe 01		. .
	jr nz,l0b28h		;0b14	20 12		  .
	ld a,(040fdh)		;0b16	3a fd 40	: . @
	or a			;0b19	b7		.
	jr nz,l0b28h		;0b1a	20 0c		  .
	ld a,(hl)		;0b1c	7e		~
	or 040h			;0b1d	f6 40		. @
	ld (ix+000h),a		;0b1f	dd 77 00	. w .
	inc hl			;0b22	23		#
	ld a,(hl)		;0b23	7e		~
	or 040h			;0b24	f6 40		. @
	jr l0b2eh		;0b26	18 06		. .
l0b28h:
	ld a,(hl)		;0b28	7e		~
	ld (ix+000h),a		;0b29	dd 77 00	. w .
	inc hl			;0b2c	23		#
	ld a,(hl)		;0b2d	7e		~
l0b2eh:
	ld (ix+001h),a		;0b2e	dd 77 01	. w .
	call sub_0b46h		;0b31	cd 46 0b	. F .
	djnz l0af5h		;0b34	10 bf		. .
	ld a,(05bb2h)		;0b36	3a b2 5b	: . [
	bit 3,a			;0b39	cb 5f		. _
	jp z,l0dbbh		;0b3b	ca bb 0d	. . .
l0b3eh:
	dec ix			;0b3e	dd 2b		. +
	call sub_0b55h		;0b40	cd 55 0b	. U .
	jp l0dbbh		;0b43	c3 bb 0d	. . .
sub_0b46h:
	inc hl			;0b46	23		#
	ld (ix+002h),c		;0b47	dd 71 02	. q .
	inc ix			;0b4a	dd 23		. #
	inc ix			;0b4c	dd 23		. #
	inc ix			;0b4e	dd 23		. #
	ret			;0b50	c9		.
sub_0b51h:
	inc ix			;0b51	dd 23		. #
	inc ix			;0b53	dd 23		. #
sub_0b55h:
	and 007h		;0b55	e6 07		. .
	push bc			;0b57	c5		.
	ld b,a			;0b58	47		G
	ld a,c			;0b59	79		y
	and 0f8h		;0b5a	e6 f8		. .
	or b			;0b5c	b0		.
	pop bc			;0b5d	c1		.
	inc hl			;0b5e	23		#
	ld (ix+000h),a		;0b5f	dd 77 00	. w .
	inc ix			;0b62	dd 23		. #
	ret			;0b64	c9		.
l0b65h:
	ld (hl),l		;0b65	75		u
	dec bc			;0b66	0b		.
	add a,l			;0b67	85		.
	dec bc			;0b68	0b		.
	and l			;0b69	a5		.
	dec bc			;0b6a	0b		.
	push de			;0b6b	d5		.
	dec bc			;0b6c	0b		.
	dec d			;0b6d	15		.
	inc c			;0b6e	0c		.
	ld h,l			;0b6f	65		e
	inc c			;0b70	0c		.
	push bc			;0b71	c5		.
	inc c			;0b72	0c		.
	dec (hl)		;0b73	35		5
	dec c			;0b74	0d		.
	nop			;0b75	00		.
	ld (bc),a		;0b76	02		.
	inc b			;0b77	04		.
	ld b,008h		;0b78	06 08		. .
	ld a,(bc)		;0b7a	0a		.
	inc c			;0b7b	0c		.
	ld c,010h		;0b7c	0e 10		. .
	ld (de),a		;0b7e	12		.
	inc d			;0b7f	14		.
	ld d,018h		;0b80	16 18		. .
	ld a,(de)		;0b82	1a		.
	inc e			;0b83	1c		.
	ld e,000h		;0b84	1e 00		. .
	ld bc,l0302h		;0b86	01 02 03	. . .
	inc b			;0b89	04		.
	dec b			;0b8a	05		.
	ld b,007h		;0b8b	06 07		. .
	ex af,af'		;0b8d	08		.
	add hl,bc		;0b8e	09		.
	ld a,(bc)		;0b8f	0a		.
	dec bc			;0b90	0b		.
	inc c			;0b91	0c		.
	dec c			;0b92	0d		.
	ld c,00fh		;0b93	0e 0f		. .
	djnz $+19		;0b95	10 11		. .
	ld (de),a		;0b97	12		.
	inc de			;0b98	13		.
	inc d			;0b99	14		.
	dec d			;0b9a	15		.
	ld d,017h		;0b9b	16 17		. .
	jr l0bb8h		;0b9d	18 19		. .
l0b9fh:
	ld a,(de)		;0b9f	1a		.
	dec de			;0ba0	1b		.
	inc e			;0ba1	1c		.
	dec e			;0ba2	1d		.
	ld e,01fh		;0ba3	1e 1f		. .
	nop			;0ba5	00		.
	add a,b			;0ba6	80		.
	ld bc,08202h		;0ba7	01 02 82	. . .
	inc bc			;0baa	03		.
	inc b			;0bab	04		.
	add a,h			;0bac	84		.
	dec b			;0bad	05		.
	ld b,086h		;0bae	06 86		. .
	rlca			;0bb0	07		.
	ex af,af'		;0bb1	08		.
	adc a,b			;0bb2	88		.
	add hl,bc		;0bb3	09		.
	ld a,(bc)		;0bb4	0a		.
	adc a,d			;0bb5	8a		.
	dec bc			;0bb6	0b		.
	inc c			;0bb7	0c		.
l0bb8h:
	adc a,h			;0bb8	8c		.
	dec c			;0bb9	0d		.
	ld c,08eh		;0bba	0e 8e		. .
	rrca			;0bbc	0f		.
	djnz $-110		;0bbd	10 90		. .
	ld de,09212h		;0bbf	11 12 92	. . .
	inc de			;0bc2	13		.
	inc d			;0bc3	14		.
	sub h			;0bc4	94		.
	dec d			;0bc5	15		.
	ld d,096h		;0bc6	16 96		. .
	rla			;0bc8	17		.
	jr $-102		;0bc9	18 98		. .
	add hl,de		;0bcb	19		.
	ld a,(de)		;0bcc	1a		.
	sbc a,d			;0bcd	9a		.
	dec de			;0bce	1b		.
	inc e			;0bcf	1c		.
	sbc a,h			;0bd0	9c		.
	dec e			;0bd1	1d		.
	ld e,09eh		;0bd2	1e 9e		. .
	rra			;0bd4	1f		.
	nop			;0bd5	00		.
	add a,b			;0bd6	80		.
	ld bc,l0281h		;0bd7	01 81 02	. . .
	add a,d			;0bda	82		.
	inc bc			;0bdb	03		.
	add a,e			;0bdc	83		.
	inc b			;0bdd	04		.
	add a,h			;0bde	84		.
	dec b			;0bdf	05		.
	add a,l			;0be0	85		.
	ld b,086h		;0be1	06 86		. .
	rlca			;0be3	07		.
	add a,a			;0be4	87		.
	ex af,af'		;0be5	08		.
	adc a,b			;0be6	88		.
	add hl,bc		;0be7	09		.
	adc a,c			;0be8	89		.
	ld a,(bc)		;0be9	0a		.
	adc a,d			;0bea	8a		.
	dec bc			;0beb	0b		.
	adc a,e			;0bec	8b		.
	inc c			;0bed	0c		.
	adc a,h			;0bee	8c		.
	dec c			;0bef	0d		.
	adc a,l			;0bf0	8d		.
	ld c,08eh		;0bf1	0e 8e		. .
	rrca			;0bf3	0f		.
	adc a,a			;0bf4	8f		.
	djnz $-110		;0bf5	10 90		. .
	ld de,01291h		;0bf7	11 91 12	. . .
	sub d			;0bfa	92		.
	inc de			;0bfb	13		.
	sub e			;0bfc	93		.
	inc d			;0bfd	14		.
	sub h			;0bfe	94		.
	dec d			;0bff	15		.
	sub l			;0c00	95		.
	ld d,096h		;0c01	16 96		. .
	rla			;0c03	17		.
	sub a			;0c04	97		.
	jr l0b9fh		;0c05	18 98		. .
	add hl,de		;0c07	19		.
	sbc a,c			;0c08	99		.
	ld a,(de)		;0c09	1a		.
	sbc a,d			;0c0a	9a		.
	dec de			;0c0b	1b		.
	sbc a,e			;0c0c	9b		.
	inc e			;0c0d	1c		.
	sbc a,h			;0c0e	9c		.
	dec e			;0c0f	1d		.
	sbc a,l			;0c10	9d		.
	ld e,09eh		;0c11	1e 9e		. .
	rra			;0c13	1f		.
	sbc a,a			;0c14	9f		.
	nop			;0c15	00		.
	nop			;0c16	00		.
	add a,b			;0c17	80		.
	ld bc,l0281h		;0c18	01 81 02	. . .
	ld (bc),a		;0c1b	02		.
	add a,d			;0c1c	82		.
	inc bc			;0c1d	03		.
	add a,e			;0c1e	83		.
	inc b			;0c1f	04		.
	inc b			;0c20	04		.
	add a,h			;0c21	84		.
	dec b			;0c22	05		.
	add a,l			;0c23	85		.
	ld b,006h		;0c24	06 06		. .
	add a,(hl)		;0c26	86		.
	rlca			;0c27	07		.
	add a,a			;0c28	87		.
	ex af,af'		;0c29	08		.
	ex af,af'		;0c2a	08		.
	adc a,b			;0c2b	88		.
	add hl,bc		;0c2c	09		.
	adc a,c			;0c2d	89		.
	ld a,(bc)		;0c2e	0a		.
	ld a,(bc)		;0c2f	0a		.
	adc a,d			;0c30	8a		.
	dec bc			;0c31	0b		.
	adc a,e			;0c32	8b		.
	inc c			;0c33	0c		.
	inc c			;0c34	0c		.
	adc a,h			;0c35	8c		.
	dec c			;0c36	0d		.
	adc a,l			;0c37	8d		.
	ld c,00eh		;0c38	0e 0e		. .
	adc a,(hl)		;0c3a	8e		.
	rrca			;0c3b	0f		.
	adc a,a			;0c3c	8f		.
	djnz l0c4fh		;0c3d	10 10		. .
	sub b			;0c3f	90		.
	ld de,01291h		;0c40	11 91 12	. . .
	ld (de),a		;0c43	12		.
	sub d			;0c44	92		.
	inc de			;0c45	13		.
	sub e			;0c46	93		.
	inc d			;0c47	14		.
	inc d			;0c48	14		.
	sub h			;0c49	94		.
	dec d			;0c4a	15		.
	sub l			;0c4b	95		.
	ld d,016h		;0c4c	16 16		. .
	sub (hl)		;0c4e	96		.
l0c4fh:
	rla			;0c4f	17		.
	sub a			;0c50	97		.
	jr l0c6bh		;0c51	18 18		. .
	sbc a,b			;0c53	98		.
	add hl,de		;0c54	19		.
	sbc a,c			;0c55	99		.
	ld a,(de)		;0c56	1a		.
	ld a,(de)		;0c57	1a		.
	sbc a,d			;0c58	9a		.
	dec de			;0c59	1b		.
	sbc a,e			;0c5a	9b		.
	inc e			;0c5b	1c		.
	inc e			;0c5c	1c		.
	sbc a,h			;0c5d	9c		.
	dec e			;0c5e	1d		.
	sbc a,l			;0c5f	9d		.
	ld e,01eh		;0c60	1e 1e		. .
	sbc a,(hl)		;0c62	9e		.
	rra			;0c63	1f		.
	sbc a,a			;0c64	9f		.
	nop			;0c65	00		.
	nop			;0c66	00		.
	add a,b			;0c67	80		.
	ld bc,08101h		;0c68	01 01 81	. . .
l0c6bh:
	ld (bc),a		;0c6b	02		.
	ld (bc),a		;0c6c	02		.
	add a,d			;0c6d	82		.
	inc bc			;0c6e	03		.
	inc bc			;0c6f	03		.
	add a,e			;0c70	83		.
	inc b			;0c71	04		.
	inc b			;0c72	04		.
	add a,h			;0c73	84		.
	dec b			;0c74	05		.
	dec b			;0c75	05		.
	add a,l			;0c76	85		.
	ld b,006h		;0c77	06 06		. .
	add a,(hl)		;0c79	86		.
	rlca			;0c7a	07		.
	rlca			;0c7b	07		.
	add a,a			;0c7c	87		.
	ex af,af'		;0c7d	08		.
	ex af,af'		;0c7e	08		.
	adc a,b			;0c7f	88		.
	add hl,bc		;0c80	09		.
	add hl,bc		;0c81	09		.
	adc a,c			;0c82	89		.
	ld a,(bc)		;0c83	0a		.
	ld a,(bc)		;0c84	0a		.
	adc a,d			;0c85	8a		.
	dec bc			;0c86	0b		.
	dec bc			;0c87	0b		.
	adc a,e			;0c88	8b		.
	inc c			;0c89	0c		.
	inc c			;0c8a	0c		.
	adc a,h			;0c8b	8c		.
	dec c			;0c8c	0d		.
	dec c			;0c8d	0d		.
	adc a,l			;0c8e	8d		.
	ld c,00eh		;0c8f	0e 0e		. .
	adc a,(hl)		;0c91	8e		.
	rrca			;0c92	0f		.
	rrca			;0c93	0f		.
	adc a,a			;0c94	8f		.
	djnz l0ca7h		;0c95	10 10		. .
	sub b			;0c97	90		.
	ld de,09111h		;0c98	11 11 91	. . .
	ld (de),a		;0c9b	12		.
	ld (de),a		;0c9c	12		.
	sub d			;0c9d	92		.
	inc de			;0c9e	13		.
	inc de			;0c9f	13		.
	sub e			;0ca0	93		.
	inc d			;0ca1	14		.
	inc d			;0ca2	14		.
	sub h			;0ca3	94		.
	dec d			;0ca4	15		.
	dec d			;0ca5	15		.
	sub l			;0ca6	95		.
l0ca7h:
	ld d,016h		;0ca7	16 16		. .
	sub (hl)		;0ca9	96		.
	rla			;0caa	17		.
	rla			;0cab	17		.
	sub a			;0cac	97		.
	jr l0cc7h		;0cad	18 18		. .
	sbc a,b			;0caf	98		.
	add hl,de		;0cb0	19		.
	add hl,de		;0cb1	19		.
	sbc a,c			;0cb2	99		.
	ld a,(de)		;0cb3	1a		.
	ld a,(de)		;0cb4	1a		.
	sbc a,d			;0cb5	9a		.
	dec de			;0cb6	1b		.
	dec de			;0cb7	1b		.
	sbc a,e			;0cb8	9b		.
	inc e			;0cb9	1c		.
	inc e			;0cba	1c		.
	sbc a,h			;0cbb	9c		.
	dec e			;0cbc	1d		.
	dec e			;0cbd	1d		.
	sbc a,l			;0cbe	9d		.
	ld e,01eh		;0cbf	1e 1e		. .
	sbc a,(hl)		;0cc1	9e		.
	rra			;0cc2	1f		.
	rra			;0cc3	1f		.
	sbc a,a			;0cc4	9f		.
	nop			;0cc5	00		.
	nop			;0cc6	00		.
l0cc7h:
	add a,b			;0cc7	80		.
	add a,b			;0cc8	80		.
	ld bc,08101h		;0cc9	01 01 81	. . .
	ld (bc),a		;0ccc	02		.
l0ccdh:
	ld (bc),a		;0ccd	02		.
	add a,d			;0cce	82		.
	add a,d			;0ccf	82		.
	inc bc			;0cd0	03		.
	inc bc			;0cd1	03		.
	add a,e			;0cd2	83		.
	inc b			;0cd3	04		.
	inc b			;0cd4	04		.
	add a,h			;0cd5	84		.
	add a,h			;0cd6	84		.
	dec b			;0cd7	05		.
	dec b			;0cd8	05		.
	add a,l			;0cd9	85		.
	ld b,006h		;0cda	06 06		. .
	add a,(hl)		;0cdc	86		.
	add a,(hl)		;0cdd	86		.
	rlca			;0cde	07		.
	rlca			;0cdf	07		.
	add a,a			;0ce0	87		.
	ex af,af'		;0ce1	08		.
	ex af,af'		;0ce2	08		.
	adc a,b			;0ce3	88		.
	adc a,b			;0ce4	88		.
	add hl,bc		;0ce5	09		.
	add hl,bc		;0ce6	09		.
	adc a,c			;0ce7	89		.
	ld a,(bc)		;0ce8	0a		.
	ld a,(bc)		;0ce9	0a		.
	adc a,d			;0cea	8a		.
	adc a,d			;0ceb	8a		.
	dec bc			;0cec	0b		.
	dec bc			;0ced	0b		.
	adc a,e			;0cee	8b		.
	inc c			;0cef	0c		.
	inc c			;0cf0	0c		.
	adc a,h			;0cf1	8c		.
	adc a,h			;0cf2	8c		.
	dec c			;0cf3	0d		.
	dec c			;0cf4	0d		.
	adc a,l			;0cf5	8d		.
	ld c,00eh		;0cf6	0e 0e		. .
	adc a,(hl)		;0cf8	8e		.
	adc a,(hl)		;0cf9	8e		.
	rrca			;0cfa	0f		.
	rrca			;0cfb	0f		.
	adc a,a			;0cfc	8f		.
	djnz l0d0fh		;0cfd	10 10		. .
	sub b			;0cff	90		.
	sub b			;0d00	90		.
	ld de,09111h		;0d01	11 11 91	. . .
	ld (de),a		;0d04	12		.
	ld (de),a		;0d05	12		.
	sub d			;0d06	92		.
	sub d			;0d07	92		.
	inc de			;0d08	13		.
	inc de			;0d09	13		.
	sub e			;0d0a	93		.
	inc d			;0d0b	14		.
	inc d			;0d0c	14		.
	sub h			;0d0d	94		.
	sub h			;0d0e	94		.
l0d0fh:
	dec d			;0d0f	15		.
	dec d			;0d10	15		.
	sub l			;0d11	95		.
	ld d,016h		;0d12	16 16		. .
	sub (hl)		;0d14	96		.
	sub (hl)		;0d15	96		.
	rla			;0d16	17		.
	rla			;0d17	17		.
	sub a			;0d18	97		.
	jr l0d33h		;0d19	18 18		. .
	sbc a,b			;0d1b	98		.
	sbc a,b			;0d1c	98		.
	add hl,de		;0d1d	19		.
	add hl,de		;0d1e	19		.
	sbc a,c			;0d1f	99		.
	ld a,(de)		;0d20	1a		.
	ld a,(de)		;0d21	1a		.
	sbc a,d			;0d22	9a		.
	sbc a,d			;0d23	9a		.
	dec de			;0d24	1b		.
	dec de			;0d25	1b		.
	sbc a,e			;0d26	9b		.
	inc e			;0d27	1c		.
	inc e			;0d28	1c		.
	sbc a,h			;0d29	9c		.
	sbc a,h			;0d2a	9c		.
	dec e			;0d2b	1d		.
	dec e			;0d2c	1d		.
	sbc a,l			;0d2d	9d		.
	ld e,01eh		;0d2e	1e 1e		. .
	sbc a,(hl)		;0d30	9e		.
	sbc a,(hl)		;0d31	9e		.
	rra			;0d32	1f		.
l0d33h:
	rra			;0d33	1f		.
	sbc a,a			;0d34	9f		.
	nop			;0d35	00		.
	nop			;0d36	00		.
	add a,b			;0d37	80		.
	add a,b			;0d38	80		.
	ld bc,08101h		;0d39	01 01 81	. . .
	add a,c			;0d3c	81		.
	ld (bc),a		;0d3d	02		.
	ld (bc),a		;0d3e	02		.
	add a,d			;0d3f	82		.
	add a,d			;0d40	82		.
	inc bc			;0d41	03		.
	inc bc			;0d42	03		.
	add a,e			;0d43	83		.
	add a,e			;0d44	83		.
	inc b			;0d45	04		.
	inc b			;0d46	04		.
	add a,h			;0d47	84		.
	add a,h			;0d48	84		.
	dec b			;0d49	05		.
	dec b			;0d4a	05		.
	add a,l			;0d4b	85		.
	add a,l			;0d4c	85		.
	ld b,006h		;0d4d	06 06		. .
	add a,(hl)		;0d4f	86		.
	add a,(hl)		;0d50	86		.
	rlca			;0d51	07		.
	rlca			;0d52	07		.
	add a,a			;0d53	87		.
	add a,a			;0d54	87		.
	ex af,af'		;0d55	08		.
	ex af,af'		;0d56	08		.
	adc a,b			;0d57	88		.
	adc a,b			;0d58	88		.
	add hl,bc		;0d59	09		.
	add hl,bc		;0d5a	09		.
	adc a,c			;0d5b	89		.
	adc a,c			;0d5c	89		.
	ld a,(bc)		;0d5d	0a		.
	ld a,(bc)		;0d5e	0a		.
	adc a,d			;0d5f	8a		.
	adc a,d			;0d60	8a		.
	dec bc			;0d61	0b		.
	dec bc			;0d62	0b		.
	adc a,e			;0d63	8b		.
	adc a,e			;0d64	8b		.
	inc c			;0d65	0c		.
	inc c			;0d66	0c		.
	adc a,h			;0d67	8c		.
	adc a,h			;0d68	8c		.
	dec c			;0d69	0d		.
	dec c			;0d6a	0d		.
	adc a,l			;0d6b	8d		.
	adc a,l			;0d6c	8d		.
	ld c,00eh		;0d6d	0e 0e		. .
	adc a,(hl)		;0d6f	8e		.
	adc a,(hl)		;0d70	8e		.
	rrca			;0d71	0f		.
	rrca			;0d72	0f		.
	adc a,a			;0d73	8f		.
	adc a,a			;0d74	8f		.
	djnz l0d87h		;0d75	10 10		. .
	sub b			;0d77	90		.
	sub b			;0d78	90		.
	ld de,09111h		;0d79	11 11 91	. . .
	sub c			;0d7c	91		.
	ld (de),a		;0d7d	12		.
	ld (de),a		;0d7e	12		.
	sub d			;0d7f	92		.
	sub d			;0d80	92		.
	inc de			;0d81	13		.
	inc de			;0d82	13		.
	sub e			;0d83	93		.
	sub e			;0d84	93		.
	inc d			;0d85	14		.
	inc d			;0d86	14		.
l0d87h:
	sub h			;0d87	94		.
	sub h			;0d88	94		.
	dec d			;0d89	15		.
	dec d			;0d8a	15		.
	sub l			;0d8b	95		.
	sub l			;0d8c	95		.
	ld d,016h		;0d8d	16 16		. .
	sub (hl)		;0d8f	96		.
	sub (hl)		;0d90	96		.
	rla			;0d91	17		.
	rla			;0d92	17		.
	sub a			;0d93	97		.
	sub a			;0d94	97		.
	jr l0dafh		;0d95	18 18		. .
	sbc a,b			;0d97	98		.
	sbc a,b			;0d98	98		.
	add hl,de		;0d99	19		.
	add hl,de		;0d9a	19		.
	sbc a,c			;0d9b	99		.
	sbc a,c			;0d9c	99		.
	ld a,(de)		;0d9d	1a		.
	ld a,(de)		;0d9e	1a		.
	sbc a,d			;0d9f	9a		.
	sbc a,d			;0da0	9a		.
	dec de			;0da1	1b		.
	dec de			;0da2	1b		.
	sbc a,e			;0da3	9b		.
	sbc a,e			;0da4	9b		.
	inc e			;0da5	1c		.
	inc e			;0da6	1c		.
	sbc a,h			;0da7	9c		.
	sbc a,h			;0da8	9c		.
	dec e			;0da9	1d		.
	dec e			;0daa	1d		.
	sbc a,l			;0dab	9d		.
	sbc a,l			;0dac	9d		.
	ld e,01eh		;0dad	1e 1e		. .
l0dafh:
	sbc a,(hl)		;0daf	9e		.
	sbc a,(hl)		;0db0	9e		.
	rra			;0db1	1f		.
	rra			;0db2	1f		.
	sbc a,a			;0db3	9f		.
	sbc a,a			;0db4	9f		.
sub_0db5h:
	add hl,bc		;0db5	09		.
	add hl,bc		;0db6	09		.
	ld e,(hl)		;0db7	5e		^
	inc hl			;0db8	23		#
	ld d,(hl)		;0db9	56		V
	ret			;0dba	c9		.
l0dbbh:
	ld a,(040fdh)		;0dbb	3a fd 40	: . @
	or a			;0dbe	b7		.
	jp z,l0e72h		;0dbf	ca 72 0e	. r .
	ld a,(0410fh)		;0dc2	3a 0f 41	: . A
	inc a			;0dc5	3c		<
	ld (0410fh),a		;0dc6	32 0f 41	2 . A
	cp 008h			;0dc9	fe 08		. .
	jp nz,l0a67h		;0dcb	c2 67 0a	. g .
	ld a,(04102h)		;0dce	3a 02 41	: . A
	or a			;0dd1	b7		.
	jp z,l0a67h		;0dd2	ca 67 0a	. g .
	ld hl,(04103h)		;0dd5	2a 03 41	* . A
	ld de,l0140h		;0dd8	11 40 01	. @ .
	add hl,de		;0ddb	19		.
	ld a,(CUR_MAP)		;0ddc	3a 22 41	: " A
	call sub_0f26h		;0ddf	cd 26 0f	. & .
	ld a,(hl)		;0de2	7e		~
	bit 1,a			;0de3	cb 4f		. O
	jr z,l0e05h		;0de5	28 1e		( .
	ld de,16		;0de7	11 10 00	. . .
	add hl,de		;0dea	19		.
	ld (04103h),hl		;0deb	22 03 41	" . A
	ld a,000h		;0dee	3e 00		> .
	ld (0410fh),a		;0df0	32 0f 41	2 . A
	ld a,(04102h)		;0df3	3a 02 41	: . A
	cp 001h			;0df6	fe 01		. .
	jp nz,l0a67h		;0df8	c2 67 0a	. g .
	ld de,32		;0dfb	11 20 00	.   .
	add hl,de		;0dfe	19		.
	push hl			;0dff	e5		.
	pop iy			;0e00	fd e1		. .
	jp l0a67h		;0e02	c3 67 0a	. g .
l0e05h:
	push ix			;0e05	dd e5		. .
	dec ix			;0e07	dd 2b		. +
	dec ix			;0e09	dd 2b		. +
	dec ix			;0e0b	dd 2b		. +
	dec ix			;0e0d	dd 2b		. +
	ld a,(ix+000h)		;0e0f	dd 7e 00	. ~ .
	ld c,a			;0e12	4f		O
	pop ix			;0e13	dd e1		. .
	ld a,(040fdh)		;0e15	3a fd 40	: . @
	ld b,a			;0e18	47		G
	ld de,COLD_START	;0e19	11 00 00	. . .
l0e1ch:
	ld a,060h		;0e1c	3e 60		> `
	ld (ix+000h),a		;0e1e	dd 77 00	. w .
	ld (ix+001h),a		;0e21	dd 77 01	. w .
	ld (ix+002h),c		;0e24	dd 71 02	. q .
	inc ix			;0e27	dd 23		. #
	inc ix			;0e29	dd 23		. #
	inc ix			;0e2b	dd 23		. #
	push bc			;0e2d	c5		.
	ld b,028h		;0e2e	06 28		. (
l0e30h:
	ld (ix+000h),020h	;0e30	dd 36 00 20	. 6 .  
	inc ix			;0e34	dd 23		. #
	djnz l0e30h		;0e36	10 f8		. .
	ld (ix+000h),038h	;0e38	dd 36 00 38	. 6 . 8
	ld (ix+001h),000h	;0e3c	dd 36 01 00	. 6 . .
	ld (ix+002h),03fh	;0e40	dd 36 02 3f	. 6 . ?
	inc ix			;0e44	dd 23		. #
	inc ix			;0e46	dd 23		. #
	inc ix			;0e48	dd 23		. #
	ld b,006h		;0e4a	06 06		. .
	ld e,002h		;0e4c	1e 02		. .
l0e4eh:
	ld (ix+000h),d		;0e4e	dd 72 00	. r .
	ld (ix+001h),d		;0e51	dd 72 01	. r .
	ld (ix+002h),c		;0e54	dd 71 02	. q .
	inc ix			;0e57	dd 23		. #
	inc ix			;0e59	dd 23		. #
	inc ix			;0e5b	dd 23		. #
	djnz l0e4eh		;0e5d	10 ef		. .
	dec e			;0e5f	1d		.
	jr z,l0e6fh		;0e60	28 0d		( .
	pop bc			;0e62	c1		.
	push bc			;0e63	c5		.
	ld a,b			;0e64	78		x
	cp 001h			;0e65	fe 01		. .
	ld b,001h		;0e67	06 01		. .
	jr nz,l0e4eh		;0e69	20 e3		  .
	set 6,d			;0e6b	cb f2		. .
	jr l0e4eh		;0e6d	18 df		. .
l0e6fh:
	pop bc			;0e6f	c1		.
	djnz l0e1ch		;0e70	10 aa		. .
l0e72h:
	dec ix			;0e72	dd 2b		. +
	dec ix			;0e74	dd 2b		. +
	dec ix			;0e76	dd 2b		. +
	ld a,(04107h)		;0e78	3a 07 41	: . A
	cp 001h			;0e7b	fe 01		. .
	jr nz,l0ea2h		;0e7d	20 23		  #
	ld a,(l0005h)		;0e7f	3a 05 00	: . . (xxx)
	cp 0aah			;0e82	fe aa		. .
	jr nz,l0e90h		;0e84	20 0a		  .
	ld a,(041d4h)		;0e86	3a d4 41	: . A
	ld hl,04123h		;0e89	21 23 41	! # A
	ld b,02bh		;0e8c	06 2b		. +
	jr l0e98h		;0e8e	18 08		. .
l0e90h:
	ld a,(04189h)		;0e90	3a 89 41	: . A
	ld hl,04123h		;0e93	21 23 41	! # A
	ld b,012h		;0e96	06 12		. .
l0e98h:
	ld (hl),000h		;0e98	36 00		6 .
	inc hl			;0e9a	23		#
	ld (hl),000h		;0e9b	36 00		6 .
	inc hl			;0e9d	23		#
	ld (hl),a		;0e9e	77		w
	inc hl			;0e9f	23		#
	djnz l0e98h		;0ea0	10 f6		. .
l0ea2h:
	ld de,(04107h)		;0ea2	ed 5b 07 41	. [ . A
	ld hl,04108h		;0ea6	21 08 41	! . A
	ld a,006h		;0ea9	3e 06		> .
	sub e			;0eab	93		.
	jr z,l0eb7h		;0eac	28 09		( .
	add hl,de		;0eae	19		.
	ld b,a			;0eaf	47		G
	ld a,000h		;0eb0	3e 00		> .
l0eb2h:
	inc hl			;0eb2	23		#
	cp (hl)			;0eb3	be		.
	ret nz			;0eb4	c0		.
	djnz l0eb2h		;0eb5	10 fb		. .
l0eb7h:
	dec ix			;0eb7	dd 2b		. +
	ld c,(ix+000h)		;0eb9	dd 4e 00	. N .
	push ix			;0ebc	dd e5		. .
	pop hl			;0ebe	e1		.
	ld de,0x2f		;0ebf	11 2f 00	. / .
	add hl,de		;0ec2	19		.
	ld (hl),060h		;0ec3	36 60		6 `
	inc hl			;0ec5	23		#
	ld (hl),060h		;0ec6	36 60		6 `
	inc hl			;0ec8	23		#
	ld (hl),c		;0ec9	71		q
	inc hl			;0eca	23		#
	ld b,02ah		;0ecb	06 2a		. *
l0ecdh:
	ld (hl),020h		;0ecd	36 20		6  
	inc hl			;0ecf	23		#
	djnz l0ecdh		;0ed0	10 fb		. .
	ld (hl),030h		;0ed2	36 30		6 0
	ld b,032h		;0ed4	06 32		. 2
l0ed6h:
	inc hl			;0ed6	23		#
	ld (hl),000h		;0ed7	36 00		6 .
	inc hl			;0ed9	23		#
	ld (hl),000h		;0eda	36 00		6 .
	inc hl			;0edc	23		#
	ld (hl),c		;0edd	71		q
	djnz l0ed6h		;0ede	10 f6		. .
	ret			;0ee0	c9		.
sub_0ee1h:
	push bc			;0ee1	c5		.
	push de			;0ee2	d5		.
	push hl			;0ee3	e5		.
	ex de,hl		;0ee4	eb		.
	ld a,(hl)		;0ee5	7e		~
	inc hl			;0ee6	23		#
	inc hl			;0ee7	23		#
	cp (hl)			;0ee8	be		.
	scf			;0ee9	37		7
	jr z,l0f03h		;0eea	28 17		( .
	ld e,(hl)		;0eec	5e		^
	inc hl			;0eed	23		#
	ld d,(hl)		;0eee	56		V
	ex de,hl		;0eef	eb		.
	ld b,(hl)		;0ef0	46		F
	and 0e0h		;0ef1	e6 e0		. .
	ld c,a			;0ef3	4f		O
	inc hl			;0ef4	23		#
	ld a,l			;0ef5	7d		}
	and 01fh		;0ef6	e6 1f		. .
	or c			;0ef8	b1		.
	dec de			;0ef9	1b		.
	ld (de),a		;0efa	12		.
	ld a,e			;0efb	7b		{
	cp 0e6h			;0efc	fe e6		. .
	ld a,b			;0efe	78		x
	call z,01041h		;0eff	cc 41 10	. A .
	or a			;0f02	b7		.
l0f03h:
	pop hl			;0f03	e1		.
	pop de			;0f04	d1		.
	pop bc			;0f05	c1		.
	ret			;0f06	c9		.
; Serial port
SERIAL_SOMETHING:
	in a,(c)		;0f07	ed 78		. x
sub_0f09h:
	ld e,(hl)		;0f09	5e		^
	inc hl			;0f0a	23		#
	ld d,(hl)		;0f0b	56		V
	ld (de),a		;0f0c	12		.
	ld a,e			;0f0d	7b		{
	and 0e0h		;0f0e	e6 e0		. .
	ld b,a			;0f10	47		G
	ld a,e			;0f11	7b		{
	inc a			;0f12	3c		<
	and 01fh		;0f13	e6 1f		. .
	or b			;0f15	b0		.
	ld e,a			;0f16	5f		_
	dec hl			;0f17	2b		+
	ld (hl),e		;0f18	73		s
	ret			;0f19	c9		.
; Memory Mapping?
SOMETHING_MEM:
	ld (CUR_MAP),a		;0f1a	32 22 41	2 " A
	out (0feh),a		;0f1d	d3 fe		. .
	ret			;0f1f	c9		.
sub_0f20h:
	push hl			;0f20	e5		.
	and a			;0f21	a7		.
	sbc hl,de		;0f22	ed 52		. R
	pop hl			;0f24	e1		.
	ret			;0f25	c9		.
sub_0f26h:
	call SOMETHING_MEM	;0f26	cd 1a 0f	. . .
	push af			;0f29	f5		.
	ld a,(hl)		;0f2a	7e		~
	cp 0ffh			;0f2b	fe ff		. .
	jr z,l0f31h		;0f2d	28 02		( .
	pop af			;0f2f	f1		.
	ret			;0f30	c9		.
l0f31h:
	inc hl			;0f31	23		#
	ld a,(hl)		;0f32	7e		~
	cp 0aah			;0f33	fe aa		. .
	jp z,l0f3bh		;0f35	ca 3b 0f	. ; .
	dec hl			;0f38	2b		+
	pop af			;0f39	f1		.
	ret			;0f3a	c9		.
l0f3bh:
	inc hl			;0f3b	23		#
	pop af			;0f3c	f1		.
	push de			;0f3d	d5		.
	ld a,(hl)		;0f3e	7e		~
	inc hl			;0f3f	23		#
	ld e,(hl)		;0f40	5e		^
	inc hl			;0f41	23		#
	ld d,(hl)		;0f42	56		V
	call SOMETHING_MEM	;0f43	cd 1a 0f	. . .
	ex de,hl		;0f46	eb		.
	pop de			;0f47	d1		.
	cp 0ffh			;0f48	fe ff		. .
	ret nz			;0f4a	c0		.
	ld a,000h		;0f4b	3e 00		> .
	call SOMETHING_MEM	;0f4d	cd 1a 0f	. . .
	ld hl,060deh		;0f50	21 de 60	! . `
	ret			;0f53	c9		.
sub_0f54h:
	push iy			;0f54	fd e5		. .
	push de			;0f56	d5		.
	pop iy			;0f57	fd e1		. .
	ld hl,COLD_START	;0f59	21 00 00	! . .
	ld a,c			;0f5c	79		y
	cp 002h			;0f5d	fe 02		. .
	jr c,l0f88h		;0f5f	38 27		8 '
	jr z,l0f7dh		;0f61	28 1a		( .
	cp 003h			;0f63	fe 03		. .
	jr z,l0f72h		;0f65	28 0b		( .
	call sub_0f94h		;0f67	cd 94 0f	. . .
	jr z,l0f72h		;0f6a	28 06		( .
	ld de,003e8h		;0f6c	11 e8 03	. . .
l0f6fh:
	add hl,de		;0f6f	19		.
	djnz l0f6fh		;0f70	10 fd		. .
l0f72h:
	call sub_0f94h		;0f72	cd 94 0f	. . .
	jr z,l0f7dh		;0f75	28 06		( .
	ld de,l0064h		;0f77	11 64 00	. d .
l0f7ah:
	add hl,de		;0f7a	19		.
	djnz l0f7ah		;0f7b	10 fd		. .
l0f7dh:
	call sub_0f94h		;0f7d	cd 94 0f	. . .
	jr z,l0f88h		;0f80	28 06		( .
	ld de,10		;0f82	11 0a 00	. . .
l0f85h:
	add hl,de		;0f85	19		.
	djnz l0f85h		;0f86	10 fd		. .
l0f88h:
	ld a,(iy+000h)		;0f88	fd 7e 00	. ~ .
	and 00fh		;0f8b	e6 0f		. .
	ld d,000h		;0f8d	16 00		. .
	ld e,a			;0f8f	5f		_
	add hl,de		;0f90	19		.
	pop iy			;0f91	fd e1		. .
	ret			;0f93	c9		.
sub_0f94h:
	ld a,(iy+000h)		;0f94	fd 7e 00	. ~ .
	inc iy			;0f97	fd 23		. #
	and 00fh		;0f99	e6 0f		. .
	ld b,a			;0f9b	47		G
	or a			;0f9c	b7		.
	ret			;0f9d	c9		.
sub_0f9eh:
	push iy			;0f9e	fd e5		. .
	push de			;0fa0	d5		.
	pop iy			;0fa1	fd e1		. .
	push bc			;0fa3	c5		.
	ld a,c			;0fa4	79		y
	cp 002h			;0fa5	fe 02		. .
	jr c,l0fd9h		;0fa7	38 30		8 0
	jr z,l0fcbh		;0fa9	28 20		(  
	cp 003h			;0fab	fe 03		. .
	jr z,l0fbdh		;0fad	28 0e		( .
	xor a			;0faf	af		.
l0fb0h:
	call sub_0fe3h		;0fb0	cd e3 0f	. . .
	ld de,003e8h		;0fb3	11 e8 03	. . .
	sbc hl,de		;0fb6	ed 52		. R
	jr nc,l0fb0h		;0fb8	30 f6		0 .
l0fbah:
	call sub_0fe7h		;0fba	cd e7 0f	. . .
l0fbdh:
	xor a			;0fbd	af		.
l0fbeh:
	call sub_0fe3h		;0fbe	cd e3 0f	. . .
	ld de,l0064h		;0fc1	11 64 00	. d .
	sbc hl,de		;0fc4	ed 52		. R
	jr nc,l0fbeh		;0fc6	30 f6		0 .
l0fc8h:
	call sub_0fe7h		;0fc8	cd e7 0f	. . .
l0fcbh:
	xor a			;0fcb	af		.
l0fcch:
	call sub_0fe3h		;0fcc	cd e3 0f	. . .
	ld de,10		;0fcf	11 0a 00	. . .
	sbc hl,de		;0fd2	ed 52		. R
	jr nc,l0fcch		;0fd4	30 f6		0 .
	call sub_0fe7h		;0fd6	cd e7 0f	. . .
l0fd9h:
	ld a,l			;0fd9	7d		}
	or 030h			;0fda	f6 30		. 0
	ld (iy+000h),a		;0fdc	fd 77 00	. w .
	pop bc			;0fdf	c1		.
	pop iy			;0fe0	fd e1		. .
	ret			;0fe2	c9		.
sub_0fe3h:
	ld b,h			;0fe3	44		D
	ld c,l			;0fe4	4d		M
	inc a			;0fe5	3c		<
	ret			;0fe6	c9		.
sub_0fe7h:
	dec a			;0fe7	3d		=
	ld h,b			;0fe8	60		`
	ld l,c			;0fe9	69		i
	or 030h			;0fea	f6 30		. 0
	ld (iy+000h),a		;0fec	fd 77 00	. w .
	inc iy			;0fef	fd 23		. #
	ret			;0ff1	c9		.
	and 03fh		;0ff2	e6 3f		. ?
	push hl			;0ff4	e5		.
	push de			;0ff5	d5		.
	ld hl,l1001h		;0ff6	21 01 10	! . .
	ld d,000h		;0ff9	16 00		. .
	ld e,a			;0ffb	5f		_
	add hl,de		;0ffc	19		.
	ld a,(hl)		;0ffd	7e		~
	pop de			;0ffe	d1		.
	pop hl			;0fff	e1		.
	ret			;1000	c9		.
l1001h:
	jr nz,$+71		;1001	20 45		  E
	ld l,041h		;1003	2e 41		. A
	adc a,e			;1005	8b		.
	ld d,e			;1006	53		S
l1007h:
	ld c,c			;1007	49		I
	ld d,l			;1008	55		U
	adc a,d			;1009	8a		.
	ld b,h			;100a	44		D
	ld d,d			;100b	52		R
	ld c,d			;100c	4a		J
	ld c,(hl)		;100d	4e		N
	ld b,(hl)		;100e	46		F
	ld b,e			;100f	43		C
	ld c,e			;1010	4b		K
	ld d,h			;1011	54		T
	ld e,d			;1012	5a		Z
	ld c,h			;1013	4c		L
	ld d,a			;1014	57		W
	ld c,b			;1015	48		H
	ld e,c			;1016	59		Y
	ld d,b			;1017	50		P
	ld d,c			;1018	51		Q
	ld c,a			;1019	4f		O
	ld b,d			;101a	42		B
	ld b,a			;101b	47		G
	ld h,04dh		;101c	26 4d		& M
	ld e,b			;101e	58		X
	ld d,(hl)		;101f	56		V
	adc a,b			;1020	88		.
	jr nz,$-106		;1021	20 94		  .
	add a,h			;1023	84		.
	sub c			;1024	91		.
	sbc a,(hl)		;1025	9e		.
	sub e			;1026	93		.
	adc a,a			;1027	8f		.
	jr nz,l0fbah		;1028	20 90		  .
	sub d			;102a	92		.
	sbc a,(hl)		;102b	9e		.
	sbc a,(hl)		;102c	9e		.
	jr nz,l0fc8h		;102d	20 99		  .
	add a,l			;102f	85		.
	sbc a,(hl)		;1030	9e		.
	sbc a,d			;1031	9a		.
	adc a,l			;1032	8d		.
	add a,(hl)		;1033	86		.
	sub (hl)		;1034	96		.
	adc a,c			;1035	89		.
	adc a,(hl)		;1036	8e		.
	add a,a			;1037	87		.
	sbc a,b			;1038	98		.
	sbc a,h			;1039	9c		.
	sub a			;103a	97		.
	sub l			;103b	95		.
	add a,c			;103c	81		.
	adc a,h			;103d	8c		.
	add a,d			;103e	82		.
	add a,e			;103f	83		.
	jr nz,l1007h		;1040	20 c5		  .
	push hl			;1042	e5		.
	ld b,a			;1043	47		G
	ld a,(l000bh)		;1044	3a 0b 00	: . .
	cp 0aah			;1047	fe aa		. .
	ld a,b			;1049	78		x
	jr nz,l105bh		;104a	20 0f		  .
	ld b,013h		;104c	06 13		. .
	ld hl,l105eh		;104e	21 5e 10	! ^ .
l1051h:
	cp (hl)			;1051	be		.
	inc hl			;1052	23		#
	jr z,l105ah		;1053	28 05		( .
	inc hl			;1055	23		#
	djnz l1051h		;1056	10 f9		. .
	jr l105bh		;1058	18 01		. .
l105ah:
	ld a,(hl)		;105a	7e		~
l105bh:
	pop hl			;105b	e1		.
	pop bc			;105c	c1		.
	ret			;105d	c9		.
l105eh:
	ld hl,(l2b5bh)		;105e	2a 5b 2b	* [ +
	ld e,h			;1061	5c		\
	ld a,(03b7bh)		;1062	3a 7b 3b	: { ;
	ld a,h			;1065	7c		|
	inc a			;1066	3c		<
	dec sp			;1067	3b		;
	ld a,03ah		;1068	3e 3a		> :
	ld b,b			;106a	40		@
	ld hl,(05a59h)		;106b	2a 59 5a	* Y Z
	ld e,d			;106e	5a		Z
	ld e,c			;106f	59		Y
	ld e,e			;1070	5b		[
	ld e,l			;1071	5d		]
	ld e,h			;1072	5c		\
	ld h,b			;1073	60		`
	ld e,l			;1074	5d		]
	ld b,b			;1075	40		@
	ld h,b			;1076	60		`
	dec hl			;1077	2b		+
	ld a,c			;1078	79		y
	ld a,d			;1079	7a		z
	ld a,d			;107a	7a		z
	ld a,c			;107b	79		y
	ld a,e			;107c	7b		{
	ld a,l			;107d	7d		}
	ld a,h			;107e	7c		|
	inc a			;107f	3c		<
	ld a,l			;1080	7d		}
	ld a,(hl)		;1081	7e		~
	ld a,(hl)		;1082	7e		~
	db 0x3e
OUTCH:
	push hl
	ld hl,0x4f79
	bit 4,(hl)
	pop hl
	ret nz
	cp ' '  
	jr nc,l10cch		;108e	30 3c		0 <
	cp 010h			;1090	fe 10		. .
	ret nc			;1092	d0		.
	ld (04f87h),hl		;1093	22 87 4f	" . O
	push de			;1096	d5		.
	push af			;1097	f5		.
	add a,a			;1098	87		.
	ld e,a			;1099	5f		_
	ld d,000h		;109a	16 00		. .
	ld hl,l10abh		;109c	21 ab 10	! . .
	add hl,de		;109f	19		.
	ld e,(hl)		;10a0	5e		^
	inc hl			;10a1	23		#
	ld d,(hl)		;10a2	56		V
	ex de,hl		;10a3	eb		.
	pop af			;10a4	f1		.
	pop de			;10a5	d1		.
	push hl			;10a6	e5		.
	ld hl,(04f87h)		;10a7	2a 87 4f	* . O
	ret			;10aa	c9		.
l10abh:
	rl b			;10ab	cb 10		. .
	rl b			;10ad	cb 10		. .
	ret p			;10af	f0		.
	ld (de),a		;10b0	12		.
	ret z			;10b1	c8		.
	ld (de),a		;10b2	12		.
	halt			;10b3	76		v
	ld de,l12b1h		;10b4	11 b1 12	. . .
	rl b			;10b7	cb 10		. .
	rl b			;10b9	cb 10		. .
	cp e			;10bb	bb		.
	ld de,l119bh		;10bc	11 9b 11	. . .
	ld d,(hl)		;10bf	56		V
	ld de,l1239h		;10c0	11 39 12	. 9 .
	xor 011h		;10c3	ee 11		. .
	rl b			;10c5	cb 10		. .
	adc a,d			;10c7	8a		.
	ld (de),a		;10c8	12		.
	and (hl)		;10c9	a6		.
	ld (de),a		;10ca	12		.
	ret			;10cb	c9		.
l10cch:
	push af			;10cc	f5		.
	push bc			;10cd	c5		.
	push de			;10ce	d5		.
	push hl			;10cf	e5		.
	ld hl,(04f84h)		;10d0	2a 84 4f	* . O
	ld b,a			;10d3	47		G
	push bc			;10d4	c5		.
	ld a,(04f86h)		;10d5	3a 86 4f	: . O
	ld c,a			;10d8	4f		O
	ld b,000h		;10d9	06 00		. .
	ld de,42		;10db	11 2a 00	. * .
	or a			;10de	b7		.
	sbc hl,de		;10df	ed 52		. R
	add hl,bc		;10e1	09		.
	pop bc			;10e2	c1		.
	ld (hl),b		;10e3	70		p
	inc a			;10e4	3c		<
	ld (04f86h),a		;10e5	32 86 4f	2 . O
	ld hl,(04f84h)		;10e8	2a 84 4f	* . O
	ld b,a			;10eb	47		G
	ld a,(hl)		;10ec	7e		~
	and 0c0h		;10ed	e6 c0		. .
	or b			;10ef	b0		.
	ld (hl),a		;10f0	77		w
	call sub_1191h		;10f1	cd 91 11	. . .
	ld a,(04f86h)		;10f4	3a 86 4f	: . O
	cp 028h			;10f7	fe 28		. (
	call nc,l12b1h		;10f9	d4 b1 12	. . .
	pop hl			;10fc	e1		.
	pop de			;10fd	d1		.
	pop bc			;10fe	c1		.
	pop af			;10ff	f1		.
	ret			;1100	c9		.
sub_1101h:
	push hl			;1101	e5		.
	push af			;1102	f5		.
	ld a,(l0005h)		;1103	3a 05 00	: . .
	cp 0aah			;1106	fe aa		. .
	jr nz,l110fh		;1108	20 05		  .
	ld hl,l004bh		;110a	21 4b 00	! K .
	add hl,de		;110d	19		.
	ex de,hl		;110e	eb		.
l110fh:
	pop af			;110f	f1		.
	pop hl			;1110	e1		.
	ret			;1111	c9		.
sub_1112h:
	push bc			;1112	c5		.
	push de			;1113	d5		.
	push hl			;1114	e5		.
	push af			;1115	f5		.
	ld de,04186h		;1116	11 86 41	. . A
	call sub_1101h		;1119	cd 01 11	. . .
	ld h,d			;111c	62		b
	ld l,e			;111d	6b		k
	ld de,l0043h		;111e	11 43 00	. C .
	ld b,01ah		;1121	06 1a		. .
l1123h:
	ld a,(hl)		;1123	7e		~
	or 03fh			;1124	f6 3f		. ?
	ld (hl),a		;1126	77		w
	add hl,de		;1127	19		.
	djnz l1123h		;1128	10 f9		. .
	pop af			;112a	f1		.
	pop hl			;112b	e1		.
	pop de			;112c	d1		.
	pop bc			;112d	c1		.
	ret			;112e	c9		.
sub_112fh:
	push bc			;112f	c5		.
	push de			;1130	d5		.
	ld de,04159h		;1131	11 59 41	. Y A
	call sub_1101h		;1134	cd 01 11	. . .
	ld h,d			;1137	62		b
	ld l,e			;1138	6b		k
	ld b,01ah		;1139	06 1a		. .
	ld de,l0043h		;113b	11 43 00	. C .
	ld c,0ffh		;113e	0e ff		. .
l1140h:
	bit 5,(hl)		;1140	cb 6e		. n
	jr z,l1148h		;1142	28 04		( .
	inc c			;1144	0c		.
	cp c			;1145	b9		.
	jr z,l114fh		;1146	28 07		( .
l1148h:
	add hl,de		;1148	19		.
	djnz l1140h		;1149	10 f5		. .
	ld de,0x2b		;114b	11 2b 00	. + .
	add hl,de		;114e	19		.
l114fh:
	ld de,0x2d		;114f	11 2d 00	. - .
	add hl,de		;1152	19		.
	pop de			;1153	d1		.
	pop bc			;1154	c1		.
	ret			;1155	c9		.
	push af			;1156	f5		.
	push hl			;1157	e5		.
	call sub_1112h		;1158	cd 12 11	. . .
	ld a,(04f83h)		;115b	3a 83 4f	: . O
	call sub_112fh		;115e	cd 2f 11	. / .
	ld (04f84h),hl		;1161	22 84 4f	" . O
	ld a,(hl)		;1164	7e		~
	and 0c0h		;1165	e6 c0		. .
	ld (hl),a		;1167	77		w
	ld a,(04f82h)		;1168	3a 82 4f	: . O
	ld (04f86h),a		;116b	32 86 4f	2 . O
	or (hl)			;116e	b6		.
	ld (hl),a		;116f	77		w
	call sub_1191h		;1170	cd 91 11	. . .
	pop hl			;1173	e1		.
	pop af			;1174	f1		.
	ret			;1175	c9		.
	push af			;1176	f5		.
	push hl			;1177	e5		.
	call sub_1112h		;1178	cd 12 11	. . .
	xor a			;117b	af		.
	call sub_112fh		;117c	cd 2f 11	. / .
	ld (04f84h),hl		;117f	22 84 4f	" . O
	ld a,(hl)		;1182	7e		~
	and 0c0h		;1183	e6 c0		. .
	ld (hl),a		;1185	77		w
	ld a,000h		;1186	3e 00		> .
	ld (04f86h),a		;1188	32 86 4f	2 . O
	call sub_1191h		;118b	cd 91 11	. . .
	pop hl			;118e	e1		.
	pop af			;118f	f1		.
	ret			;1190	c9		.
sub_1191h:
	ld a,(05b6dh)		;1191	3a 6d 5b	: m [
	or a			;1194	b7		.
	ret z			;1195	c8		.
	ld a,(hl)		;1196	7e		~
	or 03fh			;1197	f6 3f		. ?
	ld (hl),a		;1199	77		w
	ret			;119a	c9		.
l119bh:
	push af			;119b	f5		.
	push hl			;119c	e5		.
	ld hl,(04f84h)		;119d	2a 84 4f	* . O
	ld a,(hl)		;11a0	7e		~
	and 0c0h		;11a1	e6 c0		. .
	ld (hl),a		;11a3	77		w
	ld a,(04f86h)		;11a4	3a 86 4f	: . O
	inc a			;11a7	3c		<
	ld (04f86h),a		;11a8	32 86 4f	2 . O
	or (hl)			;11ab	b6		.
	ld (hl),a		;11ac	77		w
	call sub_1191h		;11ad	cd 91 11	. . .
	ld a,(04f86h)		;11b0	3a 86 4f	: . O
	cp 028h			;11b3	fe 28		. (
	call nc,l12b1h		;11b5	d4 b1 12	. . .
	pop hl			;11b8	e1		.
	pop af			;11b9	f1		.
	ret			;11ba	c9		.
	push af			;11bb	f5		.
	push hl			;11bc	e5		.
	ld hl,(04f84h)		;11bd	2a 84 4f	* . O
	ld a,(hl)		;11c0	7e		~
	and 0c0h		;11c1	e6 c0		. .
	ld (hl),a		;11c3	77		w
	ld a,(04f86h)		;11c4	3a 86 4f	: . O
	dec a			;11c7	3d		=
	ld (04f86h),a		;11c8	32 86 4f	2 . O
	or (hl)			;11cb	b6		.
	ld (hl),a		;11cc	77		w
	call sub_1191h		;11cd	cd 91 11	. . .
	ld a,(04f86h)		;11d0	3a 86 4f	: . O
	cp 0ffh			;11d3	fe ff		. .
	jr nz,l11ebh		;11d5	20 14		  .
	call sub_11eeh		;11d7	cd ee 11	. . .
	ld hl,(04f84h)		;11da	2a 84 4f	* . O
	ld a,(hl)		;11dd	7e		~
	and 0c0h		;11de	e6 c0		. .
	ld (hl),a		;11e0	77		w
	ld a,027h		;11e1	3e 27		> '
	ld (04f86h),a		;11e3	32 86 4f	2 . O
	or (hl)			;11e6	b6		.
	ld (hl),a		;11e7	77		w
	call sub_1191h		;11e8	cd 91 11	. . .
l11ebh:
	pop hl			;11eb	e1		.
	pop af			;11ec	f1		.
	ret			;11ed	c9		.
sub_11eeh:
	push af			;11ee	f5		.
	push bc			;11ef	c5		.
	push de			;11f0	d5		.
	push hl			;11f1	e5		.
	ld hl,(04f84h)		;11f2	2a 84 4f	* . O
	ld de,04186h		;11f5	11 86 41	. . A
	call sub_1101h		;11f8	cd 01 11	. . .
	call sub_0f20h		;11fb	cd 20 0f	.   .
	jr z,l1234h		;11fe	28 34		( 4
	ld a,(hl)		;1200	7e		~
	or 03fh			;1201	f6 3f		. ?
	ld (hl),a		;1203	77		w
	ld bc,00070h		;1204	01 70 00	. p .
	or a			;1207	b7		.
	sbc hl,bc		;1208	ed 42		. B
	ld de,04159h		;120a	11 59 41	. Y A
	call sub_1101h		;120d	cd 01 11	. . .
	ld bc,l0043h		;1210	01 43 00	. C .
l1213h:
	call sub_0f20h		;1213	cd 20 0f	.   .
	jr z,l1221h		;1216	28 09		( .
	bit 5,(hl)		;1218	cb 6e		. n
	jr nz,l1221h		;121a	20 05		  .
	or a			;121c	b7		.
	sbc hl,bc		;121d	ed 42		. B
	jr l1213h		;121f	18 f2		. .
l1221h:
	ld bc,0x2d		;1221	01 2d 00	. - .
	add hl,bc		;1224	09		.
	ld a,(hl)		;1225	7e		~
	and 0c0h		;1226	e6 c0		. .
	ld (hl),a		;1228	77		w
	ld a,(04f86h)		;1229	3a 86 4f	: . O
	or (hl)			;122c	b6		.
	ld (hl),a		;122d	77		w
	ld (04f84h),hl		;122e	22 84 4f	" . O
	call sub_1191h		;1231	cd 91 11	. . .
l1234h:
	pop hl			;1234	e1		.
	pop de			;1235	d1		.
	pop bc			;1236	c1		.
	pop af			;1237	f1		.
	ret			;1238	c9		.
l1239h:
	push af			;1239	f5		.
	push bc			;123a	c5		.
	push de			;123b	d5		.
	push hl			;123c	e5		.
	ld hl,(04f84h)		;123d	2a 84 4f	* . O
	ld de,04811h		;1240	11 11 48	. . H
	call sub_1101h		;1243	cd 01 11	. . .
	call sub_0f20h		;1246	cd 20 0f	.   .
	jr z,l127bh		;1249	28 30		( 0
	ld a,(hl)		;124b	7e		~
	or 03fh			;124c	f6 3f		. ?
	ld (hl),a		;124e	77		w
	ld bc,22		;124f	01 16 00	. . .
	add hl,bc		;1252	09		.
	ld de,047e4h		;1253	11 e4 47	. . G
	call sub_1101h		;1256	cd 01 11	. . .
	ld bc,l0043h		;1259	01 43 00	. C .
l125ch:
	call sub_0f20h		;125c	cd 20 0f	.   .
	jr z,l1268h		;125f	28 07		( .
	bit 5,(hl)		;1261	cb 6e		. n
	jr nz,l1268h		;1263	20 03		  .
	add hl,bc		;1265	09		.
	jr l125ch		;1266	18 f4		. .
l1268h:
	ld bc,0x2d		;1268	01 2d 00	. - .
	add hl,bc		;126b	09		.
	ld a,(hl)		;126c	7e		~
	and 0c0h		;126d	e6 c0		. .
	ld (hl),a		;126f	77		w
	ld a,(04f86h)		;1270	3a 86 4f	: . O
	or (hl)			;1273	b6		.
	ld (hl),a		;1274	77		w
	ld (04f84h),hl		;1275	22 84 4f	" . O
	call sub_1191h		;1278	cd 91 11	. . .
l127bh:
	pop hl			;127b	e1		.
	pop de			;127c	d1		.
	pop bc			;127d	c1		.
	pop af			;127e	f1		.
	ret			;127f	c9		.
	ld a,(05fb6h)		;1280	3a b6 5f	: . _
	xor 0ffh		;1283	ee ff		. .
	ld (05fb6h),a		;1285	32 b6 5f	2 . _
	jr nz,l12a6h		;1288	20 1c		  .
	push af			;128a	f5		.
	push hl			;128b	e5		.
	ld a,(05fb6h)		;128c	3a b6 5f	: . _
	or a			;128f	b7		.
	jr nz,l12a3h		;1290	20 11		  .
	ld hl,(04f84h)		;1292	2a 84 4f	* . O
	ld a,(hl)		;1295	7e		~
	and 0c0h		;1296	e6 c0		. .
	ld (hl),a		;1298	77		w
	ld a,(04f86h)		;1299	3a 86 4f	: . O
	or (hl)			;129c	b6		.
	ld (hl),a		;129d	77		w
	ld a,000h		;129e	3e 00		> .
	ld (05b6dh),a		;12a0	32 6d 5b	2 m [
l12a3h:
	pop hl			;12a3	e1		.
	pop af			;12a4	f1		.
	ret			;12a5	c9		.
l12a6h:
	push af			;12a6	f5		.
	call sub_1112h		;12a7	cd 12 11	. . .
	ld a,001h		;12aa	3e 01		> .
	ld (05b6dh),a		;12ac	32 6d 5b	2 m [
	pop af			;12af	f1		.
	ret			;12b0	c9		.
l12b1h:
	push af			;12b1	f5		.
	push hl			;12b2	e5		.
	call l1239h		;12b3	cd 39 12	. 9 .
	ld a,000h		;12b6	3e 00		> .
	ld (04f86h),a		;12b8	32 86 4f	2 . O
	ld hl,(04f84h)		;12bb	2a 84 4f	* . O
	ld a,(hl)		;12be	7e		~
	and 0c0h		;12bf	e6 c0		. .
	ld (hl),a		;12c1	77		w
	call sub_1191h		;12c2	cd 91 11	. . .
	pop hl			;12c5	e1		.
	pop af			;12c6	f1		.
	ret			;12c7	c9		.
sub_12c8h:
	push af			;12c8	f5		.
	push bc			;12c9	c5		.
	push de			;12ca	d5		.
	push hl			;12cb	e5		.
	ld hl,(04f84h)		;12cc	2a 84 4f	* . O
	ld a,(04f86h)		;12cf	3a 86 4f	: . O
	ld c,a			;12d2	4f		O
	ld b,000h		;12d3	06 00		. .
	ld de,42		;12d5	11 2a 00	. * .
	or a			;12d8	b7		.
	sbc hl,de		;12d9	ed 52		. R
	add hl,bc		;12db	09		.
	ld a,027h		;12dc	3e 27		> '
	sub c			;12de	91		.
	ld c,a			;12df	4f		O
	ld (hl),020h		;12e0	36 20		6  
	ld d,h			;12e2	54		T
	ld e,l			;12e3	5d		]
	inc de			;12e4	13		.
	ld a,b			;12e5	78		x
	or c			;12e6	b1		.
	jr z,l12ebh		;12e7	28 02		( .
	ldir			;12e9	ed b0		. .
l12ebh:
	pop hl			;12eb	e1		.
	pop de			;12ec	d1		.
	pop bc			;12ed	c1		.
	pop af			;12ee	f1		.
	ret			;12ef	c9		.
	push bc			;12f0	c5		.
	push de			;12f1	d5		.
	push hl			;12f2	e5		.
	call sub_12c8h		;12f3	cd c8 12	. . .
	ld hl,(04f84h)		;12f6	2a 84 4f	* . O
	ld bc,25		;12f9	01 19 00	. . .
	add hl,bc		;12fc	09		.
	ld de,0482ah		;12fd	11 2a 48	. * H
	call sub_1101h		;1300	cd 01 11	. . .
	ld c,01bh		;1303	0e 1b		. .
l1305h:
	call sub_0f20h		;1305	cd 20 0f	.   .
	jr nc,l1314h		;1308	30 0a		0 .
	ld b,028h		;130a	06 28		. (
l130ch:
	ld (hl),020h		;130c	36 20		6  
	inc hl			;130e	23		#
	djnz l130ch		;130f	10 fb		. .
	add hl,bc		;1311	09		.
	jr l1305h		;1312	18 f1		. .
l1314h:
	pop hl			;1314	e1		.
	pop de			;1315	d1		.
	pop bc			;1316	c1		.
	ret			;1317	c9		.
sub_1318h:
	ex (sp),hl		;1318	e3		.
	ld a,(hl)		;1319	7e		~
	inc hl			;131a	23		#
	ex (sp),hl		;131b	e3		.
	jp OUTCH		;131c	c3 84 10	. . .
sub_131fh:
	ex (sp),hl		;131f	e3		.
	push de			;1320	d5		.
	push bc			;1321	c5		.
	push af			;1322	f5		.
	call sub_144dh		;1323	cd 4d 14	. M .
	push de			;1326	d5		.
	ld a,c			;1327	79		y
	and 040h		;1328	e6 40		. @
	jr z,l1369h		;132a	28 3d		( =
	ld d,001h		;132c	16 01		. .
	ld e,020h		;132e	1e 20		.  
l1330h:
	call SOMETHING_KBD	;1330	cd a7 17	. . .
	cp 00ah			;1333	fe 0a		. .
	jr z,l1341h		;1335	28 0a		( .
	call sub_14d1h		;1337	cd d1 14	. . .
	jr c,l1330h		;133a	38 f4		8 .
	call sub_147bh		;133c	cd 7b 14	. { .
	jr l1330h		;133f	18 ef		. .
l1341h:
	bit 7,c			;1341	cb 79		. y
	jr nz,l1363h		;1343	20 1e		  .
	ld a,c			;1345	79		y
	and 00fh		;1346	e6 0f		. .
	dec a			;1348	3d		=
	ld c,a			;1349	4f		O
	ld b,000h		;134a	06 00		. .
	add hl,bc		;134c	09		.
	ld b,c			;134d	41		A
l134eh:
	ld a,(hl)		;134e	7e		~
	cp 020h			;134f	fe 20		.  
	jr nz,l1363h		;1351	20 10		  .
	push bc			;1353	c5		.
	push hl			;1354	e5		.
	ld b,c			;1355	41		A
l1356h:
	dec hl			;1356	2b		+
	ld a,(hl)		;1357	7e		~
	inc hl			;1358	23		#
	ld (hl),a		;1359	77		w
	dec hl			;135a	2b		+
	djnz l1356h		;135b	10 f9		. .
	ld (hl),020h		;135d	36 20		6  
	pop hl			;135f	e1		.
	pop bc			;1360	c1		.
	djnz l134eh		;1361	10 eb		. .
l1363h:
	pop hl			;1363	e1		.
	pop af			;1364	f1		.
	pop bc			;1365	c1		.
	pop de			;1366	d1		.
	ex (sp),hl		;1367	e3		.
	ret			;1368	c9		.
l1369h:
	ld a,c			;1369	79		y
	and 03fh		;136a	e6 3f		. ?
	ld c,a			;136c	4f		O
	ld e,001h		;136d	1e 01		. .
l136fh:
	call SOMETHING_KBD	;136f	cd a7 17	. . .
l1372h:
	cp 00ah			;1372	fe 0a		. .
	jr z,l13b9h		;1374	28 43		( C
	cp 07fh			;1376	fe 7f		. .
	jr z,l139ah		;1378	28 20		(  
	call sub_14bdh		;137a	cd bd 14	. . .
	jr c,l136fh		;137d	38 f0		8 .
	ld (hl),a		;137f	77		w
	ld a,e			;1380	7b		{
	cp c			;1381	b9		.
	jr z,l138ch		;1382	28 08		( .
	ld a,(hl)		;1384	7e		~
	call OUTCH		;1385	cd 84 10	. . .
	inc hl			;1388	23		#
	inc e			;1389	1c		.
	jr l136fh		;138a	18 e3		. .
l138ch:
	call sub_1318h		;138c	cd 18 13	. . .
	rrca			;138f	0f		.
	ld a,(hl)		;1390	7e		~
	call OUTCH		;1391	cd 84 10	. . .
	call sub_156ch		;1394	cd 6c 15	. l .
	ld bc,01918h		;1397	01 18 19	. . .
l139ah:
	ld (hl),020h		;139a	36 20		6  
	call sub_1318h		;139c	cd 18 13	. . .
	rrca			;139f	0f		.
	call sub_1318h		;13a0	cd 18 13	. . .
	jr nz,l1372h		;13a3	20 cd		  .
	ld l,h			;13a5	6c		l
	dec d			;13a6	15		.
	ld bc,0fe7bh		;13a7	01 7b fe	. { .
	ld bc,00628h		;13aa	01 28 06	. ( .
	call sub_156ch		;13ad	cd 6c 15	. l .
	ld bc,01d2bh		;13b0	01 2b 1d	. + .
	call sub_1318h		;13b3	cd 18 13	. . .
	ld c,018h		;13b6	0e 18		. .
	or (hl)			;13b8	b6		.
l13b9h:
	ld a,020h		;13b9	3e 20		>  
	cp (hl)			;13bb	be		.
	jr c,l13bfh		;13bc	38 01		8 .
	ld (hl),a		;13be	77		w
l13bfh:
	inc hl			;13bf	23		#
	inc e			;13c0	1c		.
	ld a,c			;13c1	79		y
	cp e			;13c2	bb		.
	jr nc,l13b9h		;13c3	30 f4		0 .
	jp l1363h		;13c5	c3 63 13	. c .
sub_13c8h:
	ex (sp),hl		;13c8	e3		.
	push de			;13c9	d5		.
	push bc			;13ca	c5		.
	push af			;13cb	f5		.
	call sub_144dh		;13cc	cd 4d 14	. M .
	push de			;13cf	d5		.
	call sub_09b1h		;13d0	cd b1 09	. . .
	in a,(013h)		;13d3	db 13		. .
	pop hl			;13d5	e1		.
	pop af			;13d6	f1		.
	pop bc			;13d7	c1		.
	pop de			;13d8	d1		.
	ex (sp),hl		;13d9	e3		.
	ret			;13da	c9		.
	ld b,c			;13db	41		A
l13dch:
	ld a,(hl)		;13dc	7e		~
	call OUTCH		;13dd	cd 84 10	. . .
	inc hl			;13e0	23		#
	djnz l13dch		;13e1	10 f9		. .
	ret			;13e3	c9		.
sub_13e4h:
	pop hl			;13e4	e1		.
	push de			;13e5	d5		.
	push bc			;13e6	c5		.
	push af			;13e7	f5		.
	call sub_144dh		;13e8	cd 4d 14	. M .
	push de			;13eb	d5		.
	push hl			;13ec	e5		.
	call sub_145eh		;13ed	cd 5e 14	. ^ .
l13f0h:
	ld d,001h		;13f0	16 01		. .
	ld e,030h		;13f2	1e 30		. 0
l13f4h:
	call SOMETHING_KBD	;13f4	cd a7 17	. . .
	cp 00ah			;13f7	fe 0a		. .
	jr z,l1405h		;13f9	28 0a		( .
	call sub_14cah		;13fb	cd ca 14	. . .
	jr c,l13f4h		;13fe	38 f4		8 .
	call sub_147bh		;1400	cd 7b 14	. { .
	jr l13f4h		;1403	18 ef		. .
l1405h:
	ld a,c			;1405	79		y
	and 007h		;1406	e6 07		. .
	push bc			;1408	c5		.
	ld c,a			;1409	4f		O
	ex de,hl		;140a	eb		.
	push de			;140b	d5		.
	call sub_0f54h		;140c	cd 54 0f	. T .
	pop de			;140f	d1		.
	pop bc			;1410	c1		.
	ex de,hl		;1411	eb		.
	ld a,c			;1412	79		y
	and 040h		;1413	e6 40		. @
	jr z,l1425h		;1415	28 0e		( .
	ld a,d			;1417	7a		z
	or a			;1418	b7		.
	jr nz,l141eh		;1419	20 03		  .
	inc a			;141b	3c		<
	jr l1425h		;141c	18 07		. .
l141eh:
	ld e,023h		;141e	1e 23		. #
	call sub_1501h		;1420	cd 01 15	. . .
	jr l13f0h		;1423	18 cb		. .
l1425h:
	pop hl			;1425	e1		.
	ld (hl),e		;1426	73		s
	jr nz,l142bh		;1427	20 02		  .
	inc hl			;1429	23		#
	ld (hl),d		;142a	72		r
l142bh:
	pop hl			;142b	e1		.
	pop af			;142c	f1		.
	pop bc			;142d	c1		.
	ex (sp),hl		;142e	e3		.
	ex de,hl		;142f	eb		.
	ret			;1430	c9		.
sub_1431h:
	ex (sp),hl		;1431	e3		.
	push de			;1432	d5		.
	push bc			;1433	c5		.
	push af			;1434	f5		.
	call sub_144dh		;1435	cd 4d 14	. M .
	push de			;1438	d5		.
	call sub_145eh		;1439	cd 5e 14	. ^ .
	ld a,c			;143c	79		y
	and 007h		;143d	e6 07		. .
	ld b,a			;143f	47		G
l1440h:
	ld a,(hl)		;1440	7e		~
	call OUTCH		;1441	cd 84 10	. . .
	inc hl			;1444	23		#
	djnz l1440h		;1445	10 f9		. .
	pop hl			;1447	e1		.
	pop af			;1448	f1		.
	pop bc			;1449	c1		.
	pop de			;144a	d1		.
	ex (sp),hl		;144b	e3		.
	ret			;144c	c9		.
sub_144dh:
	ld e,(hl)		;144d	5e		^
	inc hl			;144e	23		#
	ld d,(hl)		;144f	56		V
	inc hl			;1450	23		#
	ld c,(hl)		;1451	4e		N
	inc hl			;1452	23		#
	ex de,hl		;1453	eb		.
	dec h			;1454	25		%
	inc h			;1455	24		$
	ret nz			;1456	c0		.
	push de			;1457	d5		.
	push iy			;1458	fd e5		. .
	pop de			;145a	d1		.
	add hl,de		;145b	19		.
	pop de			;145c	d1		.
	ret			;145d	c9		.
sub_145eh:
	ld a,c			;145e	79		y
	and 040h		;145f	e6 40		. @
	jr z,l1468h		;1461	28 05		( .
	ld l,(hl)		;1463	6e		n
	ld h,000h		;1464	26 00		& .
	jr l146ch		;1466	18 04		. .
l1468h:
	ld e,(hl)		;1468	5e		^
	inc hl			;1469	23		#
	ld d,(hl)		;146a	56		V
	ex de,hl		;146b	eb		.
l146ch:
	ld a,c			;146c	79		y
	and 007h		;146d	e6 07		. .
	push bc			;146f	c5		.
	ld c,a			;1470	4f		O
	ld de,04f7ah		;1471	11 7a 4f	. z O
	push de			;1474	d5		.
	call sub_0f9eh		;1475	cd 9e 0f	. . .
	pop hl			;1478	e1		.
	pop bc			;1479	c1		.
	ret			;147a	c9		.
sub_147bh:
	push af			;147b	f5		.
	call sub_1318h		;147c	cd 18 13	. . .
	rrca			;147f	0f		.
	dec d			;1480	15		.
	jr nz,l1495h		;1481	20 12		  .
	ld a,c			;1483	79		y
	and 00fh		;1484	e6 0f		. .
	ld b,a			;1486	47		G
	push hl			;1487	e5		.
l1488h:
	ld (hl),e		;1488	73		s
	inc hl			;1489	23		#
	djnz l1488h		;148a	10 fc		. .
	pop hl			;148c	e1		.
	ld a,c			;148d	79		y
	and 030h		;148e	e6 30		. 0
	ld e,020h		;1490	1e 20		.  
	call nz,sub_1501h	;1492	c4 01 15	. . .
l1495h:
	ld a,c			;1495	79		y
	and 00fh		;1496	e6 0f		. .
	ld d,h			;1498	54		T
	ld e,l			;1499	5d		]
	dec a			;149a	3d		=
	jr z,l14afh		;149b	28 12		( .
	ld b,a			;149d	47		G
	ld a,008h		;149e	3e 08		> .
	push bc			;14a0	c5		.
	call sub_157ch		;14a1	cd 7c 15	. | .
	pop bc			;14a4	c1		.
l14a5h:
	inc de			;14a5	13		.
	ld a,(de)		;14a6	1a		.
	dec de			;14a7	1b		.
	ld (de),a		;14a8	12		.
	inc de			;14a9	13		.
	call OUTCH		;14aa	cd 84 10	. . .
	djnz l14a5h		;14ad	10 f6		. .
l14afh:
	pop af			;14af	f1		.
	ld (de),a		;14b0	12		.
	call OUTCH		;14b1	cd 84 10	. . .
	call sub_156ch		;14b4	cd 6c 15	. l .
	ld bc,l18cdh		;14b7	01 cd 18	. . .
	inc de			;14ba	13		.
	ld c,0c9h		;14bb	0e c9		. .
sub_14bdh:
	cp 020h			;14bd	fe 20		.  
	ret z			;14bf	c8		.
	cp 041h			;14c0	fe 41		. A
	jr c,sub_14cah		;14c2	38 06		8 .
	and 0dfh		;14c4	e6 df		. .
	cp 05bh			;14c6	fe 5b		. [
	ccf			;14c8	3f		?
	ret			;14c9	c9		.
sub_14cah:
	cp 030h			;14ca	fe 30		. 0
	ret c			;14cc	d8		.
	cp 03ah			;14cd	fe 3a		. :
	ccf			;14cf	3f		?
	ret			;14d0	c9		.
sub_14d1h:
	cp 020h			;14d1	fe 20		.  
	ret c			;14d3	d8		.
	cp 023h			;14d4	fe 23		. #
	ccf			;14d6	3f		?
	ret z			;14d7	c8		.
	cp 05bh			;14d8	fe 5b		. [
	ccf			;14da	3f		?
	ret nc			;14db	d0		.
	sub 020h		;14dc	d6 20		.  
	cp 041h			;14de	fe 41		. A
	ret c			;14e0	d8		.
	cp 05bh			;14e1	fe 5b		. [
	ccf			;14e3	3f		?
	ret			;14e4	c9		.
sub_14e5h:
	ex (sp),hl		;14e5	e3		.
	push de			;14e6	d5		.
	push bc			;14e7	c5		.
	push af			;14e8	f5		.
	ld c,(hl)		;14e9	4e		N
	inc hl			;14ea	23		#
	ld a,c			;14eb	79		y
	add a,010h		;14ec	c6 10		. .
	ld c,a			;14ee	4f		O
	call sub_1318h		;14ef	cd 18 13	. . .
	rrca			;14f2	0f		.
	ld e,0feh		;14f3	1e fe		. .
	call sub_1501h		;14f5	cd 01 15	. . .
	call sub_1318h		;14f8	cd 18 13	. . .
	ld c,0f1h		;14fb	0e f1		. .
	pop bc			;14fd	c1		.
	pop de			;14fe	d1		.
	ex (sp),hl		;14ff	e3		.
	ret			;1500	c9		.
sub_1501h:
	ld a,c			;1501	79		y
	and 007h		;1502	e6 07		. .
	ld b,a			;1504	47		G
	push bc			;1505	c5		.
	ld a,008h		;1506	3e 08		> .
	call sub_157ch		;1508	cd 7c 15	. | .
	ld a,e			;150b	7b		{
	call OUTCH		;150c	cd 84 10	. . .
	ld a,009h		;150f	3e 09		> .
	pop bc			;1511	c1		.
	call sub_157ch		;1512	cd 7c 15	. | .
	ld a,020h		;1515	3e 20		>  
	and c			;1517	a1		.
	jr nz,$+10		;1518	20 08		  .
	ld a,e			;151a	7b		{
	call OUTCH		;151b	cd 84 10	. . .
	call sub_156ch		;151e	cd 6c 15	. l .
	ld bc,06ccdh		;1521	01 cd 6c	. . l
	dec d			;1524	15		.
	ld bc,0cdc9h		;1525	01 c9 cd	. . .
	jr l153dh		;1528	18 13		. .
	rrca			;152a	0f		.
	call sub_1318h		;152b	cd 18 13	. . .
	inc b			;152e	04		.
	ex (sp),hl		;152f	e3		.
	push bc			;1530	c5		.
	ld a,00bh		;1531	3e 0b		> .
	ld b,(hl)		;1533	46		F
	inc hl			;1534	23		#
	dec b			;1535	05		.
	call nz,sub_157ch	;1536	c4 7c 15	. | .
	ld a,009h		;1539	3e 09		> .
	ld b,(hl)		;153b	46		F
	inc hl			;153c	23		#
l153dh:
	dec b			;153d	05		.
	call nz,sub_157ch	;153e	c4 7c 15	. | .
	pop bc			;1541	c1		.
	ex (sp),hl		;1542	e3		.
	call sub_1318h		;1543	cd 18 13	. . .
	ld c,0c9h		;1546	0e c9		. .
sub_1548h:
	push af			;1548	f5		.
	call sub_1318h		;1549	cd 18 13	. . .
	rrca			;154c	0f		.
	call sub_1318h		;154d	cd 18 13	. . .
	inc b			;1550	04		.
	ld a,00bh		;1551	3e 0b		> .
	dec b			;1553	05		.
	call nz,sub_157ch	;1554	c4 7c 15	. | .
	ld a,009h		;1557	3e 09		> .
	ld b,c			;1559	41		A
	dec b			;155a	05		.
	call nz,sub_157ch	;155b	c4 7c 15	. | .
	call sub_1318h		;155e	cd 18 13	. . .
	ld c,0f1h		;1561	0e f1		. .
	ret			;1563	c9		.
sub_1564h:
	ld a,00ch		;1564	3e 0c		> .
	jr l1572h		;1566	18 0a		. .
sub_1568h:
	ld a,00bh		;1568	3e 0b		> .
	jr l1572h		;156a	18 06		. .
sub_156ch:
	ld a,008h		;156c	3e 08		> .
	jr l1572h		;156e	18 02		. .
sub_1570h:
	ld a,009h		;1570	3e 09		> .
l1572h:
	ex (sp),hl		;1572	e3		.
	push bc			;1573	c5		.
	ld b,(hl)		;1574	46		F
	inc hl			;1575	23		#
	call sub_157ch		;1576	cd 7c 15	. | .
	pop bc			;1579	c1		.
	ex (sp),hl		;157a	e3		.
	ret			;157b	c9		.
sub_157ch:
	call OUTCH		;157c	cd 84 10	. . .
	djnz sub_157ch		;157f	10 fb		. .
	ret			;1581	c9		.
sub_1582h:
	ld a,(0602eh)		;1582	3a 2e 60	: . `
	or a			;1585	b7		.
	ret z			;1586	c8		.
	push hl			;1587	e5		.
	dec a			;1588	3d		=
	ld (0602eh),a		;1589	32 2e 60	2 . `
	inc a			;158c	3c		<
	ld hl,0602fh		;158d	21 2f 60	! / `
	cp 003h			;1590	fe 03		. .
	jr c,l1599h		;1592	38 05		8 .
	ld a,00fh		;1594	3e 0f		> .
	and (hl)		;1596	a6		.
	jr l15a3h		;1597	18 0a		. .
l1599h:
	cp 002h			;1599	fe 02		. .
	jr nz,l15a0h		;159b	20 03		  .
	ld a,(hl)		;159d	7e		~
	jr l15a3h		;159e	18 03		. .
l15a0h:
	ld a,00fh		;15a0	3e 0f		> .
	and (hl)		;15a2	a6		.
l15a3h:
	cpl			;15a3	2f		/
	out (004h),a		;15a4	d3 04		. .
	ld a,(0602eh)		;15a6	3a 2e 60	: . `
	cp 000h			;15a9	fe 00		. .
	jr nz,l15aeh		;15ab	20 01		  .
	ld (hl),a		;15ad	77		w
l15aeh:
	pop hl			;15ae	e1		.
	ret			;15af	c9		.
sub_15b0h:
	ld a,(l000ch)		;15b0	3a 0c 00	: . .
	cp 0aah			;15b3	fe aa		. .
	ret nz			;15b5	c0		.
	push bc			;15b6	c5		.
	push iy			;15b7	fd e5		. .
	call sub_13c8h		;15b9	cd c8 13	. . .
	ld c,h			;15bc	4c		L
	rla			;15bd	17		.
	ld a,(de)		;15be	1a		.
	ld a,(hl)		;15bf	7e		~
	push af			;15c0	f5		.
	or a			;15c1	b7		.
	jr z,l15e2h		;15c2	28 1e		( .
	and 00fh		;15c4	e6 0f		. .
	ld (hl),a		;15c6	77		w
	ld b,042h		;15c7	06 42		. B
	jr z,l15d1h		;15c9	28 06		( .
	ld b,041h		;15cb	06 41		. A
	cp 00fh			;15cd	fe 0f		. .
	jr nz,l15e2h		;15cf	20 11		  .
l15d1h:
	call sub_1570h		;15d1	cd 70 15	. p .
	ld bc,l32afh		;15d4	01 af 32	. . 2
	jr nc,$+98		;15d7	30 60		0 `
	ld a,b			;15d9	78		x
	ld (06031h),a		;15da	32 31 60	2 1 `
	call OUTCH		;15dd	cd 84 10	. . .
	jr l1603h		;15e0	18 21		. !
l15e2h:
	pop af			;15e2	f1		.
	push af			;15e3	f5		.
	and 00fh		;15e4	e6 0f		. .
	ld b,a			;15e6	47		G
	sub 009h		;15e7	d6 09		. .
	ld c,a			;15e9	4f		O
	ld a,030h		;15ea	3e 30		> 0
	jr c,l15f1h		;15ec	38 03		8 .
	ld a,031h		;15ee	3e 31		> 1
	ld b,c			;15f0	41		A
l15f1h:
	ld (06030h),a		;15f1	32 30 60	2 0 `
	ld a,b			;15f4	78		x
	or 030h			;15f5	f6 30		. 0
	ld (06031h),a		;15f7	32 31 60	2 1 `
	push hl			;15fa	e5		.
	pop iy			;15fb	fd e1		. .
	call sub_1431h		;15fd	cd 31 14	. 1 .
	nop			;1600	00		.
	nop			;1601	00		.
	ld b,d			;1602	42		B
l1603h:
	pop af			;1603	f1		.
	ld (hl),a		;1604	77		w
	and 0f0h		;1605	e6 f0		. .
	ld b,050h		;1607	06 50		. P
	cp 010h			;1609	fe 10		. .
	jr z,l161bh		;160b	28 0e		( .
	ld b,053h		;160d	06 53		. S
	cp 020h			;160f	fe 20		.  
	jr z,l161bh		;1611	28 08		( .
	ld b,052h		;1613	06 52		. R
	cp 040h			;1615	fe 40		. @
	jr z,l161bh		;1617	28 02		( .
	ld b,04eh		;1619	06 4e		. N
l161bh:
	call sub_1564h		;161b	cd 64 15	. d .
	ld bc,06ccdh		;161e	01 cd 6c	. . l
	dec d			;1621	15		.
	ld (bc),a		;1622	02		.
	ld a,b			;1623	78		x
	call OUTCH		;1624	cd 84 10	. . .
	pop iy			;1627	fd e1		. .
	pop bc			;1629	c1		.
	ret			;162a	c9		.
sub_162bh:
	ld a,(l000ch)		;162b	3a 0c 00	: . .
	cp 0aah			;162e	fe aa		. .
	ret nz			;1630	c0		.
	call sub_3b86h		;1631	cd 86 3b	. . ;
	push bc			;1634	c5		.
	ld b,008h		;1635	06 08		. .
	call sub_3866h		;1637	cd 66 38	. f 8
	pop bc			;163a	c1		.
	call sub_1548h		;163b	cd 48 15	. H .
	call sub_1570h		;163e	cd 70 15	. p .
	rrca			;1641	0f		.
l1642h:
	call sub_156ch		;1642	cd 6c 15	. l .
	ld bc,0a7cdh		;1645	01 cd a7	. . .
	rla			;1648	17		.
	cp 00ah			;1649	fe 0a		. .
	jr z,l1671h		;164b	28 24		( $
	and 05fh		;164d	e6 5f		. _
	ld b,000h		;164f	06 00		. .
	cp 04eh			;1651	fe 4e		. N
	jr z,l1667h		;1653	28 12		( .
	ld b,010h		;1655	06 10		. .
	cp 050h			;1657	fe 50		. P
	jr z,l1667h		;1659	28 0c		( .
	ld b,020h		;165b	06 20		.  
	cp 053h			;165d	fe 53		. S
	jr z,l1667h		;165f	28 06		( .
	ld b,040h		;1661	06 40		. @
	cp 052h			;1663	fe 52		. R
	jr nz,$-31		;1665	20 df		  .
l1667h:
	call OUTCH		;1667	cd 84 10	. . .
	ld a,(hl)		;166a	7e		~
	and 00fh		;166b	e6 0f		. .
	or b			;166d	b0		.
	ld (hl),a		;166e	77		w
	jr l1642h		;166f	18 d1		. .
l1671h:
	ld a,(hl)		;1671	7e		~
	and 0f0h		;1672	e6 f0		. .
	jr nz,l1679h		;1674	20 03		  .
	ld (hl),000h		;1676	36 00		6 .
	ret			;1678	c9		.
l1679h:
	call sub_3b86h		;1679	cd 86 3b	. . ;
	push bc			;167c	c5		.
	ld b,009h		;167d	06 09		. .
	call sub_3866h		;167f	cd 66 38	. f 8
	pop bc			;1682	c1		.
	call sub_1548h		;1683	cd 48 15	. H .
	call sub_1568h		;1686	cd 68 15	. h .
	ld bc,070cdh		;1689	01 cd 70	. . p
	dec d			;168c	15		.
	ld bc,0f57eh		;168d	01 7e f5	. ~ .
	push hl			;1690	e5		.
l1691h:
	call sub_131fh		;1691	cd 1f 13	. . .
	jr nc,l16f6h		;1694	30 60		0 `
	jp nc,l3121h		;1696	d2 21 31	. ! 1
	ld h,b			;1699	60		`
	ld a,(hl)		;169a	7e		~
	cp 041h			;169b	fe 41		. A
	ld b,00fh		;169d	06 0f		. .
	jr z,l16a7h		;169f	28 06		( .
	cp 042h			;16a1	fe 42		. B
	ld b,000h		;16a3	06 00		. .
	jr nz,l16b0h		;16a5	20 09		  .
l16a7h:
	dec hl			;16a7	2b		+
	ld a,(hl)		;16a8	7e		~
	or a			;16a9	b7		.
	jr z,l16e7h		;16aa	28 3b		( ;
	cp 020h			;16ac	fe 20		.  
	jr z,l16e7h		;16ae	28 37		( 7
l16b0h:
	ld a,(hl)		;16b0	7e		~
	ld b,a			;16b1	47		G
	dec hl			;16b2	2b		+
	and 0f0h		;16b3	e6 f0		. .
	cp 030h			;16b5	fe 30		. 0
	jr nz,l16e1h		;16b7	20 28		  (
	ld a,b			;16b9	78		x
	and 00fh		;16ba	e6 0f		. .
	cp 00ah			;16bc	fe 0a		. .
	jr nc,l16e1h		;16be	30 21		0 !
	ld b,a			;16c0	47		G
	ld a,(hl)		;16c1	7e		~
	or a			;16c2	b7		.
	jr z,l16d3h		;16c3	28 0e		( .
	cp 020h			;16c5	fe 20		.  
	jr z,l16d3h		;16c7	28 0a		( .
	cp 030h			;16c9	fe 30		. 0
	jr z,l16d3h		;16cb	28 06		( .
	cp 031h			;16cd	fe 31		. 1
	jr z,l16d6h		;16cf	28 05		( .
	jr l16e1h		;16d1	18 0e		. .
l16d3h:
	xor a			;16d3	af		.
	jr l16d8h		;16d4	18 02		. .
l16d6h:
	ld a,00ah		;16d6	3e 0a		> .
l16d8h:
	add a,b			;16d8	80		.
	ld b,a			;16d9	47		G
	or a			;16da	b7		.
	jr z,l16e1h		;16db	28 04		( .
	cp 00fh			;16dd	fe 0f		. .
	jr c,l16e7h		;16df	38 06		8 .
l16e1h:
	call sub_14e5h		;16e1	cd e5 14	. . .
	ld (bc),a		;16e4	02		.
	jr l1691h		;16e5	18 aa		. .
l16e7h:
	pop hl			;16e7	e1		.
	pop af			;16e8	f1		.
	and 0f0h		;16e9	e6 f0		. .
	or b			;16eb	b0		.
	ld (hl),a		;16ec	77		w
	ret			;16ed	c9		.
sub_16eeh:
	or a			;16ee	b7		.
	ret z			;16ef	c8		.
	push de			;16f0	d5		.
	push hl			;16f1	e5		.
	ld hl,040f8h		;16f2	21 f8 40	! . @
	ld d,a			;16f5	57		W
l16f6h:
	and 0f0h		;16f6	e6 f0		. .
	ld e,a			;16f8	5f		_
	ld a,d			;16f9	7a		z
	inc a			;16fa	3c		<
	and 00fh		;16fb	e6 0f		. .
	or e			;16fd	b3		.
	call sub_0f09h		;16fe	cd 09 0f	. . .
	pop hl			;1701	e1		.
	pop de			;1702	d1		.
	ret			;1703	c9		.
sub_1704h:
	ld a,(0602eh)		;1704	3a 2e 60	: . `
	or a			;1707	b7		.
	ret nz			;1708	c0		.
	ld de,040f8h		;1709	11 f8 40	. . @
	call sub_0ee1h		;170c	cd e1 0e	. . .
	ret c			;170f	d8		.
	ld (0602fh),a		;1710	32 2f 60	2 / `
	ld a,003h		;1713	3e 03		> .
	ld (0602eh),a		;1715	32 2e 60	2 . `
	ret			;1718	c9		.
	call sub_2a82h		;1719	cd 82 2a	. . *
	call 01527h		;171c	cd 27 15	. ' .
	dec b			;171f	05		.
	ld bc,0c221h		;1720	01 21 c2	. ! .
	ld d,e			;1723	53		S
	ld (hl),000h		;1724	36 00		6 .
	call sub_15b0h		;1726	cd b0 15	. . .
	call 01527h		;1729	cd 27 15	. ' .
	dec b			;172c	05		.
	ld bc,l2bcdh		;172d	01 cd 2b	. . +
	ld d,03ah		;1730	16 3a		. :
	cp d			;1732	ba		.
	ld e,h			;1733	5c		\
	cp 005h			;1734	fe 05		. .
	jr z,l173fh		;1736	28 07		( .
	ld a,(hl)		;1738	7e		~
	call sub_16eeh		;1739	cd ee 16	. . .
	jp l1925h		;173c	c3 25 19	. % .
l173fh:
	ld de,05cc6h		;173f	11 c6 5c	. . \
	ld bc,5		;1742	01 05 00	. . .
	ldir			;1745	ed b0		. .
	ld a,044h		;1747	3e 44		> D
	jp 0893fh		;1749	c3 3f 89	. ? .
	ld d,h			;174c	54		T
	ld b,c			;174d	41		A
	ld d,b			;174e	50		P
	ld b,l			;174f	45		E
	jr nz,l1793h		;1750	20 41		  A
	ld b,e			;1752	43		C
	ld d,h			;1753	54		T
	ld c,c			;1754	49		I
	ld c,a			;1755	4f		O
	ld c,(hl)		;1756	4e		N
	dec b			;1757	05		.
	ld d,b			;1758	50		P
	ld c,h			;1759	4c		L
	ld b,c			;175a	41		A
	ld e,c			;175b	59		Y
	ld b,l			;175c	45		E
	ld d,d			;175d	52		R
	jr nz,l17aeh		;175e	20 4e		  N
	ld d,l			;1760	55		U
	ld c,l			;1761	4d		M
	ld b,d			;1762	42		B
	ld b,l			;1763	45		E
	ld d,d			;1764	52		R
	jr nz,$+51		;1765	20 31		  1
	pop af			;1767	f1		.
	ld c,a			;1768	4f		O
	call SOMETHING_KBD	;1769	cd a7 17	. . .
	ld hl,04f79h		;176c	21 79 4f	! y O
	bit 4,(hl)		;176f	cb 66		. f
	jr z,l178fh		;1771	28 1c		( .
	cp 0f9h			;1773	fe f9		. .
	jr z,l178fh		;1775	28 18		( .
	cp 0a4h			;1777	fe a4		. .
	jr z,l178fh		;1779	28 14		( .
	cp 09ch			;177b	fe 9c		. .
	jr z,l178fh		;177d	28 10		( .
	cp 09dh			;177f	fe 9d		. .
	jr z,l178fh		;1781	28 0c		( .
	cp 0f4h			;1783	fe f4		. .
	jr z,l178fh		;1785	28 08		( .
	cp 00fh			;1787	fe 0f		. .
	jr z,l178fh		;1789	28 04		( .
	cp 006h			;178b	fe 06		. .
	jr nz,$-39		;178d	20 d7		  .
l178fh:
	xor a			;178f	af		.
	call SOMETHING_MEM	;1790	cd 1a 0f	. . .
l1793h:
	ld hl,08000h		;1793	21 00 80	! . .
	ld a,(04f76h)		;1796	3a 76 4f	: v O
	ld e,a			;1799	5f		_
	ld d,000h		;179a	16 00		. .
	add hl,de		;179c	19		.
	add hl,de		;179d	19		.
	ld e,(hl)		;179e	5e		^
	inc hl			;179f	23		#
	ld d,(hl)		;17a0	56		V
	ld hl,01766h		;17a1	21 66 17	! f .
	push hl			;17a4	e5		.
	push de			;17a5	d5		.
	ret			;17a6	c9		.
; Seems to be related to keyboard input
SOMETHING_KBD:
	push bc			;17a7	c5		.
	push de			;17a8	d5		.
	push hl			;17a9	e5		.
l17aah:
	xor a			;17aa	af		.
	call SOMETHING_MEM	;17ab	cd 1a 0f	. . .
l17aeh:
	ld hl,(05bb0h)		;17ae	2a b0 5b	* . [
	or h			;17b1	b4		.
	jr z,l17d6h		;17b2	28 22		( "
	ld a,(hl)		;17b4	7e		~
	cp 0ffh			;17b5	fe ff		. .
	jr nz,l17cfh		;17b7	20 16		  .
	inc hl			;17b9	23		#
	ld a,(hl)		;17ba	7e		~
	cp 0ffh			;17bb	fe ff		. .
	dec hl			;17bd	2b		+
	ld a,0ffh		;17be	3e ff		> .
	jr nz,l17cfh		;17c0	20 0d		  .
	ld hl,COLD_START	;17c2	21 00 00	! . .
	ld (05bb0h),hl		;17c5	22 b0 5b	" . [
	ld a,000h		;17c8	3e 00		> .
	ld (04f78h),a		;17ca	32 78 4f	2 x O
	jr l17d6h		;17cd	18 07		. .
l17cfh:
	inc hl			;17cf	23		#
	ld (05bb0h),hl		;17d0	22 b0 5b	" . [
	ld b,a			;17d3	47		G
	jr l17f5h		;17d4	18 1f		. .
l17d6h:
	ld de,040e4h		;17d6	11 e4 40	. . @
	ld a,(04f76h)		;17d9	3a 76 4f	: v O
	cp 005h			;17dc	fe 05		. .
	ld b,00ah		;17de	06 0a		. .
	jr z,l17f5h		;17e0	28 13		( .
	call sub_0ee1h		;17e2	cd e1 0e	. . .
	jr nc,l17ech		;17e5	30 05		0 .
	call sub_0334h		;17e7	cd 34 03	. 4 .
	jr l17d6h		;17ea	18 ea		. .
l17ech:
	ld b,001h		;17ec	06 01		. .
	call sub_1ae6h		;17ee	cd e6 1a	. . .
	ld b,a			;17f1	47		G
	call 082b6h		;17f2	cd b6 82	. . .
l17f5h:
	in a,(0ffh)		;17f5	db ff		. .
	ld hl,04f78h		;17f7	21 78 4f	! x O
	cp 0ffh			;17fa	fe ff		. .
	jr z,l1839h		;17fc	28 3b		( ;
	ld d,a			;17fe	57		W
	ld a,(05cbah)		;17ff	3a ba 5c	: . \
	or a			;1802	b7		.
	jr nz,l1839h		;1803	20 34		  4
	ld a,b			;1805	78		x
	cp 09bh			;1806	fe 9b		. .
	jr nz,l180fh		;1808	20 05		  .
	ld a,055h		;180a	3e 55		> U
	ld (hl),a		;180c	77		w
	jr l17d6h		;180d	18 c7		. .
l180fh:
	ld a,(hl)		;180f	7e		~
	cp 055h			;1810	fe 55		. U
	jr nz,l181eh		;1812	20 0a		  .
	ld c,b			;1814	48		H
	inc (hl)		;1815	34		4
	ld a,b			;1816	78		x
	cp d			;1817	ba		.
	jr nz,l17d6h		;1818	20 bc		  .
	ld (hl),0aah		;181a	36 aa		6 .
	jr l17d6h		;181c	18 b8		. .
l181eh:
	cp 056h			;181e	fe 56		. V
	jr nz,l1834h		;1820	20 12		  .
	ld (hl),000h		;1822	36 00		6 .
	ld a,(05b70h)		;1824	3a 70 5b	: p [
	cp b			;1827	b8		.
	jr nz,l17d6h		;1828	20 ac		  .
	ld a,(05b6fh)		;182a	3a 6f 5b	: o [
	cp c			;182d	b9		.
	jr nz,l17d6h		;182e	20 a6		  .
	ld (hl),0aah		;1830	36 aa		6 .
	jr l17d6h		;1832	18 a2		. .
l1834h:
	ld a,(hl)		;1834	7e		~
	cp 0aah			;1835	fe aa		. .
	jr nz,l17d6h		;1837	20 9d		  .
l1839h:
	push bc			;1839	c5		.
	ld a,(05b7bh)		;183a	3a 7b 5b	: { [
	and 001h		;183d	e6 01		. .
	jp z,l1863h		;183f	ca 63 18	. c .
	ld a,b			;1842	78		x
	cp 01bh			;1843	fe 1b		. .
	jp nz,l185bh		;1845	c2 5b 18	. [ .
	ld a,(0609dh)		;1848	3a 9d 60	: . `
	or a			;184b	b7		.
	call z,09ca7h		;184c	cc a7 9c	. . .
	ld a,001h		;184f	3e 01		> .
	ld (060cdh),a		;1851	32 cd 60	2 . `
	sub a			;1854	97		.
	ld (06054h),a		;1855	32 54 60	2 T `
	jp l1863h		;1858	c3 63 18	. c .
l185bh:
	ld a,(0609dh)		;185b	3a 9d 60	: . `
	or a			;185e	b7		.
	ld a,b			;185f	78		x
	call nz,09d61h		;1860	c4 61 9d	. a .
l1863h:
	pop bc			;1863	c1		.
	ld a,b			;1864	78		x
	ld hl,04f79h		;1865	21 79 4f	! y O
	cp 0a1h			;1868	fe a1		. .
	jr nz,l1871h		;186a	20 05		  .
	res 0,(hl)		;186c	cb 86		. .
	jp l1916h		;186e	c3 16 19	. . .
l1871h:
	cp 0b1h			;1871	fe b1		. .
	jr nz,l187ah		;1873	20 05		  .
	set 0,(hl)		;1875	cb c6		. .
	jp l1916h		;1877	c3 16 19	. . .
l187ah:
	cp 0a0h			;187a	fe a0		. .
	jr nz,l1883h		;187c	20 05		  .
	res 7,(hl)		;187e	cb be		. .
	jp l1916h		;1880	c3 16 19	. . .
l1883h:
	cp 0b0h			;1883	fe b0		. .
	jr nz,l188ch		;1885	20 05		  .
	set 7,(hl)		;1887	cb fe		. .
	jp l1916h		;1889	c3 16 19	. . .
l188ch:
	ld a,(04f76h)		;188c	3a 76 4f	: v O
	ld (04f77h),a		;188f	32 77 4f	2 w O
	ld a,(l003ch)		;1892	3a 3c 00	: < .
	cp 0bbh			;1895	fe bb		. .
	jr nz,l18b0h		;1897	20 17		  .
	ld a,(04f76h)		;1899	3a 76 4f	: v O
	cp 098h			;189c	fe 98		. .
	jr nz,l18b0h		;189e	20 10		  .
	ld a,b			;18a0	78		x
	cp 013h			;18a1	fe 13		. .
	jp z,l19a4h		;18a3	ca a4 19	. . .
	cp 08fh			;18a6	fe 8f		. .
	jp z,l19a4h		;18a8	ca a4 19	. . .
	cp 009h			;18ab	fe 09		. .
	jp z,l19a4h		;18ad	ca a4 19	. . .
l18b0h:
	ld a,(05cbah)		;18b0	3a ba 5c	: . \
	cp 001h			;18b3	fe 01		. .
	jr nz,l18c3h		;18b5	20 0c		  .
	ld a,b			;18b7	78		x
	cp 099h			;18b8	fe 99		. .
	call z,08fa5h		;18ba	cc a5 8f	. . .
	ld a,b			;18bd	78		x
	out (014h),a		;18be	d3 14		. .
	jp l17d6h		;18c0	c3 d6 17	. . .
l18c3h:
	ld a,b			;18c3	78		x
	ld (04f76h),a		;18c4	32 76 4f	2 v O
	bit 4,(hl)		;18c7	cb 66		. f
	jr nz,l190ah		;18c9	20 3f		  ?
	cp 091h			;18cb	fe 91		. .
l18cdh:
	jr c,l18f7h		;18cd	38 28		8 (
	cp 09eh			;18cf	fe 9e		. .
	jr c,l190eh		;18d1	38 3b		8 ;
	cp 0e4h			;18d3	fe e4		. .
	jr z,l190eh		;18d5	28 37		( 7
	cp 0f0h			;18d7	fe f0		. .
	jr nc,l190eh		;18d9	30 33		0 3
	cp 0dch			;18db	fe dc		. .
	jr z,l190eh		;18dd	28 2f		( /
	cp 0d2h			;18df	fe d2		. .
	jr z,l190eh		;18e1	28 2b		( +
	cp 0d3h			;18e3	fe d3		. .
	jr z,l190eh		;18e5	28 27		( '
	cp 0d4h			;18e7	fe d4		. .
	jr z,l190eh		;18e9	28 23		( #
	cp 0d5h			;18eb	fe d5		. .
	jr z,l190eh		;18ed	28 1f		( .
	cp 0a4h			;18ef	fe a4		. .
	jr z,l190eh		;18f1	28 1b		( .
	cp 0a5h			;18f3	fe a5		. .
	jr z,l190eh		;18f5	28 17		( .
l18f7h:
	bit 1,(hl)		;18f7	cb 4e		. N
	jr z,l190ah		;18f9	28 0f		( .
	res 1,(hl)		;18fb	cb 8e		. .
	call sub_2295h		;18fd	cd 95 22	. . "
	call sub_1bddh		;1900	cd dd 1b	. . .
	call sub_1318h		;1903	cd 18 13	. . .
	ld c,03ah		;1906	0e 3a		. :
	halt			;1908	76		v
	ld c,a			;1909	4f		O
l190ah:
	pop hl			;190a	e1		.
	pop de			;190b	d1		.
	pop bc			;190c	c1		.
	ret			;190d	c9		.
l190eh:
	res 1,(hl)		;190e	cb 8e		. .
	ld sp,04ff1h		;1910	31 f1 4f	1 . O
	jp l178fh		;1913	c3 8f 17	. . .
l1916h:
	ld b,a			;1916	47		G
	ld a,(05cbah)		;1917	3a ba 5c	: . \
	cp 001h			;191a	fe 01		. .
	jp nz,l17aah		;191c	c2 aa 17	. . .
	ld a,b			;191f	78		x
	out (014h),a		;1920	d3 14		. .
	jp l17aah		;1922	c3 aa 17	. . .
l1925h:
	xor a			;1925	af		.
	call SOMETHING_MEM	;1926	cd 1a 0f	. . .
	call sub_223fh		;1929	cd 3f 22	. ? "
	call sub_1bddh		;192c	cd dd 1b	. . .
	call sub_1318h		;192f	cd 18 13	. . .
	ld c,0c9h		;1932	0e c9		. .
l1934h:
	ld hl,04f79h		;1934	21 79 4f	! y O
	set 1,(hl)		;1937	cb ce		. .
	xor a			;1939	af		.
	jp SOMETHING_MEM	;193a	c3 1a 0f	. . .
	add a,a			;193d	87		.
	add a,l			;193e	85		.
	ld l,a			;193f	6f		o
	ld a,000h		;1940	3e 00		> .
	adc a,h			;1942	8c		.
	ld h,a			;1943	67		g
	ld a,(hl)		;1944	7e		~
	inc hl			;1945	23		#
	ld h,(hl)		;1946	66		f
	ld l,a			;1947	6f		o
	ret			;1948	c9		.
	call sub_1b0dh		;1949	cd 0d 1b	. . .
	call sub_13c8h		;194c	cd c8 13	. . .
	nop			;194f	00		.
	ret nc			;1950	d0		.
	ld de,0ba3ah		;1951	11 3a ba	. : .
	ld e,h			;1954	5c		\
	cp 005h			;1955	fe 05		. .
	jr nz,l1966h		;1957	20 0d		  .
	ld a,056h		;1959	3e 56		> V
	ld hl,COLD_START	;195b	21 00 00	! . .
	call 088dch		;195e	cd dc 88	. . .
	ld a,(05cc6h)		;1961	3a c6 5c	: . \
	jr l1969h		;1964	18 03		. .
l1966h:
	ld a,(VERSION)		;1966	3a 04 00	: . .
l1969h:
	call HEX2		;1969	cd a3 1a	. . .
	ld a,b			;196c	78		x
	call OUTCH		;196d	cd 84 10	. . .
	ld a,'.'		;1970	3e 2e		> .
	call OUTCH		;1972	cd 84 10	. . .
	ld a,c			;1975	79		y
	call OUTCH		;1976	cd 84 10	. . .
	ld a,005h		;1979	3e 05		> .
	call OUTCH		;197b	cd 84 10	. . .
l197eh:
	call SOMETHING_KBD	;197e	cd a7 17	. . .
	cp 01bh			;1981	fe 1b		. .
	jp nz,l1925h		;1983	c2 25 19	. % .
l1986h:
	call SOMETHING_KBD	;1986	cd a7 17	. . .
	cp 046h			;1989	fe 46		. F
	jr z,l19e7h		;198b	28 5a		( Z
	cp 044h			;198d	fe 44		. D
	jp z,l1a1dh		;198f	ca 1d 1a	. . .
	cp 053h			;1992	fe 53		. S
	jp z,l1a60h		;1994	ca 60 1a	. ` .
	cp 050h			;1997	fe 50		. P
	jp z,l1a78h		;1999	ca 78 1a	. x .
	cp 043h			;199c	fe 43		. C
	jp l1a95h		;199e	c3 95 1a	. . .
	jp l1925h		;19a1	c3 25 19	. % .
l19a4h:
	ld sp,04ff1h		;19a4	31 f1 4f	1 . O
	ld hl,01766h		;19a7	21 66 17	! f .
	push hl			;19aa	e5		.
	call sub_2a82h		;19ab	cd 82 2a	. . *
	call sub_13c8h		;19ae	cd c8 13	. . .
	ld de,l36ceh+2		;19b1	11 d0 36	. . 6
	ld de,040e4h		;19b4	11 e4 40	. . @
l19b7h:
	call sub_0ee1h		;19b7	cd e1 0e	. . .
	jr nc,l19c1h		;19ba	30 05		0 .
	call sub_0334h		;19bc	cd 34 03	. 4 .
	jr l19b7h		;19bf	18 f6		. .
l19c1h:
	cp 004h			;19c1	fe 04		. .
	jr nz,l19d0h		;19c3	20 0b		  .
	call sub_13c8h		;19c5	cd c8 13	. . .
	ld b,a			;19c8	47		G
	ret nc			;19c9	d0		.
	inc hl			;19ca	23		#
	out (070h),a		;19cb	d3 70		. p
	jp l1934h		;19cd	c3 34 19	. 4 .
l19d0h:
	call sub_13c8h		;19d0	cd c8 13	. . .
	ld l,d			;19d3	6a		j
	ret nc			;19d4	d0		.
	djnz $-59		;19d5	10 c3		. .
	inc (hl)		;19d7	34		4
	add hl,de		;19d8	19		.
sub_19d9h:
	push bc			;19d9	c5		.
	call HEX2		;19da	cd a3 1a	. . .
	ld a,b			;19dd	78		x
	call OUTCH		;19de	cd 84 10	. . .
	ld a,c			;19e1	79		y
	call OUTCH		;19e2	cd 84 10	. . .
	pop bc			;19e5	c1		.
	ret			;19e6	c9		.
l19e7h:
	call sub_1a00h		;19e7	cd 00 1a	. . .
	ld h,b			;19ea	60		`
	ld l,c			;19eb	69		i
	ld d,b			;19ec	50		P
	ld e,c			;19ed	59		Y
	call sub_1a00h		;19ee	cd 00 1a	. . .
	ld (hl),b		;19f1	70		p
	inc hl			;19f2	23		#
	ld (hl),c		;19f3	71		q
	inc hl			;19f4	23		#
	ex de,hl		;19f5	eb		.
	call sub_1a00h		;19f6	cd 00 1a	. . .
	dec bc			;19f9	0b		.
	dec bc			;19fa	0b		.
	ldir			;19fb	ed b0		. .
	jp l197eh		;19fd	c3 7e 19	. ~ .
sub_1a00h:
	call sub_1a0bh		;1a00	cd 0b 1a	. . .
	push af			;1a03	f5		.
	call sub_1a0bh		;1a04	cd 0b 1a	. . .
	ld c,a			;1a07	4f		O
	pop af			;1a08	f1		.
	ld b,a			;1a09	47		G
	ret			;1a0a	c9		.
sub_1a0bh:
	call SOMETHING_KBD	;1a0b	cd a7 17	. . .
	ld b,a			;1a0e	47		G
	call OUTCH		;1a0f	cd 84 10	. . .
	call SOMETHING_KBD	;1a12	cd a7 17	. . .
	call OUTCH		;1a15	cd 84 10	. . .
	ld c,a			;1a18	4f		O
	call sub_1ac0h		;1a19	cd c0 1a	. . .
	ret			;1a1c	c9		.
l1a1dh:
	call sub_1a6ah		;1a1d	cd 6a 1a	. j .
	ld b,018h		;1a20	06 18		. .
l1a22h:
	ld a,005h		;1a22	3e 05		> .
	call OUTCH		;1a24	cd 84 10	. . .
	ld a,h			;1a27	7c		|
	call sub_19d9h		;1a28	cd d9 19	. . .
	ld a,l			;1a2b	7d		}
	call sub_19d9h		;1a2c	cd d9 19	. . .
	push hl			;1a2f	e5		.
l1a30h:
	call sub_1570h		;1a30	cd 70 15	. p .
	ld bc,0cd7eh		;1a33	01 7e cd	. ~ .
	exx			;1a36	d9		.
	add hl,de		;1a37	19		.
	inc hl			;1a38	23		#
	ld a,l			;1a39	7d		}
	and 007h		;1a3a	e6 07		. .
	jr nz,l1a30h		;1a3c	20 f2		  .
	call sub_1570h		;1a3e	cd 70 15	. p .
	ld (bc),a		;1a41	02		.
	pop hl			;1a42	e1		.
l1a43h:
	ld a,(hl)		;1a43	7e		~
	cp 020h			;1a44	fe 20		.  
	jr c,l1a50h		;1a46	38 08		8 .
	cp 0a0h			;1a48	fe a0		. .
	jr nc,l1a50h		;1a4a	30 04		0 .
	cp 07fh			;1a4c	fe 7f		. .
	jr nz,l1a52h		;1a4e	20 02		  .
l1a50h:
	ld a,02eh		;1a50	3e 2e		> .
l1a52h:
	call OUTCH		;1a52	cd 84 10	. . .
	inc hl			;1a55	23		#
	ld a,l			;1a56	7d		}
	and 007h		;1a57	e6 07		. .
	jr nz,l1a43h		;1a59	20 e8		  .
	djnz l1a22h		;1a5b	10 c5		. .
	jp l197eh		;1a5d	c3 7e 19	. ~ .
l1a60h:
	call sub_1a6ah		;1a60	cd 6a 1a	. j .
l1a63h:
	call sub_1a0bh		;1a63	cd 0b 1a	. . .
	ld (hl),a		;1a66	77		w
	inc hl			;1a67	23		#
	jr l1a63h		;1a68	18 f9		. .
sub_1a6ah:
	call sub_1b0dh		;1a6a	cd 0d 1b	. . .
	call sub_1a00h		;1a6d	cd 00 1a	. . .
	ld a,005h		;1a70	3e 05		> .
	call OUTCH		;1a72	cd 84 10	. . .
	ld h,b			;1a75	60		`
	ld l,c			;1a76	69		i
	ret			;1a77	c9		.
l1a78h:
	call sub_1b0dh		;1a78	cd 0d 1b	. . .
	call SOMETHING_KBD	;1a7b	cd a7 17	. . .
	call OUTCH		;1a7e	cd 84 10	. . .
	and 00fh		;1a81	e6 0f		. .
	ld (05cb9h),a		;1a83	32 b9 5c	2 . \
l1a86h:
	call SOMETHING_KBD	;1a86	cd a7 17	. . .
	cp 01bh			;1a89	fe 1b		. .
	jr nz,l1a86h		;1a8b	20 f9		  .
	ld a,000h		;1a8d	3e 00		> .
	ld (05cb9h),a		;1a8f	32 b9 5c	2 . \
	jp l1986h		;1a92	c3 86 19	. . .
l1a95h:
	ld a,00fh		;1a95	3e 0f		> .
	out (020h),a		;1a97	d3 20		.  
	ld a,000h		;1a99	3e 00		> .
	out (02fh),a		;1a9b	d3 2f		. /
	call SOMETHING_KBD	;1a9d	cd a7 17	. . .
	jp l1925h		;1aa0	c3 25 19	. % .
; Input a = 0xNM
; Output (b,c) ascii values of N and M
HEX2:
	ld b,a			;1aa3	47		G
	and 00fh		;1aa4	e6 0f		. .
	call HEX1		;1aa6	cd b8 1a	. . .
	ld c,a			;1aa9	4f		O
	ld a,b			;1aaa	78		x
	srl a			;1aab	cb 3f		. ?
	srl a			;1aad	cb 3f		. ?
	srl a			;1aaf	cb 3f		. ?
	srl a			;1ab1	cb 3f		. ?
	call HEX1		;1ab3	cd b8 1a	. . .
	ld b,a			;1ab6	47		G
	ret			;1ab7	c9		.
; Input a = 0..f
; Output a = '0'..'9','A'..'F'
HEX1:
	add a,030h		;1ab8	c6 30		. 0
	cp 03ah			;1aba	fe 3a		. :
	ret c			;1abc	d8		.
	add a,007h		;1abd	c6 07		. .
	ret			;1abf	c9		.
sub_1ac0h:
	ld a,b			;1ac0	78		x
	call sub_1ad3h		;1ac1	cd d3 1a	. . .
	ld b,a			;1ac4	47		G
	ld a,c			;1ac5	79		y
	call sub_1ad3h		;1ac6	cd d3 1a	. . .
	sla b			;1ac9	cb 20		.  
	sla b			;1acb	cb 20		.  
	sla b			;1acd	cb 20		.  
	sla b			;1acf	cb 20		.  
	or b			;1ad1	b0		.
	ret			;1ad2	c9		.
sub_1ad3h:
	sub 030h		;1ad3	d6 30		. 0
	cp 00ah			;1ad5	fe 0a		. .
	ret c			;1ad7	d8		.
	sub 007h		;1ad8	d6 07		. .
	res 5,a			;1ada	cb af		. .
	cp 00ah			;1adc	fe 0a		. .
	jr c,l1ae3h		;1ade	38 03		8 .
	cp 010h			;1ae0	fe 10		. .
	ret			;1ae2	c9		.
l1ae3h:
	pop bc			;1ae3	c1		.
	scf			;1ae4	37		7
	ret			;1ae5	c9		.
sub_1ae6h:
	push af			;1ae6	f5		.
	ld a,(05cb9h)		;1ae7	3a b9 5c	: . \
	or a			;1aea	b7		.
	jr z,l1b0bh		;1aeb	28 1e		( .
	cp b			;1aed	b8		.
	jr nz,l1b0bh		;1aee	20 1b		  .
	pop af			;1af0	f1		.
	push af			;1af1	f5		.
	cp 020h			;1af2	fe 20		.  
	jr c,l1affh		;1af4	38 09		8 .
	cp 07bh			;1af6	fe 7b		. {
	jr nc,l1affh		;1af8	30 05		0 .
	call OUTCH		;1afa	cd 84 10	. . .
	jr l1b0bh		;1afd	18 0c		. .
l1affh:
	push bc			;1aff	c5		.
	ld b,a			;1b00	47		G
	ld a,02ah		;1b01	3e 2a		> *
	call OUTCH		;1b03	cd 84 10	. . .
	ld a,b			;1b06	78		x
	call sub_19d9h		;1b07	cd d9 19	. . .
	pop bc			;1b0a	c1		.
l1b0bh:
	pop af			;1b0b	f1		.
	ret			;1b0c	c9		.
sub_1b0dh:
	call sub_2a82h		;1b0d	cd 82 2a	. . *
	ld de,04185h		;1b10	11 85 41	. . A
	call sub_1101h		;1b13	cd 01 11	. . .
	ld h,d			;1b16	62		b
	ld l,e			;1b17	6b		k
	ld de,l0043h		;1b18	11 43 00	. C .
	ld b,01ah		;1b1b	06 1a		. .
l1b1dh:
	ld (hl),0c8h		;1b1d	36 c8		6 .
	add hl,de		;1b1f	19		.
	djnz l1b1dh		;1b20	10 fb		. .
	ret			;1b22	c9		.
sub_1b23h:
	ld a,(04f79h)		;1b23	3a 79 4f	: y O
	bit 7,a			;1b26	cb 7f		. .
	jr z,l1b6ah		;1b28	28 40		( @
	ld a,(04f76h)		;1b2a	3a 76 4f	: v O
	cp 040h			;1b2d	fe 40		. @
	jr nc,l1b5bh		;1b2f	30 2a		0 *
	res 4,a			;1b31	cb a7		. .
	cp 02bh			;1b33	fe 2b		. +
	jr nz,l1b3bh		;1b35	20 04		  .
	ld a,09ch		;1b37	3e 9c		> .
	jr l1b67h		;1b39	18 2c		. ,
l1b3bh:
	cp 02ah			;1b3b	fe 2a		. *
	jr nz,l1b43h		;1b3d	20 04		  .
	ld a,09dh		;1b3f	3e 9d		> .
	jr l1b67h		;1b41	18 24		. $
l1b43h:
	cp 02ch			;1b43	fe 2c		. ,
	jr nz,l1b4bh		;1b45	20 04		  .
	ld a,09eh		;1b47	3e 9e		> .
	jr l1b67h		;1b49	18 1c		. .
l1b4bh:
	cp 02eh			;1b4b	fe 2e		. .
	jr nz,l1b53h		;1b4d	20 04		  .
	ld a,09fh		;1b4f	3e 9f		> .
	jr l1b67h		;1b51	18 14		. .
l1b53h:
	cp 02fh			;1b53	fe 2f		. /
	jr nz,l1b6ah		;1b55	20 13		  .
	ld a,080h		;1b57	3e 80		> .
	jr l1b67h		;1b59	18 0c		. .
l1b5bh:
	set 5,a			;1b5b	cb ef		. .
	cp 060h			;1b5d	fe 60		. `
	jr z,l1b6ah		;1b5f	28 09		( .
	cp 07ch			;1b61	fe 7c		. |
	jr nc,l1b6ah		;1b63	30 05		0 .
	add a,020h		;1b65	c6 20		.  
l1b67h:
	ld (04f76h),a		;1b67	32 76 4f	2 v O
l1b6ah:
	ld a,(04f76h)		;1b6a	3a 76 4f	: v O
l1b6dh:
	ld hl,(04f80h)		;1b6d	2a 80 4f	* . O
	ld (hl),a		;1b70	77		w
	call OUTCH		;1b71	cd 84 10	. . .
	inc hl			;1b74	23		#
	ld (04f80h),hl		;1b75	22 80 4f	" . O
	ld a,(04f82h)		;1b78	3a 82 4f	: . O
	inc a			;1b7b	3c		<
	ld b,a			;1b7c	47		G
	call sub_22bah		;1b7d	cd ba 22	. . "
	ld c,a			;1b80	4f		O
	ld a,b			;1b81	78		x
	cp c			;1b82	b9		.
	jr z,l1b89h		;1b83	28 04		( .
	ld (04f82h),a		;1b85	32 82 4f	2 . O
	ret			;1b88	c9		.
l1b89h:
	ld a,(04f8bh)		;1b89	3a 8b 4f	: . O
	dec a			;1b8c	3d		=
	ld b,a			;1b8d	47		G
	ld a,(04f83h)		;1b8e	3a 83 4f	: . O
	cp b			;1b91	b8		.
	jr z,l1b9ch		;1b92	28 08		( .
	inc a			;1b94	3c		<
	ld (04f83h),a		;1b95	32 83 4f	2 . O
	xor a			;1b98	af		.
	ld (04f82h),a		;1b99	32 82 4f	2 . O
l1b9ch:
	call sub_22a1h		;1b9c	cd a1 22	. . "
	call sub_2290h		;1b9f	cd 90 22	. . "
	ret			;1ba2	c9		.
sub_1ba3h:
	ld a,(04f76h)		;1ba3	3a 76 4f	: v O
	call OUTCH		;1ba6	cd 84 10	. . .
	ret			;1ba9	c9		.
	ld hl,04f76h		;1baa	21 76 4f	! v O
	ld (hl),008h		;1bad	36 08		6 .
	push hl			;1baf	e5		.
	call sub_1c75h		;1bb0	cd 75 1c	. u .
	pop hl			;1bb3	e1		.
	ld (hl),020h		;1bb4	36 20		6  
	push hl			;1bb6	e5		.
	call sub_1b23h		;1bb7	cd 23 1b	. # .
	pop hl			;1bba	e1		.
	ld (hl),008h		;1bbb	36 08		6 .
	call sub_1c75h		;1bbd	cd 75 1c	. u .
	ret			;1bc0	c9		.
	ld a,0fah		;1bc1	3e fa		> .
	jr l1b6dh		;1bc3	18 a8		. .
	ld a,0fdh		;1bc5	3e fd		> .
	jr l1b6dh		;1bc7	18 a4		. .
	ld a,0f1h		;1bc9	3e f1		> .
	jr l1b6dh		;1bcb	18 a0		. .
	ld a,0f0h		;1bcd	3e f0		> .
	jr l1b6dh		;1bcf	18 9c		. .
	ld a,0fbh		;1bd1	3e fb		> .
	jr l1b6dh		;1bd3	18 98		. .
	ld a,0feh		;1bd5	3e fe		> .
	jr l1b6dh		;1bd7	18 94		. .
	ld a,0fch		;1bd9	3e fc		> .
	jr l1b6dh		;1bdb	18 90		. .
sub_1bddh:
	call sub_1be6h		;1bdd	cd e6 1b	. . .
	ld a,004h		;1be0	3e 04		> .
	call OUTCH		;1be2	cd 84 10	. . .
	ret			;1be5	c9		.
sub_1be6h:
	ld hl,04ac6h		;1be6	21 c6 4a	! . J
	ld (04f80h),hl		;1be9	22 80 4f	" . O
	xor a			;1bec	af		.
	ld (04f82h),a		;1bed	32 82 4f	2 . O
	ld (04f83h),a		;1bf0	32 83 4f	2 . O
	ret			;1bf3	c9		.
	ld a,(04f8bh)		;1bf4	3a 8b 4f	: . O
	dec a			;1bf7	3d		=
	ld b,a			;1bf8	47		G
	ld a,(04f83h)		;1bf9	3a 83 4f	: . O
	cp b			;1bfc	b8		.
	jr z,l1c03h		;1bfd	28 04		( .
	inc a			;1bff	3c		<
	ld (04f83h),a		;1c00	32 83 4f	2 . O
l1c03h:
	xor a			;1c03	af		.
	ld (04f82h),a		;1c04	32 82 4f	2 . O
	call sub_22a1h		;1c07	cd a1 22	. . "
	call sub_2290h		;1c0a	cd 90 22	. . "
	ret			;1c0d	c9		.
	ld a,(04f8bh)		;1c0e	3a 8b 4f	: . O
	dec a			;1c11	3d		=
	ld b,a			;1c12	47		G
	ld a,(04f83h)		;1c13	3a 83 4f	: . O
	cp b			;1c16	b8		.
	ret z			;1c17	c8		.
	inc a			;1c18	3c		<
	ld (04f83h),a		;1c19	32 83 4f	2 . O
	ld hl,(04f80h)		;1c1c	2a 80 4f	* . O
	ld de,00028h		;1c1f	11 28 00	. ( .
	add hl,de		;1c22	19		.
	ld (04f80h),hl		;1c23	22 80 4f	" . O
	call sub_2242h		;1c26	cd 42 22	. B "
	ret			;1c29	c9		.
	ld a,(04f83h)		;1c2a	3a 83 4f	: . O
	dec a			;1c2d	3d		=
	ret m			;1c2e	f8		.
	ld (04f83h),a		;1c2f	32 83 4f	2 . O
	ld hl,(04f80h)		;1c32	2a 80 4f	* . O
	ld de,00028h		;1c35	11 28 00	. ( .
	xor a			;1c38	af		.
	sbc hl,de		;1c39	ed 52		. R
	ld (04f80h),hl		;1c3b	22 80 4f	" . O
	call sub_1ba3h		;1c3e	cd a3 1b	. . .
	ret			;1c41	c9		.
	call sub_22bah		;1c42	cd ba 22	. . "
	ld b,a			;1c45	47		G
	dec b			;1c46	05		.
	ld a,(04f82h)		;1c47	3a 82 4f	: . O
	cp b			;1c4a	b8		.
	jr nc,l1c5ch		;1c4b	30 0f		0 .
	inc a			;1c4d	3c		<
	ld (04f82h),a		;1c4e	32 82 4f	2 . O
	ld hl,(04f80h)		;1c51	2a 80 4f	* . O
	inc hl			;1c54	23		#
	ld (04f80h),hl		;1c55	22 80 4f	" . O
	call sub_1ba3h		;1c58	cd a3 1b	. . .
	ret			;1c5b	c9		.
l1c5ch:
	ld a,(04f8bh)		;1c5c	3a 8b 4f	: . O
	dec a			;1c5f	3d		=
	ld b,a			;1c60	47		G
	ld a,(04f83h)		;1c61	3a 83 4f	: . O
	cp b			;1c64	b8		.
	ret z			;1c65	c8		.
	inc a			;1c66	3c		<
	ld (04f83h),a		;1c67	32 83 4f	2 . O
	xor a			;1c6a	af		.
	ld (04f82h),a		;1c6b	32 82 4f	2 . O
	call sub_22a1h		;1c6e	cd a1 22	. . "
	call sub_2242h		;1c71	cd 42 22	. B "
	ret			;1c74	c9		.
sub_1c75h:
	ld a,(04f82h)		;1c75	3a 82 4f	: . O
	or a			;1c78	b7		.
	jr z,l1c8ah		;1c79	28 0f		( .
	dec a			;1c7b	3d		=
	ld (04f82h),a		;1c7c	32 82 4f	2 . O
	ld hl,(04f80h)		;1c7f	2a 80 4f	* . O
	dec hl			;1c82	2b		+
	ld (04f80h),hl		;1c83	22 80 4f	" . O
	call sub_1ba3h		;1c86	cd a3 1b	. . .
	ret			;1c89	c9		.
l1c8ah:
	ld a,(04f83h)		;1c8a	3a 83 4f	: . O
	or a			;1c8d	b7		.
	ret z			;1c8e	c8		.
	dec a			;1c8f	3d		=
	ld (04f83h),a		;1c90	32 83 4f	2 . O
	call sub_22bah		;1c93	cd ba 22	. . "
	dec a			;1c96	3d		=
	ld (04f82h),a		;1c97	32 82 4f	2 . O
	call sub_22a1h		;1c9a	cd a1 22	. . "
	call sub_2290h		;1c9d	cd 90 22	. . "
	ret			;1ca0	c9		.
sub_1ca1h:
	ld hl,04ed5h		;1ca1	21 d5 4e	! . N
	ld bc,(04f80h)		;1ca4	ed 4b 80 4f	. K . O
	xor a			;1ca8	af		.
	sbc hl,bc		;1ca9	ed 42		. B
	ld b,h			;1cab	44		D
	ld c,l			;1cac	4d		M
	jr l1cb9h		;1cad	18 0a		. .
sub_1cafh:
	ld a,027h		;1caf	3e 27		> '
	ld hl,04f82h		;1cb1	21 82 4f	! . O
	ld b,(hl)		;1cb4	46		F
	sub b			;1cb5	90		.
	ld c,a			;1cb6	4f		O
	ld b,000h		;1cb7	06 00		. .
l1cb9h:
	ld a,020h		;1cb9	3e 20		>  
	ld hl,(04f80h)		;1cbb	2a 80 4f	* . O
	ld (hl),a		;1cbe	77		w
	ld d,h			;1cbf	54		T
	ld e,l			;1cc0	5d		]
	inc de			;1cc1	13		.
	ld a,b			;1cc2	78		x
	or c			;1cc3	b1		.
	jr z,l1cc8h		;1cc4	28 02		( .
	ldir			;1cc6	ed b0		. .
l1cc8h:
	call sub_1ba3h		;1cc8	cd a3 1b	. . .
	ret			;1ccb	c9		.
	ld ix,(04f80h)		;1ccc	dd 2a 80 4f	. * . O
	ld hl,04ac6h		;1cd0	21 c6 4a	! . J
	ld (04f80h),hl		;1cd3	22 80 4f	" . O
	call sub_2249h		;1cd6	cd 49 22	. I "
	call sub_1ca1h		;1cd9	cd a1 1c	. . .
	ld (04f80h),ix		;1cdc	dd 22 80 4f	. " . O
	jr l1cfch		;1ce0	18 1a		. .
	ld hl,(04f80h)		;1ce2	2a 80 4f	* . O
	push hl			;1ce5	e5		.
	ld a,(04f82h)		;1ce6	3a 82 4f	: . O
	ld e,a			;1ce9	5f		_
	ld d,000h		;1cea	16 00		. .
	or a			;1cec	b7		.
	sbc hl,de		;1ced	ed 52		. R
	ld (04f80h),hl		;1cef	22 80 4f	" . O
	call sub_2249h		;1cf2	cd 49 22	. I "
	call sub_1cafh		;1cf5	cd af 1c	. . .
	pop hl			;1cf8	e1		.
	ld (04f80h),hl		;1cf9	22 80 4f	" . O
l1cfch:
	call sub_2295h		;1cfc	cd 95 22	. . "
	call sub_2249h		;1cff	cd 49 22	. I "
	call sub_2290h		;1d02	cd 90 22	. . "
	ret			;1d05	c9		.
sub_1d06h:
	push hl			;1d06	e5		.
	push de			;1d07	d5		.
	push bc			;1d08	c5		.
	push af			;1d09	f5		.
	ld a,(04f83h)		;1d0a	3a 83 4f	: . O
	push af			;1d0d	f5		.
	ld a,b			;1d0e	78		x
	ld (04f83h),a		;1d0f	32 83 4f	2 . O
	call sub_22bah		;1d12	cd ba 22	. . "
	ld (05bb4h),a		;1d15	32 b4 5b	2 . [
	inc c			;1d18	0c		.
	sub c			;1d19	91		.
	ld e,a			;1d1a	5f		_
	ld d,000h		;1d1b	16 00		. .
	ld (05bb6h),de		;1d1d	ed 53 b6 5b	. S . [
	pop af			;1d21	f1		.
	ld (04f83h),a		;1d22	32 83 4f	2 . O
	pop af			;1d25	f1		.
	pop bc			;1d26	c1		.
	push bc			;1d27	c5		.
	push af			;1d28	f5		.
	ld hl,04a9eh		;1d29	21 9e 4a	! . J
	inc b			;1d2c	04		.
	ld de,00028h		;1d2d	11 28 00	. ( .
l1d30h:
	add hl,de		;1d30	19		.
	djnz l1d30h		;1d31	10 fd		. .
	ld a,(05bb4h)		;1d33	3a b4 5b	: . [
	dec a			;1d36	3d		=
	ld e,a			;1d37	5f		_
	ld d,000h		;1d38	16 00		. .
	add hl,de		;1d3a	19		.
	ld d,h			;1d3b	54		T
	ld e,l			;1d3c	5d		]
	dec hl			;1d3d	2b		+
	ld a,(de)		;1d3e	1a		.
	pop bc			;1d3f	c1		.
	push af			;1d40	f5		.
	push bc			;1d41	c5		.
	ld bc,(05bb6h)		;1d42	ed 4b b6 5b	. K . [
	ld a,c			;1d46	79		y
	or a			;1d47	b7		.
	jr z,l1d50h		;1d48	28 06		( .
	cp 028h			;1d4a	fe 28		. (
	jr nc,l1d50h		;1d4c	30 02		0 .
	lddr			;1d4e	ed b8		. .
l1d50h:
	pop af			;1d50	f1		.
	ld (de),a		;1d51	12		.
	pop af			;1d52	f1		.
	pop bc			;1d53	c1		.
	pop de			;1d54	d1		.
	pop hl			;1d55	e1		.
	ret			;1d56	c9		.
	ld a,(04f82h)		;1d57	3a 82 4f	: . O
	ld c,a			;1d5a	4f		O
	ld a,(04f83h)		;1d5b	3a 83 4f	: . O
	ld b,a			;1d5e	47		G
	ld a,020h		;1d5f	3e 20		>  
	call sub_1d06h		;1d61	cd 06 1d	. . .
	ld d,a			;1d64	57		W
	ld a,(04f79h)		;1d65	3a 79 4f	: y O
	bit 0,a			;1d68	cb 47		. G
	jr z,l1d7bh		;1d6a	28 0f		( .
	ld c,000h		;1d6c	0e 00		. .
l1d6eh:
	inc b			;1d6e	04		.
	ld a,b			;1d6f	78		x
	cp 01ah			;1d70	fe 1a		. .
	jr nc,l1d7bh		;1d72	30 07		0 .
	ld a,d			;1d74	7a		z
	call sub_1d06h		;1d75	cd 06 1d	. . .
	ld d,a			;1d78	57		W
	jr l1d6eh		;1d79	18 f3		. .
l1d7bh:
	call l1cfch		;1d7b	cd fc 1c	. . .
	ret			;1d7e	c9		.
sub_1d7fh:
	push hl			;1d7f	e5		.
	push af			;1d80	f5		.
	push bc			;1d81	c5		.
	push de			;1d82	d5		.
	ld hl,04a9eh		;1d83	21 9e 4a	! . J
	ld de,00028h		;1d86	11 28 00	. ( .
	inc b			;1d89	04		.
l1d8ah:
	add hl,de		;1d8a	19		.
	djnz l1d8ah		;1d8b	10 fd		. .
	add hl,bc		;1d8d	09		.
	pop de			;1d8e	d1		.
	cp 001h			;1d8f	fe 01		. .
	jr nz,l1d95h		;1d91	20 02		  .
	ld a,(hl)		;1d93	7e		~
	ld (de),a		;1d94	12		.
l1d95h:
	pop bc			;1d95	c1		.
	push bc			;1d96	c5		.
	ld a,(04f83h)		;1d97	3a 83 4f	: . O
	push af			;1d9a	f5		.
	ld a,b			;1d9b	78		x
	ld (04f83h),a		;1d9c	32 83 4f	2 . O
	call sub_22bah		;1d9f	cd ba 22	. . "
	sub c			;1da2	91		.
	ld c,a			;1da3	4f		O
	ld b,000h		;1da4	06 00		. .
	pop af			;1da6	f1		.
	ld (04f83h),a		;1da7	32 83 4f	2 . O
	ld d,h			;1daa	54		T
	ld e,l			;1dab	5d		]
	inc hl			;1dac	23		#
	dec c			;1dad	0d		.
	ld a,c			;1dae	79		y
	jr z,l1db7h		;1daf	28 06		( .
	cp 028h			;1db1	fe 28		. (
	jr nc,l1db7h		;1db3	30 02		0 .
	ldir			;1db5	ed b0		. .
l1db7h:
	ld a,020h		;1db7	3e 20		>  
	ld (de),a		;1db9	12		.
	pop bc			;1dba	c1		.
	pop af			;1dbb	f1		.
	pop hl			;1dbc	e1		.
	ret			;1dbd	c9		.
	ld a,(04f82h)		;1dbe	3a 82 4f	: . O
	ld c,a			;1dc1	4f		O
	ld a,(04f83h)		;1dc2	3a 83 4f	: . O
	ld b,a			;1dc5	47		G
	ld a,000h		;1dc6	3e 00		> .
	call sub_1d7fh		;1dc8	cd 7f 1d	. . .
	ld a,(04f79h)		;1dcb	3a 79 4f	: y O
	bit 0,a			;1dce	cb 47		. G
	jr z,l1de1h		;1dd0	28 0f		( .
	ld c,000h		;1dd2	0e 00		. .
l1dd4h:
	inc b			;1dd4	04		.
	ld a,b			;1dd5	78		x
	cp 01ah			;1dd6	fe 1a		. .
	jr nc,l1de1h		;1dd8	30 07		0 .
	ld a,001h		;1dda	3e 01		> .
	call sub_1d7fh		;1ddc	cd 7f 1d	. . .
	jr l1dd4h		;1ddf	18 f3		. .
l1de1h:
	call l1cfch		;1de1	cd fc 1c	. . .
	ret			;1de4	c9		.
l1de5h:
	ld a,(04f83h)		;1de5	3a 83 4f	: . O
	ld b,a			;1de8	47		G
	ld a,019h		;1de9	3e 19		> .
	sub b			;1deb	90		.
	ld hl,0fffch		;1dec	21 fc ff	! . .
	ld de,4		;1def	11 04 00	. . .
	ld b,a			;1df2	47		G
	push bc			;1df3	c5		.
	inc b			;1df4	04		.
l1df5h:
	add hl,de		;1df5	19		.
	djnz l1df5h		;1df6	10 fd		. .
	ld b,h			;1df8	44		D
	ld c,l			;1df9	4d		M
	ld de,04ab5h		;1dfa	11 b5 4a	. . J
	ld hl,04ab1h		;1dfd	21 b1 4a	! . J
	ld a,b			;1e00	78		x
	or c			;1e01	b1		.
	jr z,l1e06h		;1e02	28 02		( .
	lddr			;1e04	ed b8		. .
l1e06h:
	pop bc			;1e06	c1		.
	inc b			;1e07	04		.
	ld hl,0ffd8h		;1e08	21 d8 ff	! . .
	ld de,00028h		;1e0b	11 28 00	. ( .
l1e0eh:
	add hl,de		;1e0e	19		.
	djnz l1e0eh		;1e0f	10 fd		. .
	ld b,h			;1e11	44		D
	ld c,l			;1e12	4d		M
	ld de,04ed5h		;1e13	11 d5 4e	. . N
	ld hl,04eadh		;1e16	21 ad 4e	! . N
	ld a,b			;1e19	78		x
	or c			;1e1a	b1		.
	jr z,l1e1fh		;1e1b	28 02		( .
	lddr			;1e1d	ed b8		. .
l1e1fh:
	inc hl			;1e1f	23		#
	ld d,h			;1e20	54		T
	ld e,l			;1e21	5d		]
	inc de			;1e22	13		.
	ld (hl),020h		;1e23	36 20		6  
	ld bc,00027h		;1e25	01 27 00	. ' .
	ldir			;1e28	ed b0		. .
	ld hl,(04f89h)		;1e2a	2a 89 4f	* . O
	inc hl			;1e2d	23		#
	inc hl			;1e2e	23		#
	call sub_1eeah		;1e2f	cd ea 1e	. . .
	jp nz,l1cfch		;1e32	c2 fc 1c	. . .
	ld a,(04f83h)		;1e35	3a 83 4f	: . O
	cp 010h			;1e38	fe 10		. .
	jp nc,l1cfch		;1e3a	d2 fc 1c	. . .
	ld hl,04a8eh		;1e3d	21 8e 4a	! . J
	ld de,053c2h		;1e40	11 c2 53	. . S
	ld bc,4		;1e43	01 04 00	. . .
	ldir			;1e46	ed b0		. .
	ld hl,04d46h		;1e48	21 46 4d	! F M
	ld bc,00028h		;1e4b	01 28 00	. ( .
	ldir			;1e4e	ed b0		. .
	ld bc,00027h		;1e50	01 27 00	. ' .
	ld hl,04d46h		;1e53	21 46 4d	! F M
	ld de,04d47h		;1e56	11 47 4d	. G M
	ld (hl),020h		;1e59	36 20		6  
	ldir			;1e5b	ed b0		. .
	call sub_2048h		;1e5d	cd 48 20	. H  
	call l1cfch		;1e60	cd fc 1c	. . .
	ret			;1e63	c9		.
l1e64h:
	ld a,(04f83h)		;1e64	3a 83 4f	: . O
	ld b,a			;1e67	47		G
	ld a,019h		;1e68	3e 19		> .
	sub b			;1e6a	90		.
	ld b,a			;1e6b	47		G
	inc b			;1e6c	04		.
	push bc			;1e6d	c5		.
	ld hl,0fffch		;1e6e	21 fc ff	! . .
	ld de,4		;1e71	11 04 00	. . .
l1e74h:
	add hl,de		;1e74	19		.
	djnz l1e74h		;1e75	10 fd		. .
	push hl			;1e77	e5		.
	ld a,(04f83h)		;1e78	3a 83 4f	: . O
	ld b,a			;1e7b	47		G
	ld hl,04a4ah		;1e7c	21 4a 4a	! J J
	inc b			;1e7f	04		.
l1e80h:
	add hl,de		;1e80	19		.
	djnz l1e80h		;1e81	10 fd		. .
	push hl			;1e83	e5		.
	add hl,de		;1e84	19		.
	pop de			;1e85	d1		.
	pop bc			;1e86	c1		.
	ld a,b			;1e87	78		x
	or c			;1e88	b1		.
	jr z,l1e8dh		;1e89	28 02		( .
	ldir			;1e8b	ed b0		. .
l1e8dh:
	pop bc			;1e8d	c1		.
	ld hl,0ffd8h		;1e8e	21 d8 ff	! . .
	ld de,00028h		;1e91	11 28 00	. ( .
l1e94h:
	add hl,de		;1e94	19		.
	djnz l1e94h		;1e95	10 fd		. .
	push hl			;1e97	e5		.
	ld a,(04f83h)		;1e98	3a 83 4f	: . O
	ld b,a			;1e9b	47		G
	ld hl,04a9eh		;1e9c	21 9e 4a	! . J
	inc b			;1e9f	04		.
l1ea0h:
	add hl,de		;1ea0	19		.
	djnz l1ea0h		;1ea1	10 fd		. .
	push hl			;1ea3	e5		.
	add hl,de		;1ea4	19		.
	pop de			;1ea5	d1		.
	pop bc			;1ea6	c1		.
	ld a,b			;1ea7	78		x
	or c			;1ea8	b1		.
	jr z,l1eadh		;1ea9	28 02		( .
	ldir			;1eab	ed b0		. .
l1eadh:
	ld h,d			;1ead	62		b
	ld l,e			;1eae	6b		k
	ld bc,00027h		;1eaf	01 27 00	. ' .
	inc de			;1eb2	13		.
	ld (hl),020h		;1eb3	36 20		6  
	ldir			;1eb5	ed b0		. .
	ld hl,(04f89h)		;1eb7	2a 89 4f	* . O
	inc hl			;1eba	23		#
	inc hl			;1ebb	23		#
	call sub_1eeah		;1ebc	cd ea 1e	. . .
	jp nz,l1cfch		;1ebf	c2 fc 1c	. . .
	ld a,(04f83h)		;1ec2	3a 83 4f	: . O
	cp 010h			;1ec5	fe 10		. .
	jp nc,l1cfch		;1ec7	d2 fc 1c	. . .
	call sub_206ah		;1eca	cd 6a 20	. j  
	ld hl,053c2h		;1ecd	21 c2 53	! . S
	ld a,(hl)		;1ed0	7e		~
	cp 0ffh			;1ed1	fe ff		. .
	jp z,l1cfch		;1ed3	ca fc 1c	. . .
	ld de,04a8ah		;1ed6	11 8a 4a	. . J
	ld bc,4		;1ed9	01 04 00	. . .
	ldir			;1edc	ed b0		. .
	ld de,04d1eh		;1ede	11 1e 4d	. . M
	ld bc,00028h		;1ee1	01 28 00	. ( .
	ldir			;1ee4	ed b0		. .
	call l1cfch		;1ee6	cd fc 1c	. . .
	ret			;1ee9	c9		.
sub_1eeah:
	push hl			;1eea	e5		.
	push de			;1eeb	d5		.
	push af			;1eec	f5		.
	push iy			;1eed	fd e5		. .
	ld iy,05faeh		;1eef	fd 21 ae 5f	. ! . _
	ld a,(05cbah)		;1ef3	3a ba 5c	: . \
	cp 005h			;1ef6	fe 05		. .
	jr nz,l1efeh		;1ef8	20 04		  .
	ld iy,05fb2h		;1efa	fd 21 b2 5f	. ! . _
l1efeh:
	ld a,(iy+002h)		;1efe	fd 7e 02	. ~ .
	or (iy+003h)		;1f01	fd b6 03	. . .
	ld b,a			;1f04	47		G
	ld a,000h		;1f05	3e 00		> .
	jr z,l1f21h		;1f07	28 18		( .
	ex de,hl		;1f09	eb		.
	ld h,(iy+003h)		;1f0a	fd 66 03	. f .
	ld l,b			;1f0d	68		h
	call sub_0f20h		;1f0e	cd 20 0f	.   .
	jr c,l1f21h		;1f11	38 0e		8 .
	ex de,hl		;1f13	eb		.
	ld d,(iy+001h)		;1f14	fd 56 01	. V .
	ld e,(iy+000h)		;1f17	fd 5e 00	. ^ .
	call sub_0f20h		;1f1a	cd 20 0f	.   .
	jr c,l1f21h		;1f1d	38 02		8 .
	ld a,001h		;1f1f	3e 01		> .
l1f21h:
	cp 001h			;1f21	fe 01		. .
	pop iy			;1f23	fd e1		. .
	pop hl			;1f25	e1		.
	ld a,h			;1f26	7c		|
	pop de			;1f27	d1		.
	pop hl			;1f28	e1		.
	ret			;1f29	c9		.
sub_1f2ah:
	push hl			;1f2a	e5		.
	ld hl,(04f89h)		;1f2b	2a 89 4f	* . O
	inc hl			;1f2e	23		#
	call sub_1eeah		;1f2f	cd ea 1e	. . .
	pop hl			;1f32	e1		.
	ret			;1f33	c9		.
sub_1f34h:
	ld hl,(04f89h)		;1f34	2a 89 4f	* . O
	inc hl			;1f37	23		#
	inc hl			;1f38	23		#
	ld (0542ah),hl		;1f39	22 2a 54	" * T
	ex de,hl		;1f3c	eb		.
	ld hl,(05fb0h)		;1f3d	2a b0 5f	* . _
	call sub_0f20h		;1f40	cd 20 0f	.   .
	ret			;1f43	c9		.
l1f44h:
	call sub_1f34h		;1f44	cd 34 1f	. 4 .
	ret c			;1f47	d8		.
l1f48h:
	ld hl,(0542ah)		;1f48	2a 2a 54	* * T
	call sub_07f9h		;1f4b	cd f9 07	. . .
	call SOMETHING_MEM	;1f4e	cd 1a 0f	. . .
	cp 0ffh			;1f51	fe ff		. .
	ret z			;1f53	c8		.
	push hl			;1f54	e5		.
	ld de,0x2c		;1f55	11 2c 00	. , .
	add hl,de		;1f58	19		.
	ld de,053eeh		;1f59	11 ee 53	. . S
	ld bc,4		;1f5c	01 04 00	. . .
	ldir			;1f5f	ed b0		. .
	pop hl			;1f61	e1		.
	push hl			;1f62	e5		.
	ld de,l0147h+1		;1f63	11 48 01	. H .
	add hl,de		;1f66	19		.
	ld de,053f2h		;1f67	11 f2 53	. . S
	ld bc,00028h		;1f6a	01 28 00	. ( .
	ldir			;1f6d	ed b0		. .
	pop hl			;1f6f	e1		.
	ld de,l0147h		;1f70	11 47 01	. G .
	add hl,de		;1f73	19		.
	push hl			;1f74	e5		.
	ld de,00028h		;1f75	11 28 00	. ( .
	add hl,de		;1f78	19		.
	ex de,hl		;1f79	eb		.
	pop hl			;1f7a	e1		.
	ld bc,00118h		;1f7b	01 18 01	. . .
	lddr			;1f7e	ed b8		. .
	ld hl,053edh		;1f80	21 ed 53	! . S
	ld bc,00028h		;1f83	01 28 00	. ( .
	lddr			;1f86	ed b8		. .
	ld h,d			;1f88	62		b
	ld l,e			;1f89	6b		k
	ld bc,4		;1f8a	01 04 00	. . .
	or a			;1f8d	b7		.
	sbc hl,bc		;1f8e	ed 42		. B
	ld bc,28		;1f90	01 1c 00	. . .
	lddr			;1f93	ed b8		. .
	ld bc,4		;1f95	01 04 00	. . .
	ld hl,053c5h		;1f98	21 c5 53	! . S
	lddr			;1f9b	ed b8		. .
	ld de,053c2h		;1f9d	11 c2 53	. . S
	ld hl,053eeh		;1fa0	21 ee 53	! . S
	ld bc,0x2c		;1fa3	01 2c 00	. , .
	ldir			;1fa6	ed b0		. .
	ld hl,(0542ah)		;1fa8	2a 2a 54	* * T
	inc hl			;1fab	23		#
	ld (0542ah),hl		;1fac	22 2a 54	" * T
	ex de,hl		;1faf	eb		.
	ld hl,(05fb0h)		;1fb0	2a b0 5f	* . _
	call sub_0f20h		;1fb3	cd 20 0f	.   .
	jr nc,l1f48h		;1fb6	30 90		0 .
	ret			;1fb8	c9		.
sub_1fb9h:
	ld hl,(0542ah)		;1fb9	2a 2a 54	* * T
	call sub_07f9h		;1fbc	cd f9 07	. . .
	call SOMETHING_MEM	;1fbf	cd 1a 0f	. . .
	ld de,16		;1fc2	11 10 00	. . .
	add hl,de		;1fc5	19		.
	push hl			;1fc6	e5		.
	ld de,053c2h		;1fc7	11 c2 53	. . S
	ld bc,4		;1fca	01 04 00	. . .
	ldir			;1fcd	ed b0		. .
	pop de			;1fcf	d1		.
	ld bc,28		;1fd0	01 1c 00	. . .
	ldir			;1fd3	ed b0		. .
	ld de,053c6h		;1fd5	11 c6 53	. . S
	push hl			;1fd8	e5		.
	ld bc,00028h		;1fd9	01 28 00	. ( .
	ldir			;1fdc	ed b0		. .
	ld bc,00118h		;1fde	01 18 01	. . .
	pop de			;1fe1	d1		.
	ldir			;1fe2	ed b0		. .
	ret			;1fe4	c9		.
l1fe5h:
	ld a,0ffh		;1fe5	3e ff		> .
	ld (053c2h),a		;1fe7	32 c2 53	2 . S
	call sub_1f34h		;1fea	cd 34 1f	. 4 .
	ret c			;1fed	d8		.
	ld hl,(05fb0h)		;1fee	2a b0 5f	* . _
	ld (0542ah),hl		;1ff1	22 2a 54	" * T
	call sub_07f9h		;1ff4	cd f9 07	. . .
	cp 0ffh			;1ff7	fe ff		. .
	jr nz,l2004h		;1ff9	20 09		  .
	ld hl,(05fb0h)		;1ffb	2a b0 5f	* . _
	dec hl			;1ffe	2b		+
	ld (05fb0h),hl		;1fff	22 b0 5f	" . _
	jr l1fe5h		;2002	18 e1		. .
l2004h:
	call sub_1fb9h		;2004	cd b9 1f	. . .
	ld h,d			;2007	62		b
	ld l,e			;2008	6b		k
	ld b,028h		;2009	06 28		. (
l200bh:
	ld (hl),020h		;200b	36 20		6  
	inc hl			;200d	23		#
	djnz l200bh		;200e	10 fb		. .
l2010h:
	ld hl,(0542ah)		;2010	2a 2a 54	* * T
	dec hl			;2013	2b		+
	ld (0542ah),hl		;2014	22 2a 54	" * T
	ex de,hl		;2017	eb		.
	ld hl,(04f89h)		;2018	2a 89 4f	* . O
	inc hl			;201b	23		#
	call sub_0f20h		;201c	cd 20 0f	.   .
	ret z			;201f	c8		.
	ld hl,053c2h		;2020	21 c2 53	! . S
	ld de,053eeh		;2023	11 ee 53	. . S
	ld bc,0x2c		;2026	01 2c 00	. , .
	ldir			;2029	ed b0		. .
	call sub_1fb9h		;202b	cd b9 1f	. . .
	ld hl,053f2h		;202e	21 f2 53	! . S
	ld bc,00028h		;2031	01 28 00	. ( .
	ldir			;2034	ed b0		. .
	or a			;2036	b7		.
	ex de,hl		;2037	eb		.
	ld de,l0144h		;2038	11 44 01	. D .
	sbc hl,de		;203b	ed 52		. R
	ld de,053eeh		;203d	11 ee 53	. . S
	ld bc,4		;2040	01 04 00	. . .
	ex de,hl		;2043	eb		.
	ldir			;2044	ed b0		. .
	jr l2010h		;2046	18 c8		. .
sub_2048h:
	ld a,(05cbah)		;2048	3a ba 5c	: . \
	cp 005h			;204b	fe 05		. .
	jp nz,l1f44h		;204d	c2 44 1f	. D .
	ld hl,(04f89h)		;2050	2a 89 4f	* . O
	ld (05cc3h),hl		;2053	22 c3 5c	" . \
	ld de,05cc6h		;2056	11 c6 5c	. . \
	ld hl,053c2h		;2059	21 c2 53	! . S
	ld bc,0x2c		;205c	01 2c 00	. , .
	ldir			;205f	ed b0		. .
	ld a,049h		;2061	3e 49		> I
	ld (05cc2h),a		;2063	32 c2 5c	2 . \
	call 0893fh		;2066	cd 3f 89	. ? .
	ret			;2069	c9		.
sub_206ah:
	ld a,(05cbah)		;206a	3a ba 5c	: . \
	cp 005h			;206d	fe 05		. .
	jp nz,l1fe5h		;206f	c2 e5 1f	. . .
	ld hl,(04f89h)		;2072	2a 89 4f	* . O
	ld a,049h		;2075	3e 49		> I
	call 088dch		;2077	cd dc 88	. . .
	ret			;207a	c9		.
	ld a,(04f79h)		;207b	3a 79 4f	: y O
	bit 0,a			;207e	cb 47		. G
	jr z,l2090h		;2080	28 0e		( .
	ld a,000h		;2082	3e 00		> .
	ld b,01ah		;2084	06 1a		. .
l2086h:
	call sub_209ah		;2086	cd 9a 20	. .  
	inc a			;2089	3c		<
	djnz l2086h		;208a	10 fa		. .
	call l1cfch		;208c	cd fc 1c	. . .
	ret			;208f	c9		.
l2090h:
	ld a,(04f83h)		;2090	3a 83 4f	: . O
	call sub_209ah		;2093	cd 9a 20	. .  
	call l1cfch		;2096	cd fc 1c	. . .
	ret			;2099	c9		.
sub_209ah:
	push hl			;209a	e5		.
	push de			;209b	d5		.
	push bc			;209c	c5		.
	push af			;209d	f5		.
	ld b,a			;209e	47		G
	ld hl,04a4ch		;209f	21 4c 4a	! L J
	ld de,4		;20a2	11 04 00	. . .
	inc b			;20a5	04		.
l20a6h:
	add hl,de		;20a6	19		.
	djnz l20a6h		;20a7	10 fd		. .
	ld a,(hl)		;20a9	7e		~
	bit 3,a			;20aa	cb 5f		. _
	jp z,l2158h		;20ac	ca 58 21	. X !
	and 007h		;20af	e6 07		. .
	ld d,000h		;20b1	16 00		. .
	ld e,a			;20b3	5f		_
	ld hl,l22e1h		;20b4	21 e1 22	! . "
	add hl,de		;20b7	19		.
	ld a,(hl)		;20b8	7e		~
	ld c,a			;20b9	4f		O
	pop af			;20ba	f1		.
	push af			;20bb	f5		.
	ld hl,04a9eh		;20bc	21 9e 4a	! . J
	inc a			;20bf	3c		<
	ld b,a			;20c0	47		G
	ld de,00028h		;20c1	11 28 00	. ( .
l20c4h:
	add hl,de		;20c4	19		.
	djnz l20c4h		;20c5	10 fd		. .
	push hl			;20c7	e5		.
	ld b,c			;20c8	41		A
	ld d,028h		;20c9	16 28		. (
l20cbh:
	ld a,(hl)		;20cb	7e		~
	cp 0f0h			;20cc	fe f0		. .
	jr nz,l20d2h		;20ce	20 02		  .
	ld (hl),020h		;20d0	36 20		6  
l20d2h:
	cp 0f1h			;20d2	fe f1		. .
	jr nz,l20d8h		;20d4	20 02		  .
	ld (hl),020h		;20d6	36 20		6  
l20d8h:
	inc hl			;20d8	23		#
	dec d			;20d9	15		.
	djnz l20cbh		;20da	10 ef		. .
	ld b,d			;20dc	42		B
	push hl			;20dd	e5		.
	ld a,d			;20de	7a		z
	or a			;20df	b7		.
	jr z,l20e7h		;20e0	28 05		( .
l20e2h:
	ld (hl),020h		;20e2	36 20		6  
	inc hl			;20e4	23		#
	djnz l20e2h		;20e5	10 fb		. .
l20e7h:
	pop de			;20e7	d1		.
	pop hl			;20e8	e1		.
	push hl			;20e9	e5		.
	push de			;20ea	d5		.
	ld b,c			;20eb	41		A
	ld d,000h		;20ec	16 00		. .
l20eeh:
	ld a,(hl)		;20ee	7e		~
	cp 020h			;20ef	fe 20		.  
	jr nz,l20fbh		;20f1	20 08		  .
	inc d			;20f3	14		.
	inc hl			;20f4	23		#
	djnz l20eeh		;20f5	10 f7		. .
	pop hl			;20f7	e1		.
	pop hl			;20f8	e1		.
	jr l2158h		;20f9	18 5d		. ]
l20fbh:
	ld e,000h		;20fb	1e 00		. .
	pop hl			;20fd	e1		.
	dec hl			;20fe	2b		+
l20ffh:
	ld a,(hl)		;20ff	7e		~
	cp 020h			;2100	fe 20		.  
	jr nz,l2108h		;2102	20 04		  .
	inc e			;2104	1c		.
	dec hl			;2105	2b		+
	jr l20ffh		;2106	18 f7		. .
l2108h:
	pop hl			;2108	e1		.
	ld a,d			;2109	7a		z
	sub e			;210a	93		.
	jr z,l2158h		;210b	28 4b		( K
	jr nc,l213ah		;210d	30 2b		0 +
	ld a,e			;210f	7b		{
	sub d			;2110	92		.
	or a			;2111	b7		.
	rra			;2112	1f		.
	ld b,020h		;2113	06 20		.  
	jr nc,l211ah		;2115	30 03		0 .
	ld b,0f1h		;2117	06 f1		. .
	inc a			;2119	3c		<
l211ah:
	ld e,c			;211a	59		Y
	ld d,000h		;211b	16 00		. .
	add hl,de		;211d	19		.
	dec hl			;211e	2b		+
	ld d,h			;211f	54		T
	ld e,l			;2120	5d		]
	push bc			;2121	c5		.
	ld b,a			;2122	47		G
	ld a,c			;2123	79		y
	sub b			;2124	90		.
	ld c,a			;2125	4f		O
	ld a,b			;2126	78		x
l2127h:
	dec hl			;2127	2b		+
	djnz l2127h		;2128	10 fd		. .
	lddr			;212a	ed b8		. .
	inc hl			;212c	23		#
	pop bc			;212d	c1		.
	ld (hl),b		;212e	70		p
	dec a			;212f	3d		=
	jr z,l2158h		;2130	28 26		( &
	ld b,a			;2132	47		G
l2133h:
	inc hl			;2133	23		#
	ld (hl),020h		;2134	36 20		6  
	djnz l2133h		;2136	10 fb		. .
	jr l2158h		;2138	18 1e		. .
l213ah:
	or a			;213a	b7		.
	rra			;213b	1f		.
	jr nc,l2140h		;213c	30 02		0 .
	ld (hl),0f1h		;213e	36 f1		6 .
l2140h:
	inc hl			;2140	23		#
	or a			;2141	b7		.
	jr z,l2158h		;2142	28 14		( .
	ld b,a			;2144	47		G
	ld a,c			;2145	79		y
	sub b			;2146	90		.
	dec a			;2147	3d		=
	ld c,a			;2148	4f		O
	ld d,h			;2149	54		T
	ld e,l			;214a	5d		]
	ld a,b			;214b	78		x
l214ch:
	inc hl			;214c	23		#
	djnz l214ch		;214d	10 fd		. .
	ldir			;214f	ed b0		. .
	ld b,a			;2151	47		G
	ex de,hl		;2152	eb		.
l2153h:
	ld (hl),020h		;2153	36 20		6  
	inc hl			;2155	23		#
	djnz l2153h		;2156	10 fb		. .
l2158h:
	pop af			;2158	f1		.
	pop bc			;2159	c1		.
	pop de			;215a	d1		.
	pop hl			;215b	e1		.
	ret			;215c	c9		.
	ld a,(04f79h)		;215d	3a 79 4f	: y O
	bit 0,a			;2160	cb 47		. G
	jr z,l2179h		;2162	28 15		( .
	ld a,(04f83h)		;2164	3a 83 4f	: . O
	or a			;2167	b7		.
	jr z,l2171h		;2168	28 07		( .
	dec a			;216a	3d		=
	ld (04f83h),a		;216b	32 83 4f	2 . O
	call sub_22a1h		;216e	cd a1 22	. . "
l2171h:
	ld a,000h		;2171	3e 00		> .
	ld (04f83h),a		;2173	32 83 4f	2 . O
	jp l1e64h		;2176	c3 64 1e	. d .
l2179h:
	ld a,(04f83h)		;2179	3a 83 4f	: . O
	or a			;217c	b7		.
	ret z			;217d	c8		.
	ld c,a			;217e	4f		O
	dec a			;217f	3d		=
	ld (04f83h),a		;2180	32 83 4f	2 . O
	call sub_22a1h		;2183	cd a1 22	. . "
	call sub_218dh		;2186	cd 8d 21	. . !
	call l1cfch		;2189	cd fc 1c	. . .
	ret			;218c	c9		.
sub_218dh:
	ld de,4		;218d	11 04 00	. . .
	ld hl,04a4ah		;2190	21 4a 4a	! J J
	ld b,c			;2193	41		A
l2194h:
	add hl,de		;2194	19		.
	djnz l2194h		;2195	10 fd		. .
	ex de,hl		;2197	eb		.
	add hl,de		;2198	19		.
	ld b,004h		;2199	06 04		. .
	call sub_21b0h		;219b	cd b0 21	. . !
	ld b,c			;219e	41		A
	ld hl,04a9eh		;219f	21 9e 4a	! . J
	ld de,00028h		;21a2	11 28 00	. ( .
l21a5h:
	add hl,de		;21a5	19		.
	djnz l21a5h		;21a6	10 fd		. .
	ex de,hl		;21a8	eb		.
	add hl,de		;21a9	19		.
	ld b,028h		;21aa	06 28		. (
	call sub_21b0h		;21ac	cd b0 21	. . !
	ret			;21af	c9		.
sub_21b0h:
	push bc			;21b0	c5		.
l21b1h:
	ld c,(hl)		;21b1	4e		N
	ld a,(de)		;21b2	1a		.
	ld (hl),a		;21b3	77		w
	ld a,c			;21b4	79		y
	ld (de),a		;21b5	12		.
	inc hl			;21b6	23		#
	inc de			;21b7	13		.
	djnz l21b1h		;21b8	10 f7		. .
	pop bc			;21ba	c1		.
	ret			;21bb	c9		.
	ld a,(04f79h)		;21bc	3a 79 4f	: y O
	bit 0,a			;21bf	cb 47		. G
	jr z,l21d9h		;21c1	28 16		( .
	ld a,(04f83h)		;21c3	3a 83 4f	: . O
	cp 019h			;21c6	fe 19		. .
	jr z,l21d1h		;21c8	28 07		( .
	inc a			;21ca	3c		<
	ld (04f83h),a		;21cb	32 83 4f	2 . O
	call sub_22a1h		;21ce	cd a1 22	. . "
l21d1h:
	ld a,000h		;21d1	3e 00		> .
	ld (04f83h),a		;21d3	32 83 4f	2 . O
	jp l1de5h		;21d6	c3 e5 1d	. . .
l21d9h:
	ld a,(04f83h)		;21d9	3a 83 4f	: . O
	cp 019h			;21dc	fe 19		. .
	ret z			;21de	c8		.
	inc a			;21df	3c		<
	ld c,a			;21e0	4f		O
	ld (04f83h),a		;21e1	32 83 4f	2 . O
	call sub_22a1h		;21e4	cd a1 22	. . "
	call sub_218dh		;21e7	cd 8d 21	. . !
	call l1cfch		;21ea	cd fc 1c	. . .
	ret			;21ed	c9		.
	ld a,(04f79h)		;21ee	3a 79 4f	: y O
	bit 0,a			;21f1	cb 47		. G
	jr z,l2209h		;21f3	28 14		( .
	ld c,000h		;21f5	0e 00		. .
	ld b,019h		;21f7	06 19		. .
l21f9h:
	ld a,020h		;21f9	3e 20		>  
	call sub_1d06h		;21fb	cd 06 1d	. . .
	djnz l21f9h		;21fe	10 f9		. .
	ld a,020h		;2200	3e 20		>  
	call sub_1d06h		;2202	cd 06 1d	. . .
	call l1cfch		;2205	cd fc 1c	. . .
	ret			;2208	c9		.
l2209h:
	ld c,a			;2209	4f		O
	ld a,(04f83h)		;220a	3a 83 4f	: . O
	ld b,a			;220d	47		G
	ld a,020h		;220e	3e 20		>  
	call sub_1d06h		;2210	cd 06 1d	. . .
	call l1cfch		;2213	cd fc 1c	. . .
	ret			;2216	c9		.
	ld a,(04f79h)		;2217	3a 79 4f	: y O
	bit 0,a			;221a	cb 47		. G
	jr z,l2230h		;221c	28 12		( .
	ld c,000h		;221e	0e 00		. .
	ld b,019h		;2220	06 19		. .
	ld a,000h		;2222	3e 00		> .
l2224h:
	call sub_1d7fh		;2224	cd 7f 1d	. . .
	djnz l2224h		;2227	10 fb		. .
	call sub_1d7fh		;2229	cd 7f 1d	. . .
	call l1cfch		;222c	cd fc 1c	. . .
	ret			;222f	c9		.
l2230h:
	ld a,(04f83h)		;2230	3a 83 4f	: . O
	ld b,a			;2233	47		G
	ld a,000h		;2234	3e 00		> .
	ld c,000h		;2236	0e 00		. .
	call sub_1d7fh		;2238	cd 7f 1d	. . .
	call l1cfch		;223b	cd fc 1c	. . .
	ret			;223e	c9		.
sub_223fh:
	call sub_2295h		;223f	cd 95 22	. . "
sub_2242h:
	call sub_2249h		;2242	cd 49 22	. I "
	call sub_2290h		;2245	cd 90 22	. . "
	ret			;2248	c9		.
sub_2249h:
	ld hl,04a4fh		;2249	21 4f 4a	! O J
	ld de,4		;224c	11 04 00	. . .
	ld b,000h		;224f	06 00		. .
	ld c,019h		;2251	0e 19		. .
l2253h:
	inc b			;2253	04		.
	ld a,(hl)		;2254	7e		~
	and 007h		;2255	e6 07		. .
	inc a			;2257	3c		<
	ld d,a			;2258	57		W
	ld a,c			;2259	79		y
	sub d			;225a	92		.
	jr c,l2263h		;225b	38 06		8 .
	ld c,a			;225d	4f		O
	ld d,000h		;225e	16 00		. .
	add hl,de		;2260	19		.
	jr l2253h		;2261	18 f0		. .
l2263h:
	ld hl,(04f80h)		;2263	2a 80 4f	* . O
	ld de,04ac6h		;2266	11 c6 4a	. . J
	ld a,b			;2269	78		x
	ld (04f8bh),a		;226a	32 8b 4f	2 . O
	xor a			;226d	af		.
	sbc hl,de		;226e	ed 52		. R
	dec a			;2270	3d		=
l2271h:
	ld de,00028h		;2271	11 28 00	. ( .
	push hl			;2274	e5		.
	inc a			;2275	3c		<
	sbc hl,de		;2276	ed 52		. R
	pop de			;2278	d1		.
	jr nc,l2271h		;2279	30 f6		0 .
	cp b			;227b	b8		.
	jr c,l2288h		;227c	38 0a		8 .
	ld a,b			;227e	78		x
	dec a			;227f	3d		=
	ld (04f83h),a		;2280	32 83 4f	2 . O
	call sub_22a1h		;2283	cd a1 22	. . "
	jr sub_2249h		;2286	18 c1		. .
l2288h:
	ld (04f83h),a		;2288	32 83 4f	2 . O
	ld a,e			;228b	7b		{
	ld (04f82h),a		;228c	32 82 4f	2 . O
	ret			;228f	c9		.
sub_2290h:
	call sub_1318h		;2290	cd 18 13	. . .
	ld a,(bc)		;2293	0a		.
	ret			;2294	c9		.
sub_2295h:
	ld bc,1		;2295	01 01 00	. . .
	ld de,04a3eh		;2298	11 3e 4a	. > J
	ld a,000h		;229b	3e 00		> .
	call sub_09fbh		;229d	cd fb 09	. . .
	ret			;22a0	c9		.
sub_22a1h:
	ld hl,04a9eh		;22a1	21 9e 4a	! . J
	ld a,(04f83h)		;22a4	3a 83 4f	: . O
	inc a			;22a7	3c		<
	ld b,a			;22a8	47		G
	ld de,00028h		;22a9	11 28 00	. ( .
l22ach:
	add hl,de		;22ac	19		.
	djnz l22ach		;22ad	10 fd		. .
	ld d,000h		;22af	16 00		. .
	ld a,(04f82h)		;22b1	3a 82 4f	: . O
	ld e,a			;22b4	5f		_
	add hl,de		;22b5	19		.
	ld (04f80h),hl		;22b6	22 80 4f	" . O
	ret			;22b9	c9		.
sub_22bah:
	push hl			;22ba	e5		.
	push de			;22bb	d5		.
	push bc			;22bc	c5		.
	ld hl,04a4ch		;22bd	21 4c 4a	! L J
	ld de,4		;22c0	11 04 00	. . .
	ld a,(04f83h)		;22c3	3a 83 4f	: . O
	inc a			;22c6	3c		<
	ld b,a			;22c7	47		G
l22c8h:
	add hl,de		;22c8	19		.
	djnz l22c8h		;22c9	10 fd		. .
	ld a,(l22e1h)		;22cb	3a e1 22	: . "
	bit 3,(hl)		;22ce	cb 5e		. ^
	jr z,l22ddh		;22d0	28 0b		( .
	ld a,(hl)		;22d2	7e		~
	and 007h		;22d3	e6 07		. .
	ld d,000h		;22d5	16 00		. .
	ld e,a			;22d7	5f		_
	ld hl,l22e1h		;22d8	21 e1 22	! . "
	add hl,de		;22db	19		.
	ld a,(hl)		;22dc	7e		~
l22ddh:
	pop bc			;22dd	c1		.
	pop de			;22de	d1		.
	pop hl			;22df	e1		.
	ret			;22e0	c9		.
l22e1h:
	jr z,l2303h		;22e1	28 20		(  
	add hl,de		;22e3	19		.
	inc d			;22e4	14		.
	djnz l22f3h		;22e5	10 0c		. .
	ld a,(bc)		;22e7	0a		.
	ex af,af'		;22e8	08		.
	call sub_22f0h		;22e9	cd f0 22	. . "
	call sub_223fh		;22ec	cd 3f 22	. ? "
	ret			;22ef	c9		.
sub_22f0h:
	ld de,04a3eh		;22f0	11 3e 4a	. > J
l22f3h:
	ld hl,l2304h		;22f3	21 04 23	! . #
	ld bc,20		;22f6	01 14 00	. . .
	ldir			;22f9	ed b0		. .
	ld hl,04a4eh		;22fb	21 4e 4a	! N J
	ld bc,00074h		;22fe	01 74 00	. t .
	ldir			;2301	ed b0		. .
l2303h:
	ret			;2303	c9		.
l2304h:
	nop			;2304	00		.
	rrca			;2305	0f		.
	djnz l230ah		;2306	10 02		. .
	nop			;2308	00		.
	nop			;2309	00		.
l230ah:
	nop			;230a	00		.
	nop			;230b	00		.
	nop			;230c	00		.
	nop			;230d	00		.
	nop			;230e	00		.
	nop			;230f	00		.
	nop			;2310	00		.
	nop			;2311	00		.
	nop			;2312	00		.
	nop			;2313	00		.
	add a,b			;2314	80		.
	ld bc,030c9h		;2315	01 c9 30	. . 0
sub_2318h:
	ld hl,04ac6h		;2318	21 c6 4a	! . J
	ld de,04ac7h		;231b	11 c7 4a	. . J
	ld bc,l040fh+1		;231e	01 10 04	. . .
	ld (hl),020h		;2321	36 20		6  
	ldir			;2323	ed b0		. .
	ret			;2325	c9		.
sub_2326h:
	ld hl,04f79h		;2326	21 79 4f	! y O
	res 4,(hl)		;2329	cb a6		. .
	ld hl,04109h		;232b	21 09 41	! . A
	ld (hl),01ah		;232e	36 1a		6 .
	ld b,005h		;2330	06 05		. .
l2332h:
	inc hl			;2332	23		#
	ld (hl),000h		;2333	36 00		6 .
	djnz l2332h		;2335	10 fb		. .
	ld a,001h		;2337	3e 01		> .
	ld b,006h		;2339	06 06		. .
l233bh:
	call sub_3381h		;233b	cd 81 33	. . 3
	inc a			;233e	3c		<
	djnz l233bh		;233f	10 fa		. .
	ld de,04159h		;2341	11 59 41	. Y A
	call sub_1101h		;2344	cd 01 11	. . .
	ld h,d			;2347	62		b
	ld l,e			;2348	6b		k
	ld (04116h),hl		;2349	22 16 41	" . A
	ld hl,04118h		;234c	21 18 41	! . A
	ld b,00ah		;234f	06 0a		. .
l2351h:
	ld (hl),000h		;2351	36 00		6 .
	inc hl			;2353	23		#
	djnz l2351h		;2354	10 fb		. .
	ld a,000h		;2356	3e 00		> .
	ld (05cb9h),a		;2358	32 b9 5c	2 . \
	ret			;235b	c9		.
	ld hl,04f79h		;235c	21 79 4f	! y O
	set 4,(hl)		;235f	cb e6		. .
	xor a			;2361	af		.
	ld (05fe0h),a		;2362	32 e0 5f	2 . _
	call sub_087ch		;2365	cd 7c 08	. | .
	call sub_331fh		;2368	cd 1f 33	. . 3
	ld de,04109h		;236b	11 09 41	. . A
	ld hl,05b71h		;236e	21 71 5b	! q [
	ld bc,6		;2371	01 06 00	. . .
	ldir			;2374	ed b0		. .
	ld b,006h		;2376	06 06		. .
	ld de,04159h		;2378	11 59 41	. Y A
	call sub_1101h		;237b	cd 01 11	. . .
	push de			;237e	d5		.
	pop ix			;237f	dd e1		. .
	ld hl,04116h		;2381	21 16 41	! . A
	ld de,04109h		;2384	11 09 41	. . A
l2387h:
	push bc			;2387	c5		.
	push ix			;2388	dd e5		. .
	pop bc			;238a	c1		.
	ld (hl),c		;238b	71		q
	inc hl			;238c	23		#
	ld (hl),b		;238d	70		p
	inc hl			;238e	23		#
	ld a,(de)		;238f	1a		.
	inc de			;2390	13		.
	or a			;2391	b7		.
	jr z,l23a1h		;2392	28 0d		( .
	ld bc,l0043h		;2394	01 43 00	. C .
l2397h:
	add ix,bc		;2397	dd 09		. .
	dec a			;2399	3d		=
	jr nz,l2397h		;239a	20 fb		  .
	ld bc,0x2b		;239c	01 2b 00	. + .
	add ix,bc		;239f	dd 09		. .
l23a1h:
	pop bc			;23a1	c1		.
	djnz l2387h		;23a2	10 e3		. .
	ld de,0575bh		;23a4	11 5b 57	. [ W
	ld hl,l2304h		;23a7	21 04 23	! . #
	ld bc,20		;23aa	01 14 00	. . .
	ldir			;23ad	ed b0		. .
	ld hl,0576bh		;23af	21 6b 57	! k W
	ld bc,28		;23b2	01 1c 00	. . .
	ldir			;23b5	ed b0		. .
	push de			;23b7	d5		.
	pop hl			;23b8	e1		.
	inc de			;23b9	13		.
	ld (hl),020h		;23ba	36 20		6  
	ld bc,l0230h		;23bc	01 30 02	. 0 .
	ldir			;23bf	ed b0		. .
	ld bc,6		;23c1	01 06 00	. . .
l23c4h:
	ld de,0575bh		;23c4	11 5b 57	. [ W
	ld a,001h		;23c7	3e 01		> .
	push bc			;23c9	c5		.
	call sub_09fbh		;23ca	cd fb 09	. . .
	pop bc			;23cd	c1		.
	dec c			;23ce	0d		.
	jr nz,l23c4h		;23cf	20 f3		  .
	ret			;23d1	c9		.
sub_23d2h:
	call sub_2326h		;23d2	cd 26 23	. & #
	call sub_1bddh		;23d5	cd dd 1b	. . .
	call sub_223fh		;23d8	cd 3f 22	. ? "
	ret			;23db	c9		.
	ld a,000h		;23dc	3e 00		> .
	ld b,003h		;23de	06 03		. .
	ld c,001h		;23e0	0e 01		. .
	ld d,007h		;23e2	16 07		. .
	call sub_247fh		;23e4	cd 7f 24	. . $
	ret			;23e7	c9		.
	ld a,000h		;23e8	3e 00		> .
	ld b,002h		;23ea	06 02		. .
	ld c,001h		;23ec	0e 01		. .
	ld d,007h		;23ee	16 07		. .
	call sub_247fh		;23f0	cd 7f 24	. . $
	ret			;23f3	c9		.
	ld a,000h		;23f4	3e 00		> .
	ld b,001h		;23f6	06 01		. .
	ld c,010h		;23f8	0e 10		. .
	ld d,010h		;23fa	16 10		. .
	call sub_247fh		;23fc	cd 7f 24	. . $
	ret			;23ff	c9		.
	ld a,(04f76h)		;2400	3a 76 4f	: v O
	ld b,a			;2403	47		G
	dec a			;2404	3d		=
	and 007h		;2405	e6 07		. .
	ld c,a			;2407	4f		O
	ld a,(04f77h)		;2408	3a 77 4f	: w O
	cp b			;240b	b8		.
	jr nz,l2415h		;240c	20 07		  .
	set 3,c			;240e	cb d9		. .
	ld a,000h		;2410	3e 00		> .
	ld (04f76h),a		;2412	32 76 4f	2 v O
l2415h:
	ld a,0ffh		;2415	3e ff		> .
	ld b,001h		;2417	06 01		. .
	ld d,00fh		;2419	16 0f		. .
	call sub_247fh		;241b	cd 7f 24	. . $
	ret			;241e	c9		.
	ld a,000h		;241f	3e 00		> .
	ld b,003h		;2421	06 03		. .
	ld c,040h		;2423	0e 40		. @
	ld d,0c0h		;2425	16 c0		. .
	call sub_247fh		;2427	cd 7f 24	. . $
	ret			;242a	c9		.
	ld a,000h		;242b	3e 00		> .
	ld b,003h		;242d	06 03		. .
	ld c,010h		;242f	0e 10		. .
	ld d,030h		;2431	16 30		. 0
	call sub_247fh		;2433	cd 7f 24	. . $
	ret			;2436	c9		.
	ld a,000h		;2437	3e 00		> .
	ld b,003h		;2439	06 03		. .
	ld c,008h		;243b	0e 08		. .
	ld d,008h		;243d	16 08		. .
	call sub_247fh		;243f	cd 7f 24	. . $
	ret			;2442	c9		.
	ld a,000h		;2443	3e 00		> .
	ld b,001h		;2445	06 01		. .
	ld c,080h		;2447	0e 80		. .
	ld d,080h		;2449	16 80		. .
	call sub_247fh		;244b	cd 7f 24	. . $
	ret			;244e	c9		.
	ld a,000h		;244f	3e 00		> .
	ld b,002h		;2451	06 02		. .
	ld c,008h		;2453	0e 08		. .
	ld d,038h		;2455	16 38		. 8
	call sub_247fh		;2457	cd 7f 24	. . $
	ret			;245a	c9		.
	ld a,000h		;245b	3e 00		> .
	ld b,002h		;245d	06 02		. .
	ld c,040h		;245f	0e 40		. @
	ld d,040h		;2461	16 40		. @
	call sub_247fh		;2463	cd 7f 24	. . $
	ret			;2466	c9		.
	ld a,000h		;2467	3e 00		> .
	ld b,002h		;2469	06 02		. .
	ld c,080h		;246b	0e 80		. .
	ld d,080h		;246d	16 80		. .
	call sub_247fh		;246f	cd 7f 24	. . $
	ret			;2472	c9		.
	ld a,000h		;2473	3e 00		> .
	ld b,004h		;2475	06 04		. .
	ld c,040h		;2477	0e 40		. @
	ld d,0c0h		;2479	16 c0		. .
	call sub_247fh		;247b	cd 7f 24	. . $
	ret			;247e	c9		.
sub_247fh:
	push af			;247f	f5		.
	ld a,(04f79h)		;2480	3a 79 4f	: y O
	bit 0,a			;2483	cb 47		. G
	jr z,l24aah		;2485	28 23		( #
	ld hl,04a4dh		;2487	21 4d 4a	! M J
	ld e,01eh		;248a	1e 1e		. .
l248ch:
	inc hl			;248c	23		#
	djnz l248ch		;248d	10 fd		. .
	pop af			;248f	f1		.
	inc a			;2490	3c		<
	jr z,l2497h		;2491	28 04		( .
	ld a,(hl)		;2493	7e		~
	add a,c			;2494	81		.
	and d			;2495	a2		.
	ld c,a			;2496	4f		O
l2497h:
	ld b,e			;2497	43		C
	ld a,0ffh		;2498	3e ff		> .
	xor d			;249a	aa		.
	ld d,a			;249b	57		W
l249ch:
	ld a,(hl)		;249c	7e		~
	and d			;249d	a2		.
	or c			;249e	b1		.
	ld (hl),a		;249f	77		w
	inc hl			;24a0	23		#
	inc hl			;24a1	23		#
	inc hl			;24a2	23		#
	inc hl			;24a3	23		#
	djnz l249ch		;24a4	10 f6		. .
	call sub_223fh		;24a6	cd 3f 22	. ? "
	ret			;24a9	c9		.
l24aah:
	call sub_24b2h		;24aa	cd b2 24	. . $
	dec hl			;24ad	2b		+
	ld e,001h		;24ae	1e 01		. .
	jr l248ch		;24b0	18 da		. .
sub_24b2h:
	ld a,(04f83h)		;24b2	3a 83 4f	: . O
	rlca			;24b5	07		.
	rlca			;24b6	07		.
	ld h,000h		;24b7	26 00		& .
	ld l,a			;24b9	6f		o
	push de			;24ba	d5		.
	ld de,04a4eh		;24bb	11 4e 4a	. N J
	add hl,de		;24be	19		.
	pop de			;24bf	d1		.
	ret			;24c0	c9		.
l24c1h:
	ld sp,05055h		;24c1	31 55 50	1 U P
	call sub_0334h		;24c4	cd 34 03	. 4 .
	ld hl,l24c1h		;24c7	21 c1 24	! . $
	push hl			;24ca	e5		.
	call sub_1704h		;24cb	cd 04 17	. . .
	ld a,(04f79h)		;24ce	3a 79 4f	: y O
	bit 4,a			;24d1	cb 67		. g
	ret z			;24d3	c8		.
	ld ix,052cbh		;24d4	dd 21 cb 52	. ! . R
	ld hl,COLD_START	;24d8	21 00 00	! . .
l24dbh:
	push hl			;24db	e5		.
	ld a,l			;24dc	7d		}
	inc a			;24dd	3c		<
	ld (060cbh),a		;24de	32 cb 60	2 . `
	ld de,04109h		;24e1	11 09 41	. . A
	add hl,de		;24e4	19		.
	xor a			;24e5	af		.
	cp (hl)			;24e6	be		.
	jp z,l2621h		;24e7	ca 21 26	. ! &
	ld a,(ix+002h)		;24ea	dd 7e 02	. ~ .
	or (ix+003h)		;24ed	dd b6 03	. . .
	jp nz,l2621h		;24f0	c2 21 26	. ! &
	ld a,(ix+005h)		;24f3	dd 7e 05	. ~ .
	or (ix+006h)		;24f6	dd b6 06	. . .
	jp z,l25d9h		;24f9	ca d9 25	. . %
l24fch:
	pop de			;24fc	d1		.
	push de			;24fd	d5		.
	ld hl,05fb7h		;24fe	21 b7 5f	! . _
	add hl,de		;2501	19		.
	add hl,de		;2502	19		.
	add hl,de		;2503	19		.
	add hl,de		;2504	19		.
	ld (05fach),hl		;2505	22 ac 5f	" . _
	ld e,(hl)		;2508	5e		^
	inc hl			;2509	23		#
	ld d,(hl)		;250a	56		V
	ld a,e			;250b	7b		{
	or d			;250c	b2		.
	jr z,l2577h		;250d	28 68		( h
	inc hl			;250f	23		#
	ld c,(hl)		;2510	4e		N
	inc hl			;2511	23		#
	ld b,(hl)		;2512	46		F
	push hl			;2513	e5		.
	push bc			;2514	c5		.
	pop hl			;2515	e1		.
	call sub_0f20h		;2516	cd 20 0f	.   .
	pop hl			;2519	e1		.
	jr nc,l2526h		;251a	30 0a		0 .
	ld b,004h		;251c	06 04		. .
l251eh:
	ld (hl),000h		;251e	36 00		6 .
	dec hl			;2520	2b		+
	djnz l251eh		;2521	10 fb		. .
	jp l2621h		;2523	c3 21 26	. ! &
l2526h:
	ld h,d			;2526	62		b
	ld l,e			;2527	6b		k
	ld a,(060cbh)		;2528	3a cb 60	: . `
	call sub_0748h		;252b	cd 48 07	. H .
	cp 0feh			;252e	fe fe		. .
	jp z,l2621h		;2530	ca 21 26	. ! &
	push af			;2533	f5		.
	push hl			;2534	e5		.
	ld h,d			;2535	62		b
	ld l,e			;2536	6b		k
	call 0a04ah		;2537	cd 4a a0	. J .
	ld hl,(05fach)		;253a	2a ac 5f	* . _
	ld a,(0602ah)		;253d	3a 2a 60	: * `
	add a,(hl)		;2540	86		.
	ld (hl),a		;2541	77		w
	jr nc,l2546h		;2542	30 02		0 .
	inc hl			;2544	23		#
	inc (hl)		;2545	34		4
l2546h:
	pop hl			;2546	e1		.
	pop af			;2547	f1		.
	cp 0ffh			;2548	fe ff		. .
	jr z,l24fch		;254a	28 b0		( .
	call SOMETHING_MEM	;254c	cd 1a 0f	. . .
	bit 0,(hl)		;254f	cb 46		. F
	jr nz,l24fch		;2551	20 a9		  .
	bit 1,(hl)		;2553	cb 4e		. N
	jr nz,l24fch		;2555	20 a5		  .
	bit 2,(hl)		;2557	cb 56		. V
	jr z,l2563h		;2559	28 08		( .
	bit 3,(hl)		;255b	cb 5e		. ^
	jr z,l24fch		;255d	28 9d		( .
	ld a,(hl)		;255f	7e		~
	and 0c7h		;2560	e6 c7		. .
	ld (hl),a		;2562	77		w
l2563h:
	call sub_26aah		;2563	cd aa 26	. . &
	jr nz,l24fch		;2566	20 94		  .
	ld (ix+002h),l		;2568	dd 75 02	. u .
	ld (ix+003h),h		;256b	dd 74 03	. t .
	ld a,(CUR_MAP)		;256e	3a 22 41	: " A
	ld (ix+000h),a		;2571	dd 77 00	. w .
	jp l2621h		;2574	c3 21 26	. ! &
l2577h:
	nop			;2577	00		.
	ld a,(ix+004h)		;2578	dd 7e 04	. ~ .
	and 003h		;257b	e6 03		. .
	call sub_269bh		;257d	cd 9b 26	. . &
	ld l,(iy+006h)		;2580	fd 6e 06	. n .
	ld h,(iy+007h)		;2583	fd 66 07	. f .
	ld a,(060cbh)		;2586	3a cb 60	: . `
	call sub_0748h		;2589	cd 48 07	. H .
	cp 0feh			;258c	fe fe		. .
	jp z,l2621h		;258e	ca 21 26	. ! &
	push hl			;2591	e5		.
	ld l,(iy+006h)		;2592	fd 6e 06	. n .
	ld h,(iy+007h)		;2595	fd 66 07	. f .
	call 0a04ah		;2598	cd 4a a0	. J .
	pop hl			;259b	e1		.
	cp 0ffh			;259c	fe ff		. .
	jp z,l261eh		;259e	ca 1e 26	. . &
	call SOMETHING_MEM	;25a1	cd 1a 0f	. . .
	bit 1,(hl)		;25a4	cb 4e		. N
	jr nz,l261eh		;25a6	20 76		  v
	bit 2,(hl)		;25a8	cb 56		. V
	jr z,l25deh		;25aa	28 32		( 2
	bit 3,(hl)		;25ac	cb 5e		. ^
	jr z,l25b6h		;25ae	28 06		( .
	ld a,(hl)		;25b0	7e		~
	and 0c7h		;25b1	e6 c7		. .
	ld (hl),a		;25b3	77		w
	jr l25deh		;25b4	18 28		. (
l25b6h:
	bit 4,(hl)		;25b6	cb 66		. f
	jr z,l25bfh		;25b8	28 05		( .
	call sub_2632h		;25ba	cd 32 26	. 2 &
	jr l2621h		;25bd	18 62		. b
l25bfh:
	bit 5,(hl)		;25bf	cb 6e		. n
	jr nz,l25cdh		;25c1	20 0a		  .
	ld a,(052c4h)		;25c3	3a c4 52	: . R
	ld (ix+001h),a		;25c6	dd 77 01	. w .
	set 5,(hl)		;25c9	cb ee		. .
	jr l2621h		;25cb	18 54		. T
l25cdh:
	ld a,(052c4h)		;25cd	3a c4 52	: . R
	sub (ix+001h)		;25d0	dd 96 01	. . .
	cp 014h			;25d3	fe 14		. .
	jr c,l2621h		;25d5	38 4a		8 J
	set 4,(hl)		;25d7	cb e6		. .
l25d9h:
	call sub_2632h		;25d9	cd 32 26	. 2 &
	jr l2621h		;25dc	18 43		. C
l25deh:
	bit 0,(hl)		;25de	cb 46		. F
	jr nz,l261eh		;25e0	20 3c		  <
	bit 6,(hl)		;25e2	cb 76		. v
	jr z,l25edh		;25e4	28 07		( .
	bit 3,(hl)		;25e6	cb 5e		. ^
	jp z,l261eh		;25e8	ca 1e 26	. . &
	res 3,(hl)		;25eb	cb 9e		. .
l25edh:
	call sub_26aah		;25ed	cd aa 26	. . &
	jr nz,l261eh		;25f0	20 2c		  ,
	call sub_2774h		;25f2	cd 74 27	. t '
	jr nz,l261eh		;25f5	20 27		  '
	ld (ix+002h),l		;25f7	dd 75 02	. u .
	ld (ix+003h),h		;25fa	dd 74 03	. t .
	ld a,(CUR_MAP)		;25fd	3a 22 41	: " A
	ld (ix+000h),a		;2600	dd 77 00	. w .
	res 2,(ix+004h)		;2603	dd cb 04 96	. . . .
	call sub_265dh		;2607	cd 5d 26	. ] &
	ld l,(ix+005h)		;260a	dd 6e 05	. n .
	ld h,(ix+006h)		;260d	dd 66 06	. f .
	dec hl			;2610	2b		+
	ld (ix+005h),l		;2611	dd 75 05	. u .
	ld (ix+006h),h		;2614	dd 74 06	. t .
	ld a,l			;2617	7d		}
	or h			;2618	b4		.
	call z,sub_2632h	;2619	cc 32 26	. 2 &
	jr l2621h		;261c	18 03		. .
l261eh:
	call sub_265dh		;261e	cd 5d 26	. ] &
l2621h:
	pop hl			;2621	e1		.
	call sub_0334h		;2622	cd 34 03	. 4 .
	ld de,00027h		;2625	11 27 00	. ' .
	add ix,de		;2628	dd 19		. .
	inc l			;262a	2c		,
	ld a,005h		;262b	3e 05		> .
	cp l			;262d	bd		.
	jp nc,l24dbh		;262e	d2 db 24	. . $
	ret			;2631	c9		.
sub_2632h:
	ld b,004h		;2632	06 04		. .
l2634h:
	ld a,(ix+004h)		;2634	dd 7e 04	. ~ .
	and 003h		;2637	e6 03		. .
	inc a			;2639	3c		<
	cp 004h			;263a	fe 04		. .
	jr c,l263fh		;263c	38 01		8 .
	xor a			;263e	af		.
l263fh:
	ld (ix+004h),a		;263f	dd 77 04	. w .
	call sub_269bh		;2642	cd 9b 26	. . &
	ld a,(iy+004h)		;2645	fd 7e 04	. ~ .
	or (iy+005h)		;2648	fd b6 05	. . .
	jr nz,l2650h		;264b	20 03		  .
	djnz l2634h		;264d	10 e5		. .
	ret			;264f	c9		.
l2650h:
	ld a,(iy+004h)		;2650	fd 7e 04	. ~ .
	ld (ix+005h),a		;2653	dd 77 05	. w .
	ld a,(iy+005h)		;2656	fd 7e 05	. ~ .
	ld (ix+006h),a		;2659	dd 77 06	. w .
	ret			;265c	c9		.
sub_265dh:
	ld l,(iy+006h)		;265d	fd 6e 06	. n .
	ld h,(iy+007h)		;2660	fd 66 07	. f .
	ld e,(iy+002h)		;2663	fd 5e 02	. ^ .
	ld d,(iy+003h)		;2666	fd 56 03	. V .
	call sub_0f20h		;2669	cd 20 0f	.   .
	ld e,(iy+000h)		;266c	fd 5e 00	. ^ .
	ld d,(iy+001h)		;266f	fd 56 01	. V .
	jr nc,l2679h		;2672	30 05		0 .
	call sub_0f20h		;2674	cd 20 0f	.   .
	jr nc,l268dh		;2677	30 14		0 .
l2679h:
	ex de,hl		;2679	eb		.
	bit 2,(ix+004h)		;267a	dd cb 04 56	. . . V
	set 2,(ix+004h)		;267e	dd cb 04 d6	. . . .
	jr z,l2694h		;2682	28 10		( .
	push iy			;2684	fd e5		. .
	call sub_2632h		;2686	cd 32 26	. 2 &
	pop iy			;2689	fd e1		. .
	jr l2694h		;268b	18 07		. .
l268dh:
	ld a,(0602ah)		;268d	3a 2a 60	: * `
	ld e,a			;2690	5f		_
	ld d,000h		;2691	16 00		. .
	add hl,de		;2693	19		.
l2694h:
	ld (iy+006h),l		;2694	fd 75 06	. u .
	ld (iy+007h),h		;2697	fd 74 07	. t .
	ret			;269a	c9		.
sub_269bh:
	add a,a			;269b	87		.
	add a,a			;269c	87		.
	add a,a			;269d	87		.
	add a,007h		;269e	c6 07		. .
	ld d,000h		;26a0	16 00		. .
	ld e,a			;26a2	5f		_
	push ix			;26a3	dd e5		. .
	pop iy			;26a5	fd e1		. .
	add iy,de		;26a7	fd 19		. .
	ret			;26a9	c9		.
sub_26aah:
	push ix			;26aa	dd e5		. .
	push hl			;26ac	e5		.
	push hl			;26ad	e5		.
	pop ix			;26ae	dd e1		. .
	ld a,(ix+004h)		;26b0	dd 7e 04	. ~ .
	or a			;26b3	b7		.
	jp z,l2770h		;26b4	ca 70 27	. p '
	ld a,008h		;26b7	3e 08		> .
	cp (ix+004h)		;26b9	dd be 04	. . .
	jr z,l26c7h		;26bc	28 09		( .
	ld a,(05b93h)		;26be	3a 93 5b	: . [
	inc a			;26c1	3c		<
	cp (ix+004h)		;26c2	dd be 04	. . .
	jr nz,l26eah		;26c5	20 23		  #
l26c7h:
	ld a,(ix+005h)		;26c7	dd 7e 05	. ~ .
	or a			;26ca	b7		.
	jr z,l26eah		;26cb	28 1d		( .
	ld b,a			;26cd	47		G
	and 07fh		;26ce	e6 7f		. .
	cp 00ch			;26d0	fe 0c		. .
	jr nz,l26d8h		;26d2	20 04		  .
	ld a,b			;26d4	78		x
	and 080h		;26d5	e6 80		. .
	ld b,a			;26d7	47		G
l26d8h:
	ld a,(05b9ah)		;26d8	3a 9a 5b	: . [
	rrca			;26db	0f		.
	ld h,a			;26dc	67		g
	ld a,(05b97h)		;26dd	3a 97 5b	: . [
	or h			;26e0	b4		.
	cp b			;26e1	b8		.
	jr nz,l26eah		;26e2	20 06		  .
	ld a,(05b98h)		;26e4	3a 98 5b	: . [
	cp (ix+006h)		;26e7	dd be 06	. . .
l26eah:
	ld d,000h		;26ea	16 00		. .
	rl d			;26ec	cb 12		. .
	ld a,008h		;26ee	3e 08		> .
	cp (ix+004h)		;26f0	dd be 04	. . .
	jr z,l26feh		;26f3	28 09		( .
	ld a,(05b93h)		;26f5	3a 93 5b	: . [
	inc a			;26f8	3c		<
	cp (ix+007h)		;26f9	dd be 07	. . .
	jr nz,l2726h		;26fc	20 28		  (
l26feh:
	ld a,(ix+005h)		;26fe	dd 7e 05	. ~ .
	or a			;2701	b7		.
	jr z,l2727h		;2702	28 23		( #
	ld a,(ix+008h)		;2704	dd 7e 08	. ~ .
	ld b,a			;2707	47		G
	and 07fh		;2708	e6 7f		. .
	cp 00ch			;270a	fe 0c		. .
	jr nz,l2712h		;270c	20 04		  .
	ld a,b			;270e	78		x
	and 080h		;270f	e6 80		. .
	ld b,a			;2711	47		G
l2712h:
	ld a,(05b9ah)		;2712	3a 9a 5b	: . [
	rrca			;2715	0f		.
	ld h,a			;2716	67		g
	ld a,(05b97h)		;2717	3a 97 5b	: . [
	or h			;271a	b4		.
	cp b			;271b	b8		.
	jr nz,l2726h		;271c	20 08		  .
	ld a,(05b98h)		;271e	3a 98 5b	: . [
	cp (ix+009h)		;2721	dd be 09	. . .
	jr z,l2727h		;2724	28 01		( .
l2726h:
	ccf			;2726	3f		?
l2727h:
	ld e,000h		;2727	1e 00		. .
	rl e			;2729	cb 13		. .
	ld a,d			;272b	7a		z
	or e			;272c	b3		.
	jr z,l2770h		;272d	28 41		( A
	ld a,d			;272f	7a		z
	and e			;2730	a3		.
	jr nz,l2770h		;2731	20 3d		  =
	ld a,(ix+004h)		;2733	dd 7e 04	. ~ .
	cp 008h			;2736	fe 08		. .
	jr z,l273fh		;2738	28 05		( .
	cp (ix+007h)		;273a	dd be 07	. . .
	jr nz,l276ch		;273d	20 2d		  -
l273fh:
	ld a,(ix+005h)		;273f	dd 7e 05	. ~ .
	or a			;2742	b7		.
	scf			;2743	37		7
	jr z,l276ch		;2744	28 26		( &
	ld b,a			;2746	47		G
	and 07fh		;2747	e6 7f		. .
	cp 00ch			;2749	fe 0c		. .
	jr nz,l2751h		;274b	20 04		  .
	ld a,b			;274d	78		x
	and 080h		;274e	e6 80		. .
	ld b,a			;2750	47		G
l2751h:
	ld a,(ix+008h)		;2751	dd 7e 08	. ~ .
	ld c,a			;2754	4f		O
	and 07fh		;2755	e6 7f		. .
	cp 00ch			;2757	fe 0c		. .
	jr nz,l275fh		;2759	20 04		  .
	ld a,c			;275b	79		y
	and 080h		;275c	e6 80		. .
	ld c,a			;275e	4f		O
l275fh:
	ld a,b			;275f	78		x
	cp c			;2760	b9		.
	jr nz,l276ch		;2761	20 09		  .
	ld a,(ix+006h)		;2763	dd 7e 06	. ~ .
	cp (ix+009h)		;2766	dd be 09	. . .
	jr nz,l276ch		;2769	20 01		  .
	scf			;276b	37		7
l276ch:
	ld a,000h		;276c	3e 00		> .
	rla			;276e	17		.
	or a			;276f	b7		.
l2770h:
	pop hl			;2770	e1		.
	pop ix			;2771	dd e1		. .
	ret			;2773	c9		.
sub_2774h:
	xor a			;2774	af		.
	ret			;2775	c9		.
	call sub_2a82h		;2776	cd 82 2a	. . *
	call sub_2aeeh		;2779	cd ee 2a	. . *
	ld a,(05cbah)		;277c	3a ba 5c	: . \
	cp 005h			;277f	fe 05		. .
	jr nz,l2788h		;2781	20 05		  .
l2783h:
	ld hl,05cc6h		;2783	21 c6 5c	! . \
	jr l2790h		;2786	18 08		. .
l2788h:
	call sub_2b05h		;2788	cd 05 2b	. . +
	cp 0ffh			;278b	fe ff		. .
	jp z,l1934h		;278d	ca 34 19	. 4 .
l2790h:
	ld bc,0x30		;2790	01 30 00	. 0 .
	ex de,hl		;2793	eb		.
	ld hl,04a3eh		;2794	21 3e 4a	! > J
	call sub_28e4h		;2797	cd e4 28	. . (
	ldir			;279a	ed b0		. .
	ld hl,04ac6h		;279c	21 c6 4a	! . J
	ld bc,l0140h		;279f	01 40 01	. @ .
	call sub_28e4h		;27a2	cd e4 28	. . (
	ldir			;27a5	ed b0		. .
	ld a,(05cbah)		;27a7	3a ba 5c	: . \
	cp 005h			;27aa	fe 05		. .
	jr nz,l27cdh		;27ac	20 1f		  .
	ld hl,(04f89h)		;27ae	2a 89 4f	* . O
	call sub_2b25h		;27b1	cd 25 2b	. % +
	cp 0ffh			;27b4	fe ff		. .
	jp z,l2b17h		;27b6	ca 17 2b	. . +
	ld a,(05cc3h)		;27b9	3a c3 5c	: . \
	bit 1,a			;27bc	cb 4f		. O
	jr nz,l27c6h		;27be	20 06		  .
	call sub_1f2ah		;27c0	cd 2a 1f	. * .
	jp nz,l28dbh		;27c3	c2 db 28	. . (
l27c6h:
	ld hl,05cc6h		;27c6	21 c6 5c	! . \
	ld (hl),0ffh		;27c9	36 ff		6 .
	jr l27e6h		;27cb	18 19		. .
l27cdh:
	ld hl,(04f89h)		;27cd	2a 89 4f	* . O
	inc hl			;27d0	23		#
	call sub_07f9h		;27d1	cd f9 07	. . .
	cp 0ffh			;27d4	fe ff		. .
	jp z,l28dbh		;27d6	ca db 28	. . (
	call SOMETHING_MEM	;27d9	cd 1a 0f	. . .
	bit 1,(hl)		;27dc	cb 4e		. N
	jr nz,l27e6h		;27de	20 06		  .
	call sub_1f2ah		;27e0	cd 2a 1f	. * .
	jp nz,l28dbh		;27e3	c2 db 28	. . (
l27e6h:
	ld de,16		;27e6	11 10 00	. . .
	add hl,de		;27e9	19		.
	ex de,hl		;27ea	eb		.
	ld bc,32		;27eb	01 20 00	.   .
	ld hl,04a6eh		;27ee	21 6e 4a	! n J
	call sub_28e4h		;27f1	cd e4 28	. . (
	ldir			;27f4	ed b0		. .
	ld hl,04c06h		;27f6	21 06 4c	! . L
	ld bc,l0140h		;27f9	01 40 01	. @ .
	call sub_28e4h		;27fc	cd e4 28	. . (
	ldir			;27ff	ed b0		. .
	ld a,(05cbah)		;2801	3a ba 5c	: . \
	cp 005h			;2804	fe 05		. .
	jr nz,l2828h		;2806	20 20		   
	ld hl,(04f89h)		;2808	2a 89 4f	* . O
	inc hl			;280b	23		#
	call sub_2b25h		;280c	cd 25 2b	. % +
	or a			;280f	b7		.
	jp nz,l2783h		;2810	c2 83 27	. . '
	ld a,(05cc3h)		;2813	3a c3 5c	: . \
	bit 1,a			;2816	cb 4f		. O
	jp z,l28dbh		;2818	ca db 28	. . (
	call sub_1f2ah		;281b	cd 2a 1f	. * .
	jp z,l28dbh		;281e	ca db 28	. . (
	ld hl,05cc6h		;2821	21 c6 5c	! . \
	ld (hl),0ffh		;2824	36 ff		6 .
	jr l2843h		;2826	18 1b		. .
l2828h:
	ld hl,(04f89h)		;2828	2a 89 4f	* . O
	inc hl			;282b	23		#
	inc hl			;282c	23		#
	call sub_07f9h		;282d	cd f9 07	. . .
	cp 0ffh			;2830	fe ff		. .
	jp z,l28dbh		;2832	ca db 28	. . (
	call sub_1f2ah		;2835	cd 2a 1f	. * .
	jp z,l28dbh		;2838	ca db 28	. . (
	call SOMETHING_MEM	;283b	cd 1a 0f	. . .
	bit 1,(hl)		;283e	cb 4e		. N
	jp z,l28dbh		;2840	ca db 28	. . (
l2843h:
	ld de,16		;2843	11 10 00	. . .
	add hl,de		;2846	19		.
	ex de,hl		;2847	eb		.
	ld hl,04a8eh		;2848	21 8e 4a	! . J
	ld bc,32		;284b	01 20 00	.   .
	call sub_28e4h		;284e	cd e4 28	. . (
	ldir			;2851	ed b0		. .
	ld hl,04d46h		;2853	21 46 4d	! F M
	ld bc,l0140h		;2856	01 40 01	. @ .
	call sub_28e4h		;2859	cd e4 28	. . (
	ldir			;285c	ed b0		. .
	ld a,(05cbah)		;285e	3a ba 5c	: . \
	cp 005h			;2861	fe 05		. .
	jr nz,l2880h		;2863	20 1b		  .
	ld hl,(04f89h)		;2865	2a 89 4f	* . O
	inc hl			;2868	23		#
	inc hl			;2869	23		#
	call sub_2b25h		;286a	cd 25 2b	. % +
	or a			;286d	b7		.
	jp nz,l2783h		;286e	c2 83 27	. . '
	ld a,(05cc3h)		;2871	3a c3 5c	: . \
	bit 1,a			;2874	cb 4f		. O
	jp z,l28dbh		;2876	ca db 28	. . (
	ld hl,05cc6h		;2879	21 c6 5c	! . \
	ld (hl),0ffh		;287c	36 ff		6 .
	jr l2896h		;287e	18 16		. .
l2880h:
	ld hl,(04f89h)		;2880	2a 89 4f	* . O
	inc hl			;2883	23		#
	inc hl			;2884	23		#
	inc hl			;2885	23		#
	call sub_07f9h		;2886	cd f9 07	. . .
	cp 0ffh			;2889	fe ff		. .
	jp z,l28dbh		;288b	ca db 28	. . (
	call SOMETHING_MEM	;288e	cd 1a 0f	. . .
	bit 1,(hl)		;2891	cb 4e		. N
	jp z,l28dbh		;2893	ca db 28	. . (
l2896h:
	ld de,16		;2896	11 10 00	. . .
	add hl,de		;2899	19		.
	ex de,hl		;289a	eb		.
	ld hl,04aaeh		;289b	21 ae 4a	! . J
	ld bc,8		;289e	01 08 00	. . .
	call sub_28e4h		;28a1	cd e4 28	. . (
	ldir			;28a4	ed b0		. .
	push de			;28a6	d5		.
	pop hl			;28a7	e1		.
	dec hl			;28a8	2b		+
	dec hl			;28a9	2b		+
	dec hl			;28aa	2b		+
	dec hl			;28ab	2b		+
	ld bc,24		;28ac	01 18 00	. . .
	ldir			;28af	ed b0		. .
	ld hl,04e86h		;28b1	21 86 4e	! . N
	ld bc,00050h		;28b4	01 50 00	. P .
	call sub_28e4h		;28b7	cd e4 28	. . (
	ldir			;28ba	ed b0		. .
	push de			;28bc	d5		.
	pop hl			;28bd	e1		.
	inc de			;28be	13		.
	ld (hl),020h		;28bf	36 20		6  
	ld bc,l00efh		;28c1	01 ef 00	. . .
	ldir			;28c4	ed b0		. .
	ld a,(05cbah)		;28c6	3a ba 5c	: . \
	cp 005h			;28c9	fe 05		. .
	jp nz,l28dbh		;28cb	c2 db 28	. . (
	ld hl,(04f89h)		;28ce	2a 89 4f	* . O
	inc hl			;28d1	23		#
	inc hl			;28d2	23		#
	inc hl			;28d3	23		#
	call sub_2b25h		;28d4	cd 25 2b	. % +
	or a			;28d7	b7		.
	jp nz,l2783h		;28d8	c2 83 27	. . '
l28dbh:
	call sub_13c8h		;28db	cd c8 13	. . .
	ld a,d			;28de	7a		z
	ret nc			;28df	d0		.
	ex af,af'		;28e0	08		.
	jp l1934h		;28e1	c3 34 19	. 4 .
sub_28e4h:
	push hl			;28e4	e5		.
	push de			;28e5	d5		.
	push bc			;28e6	c5		.
l28e7h:
	ld a,(de)		;28e7	1a		.
	cp (hl)			;28e8	be		.
	call nz,sub_28f7h	;28e9	c4 f7 28	. . (
	inc hl			;28ec	23		#
	inc de			;28ed	13		.
	dec bc			;28ee	0b		.
	ld a,c			;28ef	79		y
	or b			;28f0	b0		.
	jr nz,l28e7h		;28f1	20 f4		  .
	pop bc			;28f3	c1		.
	pop de			;28f4	d1		.
	pop hl			;28f5	e1		.
	ret			;28f6	c9		.
sub_28f7h:
	ld hl,(04f89h)		;28f7	2a 89 4f	* . O
	ld a,h			;28fa	7c		|
	cp 000h			;28fb	fe 00		. .
	jr nz,l291eh		;28fd	20 1f		  .
	ld a,l			;28ff	7d		}
	cp 064h			;2900	fe 64		. d
	jr nc,l291eh		;2902	30 1a		0 .
	and 007h		;2904	e6 07		. .
	inc a			;2906	3c		<
	ld b,a			;2907	47		G
	ld a,080h		;2908	3e 80		> .
l290ah:
	rlca			;290a	07		.
	djnz l290ah		;290b	10 fd		. .
	ld c,a			;290d	4f		O
	ld a,l			;290e	7d		}
	and 078h		;290f	e6 78		. x
	rrca			;2911	0f		.
	rrca			;2912	0f		.
	rrca			;2913	0f		.
	ld l,a			;2914	6f		o
	ld h,000h		;2915	26 00		& .
	ld de,060d0h		;2917	11 d0 60	. . `
	add hl,de		;291a	19		.
	ld a,(hl)		;291b	7e		~
	or c			;291c	b1		.
	ld (hl),a		;291d	77		w
l291eh:
	ld bc,1		;291e	01 01 00	. . .
	ret			;2921	c9		.
	call sub_2a82h		;2922	cd 82 2a	. . *
	call sub_2aeeh		;2925	cd ee 2a	. . *
	ld a,(05cbah)		;2928	3a ba 5c	: . \
	cp 005h			;292b	fe 05		. .
	jr nz,l2943h		;292d	20 14		  .
	ld de,(05e9dh)		;292f	ed 5b 9d 5e	. [ . ^
	call 08b36h		;2933	cd 36 8b	. 6 .
	call 08879h		;2936	cd 79 88	. y .
	cp 0ffh			;2939	fe ff		. .
	jp z,l2b10h		;293b	ca 10 2b	. . +
	ld hl,05cc6h		;293e	21 c6 5c	! . \
	jr l2949h		;2941	18 06		. .
l2943h:
	call sub_2b05h		;2943	cd 05 2b	. . +
	cp 0ffh			;2946	fe ff		. .
	ret z			;2948	c8		.
l2949h:
	ld bc,0x30		;2949	01 30 00	. 0 .
	ld de,04a3eh		;294c	11 3e 4a	. > J
	ldir			;294f	ed b0		. .
	ld de,04ac6h		;2951	11 c6 4a	. . J
	ld bc,l0140h		;2954	01 40 01	. @ .
	ldir			;2957	ed b0		. .
	ld hl,(04f89h)		;2959	2a 89 4f	* . O
	inc hl			;295c	23		#
	call sub_2b3fh		;295d	cd 3f 2b	. ? +
	cp 0ffh			;2960	fe ff		. .
	jp z,l29ech		;2962	ca ec 29	. . )
	call SOMETHING_MEM	;2965	cd 1a 0f	. . .
	bit 1,(hl)		;2968	cb 4e		. N
	jr nz,l297dh		;296a	20 11		  .
	call sub_1f2ah		;296c	cd 2a 1f	. * .
	jp nz,l29ech		;296f	c2 ec 29	. . )
	push hl			;2972	e5		.
	ld hl,(04f89h)		;2973	2a 89 4f	* . O
	call sub_1eeah		;2976	cd ea 1e	. . .
	pop hl			;2979	e1		.
	jp nz,l29ech		;297a	c2 ec 29	. . )
l297dh:
	ld de,16		;297d	11 10 00	. . .
	add hl,de		;2980	19		.
	ld bc,32		;2981	01 20 00	.   .
	ld de,04a6eh		;2984	11 6e 4a	. n J
	ldir			;2987	ed b0		. .
	ld de,04c06h		;2989	11 06 4c	. . L
	ld bc,l0140h		;298c	01 40 01	. @ .
	ldir			;298f	ed b0		. .
	ld hl,(04f89h)		;2991	2a 89 4f	* . O
	inc hl			;2994	23		#
	inc hl			;2995	23		#
	call sub_2b3fh		;2996	cd 3f 2b	. ? +
	cp 0ffh			;2999	fe ff		. .
	jr z,l2a06h		;299b	28 69		( i
	call SOMETHING_MEM	;299d	cd 1a 0f	. . .
	bit 1,(hl)		;29a0	cb 4e		. N
	jr z,l2a06h		;29a2	28 62		( b
	call sub_1f2ah		;29a4	cd 2a 1f	. * .
	jr z,l2a06h		;29a7	28 5d		( ]
	ld de,16		;29a9	11 10 00	. . .
	add hl,de		;29ac	19		.
	ld bc,32		;29ad	01 20 00	.   .
	ld de,04a8eh		;29b0	11 8e 4a	. . J
	ldir			;29b3	ed b0		. .
	ld de,04d46h		;29b5	11 46 4d	. F M
	ld bc,l0140h		;29b8	01 40 01	. @ .
	ldir			;29bb	ed b0		. .
	ld hl,(04f89h)		;29bd	2a 89 4f	* . O
	inc hl			;29c0	23		#
	inc hl			;29c1	23		#
	inc hl			;29c2	23		#
	call sub_2b3fh		;29c3	cd 3f 2b	. ? +
	cp 0ffh			;29c6	fe ff		. .
	jr z,l2a20h		;29c8	28 56		( V
	call SOMETHING_MEM	;29ca	cd 1a 0f	. . .
	bit 1,(hl)		;29cd	cb 4e		. N
	jr z,l2a20h		;29cf	28 4f		( O
	ld de,16		;29d1	11 10 00	. . .
	add hl,de		;29d4	19		.
	ld bc,8		;29d5	01 08 00	. . .
	ld de,04aaeh		;29d8	11 ae 4a	. . J
	ldir			;29db	ed b0		. .
	ld de,24		;29dd	11 18 00	. . .
	add hl,de		;29e0	19		.
	ld de,04e86h		;29e1	11 86 4e	. . N
	ld bc,00050h		;29e4	01 50 00	. P .
	ldir			;29e7	ed b0		. .
l29e9h:
	jp l1925h		;29e9	c3 25 19	. % .
l29ech:
	ld hl,04a6ah		;29ec	21 6a 4a	! j J
	ld de,04a6eh		;29ef	11 6e 4a	. n J
	ld bc,00048h		;29f2	01 48 00	. H .
	ldir			;29f5	ed b0		. .
	ld hl,04c06h		;29f7	21 06 4c	! . L
	ld de,04c07h		;29fa	11 07 4c	. . L
	ld (hl),020h		;29fd	36 20		6  
	ld bc,l02cfh		;29ff	01 cf 02	. . .
	ldir			;2a02	ed b0		. .
	jr l29e9h		;2a04	18 e3		. .
l2a06h:
	ld hl,04a8ah		;2a06	21 8a 4a	! . J
	ld de,04a8eh		;2a09	11 8e 4a	. . J
	ld bc,00028h		;2a0c	01 28 00	. ( .
	ldir			;2a0f	ed b0		. .
	ld hl,04d46h		;2a11	21 46 4d	! F M
	ld de,04d47h		;2a14	11 47 4d	. G M
	ld (hl),020h		;2a17	36 20		6  
	ld bc,l018fh		;2a19	01 8f 01	. . .
	ldir			;2a1c	ed b0		. .
	jr l29e9h		;2a1e	18 c9		. .
l2a20h:
	ld hl,04aaah		;2a20	21 aa 4a	! . J
	ld de,04aaeh		;2a23	11 ae 4a	. . J
	ld bc,8		;2a26	01 08 00	. . .
	ldir			;2a29	ed b0		. .
	ld hl,04e86h		;2a2b	21 86 4e	! . N
	ld de,04e87h		;2a2e	11 87 4e	. . N
	ld (hl),020h		;2a31	36 20		6  
	ld bc,0004fh		;2a33	01 4f 00	. O .
	ldir			;2a36	ed b0		. .
	jr l29e9h		;2a38	18 af		. .
l2a3ah:
	ld hl,(04f89h)		;2a3a	2a 89 4f	* . O
	inc hl			;2a3d	23		#
	ld (04f89h),hl		;2a3e	22 89 4f	" . O
	call sub_2b73h		;2a41	cd 73 2b	. s +
	cp 0ffh			;2a44	fe ff		. .
	jp z,l2b10h		;2a46	ca 10 2b	. . +
	call SOMETHING_MEM	;2a49	cd 1a 0f	. . .
	bit 1,(hl)		;2a4c	cb 4e		. N
	jp z,l2949h		;2a4e	ca 49 29	. I )
	push hl			;2a51	e5		.
	ld hl,(04f89h)		;2a52	2a 89 4f	* . O
	call sub_1eeah		;2a55	cd ea 1e	. . .
	pop hl			;2a58	e1		.
	jp z,l2949h		;2a59	ca 49 29	. I )
	jr l2a3ah		;2a5c	18 dc		. .
l2a5eh:
	ld hl,(04f89h)		;2a5e	2a 89 4f	* . O
	dec hl			;2a61	2b		+
	ld (04f89h),hl		;2a62	22 89 4f	" . O
	call sub_2b73h		;2a65	cd 73 2b	. s +
	cp 0ffh			;2a68	fe ff		. .
	jp z,l2b10h		;2a6a	ca 10 2b	. . +
	call SOMETHING_MEM	;2a6d	cd 1a 0f	. . .
	bit 1,(hl)		;2a70	cb 4e		. N
	jp z,l2949h		;2a72	ca 49 29	. I )
	push hl			;2a75	e5		.
	ld hl,(04f89h)		;2a76	2a 89 4f	* . O
	call sub_1eeah		;2a79	cd ea 1e	. . .
	pop hl			;2a7c	e1		.
	jp z,l2949h		;2a7d	ca 49 29	. I )
	jr l2a5eh		;2a80	18 dc		. .
sub_2a82h:
	ld hl,04f79h		;2a82	21 79 4f	! y O
	bit 4,(hl)		;2a85	cb 66		. f
	ret nz			;2a87	c0		.
	ld hl,04123h		;2a88	21 23 41	! # A
	ld b,036h		;2a8b	06 36		. 6
	ld a,(l0005h)		;2a8d	3a 05 00	: . .
	cp 0aah			;2a90	fe aa		. .
	jr nz,l2a96h		;2a92	20 02		  .
	ld b,081h		;2a94	06 81		. .
l2a96h:
	ld a,(05cbah)		;2a96	3a ba 5c	: . \
	cp 005h			;2a99	fe 05		. .
	ld c,080h		;2a9b	0e 80		. .
	jr nz,l2aa1h		;2a9d	20 02		  .
	ld c,082h		;2a9f	0e 82		. .
l2aa1h:
	ld (hl),c		;2aa1	71		q
	inc hl			;2aa2	23		#
	djnz l2aa1h		;2aa3	10 fc		. .
	ld b,01ah		;2aa5	06 1a		. .
l2aa7h:
	ld a,0feh		;2aa7	3e fe		> .
	push bc			;2aa9	c5		.
	ld (hl),060h		;2aaa	36 60		6 `
	inc hl			;2aac	23		#
	ld (hl),060h		;2aad	36 60		6 `
	inc hl			;2aaf	23		#
	ld (hl),084h		;2ab0	36 84		6 .
	ld b,028h		;2ab2	06 28		. (
l2ab4h:
	inc hl			;2ab4	23		#
	ld (hl),020h		;2ab5	36 20		6  
	djnz l2ab4h		;2ab7	10 fb		. .
	inc hl			;2ab9	23		#
	ld (hl),038h		;2aba	36 38		6 8
	inc hl			;2abc	23		#
	ld (hl),0c9h		;2abd	36 c9		6 .
	inc hl			;2abf	23		#
	ld (hl),030h		;2ac0	36 30		6 0
	ld b,007h		;2ac2	06 07		. .
l2ac4h:
	inc hl			;2ac4	23		#
	inc a			;2ac5	3c		<
	inc a			;2ac6	3c		<
	ld (hl),a		;2ac7	77		w
	inc hl			;2ac8	23		#
	inc a			;2ac9	3c		<
	inc a			;2aca	3c		<
	ld (hl),a		;2acb	77		w
	inc hl			;2acc	23		#
	ld (hl),c		;2acd	71		q
	djnz l2ac4h		;2ace	10 f4		. .
	pop bc			;2ad0	c1		.
	inc hl			;2ad1	23		#
	djnz l2aa7h		;2ad2	10 d3		. .
	ld b,036h		;2ad4	06 36		. 6
	ld a,(l0005h)		;2ad6	3a 05 00	: . .
	cp 0aah			;2ad9	fe aa		. .
	jr nz,l2adfh		;2adb	20 02		  .
	ld b,0fah		;2add	06 fa		. .
l2adfh:
	ld (hl),c		;2adf	71		q
	inc hl			;2ae0	23		#
	djnz l2adfh		;2ae1	10 fc		. .
	ld a,004h		;2ae3	3e 04		> .
	call OUTCH		;2ae5	cd 84 10	. . .
	ld a,000h		;2ae8	3e 00		> .
	call SOMETHING_MEM	;2aea	cd 1a 0f	. . .
	ret			;2aed	c9		.
sub_2aeeh:
	call sub_13c8h		;2aee	cd c8 13	. . .
	add a,d			;2af1	82		.
	ret nc			;2af2	d0		.
	dec b			;2af3	05		.
	call sub_1431h		;2af4	cd 31 14	. 1 .
	adc a,c			;2af7	89		.
	ld c,a			;2af8	4f		O
	inc b			;2af9	04		.
	call sub_156ch		;2afa	cd 6c 15	. l .
	ld bc,0e4cdh		;2afd	01 cd e4	. . .
	inc de			;2b00	13		.
	adc a,c			;2b01	89		.
	ld c,a			;2b02	4f		O
	inc b			;2b03	04		.
	ret			;2b04	c9		.
sub_2b05h:
	call sub_07f9h		;2b05	cd f9 07	. . .
	cp 0ffh			;2b08	fe ff		. .
	jr z,l2b10h		;2b0a	28 04		( .
	call SOMETHING_MEM	;2b0c	cd 1a 0f	. . .
	ret			;2b0f	c9		.
l2b10h:
	call sub_13c8h		;2b10	cd c8 13	. . .
	add a,a			;2b13	87		.
	ret nc			;2b14	d0		.
	inc d			;2b15	14		.
	ret			;2b16	c9		.
l2b17h:
	ld a,(05cbch)		;2b17	3a bc 5c	: . \
	cp 055h			;2b1a	fe 55		. U
	jp z,l2783h		;2b1c	ca 83 27	. . '
	call l2b10h		;2b1f	cd 10 2b	. . +
	jp l1934h		;2b22	c3 34 19	. 4 .
sub_2b25h:
	call 08b36h		;2b25	cd 36 8b	. 6 .
	ld (05cc3h),hl		;2b28	22 c3 5c	" . \
	ld hl,(05e9dh)		;2b2b	2a 9d 5e	* . ^
	ld (05cbfh),hl		;2b2e	22 bf 5c	" . \
	ld a,053h		;2b31	3e 53		> S
	ld (05cc1h),a		;2b33	32 c1 5c	2 . \
	ld a,050h		;2b36	3e 50		> P
	ld (05cc2h),a		;2b38	32 c2 5c	2 . \
	call 0878fh		;2b3b	cd 8f 87	. . .
	ret			;2b3e	c9		.
sub_2b3fh:
	ld a,(05cbah)		;2b3f	3a ba 5c	: . \
	cp 005h			;2b42	fe 05		. .
	jr z,l2b4ah		;2b44	28 04		( .
	call sub_07f9h		;2b46	cd f9 07	. . .
	ret			;2b49	c9		.
l2b4ah:
	ld a,(05e36h)		;2b4a	3a 36 5e	: 6 ^
	bit 1,a			;2b4d	cb 4f		. O
	ld a,0ffh		;2b4f	3e ff		> .
	jr nz,l2b60h		;2b51	20 0d		  .
	call sub_1eeah		;2b53	cd ea 1e	. . .
	ret nz			;2b56	c0		.
	ld de,(04f89h)		;2b57	ed 5b 89 4f	. [ . O
l2b5bh:
	inc de			;2b5b	13		.
	call sub_0f20h		;2b5c	cd 20 0f	.   .
	ret nz			;2b5f	c0		.
l2b60h:
	ld de,(05e9dh)		;2b60	ed 5b 9d 5e	. [ . ^
	call 08b36h		;2b64	cd 36 8b	. 6 .
	call 08879h		;2b67	cd 79 88	. y .
	cp 0ffh			;2b6a	fe ff		. .
	ret z			;2b6c	c8		.
	ld hl,05cc6h		;2b6d	21 c6 5c	! . \
	ld a,000h		;2b70	3e 00		> .
	ret			;2b72	c9		.
sub_2b73h:
	ld a,(05cbah)		;2b73	3a ba 5c	: . \
	cp 005h			;2b76	fe 05		. .
	jr z,l2b7eh		;2b78	28 04		( .
	call sub_07f9h		;2b7a	cd f9 07	. . .
	ret			;2b7d	c9		.
l2b7eh:
	ld de,(05e9dh)		;2b7e	ed 5b 9d 5e	. [ . ^
	call 08b36h		;2b82	cd 36 8b	. 6 .
	call 08879h		;2b85	cd 79 88	. y .
	ld hl,05cc6h		;2b88	21 c6 5c	! . \
	ret			;2b8b	c9		.
l2b8ch:
	ld sp,050b9h		;2b8c	31 b9 50	1 . P
	call sub_0334h		;2b8f	cd 34 03	. 4 .
	ld hl,l2b8ch		;2b92	21 8c 2b	! . +
	push hl			;2b95	e5		.
	ld a,(04f79h)		;2b96	3a 79 4f	: y O
	bit 4,a			;2b99	cb 67		. g
	ret z			;2b9b	c8		.
	ld a,(05754h)		;2b9c	3a 54 57	: T W
	inc a			;2b9f	3c		<
	ld ix,(05755h)		;2ba0	dd 2a 55 57	. * U W
	ld de,4		;2ba4	11 04 00	. . .
	add ix,de		;2ba7	dd 19		. .
	cp 007h			;2ba9	fe 07		. .
	jr c,l2bafh		;2bab	38 02		8 .
	ld a,001h		;2bad	3e 01		> .
l2bafh:
	cp 001h			;2baf	fe 01		. .
	jr nz,l2bb7h		;2bb1	20 04		  .
	ld ix,0573ch		;2bb3	dd 21 3c 57	. ! < W
l2bb7h:
	ld (05755h),ix		;2bb7	dd 22 55 57	. " U W
	ld (05754h),a		;2bbb	32 54 57	2 T W
	ld c,a			;2bbe	4f		O
	ld b,000h		;2bbf	06 00		. .
	ld hl,04108h		;2bc1	21 08 41	! . A
	add hl,bc		;2bc4	09		.
	ld a,(hl)		;2bc5	7e		~
	or a			;2bc6	b7		.
	ret z			;2bc7	c8		.
	ld a,(ix+000h)		;2bc8	dd 7e 00	. ~ .
	cp 002h			;2bcb	fe 02		. .
l2bcdh:
	jp c,l2e0eh		;2bcd	da 0e 2e	. . .
	jp z,l2df4h		;2bd0	ca f4 2d	. . -
	cp 004h			;2bd3	fe 04		. .
	jr c,l2be2h		;2bd5	38 0b		8 .
	jp z,l2d1bh		;2bd7	ca 1b 2d	. . -
	cp 006h			;2bda	fe 06		. .
	jp c,l2df5h		;2bdc	da f5 2d	. . -
	jp l2e13h		;2bdf	c3 13 2e	. . .
l2be2h:
	ld h,(ix+002h)		;2be2	dd 66 02	. f .
	ld l,(ix+001h)		;2be5	dd 6e 01	. n .
	push hl			;2be8	e5		.
	pop iy			;2be9	fd e1		. .
	ld a,000h		;2beb	3e 00		> .
	ld (ix+003h),a		;2bed	dd 77 03	. w .
	ld a,(iy+00dh)		;2bf0	fd 7e 0d	. ~ .
	or a			;2bf3	b7		.
	jp nz,l2e13h		;2bf4	c2 13 2e	. . .
	ld hl,l311fh		;2bf7	21 1f 31	! . 1
	ld d,(iy+00fh)		;2bfa	fd 56 0f	. V .
	ld e,(iy+00eh)		;2bfd	fd 5e 0e	. ^ .
	call sub_0f20h		;2c00	cd 20 0f	.   .
	jr nz,l2c0fh		;2c03	20 0a		  .
	ld a,(iy+001h)		;2c05	fd 7e 01	. ~ .
	or a			;2c08	b7		.
	jp z,l2e0eh		;2c09	ca 0e 2e	. . .
	jp l2e13h		;2c0c	c3 13 2e	. . .
l2c0fh:
	ld h,(iy+00fh)		;2c0f	fd 66 0f	. f .
	ld l,(iy+00eh)		;2c12	fd 6e 0e	. n .
	ld de,00028h		;2c15	11 28 00	. ( .
	add hl,de		;2c18	19		.
	ld a,(iy+011h)		;2c19	fd 7e 11	. ~ .
	cp 008h			;2c1c	fe 08		. .
	jr c,l2c62h		;2c1e	38 42		8 B
	ld a,(iy+010h)		;2c20	fd 7e 10	. ~ .
	call sub_0f26h		;2c23	cd 26 0f	. & .
	ld (iy+010h),a		;2c26	fd 77 10	. w .
	bit 1,(hl)		;2c29	cb 4e		. N
	jp z,l2c92h		;2c2b	ca 92 2c	. . ,
l2c2eh:
	ld a,001h		;2c2e	3e 01		> .
	ld (iy+011h),a		;2c30	fd 77 11	. w .
	ld bc,18		;2c33	01 12 00	. . .
	add hl,bc		;2c36	09		.
	ld (iy+015h),h		;2c37	fd 74 15	. t .
	ld (iy+014h),l		;2c3a	fd 75 14	. u .
	ld a,(hl)		;2c3d	7e		~
	ld bc,30		;2c3e	01 1e 00	. . .
	add hl,bc		;2c41	09		.
l2c42h:
	ld (iy+00fh),h		;2c42	fd 74 0f	. t .
	ld (iy+00eh),l		;2c45	fd 75 0e	. u .
	call sub_2c54h		;2c48	cd 54 2c	. T ,
	call sub_2d02h		;2c4b	cd 02 2d	. . -
	or a			;2c4e	b7		.
	jr z,l2c0fh		;2c4f	28 be		( .
	jp l2e13h		;2c51	c3 13 2e	. . .
sub_2c54h:
	and 007h		;2c54	e6 07		. .
	ld c,a			;2c56	4f		O
	ld b,000h		;2c57	06 00		. .
	ld hl,l22e1h		;2c59	21 e1 22	! . "
	add hl,bc		;2c5c	09		.
	ld a,(hl)		;2c5d	7e		~
	ld (iy+00dh),a		;2c5e	fd 77 0d	. w .
	ret			;2c61	c9		.
l2c62h:
	inc (iy+011h)		;2c62	fd 34 11	. 4 .
	ld a,(iy+010h)		;2c65	fd 7e 10	. ~ .
	call SOMETHING_MEM	;2c68	cd 1a 0f	. . .
	push hl			;2c6b	e5		.
	ld h,(iy+015h)		;2c6c	fd 66 15	. f .
	ld l,(iy+014h)		;2c6f	fd 6e 14	. n .
	ld c,004h		;2c72	0e 04		. .
	add hl,bc		;2c74	09		.
	ld a,(hl)		;2c75	7e		~
	ld (iy+015h),h		;2c76	fd 74 15	. t .
	ld (iy+014h),l		;2c79	fd 75 14	. u .
	pop hl			;2c7c	e1		.
	jr l2c42h		;2c7d	18 c3		. .
l2c7fh:
	ld hl,l311fh		;2c7f	21 1f 31	! . 1
	ld (iy+00fh),h		;2c82	fd 74 0f	. t .
	ld (iy+00eh),l		;2c85	fd 75 0e	. u .
	ld a,(iy+009h)		;2c88	fd 7e 09	. ~ .
	inc a			;2c8b	3c		<
	ld (iy+00dh),a		;2c8c	fd 77 0d	. w .
	jp l2e13h		;2c8f	c3 13 2e	. . .
l2c92h:
	ld a,(05fd5h)		;2c92	3a d5 5f	: . _
	or a			;2c95	b7		.
	jr z,l2c7fh		;2c96	28 e7		( .
	call sub_2e3ah		;2c98	cd 3a 2e	. : .
	jr z,l2c7fh		;2c9b	28 e2		( .
	ld c,b			;2c9d	48		H
	ld b,003h		;2c9e	06 03		. .
	ld hl,0603ah		;2ca0	21 3a 60	! : `
l2ca3h:
	ld a,(hl)		;2ca3	7e		~
	cp c			;2ca4	b9		.
	jr nz,l2cb3h		;2ca5	20 0c		  .
	inc hl			;2ca7	23		#
	ld a,(hl)		;2ca8	7e		~
	cp e			;2ca9	bb		.
	jr nz,l2cb4h		;2caa	20 08		  .
	inc hl			;2cac	23		#
	ld a,(hl)		;2cad	7e		~
	cp d			;2cae	ba		.
	jr nz,l2cb5h		;2caf	20 04		  .
	jr l2cc2h		;2cb1	18 0f		. .
l2cb3h:
	inc hl			;2cb3	23		#
l2cb4h:
	inc hl			;2cb4	23		#
l2cb5h:
	inc hl			;2cb5	23		#
	djnz l2ca3h		;2cb6	10 eb		. .
	push de			;2cb8	d5		.
	call sub_2e3ah		;2cb9	cd 3a 2e	. : .
	pop de			;2cbc	d1		.
	ld (hl),d		;2cbd	72		r
	dec hl			;2cbe	2b		+
	ld (hl),e		;2cbf	73		s
	jr l2c7fh		;2cc0	18 bd		. .
l2cc2h:
	ld a,003h		;2cc2	3e 03		> .
	sub b			;2cc4	90		.
	push af			;2cc5	f5		.
	ld a,c			;2cc6	79		y
	call SOMETHING_MEM	;2cc7	cd 1a 0f	. . .
	ld (iy+010h),a		;2cca	fd 77 10	. w .
	ex de,hl		;2ccd	eb		.
	res 7,(hl)		;2cce	cb be		. .
	push iy			;2cd0	fd e5		. .
	pop bc			;2cd2	c1		.
	inc bc			;2cd3	03		.
	inc bc			;2cd4	03		.
	inc bc			;2cd5	03		.
	inc bc			;2cd6	03		.
	ld (06050h),bc		;2cd7	ed 43 50 60	. C P `
	ld a,(06052h)		;2cdb	3a 52 60	: R `
	ld e,a			;2cde	5f		_
	pop af			;2cdf	f1		.
	inc a			;2ce0	3c		<
	cp 003h			;2ce1	fe 03		. .
	jr c,l2ce7h		;2ce3	38 02		8 .
	ld a,000h		;2ce5	3e 00		> .
l2ce7h:
	ld d,a			;2ce7	57		W
	ld a,(06049h)		;2ce8	3a 49 60	: I `
	cp d			;2ceb	ba		.
	jr nz,l2cfch		;2cec	20 0e		  .
	ld a,(06044h)		;2cee	3a 44 60	: D `
	cp 004h			;2cf1	fe 04		. .
	jr c,l2cf8h		;2cf3	38 03		8 .
	ld a,e			;2cf5	7b		{
	jr l2cfeh		;2cf6	18 06		. .
l2cf8h:
	ld a,e			;2cf8	7b		{
	dec a			;2cf9	3d		=
	jr l2cfeh		;2cfa	18 02		. .
l2cfch:
	ld a,e			;2cfc	7b		{
	inc a			;2cfd	3c		<
l2cfeh:
	ld (bc),a		;2cfe	02		.
	jp l2c2eh		;2cff	c3 2e 2c	. . ,
sub_2d02h:
	ld a,(iy+010h)		;2d02	fd 7e 10	. ~ .
	call SOMETHING_MEM	;2d05	cd 1a 0f	. . .
	ld a,020h		;2d08	3e 20		>  
	ld b,(iy+00dh)		;2d0a	fd 46 0d	. F .
	ld h,(iy+00fh)		;2d0d	fd 66 0f	. f .
	ld l,(iy+00eh)		;2d10	fd 6e 0e	. n .
l2d13h:
	cp (hl)			;2d13	be		.
	ret nz			;2d14	c0		.
	inc hl			;2d15	23		#
	djnz l2d13h		;2d16	10 fb		. .
	ld a,000h		;2d18	3e 00		> .
	ret			;2d1a	c9		.
l2d1bh:
	ld h,(ix+002h)		;2d1b	dd 66 02	. f .
	ld l,(ix+001h)		;2d1e	dd 6e 01	. n .
	push hl			;2d21	e5		.
	pop iy			;2d22	fd e1		. .
	ld (ix+003h),000h	;2d24	dd 36 03 00	. 6 . .
	ld a,(iy+008h)		;2d28	fd 7e 08	. ~ .
	or a			;2d2b	b7		.
	jp nz,l2e13h		;2d2c	c2 13 2e	. . .
	ld a,(iy+01ah)		;2d2f	fd 7e 1a	. ~ .
	call SOMETHING_MEM	;2d32	cd 1a 0f	. . .
	ld a,(iy+019h)		;2d35	fd 7e 19	. ~ .
	cp 00ah			;2d38	fe 0a		. .
	jp nc,l2de4h		;2d3a	d2 e4 2d	. . -
	cp 009h			;2d3d	fe 09		. .
	jp nz,l2d7ah		;2d3f	c2 7a 2d	. z -
	ld h,(iy+018h)		;2d42	fd 66 18	. f .
	ld l,(iy+017h)		;2d45	fd 6e 17	. n .
	ld a,(iy+01ah)		;2d48	fd 7e 1a	. ~ .
	call sub_0f26h		;2d4b	cd 26 0f	. & .
	ld (iy+01ah),a		;2d4e	fd 77 1a	. w .
	bit 1,(hl)		;2d51	cb 4e		. N
	jr nz,l2d5bh		;2d53	20 06		  .
	inc (iy+019h)		;2d55	fd 34 19	. 4 .
	jp l2e13h		;2d58	c3 13 2e	. . .
l2d5bh:
	ld (iy+019h),001h	;2d5b	fd 36 19 01	. 6 . .
	res 7,(iy+000h)		;2d5f	fd cb 00 be	. . . .
	ld de,16		;2d63	11 10 00	. . .
	add hl,de		;2d66	19		.
	ld (iy+016h),h		;2d67	fd 74 16	. t .
	ld (iy+015h),l		;2d6a	fd 75 15	. u .
	ld de,32		;2d6d	11 20 00	.   .
	add hl,de		;2d70	19		.
	ld (iy+018h),h		;2d71	fd 74 18	. t .
	ld (iy+017h),l		;2d74	fd 75 17	. u .
	jp l2e13h		;2d77	c3 13 2e	. . .
l2d7ah:
	ld a,(iy+01ah)		;2d7a	fd 7e 1a	. ~ .
	ld (iy+009h),a		;2d7d	fd 77 09	. w .
	ld h,(iy+018h)		;2d80	fd 66 18	. f .
	ld l,(iy+017h)		;2d83	fd 6e 17	. n .
	ld de,00028h		;2d86	11 28 00	. ( .
	ld (iy+00bh),h		;2d89	fd 74 0b	. t .
	ld (iy+00ah),l		;2d8c	fd 75 0a	. u .
	add hl,de		;2d8f	19		.
	ld (iy+018h),h		;2d90	fd 74 18	. t .
	ld (iy+017h),l		;2d93	fd 75 17	. u .
	ld h,(iy+016h)		;2d96	fd 66 16	. f .
	ld l,(iy+015h)		;2d99	fd 6e 15	. n .
	ld a,(hl)		;2d9c	7e		~
	ld (iy+00fh),a		;2d9d	fd 77 0f	. w .
	inc hl			;2da0	23		#
	ld a,(hl)		;2da1	7e		~
	rrca			;2da2	0f		.
	rrca			;2da3	0f		.
	rrca			;2da4	0f		.
	and 01fh		;2da5	e6 1f		. .
	ld (iy+01ch),a		;2da7	fd 77 1c	. w .
	ld a,(hl)		;2daa	7e		~
	push hl			;2dab	e5		.
	and 007h		;2dac	e6 07		. .
	ld (iy+00ch),a		;2dae	fd 77 0c	. w .
	add a,a			;2db1	87		.
	ld e,a			;2db2	5f		_
	ld d,000h		;2db3	16 00		. .
	ld hl,l0b65h		;2db5	21 65 0b	! e .
	add hl,de		;2db8	19		.
	ld e,(hl)		;2db9	5e		^
	inc hl			;2dba	23		#
	ld d,(hl)		;2dbb	56		V
	ld (iy+00eh),d		;2dbc	fd 72 0e	. r .
	ld (iy+00dh),e		;2dbf	fd 73 0d	. s .
	pop hl			;2dc2	e1		.
	inc hl			;2dc3	23		#
	ld a,(hl)		;2dc4	7e		~
	ld (iy+010h),a		;2dc5	fd 77 10	. w .
	inc hl			;2dc8	23		#
	ld a,(hl)		;2dc9	7e		~
	and 0c0h		;2dca	e6 c0		. .
	ld d,a			;2dcc	57		W
	ld a,(iy+01ch)		;2dcd	fd 7e 1c	. ~ .
	or d			;2dd0	b2		.
	ld (iy+01ch),a		;2dd1	fd 77 1c	. w .
	inc hl			;2dd4	23		#
	inc (iy+019h)		;2dd5	fd 34 19	. 4 .
	ld (iy+016h),h		;2dd8	fd 74 16	. t .
	ld (iy+015h),l		;2ddb	fd 75 15	. u .
	ld (iy+008h),001h	;2dde	fd 36 08 01	. 6 . .
	jr l2e13h		;2de2	18 2f		. /
l2de4h:
	bit 7,(iy+000h)		;2de4	fd cb 00 7e	. . . ~
	jr z,l2e13h		;2de8	28 29		( )
	ld (ix+000h),000h	;2dea	dd 36 00 00	. 6 . .
	ld (ix+003h),001h	;2dee	dd 36 03 01	. 6 . .
	jr l2e13h		;2df2	18 1f		. .
l2df4h:
	nop			;2df4	00		.
l2df5h:
	ld h,(ix+002h)		;2df5	dd 66 02	. f .
	ld l,(ix+001h)		;2df8	dd 6e 01	. n .
	push hl			;2dfb	e5		.
	pop iy			;2dfc	fd e1		. .
	ld (ix+003h),000h	;2dfe	dd 36 03 00	. 6 . .
	ld a,(iy+01dh)		;2e02	fd 7e 1d	. ~ .
	or a			;2e05	b7		.
	jr nz,l2e13h		;2e06	20 0b		  .
	ld (ix+000h),000h	;2e08	dd 36 00 00	. 6 . .
	jr l2e0eh		;2e0c	18 00		. .
l2e0eh:
	ld a,001h		;2e0e	3e 01		> .
	ld (ix+003h),a		;2e10	dd 77 03	. w .
l2e13h:
	ld a,(ix+003h)		;2e13	dd 7e 03	. ~ .
	or a			;2e16	b7		.
	ret z			;2e17	c8		.
	ld a,(05754h)		;2e18	3a 54 57	: T W
	ld d,000h		;2e1b	16 00		. .
	ld e,a			;2e1d	5f		_
	ld hl,053b4h		;2e1e	21 b4 53	! . S
	add hl,de		;2e21	19		.
	ld a,(hl)		;2e22	7e		~
	ld (05759h),hl		;2e23	22 59 57	" Y W
	or a			;2e26	b7		.
	jr z,l2e2fh		;2e27	28 06		( .
	ld a,000h		;2e29	3e 00		> .
	ld (ix+000h),a		;2e2b	dd 77 00	. w .
	ret			;2e2e	c9		.
l2e2fh:
	call sub_2e3ah		;2e2f	cd 3a 2e	. : .
	jr nz,l2e54h		;2e32	20 20		   
l2e34h:
	ld a,000h		;2e34	3e 00		> .
	ld (ix+000h),a		;2e36	dd 77 00	. w .
	ret			;2e39	c9		.
sub_2e3ah:
	ld de,00027h		;2e3a	11 27 00	. ' .
	ld hl,052a4h		;2e3d	21 a4 52	! . R
	ld a,(05754h)		;2e40	3a 54 57	: T W
	ld b,a			;2e43	47		G
l2e44h:
	add hl,de		;2e44	19		.
	djnz l2e44h		;2e45	10 fd		. .
	ld b,(hl)		;2e47	46		F
	inc hl			;2e48	23		#
	inc hl			;2e49	23		#
	ld e,(hl)		;2e4a	5e		^
	ld (hl),000h		;2e4b	36 00		6 .
	inc hl			;2e4d	23		#
	ld a,(hl)		;2e4e	7e		~
	ld (hl),000h		;2e4f	36 00		6 .
	ld d,a			;2e51	57		W
	or e			;2e52	b3		.
	ret			;2e53	c9		.
l2e54h:
	ld a,b			;2e54	78		x
	call SOMETHING_MEM	;2e55	cd 1a 0f	. . .
	ld a,(de)		;2e58	1a		.
	bit 0,a			;2e59	cb 47		. G
	jr nz,l2e34h		;2e5b	20 d7		  .
	res 7,a			;2e5d	cb bf		. .
	ld (de),a		;2e5f	12		.
	ld (05b6bh),de		;2e60	ed 53 6b 5b	. S k [
	ld hl,12		;2e64	21 0c 00	! . .
	add hl,de		;2e67	19		.
	ld a,(hl)		;2e68	7e		~
	call sub_16eeh		;2e69	cd ee 16	. . .
	dec hl			;2e6c	2b		+
	dec hl			;2e6d	2b		+
	ld a,(hl)		;2e6e	7e		~
	or a			;2e6f	b7		.
	call nz,09474h		;2e70	c4 74 94	. t .
	inc de			;2e73	13		.
	ld hl,(05759h)		;2e74	2a 59 57	* Y W
	ld a,(de)		;2e77	1a		.
	ld (hl),a		;2e78	77		w
	ex de,hl		;2e79	eb		.
	inc hl			;2e7a	23		#
	inc hl			;2e7b	23		#
	ld a,(hl)		;2e7c	7e		~
	cp 002h			;2e7d	fe 02		. .
	jr c,l2e93h		;2e7f	38 12		8 .
	jp z,l2f5fh		;2e81	ca 5f 2f	. _ /
	cp 004h			;2e84	fe 04		. .
	jp c,l3016h		;2e86	da 16 30	. . 0
	jr z,l2eaah		;2e89	28 1f		( .
	cp 006h			;2e8b	fe 06		. .
	jp c,l2f80h		;2e8d	da 80 2f	. . /
	jp l311eh		;2e90	c3 1e 31	. . 1
l2e93h:
	call sub_30f6h		;2e93	cd f6 30	. . 0
	ld (iy+01dh),001h	;2e96	fd 36 1d 01	. 6 . .
	ld a,(05754h)		;2e9a	3a 54 57	: T W
	ld c,a			;2e9d	4f		O
	ld b,000h		;2e9e	06 00		. .
	ld de,(05b6bh)		;2ea0	ed 5b 6b 5b	. [ k [
	ld a,001h		;2ea4	3e 01		> .
	call sub_09fbh		;2ea6	cd fb 09	. . .
	ret			;2ea9	c9		.
l2eaah:
	call sub_30f6h		;2eaa	cd f6 30	. . 0
	ld (ix+000h),004h	;2ead	dd 36 00 04	. 6 . .
	ld hl,04114h		;2eb1	21 14 41	! . A
	call sub_0db5h		;2eb4	cd b5 0d	. . .
	ld (iy+002h),d		;2eb7	fd 72 02	. r .
	ld (iy+001h),e		;2eba	fd 73 01	. s .
	ld hl,04108h		;2ebd	21 08 41	! . A
	add hl,bc		;2ec0	09		.
	ld b,(hl)		;2ec1	46		F
	ld hl,0ffcfh		;2ec2	21 cf ff	! . .
	ld de,l0043h		;2ec5	11 43 00	. C .
l2ec8h:
	add hl,de		;2ec8	19		.
	djnz l2ec8h		;2ec9	10 fd		. .
	ld (iy+004h),h		;2ecb	fd 74 04	. t .
	ld (iy+003h),l		;2ece	fd 75 03	. u .
	set 0,(iy+005h)		;2ed1	fd cb 05 c6	. . . .
	set 1,(iy+005h)		;2ed5	fd cb 05 ce	. . . .
	ld hl,(05b6bh)		;2ed9	2a 6b 5b	* k [
	inc hl			;2edc	23		#
	inc hl			;2edd	23		#
	ld a,(hl)		;2ede	7e		~
	ld (iy+006h),a		;2edf	fd 77 06	. w .
	ld de,14		;2ee2	11 0e 00	. . .
	add hl,de		;2ee5	19		.
	ld a,(hl)		;2ee6	7e		~
	ld (iy+014h),a		;2ee7	fd 77 14	. w .
	inc hl			;2eea	23		#
	ld a,(hl)		;2eeb	7e		~
	rrca			;2eec	0f		.
	rrca			;2eed	0f		.
	rrca			;2eee	0f		.
	and 01fh		;2eef	e6 1f		. .
	ld (iy+01bh),a		;2ef1	fd 77 1b	. w .
	dec hl			;2ef4	2b		+
	push hl			;2ef5	e5		.
	ld de,32		;2ef6	11 20 00	.   .
	add hl,de		;2ef9	19		.
	push hl			;2efa	e5		.
	ld h,(iy+002h)		;2efb	fd 66 02	. f .
	ld l,(iy+001h)		;2efe	fd 6e 01	. n .
	ld d,(iy+004h)		;2f01	fd 56 04	. V .
	ld e,(iy+003h)		;2f04	fd 5e 03	. ^ .
	add hl,de		;2f07	19		.
	ld de,0x31		;2f08	11 31 00	. 1 .
	add hl,de		;2f0b	19		.
	pop de			;2f0c	d1		.
	ld bc,00028h		;2f0d	01 28 00	. ( .
	ex de,hl		;2f10	eb		.
	ldir			;2f11	ed b0		. .
	ld (iy+018h),h		;2f13	fd 74 18	. t .
	ld (iy+017h),l		;2f16	fd 75 17	. u .
	ex de,hl		;2f19	eb		.
	pop de			;2f1a	d1		.
	inc de			;2f1b	13		.
	ld a,(de)		;2f1c	1a		.
	ld b,a			;2f1d	47		G
	inc de			;2f1e	13		.
	ld a,(de)		;2f1f	1a		.
	ld (hl),038h		;2f20	36 38		6 8
	inc hl			;2f22	23		#
	ld (hl),a		;2f23	77		w
	inc hl			;2f24	23		#
	inc de			;2f25	13		.
	ld a,(de)		;2f26	1a		.
	or 03fh			;2f27	f6 3f		. ?
	ld (hl),a		;2f29	77		w
	inc de			;2f2a	13		.
	ld (iy+016h),d		;2f2b	fd 72 16	. r .
	ld (iy+015h),e		;2f2e	fd 73 15	. s .
	ld (iy+019h),002h	;2f31	fd 36 19 02	. 6 . .
	ld a,b			;2f35	78		x
	and 007h		;2f36	e6 07		. .
	ld (iy+013h),a		;2f38	fd 77 13	. w .
	add a,a			;2f3b	87		.
	ld hl,l0b65h		;2f3c	21 65 0b	! e .
	ld e,a			;2f3f	5f		_
	ld d,000h		;2f40	16 00		. .
	add hl,de		;2f42	19		.
	ld e,(hl)		;2f43	5e		^
	inc hl			;2f44	23		#
	ld d,(hl)		;2f45	56		V
	ld (iy+012h),d		;2f46	fd 72 12	. r .
	ld (iy+011h),e		;2f49	fd 73 11	. s .
	ld (iy+008h),000h	;2f4c	fd 36 08 00	. 6 . .
	ld a,(CUR_MAP)		;2f50	3a 22 41	: " A
	ld (iy+01ah),a		;2f53	fd 77 1a	. w .
	ld (iy+000h),001h	;2f56	fd 36 00 01	. 6 . .
	ld (iy+01dh),004h	;2f5a	fd 36 1d 04	. 6 . .
	ret			;2f5e	c9		.
l2f5fh:
	call sub_30f6h		;2f5f	cd f6 30	. . 0
	ld a,002h		;2f62	3e 02		> .
	ld (ix+000h),a		;2f64	dd 77 00	. w .
	ld (iy+01dh),000h	;2f67	fd 36 1d 00	. 6 . .
	push af			;2f6b	f5		.
	ld hl,(05b6bh)		;2f6c	2a 6b 5b	* k [
	inc hl			;2f6f	23		#
	inc hl			;2f70	23		#
	ld a,(hl)		;2f71	7e		~
	ld b,00ah		;2f72	06 0a		. .
	cp 010h			;2f74	fe 10		. .
	jr z,l2f9fh		;2f76	28 27		( '
	ld b,003h		;2f78	06 03		. .
	jr nc,l2f9fh		;2f7a	30 23		0 #
	ld b,012h		;2f7c	06 12		. .
	jr l2f9fh		;2f7e	18 1f		. .
l2f80h:
	call sub_30f6h		;2f80	cd f6 30	. . 0
	ld a,005h		;2f83	3e 05		> .
	ld (ix+000h),a		;2f85	dd 77 00	. w .
	ld (iy+01dh),000h	;2f88	fd 36 1d 00	. 6 . .
	push af			;2f8c	f5		.
	ld hl,(05b6bh)		;2f8d	2a 6b 5b	* k [
	inc hl			;2f90	23		#
	inc hl			;2f91	23		#
	ld a,(hl)		;2f92	7e		~
	ld b,003h		;2f93	06 03		. .
	cp 010h			;2f95	fe 10		. .
	jr z,l2f9fh		;2f97	28 06		( .
	ld b,001h		;2f99	06 01		. .
	jr nc,l2f9fh		;2f9b	30 02		0 .
	ld b,006h		;2f9d	06 06		. .
l2f9fh:
	ld (iy+000h),b		;2f9f	fd 70 00	. p .
	ld (iy+009h),b		;2fa2	fd 70 09	. p .
	ld de,16		;2fa5	11 10 00	. . .
	add hl,de		;2fa8	19		.
	ld a,(hl)		;2fa9	7e		~
	ld de,30		;2faa	11 1e 00	. . .
	add hl,de		;2fad	19		.
	ld (iy+002h),h		;2fae	fd 74 02	. t .
	ld (iy+001h),l		;2fb1	fd 75 01	. u .
	bit 3,a			;2fb4	cb 5f		. _
	jr nz,l2fbch		;2fb6	20 04		  .
	ld a,028h		;2fb8	3e 28		> (
	jr l2fc6h		;2fba	18 0a		. .
l2fbch:
	and 007h		;2fbc	e6 07		. .
	ld c,a			;2fbe	4f		O
	ld b,000h		;2fbf	06 00		. .
	ld hl,l22e1h		;2fc1	21 e1 22	! . "
	add hl,bc		;2fc4	09		.
	ld a,(hl)		;2fc5	7e		~
l2fc6h:
	ld (iy+006h),a		;2fc6	fd 77 06	. w .
	ld (iy+007h),a		;2fc9	fd 77 07	. w .
	ld (iy+005h),008h	;2fcc	fd 36 05 08	. 6 . .
	ld hl,04114h		;2fd0	21 14 41	! . A
	ld a,(05754h)		;2fd3	3a 54 57	: T W
	ld c,a			;2fd6	4f		O
	ld b,000h		;2fd7	06 00		. .
	call sub_0db5h		;2fd9	cd b5 0d	. . .
	inc de			;2fdc	13		.
	inc de			;2fdd	13		.
	inc de			;2fde	13		.
	ld (iy+004h),d		;2fdf	fd 72 04	. r .
	ld (iy+003h),e		;2fe2	fd 73 03	. s .
	ld hl,04108h		;2fe5	21 08 41	! . A
	add hl,bc		;2fe8	09		.
	ld a,(hl)		;2fe9	7e		~
	ld (iy+008h),a		;2fea	fd 77 08	. w .
	ld a,(CUR_MAP)		;2fed	3a 22 41	: " A
	ld (iy+00ah),a		;2ff0	fd 77 0a	. w .
	ld hl,0575bh		;2ff3	21 5b 57	! [ W
	ld de,0575ch		;2ff6	11 5c 57	. \ W
	ld bc,l040fh		;2ff9	01 0f 04	. . .
	ld (hl),020h		;2ffc	36 20		6  
	ldir			;2ffe	ed b0		. .
l3000h:
	ld a,(05754h)		;3000	3a 54 57	: T W
	ld c,a			;3003	4f		O
	ld de,(05b6bh)		;3004	ed 5b 6b 5b	. [ k [
	ld a,002h		;3008	3e 02		> .
	push iy			;300a	fd e5		. .
	call sub_09fbh		;300c	cd fb 09	. . .
	pop iy			;300f	fd e1		. .
	pop af			;3011	f1		.
	ld (iy+01dh),a		;3012	fd 77 1d	. w .
	ret			;3015	c9		.
l3016h:
	ld hl,0575bh		;3016	21 5b 57	! [ W
	ld de,0575ch		;3019	11 5c 57	. \ W
l301ch:
	ld bc,l040fh		;301c	01 0f 04	. . .
	ld (hl),020h		;301f	36 20		6  
	ldir			;3021	ed b0		. .
	ld hl,04114h		;3023	21 14 41	! . A
	ld a,(05754h)		;3026	3a 54 57	: T W
	ld c,a			;3029	4f		O
	ld b,000h		;302a	06 00		. .
	call sub_0db5h		;302c	cd b5 0d	. . .
	ld hl,04108h		;302f	21 08 41	! . A
	add hl,bc		;3032	09		.
	ld a,(hl)		;3033	7e		~
	ld b,a			;3034	47		G
	ex de,hl		;3035	eb		.
	ld de,0575bh		;3036	11 5b 57	. [ W
l3039h:
	push bc			;3039	c5		.
	ld a,(hl)		;303a	7e		~
	bit 5,a			;303b	cb 6f		. o
	jr z,l3049h		;303d	28 0a		( .
	ld bc,00028h		;303f	01 28 00	. ( .
	push hl			;3042	e5		.
	inc hl			;3043	23		#
	inc hl			;3044	23		#
	inc hl			;3045	23		#
	ldir			;3046	ed b0		. .
	pop hl			;3048	e1		.
l3049h:
	ld bc,l0043h		;3049	01 43 00	. C .
	add hl,bc		;304c	09		.
	pop bc			;304d	c1		.
	djnz l3039h		;304e	10 e9		. .
	ld a,(05754h)		;3050	3a 54 57	: T W
	ld c,a			;3053	4f		O
	ld b,000h		;3054	06 00		. .
	ld de,(05b6bh)		;3056	ed 5b 6b 5b	. [ k [
	ld hl,18		;305a	21 12 00	! . .
	add hl,de		;305d	19		.
	set 3,(hl)		;305e	cb de		. .
	ld a,002h		;3060	3e 02		> .
	push ix			;3062	dd e5		. .
	call sub_09fbh		;3064	cd fb 09	. . .
	pop ix			;3067	dd e1		. .
	call sub_30f6h		;3069	cd f6 30	. . 0
	ld (ix+000h),003h	;306c	dd 36 00 03	. 6 . .
	ld hl,04114h		;3070	21 14 41	! . A
	call sub_0db5h		;3073	cd b5 0d	. . .
	ld hl,3		;3076	21 03 00	! . .
	add hl,de		;3079	19		.
	ld (iy+007h),l		;307a	fd 75 07	. u .
	ld (iy+008h),h		;307d	fd 74 08	. t .
	ld de,00028h		;3080	11 28 00	. ( .
	add hl,de		;3083	19		.
	ld (iy+003h),h		;3084	fd 74 03	. t .
	ld (iy+002h),l		;3087	fd 75 02	. u .
	ld hl,(05b6bh)		;308a	2a 6b 5b	* k [
	inc hl			;308d	23		#
	inc hl			;308e	23		#
	ld a,(hl)		;308f	7e		~
	cp 010h			;3090	fe 10		. .
	jr nz,l3098h		;3092	20 04		  .
	ld a,003h		;3094	3e 03		> .
	jr l30a9h		;3096	18 11		. .
l3098h:
	jr nc,l309eh		;3098	30 04		0 .
	ld a,002h		;309a	3e 02		> .
	jr l30a9h		;309c	18 0b		. .
l309eh:
	ld a,(l003dh)		;309e	3a 3d 00	: = .
	bit 2,a			;30a1	cb 57		. W
	ld a,005h		;30a3	3e 05		> .
	jr z,l30a9h		;30a5	28 02		( .
	ld a,004h		;30a7	3e 04		> .
l30a9h:
	ld (iy+004h),a		;30a9	fd 77 04	. w .
	ld de,16		;30ac	11 10 00	. . .
	add hl,de		;30af	19		.
	ld a,(hl)		;30b0	7e		~
	ld (iy+015h),h		;30b1	fd 74 15	. t .
	ld (iy+014h),l		;30b4	fd 75 14	. u .
	and 007h		;30b7	e6 07		. .
	push af			;30b9	f5		.
	add a,a			;30ba	87		.
	ld e,a			;30bb	5f		_
	ld d,000h		;30bc	16 00		. .
	ld hl,l310eh		;30be	21 0e 31	! . 1
	add hl,de		;30c1	19		.
	ld a,(hl)		;30c2	7e		~
	ld (iy+005h),a		;30c3	fd 77 05	. w .
	inc hl			;30c6	23		#
	ld a,(hl)		;30c7	7e		~
	ld (iy+006h),a		;30c8	fd 77 06	. w .
	pop af			;30cb	f1		.
	di			;30cc	f3		.
	call sub_2c54h		;30cd	cd 54 2c	. T ,
	dec a			;30d0	3d		=
	ld (iy+009h),a		;30d1	fd 77 09	. w .
	ld a,(CUR_MAP)		;30d4	3a 22 41	: " A
	ld (iy+010h),a		;30d7	fd 77 10	. w .
	ld hl,(05b6bh)		;30da	2a 6b 5b	* k [
	ld de,0x30		;30dd	11 30 00	. 0 .
	add hl,de		;30e0	19		.
	ld (iy+00fh),h		;30e1	fd 74 0f	. t .
	ld (iy+00eh),l		;30e4	fd 75 0e	. u .
	ld a,001h		;30e7	3e 01		> .
	ld (iy+011h),a		;30e9	fd 77 11	. w .
	ld (iy+001h),000h	;30ec	fd 36 01 00	. 6 . .
	ld (iy+01dh),003h	;30f0	fd 36 1d 03	. 6 . .
	ei			;30f4	fb		.
	ret			;30f5	c9		.
sub_30f6h:
	ld a,(05754h)		;30f6	3a 54 57	: T W
	ld b,a			;30f9	47		G
	ld c,a			;30fa	4f		O
	ld hl,0566ah		;30fb	21 6a 56	! j V
	ld de,30		;30fe	11 1e 00	. . .
l3101h:
	add hl,de		;3101	19		.
	djnz l3101h		;3102	10 fd		. .
	ld (ix+002h),h		;3104	dd 74 02	. t .
	ld (ix+001h),l		;3107	dd 75 01	. u .
	push hl			;310a	e5		.
	pop iy			;310b	fd e1		. .
	ret			;310d	c9		.
l310eh:
	jr z,$+58		;310e	28 38		( 8
	inc h			;3110	24		$
	jr c,$+33		;3111	38 1f		8 .
	jr c,l312dh		;3113	38 18		8 .
	jr c,l3127h		;3115	38 10		8 .
	jr c,l311ch		;3117	38 03		8 .
	jr c,l311eh		;3119	38 03		8 .
	ld b,e			;311b	43		C
l311ch:
	inc bc			;311c	03		.
	ld d,e			;311d	53		S
l311eh:
	ret			;311e	c9		.
l311fh:
	jr nz,l3141h		;311f	20 20		   
l3121h:
	jr nz,l3143h		;3121	20 20		   
	jr nz,l3145h		;3123	20 20		   
	jr nz,l3147h		;3125	20 20		   
l3127h:
	jr nz,$+34		;3127	20 20		   
	jr nz,$+34		;3129	20 20		   
	jr nz,l314dh		;312b	20 20		   
l312dh:
	jr nz,$+34		;312d	20 20		   
	jr nz,l3151h		;312f	20 20		   
	jr nz,$+34		;3131	20 20		   
	jr nz,l3155h		;3133	20 20		   
	jr nz,$+34		;3135	20 20		   
	jr nz,l3159h		;3137	20 20		   
	jr nz,$+34		;3139	20 20		   
	jr nz,$+34		;313b	20 20		   
	jr nz,l315fh		;313d	20 20		   
	jr nz,$+34		;313f	20 20		   
l3141h:
	jr nz,$+34		;3141	20 20		   
l3143h:
	jr nz,l3165h		;3143	20 20		   
l3145h:
	jr nz,$+34		;3145	20 20		   
l3147h:
	ld sp,0511dh		;3147	31 1d 51	1 . Q
	ld hl,l3147h		;314a	21 47 31	! G 1
l314dh:
	push hl			;314d	e5		.
	ld a,(052bfh)		;314e	3a bf 52	: . R
l3151h:
	ld b,a			;3151	47		G
	ld a,(052c0h)		;3152	3a c0 52	: . R
l3155h:
	cp b			;3155	b8		.
	jr nz,l3185h		;3156	20 2d		  -
	xor a			;3158	af		.
l3159h:
	call SOMETHING_MEM	;3159	cd 1a 0f	. . .
	call 0c86ch		;315c	cd 6c c8	. l .
l315fh:
	call 0a0c6h		;315f	cd c6 a0	. . .
	call 0a47bh		;3162	cd 7b a4	. { .
l3165h:
	call 0a683h		;3165	cd 83 a6	. . .
	call 0a82ah		;3168	cd 2a a8	. * .
	call 09413h		;316b	cd 13 94	. . .
	ld a,(05b7bh)		;316e	3a 7b 5b	: { [
	and 001h		;3171	e6 01		. .
	call nz,09d2dh		;3173	c4 2d 9d	. - .
	call 094b5h		;3176	cd b5 94	. . .
	call sub_33dch		;3179	cd dc 33	. . 3
	call sub_33ffh		;317c	cd ff 33	. . 3
	call sub_3496h		;317f	cd 96 34	. . 4
	jp sub_0334h		;3182	c3 34 03	. 4 .
l3185h:
	inc a			;3185	3c		<
	ld (052c0h),a		;3186	32 c0 52	2 . R
	ld b,032h		;3189	06 32		. 2
	ld a,(l0007h)		;318b	3a 07 00	: . .
	cp 0aah			;318e	fe aa		. .
	jr z,l31afh		;3190	28 1d		( .
	ld hl,(052c2h)		;3192	2a c2 52	* . R
	dec hl			;3195	2b		+
	ld a,l			;3196	7d		}
	or h			;3197	b4		.
	jr nz,l31aah		;3198	20 10		  .
	ld hl,003e7h		;319a	21 e7 03	! . .
	ld a,(052c1h)		;319d	3a c1 52	: . R
	dec a			;31a0	3d		=
	jr nz,l31a7h		;31a1	20 04		  .
	ld b,03bh		;31a3	06 3b		. ;
	jr l31ach		;31a5	18 05		. .
l31a7h:
	ld (052c1h),a		;31a7	32 c1 52	2 . R
l31aah:
	ld b,03ch		;31aa	06 3c		. <
l31ach:
	ld (052c2h),hl		;31ac	22 c2 52	" . R
l31afh:
	ld a,(052c1h)		;31af	3a c1 52	: . R
	dec a			;31b2	3d		=
	ld (052c1h),a		;31b3	32 c1 52	2 . R
	ld a,(l003ch)		;31b6	3a 3c 00	: < .
	cp 0bbh			;31b9	fe bb		. .
	jr nz,l31c1h		;31bb	20 04		  .
	in a,(030h)		;31bd	db 30		. 0
	jr l31c3h		;31bf	18 02		. .
l31c1h:
	in a,(020h)		;31c1	db 20		.  
l31c3h:
	ld a,(l000dh)		;31c3	3a 0d 00	: . .
	cp 0aah			;31c6	fe aa		. .
	jr nz,l31d5h		;31c8	20 0b		  .
	ld a,(05bafh)		;31ca	3a af 5b	: . [
l31cdh:
	and a			;31cd	a7		.
	ret z			;31ce	c8		.
	dec a			;31cf	3d		=
	ld (05bafh),a		;31d0	32 af 5b	2 . [
	jr l31dah		;31d3	18 05		. .
l31d5h:
	ld a,(052c1h)		;31d5	3a c1 52	: . R
	and a			;31d8	a7		.
	ret nz			;31d9	c0		.
l31dah:
	call sub_32d1h		;31da	cd d1 32	. . 2
	xor a			;31dd	af		.
	ld hl,05ea7h		;31de	21 a7 5e	! . ^
	cp (hl)			;31e1	be		.
	jr z,l31e5h		;31e2	28 01		( .
	dec (hl)		;31e4	35		5
l31e5h:
	ld hl,05ea8h		;31e5	21 a8 5e	! . ^
	cp (hl)			;31e8	be		.
	jr z,l31ech		;31e9	28 01		( .
	dec (hl)		;31eb	35		5
l31ech:
	ld hl,06029h		;31ec	21 29 60	! ) `
	cp (hl)			;31ef	be		.
	jr z,l31f3h		;31f0	28 01		( .
	dec (hl)		;31f2	35		5
l31f3h:
	ld a,(05b7bh)		;31f3	3a 7b 5b	: { [
	and 001h		;31f6	e6 01		. .
	jp z,l3248h		;31f8	ca 48 32	. H 2
	ld hl,06054h		;31fb	21 54 60	! T `
	ld a,(hl)		;31fe	7e		~
	cp 0ffh			;31ff	fe ff		. .
	jr z,l3204h		;3201	28 01		( .
	inc (hl)		;3203	34		4
l3204h:
	ld a,(060cch)		;3204	3a cc 60	: . `
	or a			;3207	b7		.
	jr z,l323fh		;3208	28 35		( 5
	cp 003h			;320a	fe 03		. .
	jr z,l3229h		;320c	28 1b		( .
	cp 002h			;320e	fe 02		. .
	jr z,l321ah		;3210	28 08		( .
	ld a,002h		;3212	3e 02		> .
	ld (060cch),a		;3214	32 cc 60	2 . `
	jp l3248h		;3217	c3 48 32	. H 2
l321ah:
	ld a,005h		;321a	3e 05		> .
	out (012h),a		;321c	d3 12		. .
	ld a,0a0h		;321e	3e a0		> .
	out (012h),a		;3220	d3 12		. .
	ld a,003h		;3222	3e 03		> .
	ld (060cch),a		;3224	32 cc 60	2 . `
	jr l3248h		;3227	18 1f		. .
l3229h:
	ld a,005h		;3229	3e 05		> .
	out (012h),a		;322b	d3 12		. .
	ld a,020h		;322d	3e 20		>  
	out (012h),a		;322f	d3 12		. .
	ld a,005h		;3231	3e 05		> .
	out (012h),a		;3233	d3 12		. .
	ld a,0a0h		;3235	3e a0		> .
	out (012h),a		;3237	d3 12		. .
	sub a			;3239	97		.
	ld (060cch),a		;323a	32 cc 60	2 . `
	jr l3248h		;323d	18 09		. .
l323fh:
	ld a,005h		;323f	3e 05		> .
	out (012h),a		;3241	d3 12		. .
	ld a,(060ceh)		;3243	3a ce 60	: . `
	out (012h),a		;3246	d3 12		. .
l3248h:
	ld hl,052c4h		;3248	21 c4 52	! . R
	inc (hl)		;324b	34		4
	ld a,b			;324c	78		x
	ld (052c1h),a		;324d	32 c1 52	2 . R
	call 0b2fbh		;3250	cd fb b2	. . .
	ld hl,(05b9bh)		;3253	2a 9b 5b	* . [
	ld a,l			;3256	7d		}
	or h			;3257	b4		.
	jp z,l328eh		;3258	ca 8e 32	. . 2
l325bh:
	push hl			;325b	e5		.
	call sub_07f9h		;325c	cd f9 07	. . .
	cp 0ffh			;325f	fe ff		. .
	jp z,l328dh		;3261	ca 8d 32	. . 2
	call SOMETHING_MEM	;3264	cd 1a 0f	. . .
	ld de,0x30		;3267	11 30 00	. 0 .
	add hl,de		;326a	19		.
	ld a,(l000dh)		;326b	3a 0d 00	: . .
	cp 0bbh			;326e	fe bb		. .
	jr nz,l3277h		;3270	20 05		  .
	call sub_3480h		;3272	cd 80 34	. . 4
	jr l3280h		;3275	18 09		. .
l3277h:
	ex de,hl		;3277	eb		.
	ld hl,055b7h		;3278	21 b7 55	! . U
	ld bc,32		;327b	01 20 00	.   .
	ldir			;327e	ed b0		. .
l3280h:
	pop de			;3280	d1		.
	inc de			;3281	13		.
	ld hl,(05b9dh)		;3282	2a 9d 5b	* . [
	or a			;3285	b7		.
	sbc hl,de		;3286	ed 52		. R
	ex de,hl		;3288	eb		.
	jr nc,l325bh		;3289	30 d0		0 .
	jr l328eh		;328b	18 01		. .
l328dh:
	pop hl			;328d	e1		.
l328eh:
	ld hl,(055e1h)		;328e	2a e1 55	* . U
	ld a,l			;3291	7d		}
	or h			;3292	b4		.
	jr z,l32bbh		;3293	28 26		( &
l3295h:
	push hl			;3295	e5		.
	call sub_07f9h		;3296	cd f9 07	. . .
	cp 0ffh			;3299	fe ff		. .
	jr z,l32bah		;329b	28 1d		( .
	call SOMETHING_MEM	;329d	cd 1a 0f	. . .
	ld de,0x30		;32a0	11 30 00	. 0 .
	add hl,de		;32a3	19		.
	ex de,hl		;32a4	eb		.
	ld hl,055e5h		;32a5	21 e5 55	! . U
	ld bc,000a0h		;32a8	01 a0 00	. . .
	ldir			;32ab	ed b0		. .
	pop de			;32ad	d1		.
	inc de			;32ae	13		.
l32afh:
	ld hl,(055e3h)		;32af	2a e3 55	* . U
	or a			;32b2	b7		.
	sbc hl,de		;32b3	ed 52		. R
	ex de,hl		;32b5	eb		.
	jr nc,l3295h		;32b6	30 dd		0 .
	jr l32bbh		;32b8	18 01		. .
l32bah:
	pop hl			;32ba	e1		.
l32bbh:
	ld hl,053b5h		;32bb	21 b5 53	! . S
	ld b,006h		;32be	06 06		. .
l32c0h:
	ld a,(hl)		;32c0	7e		~
	or a			;32c1	b7		.
	jr z,l32cdh		;32c2	28 09		( .
	cp 063h			;32c4	fe 63		. c
	jr z,l32cdh		;32c6	28 05		( .
	jr c,l32cch		;32c8	38 02		8 .
	ld (hl),010h		;32ca	36 10		6 .
l32cch:
	dec (hl)		;32cc	35		5
l32cdh:
	inc hl			;32cd	23		#
	djnz l32c0h		;32ce	10 f0		. .
	ret			;32d0	c9		.
sub_32d1h:
	ld a,(l003ch)		;32d1	3a 3c 00	: < .
	cp 0bbh			;32d4	fe bb		. .
	ret nz			;32d6	c0		.
	ld a,(04f79h)		;32d7	3a 79 4f	: y O
	bit 4,a			;32da	cb 67		. g
	jr nz,l32f9h		;32dc	20 1b		  .
	ld a,(060cfh)		;32de	3a cf 60	: . `
	cp 000h			;32e1	fe 00		. .
	ret z			;32e3	c8		.
	xor a			;32e4	af		.
	ld (060cfh),a		;32e5	32 cf 60	2 . `
	in a,(016h)		;32e8	db 16		. .
	and 018h		;32ea	e6 18		. .
	ret z			;32ec	c8		.
	ld hl,l32fdh		;32ed	21 fd 32	! . 2
	ld de,0415dh		;32f0	11 5d 41	. ] A
	ld bc,23		;32f3	01 17 00	. . .
	ldir			;32f6	ed b0		. .
	ret			;32f8	c9		.
l32f9h:
	ld (060cfh),a		;32f9	32 cf 60	2 . `
	ret			;32fc	c9		.
l32fdh:
	jr nz,$+89		;32fd	20 57		  W
	ld b,c			;32ff	41		A
	ld d,d			;3300	52		R
	ld c,(hl)		;3301	4e		N
	ld c,c			;3302	49		I
	ld c,(hl)		;3303	4e		N
	ld b,a			;3304	47		G
	jr nz,$+78		;3305	20 4c		  L
	ld c,a			;3307	4f		O
	ld d,a			;3308	57		W
	jr nz,l334dh		;3309	20 42		  B
	ld b,c			;330b	41		A
	ld d,h			;330c	54		T
	ld d,h			;330d	54		T
	ld b,l			;330e	45		E
	ld d,d			;330f	52		R
	ld c,c			;3310	49		I
	ld b,l			;3311	45		E
	ld d,e			;3312	53		S
	jr nz,$+64		;3313	20 3e		  >
	ld bc,l0606h		;3315	01 06 06	. . .
l3318h:
	call sub_332ah		;3318	cd 2a 33	. * 3
	inc a			;331b	3c		<
	djnz l3318h		;331c	10 fa		. .
	ret			;331e	c9		.
sub_331fh:
	ld a,001h		;331f	3e 01		> .
	ld b,006h		;3321	06 06		. .
l3323h:
	call sub_33a3h		;3323	cd a3 33	. . 3
	inc a			;3326	3c		<
	djnz l3323h		;3327	10 fa		. .
	ret			;3329	c9		.
sub_332ah:
	push af			;332a	f5		.
	dec a			;332b	3d		=
	cp 006h			;332c	fe 06		. .
	jp nc,l337fh		;332e	d2 7f 33	. . 3
	push hl			;3331	e5		.
	push de			;3332	d5		.
	push bc			;3333	c5		.
	ld d,000h		;3334	16 00		. .
	ld e,a			;3336	5f		_
	ld hl,053b5h		;3337	21 b5 53	! . S
	add hl,de		;333a	19		.
	ld (hl),000h		;333b	36 00		6 .
	add a,a			;333d	87		.
	add a,a			;333e	87		.
	push af			;333f	f5		.
	add a,a			;3340	87		.
	add a,a			;3341	87		.
	add a,a			;3342	87		.
	sub e			;3343	93		.
	sub e			;3344	93		.
	ld e,a			;3345	5f		_
	ld hl,05688h		;3346	21 88 56	! . V
	add hl,de		;3349	19		.
	push hl			;334a	e5		.
	pop iy			;334b	fd e1		. .
l334dh:
	ld a,(iy+01dh)		;334d	fd 7e 1d	. ~ .
	cp 004h			;3350	fe 04		. .
	jr nz,l3366h		;3352	20 12		  .
	ld a,(04f79h)		;3354	3a 79 4f	: y O
	bit 4,a			;3357	cb 67		. g
	jr z,l3366h		;3359	28 0b		( .
	ld (iy+008h),000h	;335b	fd 36 08 00	. 6 . .
	ld (iy+019h),00ah	;335f	fd 36 19 0a	. 6 . .
	pop af			;3363	f1		.
	jr l337ch		;3364	18 16		. .
l3366h:
	ld (hl),000h		;3366	36 00		6 .
	ld d,h			;3368	54		T
	ld e,l			;3369	5d		]
	inc de			;336a	13		.
	ld bc,29		;336b	01 1d 00	. . .
	di			;336e	f3		.
	ldir			;336f	ed b0		. .
	ei			;3371	fb		.
	pop af			;3372	f1		.
	ld d,000h		;3373	16 00		. .
	ld e,a			;3375	5f		_
	ld hl,0573ch		;3376	21 3c 57	! < W
	add hl,de		;3379	19		.
	ld (hl),000h		;337a	36 00		6 .
l337ch:
	pop bc			;337c	c1		.
	pop de			;337d	d1		.
	pop hl			;337e	e1		.
l337fh:
	pop af			;337f	f1		.
	ret			;3380	c9		.
sub_3381h:
	call sub_332ah		;3381	cd 2a 33	. * 3
	push af			;3384	f5		.
	or a			;3385	b7		.
	jr z,l33a1h		;3386	28 19		( .
	cp 007h			;3388	fe 07		. .
	jr nc,l33a1h		;338a	30 15		0 .
	push hl			;338c	e5		.
	push de			;338d	d5		.
	push bc			;338e	c5		.
	ld hl,052a6h		;338f	21 a6 52	! . R
	ld de,00027h		;3392	11 27 00	. ' .
	ld b,a			;3395	47		G
l3396h:
	add hl,de		;3396	19		.
	djnz l3396h		;3397	10 fd		. .
	ld (hl),000h		;3399	36 00		6 .
	inc hl			;339b	23		#
	ld (hl),000h		;339c	36 00		6 .
	pop bc			;339e	c1		.
	pop de			;339f	d1		.
	pop hl			;33a0	e1		.
l33a1h:
	pop af			;33a1	f1		.
	ret			;33a2	c9		.
sub_33a3h:
	push af			;33a3	f5		.
	or a			;33a4	b7		.
	jr z,l33d7h		;33a5	28 30		( 0
	cp 007h			;33a7	fe 07		. .
	jr nc,l33d7h		;33a9	30 2c		0 ,
	call sub_3381h		;33ab	cd 81 33	. . 3
l33aeh:
	push hl			;33ae	e5		.
	push de			;33af	d5		.
	push bc			;33b0	c5		.
	ld hl,052a8h		;33b1	21 a8 52	! . R
	ld de,00027h		;33b4	11 27 00	. ' .
	ld b,a			;33b7	47		G
l33b8h:
	add hl,de		;33b8	19		.
	djnz l33b8h		;33b9	10 fd		. .
	ld (hl),003h		;33bb	36 03		6 .
	inc hl			;33bd	23		#
	ld (hl),000h		;33be	36 00		6 .
	inc hl			;33c0	23		#
	ld (hl),000h		;33c1	36 00		6 .
	inc hl			;33c3	23		#
	ld b,004h		;33c4	06 04		. .
l33c6h:
	ld e,(hl)		;33c6	5e		^
	inc hl			;33c7	23		#
	ld d,(hl)		;33c8	56		V
	inc hl			;33c9	23		#
	inc hl			;33ca	23		#
	inc hl			;33cb	23		#
	inc hl			;33cc	23		#
	inc hl			;33cd	23		#
	ld (hl),e		;33ce	73		s
	inc hl			;33cf	23		#
	ld (hl),d		;33d0	72		r
	inc hl			;33d1	23		#
	djnz l33c6h		;33d2	10 f2		. .
	pop bc			;33d4	c1		.
	pop de			;33d5	d1		.
	pop hl			;33d6	e1		.
l33d7h:
	pop af			;33d7	f1		.
	ret			;33d8	c9		.
	push af			;33d9	f5		.
	jr l33aeh		;33da	18 d2		. .
sub_33dch:
	ld a,(l0006h)		;33dc	3a 06 00	: . .
	cp 0aah			;33df	fe aa		. .
	ret nz			;33e1	c0		.
	ld a,(04f79h)		;33e2	3a 79 4f	: y O
	ld b,a			;33e5	47		G
	ld a,(053bdh)		;33e6	3a bd 53	: . S
	bit 4,b			;33e9	cb 60		. `
	jr nz,l33f4h		;33eb	20 07		  .
	bit 3,a			;33ed	cb 5f		. _
	ret z			;33ef	c8		.
	res 3,a			;33f0	cb 9f		. .
	jr l33f9h		;33f2	18 05		. .
l33f4h:
	bit 3,a			;33f4	cb 5f		. _
	ret nz			;33f6	c0		.
	set 3,a			;33f7	cb df		. .
l33f9h:
	ld (053bdh),a		;33f9	32 bd 53	2 . S
	out (005h),a		;33fc	d3 05		. .
	ret			;33fe	c9		.
sub_33ffh:
	ld a,(l000ch)		;33ff	3a 0c 00	: . .
	cp 0aah			;3402	fe aa		. .
	ret z			;3404	c8		.
	ld a,(05fd6h)		;3405	3a d6 5f	: . _
	inc a			;3408	3c		<
	ld (05fd6h),a		;3409	32 d6 5f	2 . _
	cp 004h			;340c	fe 04		. .
	ret nz			;340e	c0		.
	ld a,000h		;340f	3e 00		> .
	ld (05fd6h),a		;3411	32 d6 5f	2 . _
	ld a,(05fd7h)		;3414	3a d7 5f	: . _
	ld b,a			;3417	47		G
	in a,(004h)		;3418	db 04		. .
	and 030h		;341a	e6 30		. 0
	cp b			;341c	b8		.
	ret z			;341d	c8		.
	ld (05fd7h),a		;341e	32 d7 5f	2 . _
	cp 030h			;3421	fe 30		. 0
	ret z			;3423	c8		.
	ld a,(05fd8h)		;3424	3a d8 5f	: . _
	or a			;3427	b7		.
	jr nz,l3446h		;3428	20 1c		  .
	ld a,(05fd7h)		;342a	3a d7 5f	: . _
	bit 4,a			;342d	cb 67		. g
	ret nz			;342f	c0		.
	ld hl,040e4h		;3430	21 e4 40	! . @
	ld a,0f9h		;3433	3e f9		> .
	call sub_0f09h		;3435	cd 09 0f	. . .
	ld hl,040e4h		;3438	21 e4 40	! . @
	ld a,09ah		;343b	3e 9a		> .
	call sub_0f09h		;343d	cd 09 0f	. . .
	ld a,001h		;3440	3e 01		> .
	ld (05fd8h),a		;3442	32 d8 5f	2 . _
	ret			;3445	c9		.
l3446h:
	ld hl,040e4h		;3446	21 e4 40	! . @
	ld a,(05fd7h)		;3449	3a d7 5f	: . _
	bit 5,a			;344c	cb 6f		. o
	jr nz,l3456h		;344e	20 06		  .
	ld a,020h		;3450	3e 20		>  
	call sub_0f09h		;3452	cd 09 0f	. . .
	ret			;3455	c9		.
l3456h:
	ld a,(05fd8h)		;3456	3a d8 5f	: . _
	inc a			;3459	3c		<
	ld (05fd8h),a		;345a	32 d8 5f	2 . _
	cp 009h			;345d	fe 09		. .
	jr z,l3467h		;345f	28 06		( .
	ld a,00ah		;3461	3e 0a		> .
	call sub_0f09h		;3463	cd 09 0f	. . .
	ret			;3466	c9		.
l3467h:
	ld a,000h		;3467	3e 00		> .
	ld (05fd8h),a		;3469	32 d8 5f	2 . _
	ld b,003h		;346c	06 03		. .
l346eh:
	ld a,00ah		;346e	3e 0a		> .
	push bc			;3470	c5		.
	call sub_0f09h		;3471	cd 09 0f	. . .
	pop bc			;3474	c1		.
	ld hl,040e4h		;3475	21 e4 40	! . @
	djnz l346eh		;3478	10 f4		. .
	ld a,0f8h		;347a	3e f8		> .
	call sub_0f09h		;347c	cd 09 0f	. . .
	ret			;347f	c9		.
sub_3480h:
	ld de,24		;3480	11 18 00	. . .
	add hl,de		;3483	19		.
	ex de,hl		;3484	eb		.
	ld hl,055cch		;3485	21 cc 55	! . U
	ld bc,5		;3488	01 05 00	. . .
	ldir			;348b	ed b0		. .
	ld hl,055d4h		;348d	21 d4 55	! . U
	ld bc,3		;3490	01 03 00	. . .
	ldir			;3493	ed b0		. .
	ret			;3495	c9		.
sub_3496h:
	ld a,(l003eh)		;3496	3a 3e 00	: > .
	cp 0aah			;3499	fe aa		. .
	jr nz,l34bdh		;349b	20 20		   
	ld a,(05b98h)		;349d	3a 98 5b	: . [
	cp 01eh			;34a0	fe 1e		. .
	jr nz,l34b6h		;34a2	20 12		  .
	ld a,(05b99h)		;34a4	3a 99 5b	: . [
	cp 000h			;34a7	fe 00		. .
	jr nz,l34b6h		;34a9	20 0b		  .
	ld a,(053bdh)		;34ab	3a bd 53	: . S
	res 2,a			;34ae	cb 97		. .
l34b0h:
	ld (053bdh),a		;34b0	32 bd 53	2 . S
	out (005h),a		;34b3	d3 05		. .
	ret			;34b5	c9		.
l34b6h:
	ld a,(053bdh)		;34b6	3a bd 53	: . S
	set 2,a			;34b9	cb d7		. .
	jr l34b0h		;34bb	18 f3		. .
l34bdh:
	cp 055h			;34bd	fe 55		. U
	ret nz			;34bf	c0		.
	ld a,(05baeh)		;34c0	3a ae 5b	: . [
	ld b,a			;34c3	47		G
	in a,(005h)		;34c4	db 05		. .
	and 020h		;34c6	e6 20		.  
	cp b			;34c8	b8		.
	ret z			;34c9	c8		.
	ld (05baeh),a		;34ca	32 ae 5b	2 . [
	and a			;34cd	a7		.
	ret nz			;34ce	c0		.
	ld a,01eh		;34cf	3e 1e		> .
	ld (05b98h),a		;34d1	32 98 5b	2 . [
	ld a,000h		;34d4	3e 00		> .
	ld (05b99h),a		;34d6	32 99 5b	2 . [
	ld a,03ch		;34d9	3e 3c		> <
	ld (052c1h),a		;34db	32 c1 52	2 . R
	call 0c5cbh		;34de	cd cb c5	. . .
	ret			;34e1	c9		.
	ld hl,04a3eh		;34e2	21 3e 4a	! > J
	ld de,053c2h		;34e5	11 c2 53	. . S
	ld bc,16		;34e8	01 10 00	. . .
	ldir			;34eb	ed b0		. .
	ld a,(04a48h)		;34ed	3a 48 4a	: H J
	ld hl,053d6h		;34f0	21 d6 53	! . S
	call 0b845h		;34f3	cd 45 b8	. E .
	call sub_2a82h		;34f6	cd 82 2a	. . *
	call sub_13c8h		;34f9	cd c8 13	. . .
	sbc a,e			;34fc	9b		.
	ret nc			;34fd	d0		.
	add a,0cdh		;34fe	c6 cd		. .
	daa			;3500	27		'
	dec d			;3501	15		.
	ld bc,0dd0fh		;3502	01 0f dd	. . .
	ld hl,053c2h		;3505	21 c2 53	! . S
	ld iy,0d161h		;3508	fd 21 61 d1	. ! a .
	ld c,00ah		;350c	0e 0a		. .
	ld b,(ix+003h)		;350e	dd 46 03	. F .
	dec b			;3511	05		.
	push bc			;3512	c5		.
	ld c,a			;3513	4f		O
	ld a,004h		;3514	3e 04		> .
	sub b			;3516	90		.
	ld a,c			;3517	79		y
	pop bc			;3518	c1		.
	jp nc,l3522h		;3519	d2 22 35	. " 5
	ld b,000h		;351c	06 00		. .
	ld (ix+003h),001h	;351e	dd 36 03 01	. 6 . .
l3522h:
	call 03b0ch		;3522	cd 0c 3b	. . ;
	call 01527h		;3525	cd 27 15	. ' .
	ld (bc),a		;3528	02		.
	rrca			;3529	0f		.
	ld a,(ix+002h)		;352a	dd 7e 02	. ~ .
	ld iy,0d183h		;352d	fd 21 83 d1	. ! . .
	ld c,006h		;3531	0e 06		. .
	push bc			;3533	c5		.
	ld c,a			;3534	4f		O
	ld a,008h		;3535	3e 08		> .
	ld b,a			;3537	47		G
	ld a,c			;3538	79		y
	sub b			;3539	90		.
	ld a,c			;353a	79		y
	pop bc			;353b	c1		.
	jp nz,l3544h		;353c	c2 44 35	. D 5
	ld b,000h		;353f	06 00		. .
	jp l355ch		;3541	c3 5c 35	. \ 5
l3544h:
	push bc			;3544	c5		.
	ld c,a			;3545	4f		O
	ld a,020h		;3546	3e 20		>  
	ld b,a			;3548	47		G
	ld a,c			;3549	79		y
	sub b			;354a	90		.
	ld a,c			;354b	79		y
	pop bc			;354c	c1		.
	jp nz,l3555h		;354d	c2 55 35	. U 5
	ld b,002h		;3550	06 02		. .
	jp l355ch		;3552	c3 5c 35	. \ 5
l3555h:
	ld b,001h		;3555	06 01		. .
	ld a,010h		;3557	3e 10		> .
	ld (ix+002h),a		;3559	dd 77 02	. w .
l355ch:
	call 03b0ch		;355c	cd 0c 3b	. . ;
	call 01527h		;355f	cd 27 15	. ' .
	inc bc			;3562	03		.
	rrca			;3563	0f		.
	push bc			;3564	c5		.
	ld c,a			;3565	4f		O
	ld a,(ix+001h)		;3566	dd 7e 01	. ~ .
	ld b,a			;3569	47		G
	ld a,063h		;356a	3e 63		> c
	sub b			;356c	90		.
	ld a,c			;356d	79		y
	pop bc			;356e	c1		.
	jp nc,l3576h		;356f	d2 76 35	. v 5
	ld (ix+001h),010h	;3572	dd 36 01 10	. 6 . .
l3576h:
	call sub_1431h		;3576	cd 31 14	. 1 .
	jp 04253h		;3579	c3 53 42	. S B
	call 01527h		;357c	cd 27 15	. ' .
	inc b			;357f	04		.
	rrca			;3580	0f		.
	ld a,001h		;3581	3e 01		> .
	and (ix+000h)		;3583	dd a6 00	. . .
	call sub_3b79h		;3586	cd 79 3b	. y ;
	call 01527h		;3589	cd 27 15	. ' .
	dec b			;358c	05		.
	rrca			;358d	0f		.
	ld a,002h		;358e	3e 02		> .
	and (ix+000h)		;3590	dd a6 00	. . .
	call sub_3b79h		;3593	cd 79 3b	. y ;
	call 01527h		;3596	cd 27 15	. ' .
	ld b,00fh		;3599	06 0f		. .
	ld a,004h		;359b	3e 04		> .
	and (ix+000h)		;359d	dd a6 00	. . .
	call sub_3b79h		;35a0	cd 79 3b	. y ;
	push bc			;35a3	c5		.
	ld c,a			;35a4	4f		O
	ld a,008h		;35a5	3e 08		> .
	ld b,a			;35a7	47		G
	ld a,(ix+004h)		;35a8	dd 7e 04	. ~ .
	sub b			;35ab	90		.
	ld a,c			;35ac	79		y
	pop bc			;35ad	c1		.
	jp c,l35b9h		;35ae	da b9 35	. . 5
	ld (ix+004h),008h	;35b1	dd 36 04 08	. 6 . .
	ld (ix+007h),008h	;35b5	dd 36 07 08	. 6 . .
l35b9h:
	push bc			;35b9	c5		.
	ld c,a			;35ba	4f		O
	ld a,000h		;35bb	3e 00		> .
	ld b,a			;35bd	47		G
	ld a,(ix+004h)		;35be	dd 7e 04	. ~ .
	sub b			;35c1	90		.
	ld a,c			;35c2	79		y
	pop bc			;35c3	c1		.
	jp nz,l35ceh		;35c4	c2 ce 35	. . 5
	xor a			;35c7	af		.
	ld (ix+005h),a		;35c8	dd 77 05	. w .
	ld (ix+007h),a		;35cb	dd 77 07	. w .
l35ceh:
	ld a,(ix+005h)		;35ce	dd 7e 05	. ~ .
	and 07fh		;35d1	e6 7f		. .
	push bc			;35d3	c5		.
	ld c,a			;35d4	4f		O
	ld a,000h		;35d5	3e 00		> .
	ld b,a			;35d7	47		G
	ld a,c			;35d8	79		y
	sub b			;35d9	90		.
	ld a,c			;35da	79		y
	pop bc			;35db	c1		.
	jp nz,l35ebh		;35dc	c2 eb 35	. . 5
	ld (ix+008h),a		;35df	dd 77 08	. w .
	ld (ix+006h),a		;35e2	dd 77 06	. w .
	ld (ix+009h),a		;35e5	dd 77 09	. w .
	jp l3603h		;35e8	c3 03 36	. . 6
l35ebh:
	push bc			;35eb	c5		.
	ld c,a			;35ec	4f		O
	ld b,a			;35ed	47		G
	ld a,00ch		;35ee	3e 0c		> .
	sub b			;35f0	90		.
	ld a,c			;35f1	79		y
	pop bc			;35f2	c1		.
	jp nc,l3603h		;35f3	d2 03 36	. . 6
	xor a			;35f6	af		.
	ld (ix+005h),a		;35f7	dd 77 05	. w .
	ld (ix+008h),a		;35fa	dd 77 08	. w .
	ld (ix+006h),a		;35fd	dd 77 06	. w .
	ld (ix+009h),a		;3600	dd 77 09	. w .
l3603h:
	push bc			;3603	c5		.
	ld c,a			;3604	4f		O
	ld a,000h		;3605	3e 00		> .
	ld b,a			;3607	47		G
	ld a,(ix+007h)		;3608	dd 7e 07	. ~ .
	sub b			;360b	90		.
	ld a,c			;360c	79		y
	pop bc			;360d	c1		.
	jp nz,l361ah		;360e	c2 1a 36	. . 6
	ld a,(ix+004h)		;3611	dd 7e 04	. ~ .
	ld (ix+007h),a		;3614	dd 77 07	. w .
	jp l362eh		;3617	c3 2e 36	. . 6
l361ah:
	push bc			;361a	c5		.
	ld c,a			;361b	4f		O
	ld a,008h		;361c	3e 08		> .
	ld b,a			;361e	47		G
	ld a,(ix+007h)		;361f	dd 7e 07	. ~ .
	sub b			;3622	90		.
	ld a,c			;3623	79		y
	pop bc			;3624	c1		.
	jp c,l362eh		;3625	da 2e 36	. . 6
	ld a,(ix+004h)		;3628	dd 7e 04	. ~ .
	ld (ix+007h),a		;362b	dd 77 07	. w .
l362eh:
	ld a,(ix+008h)		;362e	dd 7e 08	. ~ .
	and 07fh		;3631	e6 7f		. .
	ld b,a			;3633	47		G
	push bc			;3634	c5		.
	ld c,a			;3635	4f		O
	ld a,000h		;3636	3e 00		> .
	push de			;3638	d5		.
	ld d,b			;3639	50		P
	ld b,a			;363a	47		G
	ld a,d			;363b	7a		z
	pop de			;363c	d1		.
	sub b			;363d	90		.
	ld a,c			;363e	79		y
	pop bc			;363f	c1		.
	jp nz,l364ch		;3640	c2 4c 36	. L 6
	ld a,(ix+005h)		;3643	dd 7e 05	. ~ .
	ld (ix+008h),a		;3646	dd 77 08	. w .
	jp l365ch		;3649	c3 5c 36	. \ 6
l364ch:
	push bc			;364c	c5		.
	ld c,a			;364d	4f		O
	ld a,00ch		;364e	3e 0c		> .
	sub b			;3650	90		.
	ld a,c			;3651	79		y
	pop bc			;3652	c1		.
	jp nc,l365ch		;3653	d2 5c 36	. \ 6
	ld a,(ix+005h)		;3656	dd 7e 05	. ~ .
	ld (ix+008h),a		;3659	dd 77 08	. w .
l365ch:
	call 01527h		;365c	cd 27 15	. ' .
	ld a,(bc)		;365f	0a		.
	rrca			;3660	0f		.
	call sub_3879h		;3661	cd 79 38	. y 8
	ld b,006h		;3664	06 06		. .
	call sub_3866h		;3666	cd 66 38	. f 8
	call 01527h		;3669	cd 27 15	. ' .
	inc de			;366c	13		.
	rrca			;366d	0f		.
	ld hl,053d6h		;366e	21 d6 53	! . S
	call 0b86dh		;3671	cd 6d b8	. m .
	call 01527h		;3674	cd 27 15	. ' .
	ld d,001h		;3677	16 01		. .
	ld hl,053ceh		;3679	21 ce 53	! . S
	call sub_15b0h		;367c	cd b0 15	. . .
	ld b,000h		;367f	06 00		. .
	call sub_3866h		;3681	cd 66 38	. f 8
	call 01527h		;3684	cd 27 15	. ' .
	ld bc,0fd0fh		;3687	01 0f fd	. . .
	ld hl,0d161h		;368a	21 61 d1	! a .
	ld b,(ix+003h)		;368d	dd 46 03	. F .
	dec b			;3690	05		.
l3691h:
	call SOMETHING_KBD	;3691	cd a7 17	. . .
	push bc			;3694	c5		.
	ld c,a			;3695	4f		O
	ld a,020h		;3696	3e 20		>  
	ld b,a			;3698	47		G
	ld a,c			;3699	79		y
	sub b			;369a	90		.
	ld a,c			;369b	79		y
	pop bc			;369c	c1		.
	jp nz,l36b2h		;369d	c2 b2 36	. . 6
	inc b			;36a0	04		.
	push bc			;36a1	c5		.
	ld c,a			;36a2	4f		O
	ld a,004h		;36a3	3e 04		> .
	sub b			;36a5	90		.
	ld a,c			;36a6	79		y
	pop bc			;36a7	c1		.
	jp nc,l36adh		;36a8	d2 ad 36	. . 6
	ld b,000h		;36ab	06 00		. .
l36adh:
	ld c,00ah		;36ad	0e 0a		. .
	call 03b0ch		;36af	cd 0c 3b	. . ;
l36b2h:
	push bc			;36b2	c5		.
	ld c,a			;36b3	4f		O
	ld a,00ah		;36b4	3e 0a		> .
	ld b,a			;36b6	47		G
	ld a,c			;36b7	79		y
	sub b			;36b8	90		.
	ld a,c			;36b9	79		y
	pop bc			;36ba	c1		.
	jp nz,l3691h		;36bb	c2 91 36	. . 6
	inc b			;36be	04		.
	ld (ix+003h),b		;36bf	dd 70 03	. p .
	call 01527h		;36c2	cd 27 15	. ' .
	ld (bc),a		;36c5	02		.
	rrca			;36c6	0f		.
	ld iy,0d183h		;36c7	fd 21 83 d1	. ! . .
	ld d,(ix+002h)		;36cb	dd 56 02	. V .
l36ceh:
	call SOMETHING_KBD	;36ce	cd a7 17	. . .
	push bc			;36d1	c5		.
	ld c,a			;36d2	4f		O
	ld a,020h		;36d3	3e 20		>  
	ld b,a			;36d5	47		G
	ld a,c			;36d6	79		y
	sub b			;36d7	90		.
	ld a,c			;36d8	79		y
	pop bc			;36d9	c1		.
	jp nz,l370ah		;36da	c2 0a 37	. . 7
	rl d			;36dd	cb 12		. .
	push bc			;36df	c5		.
	ld c,a			;36e0	4f		O
	ld a,010h		;36e1	3e 10		> .
	ld b,a			;36e3	47		G
	ld a,d			;36e4	7a		z
	sub b			;36e5	90		.
	ld a,c			;36e6	79		y
	pop bc			;36e7	c1		.
	jp nz,l36f0h		;36e8	c2 f0 36	. . 6
	ld b,001h		;36eb	06 01		. .
	jp l3705h		;36ed	c3 05 37	. . 7
l36f0h:
	push bc			;36f0	c5		.
l36f1h:
	ld c,a			;36f1	4f		O
	ld a,020h		;36f2	3e 20		>  
	ld b,a			;36f4	47		G
	ld a,d			;36f5	7a		z
	sub b			;36f6	90		.
	ld a,c			;36f7	79		y
	pop bc			;36f8	c1		.
	jp nz,l3701h		;36f9	c2 01 37	. . 7
	ld b,002h		;36fc	06 02		. .
	jp l3705h		;36fe	c3 05 37	. . 7
l3701h:
	ld b,000h		;3701	06 00		. .
	ld d,008h		;3703	16 08		. .
l3705h:
	ld c,006h		;3705	0e 06		. .
	call 03b0ch		;3707	cd 0c 3b	. . ;
l370ah:
	push bc			;370a	c5		.
	ld c,a			;370b	4f		O
	ld a,00ah		;370c	3e 0a		> .
	ld b,a			;370e	47		G
	ld a,c			;370f	79		y
	sub b			;3710	90		.
	ld a,c			;3711	79		y
	pop bc			;3712	c1		.
	jp nz,l36ceh		;3713	c2 ce 36	. . 6
	ld (ix+002h),d		;3716	dd 72 02	. r .
	ld b,001h		;3719	06 01		. .
	call sub_3866h		;371b	cd 66 38	. f 8
	call 01527h		;371e	cd 27 15	. ' .
	inc bc			;3721	03		.
	djnz l36f1h		;3722	10 cd		. .
	call po,0c313h		;3724	e4 13 c3	. . .
	ld d,e			;3727	53		S
	ld b,d			;3728	42		B
	ld b,002h		;3729	06 02		. .
	call sub_3866h		;372b	cd 66 38	. f 8
	call 01527h		;372e	cd 27 15	. ' .
	inc b			;3731	04		.
	rrca			;3732	0f		.
	ld hl,053c2h		;3733	21 c2 53	! . S
	ld b,001h		;3736	06 01		. .
	call sub_3ae0h		;3738	cd e0 3a	. . :
	call 01527h		;373b	cd 27 15	. ' .
	dec b			;373e	05		.
	rrca			;373f	0f		.
	ld b,002h		;3740	06 02		. .
	call sub_3ae0h		;3742	cd e0 3a	. . :
	call 01527h		;3745	cd 27 15	. ' .
	ld b,00fh		;3748	06 0f		. .
	ld b,004h		;374a	06 04		. .
	call sub_3ae0h		;374c	cd e0 3a	. . :
	ld b,000h		;374f	06 00		. .
	call sub_3866h		;3751	cd 66 38	. f 8
	call 01527h		;3754	cd 27 15	. ' .
	ld a,(bc)		;3757	0a		.
	rrca			;3758	0f		.
	ld iy,0d27ah		;3759	fd 21 7a d2	. ! z .
	ld b,(ix+004h)		;375d	dd 46 04	. F .
l3760h:
	call SOMETHING_KBD	;3760	cd a7 17	. . .
	push bc			;3763	c5		.
	ld c,a			;3764	4f		O
	ld a,020h		;3765	3e 20		>  
	ld b,a			;3767	47		G
	ld a,c			;3768	79		y
	sub b			;3769	90		.
	ld a,c			;376a	79		y
	pop bc			;376b	c1		.
	jp nz,l3781h		;376c	c2 81 37	. . 7
	inc b			;376f	04		.
	push bc			;3770	c5		.
	ld c,a			;3771	4f		O
	ld a,008h		;3772	3e 08		> .
	sub b			;3774	90		.
	ld a,c			;3775	79		y
	pop bc			;3776	c1		.
	jp nc,l377ch		;3777	d2 7c 37	. | 7
	ld b,000h		;377a	06 00		. .
l377ch:
	ld c,00bh		;377c	0e 0b		. .
	call 03b0ch		;377e	cd 0c 3b	. . ;
l3781h:
	push bc			;3781	c5		.
	ld c,a			;3782	4f		O
	ld a,00ah		;3783	3e 0a		> .
	ld b,a			;3785	47		G
	ld a,c			;3786	79		y
	sub b			;3787	90		.
	ld a,c			;3788	79		y
	pop bc			;3789	c1		.
	jp nz,l3760h		;378a	c2 60 37	. ` 7
	ld a,b			;378d	78		x
	ld (053c6h),a		;378e	32 c6 53	2 . S
	push bc			;3791	c5		.
	ld c,a			;3792	4f		O
	ld a,000h		;3793	3e 00		> .
	push de			;3795	d5		.
	ld d,b			;3796	50		P
	ld b,a			;3797	47		G
	ld a,d			;3798	7a		z
	pop de			;3799	d1		.
	sub b			;379a	90		.
	ld a,c			;379b	79		y
	pop bc			;379c	c1		.
	jp nz,l37b5h		;379d	c2 b5 37	. . 7
	ld (053c7h),a		;37a0	32 c7 53	2 . S
	ld (053c8h),a		;37a3	32 c8 53	2 . S
	ld (053c9h),a		;37a6	32 c9 53	2 . S
	ld (053cah),a		;37a9	32 ca 53	2 . S
	ld (053cbh),a		;37ac	32 cb 53	2 . S
	call sub_3879h		;37af	cd 79 38	. y 8
	jp l383ah		;37b2	c3 3a 38	. : 8
l37b5h:
	push bc			;37b5	c5		.
	ld c,a			;37b6	4f		O
	ld a,008h		;37b7	3e 08		> .
	push de			;37b9	d5		.
	ld d,b			;37ba	50		P
	ld b,a			;37bb	47		G
	ld a,d			;37bc	7a		z
	pop de			;37bd	d1		.
	sub b			;37be	90		.
	ld a,c			;37bf	79		y
	pop bc			;37c0	c1		.
	jp nz,l37dah		;37c1	c2 da 37	. . 7
	ld (053c9h),a		;37c4	32 c9 53	2 . S
	call 01527h		;37c7	cd 27 15	. ' .
	rrca			;37ca	0f		.
	rrca			;37cb	0f		.
	ld c,00bh		;37cc	0e 0b		. .
	call 03b0ch		;37ce	cd 0c 3b	. . ;
	call sub_38fbh		;37d1	cd fb 38	. . 8
	call sub_39c4h		;37d4	cd c4 39	. . 9
	jp l383ah		;37d7	c3 3a 38	. : 8
l37dah:
	ld a,(053c9h)		;37da	3a c9 53	: . S
	dec a			;37dd	3d		=
	cp 007h			;37de	fe 07		. .
	jp c,l37f1h		;37e0	da f1 37	. . 7
	ld a,b			;37e3	78		x
	ld (053c9h),a		;37e4	32 c9 53	2 . S
	call 01527h		;37e7	cd 27 15	. ' .
	rrca			;37ea	0f		.
	rrca			;37eb	0f		.
	ld c,00bh		;37ec	0e 0b		. .
	call 03b0ch		;37ee	cd 0c 3b	. . ;
l37f1h:
	call sub_38fbh		;37f1	cd fb 38	. . 8
	ld b,000h		;37f4	06 00		. .
	call sub_3866h		;37f6	cd 66 38	. f 8
	call 01527h		;37f9	cd 27 15	. ' .
	rrca			;37fc	0f		.
	rrca			;37fd	0f		.
	ld iy,0d27ah		;37fe	fd 21 7a d2	. ! z .
	ld a,(053c9h)		;3802	3a c9 53	: . S
	ld b,a			;3805	47		G
l3806h:
	call SOMETHING_KBD	;3806	cd a7 17	. . .
	push bc			;3809	c5		.
	ld c,a			;380a	4f		O
	ld a,020h		;380b	3e 20		>  
	ld b,a			;380d	47		G
	ld a,c			;380e	79		y
	sub b			;380f	90		.
	ld a,c			;3810	79		y
	pop bc			;3811	c1		.
	jp nz,l3827h		;3812	c2 27 38	. ' 8
	inc b			;3815	04		.
	push bc			;3816	c5		.
	ld c,a			;3817	4f		O
	ld a,007h		;3818	3e 07		> .
	sub b			;381a	90		.
	ld a,c			;381b	79		y
	pop bc			;381c	c1		.
	jp nc,l3822h		;381d	d2 22 38	. " 8
	ld b,001h		;3820	06 01		. .
l3822h:
	ld c,00bh		;3822	0e 0b		. .
	call 03b0ch		;3824	cd 0c 3b	. . ;
l3827h:
	push bc			;3827	c5		.
	ld c,a			;3828	4f		O
	ld a,00ah		;3829	3e 0a		> .
	ld b,a			;382b	47		G
	ld a,c			;382c	79		y
	sub b			;382d	90		.
	ld a,c			;382e	79		y
	pop bc			;382f	c1		.
	jp nz,l3806h		;3830	c2 06 38	. . 8
	ld a,b			;3833	78		x
	ld (053c9h),a		;3834	32 c9 53	2 . S
	call sub_39c4h		;3837	cd c4 39	. . 9
l383ah:
	ld b,006h		;383a	06 06		. .
	call sub_3866h		;383c	cd 66 38	. f 8
	call 01527h		;383f	cd 27 15	. ' .
	inc de			;3842	13		.
	rrca			;3843	0f		.
	ld hl,053d6h		;3844	21 d6 53	! . S
	call 0b87bh		;3847	cd 7b b8	. { .
	ld (053cch),a		;384a	32 cc 53	2 . S
	call 01527h		;384d	cd 27 15	. ' .
	ld d,001h		;3850	16 01		. .
	ld hl,053ceh		;3852	21 ce 53	! . S
	call sub_162bh		;3855	cd 2b 16	. + .
	ld de,04a3eh		;3858	11 3e 4a	. > J
	ld hl,053c2h		;385b	21 c2 53	! . S
	ld bc,16		;385e	01 10 00	. . .
	ldir			;3861	ed b0		. .
	jp l1925h		;3863	c3 25 19	. % .
sub_3866h:
	push iy			;3866	fd e5		. .
	ld iy,0d194h		;3868	fd 21 94 d1	. ! . .
	ld c,020h		;386c	0e 20		.  
	call 01527h		;386e	cd 27 15	. ' .
	add hl,de		;3871	19		.
	ld bc,l0ccdh		;3872	01 cd 0c	. . .
	dec sp			;3875	3b		;
	pop iy			;3876	fd e1		. .
	ret			;3878	c9		.
sub_3879h:
	ld d,002h		;3879	16 02		. .
	ld hl,053c6h		;387b	21 c6 53	! . S
l387eh:
	ld b,(hl)		;387e	46		F
	ld iy,0d27ah		;387f	fd 21 7a d2	. ! z .
	ld c,00bh		;3883	0e 0b		. .
	call 03b0ch		;3885	cd 0c 3b	. . ;
	call sub_1568h		;3888	cd 68 15	. h .
	ld bc,07e23h		;388b	01 23 7e	. # ~
	and 07fh		;388e	e6 7f		. .
	ld (053d2h),a		;3890	32 d2 53	2 . S
	call sub_1431h		;3893	cd 31 14	. 1 .
	jp nc,04253h		;3896	d2 53 42	. S B
	call sub_1318h		;3899	cd 18 13	. . .
	ld a,(07e23h)		;389c	3a 23 7e	: # ~
	push bc			;389f	c5		.
	ld c,a			;38a0	4f		O
	ld b,a			;38a1	47		G
	ld a,03bh		;38a2	3e 3b		> ;
	sub b			;38a4	90		.
	ld a,c			;38a5	79		y
	pop bc			;38a6	c1		.
	jp nc,l38adh		;38a7	d2 ad 38	. . 8
	ld a,000h		;38aa	3e 00		> .
	ld (hl),a		;38ac	77		w
l38adh:
	call sub_38c7h		;38ad	cd c7 38	. . 8
	call sub_1568h		;38b0	cd 68 15	. h .
	inc b			;38b3	04		.
	call sub_156ch		;38b4	cd 6c 15	. l .
	ld b,023h		;38b7	06 23		. #
	dec d			;38b9	15		.
	push bc			;38ba	c5		.
	ld c,a			;38bb	4f		O
	ld a,000h		;38bc	3e 00		> .
	ld b,a			;38be	47		G
	ld a,d			;38bf	7a		z
	sub b			;38c0	90		.
	ld a,c			;38c1	79		y
	pop bc			;38c2	c1		.
	jp nz,l387eh		;38c3	c2 7e 38	. ~ 8
	ret			;38c6	c9		.
sub_38c7h:
	ld a,(hl)		;38c7	7e		~
	ld (053d3h),a		;38c8	32 d3 53	2 . S
	call sub_1431h		;38cb	cd 31 14	. 1 .
	out (053h),a		;38ce	d3 53		. S
	ld b,d			;38d0	42		B
	dec hl			;38d1	2b		+
	ld a,07fh		;38d2	3e 7f		> .
	and (hl)		;38d4	a6		.
	push bc			;38d5	c5		.
	ld c,a			;38d6	4f		O
	ld a,000h		;38d7	3e 00		> .
	ld b,a			;38d9	47		G
	ld a,c			;38da	79		y
	sub b			;38db	90		.
	ld a,c			;38dc	79		y
	pop bc			;38dd	c1		.
	jp nz,l38e6h		;38de	c2 e6 38	. . 8
	ld b,002h		;38e1	06 02		. .
	jp l38ech		;38e3	c3 ec 38	. . 8
l38e6h:
	ld a,080h		;38e6	3e 80		> .
	and (hl)		;38e8	a6		.
	ld b,a			;38e9	47		G
	rlc b			;38ea	cb 00		. .
l38ech:
	inc hl			;38ec	23		#
	ld c,009h		;38ed	0e 09		. .
	ld iy,0d2abh		;38ef	fd 21 ab d2	. ! . .
	call sub_1570h		;38f3	cd 70 15	. p .
	ld bc,l0ccdh		;38f6	01 cd 0c	. . .
	dec sp			;38f9	3b		;
	ret			;38fa	c9		.
sub_38fbh:
	ld b,003h		;38fb	06 03		. .
	call sub_3866h		;38fd	cd 66 38	. f 8
	call 01527h		;3900	cd 27 15	. ' .
	dec bc			;3903	0b		.
	djnz $+35		;3904	10 21		. !
	rst 0			;3906	c7		.
	ld d,e			;3907	53		S
	ld a,(hl)		;3908	7e		~
	and 07fh		;3909	e6 7f		. .
	ld (053d2h),a		;390b	32 d2 53	2 . S
l390eh:
	call sub_13e4h		;390e	cd e4 13	. . .
	jp nc,05253h		;3911	d2 53 52	. S R
	push de			;3914	d5		.
	push hl			;3915	e5		.
	ex de,hl		;3916	eb		.
	ld hl,12		;3917	21 0c 00	! . .
	or a			;391a	b7		.
	sbc hl,de		;391b	ed 52		. R
	pop hl			;391d	e1		.
	pop de			;391e	d1		.
	jp nc,l3926h		;391f	d2 26 39	. & 9
	xor a			;3922	af		.
	jp l3928h		;3923	c3 28 39	. ( 9
l3926h:
	ld a,0ffh		;3926	3e ff		> .
l3928h:
	push bc			;3928	c5		.
	ld c,a			;3929	4f		O
	ld a,000h		;392a	3e 00		> .
	ld b,a			;392c	47		G
	ld a,c			;392d	79		y
	sub b			;392e	90		.
	ld a,c			;392f	79		y
	pop bc			;3930	c1		.
	jp nz,l3938h		;3931	c2 38 39	. 8 9
	call sub_14e5h		;3934	cd e5 14	. . .
	ld (bc),a		;3937	02		.
l3938h:
	push bc			;3938	c5		.
	ld c,a			;3939	4f		O
	ld a,0ffh		;393a	3e ff		> .
	ld b,a			;393c	47		G
	ld a,c			;393d	79		y
	sub b			;393e	90		.
	ld a,c			;393f	79		y
	pop bc			;3940	c1		.
	jp nz,l390eh		;3941	c2 0e 39	. . 9
	call sub_13c8h		;3944	cd c8 13	. . .
	cp e			;3947	bb		.
	jp nc,07d03h		;3948	d2 03 7d	. . }
	push bc			;394b	c5		.
	ld c,a			;394c	4f		O
	ld a,000h		;394d	3e 00		> .
	ld b,a			;394f	47		G
	ld a,c			;3950	79		y
	sub b			;3951	90		.
	ld a,c			;3952	79		y
	pop bc			;3953	c1		.
	jp z,l399ah		;3954	ca 9a 39	. . 9
	push bc			;3957	c5		.
	ld c,a			;3958	4f		O
l3959h:
	ld a,000h		;3959	3e 00		> .
	ld b,a			;395b	47		G
	ld a,(053c7h)		;395c	3a c7 53	: . S
	sub b			;395f	90		.
	ld a,c			;3960	79		y
	pop bc			;3961	c1		.
	jp nz,l3991h		;3962	c2 91 39	. . 9
	push af			;3965	f5		.
	ld (053c7h),a		;3966	32 c7 53	2 . S
	ld (053cah),a		;3969	32 ca 53	2 . S
	call sub_156ch		;396c	cd 6c 15	. l .
	ld bc,0c821h		;396f	01 21 c8	. ! .
	ld d,e			;3972	53		S
	call sub_38c7h		;3973	cd c7 38	. . 8
	call 01527h		;3976	cd 27 15	. ' .
	djnz l398ah		;3979	10 0f		. .
	call sub_1431h		;397b	cd 31 14	. 1 .
	jp nc,04253h		;397e	d2 53 42	. S B
	ld hl,053cbh		;3981	21 cb 53	! . S
	call sub_1570h		;3984	cd 70 15	. p .
	ld bc,0c7cdh		;3987	01 cd c7	. . .
l398ah:
	jr c,l3959h		;398a	38 cd		8 .
	daa			;398c	27		'
l398dh:
	dec d			;398d	15		.
	dec bc			;398e	0b		.
	inc de			;398f	13		.
	pop af			;3990	f1		.
l3991h:
	ld hl,053c8h		;3991	21 c8 53	! . S
	call sub_3a3dh		;3994	cd 3d 3a	. = :
	jp 039c3h		;3997	c3 c3 39	. . 9
l399ah:
	ld hl,053c7h		;399a	21 c7 53	! . S
	ld (hl),a		;399d	77		w
	inc hl			;399e	23		#
	ld (hl),a		;399f	77		w
	call sub_156ch		;39a0	cd 6c 15	. l .
	ld bc,0c7cdh		;39a3	01 cd c7	. . .
	jr c,l39cbh		;39a6	38 23		8 #
	inc hl			;39a8	23		#
	xor a			;39a9	af		.
	ld (hl),a		;39aa	77		w
	call 01527h		;39ab	cd 27 15	. ' .
	djnz l39bfh		;39ae	10 0f		. .
	xor a			;39b0	af		.
	ld (053d2h),a		;39b1	32 d2 53	2 . S
	call sub_1431h		;39b4	cd 31 14	. 1 .
	jp nc,04253h		;39b7	d2 53 42	. S B
	inc hl			;39ba	23		#
	ld (hl),a		;39bb	77		w
	call sub_1570h		;39bc	cd 70 15	. p .
l39bfh:
	ld bc,0c7cdh		;39bf	01 cd c7	. . .
	jr c,l398dh		;39c2	38 c9		8 .
sub_39c4h:
	ld a,(053c7h)		;39c4	3a c7 53	: . S
	and 07fh		;39c7	e6 7f		. .
	push bc			;39c9	c5		.
	ld c,a			;39ca	4f		O
l39cbh:
	ld a,000h		;39cb	3e 00		> .
	ld b,a			;39cd	47		G
	ld a,c			;39ce	79		y
	sub b			;39cf	90		.
	ld a,c			;39d0	79		y
	pop bc			;39d1	c1		.
	jp z,l3a3ch		;39d2	ca 3c 3a	. < :
	ld b,005h		;39d5	06 05		. .
	call sub_3866h		;39d7	cd 66 38	. f 8
	call 01527h		;39da	cd 27 15	. ' .
	djnz l39efh		;39dd	10 10		. .
	ld hl,053cah		;39df	21 ca 53	! . S
	ld a,(hl)		;39e2	7e		~
	and 07fh		;39e3	e6 7f		. .
	ld (053d2h),a		;39e5	32 d2 53	2 . S
	push hl			;39e8	e5		.
l39e9h:
	call sub_13e4h		;39e9	cd e4 13	. . .
	jp nc,05253h		;39ec	d2 53 52	. S R
l39efh:
	push de			;39ef	d5		.
	push hl			;39f0	e5		.
	ld de,1		;39f1	11 01 00	. . .
	or a			;39f4	b7		.
	sbc hl,de		;39f5	ed 52		. R
	pop hl			;39f7	e1		.
	pop de			;39f8	d1		.
	jp nc,l3a00h		;39f9	d2 00 3a	. . :
	xor a			;39fc	af		.
	jp l3a14h		;39fd	c3 14 3a	. . :
l3a00h:
	push de			;3a00	d5		.
	push hl			;3a01	e5		.
	ex de,hl		;3a02	eb		.
	ld hl,12		;3a03	21 0c 00	! . .
	or a			;3a06	b7		.
	sbc hl,de		;3a07	ed 52		. R
	pop hl			;3a09	e1		.
	pop de			;3a0a	d1		.
	jp nc,l3a12h		;3a0b	d2 12 3a	. . :
	xor a			;3a0e	af		.
	jp l3a14h		;3a0f	c3 14 3a	. . :
l3a12h:
	ld a,0ffh		;3a12	3e ff		> .
l3a14h:
	push bc			;3a14	c5		.
	ld c,a			;3a15	4f		O
	ld a,000h		;3a16	3e 00		> .
	ld b,a			;3a18	47		G
	ld a,c			;3a19	79		y
	sub b			;3a1a	90		.
	ld a,c			;3a1b	79		y
	pop bc			;3a1c	c1		.
	jp nz,l3a24h		;3a1d	c2 24 3a	. $ :
	call sub_14e5h		;3a20	cd e5 14	. . .
	ld (bc),a		;3a23	02		.
l3a24h:
	push bc			;3a24	c5		.
	ld c,a			;3a25	4f		O
	ld a,0ffh		;3a26	3e ff		> .
	ld b,a			;3a28	47		G
	ld a,c			;3a29	79		y
	sub b			;3a2a	90		.
	ld a,c			;3a2b	79		y
	pop bc			;3a2c	c1		.
	jp nz,l39e9h		;3a2d	c2 e9 39	. . 9
	call sub_13c8h		;3a30	cd c8 13	. . .
	cp e			;3a33	bb		.
	jp nc,07d03h		;3a34	d2 03 7d	. . }
	pop hl			;3a37	e1		.
	inc hl			;3a38	23		#
	call sub_3a3dh		;3a39	cd 3d 3a	. = :
l3a3ch:
	ret			;3a3c	c9		.
sub_3a3dh:
	call sub_3b86h		;3a3d	cd 86 3b	. . ;
	push bc			;3a40	c5		.
	ld b,004h		;3a41	06 04		. .
	call sub_3866h		;3a43	cd 66 38	. f 8
	pop bc			;3a46	c1		.
	call sub_1548h		;3a47	cd 48 15	. H .
	ld a,(hl)		;3a4a	7e		~
	ld (053d3h),a		;3a4b	32 d3 53	2 . S
	push hl			;3a4e	e5		.
l3a4fh:
	call sub_13e4h		;3a4f	cd e4 13	. . .
	out (053h),a		;3a52	d3 53		. S
	ld d,d			;3a54	52		R
	push de			;3a55	d5		.
	push hl			;3a56	e5		.
	ex de,hl		;3a57	eb		.
	ld hl,0003bh		;3a58	21 3b 00	! ; .
	or a			;3a5b	b7		.
	sbc hl,de		;3a5c	ed 52		. R
	pop hl			;3a5e	e1		.
	pop de			;3a5f	d1		.
	jp nc,l3a67h		;3a60	d2 67 3a	. g :
	xor a			;3a63	af		.
	jp l3a69h		;3a64	c3 69 3a	. i :
l3a67h:
	ld a,0ffh		;3a67	3e ff		> .
l3a69h:
	push bc			;3a69	c5		.
	ld c,a			;3a6a	4f		O
	ld a,000h		;3a6b	3e 00		> .
	ld b,a			;3a6d	47		G
	ld a,c			;3a6e	79		y
	sub b			;3a6f	90		.
	ld a,c			;3a70	79		y
	pop bc			;3a71	c1		.
	jp nz,l3a79h		;3a72	c2 79 3a	. y :
	call sub_14e5h		;3a75	cd e5 14	. . .
	ld (bc),a		;3a78	02		.
l3a79h:
	push bc			;3a79	c5		.
	ld c,a			;3a7a	4f		O
	ld a,0ffh		;3a7b	3e ff		> .
	ld b,a			;3a7d	47		G
	ld a,c			;3a7e	79		y
	sub b			;3a7f	90		.
	ld a,c			;3a80	79		y
	pop bc			;3a81	c1		.
	jp nz,l3a4fh		;3a82	c2 4f 3a	. O :
	ld a,l			;3a85	7d		}
	pop hl			;3a86	e1		.
	ld (hl),a		;3a87	77		w
	call sub_156ch		;3a88	cd 6c 15	. l .
	ld (bc),a		;3a8b	02		.
	call sub_1318h		;3a8c	cd 18 13	. . .
	ld a,(070cdh)		;3a8f	3a cd 70	: . p
	dec d			;3a92	15		.
	inc bc			;3a93	03		.
	dec hl			;3a94	2b		+
	call sub_3b86h		;3a95	cd 86 3b	. . ;
	push bc			;3a98	c5		.
	ld b,000h		;3a99	06 00		. .
	call sub_3866h		;3a9b	cd 66 38	. f 8
	pop bc			;3a9e	c1		.
	call sub_1548h		;3a9f	cd 48 15	. H .
	ld a,080h		;3aa2	3e 80		> .
	and (hl)		;3aa4	a6		.
	ld e,a			;3aa5	5f		_
	ld iy,0d2abh		;3aa6	fd 21 ab d2	. ! . .
	ld c,009h		;3aaa	0e 09		. .
l3aach:
	call SOMETHING_KBD	;3aac	cd a7 17	. . .
	push bc			;3aaf	c5		.
	ld c,a			;3ab0	4f		O
	ld a,020h		;3ab1	3e 20		>  
	ld b,a			;3ab3	47		G
	ld a,c			;3ab4	79		y
	sub b			;3ab5	90		.
	ld a,c			;3ab6	79		y
	pop bc			;3ab7	c1		.
	jp nz,l3aceh		;3ab8	c2 ce 3a	. . :
	bit 7,e			;3abb	cb 7b		. {
	jp z,l3ac7h		;3abd	ca c7 3a	. . :
	res 7,e			;3ac0	cb bb		. .
	ld b,000h		;3ac2	06 00		. .
	jp l3acbh		;3ac4	c3 cb 3a	. . :
l3ac7h:
	set 7,e			;3ac7	cb fb		. .
	ld b,001h		;3ac9	06 01		. .
l3acbh:
	call 03b0ch		;3acb	cd 0c 3b	. . ;
l3aceh:
	push bc			;3ace	c5		.
	ld c,a			;3acf	4f		O
	ld a,00ah		;3ad0	3e 0a		> .
	ld b,a			;3ad2	47		G
	ld a,c			;3ad3	79		y
	sub b			;3ad4	90		.
	ld a,c			;3ad5	79		y
	pop bc			;3ad6	c1		.
	jp nz,l3aach		;3ad7	c2 ac 3a	. . :
	ld a,(053d2h)		;3ada	3a d2 53	: . S
	or e			;3add	b3		.
	ld (hl),a		;3ade	77		w
	ret			;3adf	c9		.
sub_3ae0h:
	call SOMETHING_KBD	;3ae0	cd a7 17	. . .
	and 05fh		;3ae3	e6 5f		. _
	cp 00ah			;3ae5	fe 0a		. .
	ret z			;3ae7	c8		.
	cp 059h			;3ae8	fe 59		. Y
	jr z,l3af6h		;3aea	28 0a		( .
	cp 04eh			;3aec	fe 4e		. N
	jr nz,sub_3ae0h		;3aee	20 f0		  .
	call OUTCH		;3af0	cd 84 10	. . .
	xor a			;3af3	af		.
	jr l3afbh		;3af4	18 05		. .
l3af6h:
	call OUTCH		;3af6	cd 84 10	. . .
	ld a,0ffh		;3af9	3e ff		> .
l3afbh:
	push bc			;3afb	c5		.
	and b			;3afc	a0		.
	push af			;3afd	f5		.
	ld a,b			;3afe	78		x
	cpl			;3aff	2f		/
	and (hl)		;3b00	a6		.
	ld b,a			;3b01	47		G
	pop af			;3b02	f1		.
	or b			;3b03	b0		.
	ld (hl),a		;3b04	77		w
	call sub_156ch		;3b05	cd 6c 15	. l .
	ld bc,018c1h		;3b08	01 c1 18	. . .
	call nc,0b1cdh		;3b0b	d4 cd b1	. . .
	add hl,bc		;3b0e	09		.
	ld (de),a		;3b0f	12		.
	dec sp			;3b10	3b		;
	ret			;3b11	c9		.
	push iy			;3b12	fd e5		. .
	push de			;3b14	d5		.
	push af			;3b15	f5		.
	push bc			;3b16	c5		.
	ld d,000h		;3b17	16 00		. .
l3b19h:
	push bc			;3b19	c5		.
	ld c,a			;3b1a	4f		O
	ld a,000h		;3b1b	3e 00		> .
	sub b			;3b1d	90		.
	ld a,c			;3b1e	79		y
	pop bc			;3b1f	c1		.
	jp nc,l3b2dh		;3b20	d2 2d 3b	. - ;
	ld e,(iy+000h)		;3b23	fd 5e 00	. ^ .
	inc e			;3b26	1c		.
	add iy,de		;3b27	fd 19		. .
	dec b			;3b29	05		.
	jp l3b19h		;3b2a	c3 19 3b	. . ;
l3b2dh:
	ld b,(iy+000h)		;3b2d	fd 46 00	. F .
	ld d,c			;3b30	51		Q
	push bc			;3b31	c5		.
	push de			;3b32	d5		.
	ld d,a			;3b33	57		W
	ld a,c			;3b34	79		y
	ld c,d			;3b35	4a		J
	pop de			;3b36	d1		.
	sub b			;3b37	90		.
	ld a,c			;3b38	79		y
	pop bc			;3b39	c1		.
	jp nc,l3b3eh		;3b3a	d2 3e 3b	. > ;
	ld b,c			;3b3d	41		A
l3b3eh:
	ld a,c			;3b3e	79		y
	sub b			;3b3f	90		.
	ld c,a			;3b40	4f		O
	inc iy			;3b41	fd 23		. #
l3b43h:
	push bc			;3b43	c5		.
	ld c,a			;3b44	4f		O
	ld a,000h		;3b45	3e 00		> .
	sub b			;3b47	90		.
	ld a,c			;3b48	79		y
	pop bc			;3b49	c1		.
	jp nc,l3b59h		;3b4a	d2 59 3b	. Y ;
	ld a,(iy+000h)		;3b4d	fd 7e 00	. ~ .
	call OUTCH		;3b50	cd 84 10	. . .
	inc iy			;3b53	fd 23		. #
	dec b			;3b55	05		.
	jp l3b43h		;3b56	c3 43 3b	. C ;
l3b59h:
	ld a,020h		;3b59	3e 20		>  
l3b5bh:
	push bc			;3b5b	c5		.
	ld b,c			;3b5c	41		A
	ld c,a			;3b5d	4f		O
	ld a,000h		;3b5e	3e 00		> .
	sub b			;3b60	90		.
	ld a,c			;3b61	79		y
	pop bc			;3b62	c1		.
	jp nc,l3b6dh		;3b63	d2 6d 3b	. m ;
	call OUTCH		;3b66	cd 84 10	. . .
	dec c			;3b69	0d		.
	jp l3b5bh		;3b6a	c3 5b 3b	. [ ;
l3b6dh:
	ld b,d			;3b6d	42		B
	ld a,008h		;3b6e	3e 08		> .
	call sub_157ch		;3b70	cd 7c 15	. | .
	pop bc			;3b73	c1		.
	pop af			;3b74	f1		.
	pop de			;3b75	d1		.
	pop iy			;3b76	fd e1		. .
	ret			;3b78	c9		.
sub_3b79h:
	or a			;3b79	b7		.
	jr z,l3b80h		;3b7a	28 04		( .
	ld a,059h		;3b7c	3e 59		> Y
	jr l3b82h		;3b7e	18 02		. .
l3b80h:
	ld a,04eh		;3b80	3e 4e		> N
l3b82h:
	call OUTCH		;3b82	cd 84 10	. . .
	ret			;3b85	c9		.
sub_3b86h:
	push hl			;3b86	e5		.
	push de			;3b87	d5		.
	push af			;3b88	f5		.
	ld a,001h		;3b89	3e 01		> .
	ld de,(04f84h)		;3b8b	ed 5b 84 4f	. [ . O
	ld hl,04186h		;3b8f	21 86 41	! . A
	ld bc,l0043h		;3b92	01 43 00	. C .
l3b95h:
	call sub_0f20h		;3b95	cd 20 0f	.   .
	jr z,l3ba0h		;3b98	28 06		( .
	add hl,bc		;3b9a	09		.
	inc a			;3b9b	3c		<
	cp 01ah			;3b9c	fe 1a		. .
	jr c,l3b95h		;3b9e	38 f5		8 .
l3ba0h:
	ld b,a			;3ba0	47		G
	ld a,(04f86h)		;3ba1	3a 86 4f	: . O
	inc a			;3ba4	3c		<
	ld c,a			;3ba5	4f		O
	pop af			;3ba6	f1		.
	pop de			;3ba7	d1		.
	pop hl			;3ba8	e1		.
	ret			;3ba9	c9		.
	call sub_2a82h		;3baa	cd 82 2a	. . *
	call sub_13c8h		;3bad	cd c8 13	. . .
	cp (hl)			;3bb0	be		.
	jp nc,0fd17h		;3bb1	d2 17 fd	. . .
	ld hl,0fffdh		;3bb4	21 fd ff	! . .
	add iy,sp		;3bb7	fd 39		. 9
	ld sp,iy		;3bb9	fd f9		. .
	ld h,006h		;3bbb	26 06		& .
	call sub_3d48h		;3bbd	cd 48 3d	. H =
	ld a,(05cbah)		;3bc0	3a ba 5c	: . \
	cp 005h			;3bc3	fe 05		. .
	jr nz,l3bcfh		;3bc5	20 08		  .
	inc hl			;3bc7	23		#
	ld a,053h		;3bc8	3e 53		> S
	call 088dch		;3bca	cd dc 88	. . .
	jr l3be4h		;3bcd	18 15		. .
l3bcfh:
	call sub_3d8ah		;3bcf	cd 8a 3d	. . =
	ld de,052cbh		;3bd2	11 cb 52	. . R
	add hl,de		;3bd5	19		.
	ld (iy+001h),l		;3bd6	fd 75 01	. u .
	ld (iy+002h),h		;3bd9	fd 74 02	. t .
	ld de,053c2h		;3bdc	11 c2 53	. . S
	ld bc,00027h		;3bdf	01 27 00	. ' .
	ldir			;3be2	ed b0		. .
l3be4h:
	call sub_13c8h		;3be4	cd c8 13	. . .
	push de			;3be7	d5		.
	jp nc,02137h		;3be8	d2 37 21	. 7 !
	ret			;3beb	c9		.
	ld d,e			;3bec	53		S
	push hl			;3bed	e5		.
	ld (iy+000h),001h	;3bee	fd 36 00 01	. 6 . .
l3bf2h:
	push bc			;3bf2	c5		.
	ld c,a			;3bf3	4f		O
	ld a,(iy+000h)		;3bf4	fd 7e 00	. ~ .
	ld b,a			;3bf7	47		G
	ld a,004h		;3bf8	3e 04		> .
	sub b			;3bfa	90		.
	ld a,c			;3bfb	79		y
	pop bc			;3bfc	c1		.
	jp c,l3c3bh		;3bfd	da 3b 3c	. ; <
	call sub_1570h		;3c00	cd 70 15	. p .
	ld (bc),a		;3c03	02		.
	call sub_1431h		;3c04	cd 31 14	. 1 .
	nop			;3c07	00		.
	nop			;3c08	00		.
	ld b,c			;3c09	41		A
	call sub_1570h		;3c0a	cd 70 15	. p .
	inc bc			;3c0d	03		.
	ex (sp),iy		;3c0e	fd e3		. .
	call sub_1431h		;3c10	cd 31 14	. 1 .
	nop			;3c13	00		.
	nop			;3c14	00		.
	inc b			;3c15	04		.
	call sub_1570h		;3c16	cd 70 15	. p .
	inc bc			;3c19	03		.
	call sub_1431h		;3c1a	cd 31 14	. 1 .
	ld (bc),a		;3c1d	02		.
	nop			;3c1e	00		.
	inc b			;3c1f	04		.
	call sub_1570h		;3c20	cd 70 15	. p .
	inc bc			;3c23	03		.
	call sub_1431h		;3c24	cd 31 14	. 1 .
	inc b			;3c27	04		.
	nop			;3c28	00		.
	inc b			;3c29	04		.
	ld de,8		;3c2a	11 08 00	. . .
	add iy,de		;3c2d	fd 19		. .
	ex (sp),iy		;3c2f	fd e3		. .
	inc (iy+000h)		;3c31	fd 34 00	. 4 .
	call sub_1318h		;3c34	cd 18 13	. . .
	dec b			;3c37	05		.
	jp l3bf2h		;3c38	c3 f2 3b	. . ;
l3c3bh:
	pop hl			;3c3b	e1		.
	ld hl,COLD_START	;3c3c	21 00 00	! . .
	ld (053c7h),hl		;3c3f	22 c7 53	" . S
	call 01527h		;3c42	cd 27 15	. ' .
	ld b,001h		;3c45	06 01		. .
	push iy			;3c47	fd e5		. .
	ld iy,053c9h		;3c49	fd 21 c9 53	. ! . S
	ld a,000h		;3c4d	3e 00		> .
l3c4fh:
	push bc			;3c4f	c5		.
	ld c,a			;3c50	4f		O
	ld b,a			;3c51	47		G
	ld a,003h		;3c52	3e 03		> .
	sub b			;3c54	90		.
	ld a,c			;3c55	79		y
	pop bc			;3c56	c1		.
	jp c,l3cadh		;3c57	da ad 3c	. . <
	push af			;3c5a	f5		.
	call sub_1570h		;3c5b	cd 70 15	. p .
	add hl,bc		;3c5e	09		.
	call sub_3cdfh		;3c5f	cd df 3c	. . <
	ld (iy+006h),l		;3c62	fd 75 06	. u .
	ld (iy+007h),h		;3c65	fd 74 07	. t .
	ex de,hl		;3c68	eb		.
	call sub_1570h		;3c69	cd 70 15	. p .
	rlca			;3c6c	07		.
	call sub_3d11h		;3c6d	cd 11 3d	. . =
	call sub_1570h		;3c70	cd 70 15	. p .
	rlca			;3c73	07		.
	call sub_13e4h		;3c74	cd e4 13	. . .
	inc b			;3c77	04		.
	nop			;3c78	00		.
	inc b			;3c79	04		.
	push de			;3c7a	d5		.
	push hl			;3c7b	e5		.
	ld hl,(053c7h)		;3c7c	2a c7 53	* . S
	ld de,COLD_START	;3c7f	11 00 00	. . .
	or a			;3c82	b7		.
	sbc hl,de		;3c83	ed 52		. R
	pop hl			;3c85	e1		.
	pop de			;3c86	d1		.
	jp nz,l3c9fh		;3c87	c2 9f 3c	. . <
	push de			;3c8a	d5		.
	push hl			;3c8b	e5		.
	ld de,COLD_START	;3c8c	11 00 00	. . .
	or a			;3c8f	b7		.
	sbc hl,de		;3c90	ed 52		. R
	pop hl			;3c92	e1		.
	pop de			;3c93	d1		.
	jp z,l3c9fh		;3c94	ca 9f 3c	. . <
	ld (053c7h),hl		;3c97	22 c7 53	" . S
	pop af			;3c9a	f1		.
	push af			;3c9b	f5		.
	ld (053c6h),a		;3c9c	32 c6 53	2 . S
l3c9fh:
	call sub_1318h		;3c9f	cd 18 13	. . .
	dec b			;3ca2	05		.
	ld de,8		;3ca3	11 08 00	. . .
	add iy,de		;3ca6	fd 19		. .
	pop af			;3ca8	f1		.
	inc a			;3ca9	3c		<
	jp l3c4fh		;3caa	c3 4f 3c	. O <
l3cadh:
	pop iy			;3cad	fd e1		. .
	ld a,(05cbah)		;3caf	3a ba 5c	: . \
	cp 005h			;3cb2	fe 05		. .
	jr nz,l3cc6h		;3cb4	20 10		  .
	ld hl,053c2h		;3cb6	21 c2 53	! . S
	ld de,05cc6h		;3cb9	11 c6 5c	. . \
	ld bc,00027h		;3cbc	01 27 00	. ' .
	ldir			;3cbf	ed b0		. .
	call 0893fh		;3cc1	cd 3f 89	. ? .
	jr l3cd4h		;3cc4	18 0e		. .
l3cc6h:
	ld e,(iy+001h)		;3cc6	fd 5e 01	. ^ .
	ld d,(iy+002h)		;3cc9	fd 56 02	. V .
	ld hl,053c2h		;3ccc	21 c2 53	! . S
	ld bc,00027h		;3ccf	01 27 00	. ' .
	ldir			;3cd2	ed b0		. .
l3cd4h:
	ld iy,3		;3cd4	fd 21 03 00	. ! . .
	add iy,sp		;3cd8	fd 39		. 9
	ld sp,iy		;3cda	fd f9		. .
	jp l1925h		;3cdc	c3 25 19	. % .
sub_3cdfh:
	call sub_13e4h		;3cdf	cd e4 13	. . .
	nop			;3ce2	00		.
	nop			;3ce3	00		.
	inc d			;3ce4	14		.
	ld de,(05b77h)		;3ce5	ed 5b 77 5b	. [ w [
	ex de,hl		;3ce9	eb		.
	call sub_0f20h		;3cea	cd 20 0f	.   .
	jr nc,l3d0fh		;3ced	30 20		0  
	ld a,(05b84h)		;3cef	3a 84 5b	: . [
	cp 04eh			;3cf2	fe 4e		. N
	jr z,l3cfeh		;3cf4	28 08		( .
	call sub_09e4h		;3cf6	cd e4 09	. . .
	call sub_0f20h		;3cf9	cd 20 0f	.   .
	jr c,l3d0fh		;3cfc	38 11		8 .
l3cfeh:
	ld hl,(0548ah)		;3cfe	2a 8a 54	* . T
	ex de,hl		;3d01	eb		.
	ld (0548ah),hl		;3d02	22 8a 54	" . T
	call sub_0f20h		;3d05	cd 20 0f	.   .
	ret z			;3d08	c8		.
	call sub_14e5h		;3d09	cd e5 14	. . .
	inc b			;3d0c	04		.
	jr sub_3cdfh		;3d0d	18 d0		. .
l3d0fh:
	ex de,hl		;3d0f	eb		.
	ret			;3d10	c9		.
sub_3d11h:
	call sub_13e4h		;3d11	cd e4 13	. . .
	ld (bc),a		;3d14	02		.
	nop			;3d15	00		.
	inc d			;3d16	14		.
	call sub_0f20h		;3d17	cd 20 0f	.   .
	jr c,l3d3fh		;3d1a	38 23		8 #
	push hl			;3d1c	e5		.
	push de			;3d1d	d5		.
	ex de,hl		;3d1e	eb		.
	ld hl,(05b77h)		;3d1f	2a 77 5b	* w [
	call sub_0f20h		;3d22	cd 20 0f	.   .
	jr nc,l3d45h		;3d25	30 1e		0 .
	ld hl,(0548ah)		;3d27	2a 8a 54	* . T
	ex de,hl		;3d2a	eb		.
	ld (0548ah),hl		;3d2b	22 8a 54	" . T
	call sub_0f20h		;3d2e	cd 20 0f	.   .
	jr z,l3d45h		;3d31	28 12		( .
	ld hl,(05b77h)		;3d33	2a 77 5b	* w [
	pop de			;3d36	d1		.
	push de			;3d37	d5		.
	call sub_0f20h		;3d38	cd 20 0f	.   .
	jr c,l3d45h		;3d3b	38 08		8 .
	pop de			;3d3d	d1		.
	pop hl			;3d3e	e1		.
l3d3fh:
	call sub_14e5h		;3d3f	cd e5 14	. . .
	inc b			;3d42	04		.
	jr sub_3d11h		;3d43	18 cc		. .
l3d45h:
	pop de			;3d45	d1		.
	pop hl			;3d46	e1		.
	ret			;3d47	c9		.
sub_3d48h:
	ld l,0ffh		;3d48	2e ff		. .
l3d4ah:
	call SOMETHING_KBD	;3d4a	cd a7 17	. . .
	push bc			;3d4d	c5		.
	ld c,a			;3d4e	4f		O
	ld a,00ah		;3d4f	3e 0a		> .
	ld b,a			;3d51	47		G
	ld a,c			;3d52	79		y
	sub b			;3d53	90		.
	ld a,c			;3d54	79		y
	pop bc			;3d55	c1		.
	jp nz,l3d6ah		;3d56	c2 6a 3d	. j =
	ld a,l			;3d59	7d		}
	cp h			;3d5a	bc		.
	jp nc,l3d65h		;3d5b	d2 65 3d	. e =
	ld a,00ah		;3d5e	3e 0a		> .
	ld h,000h		;3d60	26 00		& .
	jp l3d67h		;3d62	c3 67 3d	. g =
l3d65h:
	ld a,00bh		;3d65	3e 0b		> .
l3d67h:
	jp l3d7dh		;3d67	c3 7d 3d	. } =
l3d6ah:
	sub 031h		;3d6a	d6 31		. 1
	cp h			;3d6c	bc		.
	jp nc,03d7bh		;3d6d	d2 7b 3d	. { =
	ld l,a			;3d70	6f		o
	inc a			;3d71	3c		<
	or 030h			;3d72	f6 30		. 0
	call OUTCH		;3d74	cd 84 10	. . .
	call sub_156ch		;3d77	cd 6c 15	. l .
	ld bc,l0b3eh		;3d7a	01 3e 0b	. > .
l3d7dh:
	push bc			;3d7d	c5		.
	ld c,a			;3d7e	4f		O
	ld a,00ah		;3d7f	3e 0a		> .
	ld b,a			;3d81	47		G
	ld a,c			;3d82	79		y
	sub b			;3d83	90		.
	ld a,c			;3d84	79		y
	pop bc			;3d85	c1		.
	jp nz,l3d4ah		;3d86	c2 4a 3d	. J =
	ret			;3d89	c9		.
sub_3d8ah:
	push de			;3d8a	d5		.
	ld d,h			;3d8b	54		T
	ld e,l			;3d8c	5d		]
	add hl,hl		;3d8d	29		)
	add hl,hl		;3d8e	29		)
	add hl,hl		;3d8f	29		)
	add hl,de		;3d90	19		.
	add hl,hl		;3d91	29		)
	add hl,de		;3d92	19		.
	add hl,hl		;3d93	29		)
	add hl,de		;3d94	19		.
	pop de			;3d95	d1		.
	ret			;3d96	c9		.
	ld a,(05cbah)		;3d97	3a ba 5c	: . \
	cp 005h			;3d9a	fe 05		. .
	jr nz,l3dbbh		;3d9c	20 1d		  .
	ld a,048h		;3d9e	3e 48		> H
	ld hl,COLD_START	;3da0	21 00 00	! . .
	call 088dch		;3da3	cd dc 88	. . .
	ld hl,053d9h		;3da6	21 d9 53	! . S
	ld de,053e5h		;3da9	11 e5 53	. . S
	ld bc,24		;3dac	01 18 00	. . .
	lddr			;3daf	ed b8		. .
	ld a,052h		;3db1	3e 52		> R
	ld hl,COLD_START	;3db3	21 00 00	! . .
	call 088dch		;3db6	cd dc 88	. . .
	jr l3dc6h		;3db9	18 0b		. .
l3dbbh:
	ld hl,05b6fh		;3dbb	21 6f 5b	! o [
	ld de,053c2h		;3dbe	11 c2 53	. . S
	ld bc,36		;3dc1	01 24 00	. $ .
	ldir			;3dc4	ed b0		. .
l3dc6h:
	call sub_2a82h		;3dc6	cd 82 2a	. . *
	call sub_09b1h		;3dc9	cd b1 09	. . .
	dec e			;3dcc	1d		.
	jp nz,08dcdh		;3dcd	c2 cd 8d	. . .
	sub a			;3dd0	97		.
	call 01527h		;3dd1	cd 27 15	. ' .
	ld bc,0cd01h		;3dd4	01 01 cd	. . .
	daa			;3dd7	27		'
	sbc a,d			;3dd8	9a		.
	jr z,l3de1h		;3dd9	28 06		( .
	call 097d9h		;3ddb	cd d9 97	. . .
	jp l3e88h		;3dde	c3 88 3e	. . >
l3de1h:
	call 01527h		;3de1	cd 27 15	. ' .
	inc bc			;3de4	03		.
	djnz $-49		;3de5	10 cd		. .
	rra			;3de7	1f		.
	inc de			;3de8	13		.
	jp nz,04253h		;3de9	c2 53 42	. S B
	call 01527h		;3dec	cd 27 15	. ' .
	rlca			;3def	07		.
	djnz $+8		;3df0	10 06		. .
	ld bc,01a11h		;3df2	01 11 1a	. . .
	nop			;3df5	00		.
	ld iy,053c4h		;3df6	fd 21 c4 53	. ! . S
	push de			;3dfa	d5		.
	push hl			;3dfb	e5		.
	ld hl,COLD_START	;3dfc	21 00 00	! . .
	or a			;3dff	b7		.
	sbc hl,de		;3e00	ed 52		. R
	pop hl			;3e02	e1		.
	pop de			;3e03	d1		.
	jp nc,l3e5ah		;3e04	d2 5a 3e	. Z >
l3e07h:
	call sub_13e4h		;3e07	cd e4 13	. . .
	nop			;3e0a	00		.
	nop			;3e0b	00		.
	ld d,d			;3e0c	52		R
	push de			;3e0d	d5		.
	push hl			;3e0e	e5		.
	ex de,hl		;3e0f	eb		.
	or a			;3e10	b7		.
	sbc hl,de		;3e11	ed 52		. R
	pop hl			;3e13	e1		.
	pop de			;3e14	d1		.
	jp nc,l3e1ch		;3e15	d2 1c 3e	. . >
	xor a			;3e18	af		.
	jp l3e1eh		;3e19	c3 1e 3e	. . >
l3e1ch:
	ld a,0ffh		;3e1c	3e ff		> .
l3e1eh:
	push bc			;3e1e	c5		.
	ld c,a			;3e1f	4f		O
	ld a,000h		;3e20	3e 00		> .
	ld b,a			;3e22	47		G
	ld a,c			;3e23	79		y
	sub b			;3e24	90		.
	ld a,c			;3e25	79		y
	pop bc			;3e26	c1		.
	jp nz,l3e2eh		;3e27	c2 2e 3e	. . >
	call sub_14e5h		;3e2a	cd e5 14	. . .
	ld (bc),a		;3e2d	02		.
l3e2eh:
	push bc			;3e2e	c5		.
	ld c,a			;3e2f	4f		O
	ld a,0ffh		;3e30	3e ff		> .
	ld b,a			;3e32	47		G
	ld a,c			;3e33	79		y
	sub b			;3e34	90		.
	ld a,c			;3e35	79		y
	pop bc			;3e36	c1		.
	jp nz,l3e07h		;3e37	c2 07 3e	. . >
	ex de,hl		;3e3a	eb		.
	xor a			;3e3b	af		.
	sbc hl,de		;3e3c	ed 52		. R
	ex de,hl		;3e3e	eb		.
	inc b			;3e3f	04		.
	push bc			;3e40	c5		.
	ld c,a			;3e41	4f		O
	ld a,006h		;3e42	3e 06		> .
	sub b			;3e44	90		.
	ld a,c			;3e45	79		y
	pop bc			;3e46	c1		.
	jp nc,l3e51h		;3e47	d2 51 3e	. Q >
	add hl,de		;3e4a	19		.
	ld (iy+000h),l		;3e4b	fd 75 00	. u .
	ld de,COLD_START	;3e4e	11 00 00	. . .
l3e51h:
	inc iy			;3e51	fd 23		. #
	call sub_1568h		;3e53	cd 68 15	. h .
	ld bc,0fac3h		;3e56	01 c3 fa	. . .
	dec a			;3e59	3d		=
l3e5ah:
	push bc			;3e5a	c5		.
	ld c,a			;3e5b	4f		O
	ld a,006h		;3e5c	3e 06		> .
	sub b			;3e5e	90		.
	ld a,c			;3e5f	79		y
	pop bc			;3e60	c1		.
	jp c,l3e80h		;3e61	da 80 3e	. . >
	ld (iy+000h),000h	;3e64	fd 36 00 00	. 6 . .
	call sub_156ch		;3e68	cd 6c 15	. l .
	ld bc,l31cdh		;3e6b	01 cd 31	. . 1
	inc d			;3e6e	14		.
	nop			;3e6f	00		.
	nop			;3e70	00		.
	ld b,d			;3e71	42		B
	call sub_1568h		;3e72	cd 68 15	. h .
	ld bc,06ccdh		;3e75	01 cd 6c	. . l
	dec d			;3e78	15		.
	ld bc,0fd04h		;3e79	01 04 fd	. . .
	inc hl			;3e7c	23		#
	jp l3e5ah		;3e7d	c3 5a 3e	. Z >
l3e80h:
	call sub_09b1h		;3e80	cd b1 09	. . .
	pop bc			;3e83	c1		.
	jp nz,0afcdh		;3e84	c2 cd af	. . .
	sub a			;3e87	97		.
l3e88h:
	ld a,(05cbah)		;3e88	3a ba 5c	: . \
	cp 005h			;3e8b	fe 05		. .
	jr nz,l3eb3h		;3e8d	20 24		  $
	ld hl,053c2h		;3e8f	21 c2 53	! . S
	ld de,05cc6h		;3e92	11 c6 5c	. . \
	ld bc,12		;3e95	01 0c 00	. . .
	ldir			;3e98	ed b0		. .
	call 0893fh		;3e9a	cd 3f 89	. ? .
	ld hl,053ceh		;3e9d	21 ce 53	! . S
	ld de,05cc6h		;3ea0	11 c6 5c	. . \
	ld bc,24		;3ea3	01 18 00	. . .
	ldir			;3ea6	ed b0		. .
	ld a,048h		;3ea8	3e 48		> H
	ld (05cc2h),a		;3eaa	32 c2 5c	2 . \
	call 0893fh		;3ead	cd 3f 89	. ? .
	jp l1925h		;3eb0	c3 25 19	. % .
l3eb3h:
	ld de,05b6fh		;3eb3	11 6f 5b	. o [
	ld hl,053c2h		;3eb6	21 c2 53	! . S
	ld bc,36		;3eb9	01 24 00	. $ .
	ldir			;3ebc	ed b0		. .
	call 099cah		;3ebe	cd ca 99	. . .
	call sub_0849h		;3ec1	cd 49 08	. I .
	jp l1925h		;3ec4	c3 25 19	. % .
	nop			;3ec7	00		.
	nop			;3ec8	00		.
	nop			;3ec9	00		.
	nop			;3eca	00		.
	nop			;3ecb	00		.
	nop			;3ecc	00		.
	nop			;3ecd	00		.
	nop			;3ece	00		.
	nop			;3ecf	00		.
	nop			;3ed0	00		.
	nop			;3ed1	00		.
	nop			;3ed2	00		.
	nop			;3ed3	00		.
	nop			;3ed4	00		.
	nop			;3ed5	00		.
	nop			;3ed6	00		.
	nop			;3ed7	00		.
	nop			;3ed8	00		.
	nop			;3ed9	00		.
	nop			;3eda	00		.
	nop			;3edb	00		.
	nop			;3edc	00		.
	nop			;3edd	00		.
	nop			;3ede	00		.
	nop			;3edf	00		.
	nop			;3ee0	00		.
	nop			;3ee1	00		.
	nop			;3ee2	00		.
	nop			;3ee3	00		.
	nop			;3ee4	00		.
	nop			;3ee5	00		.
	nop			;3ee6	00		.
	nop			;3ee7	00		.
	nop			;3ee8	00		.
	nop			;3ee9	00		.
	nop			;3eea	00		.
	nop			;3eeb	00		.
	nop			;3eec	00		.
	nop			;3eed	00		.
	nop			;3eee	00		.
	nop			;3eef	00		.
	nop			;3ef0	00		.
	nop			;3ef1	00		.
	nop			;3ef2	00		.
	nop			;3ef3	00		.
	nop			;3ef4	00		.
	nop			;3ef5	00		.
	nop			;3ef6	00		.
	nop			;3ef7	00		.
	nop			;3ef8	00		.
	nop			;3ef9	00		.
	nop			;3efa	00		.
	nop			;3efb	00		.
	nop			;3efc	00		.
	nop			;3efd	00		.
	nop			;3efe	00		.
	nop			;3eff	00		.
	nop			;3f00	00		.
	nop			;3f01	00		.
	nop			;3f02	00		.
	nop			;3f03	00		.
	nop			;3f04	00		.
	nop			;3f05	00		.
	nop			;3f06	00		.
	nop			;3f07	00		.
	nop			;3f08	00		.
	nop			;3f09	00		.
	nop			;3f0a	00		.
	nop			;3f0b	00		.
	nop			;3f0c	00		.
	nop			;3f0d	00		.
	nop			;3f0e	00		.
	nop			;3f0f	00		.
	nop			;3f10	00		.
	nop			;3f11	00		.
	nop			;3f12	00		.
	nop			;3f13	00		.
	nop			;3f14	00		.
	nop			;3f15	00		.
	nop			;3f16	00		.
	nop			;3f17	00		.
	nop			;3f18	00		.
	nop			;3f19	00		.
	nop			;3f1a	00		.
	nop			;3f1b	00		.
	nop			;3f1c	00		.
	nop			;3f1d	00		.
	nop			;3f1e	00		.
	nop			;3f1f	00		.
	nop			;3f20	00		.
	nop			;3f21	00		.
	nop			;3f22	00		.
	nop			;3f23	00		.
	nop			;3f24	00		.
	nop			;3f25	00		.
	nop			;3f26	00		.
	nop			;3f27	00		.
	nop			;3f28	00		.
	nop			;3f29	00		.
	nop			;3f2a	00		.
	nop			;3f2b	00		.
	nop			;3f2c	00		.
	nop			;3f2d	00		.
	nop			;3f2e	00		.
	nop			;3f2f	00		.
	nop			;3f30	00		.
	nop			;3f31	00		.
	nop			;3f32	00		.
	nop			;3f33	00		.
	nop			;3f34	00		.
	nop			;3f35	00		.
	nop			;3f36	00		.
	nop			;3f37	00		.
	nop			;3f38	00		.
	nop			;3f39	00		.
	nop			;3f3a	00		.
	nop			;3f3b	00		.
	nop			;3f3c	00		.
	nop			;3f3d	00		.
	nop			;3f3e	00		.
	nop			;3f3f	00		.
	nop			;3f40	00		.
	nop			;3f41	00		.
	nop			;3f42	00		.
	nop			;3f43	00		.
	nop			;3f44	00		.
	nop			;3f45	00		.
	nop			;3f46	00		.
	nop			;3f47	00		.
	nop			;3f48	00		.
	nop			;3f49	00		.
	nop			;3f4a	00		.
	nop			;3f4b	00		.
	nop			;3f4c	00		.
	nop			;3f4d	00		.
	nop			;3f4e	00		.
	nop			;3f4f	00		.
	nop			;3f50	00		.
	nop			;3f51	00		.
	nop			;3f52	00		.
	nop			;3f53	00		.
	nop			;3f54	00		.
	nop			;3f55	00		.
	nop			;3f56	00		.
	nop			;3f57	00		.
	nop			;3f58	00		.
	nop			;3f59	00		.
	nop			;3f5a	00		.
	nop			;3f5b	00		.
	nop			;3f5c	00		.
	nop			;3f5d	00		.
	nop			;3f5e	00		.
	nop			;3f5f	00		.
	nop			;3f60	00		.
	nop			;3f61	00		.
	nop			;3f62	00		.
	nop			;3f63	00		.
	nop			;3f64	00		.
	nop			;3f65	00		.
	nop			;3f66	00		.
	nop			;3f67	00		.
	nop			;3f68	00		.
	nop			;3f69	00		.
	nop			;3f6a	00		.
	nop			;3f6b	00		.
	nop			;3f6c	00		.
	nop			;3f6d	00		.
	nop			;3f6e	00		.
	nop			;3f6f	00		.
	nop			;3f70	00		.
	nop			;3f71	00		.
	nop			;3f72	00		.
	nop			;3f73	00		.
	nop			;3f74	00		.
	nop			;3f75	00		.
	nop			;3f76	00		.
	nop			;3f77	00		.
	nop			;3f78	00		.
	nop			;3f79	00		.
	nop			;3f7a	00		.
	nop			;3f7b	00		.
	nop			;3f7c	00		.
	nop			;3f7d	00		.
	nop			;3f7e	00		.
	nop			;3f7f	00		.
	nop			;3f80	00		.
	nop			;3f81	00		.
	nop			;3f82	00		.
	nop			;3f83	00		.
	nop			;3f84	00		.
	nop			;3f85	00		.
	nop			;3f86	00		.
	nop			;3f87	00		.
	nop			;3f88	00		.
	nop			;3f89	00		.
	nop			;3f8a	00		.
	nop			;3f8b	00		.
	nop			;3f8c	00		.
	nop			;3f8d	00		.
	nop			;3f8e	00		.
	nop			;3f8f	00		.
	nop			;3f90	00		.
	nop			;3f91	00		.
	nop			;3f92	00		.
	nop			;3f93	00		.
	nop			;3f94	00		.
	nop			;3f95	00		.
	nop			;3f96	00		.
	nop			;3f97	00		.
	nop			;3f98	00		.
	nop			;3f99	00		.
	nop			;3f9a	00		.
	nop			;3f9b	00		.
	nop			;3f9c	00		.
	nop			;3f9d	00		.
	nop			;3f9e	00		.
	nop			;3f9f	00		.
	nop			;3fa0	00		.
	nop			;3fa1	00		.
	nop			;3fa2	00		.
	nop			;3fa3	00		.
	nop			;3fa4	00		.
	nop			;3fa5	00		.
	nop			;3fa6	00		.
	nop			;3fa7	00		.
	nop			;3fa8	00		.
	nop			;3fa9	00		.
	nop			;3faa	00		.
	nop			;3fab	00		.
	nop			;3fac	00		.
	nop			;3fad	00		.
	nop			;3fae	00		.
	nop			;3faf	00		.
	nop			;3fb0	00		.
	nop			;3fb1	00		.
	nop			;3fb2	00		.
	nop			;3fb3	00		.
	nop			;3fb4	00		.
	nop			;3fb5	00		.
	nop			;3fb6	00		.
	nop			;3fb7	00		.
	nop			;3fb8	00		.
	nop			;3fb9	00		.
	nop			;3fba	00		.
	nop			;3fbb	00		.
	nop			;3fbc	00		.
	nop			;3fbd	00		.
	nop			;3fbe	00		.
	nop			;3fbf	00		.
	nop			;3fc0	00		.
	nop			;3fc1	00		.
	nop			;3fc2	00		.
	nop			;3fc3	00		.
	nop			;3fc4	00		.
	nop			;3fc5	00		.
	nop			;3fc6	00		.
	nop			;3fc7	00		.
	nop			;3fc8	00		.
	nop			;3fc9	00		.
	nop			;3fca	00		.
	nop			;3fcb	00		.
	nop			;3fcc	00		.
	nop			;3fcd	00		.
	nop			;3fce	00		.
	nop			;3fcf	00		.
	nop			;3fd0	00		.
	nop			;3fd1	00		.
	nop			;3fd2	00		.
	nop			;3fd3	00		.
	nop			;3fd4	00		.
	nop			;3fd5	00		.
	nop			;3fd6	00		.
	nop			;3fd7	00		.
	nop			;3fd8	00		.
	nop			;3fd9	00		.
	nop			;3fda	00		.
	nop			;3fdb	00		.
	nop			;3fdc	00		.
	nop			;3fdd	00		.
	nop			;3fde	00		.
	nop			;3fdf	00		.
	nop			;3fe0	00		.
	nop			;3fe1	00		.
	nop			;3fe2	00		.
	nop			;3fe3	00		.
	nop			;3fe4	00		.
	nop			;3fe5	00		.
	nop			;3fe6	00		.
	nop			;3fe7	00		.
	nop			;3fe8	00		.
	nop			;3fe9	00		.
	nop			;3fea	00		.
	nop			;3feb	00		.
	nop			;3fec	00		.
	nop			;3fed	00		.
	nop			;3fee	00		.
	nop			;3fef	00		.
	nop			;3ff0	00		.
	nop			;3ff1	00		.
	nop			;3ff2	00		.
	nop			;3ff3	00		.
	nop			;3ff4	00		.
	nop			;3ff5	00		.
	nop			;3ff6	00		.
	nop			;3ff7	00		.
	nop			;3ff8	00		.
	nop			;3ff9	00		.
	nop			;3ffa	00		.
	nop			;3ffb	00		.
	nop			;3ffc	00		.
	nop			;3ffd	00		.
	nop			;3ffe	00		.
l3fffh:
	nop			;3fff	00		.
