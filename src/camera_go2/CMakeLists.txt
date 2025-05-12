cmake_minimum_required(VERSION 3.8)
project(camera_go2)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(vision_msgs REQUIRED)
find_package(image_transport REQUIRED)
find_package(cv_bridge REQUIRED)
find_package(OpenCV REQUIRED)
find_package(darknet_ros_msgs REQUIRED)

# set(dependencues
#   rclcpp
#   sensor_msgs
#   image_transport
#   cv_bridge 
#   darknet_ros_msgs
# )

add_executable(image_listener src/image_listener.cpp)
ament_target_dependencies(image_listener
  rclcpp
  sensor_msgs
  image_transport
  cv_bridge
)

add_executable(bbox_listener src/bbox_listener.cpp)
ament_target_dependencies(bbox_listener
  rclcpp
  sensor_msgs
  image_transport
  cv_bridge
  darknet_ros_msgs
)

target_link_libraries(image_listener ${OpenCV_LIBS})


install(TARGETS
  image_listener
  bbox_listener
  DESTINATION lib/${PROJECT_NAME}
)

include_directories(
  include
)


if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  set(ament_cmake_cpplint_FOUND TRUE)
  set(ament_cmake_copyright_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
