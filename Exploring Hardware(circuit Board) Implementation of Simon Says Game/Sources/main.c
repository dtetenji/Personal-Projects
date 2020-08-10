/* ###################################################################
**     Filename    : main.c
**     Project     : Assignment1
**     Processor   : MKL25Z128VLK4
**     Version     : Driver 01.01
**     Compiler    : GNU C Compiler
**     Date/Time   : 2018-11-15, 09:06, # CodeGen: 0
**     Abstract    :
**         Main module.
**         This module contains user's application code.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file main.c
** @version 01.01
** @brief
**         Main module.
**         This module contains user's application code.
*/         
/*!
**  @addtogroup main_module main module documentation
**  @{
*/         
/* MODULE main */


/* Including needed modules to compile this module/procedure */
#include "Cpu.h"
#include "Events.h"
#include "red.h"
#include "TU1.h"
#include "green.h"
#include "blue.h"
#include "TU2.h"
#include "TSS1.h"
/* Including shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
/* User includes (#include below this line is not maintained by Processor Expert) */
int pos,x=0,ispressed,run=1,col=5,c,c1[100],q=0,h=49;
int i,i2[50]={50},i3,i4,i5,i6,i7,n=5,a[100],a2[100],b1[100],p=0,o,k;
void torq()/*function to set pwms to give torquoise colour*/
{
	blue_SetRatio16(blue_DeviceData,10000);
	  green_SetRatio16(green_DeviceData,10000);
	   red_SetRatio16(red_DeviceData,0);
}
void orange()/*this function produces the colour orange*/
{
	 green_SetRatio16(green_DeviceData,12000);
	  red_SetRatio16(red_DeviceData,65000);
	    blue_SetRatio16(blue_DeviceData,0);
}
void yellow()
{
	 green_SetRatio16(green_DeviceData,40000);
	  red_SetRatio16(red_DeviceData,60000);
	    blue_SetRatio16(blue_DeviceData,0);
}
void g()/*gives a green colour*/
{
  green_SetRatio16(green_DeviceData,60000);
  red_SetRatio16(red_DeviceData,0);
    blue_SetRatio16(blue_DeviceData,0);

}
void r()/*gives a red colour*/
{
   red_SetRatio16(red_DeviceData,60000);
   blue_SetRatio16(blue_DeviceData,0);
  green_SetRatio16(green_DeviceData,0);
}
void b()/*gives a bluecolour*/
{ blue_SetRatio16(blue_DeviceData,60000);
green_SetRatio16(green_DeviceData,0);
red_SetRatio16(red_DeviceData,0);
}
void purp()/*gives a purple colour*/
{
	blue_SetRatio16(blue_DeviceData,30000);
	green_SetRatio16(green_DeviceData,0);
	red_SetRatio16(red_DeviceData,30000);
}

void w()/*gives a white colour*/
{
	blue_SetRatio16(blue_DeviceData,30000);
		  green_SetRatio16(green_DeviceData,30000);
		   red_SetRatio16(red_DeviceData,30000);
}
void off()/*turns off all the pwms*/
{ blue_SetRatio16(blue_DeviceData,0);
green_SetRatio16(green_DeviceData,0);
 red_SetRatio16(red_DeviceData,0);
}

void input()/*this function records the users input and gives out put based on the location where the user touches the board with red green blue corresponding to left middle and right.*/
{orange(); waitms(5000);
	ispressed=0;
	TSS1_Configure();
	c=4;
	while (c==4)
	{
	while(ispressed<2 )
	{

	for(;;){

	TSS_Task();
if (TSS1_cKey0.Position >= 1 && TSS1_cKey0.Position <= 15)
	  	  {c=2;break;
	  	  }
	  else if(TSS1_cKey0.Position >15 && TSS1_cKey0.Position <= 47)
	  	  {c=0;break;
	  	  }
	  	  else if (TSS1_cKey0.Position > 47)
	  	  {c=1;break;}


		}
	}
	}
	switch(c){
		case 0 : g();
			break;
		case 1 : b();
			break;
		case 2 : r();
			break;
		default:torq();
			waitms(1000);
			break;
	}



	  pos=TSS1_cKey0.Position;

}


void waitms(int wait_ms)/*this function acts as a software system timer interrupt used in most parts of the program to keep the program running when LEDs light up.*/
{
	unsigned int i,j;
	for(i=0;i<wait_ms;i++){
		for(j=0;j<785;j++) {
			__asm("nop");
		}

	}
}
void colors()/*this function based on the random number sequence created in the main shows colours g for green, b for blue and r for red. torquiouse if the random number function fails*/
{
	purp(); waitms(3000);
	off(); waitms(2000);


for(i=0;i<n;i++){
switch (a[i])
{case 0:
	 g(); waitms(1000);
	 off(); waitms(1000);
break;
case 1:
	 b(); waitms(1000);
	 off(); waitms(1000);
break;
case 2 :
	 r(); waitms(1000);
	 off(); waitms(1000);
break;
default:
	 torq(); waitms(5000);
	 break;
}

	}
}
void colrem()/*this is a function created to remove colours from an already created sequence.*/
{
	purp(); waitms(3000);
	off(); waitms(2000);
srand(pos);
do {
	do{

   	i= rand()%n;/*this line randomly selects a location in the random colour array*/
	  }while(i==i2[h]||i==i2[h-1]||i==i2[h-2]||i==i2[h-3]||i==i2[h-4]||i==i2[h-5]);/*for this loop i2 is initialized to a number outside range of our use. it is there to specifically check and make sure that our locations chosen randomly to select remove the colours is always unique!!*/
       	/*this  then stores the removed color number code to be used in the check function after the users input.*/
	b1[q]=a[i];
	i2[h]=i;

	q++;
    if(q==1)
	{i3=i2[h];}
   	if (q==2)
   	{i2[h-1]=i3;i4=i2[h];}
	if (q==3)
   	{i2[h-2]=i2[h-1];i2[h-1]=i4;i5=i2[h];}
	if (q==3)
   	{i2[h-3]=i2[h-2];i2[h-2]=i2[h-1];i2[h-1]=i5;i6=i2[h];}
	if (q==4)
   	{i2[h-4]=i2[h-3];i2[h-3]=i2[h-2];i2[h-2]=i2[h-1];i2[h-1]=i6;i7=i2[h];}
	if (q==5)
	{i2[h-5]=i2[h-4];i2[h-4]=i2[h-3];i2[h-3]=i2[h-2];i2[h-2]=i2[h-1];i2[h-1]=i7;}
   	a[i]=4;/*this line then forces the location that is uniquely randomly selected to become white*/
   }while(q<n-4);

q=0;
for(i=0;i<n;i++){
switch (a[i])
{case 0:
	 g(); waitms(1000);
	 off(); waitms(1000);
break;
case 1:
	 b(); waitms(1000);
	 off(); waitms(1000);
break;
case 2 :
	 r(); waitms(1000);
	 off(); waitms(1000);
break;
default:
	 w(); waitms(1000);
off(); waitms(1000);
	 break;
}
	}
}
void carryon()/*this function allows the user to play the game by increasing the length of the sequence each time the user gets one right and also resets the random array that was created first to keep the colours from initial round.*/
{
	n++;
	srand(pos);
	a2[n-1]=rand()%3;
	for(i=0;i<n;i++)
	{
		a[i]=a2[i];
	}
}
void check()/*This function calls for the user to input their solution as well as check to see if they are right or wrong. */
{
for(k=0;k<n-4;k++)
{ input();waitms(2000);
c1[k]=c;
off(); waitms(2000);
}

for(k=0;k<n-4;k++){
if 	(b1[k]!=c1[k])
	{o++;
	}
}
if (o>0)
{ p=2;yellow(); waitms(2000);

	}
else
{p=1;
carryon();
	}


}

/*lint -save  -e970 Disable MISRA rule (6.3) checking. */
int main(void)
/*lint -restore Enable MISRA rule (6.3) checking. */
{
  /* Write your local variable definition here */

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/

  /* Write your code here */
while(x==0)/*This allows the game to run again after the users failure after a while.*/
{
o=0;
off(); waitms(3000);/*This turns off all the lights at the start of the game and the wait function beside it makes it wait for 3 seconds before the start of the game. */
orange(); waitms(2000);/* this is to show the user that the system is waiting for their input */
input();waitms(3000);
/*this waits for the user to touch the slider to start the game.*/
srand(pos);
for( i = 0 ; i < n ; i++ )/*this first sequence creates a random sequence by seeding the position where the user touched initially */
{  	a[i]= rand() % 3;}
for(i=0;i<n;i++)/*this sequence stores the initially created random sequence for use in a later point*/
{
	a2[i]=a[i];
}

do{
colors();/*this displays the colors with respect to our random numbers*/
colrem();/*this calls the color remove function*/
check();/*this then calls the function check to check the users input.*/
//waitms(6000);
o=0;
 }while(p==1);

torq(); waitms(2000);/*This shows the end of a loop and symbolises the begining of another round without having to reset the board.*/
n=5;

};



  /*** Don't write any code pass this line, or it will be deleted during code generation. ***/
  /*** RTOS startup code. Macro PEX_RTOS_START is defined by the RTOS component. DON'T MODIFY THIS CODE!!! ***/
  #ifdef PEX_RTOS_START
    PEX_RTOS_START();                  /* Startup of the selected RTOS. Macro is defined by the RTOS component. */
  #endif
  /*** End of RTOS startup code.  ***/
  /*** Processor Expert end of main routine. DON'T MODIFY THIS CODE!!! ***/
  for(;;){}
  /*** Processor Expert end of main routine. DON'T WRITE CODE BELOW!!! ***/
} /*** End of main routine. DO NOT MODIFY THIS TEXT!!! ***/

/* END main */
/*!
** @}
*/
/*
** ###################################################################
**
**     This file was created by Processor Expert 10.5 [05.21]
**     for the Freescale Kinetis series of microcontrollers.
**
** ###################################################################
*/
