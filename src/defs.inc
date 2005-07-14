;[]-----------------------------------------------------------------[]
;|   DEFS.INC -- locale definitions file			     |
;[]-----------------------------------------------------------------[]
;
; $Copyright: 2005$
; $Revision: 1.1.1.1 $
;
	bits 32


%define PUBLIC GLOBAL
%define EXTRN EXTERN
%define endm endmacro
%define proc :
%define near
%define ptr
%define endp
%define tbyte tword
%define offset



%macro	jfe	1
	fstsw	ax
	test	ah, 1000000b
	jnz	%1
%endm


%macro	jfne	1
	fstsw	ax
	test	ah, 1000000b
	jz	%1
%endm


%macro	jfge	1
	fstsw	ax
	test	ah, 1
	jz	%1
%endm


%macro	jfl	1
	fstsw	ax
	test	ah, 1
	jnz	%1
%endm


	section _TEXT use32 public class=code align=16
	section _DATA use32 public class=data align=16
	__SECT__

;structure constants


struc Memblock
.Ptr:	   resd 1
.Size:	   resd 1
endstruc

