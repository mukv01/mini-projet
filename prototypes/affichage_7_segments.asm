	#include "hcs12.inc"
	org 	$1500
start 	lds 	#$1500
	movb 	#$FF,DDRB 	; configuration du port B
	movb 	#$3F,DDRP 	; configuration du port P
forever ldx 	#DispTab 	; X pointe vers le tableau à afficher
loopi 	movb 	1,X+	PTB 	; sortie du schéma de segments
	movb 	1,X+	PTP 	; sélection de l’afficheur
	ldy 	#1
	jsr 	delayby1ms 	; attend 1 ms
	cpx 	#DispTab+8 	; fin du tableau?
	bne 	loopi
	bra 	forever
	#include "delay.asm"
DispTab dc.b 	$7D, $37 	; écrire 6=$7D sur afficheur 4
	dc.b 	$06, $3B 	; écrire 1=$06 sur afficheur 3
	dc.b 	$3F, $3D 	; écrire 0=$3F sur afficheur 2
	dc.b 	$5B, $3E 	; écrire 2=$5B sur afficheur 1
	end
