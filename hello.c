#include <stdio.h>

/**
 * Entry point: main
 * Return value: 0 (status code)
 */

int main (void)
{
	int f = 4;
	if(f < 5)
	{
		f = (f <= 6 || f == 0) ? 5 : 4;
		puts("hello world");
	}
	return 0;
}
