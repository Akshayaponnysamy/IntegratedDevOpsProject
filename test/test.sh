#!/bin/sh

echo "Running application test..."

if [ -f index.html ]; then
    echo "TEST PASSED: index.html exists."
else
    echo "TEST FAILED: index.html not found."
    exit 1
fi

if grep -q "Integrated DevOps Project" index.html; then
    echo "TEST PASSED: Application title found."
else
    echo "TEST FAILED: Application title not found."
    exit 1
fi

echo "All tests passed successfully."
