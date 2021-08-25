//
//  TWSJPlayerViewPlayItem.swift
//  house591
//
//  Created by zhengzeqin on 2021/7/15.
//

import UIKit

@objcMembers public class TWSJPlayerViewPlayItem: NSObject {
    struct Macro {
        static let resolution_720P = "720P"
        static let resolution_480P = "480P"
        static let resolution_360P = "360P"
    }
    /// 播放链接
    var videoUrl: String = ""
    /// 播放标题
    var videoTitle: String?
    /// 封面 url
    var videoCover: String?
    /// 下标
    var index: Int = 0
    /// 分辨率
    var resolution: String = "" {
        didSet {
            resolutionTitle = fetchResolutionTitle(resolution)
        }
    }
    /// 分辨率后半部分
    var resolutionTitle: String = ""
    
    // MARK: - Public Method
    /// 是否 720P 资源
    var is720P: Bool {
        get {
            return resolutionTitle == Macro.resolution_720P
        }
    }
    
    /// 是否 360P 资源
    var is360P: Bool {
        get {
            return resolutionTitle == Macro.resolution_360P
        }
    }
    
    /// 是否 480P 资源
    var is480P: Bool {
        get {
            return resolutionTitle == Macro.resolution_480P
        }
    }
    
    // MARK: - Priavte Method
    /// 分隔获取后半部分 868x480  = 480
    fileprivate func fetchResolutionTitle(_ str: String) -> String {
        guard let fetchResolutionString = str.components(separatedBy: "x").last else { return "" }
        return "\(fetchResolutionString)P"
    }
    
}
