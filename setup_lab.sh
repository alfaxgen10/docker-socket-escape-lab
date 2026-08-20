#!/bin/bash
echo "Setting up the Vulnerable Docker Socket Lab..."
# Pull a basic ubuntu image
docker pull ubuntu:latest
# Run the vulnerable container with the socket exposed
docker run -d --name vulnerable_target -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker ubuntu tail -f /dev/null
echo "Lab deployed! You are ready to begin."
