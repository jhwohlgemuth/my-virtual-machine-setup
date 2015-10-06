#!/usr/bin/env bash
apt-get update
# Install Java (JRE/JDK)
# ----------------------
echo "Installing JRE and JDK..........."$(date '+%T')
apt-get install -y default-jre default-jdk >/dev/null 2>&1
# Install Pandoc
# --------------
echo "Installing Pandoc................"$(date '+%T')
apt-get install -y texlive texlive-latex-extra pandoc >/dev/null 2>&1
# Miscellaneous Items
# -------------------
echo "Installing miscellaneous items..."$(date '+%T')
apt-get install -y figlet toilet >/dev/null 2>&1