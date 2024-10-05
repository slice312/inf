#!/bin/bash

sudo dnf update
sudo dnf group install -y 'Development Tools'
sudo dnf install -y nc
sudo dnf install -y telnet
sudo dnf install -y jq
      # TODO: yaml query yq
      # TODO: tree
sudo dnf install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd