# cs152_phase3_part1
**Project Phase 3 Specifications**

In this phase of the project, we were first tasked with taking a syntactically-correct program and ensuring it contains no semantic errors. We were then tasked with generating this program’s corresponding intermediate code. For this project, the intermediate code will be in MIL code. This MIL code can then be executed to run the compiled program. We have gotten segmentation faults at times but we are not sure why that is. We managed to get it to work for the project demo.

For our project, we were able to implement code generation on only Arrays of Integers and If-then-else statements. 

Our GitHub repository has not been recently updated because one of our team members has not been able to have access to it. Because of this, we have been transferring and collaborating on all of our files through Discord. This is to ensure that the commit history does not imply that he did not participate in this project. In this file, we want to make clear that everyone participated in this project. We have discussed this issue with the TA since Week 1 of this quarter, but he was unable to fix the issue nor provide us with any feedback on the problem. 

The following is a link to a temporary GitHub Repository that we created so that all team members were able to view the files.

Link: 

The following link is our demo video that shows all of our test cases being successful. Each test case can be executed and produce the correct results.

Link: https://youtu.be/cdhMPbZg7VE

In the next two sections of this file, we will be providing the instructions needed to compile the source code to build the compiler. We will also be discussing the language features that we implemented in our project with concrete examples. 

**Instructions**

In this section, we will be providing the instructions needed to compile the source code in order to build our compiler. The following steps are the instructions.

Check that  Bison and Flex are installed
make
cat if_test.min | parser
mil_run code.mil
cat array_test.min | parser
mil_run code.mil
make clean

**Language Features**

In this section, we will be indicating the language features that we implemented. We will also provide examples of these features. 

One language feature that we implemented are Mathematical Operators. The following is a list of these operators.

Mathematical Operators:
It (integer)
- (subtraction)
+ (addition)
* (multiplication)
/ (division)
% (mod)
= (assignment)
arr (array)
of (of)

Here is an example of how you can use the “It” datatype, the subtraction operator, as well as the multiplication operator.
Example:
It num = 5;
It num2 = num * num - num (num would equal 20)

Another language feature that we implemented are Comparison Operators. The following is a list of these operators. 

Comparison Operators:
== (equivalency)
!= (not equivalent)
< (less than)
> (greater than)
<= (less than or equal to)
>= (greater than or equal to)
and (and)
or (or)

Other language features that we implemented are Functions, Loops, and Conditionals. The following is a list of these features.

Functions, loops, and etc
; : , ( ) [ ] (colons and parentheses)
if (if statement declaration)
then (then)
fi (ends if statement)
elif (else)
begin_l (begins loop)
end_l (ends loop)
func (function declaration)
bp (begin parameters)
ep (end parameters)
bl (begin locals in function)
el (end locals in functions)
bb (begin body of function)
eb (end body of function)

Example:
func example;
 bp 
it temp;
 ep
bl 
it temp2 = 1;
el
bb 
while(temp > 0) begin_l;
if temp2 % 2 == 0 then 
temp2 = temp2 - 1 ;
elif
temp = temp - 1;
fi
end_l
eb

example(10);
