//
//  TWSJPlayerViewConfigure.swift
//  TWSJPlayerView
//
//  Created by zhengzeqin on 2021/8/25.
//

import Foundation

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
