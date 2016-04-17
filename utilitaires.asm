; ************************************************************************************
; Auteurs: Vestine Mukeshimana & Arnaud Niyonkuru
; Date: 30/03/2016
; Mini-projet : minuterie à micro-onde
; ************************************************************************************
; Utilitaires :7-segments, son et delai combinés
; ************************************************************************************


; ************************************************************************************
; Cette sous-routine affiche sur les 7 segments dépendamment des variables afficheurs
; Elle dure 600us ou 0.6 ms
; ************************************************************************************
afficher		pshx
			pshy
			psha	
			ldaa	afficheur4		;envoyer le contenu d'afficheur4 sur le 7-segment
			ldx	#chiffre
			movb	a,x PTB
			movb	#POS_AFFICH4 PTP
	
			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	

			ldaa	afficheur3		;envoyer le contenu d'afficheur3 sur le 7-segment
			ldx	#chiffre
			movb	a,x PTB
			movb	#POS_AFFICH3 PTP

			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	

			ldaa	afficheur2		;envoyer le contenu d'afficheur2 sur le 7-segment
			ldx	#chiffre
			movb	a,x PTB
			movb	#POS_AFFICH2 PTP	

			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	

			ldaa	afficheur1		;envoyer le contenu d'afficheur1 sur le 7-segment
			ldx	#chiffre
			movb	a,x PTB
			movb	#POS_AFFICH1 PTP

			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	
		
			pula
			puly
			pulx
			rts
			
; ************************************************************************************
; Cette sous-routine affiche sur les 7 segments END
; Elle dure 600us ou 0.6 ms
; ************************************************************************************
afficherEnd		pshy
			movb	#$79 PTB		;ne rien afficher sur le 7-segment 4
			movb	#POS_AFFICH4 PTP
			
			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	

			movb	#$54 PTB		;envoyer la lettre E sur le 7-segment 3
			movb	#POS_AFFICH3 PTP
			
			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	

			movb	#$5E PTB		;envoyer la lettre n sur le 7-segment 2
			movb	#POS_AFFICH2 PTP

			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	

			movb	#$00 PTB		;envoyer la lettre d sur le 7-segment 1
			movb	#POS_AFFICH1 PTP
			
			ldy 	#3			; attendre 150 us
			jsr 	delayby50us 	
			puly
			rts
			
			
; ************************************************************************************
; Cette sous-routine affiche sur les 7 segments dépendamment des variables afficheurs
; Elle dure 0.6 ms x le nombre de fois dans le registre Y
; ************************************************************************************
delayWithAfficher	pshy	 	
loopdwa			jsr	afficher
			dbne	y, loopdwa
			puly
			rts
			
; ************************************************************************************
; Cette sous-routine fait sonner un son tout en affichant sur sur les 7 segments
; Elle dure 1.2 ms x le nombre de fois dans le registre Y
; ************************************************************************************
soundWithAfficher	pshy
tone			bset 	PTT,BIT5 		; met le PT5 à haut
			jsr	afficher
			bclr 	PTT,BIT5		; met le PT5 à bas
			jsr	afficher
			dbne 	y,tone
			puly
			rts
			
; ************************************************************************************
; Cette sous-routine fait sonner un son tout en affichant END sur sur les 7 segments
; Elle dure 1.2 ms x le nombre de fois dans le registre Y
; ************************************************************************************
soundWithAfficherEnd	pshy
toneE			bset 	PTT,BIT5 		; met le PT5 à haut
			jsr	afficherEnd
			bclr 	PTT,BIT5		; met le PT5 à bas
			jsr	afficherEnd
			dbne 	y,toneE
			puly
			rts