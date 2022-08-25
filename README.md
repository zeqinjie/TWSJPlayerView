# TWSJPlayerView

[![CI Status](https://img.shields.io/travis/zhengzeqin/TWSJPlayerView.svg?style=flat)](https://travis-ci.org/zhengzeqin/TWSJPlayerView)
[![Version](https://img.shields.io/cocoapods/v/TWSJPlayerView.svg?style=flat)](https://cocoapods.org/pods/TWSJPlayerView)
[![License](https://img.shields.io/cocoapods/l/TWSJPlayerView.svg?style=flat)](https://cocoapods.org/pods/TWSJPlayerView)
[![Platform](https://img.shields.io/cocoapods/p/TWSJPlayerView.svg?style=flat)](https://cocoapods.org/pods/TWSJPlayerView)

## Introduce
> 基于 SJVideoPlayer & M3U8Kit 二次封装的支持 m3u8 解析播放器控制器 
> - 基于 m3u8.master 文件 url 直接播放视频
> - 目前支持 360, 480, 720P 等资源判断
> - 目前支持播放自定义控制，比如进度条颜色等



![图片](https://github.com/zeqinjie/TWSJPlayerView/blob/master/assets/1.png)

## Demo

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```
public class TWSJPlayerViewConfigure: NSObject {
    /// 是否展示关闭按钮
    public var isShowClose: Bool = false
    /// 进度条颜色
    public var progressColor: UIColor = .orange
    /// 背景色
    public var backgroundColor: UIColor = .black
    /// 是否自动播放
    public var isAutoPlay: Bool = true
}


fileprivate func clickAction(_ btn: UIButton) {
        let dvc: TWSJPlayerViewController = TWSJPlayerViewController()
        let configure = TWSJPlayerViewConfigure()
        configure.isShowClose = true
        dvc.configure = configure
        dvc.actionBlock = { (type, vc) in
            switch type {
            case .close:
                print("close...")
            default:
                print("default")
            }
        }
        dvc.playM3U8MasterUrl("https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8")
        present(dvc, animated: true, completion: nil)
    }
```


## Installation

TWSJPlayerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TWSJPlayerView'
```

## Author

zhengzeqin, zeqinjie@qq.com

## License

TWSJPlayerView is available under the MIT license. See the LICENSE file for more info.
