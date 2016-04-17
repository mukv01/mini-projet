; ***************************************************************************
; Auteurs: Vestine Mukeshimana & Arnaud Niyonkuru
; Date: 30/03/2016
; Mini-projet : minuterie à micro-onde
; ***************************************************************************
; Programme pour simuler la minuterie à micro-onde
; ***************************************************************************
		#include "hcs12.inc"
INITIALISATION	equ	0			;constantes pour l'état
DECALAGE	equ	1
DECOMPTE	equ	2
PAUSE		equ	3
FINAL		equ	4

BTN_NONE	equ	%00001111		;0F 
BTN_START	equ	%00000111		;07 sw2
BTN_STOP	equ	%00001011		;0B sw3
BTN_NUMBER1	equ	%00001101		;0D sw4
BTN_NUMBER2	equ	%00001110		;0E sw5

POS_AFFICH1	equ	$37			;positionner afficheur 4
POS_AFFICH2	equ	$3B			;positionner afficheur 3
POS_AFFICH3	equ	$3D			;positionner afficheur 2
POS_AFFICH4	equ	$3E			;positionner afficheur 1

OUTPUT		equ	$FF
INPUT		equ	$00

		org 	$1000			;début des données
afficheur1	ds.b	1			;variable pour l'afficheur 1(secondes)
afficheur2	ds.b	1			;variable pour l'afficheur 2(secondes)
afficheur3	ds.b	1			;variable pour l'afficheur 3(minutes)
afficheur4	ds.b	1			;variable pour l'afficheur 4(minutes)

etat		ds.b	1			;variable pour l'état
chiffre		dc.b	$3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F,$6F,$6F,$6F,$6F,$6F,$6F

		org	$1500			;début du programme
		lds	#$1500			;initialisation de la pile
		
		movb 	#01,PTJ 		;1 active les afficheurs 7-segments et 0 active les LEDs
		movb	#INPUT,DDRH		;configuration du port A comme entrée (switches)
		movb 	#OUTPUT,DDRB 		;configuration du port B comme sortie (afficheurs)
		movb 	#$3F,DDRP 		;configuration du port P comme sortie (afficheurs)
		bset 	DDRT,BIT5 		;configuration de PT5 comme sortie (son)
		
		clr	afficheur1		;initialiser à 0
		clr	afficheur2		;initialiser à 0
		clr	afficheur3		;initialiser à 0
		clr	afficheur4		;initialiser à 0
		
		movb	#INITIALISATION	etat
forever		jsr	afficher
		ldaa	PTH			;lecture des boutons
		anda	#$0F
		
		cmpa	#BTN_START		;identifier le bouton appuyé	
		beq	on_start
		cmpa	#BTN_STOP			
		beq	on_stop
		cmpa	#BTN_NUMBER1			
		beq	on_number
		cmpa	#BTN_NUMBER2			
		beq	on_number
		bra	on_none
on_start	ldaa	etat
		cmpa	#INITIALISATION		;identifier l'état dépendamment du bouton appuyé
		beq	etat_init
		cmpa	#DECALAGE
		lbeq	etat_decompte
		cmpa	#DECOMPTE
		lbeq	etat_decompte
		cmpa	#PAUSE
		lbeq	etat_decompte
		bra	forever
on_stop		ldaa	etat
		cmpa	#INITIALISATION		;identifier l'état dépendamment du bouton appuyé
		beq	etat_init
		cmpa	#DECALAGE
		beq	etat_init
		cmpa	#DECOMPTE
		lbeq	etat_pause
		cmpa	#PAUSE
		beq	etat_init
		bra	forever
on_number	ldaa	etat
		cmpa	#INITIALISATION		;identifier l'état dépendamment du bouton appuyé
		beq	etat_decalage
		cmpa	#DECALAGE
		beq	etat_decalage
		cmpa	#DECOMPTE
		beq	etat_decompte
		cmpa	#PAUSE
		lbeq	etat_pause
		bra	forever
on_none		ldaa	etat			;identifier l'état quand aucun bouton n'est appuyé
		cmpa	#DECOMPTE
		beq	etat_decompte
		bra	forever
etat_init	movb	#INITIALISATION	etat
		clr	afficheur1		;initialiser à 0
		clr	afficheur2		;initialiser à 0
		clr	afficheur3		;initialiser à 0
		clr	afficheur4		;initialiser à 0
		
		lbra	forever
etat_decalage	movb	#DECALAGE etat
		ldaa	PTH
		lsra
		lsra
		lsra
		lsra
		
		movb	afficheur3 afficheur4 	;décaller les digits
		movb	afficheur2 afficheur3
		movb	afficheur1 afficheur2
		staa	afficheur1
		
		ldy 	#50 			;son court (60ms)
		jsr	soundWithAfficher
		
		ldy	#1567			;940ms = 1567 x 0.6ms
		jsr	delayWithAfficher

		lbra	forever
etat_decompte	movb	#DECOMPTE etat
		ldab	#$0			;vérifier si la décompte est à 0
		addb	afficheur1
		addb	afficheur2
		addb	afficheur3
		addb	afficheur4
		cmpb	#0
		beq	etat_final
		dec    	afficheur1		;afficheur1 -= 1
		ldab   	afficheur1
		cmpb	#-1
		bne	wait1sec
		ldab	#9
		stab	afficheur1
		dec    	afficheur2		;afficheur2 -= 1
		ldab   	afficheur2
		cmpb	#-1
		bne	wait1sec
		ldab	#5
		stab	afficheur2
		dec    	afficheur3		;afficheur3 -= 1
		ldab   	afficheur3
		cmpb	#-1
		bne	wait1sec
		ldab	#9
		stab	afficheur3
		dec    	afficheur4		;afficheur4 -= 1
		ldab   	afficheur4
		cmpb	#-1
		bne	wait1sec
		ldab	#5
		stab	afficheur4
wait1sec	ldy 	#50 			;son court (60ms)
		jsr	soundWithAfficher
		
		ldy	#1567			;940ms = 1567 x 0.6ms
		jsr	delayWithAfficher
		lbra	forever
etat_pause	movb	#PAUSE etat
		ldy 	#50 			;son court (60ms)
		jsr	soundWithAfficher
		
		ldy	#1567			;940ms = 1567 x 0.6ms
		jsr	delayWithAfficher
		lbra 	forever
etat_final	movb	#FINAL etat
		ldy 	#833 			;sonner la 1ere fois (1000ms)
		jsr	soundWithAfficherEnd
		ldy	#5					;silence de 500ms
		jsr	delayby100ms
		ldy 	#833 			;sonner la 2e fois (1000ms)
		jsr	soundWithAfficherEnd
		lbra	etat_init
		swi
		#include "delay.asm"	
		#include "utilitaires.asm"	
		end