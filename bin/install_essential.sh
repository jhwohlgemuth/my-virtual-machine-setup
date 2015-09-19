#!/usr/bin/env bash
printf "Installing essential software..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y make >/dev/null 2>&1
sudo apt-get install -y curl >/dev/null 2>&1
sudo apt-get install -y build-essential >/dev/null 2>&1

# Install Java (JRE/JDK)
printf "Installing JRE and JDK..."
sudo apt-get install -y default-jre >/dev/null 2>&1
sudo apt-get install -y default-jdk >/dev/null 2>&1