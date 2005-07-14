;[]-----------------------------------------------------------------[]
;|   MEMUTILS.ASM -- memory class functions			     |
;[]-----------------------------------------------------------------[]
;
; $Copyright: 2005$
; $Revision: 1.1.1.1 $
;

	%include 'defs.inc'

	GLOBAL _mainCRTStartup
;	 GLOBAL decimal_constant

	section _TEXT

_mainCRTStartup:
	mov	eax, [dataskl]
	mov	eax, 1
	ret	0ch

	section _DATA
dataskl:	dd	0