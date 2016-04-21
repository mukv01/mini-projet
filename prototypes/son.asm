	; g�n�ration d�un forme d�onde p�riodique avec une fr�quence de 1KHz
#include "hcs12.inc"
	org 	$1500
start 	lds 	#$1500
	bset 	DDRT,BIT5 	; configuration de PT5 comme sortie
forever bset 	PTT,BIT5 	; remettre PT5 � haut
	ldy 	#10 		; attendre 0.5 ms
	jsr 	delayby50us 
	bclr 	PTT,BIT5 	; mettre PT5 � bas
	ldy 	#10 		; attendre 0.5 ms
	jsr 	delayby50us 	
	bra 	forever
	#include "delay.asm"
	end
