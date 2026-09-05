
I need to write a simple command-line program in C. I am a beginner, so please keep the code as simple as possible. Do not use external libraries, only standard ones like <stdio.h> and <string.h>. Here is the specification for the program: 1. It should run an infinite while loop that asks for user input using fgets. 2. If the user types 'exit', the loop should break and the program should end. 3. If the user types a sentence containing the word 'hello', the program should print a hardcoded greeting. 4. If the user types anything else, it should echo their input back to them. 5. Please add clear, line-by-line comments explaining what the code is doing."  6. This should model a harness for an LLM without access to a true LLm

Yes. Since you're modeling this as a simple LLM harness, the basic structure is:

user input → simple pattern matching → hardcoded response

Here is a beginner-friendly C implementation:

#include <stdio.h>
#include <string.h>

int main(void)
{
    // Create a character array to store the user's input.
    char input[100];

    // Keep running forever until we explicitly break out of the loop.
    while (1)
    {
        // Ask the user to enter some text.
        printf("You: ");

        // Read a line of text from the user.
        // fgets() also stores the newline character if there is room.
        fgets(input, sizeof(input), stdin);

        // Remove the newline character from the end of the input.
        input[strcspn(input, "\n")] = '\0';

        // Check if the user entered exactly "exit".
        if (strcmp(input, "exit") == 0)
        {
            // Leave the while loop.
            break;
        }

        // Check if the input contains the word "hello".
        // strstr() returns NULL if "hello" was not found.
        if (strstr(input, "hello") != NULL)
        {
            // Print the hardcoded response.
            printf("LLM: Hello! Nice to meet you.\n");
        }
        else
        {
            // If no special command was recognized,
            // simply echo the user's input back.
            printf("LLM: %s\n", input);
        }
    }

    // The loop ended because the user typed "exit".
    printf("LLM: Goodbye!\n");

    // Return 0 to indicate that the program ended successfully.
    return 0;
}
Example
You: hello
LLM: Hello! Nice to meet you.

You: hello there, how are you?
LLM: Hello! Nice to meet you.

You: What is the weather?
LLM: What is the weather?

You: This is a test
LLM: This is a test

You: exit
LLM: Goodbye!

The important part for your LLM harness model is this section:

if (strcmp(input, "exit") == 0)
{
    break;
}

if (strstr(input, "hello") != NULL)
{
    printf("LLM: Hello! Nice to meet you.\n");
}
else
{
    printf("LLM: %s\n", input);
}

This is essentially a very primitive input → processing → output pipeline. Later, you could replace the if/else section with a function that sends input to an actual LLM API, while keeping the overall fgets()/loop structure largely the same.

Absolutely. I’ll explain the code against each specification, without changing the code.

1. Use standard C only

The program uses only:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

These are all standard C libraries.

<stdio.h> provides printf(), fgets(), and sscanf().
<stdlib.h> provides malloc() and free().
<string.h> provides strcpy(), strcmp(), strstr(), and strcspn().

There are no external libraries or third-party dependencies.

2. The program must be compiled in a POSIX environment

The program uses standard C functionality and does not depend on Windows-specific functionality.

There are no things such as:

#include <windows.h>

or Windows-specific system calls.

Therefore, the source is suitable for compilation in a POSIX environment with a standard C compiler such as GCC.

For example:

gcc main.c -o main

The program itself does not require any special operating-system features.

3. Only simple standard libraries

This requirement is met by the four includes at the top:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

No networking, API, JSON, threading, or other external libraries are included.

4. Keep the program simple and readable

The program uses relatively basic C concepts:

while loop
if / else if / else
arrays
structures
functions
pointers
malloc() / free()
fgets()
sscanf()
basic string functions

The program is separated into only a few logical pieces:

main()
calculator()
is_expression()
mock_model()

The more complicated behavior is contained in mock_model(), while the actual arithmetic is isolated in calculator().

5. Clear comments

The code contains comments explaining the important operations.

For example:

/*
 * Remove the newline character added by fgets().
 */
input[strcspn(input, "\n")] = '\0';

and:

/*
 * If the history is already full, remove the
 * oldest conversation turn.
 */

The comments are intended to explain what the code is doing and why, which is particularly useful for a beginner-level project.

Original input-loop requirements
6. The program starts in main()

The entry point is:

int main(void)
{

This is where the program allocates its history and begins the input loop.

7. Prompt the user for input

Inside the loop:

printf("You: ");

This displays the prompt before every user message.

8. Read input using fgets()

The program uses:

if (fgets(input, sizeof(input), stdin) == NULL)
{
    printf("Error: Failed to read input.\n");
    break;
}

This satisfies the requirement to use fgets().

It also handles the possibility that fgets() fails.

Instead of continuing with invalid input and potentially causing problems, the program prints an error and leaves the loop.

9. Remove the newline

fgets() normally stores the newline when the user presses Enter.

The program removes it with:

input[strcspn(input, "\n")] = '\0';

So if the user enters:

hello

the string stored in input becomes:

hello\0

rather than containing the newline.

This is important because otherwise:

strcmp(input, "exit")

would not recognize exit\n as "exit".

10. Check for "exit"

The program checks:

if (strcmp(input, "exit") == 0)
{
    break;
}

If the user enters exactly:

exit

the break terminates the while loop.

The program then frees its allocated memory and exits normally.

Conversation history
11. Store the user's message in conversation history

The history is represented by:

struct Conversation
{
    char input[MAX_INPUT];
    char response[MAX_INPUT];
};

Each entry therefore contains both:

user input
model response

The user's message is stored with:

strcpy(history[history_count].input, input);

So the user message is saved before the mock model is called.

12. At least the last 5 inputs and responses are saved

The program defines:

#define MAX_HISTORY 5

and allocates:

history = malloc(MAX_HISTORY * sizeof(struct Conversation));

Therefore, the program has room for five conversation turns.

When the fifth slot is full and another message arrives, this code executes:

if (history_count == MAX_HISTORY)
{
    int i;

    for (i = 0; i < MAX_HISTORY - 1; i++)
    {
        history[i] = history[i + 1];
    }

    history_count--;
}

This moves:

Turn 2 → Turn 1
Turn 3 → Turn 2
Turn 4 → Turn 3
Turn 5 → Turn 4

Then the new conversation becomes Turn 5.

So the oldest conversation is discarded and the most recent five turns remain.

Each turn contains both an input and response, so the history stores:

5 inputs + 5 corresponding responses.

13. Pass input/history to the mock model

The program calls:

mock_model(input,
           history,
           history_count,
           response);

This passes four things to the mock model:

The current user input
The conversation history
The number of stored history entries
The array where the model should put its response

The function definition is:

void mock_model(char input[],
                struct Conversation history[],
                int history_count,
                char response[])

So the mock model has access to the conversation history rather than only seeing the current message.

Mock model requirements
14. It must NOT call an actual LLM

The program does not make any API calls or network connections.

Instead, mock_model() consists entirely of local C rules:

if (...)
{
    ...
}
else if (...)
{
    ...
}
else
{
    ...
}

Therefore, it is genuinely a local mock model.

15. "hello" produces a hardcoded greeting

The first rule in mock_model() is:

if (strstr(input, "hello") != NULL)
{
    strcpy(response, "Hello! Nice to meet you.");
    return;
}

strstr() searches the input for "hello".

Therefore:

hello

or:

hello there

will produce:

Hello! Nice to meet you.

The response is hardcoded rather than generated by an actual language model.

Calculator requirements
16. Simple mathematical expressions are supported

The function:

int is_expression(char input[])

checks whether the input can be interpreted as:

number operator number

For example:

5 + 3
10 - 4
6 * 7
20 / 5

It does this using:

sscanf(input, "%lf %c %lf",
       &number1, &operator, &number2)

If three values can be extracted—a number, an operator, and another number—it identifies the input as a possible expression.

17. The calculator supports addition

Inside calculator():

if (operator == '+')
{
    *result = number1 + number2;
    return 1;
}

So:

5 + 3

produces:

8.00
18. The calculator supports subtraction
if (operator == '-')
{
    *result = number1 - number2;
    return 1;
}

For example:

10 - 4

produces:

6.00
19. The calculator supports multiplication
if (operator == '*')
{
    *result = number1 * number2;
    return 1;
}

For example:

6 * 7

produces:

42.00
20. The calculator supports division
if (operator == '/')
{
    if (number2 == 0)
    {
        return 0;
    }

    *result = number1 / number2;
    return 1;
}

Normal division is performed when the denominator isn't zero.

For example:

20 / 5

produces:

4.00
21. No other mathematical functionality is supported

The calculator only recognizes:

+
-
*
/

At the end of calculator():

return 0;

is reached if the operator isn't one of those four.

Therefore things such as:

5 ^ 2
sqrt 25
sin 5
5 %

are not supported by the calculator.

22. Unsupported operations are reported instead of crashing

For a recognized expression with an unsupported operator, this section runs:

else
{
    sprintf(response,
            "The operation '%s' is not supported.",
            input);
}

For example:

You: 5 ^ 2
Model: The operation '5 ^ 2' is not supported.

The program continues running afterward.

23. Calculator can be requested using words

The specification says the calculator should be reachable by asking for an operation, not just entering an expression.

The program supports:

add 5 3
subtract 10 4
multiply 6 7
divide 20 5

This section detects those requests:

if (sscanf(input, "add %lf %lf", &number1, &number2) == 2)
{
    operator = '+';
}
else if (sscanf(input, "subtract %lf %lf",
                &number1, &number2) == 2)
{
    operator = '-';
}

and similarly for multiplication and division.

The operation is then passed to the same calculator() function.

This means there is one calculator implementation, regardless of how the user requested the calculation.

Error handling
24. fgets() failure

The program explicitly checks:

if (fgets(input, sizeof(input), stdin) == NULL)
{
    printf("Error: Failed to read input.\n");
    break;
}

If fgets() fails, the program doesn't attempt to process invalid input.

It reports the error and exits the loop cleanly.

25. Failed memory allocation

The program dynamically allocates the history:

history = malloc(MAX_HISTORY * sizeof(struct Conversation));

Immediately afterward, it checks:

if (history == NULL)
{
    printf("Error: Could not allocate memory for conversation history.\n");
    return 1;
}

If allocation fails, the program does not attempt to access the nonexistent history array.

It reports the error and terminates.

26. Memory cleanup

At the end of the program:

free(history);
history = NULL;

This releases the memory allocated by malloc().

Setting the pointer to NULL afterward makes it clear that the memory should no longer be accessed.

As mentioned earlier, standard C's free() does not provide a return value that can be checked for a "free failure," so cleanup is performed normally.

27. Division by zero

There are actually two places where division by zero is prevented.

For direct expressions:

if (operator == '/' && number2 == 0)
{
    sprintf(response,
            "The operation '%s' is not supported because division by zero is not allowed.",
            input);
    return;
}

And for requests such as:

divide 10 0

the same check is performed.

This means the actual calculator is never allowed to execute:

number1 / 0

The program instead gives the user an error response and continues running.

28. The response is printed

After mock_model() finishes:

printf("Model: %s\n", response);

This displays whatever response the mock model generated.

29. The response is stored in history

Immediately afterward:

strcpy(history[history_count].response, response);

So the response is saved alongside the user's original input.

For example:

You: 5 + 3
Model: The answer is 8.00

becomes conceptually:

History:
    input:    "5 + 3"
    response: "The answer is 8.00"
30. The loop continues

Finally:

history_count++;

is executed and the program reaches the end of the while loop.

It returns to:

printf("You: ");

and waits for another input.

The only normal way to leave that loop is:

exit

or an input failure.

Overall specification mapping

The complete program therefore follows this sequence:

                    main()
                      |
                      v
                Prompt user
                      |
                      v
                   fgets()
                      |
                      v
              Remove newline
                      |
                      v
                Is "exit"?
                 /       \
               YES        NO
                |          |
                v          v
              Exit     Save input
                           |
                           v
                     mock_model()
                           |
              +------------+------------+
              |            |            |
            hello      calculation   anything else
              |            |            |
              v            v            v
          greeting     calculator    simple response
                           |
                           v
                    Save response
                           |
                           v
                    Repeat loop

So the current version meets the specified mini-harness architecture, while keeping the "LLM" intentionally simple and local. The calculator acts as the program's one mock tool, and both normal model responses and calculator interactions become part of the five-turn conversation memory.

For all error handling, if the error is recoverable, we should not terminate the program. For all inputs from the user as well, we should always give a response and keep the loop repeating to get another user input. We should ONLY EVER terminate if the error is unrecoverable.

Exactly. That means the program should follow a simple rule:

Only an unrecoverable error should terminate the program. Every recoverable error should produce a response and return to the input loop.

For your current specifications, this means:

Situation	Recoverable?	What program should do
Invalid/unsupported user input	Yes	Give a response and ask for another input
Unsupported math operation	Yes	Explain it isn't supported and continue
Division by zero	Yes	Explain the error and continue
fgets() failure	Generally no	Terminate because the program cannot reliably receive further input
Initial malloc() failure	No	Terminate because conversation history cannot be created
free() cleanup	N/A	Clean up and terminate normally; standard C doesn't provide a failure status from free()
User enters exit	Not an error	Terminate normally
One important distinction

The "exit" input is not an error. It is the user's explicit request to terminate, so the loop should still break there.

For everything else, including something like:

You: divide 5 0
Model: The operation 'divide 5 0' is not supported because division by zero is not allowed.
You: 

the program must remain inside the loop.

Likewise:

You: 5 ^ 2
Model: The operation '5 ^ 2' is not supported.
You:

and:

You: this is some random message
Model: I received your message: this is some random message
You:

all continue normally.

So the overall control flow you want is:

START
  |
  v
Get user input
  |
  +-- fgets fails --> UNRECOVERABLE --> END
  |
  v
Check "exit"
  |
  +-- yes --> END
  |
  v
Store input
  |
  v
Mock model
  |
  +-- invalid input -----------+
  +-- unsupported operation ---+
  +-- divide by zero ----------+--> Give response --> Store response
  +-- normal input ------------+
                                      |
                                      v
                               Get next input

This is consistent with the code we have already discussed: the calculator errors and unsupported inputs return a response from mock_model() rather than terminating main(). The only normal loop-breaking cases are the explicit "exit" and an unrecoverable fgets() failure.

Can you give me a list of manual tests to prove functionality, these tests should include:
Entering hello; Entering normal text, Entering a string that indicates addition, testing subtraction, testing multiplication, testing division, testing division by zero, entering at least 6 messages and verifying only the last 5 have been stored, entering exit and verifying the program terminates without crashing.

Absolutely. Here is a manual test plan you can use to demonstrate that each required part of the program works.

Manual Functionality Tests
Test #	Test	Input	Expected Result
1	Hello message	hello	Program responds with the hardcoded greeting, such as Hello! Nice to meet you. Program continues asking for input.
2	Normal text	How are you today?	Program responds with a message indicating it received the user's message. Program continues asking for input.
3	Addition	add 5 3	Program calls the calculator and displays The answer is 8.00. Program continues.
4	Subtraction	subtract 10 4	Program calls the calculator and displays The answer is 6.00. Program continues.
5	Multiplication	multiply 6 7	Program calls the calculator and displays The answer is 42.00. Program continues.
6	Division	divide 20 5	Program calls the calculator and displays The answer is 4.00. Program continues.
7	Division by zero	divide 10 0	Program displays an error indicating division by zero is not supported. Program does not terminate and prompts for another input.
8	Mathematical expression	8 + 2	Program recognizes the expression, calls the calculator, and displays The answer is 10.00.
9	Unsupported operation	5 ^ 2	Program responds that the operation is not supported. Program does not terminate.
10	Six-message history test	Enter six separate messages	After the sixth message, verify that only the five most recent input/response pairs remain in the conversation history. The oldest message should have been removed.
11	Exit	exit	Program leaves the input loop, frees allocated memory, prints Program ended., and terminates normally without crashing.
Test 10 — Specifically Testing the 5-Message History

For a clear demonstration, enter these six messages in order:

Message 1
Message 2
Message 3
Message 4
Message 5
Message 6

After the sixth message, the history should contain:

Message 2
Message 3
Message 4
Message 5
Message 6

and Message 1 should no longer be stored.

Since each history entry contains both the user's input and the model's response, the stored history should consist of the five most recent input/response pairs, not merely five individual strings.

Test 11 — Termination Test

After performing the other tests, enter:

exit

Expected behavior:

The program recognizes exit.
It leaves the while loop.
Allocated conversation-history memory is freed.

The program prints:

Program ended.
The program terminates normally.
There is no crash or segmentation fault.

These tests collectively demonstrate the normal inputs, all four supported calculator operations, calculator error handling, history limit, continued operation after recoverable errors, and clean termination.
