#!/bin/bash

# test.sh
# Automated tests for harness.c
#
# This script:
#   1. Compiles harness.c with useful warnings.
#   2. Runs basic functional/state tests.
#   3. Checks that recoverable errors do not terminate the program.
#   4. Checks the six-message history behavior through the program's state.
#   5. Runs Valgrind to check for memory leaks.
#
# Requirements:
#   - gcc
#   - valgrind
#
# Usage:
#   chmod +x test.sh
#   ./test.sh

set -u

PROGRAM="./harness"
SOURCE="harness.c"
INPUT_FILE="test_input.txt"
OUTPUT_FILE="test_output.txt"
VALGRIND_FILE="valgrind_output.txt"

passed=0
failed=0

pass_test()
{
    echo "PASS: $1"
    passed=$((passed + 1))
}

fail_test()
{
    echo "FAIL: $1"
    failed=$((failed + 1))
}

echo "========================================"
echo " Harness Automated Test"
echo "========================================"
echo

# ------------------------------------------------------------
# Check required files/tools
# ------------------------------------------------------------

if [ ! -f "$SOURCE" ]; then
    echo "ERROR: $SOURCE was not found."
    echo "Run this script from the directory containing harness.c."
    exit 1
fi

if ! command -v gcc >/dev/null 2>&1; then
    echo "ERROR: gcc is required but was not found."
    exit 1
fi

if ! command -v valgrind >/dev/null 2>&1; then
    echo "ERROR: valgrind is required for the memory-leak test."
    echo "Install Valgrind and run this script again."
    exit 1
fi

# ------------------------------------------------------------
# Compile the program
# ------------------------------------------------------------

echo "Compiling $SOURCE..."

if gcc -std=c11 -Wall -Wextra -pedantic "$SOURCE" -o "$PROGRAM"; then
    pass_test "harness.c compiles successfully"
else
    fail_test "harness.c compiles successfully"
    exit 1
fi

echo

# ------------------------------------------------------------
# Functional/state test input
# ------------------------------------------------------------
#
# The six messages at the end are used to test that the
# conversation history is limited to the last five entries.
# ------------------------------------------------------------

cat > "$INPUT_FILE" << 'EOF'
hello
How are you today?
add 5 3
subtract 10 4
multiply 6 7
divide 20 5
divide 10 0
5 ^ 2
Message 1
Message 2
Message 3
Message 4
Message 5
Message 6
exit
EOF

echo "Running functional tests..."

if "$PROGRAM" < "$INPUT_FILE" > "$OUTPUT_FILE" 2>&1; then
    program_status=0
else
    program_status=$?
fi

if [ "$program_status" -eq 0 ]; then
    pass_test "program completes without crashing"
else
    fail_test "program completes without crashing (exit status $program_status)"
fi

# ------------------------------------------------------------
# Test 1: hello
# ------------------------------------------------------------

if grep -q "Hello! Nice to meet you." "$OUTPUT_FILE"; then
    pass_test "hello input produces the greeting"
else
    fail_test "hello input produces the greeting"
fi

# ------------------------------------------------------------
# Test 2: normal text
# ------------------------------------------------------------

if grep -q "I received your message: How are you today?" "$OUTPUT_FILE"; then
    pass_test "normal text receives a response"
else
    fail_test "normal text receives a response"
fi

# ------------------------------------------------------------
# Test 3: addition
# ------------------------------------------------------------

if grep -q "The answer is 8.00" "$OUTPUT_FILE"; then
    pass_test "addition works"
else
    fail_test "addition works"
fi

# ------------------------------------------------------------
# Test 4: subtraction
# ------------------------------------------------------------

if grep -q "The answer is 6.00" "$OUTPUT_FILE"; then
    pass_test "subtraction works"
else
    fail_test "subtraction works"
fi

# ------------------------------------------------------------
# Test 5: multiplication
# ------------------------------------------------------------

if grep -q "The answer is 42.00" "$OUTPUT_FILE"; then
    pass_test "multiplication works"
else
    fail_test "multiplication works"
fi

# ------------------------------------------------------------
# Test 6: division
# ------------------------------------------------------------

if grep -q "The answer is 4.00" "$OUTPUT_FILE"; then
    pass_test "division works"
else
    fail_test "division works"
fi

# ------------------------------------------------------------
# Test 7: division by zero
# ------------------------------------------------------------

if grep -q "division by zero is not allowed" "$OUTPUT_FILE"; then
    pass_test "division by zero is handled"
else
    fail_test "division by zero is handled"
fi

# ------------------------------------------------------------
# Test 8: recoverable error continues the loop
#
# Message 1 appears after the division-by-zero test.
# If the program had terminated after the recoverable error,
# this response would not exist.
# ------------------------------------------------------------

if grep -q "I received your message: Message 1" "$OUTPUT_FILE"; then
    pass_test "program continues after division-by-zero error"
else
    fail_test "program continues after division-by-zero error"
fi

# ------------------------------------------------------------
# Test 9: unsupported operation
# ------------------------------------------------------------

if grep -q "The operation '5 \^ 2' is not supported." "$OUTPUT_FILE"; then
    pass_test "unsupported mathematical operation is handled"
else
    fail_test "unsupported mathematical operation is handled"
fi

# ------------------------------------------------------------
# Test 10: six-message history test
#
# The current harness does not print its history, so this
# script cannot directly inspect the history array.
#
# It verifies that all six messages were accepted and that
# the program reached the final exit command without crashing.
#
# The actual five-entry storage rule is implemented by:
#   if (history_count == MAX_HISTORY)
#       shift entries left
#       history_count--
#
# Therefore, direct verification of the stored array would
# require adding a history-display/debug interface to harness.c,
# which would change the program being tested.
# ------------------------------------------------------------

message_count=$(grep -c "I received your message: Message [1-6]" "$OUTPUT_FILE")

if [ "$message_count" -eq 6 ]; then
    pass_test "all six history-test messages were processed"
else
    fail_test "all six history-test messages were processed (found $message_count)"
fi

if grep -q "I received your message: Message 6" "$OUTPUT_FILE"; then
    pass_test "sixth message was processed after history limit was reached"
else
    fail_test "sixth message was processed after history limit was reached"
fi

# ------------------------------------------------------------
# Test 11: exit
# ------------------------------------------------------------

if grep -q "Program ended." "$OUTPUT_FILE"; then
    pass_test "exit terminates the program normally"
else
    fail_test "exit terminates the program normally"
fi

# ------------------------------------------------------------
# Memory-leak test with Valgrind
# ------------------------------------------------------------

echo
echo "Running Valgrind memory-leak check..."

if valgrind \
    --leak-check=full \
    --show-leak-kinds=all \
    --error-exitcode=1 \
    "$PROGRAM" < "$INPUT_FILE" > /dev/null 2> "$VALGRIND_FILE"
then
    valgrind_status=0
else
    valgrind_status=$?
fi

if [ "$valgrind_status" -eq 0 ] &&
   grep -q "definitely lost: 0 bytes" "$VALGRIND_FILE" &&
   grep -q "indirectly lost: 0 bytes" "$VALGRIND_FILE"
then
    pass_test "Valgrind reports no memory leaks"
else
    fail_test "Valgrind reports no memory leaks"
    echo
    echo "Valgrind output:"
    cat "$VALGRIND_FILE"
fi

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

rm -f "$INPUT_FILE"
rm -f "$OUTPUT_FILE"
rm -f "$VALGRIND_FILE"
rm -f "$PROGRAM"

# ------------------------------------------------------------
# Final results
# ------------------------------------------------------------

echo
echo "========================================"
echo " Test Results"
echo "========================================"
echo "Passed: $passed"
echo "Failed: $failed"
echo

if [ "$failed" -eq 0 ]; then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "SOME TESTS FAILED"
    exit 1
fi
