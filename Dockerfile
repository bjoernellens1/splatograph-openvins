FROM ros:jazzy-ros-base-noble AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV ROS_DISTRO=jazzy     DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends       build-essential cmake git ca-certificates       libeigen3-dev libopencv-dev libopencv-contrib-dev libboost-all-dev libceres-dev       python3-colcon-common-extensions       ros-jazzy-ament-cmake ros-jazzy-rclcpp ros-jazzy-tf2-ros ros-jazzy-tf2-geometry-msgs       ros-jazzy-cv-bridge ros-jazzy-image-transport ros-jazzy-nav-msgs ros-jazzy-sensor-msgs       ros-jazzy-geometry-msgs ros-jazzy-visualization-msgs     && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/openvins_ws/src
RUN git clone --depth 1 https://github.com/rpng/open_vins.git \
    && grep -RIl "image_transport/image_transport.h" open_vins | xargs -r sed -i "s#image_transport/image_transport.h#image_transport/image_transport.hpp#g" \
    && grep -RIl "tf2_geometry_msgs/tf2_geometry_msgs.h" open_vins | xargs -r sed -i "s#tf2_geometry_msgs/tf2_geometry_msgs.h#tf2_geometry_msgs/tf2_geometry_msgs.hpp#g" \
    && grep -RIl "cv_bridge/cv_bridge.h" open_vins | xargs -r sed -i "s#cv_bridge/cv_bridge.h#cv_bridge/cv_bridge.hpp#g"
WORKDIR /opt/openvins_ws
RUN bash -lc 'source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=Release'

FROM ros:jazzy-ros-base-noble
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
LABEL org.opencontainers.image.source="https://github.com/bjoernellens1/splatograph-openvins"       org.opencontainers.image.description="ROS2 Jazzy OpenVINS container for Splatograph pose input"       org.opencontainers.image.licenses="GPL-3.0"
ENV ROS_DISTRO=jazzy     DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends       libopencv-dev libopencv-contrib-dev libboost-all-dev libceres-dev       ros-jazzy-rclcpp ros-jazzy-tf2-ros ros-jazzy-tf2-geometry-msgs       ros-jazzy-cv-bridge ros-jazzy-image-transport ros-jazzy-nav-msgs ros-jazzy-sensor-msgs       ros-jazzy-geometry-msgs ros-jazzy-visualization-msgs     && rm -rf /var/lib/apt/lists/*
COPY --from=builder /opt/openvins_ws /opt/openvins_ws
COPY scripts/slam-launch /usr/local/bin/slam-launch
COPY scripts/smoke.sh /usr/local/bin/splatograph-smoke
RUN chmod +x /usr/local/bin/slam-launch /usr/local/bin/splatograph-smoke
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["slam-launch"]
