#!/usr/bin/env bash

# Install Jenkins
# Jenkins will be launched as a daemon up on start. See /etc/init.d/jenkins for more details.
# The 'jenkins' user is created to run this service.
# Log file will be placed in /var/log/jenkins/jenkins.log. Check this file if you are troubleshooting Jenkins.
# /etc/default/jenkins will capture configuration parameters for the launch like e.g JENKINS_HOME
printf "Preparing to install Jenkins CI Server..."
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - >/dev/null 2>&1
sudo sh -c 'printf deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
printf "Installing Jenkins CI Server..."
sudo apt-get install -y jenkins >/dev/null 2>&1
