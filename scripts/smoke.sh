#!/usr/bin/env bash
set -eo pipefail
source /opt/ros/${ROS_DISTRO:-jazzy}/setup.bash
source /opt/openvins_ws/install/setup.bash
ros2 pkg prefix ov_msckf >/dev/null
ros2 pkg prefix ov_core >/dev/null
command -v slam-launch >/dev/null
