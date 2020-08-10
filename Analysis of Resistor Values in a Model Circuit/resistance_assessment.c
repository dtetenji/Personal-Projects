/*MY REG Number: 170171168*//*3fca4542-30fa-46aa-ab53-24d992da2a46.*/
#include <stdio.h>
#include <math.h>
#define ten 10
#define average 1
#define standard_dev 2
#define largest 3


float mean(float b[],int a)/*this function is for calculating mean: b carries the users input for the  values while a carries the size of the array*/
{float mean1,sum=0;int i;
for (i=0;i<a;i++)
 {
sum += b[i] ;
}
mean1=(float) sum/a;
return(mean1);
}

float sd(float bs[],int as,float ms)/*this function is for calculating the standard deviation bs for the values , as for the size and ms for the mean of the values*/
{float sd1,sum=0;int i;
for(i=0;i<as;i++)
{
sum += (bs[i]-ms)*(bs[i]-ms);
}

sd1=sqrt(sum/--as);
return(sd1);
}

void sort(float *b3, int n3)
{float sort1;
int f,g,h;float var;
for(f=0;f<n3-1;f++)
{
	for(g=n3;g>f;g--)
{
	if (b3[g-1]<b3[g])
{
var=b3[g-1];
b3[g-1]=b3[g];
b3[g]=var;
}
}
	
}
	
}

void display (float bv[], int nv );

/*idea gotten from lecture 10 of the handout written by "Peter Judd"*/

int main (void)
{
int n,i=0,op,rob=0; char end;float x[ten],m,s,high;
char bust[ten];
/*the first do while loop is to enable the user to come back and rerun the program*/
do {
     printf("\n this is a program used to analyse statistical data for a group of resistors\n");
do{

	printf("\n Enter value for the number of resistors you want to analyse btw 2 & 10\n");
	gets(bust);/*when you use 'gets' you can overwrite the array*/
		rob=sscanf(bust,"%d",&n);
	if (rob!=1)
	printf("\nerror try again : ");
}while (rob !=1);/*this do while loop is for robust programming*/

	if(n>=2&&n<=10)/*this is to make sure that user enters a value in an acceptable range*/
	
	{
	for(i=0;i<n;i++)/*This for loop enables the user to input the values of the resistors in the correct range into the array*/
	{	
	do{
		rob=0;
	printf("\n Enter the values of your number %d resistor between 0.001 & 1000000 ohms,if value entered is not in range you will be asked to re-enter it.\n ",i+1);
	gets(bust);
	  rob=sscanf(bust,"%f",&x[i]);
	  if (rob !=1)
	  printf("\nerror Try again: ");
	    }while(rob!=1);/*this do while loop is for robust programming*/
	    if(x[i]>=0.001 && x[i]<=1000000)/*This is for range checking*/
	      continue;
	      else
	      {printf("\nerror");
	      i--;	
		  }
	}
	for (i=0;i<n;i++)/*This loop displays the users input in an organised manner*/
{
display (x,i);
	
}
	

do{

printf("\npress 1 for mean value , 2 for standard deviation value and 3 for largest value of resistor");
scanf("%d",&op);
switch(op)
{
case average:	
printf("\n you have chosen to calculate mean");
m=mean(x,n);
printf("\nThe value of the mean is %8.5f",mean(x,n));
break;	
case standard_dev:
	m=mean(x,n);
	s=sd(x,n,m);
	printf("\nThe standard Deviation for your set of resistors is %8.5f",s);
break;	
case largest:

sort(x,n);
printf("\nThe highest number of the resistors is %8.5f",x[0]);
break;	
default:
printf("\nerror, you did not pick a valid operation");	
}
printf("\nif you want to get more statitical data on your resistors press y ");
scanf(" %c",&end);
}while(end=='Y'||end=='y');/*this do while loop helps user to go back and perform another statistical operation on his values*/
}
 else 
printf("\n error");

printf("\npress letter o if you want to rerun program ");
scanf(" %c",&end);
}while ((end=='O')||(end=='o'));/*to check if the user wants to continue*/
/*we can now sell this bad boy of a program to microsoft and make millions :)*/ 
system ("PAUSE");
return(0);
}
 
 
 
 void display (float bv[],int nv)
 {if (bv[nv]>=0.001 && bv[nv]<1)
	{
	
			printf("the value of the number %d resistor entered is %8.3f m OHMS\n",nv+1,bv[nv]*1000);
	}
	
	else if(bv[nv]>=1 && bv[nv]<1000)
	{
	
		printf("the value of the number %d resistor entered is %8.3f OHMS\n",nv+1,bv[nv]);
	}
	
	else if(bv[nv]>=1000 && bv[nv]<100000)
	{
		printf("the value of the number %d resistor entered is %8.3f K OHMS\n",nv+1,bv[nv]/1000);
	}
	
	else if(bv[nv]>=100000 && bv[nv]>=1000000)
	{
	
		printf("the value of the number %d resistor entered is %8.3f M OHMS\n",nv+1,bv[nv]/1000000);
	}
	
 }

