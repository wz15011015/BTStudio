# BTStudio
![BTStudio logo](https://avatars2.githubusercontent.com/u/12229793?v=3&s=460)

## How To Get Started

**第一次添加一个README.md文件**
### Git command

	echo "# BTStudio" >> README.md
	git init
	git add README.md
	git commit -m 'first commit'
	git remote add origin https://github.com/wz15011015github/BTStudio.git
	git push -u origin master

## Communication

## Installation
BTStudio supports multiple methods for installing the library in a project.
## Installation with CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like BTStudio in your projects. You can install it with the following command:

	gem install cocoapods
	
> Command

### Podfile
To integrate BTStudio into your Xcode project using CocoaPods, specify it in your `Podfile`:

	source 'https://github.com/CocoaPods/Specs.git'
	platform : ios, '8.0'
	
	target 'TargetName' do
	pod 'BTStudio', '~> 1.0'
	end
	
Then, run the following command:

	pod install

## Requirements

## Usage

## License
BTStudio is released under the MIT license. See LICENSE for details.

