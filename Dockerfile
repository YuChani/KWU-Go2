FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 1. 필수 시스템 도구 설치
RUN apt update && apt install -y \
    curl \
    git \
    locales \
    lsb-release \
    gnupg2 \
    software-properties-common \
    sudo \
    python3-pip \
    net-tools \
    wget \
    nano \
    && locale-gen en_US.UTF-8

# 2. ROS 2 Humble 저장소 등록 및 GPG 키 설정
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | \
    gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/ros2-latest.list

# 3. ROS 2 및 주요 패키지 설치
RUN apt update && apt install -y \
    ros-humble-desktop \
    python3-rosdep \
    python3-colcon-common-extensions \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-robot-localization \
    ros-humble-robot-state-publisher \
    ros-humble-perception-pcl \
    ros-humble-pcl-msgs \
    ros-humble-vision-opencv \
    ros-humble-xacro \
    ros-humble-rviz2 \
    ros-humble-slam-toolbox \
    ros-humble-cartographer \
    ros-humble-cartographer-ros \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-ros2-control \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-turtlebot3-msgs \
    ros-humble-turtlebot3-description \
    ros-humble-turtlebot3-gazebo \
    ros-humble-turtlebot3-navigation2 \
    ros-humble-velodyne \
    ros-humble-velodyne-description \
    ros-humble-velodyne-driver \
    ros-humble-velodyne-pointcloud \
    && rm -rf /var/lib/apt/lists/*

# 4. rosdep 초기화
RUN rosdep init && rosdep update

# 5. ROS 환경 설정
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# 6. ros2_ws 생성 및 GitHub 프로젝트 clone
RUN mkdir -p /root/ros2_ws/src && \
    git clone https://github.com/YuChani/KWU-Go2.git /root/ros2_ws/src/KWU-Go2

# 7. ros2_ws 초기 빌드
RUN cd /root/ros2_ws && colcon build

# 8. ros2_ws 환경 설정
RUN echo "source /root/ros2_ws/install/setup.bash" >> /root/.bashrc

# 9. 기본 작업 디렉토리
WORKDIR /root/ros2_ws

CMD ["bash"]

