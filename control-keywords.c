#include <stdio.h>
int main() {
   if (1) {
        while (0) {
            do {
                for (int i = 0; i < 1; i++) {
                    switch (i) {
                        case 0:
                            break;
                        default:
                            continue;
                    }
                }
            } while (0);
        }
    } else if (0) {

  } else {
        goto end;
    }
    
    end:
    printf("This program includes all control keywords in C.");
    return 0;
}
