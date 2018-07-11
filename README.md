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
 
>Note: for this lab, we are installing docker for CentOS, this will work on CentOS or RHEL due to the similarity of the OS’s. For production usage on RHEL, install Docker EE for RHEL:  https://docs.docker.com/install/linux/docker-ee/rhel/.  
 
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

Open SSMS or Ops studio and connect to the SQL Server in container instance by connecting host:

```
http:<host IP>:1500
```
>Note: If you are running this in an Azure VM, the host IP is the Azure VM IP. You will also need to open port 1500 external traffic.


3. Run SQLCMD inside the container

```
# docker execute command 'bash' inside 'sql1' container 
docker exec -it bash sql1

/opt/mssql-tools/bin/sqlcmd -U SA -P YourStrong!Passw0rd

```

> **Key Takeaway**
> 
>SQL Server running in a container is the same SQL Server engine as it is on Linux OS or Windows.
 
---

### 2. Explore Docker Basics
#### Introduction
 In this section you'll learn the basics of how to navigate container images and active containers on your host.

#### Steps
Enter the following commands in your terminal.

See the active container instances:
```
sudo docker ps
```
List all the container instances:
```
sudo docker ps -a
```
List all container images:
```
sudo docker image ls
```
Stop the SQL Server container:
```
sudo docker stop sql1
```
See that `sql1` is no longer running: 
```
sudo docker ps -a
```
Delete the container:
```
sudo docker rm sql1
```
See that the container no longer exists:
```
sudo docker container ls
```


> **Key Takeaway**
>
> A container is launched by running an image. An **image** is an executable package that includes everything needed to run an application--the code, a runtime, libraries, environment variables, and configuration files.
>
>A **container** is a runtime instance of an image--what the image becomes in memory when executed (that is, an image with state, or a user process). You can see a list of your running containers with the command, docker ps, just as you would in Linux.
> 
> -- https://docs.docker.com/get-started/
 
---

### 3.  Build your own container 

#### Introduction:
In the past, if you were to set up a new SQL Server environment or dev test, your first order of business was to install a SQL Server onto your machine. But, that creates a situation where the environment on your machine might not match test/production.

With Docker, you can get SQL Server as an image, no installation necessary. Then, your build can include the base SQL Server image right alongside any additional environment needs, ensuring that your SQL Server instance, its dependencies, and the runtime, all travel together.

In this section you will build your a own container layered on top of the SQL Server image. 

Scenario: Let's say for testing purposes you want to start the container with the same state. We’ll copy a .bak file into the container which can be restored with T-SQL.  

 
#### Steps:

1. Ensure you are at the base of this project
```
cd <path to git folder>/mssql-custom-image-example
```

2. Create a Dockerfile with the following contents
```
cat <<EOF>> Dockerfile
FROM microsoft/mssql-server-linux:latest
COPY ./SampleDB.bak /var/opt/mssql/data/SampleDB.bak
CMD ["/opt/mssql/bin/sqlservr"]
EOF
```

3. View the contents of the Dockerfile 

```
cat Dockerfile
```

<insert image for contents of Dockefile>

4. Run the following to build your
```
docker build . -t mssql-with-backup-example
```
5. Start the container 
```
sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourStrong!Passw0rd' \
      -p 1500:1433 --name sql2 \
      -d mssql-with-backup-example
```

6. View the contents of the backup file built in the image:

```
   sudo docker exec -it sql2 /opt/mssql-tools/bin/sqlcmd -S localhost \
   -U SA -P '1234qwerASDF' \
   -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/data/SampleDB.bak"' \
   -W \
   | tr -s ' ' | cut -d ' ' -f 1-2
```

6. Restore the backup:
```
      sudo docker exec -it sql2 /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P '1234qwerASDF' \
   -Q 'RESTORE DATABASE ProductCatalog FROM DISK = "/var/opt/mssql/data/SampleDB.bak" WITH MOVE "ProductCatalog" TO "/var/opt/mssql/data/ProductCatalog.mdf", MOVE "ProductCatalog_log" TO "/var/opt/mssql/data/ProductCatalog.ldf"'

```

if you connect to the instance, you should see that the instance was restored.

<insert image of restored database here>

> **Key Takeaway**
>
> A **Dockerfile** defines what goes on in the environment inside your container. Access to resources like networking interfaces and disk drives is virtualized inside this environment, which is isolated from the rest of your system, so you need to map ports to the outside world, and be specific about what files you want to “copy in” to that environment. However, after doing that, you can expect that the build of your app defined in this Dockerfile behaves exactly the same wherever it runs.
>
> -- https://docs.docker.com/get-started/part2/#your-new-development-environment
---

 ### 4. Run a Containerized Application with SQL Server
 
 #### Introduction
  
Most applications involve multiple containers. 

#### Steps

1. change directory to the mssql-aspcore-example

```
cd <path to git folder>/mssql-aspcore-example 
```

2. Open the docker-compose.yml file 
```
nano docker-compose.yml
```

3. Edit the SQL Server environment variables then save the file with `ctrl + x`

<insert images>

4. Run the containers with docker-compose:
```
docker-compose up
```
>note: this will take approx. 15 seconds


5. At this point, you will have two containers up and running: an application container that is able to query the database container. Connect to the 

```
http:<host IP>:5000
```
>Note: If you are running this in an Azure VM, the host IP is the Azure VM IP. You will also need to open port 5000 external traffic.

To stop the docker compose application, press `ctrl + c` in the terminal. 
To remove the containers run the following command:

```
docker-compose down
```


### Start-up Explanation

1. Running `docker-compose up` builds/pulls containers and run them with parameters defined in docker-compose.yml
2. The .Net Core application container starts up  
3. The SQL Server container starts up with `entrypoint.sh`

    a. The sqlservr process starts 

    b. A start script is run to apply schema needed by application     

4. The .Net Core application is now able to connect to the SQL Server container with all necessary 


> **Key Takeaway**
>
> **Compose** is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.
>
> --https://docs.docker.com/compose/overview/