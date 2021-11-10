# Using Docker for PM classes
Hopefuly this solves compatibility issues and the VM limitations so everyone can work on classes and develop the projects instead of debugging dependencies or building problems.
## Installing Docker
Frist of, you need to install `docker`. For that I suggest to follow [Docker guide](https://docs.docker.com/get-docker/).

## Get the repo
Either clone the repo or download de zip and extract. All that you need is the **Dockerfile**.

## Build the container
> The next steps are for Linux users. On Windows try on powershell and on Mac you should not have trouble.
>
Change to the directory of the **Dockerfile**:
```
cd docker-pm-class
```
Build command:
```
docker build . -t ros-melodic
```

## Build catkin workspace
> It is possible that if you already created the workspace on ros melodic version you can skip this section
>
For simplicity sake, I suggest you move the old `catkin_ws` to another location or change the name so you can create a fresh new one, in any caset **DO NOT** keep CMakeLists.txt since we're are going to recompile and recreate the workspace.

After you have backed up everything you need, you have to recreate the folder:
```
cd ~
mkdir catkin_ws
cd catkin_ws
mkdir src
```
**Don't `catkin_make` yet**

First you need to create the container in interactive mode and mount to your catkin workspace (In this case `~/catkin_ws`).
```
docker run -it -v ~/catkin_ws:/root/catkin_ws --name ros ros-melodic
```
This created a new container named 'ros'.

Useful commands:
```
# restart a container
docker start ros
# attach a shell to the container
docker exec -it ros bash
# stop a container
docker stop ros
```

Now the `root/catkin_ws` inside the container will have the contents of your workspace.

Notice that now you're in the shell inside of the container.
Now you'll create the workspace:
```
catkin_make
```
## Copy workspace
Now copy only de source files you backup but **DO NOT** copy the CMakeLists.txt file.

Back to the running container, still inside the `/root/catkin_ws` folder run:

>_Warning: this will be an intensive workload_
>
```
# eg:
catkin_make -j4
# 4 is the number of threads
```
## Running ROS
If you compiled the workspace inside the same session shell as right now, you need to source an enviroment.
Go ahead and run:
```
source /root/catkin_ws/devel/setup.bash
```
Previous step is not necessary the next time you start a shell.

