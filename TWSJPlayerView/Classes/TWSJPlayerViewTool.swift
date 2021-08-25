//
//  TWSJPlayerViewM3U8Tool.swift
//  house591
//
//  Created by zhengzeqin on 2021/7/15.
//

import UIKit
import M3U8Kit
import SJVideoPlayer
public class TWSJPlayerViewTool: NSObject {
    
    public typealias TWSJPlayerViewToolFetchItemsBlock = ((_ items: [TWSJPlayerViewPlayItem], _ isSuccess: Bool)-> Void)
    
    // MARK: - Pirvate Property
    fileprivate struct Macro {
        static let dictionary = "dictionary"
    }

    // MARK: - Public Method
    /// 获取解析播放资源 master url 资源
   public class func fetchM3U8Parser(
        masterUrl: String,
        fetchItemsBlock: TWSJPlayerViewToolFetchItemsBlock?
    ) {
        guard let url = NSURL(string: masterUrl) else {
            performM3U8Result(items: [], isSuccess: false, fetchItemsBlock: fetchItemsBlock)
            return
        }
        url.m3u_loadAsyncCompletion({ (model, error) in
            guard let xStreamList = model?.masterPlaylist.xStreamList else {
                performM3U8Result(items: [], isSuccess: false, fetchItemsBlock: fetchItemsBlock)
                return
            }
            var items: [TWSJPlayerViewPlayItem] = []
            for index in 0...xStreamList.count {
                guard let xStreamInf = xStreamList.xStreamInf(at: index) else { continue }
                guard let m3u8URL = xStreamInf.m3u8URL() else { continue }
                let item: TWSJPlayerViewPlayItem = TWSJPlayerViewPlayItem()
                item.videoUrl = m3u8URL.absoluteString
                item.index = Int(index)
                if let dictionary = xStreamInf.value(forKey: Macro.dictionary) as? [String: Any] {
                    /// 视频分辨率
                    if let resolution = dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_RESOLUTION] as? String  {
                        item.resolution = resolution
                    }
                }
                items.append(item)
            }
            performM3U8Result(items: items, isSuccess: error == nil, fetchItemsBlock: fetchItemsBlock)
        })
    }
    
    /// 转换数据
    public class func fetchSJVideoPlayerURLAsset(items: [TWSJPlayerViewPlayItem]) -> [SJVideoPlayerURLAsset] {
        return items.compactMap { item -> SJVideoPlayerURLAsset? in
            guard let videoUrl = URL(string: item.videoUrl) else { return nil }
            guard let asset: SJVideoPlayerURLAsset = SJVideoPlayerURLAsset(url: videoUrl) else { return nil }
            asset.definition_fullName = item.resolutionTitle
            asset.definition_lastName = item.resolutionTitle
            return asset
        }
    }
    
    /// 设置默认进度条颜色
    @objc public class func configureProgressColor(_ color: UIColor? = .orange) {
        SJVideoPlayerConfigurations.update({ cofigure in
            let resources = cofigure.resources
            resources?.progressTraceColor = color
            resources?.bottomIndicatorTraceColor = color
        })
    }
    
    /// 监听事件回调
    public class func addNoticeListener(
        observer: Any,
        method: Selector,
        adapter: SJEdgeControlButtonItemAdapter,
        itemTag: SJEdgeControlButtonItemTag
    ) {
        if let playItem = adapter.item(forTag: itemTag) {
            NotificationCenter.default.addObserver(
                observer,
                selector: method,
                name: NSNotification.Name.SJEdgeControlButtonItemPerformedAction,
                object: playItem
            )
        }
    }
    
    // MARK: - Pirvate Method
    fileprivate class func performM3U8Result(
        items: [TWSJPlayerViewPlayItem],
        isSuccess: Bool,
        fetchItemsBlock: TWSJPlayerViewToolFetchItemsBlock?
    ) {
        DispatchQueue.main.async {
            fetchItemsBlock?(items, isSuccess)
        }
    }
    

}
