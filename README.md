# ece309
# C LLM Harness

## Description

This project implements a simple C-based LLM harness with a local mock model. The program accepts user messages through the terminal, processes the input using predefined rules, and produces a response.

The program maintains a conversation history containing up to five conversation turns. When the history is full and a new message is entered, the oldest conversation turn is removed before the new turn is stored.

## Features

* Accepts user input using `fgets()`
* Responds to messages containing `"hello"`
* Responds to normal text input
* Performs addition
* Performs subtraction
* Performs multiplication
* Performs division
* Detects and handles division by zero
* Supports mathematical expressions such as:

  * `5 + 3`
  * `10 - 4`
  * `6 * 7`
  * `20 / 5`
* Supports word-based mathematical requests such as:

  * `add 5 3`
  * `subtract 10 4`
  * `multiply 6 7`
  * `divide 20 5`
* Maintains a maximum conversation history of five turns
* Removes the oldest conversation turn when the history is full
* Dynamically allocates memory for the conversation history
* Checks whether memory allocation succeeds
* Handles input failure without crashing
* Terminates when the user enters `exit`
* Frees dynamically allocated memory before terminating

## Conversation History

The program stores up to five conversation turns.

Each conversation turn contains:

1. The user's input
2. The model's response

When five conversation turns are already stored and another message is entered, the oldest turn is removed. The remaining four turns are shifted forward, and the new turn is added as the newest entry.

The conversation history is maintained internally by the program and is not directly displayed to the user.

## Mathematical Operations

The calculator supports four operators:

| Operator | Operation      |
| -------- | -------------- |
| `+`      | Addition       |
| `-`      | Subtraction    |
| `*`      | Multiplication |
| `/`      | Division       |

Mathematical expressions must follow the format:

```text
number operator number
```

Examples:

```text
5 + 3
10 - 4
6 * 7
20 / 5
```

The program also accepts word-based operations:

```text
add 5 3
subtract 10 4
multiply 6 7
divide 20 5
```

Results are displayed to two decimal places.

## Division by Zero

Division by zero is not permitted.

If the user enters a division operation where the second number is zero, the program displays an error message instead of performing the calculation.

## Memory Management

The conversation history is dynamically allocated using `malloc()`.

The program checks whether the memory allocation succeeds.

When the program exits normally, the dynamically allocated history is released using `free()`.

## Compilation

The program can be compiled using GCC:

```bash
gcc harness.c -o harness
```

## Running the Program

After compilation, run the executable with:

```bash
./harness
```

The program will then prompt for user input.

Enter `exit` to terminate the program.

## Manual Testing

The following tests can be used to verify the functionality of the program.

### 1. Hello Test

Enter:

```text
hello
```

Verify that the program responds with:

```text
Hello! Nice to meet you.
```

### 2. Normal Text Test

Enter normal text that does not represent a mathematical operation.

Verify that the program responds with:

```text
I received your message: <input>
```

### 3. Addition Test

Enter:

```text
5 + 3
```

Verify that the program returns:

```text
The answer is 8.00
```

### 4. Subtraction Test

Enter:

```text
10 - 4
```

Verify that the program returns:

```text
The answer is 6.00
```

### 5. Multiplication Test

Enter:

```text
6 * 7
```

Verify that the program returns:

```text
The answer is 42.00
```

### 6. Division Test

Enter:

```text
20 / 5
```

Verify that the program returns:

```text
The answer is 4.00
```

### 7. Division by Zero Test

Enter:

```text
10 / 0
```

Verify that the program displays an error message and continues running without crashing.

### 8. Conversation History Test

Enter at least six distinct messages.

For example:

```text
one
two
three
four
five
six
```

The program internally stores a maximum of five conversation turns. After the sixth message is entered, the oldest turn (`one`) should have been removed, leaving:

```text
two
three
four
five
six
```

Because the conversation history is stored internally and is not displayed by the program, this behavior can be verified by inspecting the program's history data during testing.

### 9. Exit Test

Enter:

```text
exit
```

Verify that the program terminates normally and displays:

```text
Program ended.
```

The program should terminate without crashing.
## Automated Testing

The project includes a Bash test script named test.sh that automatically tests the functionality of the harness.c program and performs memory-leak checking using Valgrind.

Before running the test script, give it execute permission:

chmod +x test.sh

Then execute the test script:

./test.sh

The script automatically runs the defined functionality tests and uses Valgrind to check for memory leaks and memory-related errors.

A successful test run should show that the functionality tests pass and that Valgrind reports no memory leaks or memory errors.
## Technologies
* C
* Bash
* GCC
* Valgrind
* Linux / WSL
* GitHub
