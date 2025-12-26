#!/bin/bash

# Script to find all Dart files still using Material Icons
echo "=== Files still using Material Icons ==="
echo ""

# Find all .dart files with Icons. usage (excluding LucideIcons)
grep -r "Icons\." lib/ --include="*.dart" | grep -v "LucideIcons" | cut -d: -f1 | sort -u

echo ""
echo "=== Total count ==="
grep -r "Icons\." lib/ --include="*.dart" | grep -v "LucideIcons" | cut -d: -f1 | sort -u | wc -l

echo ""
echo "=== Files still using elevation ==="
grep -r "elevation:" lib/ --include="*.dart" | grep -v "elevation: 0" | cut -d: -f1 | sort -u

echo ""
echo "=== Files still using boxShadow ==="
grep -r "boxShadow:" lib/ --include="*.dart" | cut -d: -f1 | sort -u
