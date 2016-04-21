#include "hcs12.h"      // les constantes pour les ports
#include "delay.h"      // les fonctionsn(sous-routines) pour les delais
#include "utilitaires.h" // les fonctions (sous-routines) pour afficher sur 7 segments cobinées avec,sons

//variables pour l'état
const int INITIALISATION  = 0;
const int DECALAGE        = 1;
const int DECOMPTE        = 2;
const int PAUSE           = 3;
const int FINAL           = 4;

//port PTH
const int BTN_NONE    = 0b00001111;   //0F 
const int BTN_START   = 0b00000111;   //07 sw2
const int BTN_STOP    = 0b00001011;   //0B sw3
const int BTN_NUMBER1 = 0b00001101;   //0D sw4
const int BTN_NUMBER2 = 0b00001110;   //0E sw5

//port PTP
const int POS_AFFICH1 = 0x37;     //positionner afficheur 4
const int POS_AFFICH2 = 0x3B;     //positionner afficheur 3
const int POS_AFFICH3 = 0x3D;     //positionner afficheur 2
const int POS_AFFICH4 = 0x3E;     //positionner afficheur 1

const int OUTPUT1 = 0xFF;
const int INPUT1  = 0x00;


int afficheur1; //variable pour l'afficheur 1(secondes)
int afficheur2; //variable pour l'afficheur 2(secondes)
int afficheur3; //variable pour l'afficheur 3(minutes)
int afficheur4; //variable pour l'afficheur 4(minutes)

int etat;
int chiffre[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x6F,0x6F,0x6F,0x6F,0x6F,0x6F};

void setup() {
  // put your setup code here, to run once:
  afficheur1 = 0;
  afficheur2 = 0;
  afficheur3 = 0;
  afficheur4 = 0;

  etat = INITIALISATION;

}

void loop() {
  // put your main code here, to run repeatedly:
  afficher(afficheur1,afficheur2,afficheur3,afficheur4);

  int bouton = BTN_START;

  if(bouton == BTN_START) {
    on_start();
  }
  else if(bouton == BTN_STOP) {
    on_stop();
  }
  else if(bouton == BTN_NUMBER1) {
    on_number();
  }
  else if(bouton == BTN_NUMBER2) {
    on_number();
  }
  
  
}


void on_start() {
  if(etat == INITIALISATION) {
    etat_init();
  }
  else if(etat == DECALAGE) {
    etat_decalage();
  }
}

void on_stop() {
}

void on_number() {
  if(etat == INITIALISATION) {
    etat_decalage();
  }
  else if(etat == DECALAGE) {
    etat_decalage();
  }
  else if(etat == PAUSE) {
    etat_pause();
  }
}

void on_none() {
}


void etat_init() {
  etat = INITIALISATION;
  afficheur1 = 0;
  afficheur2 = 0;
  afficheur3 = 0;
  afficheur4 = 0;
}

void etat_decalage() {
  etat = DECALAGE;
}

void etat_decompte() {
  if(afficheur1 == 0 || afficheur2 == 0 || afficheur3 || afficheur4) {
    etat_end();
  }
  else {
    afficheur1 -= 1;
    if(afficheur1 == -1) {
      afficheur1 = 9;
    }


    
  }
}

void etat_pause() {
}

void etat_end() {
  
}

