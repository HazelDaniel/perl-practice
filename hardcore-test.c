#include <stdio.h>

int main (){
if( 1){
while( 0 ){
do {
for( int i=0; i<1; i++ ){
int i = 0;
float j = i + 1;
switch ( i) {
case 0:
return 0;
case 3:
return 3;
default:
return 2;
}
}
} while(0);
}
 
} 
else{
goto end;
}

end:
printf("This program includes all control keywords in C.");
return 0;
}

int largest_number (int a, int b, int c){
int largest;

if (a>b&&a>c){
largest = a;
}
else if (b>a&&b>c)
{
largest = b;
}
else
{
largest = c;
}
return (largest);
}
