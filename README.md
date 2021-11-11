# Using Docker for PM classes
Hopefuly this solves compatibility issues and the VM limitations so everyone can work on classes and develop the projects instead of debugging dependencies or building problems.
>**This process is specific to linux but the procedure itself should be similiar**.
>
## Installing Docker
First off, you need to install `docker`. For that I suggest to follow [Docker guide](https://docs.docker.com/get-docker/).

## Get the repo
Either clone the repo or download de zip and extract. All that you need is the **Dockerfile**.

## Build the container
Change to the directory to the **Dockerfile**:
```
cd docker-pm-class
```
Build command:
```
docker build . -t ros-melodic
```

## Build catkin workspace
Now you need to create a folder for your catkin workspace (usually `catkin_ws`). Go inside the folder you just created and a make a new folder `src`.

If you already had a `catkin_ws` folder, I suggest you backup your source files **EXCEPT CMakeLists.txt**. Once you compile the fresh new workspace, it will create a new CMakeList.txt and you'll later paste the source files you backup.

Your folder structure must be something like this:
```
.../
    |
    catkin_ws/
            |
            src/
```
**Don't `catkin_make` yet**

First you need to create the container in interactive mode and mount to your catkin workspace.
```
# Change the path to you catkin folder
docker run -it -v <path-to-your-catkin_ws-folder>:/root/catkin_ws --name ros ros-melodic
```
This created a new container named 'ros'.

Now the `root/catkin_ws` inside the container will have the contents of the path you specified in the previous step (the path to your workspace). This way we can code outside the container but our files will be there.

Notice that now you're in the shell inside of the container and should look something like this:
```
root@589ddd9bfdc7:/# 
```
> Note that docker will close the bash shell if it is given an error. To restart a shell attached to the container run `docker exec -it ros bash`.
>
> Furthermore if instead of an error it gives an exception the whole container will stop. To restart it run `docker start ros`.
>
> To check the running docker containers run `docker ps`.
>
Now you'll initialize the workspace:
```
cd /root/catkin_ws
catkin_make
```
## Copy and compile workspace
If you had an workspace now you need to copy only the source files you backup but **DO NOT** copy the CMakeLists.txt file.

Back to the running container, still inside the `/root/catkin_ws` folder let's compile the code you pasted by runnning:

>_Warning: this will be an intensive workload_
>
```
# eg:
catkin_make -j4
# 4 is the number of threads
```
## Setup ROS
Now you need to source an enviroment.
Go ahead and run:
```
source /root/catkin_ws/devel/setup.bash
```
> This must be called everytime you start a shell. There's a way but involves modifying the _Dockerfile_ and build a run the container again. Note that building the container wont take as much time as the first time because it will cache the previous image and build on top of it.
>

> I'm still working on x11 to see simulator windows.
>
Now you'll be able to run ros.

## Running ROS
All you have to do is make sure the ros container is running.
```
docker ps
```
If it is not running you can start it with.
```
docker start ros
```
Then you can attach any number of bash shells to the container to run your ros programs.
```
docker exec -it ros bash
```
> You only have to start the container once unless an exception was thrown. In that case you need to restart it.
>
