FROM ros:melodic

# Install wget
RUN apt-get update
RUN apt-get install -y wget

# Install latest CMAKE
RUN apt purge --auto-remove -y cmake
RUN apt update; apt install -y software-properties-common lsb-release; apt clean all
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
RUN apt update; apt install kitware-archive-keyring
RUN rm /etc/apt/trusted.gpg.d/kitware.gpg
RUN apt update
RUN apt install -y cmake

# Install ros-melodic-desktop-full dependencies
RUN apt-get install -y ros-melodic-desktop-full
# Install other dependencies
RUN apt install -y ros-$ROS_DISTRO-hector-gazebo-plugins ros-$ROS_DISTRO-velodyne-description
RUN apt install -y libcgal-dev
RUN apt install -y libcgal-demo
RUN apt-get install -y libgmp10 libgmp-dev

# Set up environment
RUN echo 'source ros_entrypoint.sh' >> /root/.bashrc
RUN echo 'test -f /root/catkin_ws/devel/setup.bash && source /root/catkin_ws/devel/setup.bash' >> /root/.bashrc
