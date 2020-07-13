# EasyCoding

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

部分示例：
### 1. 视图创建语法糖
```swift

let label2 = UILabel()

//添加UILabel()到UIView()上，顶部对齐，两边间隔20, 蓝色苹方粗体18号
UIView.easy.add(
    UILabel.easy(.color(.blue), .font(UIFont.easy.pingfang(bold: 18), .text("第一个Label"))),
    layout: .top, .margin(20))
//添加label2到上面的UIView()上，顶部间隔上一个UILabel()的底部15，跟父控件x轴中间对齐，底部贴着父控件间隔30，红色系统15号字体
.next(label2.easy(.color(.red), .font(size: 15), .text("第二个Label")),
    layout: .bottomTop(15))
    .parent(.centerX, .bottom(30))
```
.easy.add方法在实例方法和类方法均可使用，类方法会创建个新类，实例方法则直接操作当前实例
除了.add外还有.append, .next, .follow, .parent

.add: 将参数视图添加到当前视图，layout参数的针对当前视图相对于参数视图布局，内部还是使用了snapKit，布局后返回参数视图作为链式语法的下一个视图

.append: 跟.add一样，区别是返回值为源视图

.next: 将参数视图添加到当前视图的父视图，layout参数的针对当前视图相对于参数视图布局，返回参数视图

.follow: 跟.follow一样，但返回源视图

.parent: 参数为布局设置，针对当前视图相对于父视图的布局，返回父视图

详细使用参考1.4.3.ViewBuilder目录及1.4.2.ViewStyle目录下的类

### 2.AttributedString语法糖

```swift
NSAttributedString.easy("我是一段富文本，文本很\("富", .color(.red))，我很\("穷", .color(.green), .boldFont(size: 30))", .color(rgb: 0x333333), .font(size: 15))
```
创建一个NSAttributedString，全局颜色深灰，15号系统字体，里面的"富"字红字，"穷"字绿字，加粗30号系统字体

暂时写这么点，其他还有很多可以参考demo和源码，源码都按目录分好了，很多没有写demo，懒得写了

## Requirements

Swift 5.2

## Installation

EasyCoding is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasyCoding'
```

## Author

fanxiaoxin_1987@126.com, fanxiaoxin_1987@126.com

## License

EasyCoding is available under the MIT license. See the LICENSE file for more info.
