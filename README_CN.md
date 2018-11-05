![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/EFColorPicker.png)

<p align="center">
<a href="https://travis-ci.org/EFPrefix/EFColorPicker"><img src="https://api.travis-ci.org/EFPrefix/EFColorPicker.svg?branch=master"></a>
<a href="http://cocoapods.org/pods/EFColorPicker"><img src="https://img.shields.io/cocoapods/v/EFColorPicker.svg?style=flat"></a>
<a href="http://cocoapods.org/pods/EFColorPicker"><img src="https://img.shields.io/cocoapods/p/EFColorPicker.svg?style=flat"></a>
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/language-swift-orange.svg"></a>
<a href="https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/EFColorPicker.svg?style=flat"></a>
<a href="https://twitter.com/EyreFree777"><img src="https://img.shields.io/badge/twitter-@EyreFree777-blue.svg?style=flat"></a>
<a href="http://weibo.com/eyrefree777"><img src="https://img.shields.io/badge/weibo-@EyreFree-red.svg?style=flat"></a>
<img src="https://img.shields.io/badge/made%20with-%3C3-orange.svg">
</p>

EFColorPicker 是一个纯 Swift 的轻量级 iOS 颜色选择器，受 [MSColorPicker](https://github.com/sgl0v/MSColorPicker) 启发。

> [English Introduction](https://github.com/EFPrefix/EFColorPicker/blob/master/README.md)

## 概述

iOS 颜色选择器组件，它能够让用户选择自定义颜色，关键特性如下：

- 支持 iPhone 和 iPad
- 自适应的用户界面
- 支持 RGB 和 HSB 两种颜色模式
- 比较完善的文档和注释
- 支持 iOS 8.0 (iPhone &amp; iPad) 及更高版本

## 预览

| iPhone |   | iPad |
|:---------------------:|:---------------------:|:---------------------:|
![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/sample_iphone.png)|![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/sample_iphone.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/sample_ipad.gif)   

## 示例

1. 利用 `git clone` 命令下载本仓库；
2. 利用 cd 命令切换到 Example 目录下，执行 `pod install` 命令；
3. 随后打开 `EFColorPicker.xcworkspace` 编译即可。

或执行以下命令：

```bash
git clone git@github.com:EFPrefix/EFColorPicker.git; cd EFColorPicker/Example; pod install; open EFColorPicker.xcworkspace
```

## 环境

- iOS 8.0+
- Xcode 10.1+
- Swift 4.2+
- CocoaPods 1.6.0.beta.2+

## 安装

EFColorPicker 可以通过 [CocoaPods](http://cocoapods.org) 进行获取。只需要在你的 Podfile 中添加如下代码就能实现引入：

```
pod "EFColorPicker"
```

## 使用

1. 首先，需要导入 EFColorPicker 库：

```swift
import EFColorPicker
```

2. 接下来，可以通过纯代码调用：

```swift
let colorSelectionController = EFColorSelectionViewController()
let navCtrl = UINavigationController(rootViewController: colorSelectionController)
navCtrl.navigationBar.backgroundColor = UIColor.white
navCtrl.navigationBar.isTranslucent = false
navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
navCtrl.popoverPresentationController?.delegate = self
navCtrl.popoverPresentationController?.sourceView = sender
navCtrl.popoverPresentationController?.sourceRect = sender.bounds
navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
    UILayoutFittingCompressedSize
)

colorSelectionController.delegate = self
colorSelectionController.color = self.view.backgroundColor ?? UIColor.white

if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
    let doneBtn: UIBarButtonItem = UIBarButtonItem(
        title: NSLocalizedString("Done", comment: ""),
        style: UIBarButtonItemStyle.done,
        target: self,
        action: #selector(ef_dismissViewController(sender:))
    )
    colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
}
self.present(navCtrl, animated: true, completion: nil)
```

也可以通过 Storyboard 调用：

```swift
if "showPopover" == segue.identifier {
	guard let destNav: UINavigationController = segue.destination as? UINavigationController else {
	    return
	}
	if let size = destNav.visibleViewController?.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize) {
	    destNav.preferredContentSize = size
	}
	destNav.popoverPresentationController?.delegate = self
	if let colorSelectionController = destNav.visibleViewController as? EFColorSelectionViewController {
	    colorSelectionController.delegate = self
	    colorSelectionController.color = self.view.backgroundColor ?? UIColor.white

	    if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
	        let doneBtn: UIBarButtonItem = UIBarButtonItem(
	            title: NSLocalizedString("Done", comment: ""),
	            style: UIBarButtonItemStyle.done,
	            target: self,
	            action: #selector(ef_dismissViewController(sender:))
	        )
	        colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
	    }
	}
}
```

你可以通过修改 `EFColorSelectionViewController` 的 `isColorTextFieldHidden` 属性来控制颜色编辑框的可见性，效果如下：

| isColorTextFieldHidden: true |   | isColorTextFieldHidden: false |   |
|:---------------------:|:---------------------:|:---------------------:|:---------------------:|
![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/sample_iphone1.png)|![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/sample_iphone2.png)|![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/sample_iphone3.png)|![](https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/sample_iphone4.png)   

具体可参考示例程序。

3. 最后，不要忘记调用的 ViewController 需要继承 EFColorSelectionViewControllerDelegate 来及时获取颜色的变化：

```swift
// MARK:- EFColorSelectionViewControllerDelegate
func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
    self.view.backgroundColor = color

    // TODO: You can do something here when color changed.
    print("New color: " + color.debugDescription)
}
```

## 备注

[EFColorPicker](https://github.com/EFPrefix/EFColorPicker/releases/tag/0.0.1) 的第一个版本从 [MSColorPicker](https://github.com/sgl0v/MSColorPicker/commit/b15f6cfabf4e406368f730f3f66f823bf1593293) 转换而来，在此对 MSColorPicker 的作者 [sgl0v](https://github.com/sgl0v) 表示感谢！

## 作者

EyreFree, eyrefree@eyrefree.org

## 协议

![](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png)

EFColorPicker 基于 MIT 协议进行分发和使用，更多信息参见协议文件。
