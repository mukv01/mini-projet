; ***************************************************************************
; Author: Dr. Han-Way Huang
; Date: 07/18/2004
; Organization: Minnesota State University, Mankato
; ***************************************************************************
; The following function creates a time delay which is equal to the multiple
; of 50 us. The value passed in Y specifies the number of milliseconds to be
; delayed.
; ***************************************************************************
delayby50us movb	#$90,TSCR1		; enable TCNT & fast flags clear
	movb	#$02,TSCR2 	; configure prescale factor to 4
	movb	#$01,TIOS		; enable OC0
	ldd 	TCNT
again0	addd	#300		; start an output compare operation
	std	TC0		; with 1 ms time delay
wait_lp0	brclr	TFLG1,$01,wait_lp0
	ldd	TC0
	dbne	y,again0
	rts
; ***************************************************************************
; The following function creates a time delay which is equal to the multiple
; of 1 ms. The value passed in Y specifies the number of milliseconds to be
; delayed.
; ***************************************************************************
delayby1ms movb	#$90,TSCR1		; enable TCNT & fast flags clear
	movb	#$06,TSCR2 	; configure prescale factor to 64
	movb	#$01,TIOS		; enable OC0
	ldd 	TCNT
again1	addd	#375		; start an output compare operation
	std	TC0		; with 1 ms time delay
wait_lp1	brclr	TFLG1,$01,wait_lp1
	ldd	TC0
	dbne	y,again1
	rts
; ***************************************************************************
; The following function creates a time delay which is equal to the multiple
; of 10 ms. The value passed in Y specifies the number of 10 milliseconds
; to be delayed.
; ***************************************************************************
delayby10ms movb	#$90,TSCR1		; enable TCNT & fast flags clear
	movb	#$06,TSCR2 	; configure prescale factor to 64
	movb	#$01,TIOS		; enable OC0
	ldd 	TCNT
again2	addd	#3750		; start an output compare operation
	std	TC0		; with 10 ms time delay
wait_lp2	brclr	TFLG1,$01,wait_lp2
	ldd	TC0
	dbne	y,again2
	rts
; ***************************************************************************
; The following function creates a time delay which is equal to the multiple
; of 100 ms. The value passed in Y specifies the number of 100 milliseconds
; to be delayed.
; ***************************************************************************
delayby100ms movb	#$90,TSCR1		; enable TCNT & fast flags clear
	movb	#$06,TSCR2 	; configure prescale factor to 64
	movb	#$01,TIOS		; enable OC0
	ldd 	TCNT
again3	addd	#37500		; start an output compare operation
	std	TC0		; with 100 ms time delay
wait_lp3	brclr	TFLG1,$01,wait_lp3
	ldd	TC0
	dbne	y,again3
	rts


