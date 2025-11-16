#include <stdio.h>
#include <stdlib.h>

#define _CRT_SECURE_NO_WARNINGS

int main() {
    printf("=== 16-bit Signed Overflow Test ===\n\n");

    // 测试用例数组
    struct {
        short a, b;
        char* desc;
    } tests[] = {
        {30000, 10000, "Overflow case (30000 + 10000)"},
        {100, 200, "Normal case (100 + 200)"},
        {20000, 20000, "Boundary case (20000 + 20000)"},
        {-30000, -10000, "Negative overflow (-30000 + -10000)"}
    };

    int numTests = sizeof(tests) / sizeof(tests[0]);

    for (int i = 0; i < numTests; i++) {
        short a = tests[i].a;
        short b = tests[i].b;
        short result;
        unsigned short flags;

        printf("Test %d: %s\n", i + 1, tests[i].desc);
        printf("Input: %d + %d\n", a, b);

        // 内联汇编执行16位加法
        __asm {
            mov ax, a
            add ax, b
            mov result, ax
            pushf
            pop ax
            mov flags, ax
        }

        printf("16-bit result: %d\n", result);
        printf("Flags register: 0x%04X\n", flags);

        // 检查溢出标志
        if (flags & 0x800) {
            printf("*** OVERFLOW DETECTED! OF=1 ***\n");
        }
        else {
            printf("No overflow. OF=0\n");
        }

        // 显示正确的32位结果
        int correct_result = (int)a + (int)b;
        printf("Correct 32-bit result: %d\n", correct_result);

        printf("----------------------------\n\n");
    }

    printf("All tests completed!\n");
    system("pause");
    return 0;
}