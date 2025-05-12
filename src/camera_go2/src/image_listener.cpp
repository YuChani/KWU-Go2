#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/image.hpp>
#include <cv_bridge/cv_bridge.h>
#include <opencv2/opencv.hpp>

rclcpp::Subscription<sensor_msgs::msg::Image>::SharedPtr sub;

void image_callback(const sensor_msgs::msg::Image::SharedPtr msg)
{
    try
    {
        cv::Mat image = cv_bridge::toCvShare(msg, "bgr8")->image;
        cv::imshow("YOLO Detection Image", image);
        cv::waitKey(1);
    }

    catch (cv_bridge::Exception& e)
    {
        RCLCPP_ERROR(rclcpp::get_logger("image_listener"), "cv_bridge exception: %s", e.what());
    }
}

int main(int argc, char* argv[])
{
    rclcpp::init(argc, argv);
    auto node = rclcpp::Node::make_shared("image_listener");

    auto sub = node->create_subscription<sensor_msgs::msg::Image>("/darknet_ros/detection_image", 10, image_callback);

    rclcpp::spin(node);
    rclcpp::shutdown();
    
    return 0;
}
