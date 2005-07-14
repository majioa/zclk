;[]-----------------------------------------------------------------[]
;|   MEMUTILS.ASM -- memory class functions			     |
;[]-----------------------------------------------------------------[]
;
; $Copyright: 2003$
; $Revision: 1.1.1.1 $
;

	%include 'defs.inc'

	PUBLIC	@Memblock@$bctr$qqrul ;MemAlloc
	PUBLIC	@Memblock@Resize$qqrul ;MemAlloc
	PUBLIC	@Memblock@$bctr$qqrrx8Memblock ;MemRealloc
	PUBLIC	@Memblock@$bdtr$qqrv ; MemFree

	PUBLIC	@Memblock@Copy$qqrrx8Memblockul
	PUBLIC	@Memblock@Copy$qqrrx8Memblock
	PUBLIC	@Memblock@$brsh$qqrrx8Memblock
	PUBLIC	@Memblock@$blsh$qqrrx8Memblock
	PUBLIC	@Memblock@Assign$qqrrx8Memblock
	PUBLIC	@Memblock@Swap$qqrrx8Memblock
	PUBLIC	@Memblock@Set$qqrculul
	PUBLIC	@Memblock@Set$qqrc
	PUBLIC	@Memblock@Char$qqrcul
	PUBLIC	@Memblock@Char$qqrc
	PUBLIC	@Memblock@Compare$qqrrx8Memblock
	PUBLIC	@Memblock@Seek$qqrrx8Memblock
	PUBLIC	@Memblock@Seek$qqrrx8Memblockulul
	PUBLIC	@Memblock@$beql$qqrrx8Memblock
	PUBLIC	@Memblock@$bneq$qqrrx8Memblock
	PUBLIC	@Memblock@$bgeq$qqrrx8Memblock
	PUBLIC	@Memblock@$bleq$qqrrx8Memblock
	PUBLIC	@Memblock@$bgtr$qqrrx8Memblock
	PUBLIC	@Memblock@$blss$qqrrx8Memblock
	PUBLIC	@Memblock@$basg$qqrrx8Memblock

;Global Memory Flags
	GMEM_FIXED		equ	  0000h
	GMEM_MOVEABLE		equ	  0002h
	GMEM_NOCOMPACT		equ	  0010h
	GMEM_NODISCARD		equ	  0020h
	GMEM_ZEROINIT		equ	  0040h
	GMEM_MODIFY		equ	  0080h
	GMEM_DISCARDABLE	equ	  0100h
	GMEM_NOT_BANKED 	equ	  1000h
	GMEM_SHARE		equ	  2000h
	GMEM_DDESHARE		equ	  2000h
	GMEM_NOTIFY		equ	  4000h
	GMEM_LOWER		equ	  GMEM_NOT_BANKED
	GMEM_VALID_FLAGS	equ	  7F72h
	GMEM_INVALID_HANDLE	equ	  8000h
	GHND			equ	  GMEM_MOVEABLE | GMEM_ZEROINIT
	GPTR			equ	  GMEM_FIXED | GMEM_ZEROINIT


;extern memory routines
	EXTRN	GlobalAlloc
	EXTRN	GlobalReAlloc
	EXTRN	GlobalSize
	EXTRN	GlobalFree

	section _TEXT

;void *__stdcall MemCopy(void *dest, void *src, int n)

@Memblock@Resize$qqrul:
Resize:
;@Memblock@$bctr$qqrrx8Memblock:
	;in
	;eax: this
	;edx: memsize
	;out
	;eax: new memory Ptr
	;ecx, edx: destroyed
	push	ebx
	push	esi
	push	edi
	mov	esi, [eax+Memblock.Ptr]
	mov	ebx, eax
	mov	edi, edx
	push	edx
	pushfd
	push	GPTR
	push	edx
	push	esi
	call	GlobalReAlloc
	or	eax, eax
	jnz	short	MemoryReAlloc_exit
;	 call	 GetLastError
;	 cmp	 eax, 8 ;ERROR_NOT_ENOUGH_MEMORY
;	 jnz	 short	 MemoryReAlloc_error
	push	edi
	push	GPTR
	call	GlobalAlloc
	or	eax, eax
	jz	MemoryReAlloc_error
	mov	edi, eax
	popfd
	mov	eax, [esp]
	push	esi
	jc	MemoryReAlloc_1
	mov	ecx, eax
	shr	ecx, 2
	repz	movsd
	and	eax, 3
	jz	MemoryReAlloc_1
	mov	ecx, eax
	repz	movsb
MemoryReAlloc_1:
	call	GlobalFree
	pop	dword ptr[ebx+Memblock.Size]
;	 pop	 eax
MemoryReAlloc_exit:
	pop	edi
	pop	esi
	pop	ebx
	ret
MemoryReAlloc_error:
	stc
	jmp	MemoryReAlloc_exit


@Memblock@$bctr$qqrul:
	;in
	;eax: this
	;ecx: new size
	;out
	;eax: new memory Ptr
	;ecx, edx: destroyed
	push	eax
	push	edx
	push	edx
	push	GPTR
	call	GlobalAlloc
	pop	ecx
	pop	edx
MemoryAlloc_checkerror:
	or	eax, eax
	jz	MemoryAlloc_error
	mov	[edx+Memblock.Ptr], eax
	mov	[edx+Memblock.Size], ecx
	ret
MemoryAlloc_error:
	stc
	ret

@Memblock@$bctr$qqrrx8Memblock:
	;in
	;eax: this
	;ecx: source memblock
	;out
	;eax: new memory Ptr
	;ecx, edx: destroyed
	push	dword ptr[edx+Memblock.Ptr]
	mov	edx, [edx+Memblock.Size]
	call	@Memblock@$bctr$qqrul
;	 pop	 edx
	jc	@Memblock@$bctr$qqrrx8Memblock_error
	xchg	esi, [esp]
	push	edi
;	 mov	 esi, [edx+Memblock.Ptr]
	mov	edi, [eax+Memblock.Ptr]
	jmp	Assign
@Memblock@$bctr$qqrrx8Memblock_error:


@Memblock@$bdtr$qqrv:
	;in
	;eax: memory Ptr to destroy
	;out
	;eax, ecx, edx: destroyed
	push	dword [eax+Memblock.Ptr]
	call	GlobalFree
	jmp	MemoryAlloc_checkerror



@Memblock@Copy$qqrrx8Memblockul:
	;in
	;eax: this
	;edx: destination
	;ecx: count
	cmp	ecx, [eax+Memblock.Size]
	xchg	eax, edx
	jmp	@Memblock@Assign$qqrrx8Memblock_push


@Memblock@$brsh$qqrrx8Memblock:
@Memblock@Copy$qqrrx8Memblock:
	;in
	;eax: this
	;edx: destination
	xchg	eax, edx
;	 jmp	 short @Memblock@Assign$qqrrx8Memblock

@Memblock@$blsh$qqrrx8Memblock:
@Memblock@$basg$qqrrx8Memblock:
@Memblock@Assign$qqrrx8Memblock:
	;in
	;eax: this
	;edx: source
	mov	ecx, [edx+Memblock.Size]
	cmp	ecx, [eax+Memblock.Size]
@Memblock@Assign$qqrrx8Memblock_push:
	push	esi
	push	edi
	mov	esi, [edx+Memblock.Ptr]
	mov	edi, [eax+Memblock.Ptr]
	jnz	short @Memblock@Assign$qqrrx8Memblock_resize
;	 pushf
Assign:
	mov	edx, ecx
	shr	ecx, 2
	rep	movsd
	and	edx, 3
	jz	MemCopy_exit
	mov	ecx, edx
	rep	movsb
MemCopy_exit:
	pop	edi
	pop	esi
;	 popf
	ret
@Memblock@Assign$qqrrx8Memblock_resize:
	mov	edx, ecx
	push	ecx
	stc
	call	Resize
	pop	ecx
	jmp	Assign


;void *__stdcall MemSwap(void *dest, void *src, unsigned int n)
@Memblock@Swap$qqrrx8Memblock:
	;in
	;eax: this
	;edx: Memblock destination
	mov	ecx, [eax+Memblock.Ptr]
	xchg	ecx, [edx+Memblock.Ptr]
	mov	[eax+Memblock.Ptr], ecx
	mov	ecx, [eax+Memblock.Size]
	xchg	ecx, [edx+Memblock.Size]
	mov	[eax+Memblock.Size], ecx
	ret
;	 mov	 ecx, [eax+Memblock.Size]
;	 cmp	 ecx, [edx+Memblock.Size]
;	 jnz	 @Memblock@Swap$qqrrx8Memblock_difsize
;	 pushf
;	 push	 esi
;	 push	 edi
;	 mov	 esi, [edx+Memblock.Ptr]
;	 mov	 edi, [eax+Memblock.Ptr]
;
;
;	 pop	 ecx
;	 pop	 eax
;	 pop	 edx
;	 xchg	 ecx, [esp]
;@MemSwap$qqrpvt1i:
;	 push	 eax
;	 push	 edi
;	 push	 ecx
;	 and	 dword ptr[esp], 3
;	 shr	 ecx, 2
;	 mov	 edi, edx
;	 cmp	 edi, eax
;	 jae	 MemSwap_loop_through
;	 cmp	 eax, [edx + ecx]
;	 jbe	 MemSwap_loop_through
;	 pushf
;	 or	 dword ptr[esp], 400h
;	 popf
;	 lea	 edi, [edi + ecx - 1]
;	 lea	 edx, [edx + ecx - 1]
;MemSwap_loop_back:
;	 jcxz	 MemSwap_loop_back_exit
;	 mov	 eax, [edi]
;	 xchg	 eax, [edx]
;	 sub	 edx, 4
;	 stosd
;	 dec	 ecx
;	 jmp	 MemSwap_loop_back
;MemSwap_loop_back_exit:
;	 pop	 ecx
;	and	ecx, 3
;	 jz	 MemSwap_exit
;MemSwap_loop_back1:
;	mov	al, [edi]
;	 xchg	 al, [edx]
;	 dec	 edx
;	 stosb
;	 loop	 MemSwap_loop_back1
;	 jmp	 MemSwap_exit
;MemSwap_loop_through:
;	 jcxz	 MemSwap_loop_through_exit
;	 mov	 eax, [edi]
;	 xchg	 eax, [edx]
;	 add	 edx, 4
;	 stosd
;	 dec	 ecx
;	 jmp	 MemSwap_loop_through
;MemSwap_loop_through_exit:
;	 pop	 ecx
;	and	ecx, 3
;	 jz	 MemSwap_exit
;MemSwap_loop_through1:
;	 mov	 al, [edi]
;	 xchg	 al, [edx]
;	 inc	 edx
;	 stosb
;	loop	MemSwap_loop_through1
;MemSwap_exit:
;	 pop	 edi
;	 pop	 eax
;	 ret
;@Memblock@Swap$qqrrx8Memblock_difsize:


;void *__stdcall MemSet(void *dest, unsigned char sym, unsigned int n)
@Memblock@Set$qqrculul:
	;in
	;eax: this
	;edx: symbol
	;ecx: index
	;[esp]: count
	push	edi
	mov	edi, ecx
	add	ecx, [esp+8]
	jc	@Memblock@Set$qqrci_sizechecked
	cmp	ecx, [eax+Memblock.Size]
	jbe	@Memblock@Set$qqrci_sizechecked1
	mov	ecx, [eax+Memblock.Size]
	sub	ecx, edi
	jmp	@Memblock@Set$qqrci_sizechecked
@Memblock@Set$qqrci_sizechecked1:
	mov	ecx, [esp+8]
	jmp	@Memblock@Set$qqrci_sizechecked
@Memblock@Set$qqrc:
	push	dword ptr[esp]
	push	edi
	xor	edi, edi
	mov	ecx, [eax+Memblock.Size]
@Memblock@Set$qqrci_sizechecked:
	add	edi, [eax+Memblock.Ptr]
	cmp	ecx, 16
	jb	@Memblock@Set$qqrci_copy
	mov	dh, dl
	shl	edx, 8
	mov	dl, dh
	shl	edx, 8
	mov	dl, dh
	mov	eax, edx
	mov	edx, ecx
	shr	ecx, 2
	rep	stosd
	and	edx, 3
	jz	@Memblock@Set$qqrci_exit
	mov	ecx, edx
@Memblock@Set$qqrci_copy:
	rep	stosb
@Memblock@Set$qqrci_exit:
	pop	edi
	ret	4


;void *__stdcall MemChar(void *dest, char sym, int n)
@Memblock@Char$qqrcul:
	;in
	;eax: this
	;edx: symbol
	;ecx: position
	push	edi
	mov	edi, ecx
	cmp	ecx, [eax+Memblock.Size]
	jbe	@Memblock@Char$qqrc_checked
	jmp	@Memblock@Char$qqrc_error
@Memblock@Char$qqrc:
;@MemChar$qqrpvci:
	push	edi
	xor	edi, edi
@Memblock@Char$qqrc_checked:
;	 add	 edi, ecx
	mov	ecx, [eax+Memblock.Size]
	sub	ecx, edi
	add	edi, [eax+Memblock.Ptr]
	push	dword ptr [eax+Memblock.Ptr]
	mov	eax, edx
;	 sub	 edx, ecx
;	 mov	 ecx, edx
;	 pop	 eax
	repnz	scasb
	jnz	@Memblock@Char$qqrc_error1
	lea	    eax, [edi - 1]
	sub	eax, [esp]
	pop	 edi
	pop	edi
	ret
@Memblock@Char$qqrc_error1:
	pop	eax
	xor	eax, eax
	dec	eax
@Memblock@Char$qqrc_error:
	pop	edi
	stc
	ret


Compare:
	push	esi
	push	edi
	mov	ecx, [eax+Memblock.Size]
	cmp	ecx, [edx+Memblock.Size]
	jb	@Memblock@Comp$qqrrx8Memblock_below
	ja	@Memblock@Comp$qqrrx8Memblock_above
	mov	esi, [edx+Memblock.Ptr]
	mov	edi, [eax+Memblock.Ptr]
	xor	eax, eax
	repz	cmpsb
	pop	edi
	pop	esi
	ret

;int __stdcall MemComp(void *dest, void *src, int n)
@Memblock@Compare$qqrrx8Memblock:
	;in
	;eax: this
	;edx: Memblock destination
	call	Compare
	jz	@Memblock@Comp$qqrrx8Memblock_exit
	jb	@Memblock@Comp$qqrrx8Memblock_below
@Memblock@Comp$qqrrx8Memblock_above:
	inc	eax
	jmp	@Memblock@Comp$qqrrx8Memblock_exit
@Memblock@Comp$qqrrx8Memblock_below:
	dec	eax
@Memblock@Comp$qqrrx8Memblock_exit:
	ret
;void *__stdcall MemSeek(void *dest, void *src, int ndest, int nsrc)
@Memblock@Seek$qqrrx8Memblockulul:
	;in
	;eax: this
	;edx: Memblock destination
	;ecx: index
	;[esp]: count
	cmp	ecx, [eax+Memblock.Size]
	ja	@Memblock@Seek$qqrrx8Memblockulul_exit
	cmp	ecx, [edx+Memblock.Size]
	ja	@Memblock@Seek$qqrrx8Memblockulul_exit
	push	edi
	mov	edi, [esp+4]
	call	Seek
	pop	edi
	ret	4
@Memblock@Seek$qqrrx8Memblockulul_exit:
	lea	eax, [-1]
	ret	4

@Memblock@Seek$qqrrx8Memblock:
	;in
	;eax: this
	;edx: Memblock destination
	push	edi
	xor	ecx, ecx
	call	Seek
	pop	edi
	ret
Seek:
	push	ebx
	push	esi
	push	ebp
	mov	esi, [edx+Memblock.Ptr]
	mov	edi, [eax+Memblock.Ptr]
	push	edi
	add	edi, ecx
;	 mov	 edx, [esp+14h]
;;	  mov	  ecx, [edx+Memblock.Size]
;;	  mov	  edx, [eax+Memblock.Size]
	mov	ecx, [eax+Memblock.Size]
;	 dec	 edx
;	 sub	 ecx, edx
	cmp	ecx, [edx+Memblock.Size]
	jb	MemSeek_large_size
	jz	MemSeek_comp
	mov	edx, [edx+Memblock.Size]
	dec	edx
	sub	ecx, edx
MemSeek_loop:
	mov	al, [esi]
	repnz	scasb
	jnz	MemSeek_not_found
	mov	ebp, edi
	mov	ebx, esi
	inc	esi
	mov	eax, ecx
	mov	ecx, edx
	repz	cmpsb
	mov	esi, ebx
	mov	edi, ebp
	mov	ecx, eax
	jnz	MemSeek_loop
MemSeek_found:
	lea	eax, [edi - 1]
	sub	eax, [esp]
	jmp	MemSeek_exit
MemSeek_comp:
	push	esi
	call	Compare
	pop	eax
	jz	MemSeek_exit
MemSeek_large_size:
MemSeek_not_found:
	xor	eax, eax
	dec	eax
MemSeek_exit:
	pop	edi
	pop	ebp
	pop	esi
	pop	ebx
	ret


@Memblock@$beql$qqrrx8Memblock:
	call	Compare
beql:
	setz	al
	ret
@Memblock@$bneq$qqrrx8Memblock:
	call	Compare
bneq:
	setnz	al
	ret
@Memblock@$bgeq$qqrrx8Memblock:
	call	Compare
	jz	beql
bgeq:
	setnc	 al
	ret
@Memblock@$bleq$qqrrx8Memblock:
	call	Compare
	jz	beql
bleq:
	setc	al
	ret
@Memblock@$bgtr$qqrrx8Memblock:
	call	Compare
	jz	bneq
bgtr:
	setnc	al
	ret
@Memblock@$blss$qqrrx8Memblock:
	call	Compare
blss:
	setc	al
	ret

