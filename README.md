# Using Docker for PM classes
Hopefuly this solves compatibility issues and the VM limitations so everyone can work on classes and develop the projects instead of debugging dependencies or building problems.
>**This process is specific to linux but the procedure itself should be similiar**.
>
## Installing Docker
First off, you need to install `docker`. For that I suggest to follow [Docker guide](https://docs.docker.com/get-docker/).
### Installing X11 (Windows only)
You'll need something to run a X11 server so we can see the simulator windows. I suggest [VcXsrv](https://sourceforge.net/projects/vcxsrv/).
Important set up configurations:
* Uncheck "Native opengl".
* Check "Disable access control".
* Save the configuration somewhere accessible because you'll launch the server from there.

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

## Create catkin folder
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
First you need to create the container in interactive mode and mount to your catkin workspace.
### Linux
```bash
# Change the path to your catkin folder
docker run -it --rm -v <path-to-your-workspace>:/root/catkin_ws -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/root/.Xauthority --name ros ros-melodic
```
### Windows
Run the X11 server by executing the configuration you saved earlier.
```bash
# Change the path to your catkin folder and your ip (you can run ipconfig to check your ip)
docker run -it --rm -v <path-to-your-workspace>:/root/catkin_ws -e DISPLAY=<your-ip>:0.0 -e LIBGL_ALWAYS_INDIRECT=0 --name ros ros-melodic
```
> Your ip will change depending on the network it is connected, you may need to update it
>
Now the container is created and is named 'ros'.

> I suggest for both platforms to create a script so you don't need to copy or write it everytime.
>

Now the `root/catkin_ws` inside the container will have the contents of the path you specified in the previous step (the path to your workspace). This way we can code outside the container but our files will be there.

Notice that now you're in the shell inside of the container and should look something like this:
```bash
root@589ddd9bfdc7:/# 
```
> Note that docker will close the bash shell if it is given an error. To restart a shell attached to the container run `docker exec -it ros bash`.
>
> To check the running docker containers run `docker ps`.
>
## Initialize catkin workspace
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
> You only need to run this once if you are compiling for the first time. Next time it will do it automatically.
>
Now you'll be able to run ros.

## Running ROS
You can check the status of your running containers:
```
docker ps
```
Start the container:
> Linux
>
```bash
docker run -it --rm -v <path-to-your-workspace>:/root/catkin_ws -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/root/.Xauthority --name ros ros-melodic
```
> Windows
>
Make sure your X11 is running and your ip address is correct.
```bash
# Change the path to your catkin folder and your ip (you can run ipconfig to check your ip)
docker run -it --rm -v <path-to-your-workspace>:/root/catkin_ws -e DISPLAY=<your-ip>:0.0 -e LIBGL_ALWAYS_INDIRECT=0 --name ros ros-melodic
```
Then you can attach more bash shells to the container to run your ros programs.
```bash
docker exec -it ros bash
```
## Quit PM
Now you can work on your main machine in your favorite IDE or editor instead of the slow bugged VM!
