#include <stdio.h>

/**
* main - The entry point into the program
* 
* Return: Always Return int
*/

void print_nth_fibon (unsigned int limit);

int main(void)
{
    unsigned long fibon_array [50];
    unsigned int nth_fibon = 50;

    print_nth_fibon(nth_fibon, &fibon_array);
    return (0);
}

void print_nth_fibon (unsigned int limit, unsigned long* &fibon_array)
{
    fibon_array[0] = 0;

    if (limit >= 2)
    {
        fibon_array[1] = 1;
        printf("%lu, %lu",fibon_array[0],fibon_array[1]);
    }
    size_t vind = 2;
    unsigned long x = 1;

    while(vind < limit)
    {
        if(x == fibon_array[vind -1] + fibon_array[vind - 2])
        {
            fibon_array[vind] = x;
            printf(", %lu",x);
            vind++;
        }
        x++;
    }
}