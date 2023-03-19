#include <stdio.h>

int main()
{
	if (1)
	{
		while (0)
		{
			for (int i = 0; i < 1; i++)
			{
				switch (i)
				{
					case 0:
					break;
					default:
					continue;
				}
			}
		}
    } else 
		{
			goto end;
		}
    
		end:
		printf("This program includes all control keywords in C.");
		return 0;
	}

