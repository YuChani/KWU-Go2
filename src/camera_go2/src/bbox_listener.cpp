#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/image.hpp>
#include <cv_bridge/cv_bridge.h>
#include <opencv2/opencv.hpp>
#include <darknet_ros_msgs/msg/bounding_boxes.hpp>

using namespace std;
// camera size = 640 * 480
rclcpp::Subscription<sensor_msgs::msg::Image>::SharedPtr sub;

void bbox_callback(const darknet_ros_msgs::msg::BoundingBoxes::SharedPtr msg)
{
    for (const auto& box : msg->bounding_boxes)
    {
        float center_x = box.xmin + (box.xmax - box.xmin) / 2.0;
        float center_y = box.ymin + (box.ymax - box.ymin) / 2.0;
        float box_width = box.xmax - box.xmin;
        float box_height = box.ymax - box.ymin;

        RCLCPP_INFO(rclcpp::get_logger("bbox_listener"),
                    "Object: %s | x: %f | y: %f | w: %f | h: %f",
                    box.class_id.c_str(), center_x, center_y, box_width, box_height);
                    // center_x : boundingbox 중심 x좌표 , center_y : boundingbox의 중심 y좌표, 
                    // box_width : boundingbox 가로길이, box_height : boundingbox 세로길이
    }
}

int main(int argc, char* argv[])
{
    rclcpp::init(argc, argv);
    auto node = rclcpp::Node::make_shared("bbox_listener");

    auto sub = node->create_subscription<darknet_ros_msgs::msg::BoundingBoxes>(
        "/darknet_ros/bounding_boxes", 10, bbox_callback);

    rclcpp::spin(node);
    rclcpp::shutdown();

    return 0;
}