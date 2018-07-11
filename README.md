# SQL Server Containers Lab
This is built for Ready 2018 July

## Pre Lab
1. Install docker engine by running the following
```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce
 ```

check status of docker engine
```
systemctl status docker:
 ```

if is not running, start it by running:

``` 
systemctl start docker
```
 
    Note: for this lab, we are installing docker for CentOS, this will work on CentOS or RHEL due to the similarity of the OS’s. For production usage on RHEL, install Docker EE for RHEL:  https://docs.docker.com/install/linux/docker-ee/rhel/.  
 
2. clone this repo by running the following: 

```
git clone https://github.com/vin-yu/ReadyDemo.git 
```
---

## Lab
### 1. Getting started with SQL Server in Container

#### Introduction
In this section you will run SQL Server in a container and connect to it with SSMS/Operational Studio. This is the most common way to get started with SQL Server in containers.  
 
#### Steps
1. Run the following command in your terminal with your own password:
``` 
sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourStrong!Passw0rd' \
      -p 1500:1433 --name sql1 \
      -d microsoft/mssql-server-linux:2017-latest
 ```

> Note: By default, the password must be at least 8 characters long and contain characters from three of the following four sets: Uppercase letters, Lowercase letters, Base 10 digits, and Symbols.
 
2. Connect to SQL Server in container using SSMS or SQL Ops Studio.

Open SSMS or Ops studio and connect to the SQL Server in container instance by connecting to the *host-ip,port*. 

<insert picture>

> Note: The container is listening on port 1500 from the previous example.
 
Run SQLCMD inside the container

    docker exec -it bash sql1
 
> Key Takeaway: 
SQL Server running in a container is the same SQL Server engine as it is on Linux OS or Windows.
 
---

### 2. Explore Docker Basics
#### Introduction
 In this section you'll learn the basics of how to navigate container images and active containers on your host.

#### Steps
Enter the following commands in your terminal.

See the active container instances:
```
Docker ps
```
List all the container instances:
```
Docker ps -a
```
List all container images:
```
Docker image ls
```
Stop the SQL Server container:
```
Docker stop sql1
```
See that `sql1` is no longer running 
```
Docker ps -a
```
Delete the container
```
Docker rm sql1
```
See that the container no longer exists:
```
docker container ls
```


> Key Takeaways:
>
> A container is launched by running an image. An **image** is an executable package that includes everything needed to run an application--the code, a runtime, libraries, environment variables, and configuration files.
>
>A **container** is a runtime instance of an image--what the image becomes in memory when executed (that is, an image with state, or a user process). You can see a list of your running containers with the command, docker ps, just as you would in Linux.
> 
> -- https://docs.docker.com/get-started/
 
---

### 3.  Build your own container 

#### Introduction:
say for testing purposes you want to start the container with the same state. We’ll copy a .bak file into the container.

 
#### Steps:

1. Ensure you are at the base of this project
```
cd < insert >
```

2. Create a Dockerfile with the following contents
```
cat <<EOF>> Dockerfile
FROM microsoft/mssql-server-linux:latest
COPY ./mssql-custom-image-example/SampleDB.bak /var/opt/mssql/data/SampleDB.bak
CMD ["/opt/mssql/bin/sqlservr"]
EOF
```

3. View the contents of the Dockerfile 


4. Run the following docker build -t <docker username>/mssql-with-backup-example
Start the container
sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourStrong!Passw0rd' \
      -p 1500:1433 --name sql1 \
      -d <docker username>/mssql-with-backup-example
Connect and restore the backup:
 

 
Run an app with the container.
 
Introduction/Why: Most applications involve multiple  components to the  application
 
Steps
 
> Takeaway:
 

 ### 4. Run a Containerized Application with SQL Server
 
 
 
 
 
 