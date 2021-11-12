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
```bash
cd docker-pm-class
```
Build command:
```bash
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

## Run the container
### Linux
First you need to create the container in interactive mode and mount to your catkin workspace.
```bash
# Change the path to your catkin folder
docker run -it --rm -v <path-to-your-workspace>:/root/catkin_ws -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/root/.Xauthority --name ros ros-melodic
```
### Windows
> TODO
>
Now the container is created and is named 'ros'.

Now the `root/catkin_ws` inside the container will have the contents of the path you specified in the previous step (the path to your workspace). This way we can code outside the container but our files will be there.

Notice that now you're in the shell inside of the container and should look something like this:
```bash
root@589ddd9bfdc7:/# 
```
> Note that docker will close the bash shell if it is given an error. To restart a shell attached to the container run `docker exec -it ros bash`.
>
> Furthermore if instead of an error it gives an exception the whole container will stop. To restart it run `docker start ros`.
>
> To check the running docker containers run `docker ps`.
>
Now you'll initialize the workspace:
```bash
cd /root/catkin_ws
catkin_make
```
## Copy and compile workspace
If you had an workspace now you need to copy only the source files you backup but **DO NOT** copy the CMakeLists.txt file.

Back to the running container, still inside the `/root/catkin_ws` folder let's compile the code you pasted by runnning:

>_Warning: this will be an intensive workload_
>
```bash
# eg:
catkin_make -j4
# 4 is the number of threads
```
## Setup ROS
Now you need to source an enviroment.
Go ahead and run:
```bash
source /root/catkin_ws/devel/setup.bash
```
> This must be called everytime you start a shell. There's a way but involves modifying the _Dockerfile_ and build a run the container again. Note that building the container wont take as much time as the first time because it will cache the previous image and build on top of it.
>

> I'm still working on x11 to see simulator windows.
>
Now you'll be able to run ros.

## Running ROS
You can check the status of your running containers:
```
docker ps
```
Start the container:
```bash
docker run -it --rm -v <path-to-your-workspace>:/root/catkin_ws -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/root/.Xauthority --name ros ros-melodic
```
Then you can attach more bash shells to the container to run your ros programs.
```bash
docker exec -it ros bash
```
