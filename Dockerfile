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

# Set up environment
RUN echo 'source ros_entrypoint.sh' >> /root/.bashrc
RUN echo 'source /root/catkin_ws/devel/setup.bash' >> /root/.bashrc

# Install simulator dependencies
RUN apt install -y libcgal-dev
RUN apt install -y libcgal-demo
# RUN wget https://github.com/CGAL/cgal/releases/download/v5.3/CGAL-5.3.tar.xz
# RUN tar xavf CGAL-5.3.tar.xz
# RUN cd CGAL-5.3; mkdir build; cd build; cmake ..; make install

RUN apt-get install -y libgmp10 libgmp-dev
# RUN curl -fLO https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz
# RUN tar -xf gmp-6.2.1.tar.xz
# RUN cd gmp-6.2.1; ./configure --prefix=/opt/gmp;
# RUN cd gmp-6.2.1; make all; make install; cp gmpxx.h /opt/gmp/include
# RUN export GMP_INC=/opt/gmp/include
# RUN export GMP_LIB=/opt/gmp/lib

