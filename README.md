# BTStudio
<img src="https://avatars2.githubusercontent.com/u/12229793?v=3&s=460" width="240" height="240">

## How To Get Started

- [Download TouchIDDemo](https://github.com/wz15011015github/BTStudio.git) and try out the included iPhone example apps.

- 第一次添加一个README.md文件
#####   Git command
```bash
echo "# BTStudio" >> README.md
git init
git add README.md
git commit -m 'first commit'
git remote add origin https://github.com/wz15011015github/BTStudio.git
git push -u origin master
```

## Communication

- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


[//]:## Installation
[//]:BTStudio supports multiple methods for installing the library in a project.

### Installation with CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like BTStudio in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
> Tips: Nothing lasts forever.

### Podfile

To integrate BTStudio into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
	
target 'TargetName' do
pod 'BTStudio'
end
```

Then, run the following command:

```bash
$ pod install
```


## Requirements

| Minimum iOS Target |
|:------------------:|
| iOS 8.0 |

## Usage

### 1. TouchIDDemo

TouchID使用小Demo.

### 2. LiveForMobile

移动直播Demo，模仿iOS平台主流直播App界面来搭建，更新中...

## License
BTStudio is released under the MIT license. See LICENSE for details.

