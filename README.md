Computer Organization - Spring 2024
==============================================================
## Iran Univeristy of Science and Technology
## LUMOS RISC-V

- Team Members:Sadra Same(400412274),Hamid Reza Rajab(400412148),Hamid Reza Tizpar(400411306),Mohammad Hosein Sadat(400412256)
- Date:2024.07.03

## Report
- Study the code written in Assembly.S. Explain each section of the code and its purpose in your 
report. Explain where the values are loaded from, steps of the calculation and what register the 
final result is in.

## Answer:
The given assembly code represents a program that performs a series of floating-point operations. Let's break down the code and explain each section:

1. `main:`:
   - This is the entry point of the program.
   - The first instruction, `li sp, 0x3C00`, sets the stack pointer (`sp`) to the address `0x3C00`.
   - The next instruction, `addi gp, sp, 392`, calculates the address of the end of the data block by adding 392 to the stack pointer, and stores the result in the global pointer (`gp`) register.

2. `loop:`:
   - This is the beginning of a loop that performs the following operations:
   - `flw f1, 0(sp)`: Loads the floating-point value at the address pointed to by `sp` into the `f1` register.
   - `flw f2, 4(sp)`: Loads the floating-point value at the address `sp + 4` into the `f2` register.
   - `fmul.s f10, f1, f1`: Multiplies the value in `f1` by itself and stores the result in `f10`.
   - `fmul.s f20, f2, f2`: Multiplies the value in `f2` by itself and stores the result in `f20`.
   - `fadd.s f30, f10, f20`: Adds the values in `f10` and `f20`, and stores the result in `f30`.
   - `fsqrt.s x3, f30`: Calculates the square root of the value in `f30` and stores the result in the `x3` register.
   - `fadd.s f0, f0, f3`: Adds the value in `f3` to the value in `f0` and stores the result back in `f0`.

3. `addi sp, sp, 8`: Increments the stack pointer by 8 bytes, effectively moving to the next pair of floating-point values.
4. `blt sp, gp, loop`: Checks if the stack pointer (`sp`) is less than the global pointer (`gp`). If so, it jumps back to the `loop` label and continues the loop.
5. `ebreak`: This instruction is used to terminate the program.

In summary, this program loads pairs of floating-point values from memory, starting at the address pointed to by the stack pointer (`sp`). It then performs the following operations on each pair:
1. Squares the first value and stores the result in `f10`.
2. Squares the second value and stores the result in `f20`.
3. Adds the squared values and stores the result in `f30`.
4. Calculates the square root of the result and stores it in `x3`.
5. Adds the value in `f3` to the value in `f0` and stores the result back in `f0`.

The program then increments the stack pointer and checks if it has reached the end of the data block (indicated by the global pointer `gp`). If not, it repeats the loop.

The final result of the program is stored in the `f0` register.

## explanation of codes (square root calculator and multiplier)

- square root:

First, we take a copy of the first operand (Co_operand1) so that there is no problem in removing the last bit for the first operand, then we put the last two bits of the copy exactly in the pair variable, to put it next to the subtraction result of the previous step to form the radicand expression Gives. Then we shift the root twice and add it with 01 to get the expression that should be subtracted from the radicand (sbb), then we subtract the radicand from sbb and the result of the current step is obtained (sub-result).
If the obtained result is positive (if (sub_result)), the root value (final expression) is shifted once and added by one, and if the subtraction result is negative, the expression is copied from the subtraction result of the previous step (co_sub_result). we put it in the subtraction result of this step to be used for the next step and we shift the root once so that a zero is added to its LSB.
By doing these steps in the for loop, we reach the correct count number for the final value (root) and set root_ready to 1 to show that the root has been calculated.

- multiplier

First, we spread two operands 1 and 2 into two parts, low bite and hiw bite, so that each part becomes two parts of 16 bits, then by placing them in a programmed way in the Multiplier module, we get the result of four parts of the product.
Now, each of these 4 parts must be shifted to the required value and added together to get the 64-bit result of the main product. For this, the product of each part of the module must be set with a 64-bit reg that is already set to zero. We add and shift the result instead of the product of the modules so that the data is not lost in case of shift.
Finally, by summing these expressions, we get a 64-bit product. We put the result in the result. And we set product_ready to 1 to show that the multiplication is done.

## question2:
Test your project with the LUMOS testing environment.

## result_2:
![picture1](picture1.jpg)
![picture2](picture2.jpg)
![picture3](picture3.jpg)
![picture4](picture4.jpg)
![picture5](picture5.jpg)





