# YJImagePickerController

[![CI Status](http://img.shields.io/travis/full-of-fire/YJImagePickerController.svg?style=flat)](https://travis-ci.org/full-of-fire/YJImagePickerController)
[![Version](https://img.shields.io/cocoapods/v/YJImagePickerController.svg?style=flat)](http://cocoapods.org/pods/YJImagePickerController)
[![License](https://img.shields.io/cocoapods/l/YJImagePickerController.svg?style=flat)](http://cocoapods.org/pods/YJImagePickerController)
[![Platform](https://img.shields.io/cocoapods/p/YJImagePickerController.svg?style=flat)](http://cocoapods.org/pods/YJImagePickerController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
1.相册的多选功能
```
YJImagePickerController *albumsList = [YJImagePickerController new];
albumsList.didFinishPickingImages = ^(NSArray *images) {

NSLog(@"====images = %@",images);
};
albumsList.didCancel = ^{

NSLog(@"取消选择");
};
[self presentViewController:albumsList animated:YES completion:nil];
```
2.多拍相机的使用
```
YJMulCameraViewController *camera = [YJMulCameraViewController new];
camera.didFinishTakeImagesBlock = ^(NSArray *images) {

NSLog(@"====images = %@",images);
};
camera.didCancelBlock = ^{
NSLog(@"取消");
};
[self presentViewController:camera animated:YES completion:nil];

```
3.相册预览功能
```
YJImagePrewViewController *preView = [YJImagePrewViewController new];

YJImageModel *model = [YJImageModel new];
model.imageURL = [NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=4115900726,1603453606&fm=173&s=38B75894034017490198B48F030070C8&w=218&h=146&img.JPEG"];
preView.photoList = @[model,model,model,model,model,model];
[self presentViewController:preView animated:YES completion:nil];
```

## Requirements

## Installation

YJImagePickerController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YJImagePickerController'
```

## Author

full-of-fire, 591730822@qq.com

## License

YJImagePickerController is available under the MIT license. See the LICENSE file for more info.
