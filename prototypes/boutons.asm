;web_sw_to_led.asm, 11/2006, ref. Dragon12 schematics
;Ignoring bounce issues, echo switch value on LEDs
;PJ1 = 1 enables 7-segment while PJ0 = 0 enables LEDs
;PH0 thru PH7 connected to DIP switches
; but also PH0 thru PH3 are pushbuttons (in parallel)
portb	equ 	$0001 		;LEDs and 7-seg LED port (Refer back to Port Use Slide)
portj	equ 	$0268 		;7-segment and LEDs Enable/Disable
porth	equ 	$0261 		;push button and rocker/DIP switches
portp	equ 	$0258 		;connected to cathodes of 7-segments (DIG0 – DIG3)
ddrb 	equ 	$0003
ddrh 	equ 	$0262
ddrj 	equ 	$026A
ddrp 	equ 	$025A
output 	equ 	$FF
input 	equ 	$00
	org 	$1500
	movb 	#output,ddrj
	movb 	#output,ddrb
	movb	#output,ddrp
	movb 	#input,ddrh
	movb 	#00,portj 	;enables LEDs
	movb 	#$FF,portp 	;turns off 7-seg LED display using DIG0-DIG33
poll 	ldaa 	porth
	staa 	portb
	bra 	poll 		;never ends
	end
