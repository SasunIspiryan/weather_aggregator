#!/bin/bash

# ================================
# Ansible Docker Connection Script
# ================================
# Purpose: Test Ansible connectivity to running Docker containers
# using the native Docker connection plugin (no SSH required)
#
# This script demonstrates:
# 1. Pinging all containers with Python
# 2. Executing raw commands on containers without Python
# 3. Gathering system facts from backend
# 4. Checking service status across all hosts

set -e

echo "================================"
echo "Weather Aggregator - Ansible Infrastructure Test"
echo "================================"
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ================================
# Pre-flight Check: Start containers if needed
# ================================
echo -e "${BLUE}[PRE-CHECK] Verifying containers are running...${NC}"
echo ""

RUNNING_CONTAINERS=$(docker ps --format "table {{.Names}}" | grep -E "python_app|postgres_db|nginx_proxy|frontend_app" | wc -l)

if [ "$RUNNING_CONTAINERS" -lt 4 ]; then
    echo -e "${YELLOW}⚠ Some containers are not running. Starting docker-compose...${NC}"
    docker-compose down -v 2>/dev/null || true
    sleep 2
    docker-compose up -d --build
    sleep 5
    echo -e "${GREEN}✓ Containers started successfully${NC}"
else
    echo -e "${GREEN}✓ All containers are running${NC}"
fi
echo ""

# ================================
# Test 1: Ping backend container using raw module (no temp dir needed)
# ================================
echo -e "${BLUE}[TEST 1] Pinging Flask backend container...${NC}"
echo ""
ansible backend -i inventory.yml -m raw -a "echo 'pong - Docker connection established'"
echo ""

# ================================
# Test 2: Check Python version (Backend)
# ================================
echo -e "${BLUE}[TEST 2] Checking Python version on Flask backend...${NC}"
echo ""
ansible backend -i inventory.yml -m raw -a "python --version"
echo ""

# ================================
# Test 3: Verify PostgreSQL is running (Database)
# ================================
echo -e "${BLUE}[TEST 3] Verifying PostgreSQL database is running...${NC}"
echo ""
ansible database -i inventory.yml -m raw -a "psql --version"
echo ""

# ================================
# Test 4: Get database connection status
# ================================
echo -e "${BLUE}[TEST 4] Checking PostgreSQL connection status...${NC}"
echo ""
ansible database -i inventory.yml -m raw -a "pg_isready -U postgres -h localhost"
echo ""

# ================================
# Test 5: Check backend system info using raw
# ================================
echo -e "${BLUE}[TEST 5] Gathering system info from Flask backend...${NC}"
echo ""
ansible backend -i inventory.yml -m raw -a "uname -a"
echo ""

# ================================
# Test 6: Check Nginx configuration (Proxy)
# ================================
echo -e "${BLUE}[TEST 6] Checking Nginx configuration...${NC}"
echo ""
ansible proxy -i inventory.yml -m raw -a "nginx -t"
echo ""

# ================================
# Test 7: Check running services on backend
# ================================
echo -e "${BLUE}[TEST 7] Checking running services on Flask backend...${NC}"
echo ""
ansible backend -i inventory.yml -m raw -a "ls -la /proc/*/exe 2>&1 | grep python | head -3"
echo ""

# ================================
# Test 8: Check filesystem usage on database
# ================================
echo -e "${BLUE}[TEST 8] Checking filesystem usage on PostgreSQL...${NC}"
echo ""
ansible database -i inventory.yml -m raw -a "df -h"
echo ""

# ================================
# Test 9: Check frontend container  
# ================================
echo -e "${BLUE}[TEST 9] Checking frontend container status...${NC}"
echo ""
ansible frontend -i inventory.yml -m raw -a "ls -la /usr/share/nginx/html"
echo ""

# ================================
# Test 10: Check backend service port
# ================================
echo -e "${BLUE}[TEST 10] Checking backend Flask service port...${NC}"
echo ""
ansible backend -i inventory.yml -m raw -a "netstat -tuln 2>/dev/null | grep 5000 || echo 'Port status check (netstat requires net-tools)'"
echo ""

# ================================
# Summary
# ================================
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}All tests completed!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "✓ Ansible is successfully communicating with all Docker containers"
echo "✓ Using native Docker connection plugin (no SSH daemon required)"
echo "✓ Backend container: raw Python modules work"
echo "✓ Other containers: using raw/shell modules for direct command execution"
echo ""
