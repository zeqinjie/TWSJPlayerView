//
//  TWSJPlayerViewController.swift
//  house591
//
//  Created by zhengzeqin on 2021/7/15.
//  公用的，不能有業務內容

import UIKit
import SJVideoPlayer
import SnapKit
@objc public enum TWSJPlayerViewControllerActionType: Int {
    /// 播放
    case play
    /// 暂停
    case pause
    /// 全屏幕
    case full
    /// 清晰度
    case definition
    /// 清晰度选择 360p
    case definition_360P
    /// 清晰度选择 480p
    case definition_480P
    /// 清晰度选择 720p
    case definition_720P
    /// 重播
    case replay
    /// 音量变化
    case volumeChange
    /// 速率变化
    case rateChange
    /// 关闭播放器
    case close
}

@objc public enum TWSJPlayerViewControllerPlayStatus: Int {
    /// 获取播放资源成功
    case fetchPlaySuccess
    /// 获取播放资源失败
    case fetchPlayFail
}

public class TWSJPlayerViewController: UIViewController {
    
    // MARK: - Public Property
    /// 事件触发事件回调
    @objc public var actionBlock: ((_ type: TWSJPlayerViewControllerActionType, _ vc: TWSJPlayerViewController?) -> Void)?
    /// 播放状态
    @objc public var playStatusBlock: ((_ status: TWSJPlayerViewControllerPlayStatus, _ vc: TWSJPlayerViewController?) -> Void)?
    /// 设置播放资源
    @objc public var playAssets: [SJVideoPlayerURLAsset]? {
        didSet {
            player.definitionURLAssets = playAssets;
        }
    }
    /// 配置样式对象
    @objc public var configure: TWSJPlayerViewConfigure = TWSJPlayerViewConfigure()
    // MARK: - Private Property
    /// 设置播放资源
    fileprivate var playItems: [TWSJPlayerViewPlayItem]?
    /// m3u8master url
    fileprivate var masterUrl: String?
    /// 是否重播
    fileprivate var isHadReplay: Bool = false
    /// 是否播放完毕
    fileprivate var isFinishPlay: Bool = false
    /// loading
    fileprivate let actView = UIActivityIndicatorView()
    /// 是否获取 解析 url 失败
    fileprivate var fetchVideoListFail: Bool = false
    fileprivate lazy var playerContainerView: UIView = {
        let controlView: UIView = UIView(frame: .zero)
        return controlView
    }()
    
    fileprivate lazy var closeBtn: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.setBackgroundImage(self.imageResourcePath("video_colse"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    fileprivate lazy var player: SJVideoPlayer = {
        let player: SJVideoPlayer = SJVideoPlayer()
        player.defaultEdgeControlLayer.isHiddenBackButtonWhenOrientationIsPortrait = true
        player.controlLayerAppearObserver.appearStateDidChangeExeBlock = { [weak self] mgr in
            guard let self = self else { return }
            self.player.promptPopupController.bottomMargin = mgr.isAppeared ? self.player.defaultEdgeControlLayer.bottomContainerView.bounds.size.height : 16
        }
        if #available(iOS 14.0, *) {
            player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = false
        }
        return player
    }()
    
    
    fileprivate struct Metric {
        static let closeBtnLeftMargin: CGFloat = 30
        static let closeBtnTopMargin: CGFloat = TWSJStatusBarHeight + 10
        static let closeBtnWidth: CGFloat = 50
        static let closeBtnHeight: CGFloat = 40
        static let playerContainerViewHeightRate: CGFloat = 9 / 16
        static let activitySize: CGFloat = 50
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        allowOrentitaionRotation()
        createUI()
        setConfigure()
    }
    
    deinit {
        if !fetchVideoListFail {
            actionBlock?(.close, self)
        }
        allowOrentitaionRotation(false)
        NotificationCenter.default.removeObserver(self)
    }
    
    public override var shouldAutorotate: Bool {
        return false
    }

    public override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    // MARK: - Public Method
    /// 播放第几个资源文件
    /// - Parameter index: 下标 默认第一个
    @objc public func play(index: Int = 0) {
        guard let playAssets = playAssets else { return }
        if playAssets.count > index {
            self.player.urlAsset = playAssets[index]
            if !configure.isAutoPlay { pause() }
        }
    }
    
    /// 播放的资源文件
    @objc public func play(item: SJVideoPlayerURLAsset?) {
        self.player.urlAsset = item
        if !configure.isAutoPlay { pause() }
    }
    
    /// 播放
    @objc public func play() {
        self.player.play()
    }
    
    /// 暂停
    @objc public func pause() {
        self.player.pause()
    }
    
    /// 通过设置 m3u8 链接播放
    /// - Parameters:
    ///   - url: 播放地址
    @objc public func playM3U8MasterUrl(_ url: String, index: Int = 0) {
        self.startActivity()
        self.masterUrl = url
        TWSJPlayerViewTool.fetchM3U8Parser(masterUrl: url) { [weak self] (items, isSuccess) in
            guard let self = self else { return }
            self.stopActivity()
            if isSuccess {
                self.playItems = items
                self.playAssets = TWSJPlayerViewTool.fetchSJVideoPlayerURLAsset(items: items)
                self.play(index: index)
                self.playStatusBlock?(.fetchPlaySuccess, self)
            } else {
                self.fetchVideoListFail = true
                self.playStatusBlock?(.fetchPlayFail, self)
                self.closeAction()
            }
        }
    }
    
    /// 获取当前播放 asset
    @objc public func fetchPlayUrlAsset() -> SJVideoPlayerURLAsset? {
        return self.player.urlAsset
    }
    
    /// 获取当前播放 index
    @objc public func fetchPlayIndex() -> Int {
        guard let playAssets = self.playAssets else { return 0 }
        guard let playAsset = self.fetchPlayUrlAsset() else { return 0 }
        return playAssets.firstIndex(of: playAsset) ?? 0
    }
    
    /// 获取当前播放 item
    @objc public func fetchPlayItem() -> TWSJPlayerViewPlayItem? {
        let index = fetchPlayIndex()
        if self.playItems?.count ?? 0 > index {
            return self.playItems?[index]
        }
        return nil
    }
    
    /// 是否播放完毕
    @objc public func fetchIsFinishPlay() -> Bool {
        return self.isFinishPlay
    }
    
    /// 是否重播过
    @objc public func fetchIsHadReplay() -> Bool {
        return self.isHadReplay
    }
    
    /// 获取当前播放的时间 s 秒
    @objc public func fetchCurrentTime() -> TimeInterval {
        return self.player.currentTime
    }
    
    /// 获取播放总时长 s 秒
    @objc public func fetchTotalTime() -> TimeInterval {
        return self.player.duration
    }
    
    /// 获取播放总时长 s 秒
    @objc public func fetchUrl() -> String {
        return self.masterUrl ?? ""
    }
    
    // MARK: - UI
    fileprivate func createUI() {
        view.addSubview(playerContainerView)
        playerContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(view.frame.width * Metric.playerContainerViewHeightRate)
        }
        
        playerContainerView.addSubview(player.view)
        player.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(Metric.closeBtnLeftMargin)
            make.top.equalTo(Metric.closeBtnTopMargin)
            make.width.equalTo(Metric.closeBtnWidth)
            make.height.equalTo(Metric.closeBtnHeight)
        }
        
        if #available(iOS 13.0, *) {
            actView.style = .medium
        } else {
            actView.style = .gray
        }
        view.addSubview(actView)
        actView.snp.makeConstraints { make in
            make.center.equalTo(playerContainerView)
            make.width.height.equalTo(Metric.activitySize)
        }

    }
    
    fileprivate func startActivity() {
        actView.isHidden = false
        actView.startAnimating()
    }
    
    fileprivate func stopActivity() {
        actView.isHidden = true
        actView.stopAnimating()
    }
    
    // MARK: - Priavte Method
    /// 配置播放器信息
    fileprivate func setConfigure() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playItemNotification(_:)),
            name: NSNotification.Name.SJEdgeControlButtonItemPerformedAction,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willTerminateNotification(_:)),
            name: NSNotification.Name.SJVideoPlayerApplicationWillTerminate,
            object: nil
        )
        player.deviceVolumeAndBrightnessObserver.volumeDidChangeExeBlock = { [weak self] (mgr, volume) in
            guard let self = self else { return }
            self.actionBlock?(.volumeChange, self)
        }
        player.playbackObserver.rateDidChangeExeBlock = { [weak self] player in
            guard let self = self else { return }
            self.actionBlock?(.rateChange, self)
        }
        player.playbackObserver.playbackDidFinishExeBlock = { [weak self] player in
            guard let self = self else { return }
            self.isFinishPlay = true
        }
        closeBtn.isHidden = !configure.isShowClose
        view.backgroundColor = configure.backgroundColor
        TWSJPlayerViewTool.configureProgressColor(configure.progressColor)
    }
    
    fileprivate func addNoticeListener(adapter: SJEdgeControlButtonItemAdapter, itemTags:[SJEdgeControlButtonItemTag]) {
        for itemTag in itemTags {
            TWSJPlayerViewTool.addNoticeListener(
                observer: self,
                method: #selector(playItemNotification(_:)),
                adapter: adapter,
                itemTag: itemTag
            )
        }
    }
    
    fileprivate func allowOrentitaionRotation(_ isSupport: Bool = true) {
        guard let delegate = UIApplication.shared.delegate else { return }
        delegate.allowOrentitaionRotation = isSupport
    }
    
    fileprivate var isModal: Bool {
        presentingViewController?.presentedViewController == self ||
            navigationController?.presentingViewController?.presentedViewController == navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
    fileprivate func imageResourcePath(_ fileName: String) -> UIImage? {
        let bundle = Bundle(for: TWSJPlayerViewController.self)
        return UIImage(named: fileName, in: bundle, compatibleWith: nil)
    }
    
    // MARK: Notification
    /// button Item 按键触发事件通知, 按钮状态已改变后收到通知
    @objc fileprivate func playItemNotification(_ notification: Notification) {
        guard let item = notification.object as? SJEdgeControlButtonItem else { return }
        switch item.tag {
        case SJEdgeControlLayerBottomItem_Play:
            if self.player.isPaused { // 暂停状态下播放
                self.actionBlock?(.pause, self)
            } else {
                self.actionBlock?(.play, self)
            }
            return
        case SJEdgeControlLayerBottomItem_Full:
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                if self.player.isFullScreen || self.player.isFitOnScreen {
                    self.actionBlock?(.full, self)
                }
            }
            return
        case SJEdgeControlLayerCenterItem_Replay:
            self.isHadReplay = true
            self.actionBlock?(.replay, self)
            return
        case SJEdgeControlLayerBottomItem_Definition:
            self.actionBlock?(.definition, self)
            return
        default:
            break
        }
        if let title = item.title?.string {
            switch title {
            case TWSJPlayerViewPlayItem.Macro.resolution_360P:
                self.actionBlock?(.definition_360P, self)
                return
            case TWSJPlayerViewPlayItem.Macro.resolution_480P:
                self.actionBlock?(.definition_480P, self)
                return
            case TWSJPlayerViewPlayItem.Macro.resolution_720P:
                self.actionBlock?(.definition_720P, self)
                return
            default:
                break
            }
        }
    }
    
    /// 将要销毁通知
    @objc fileprivate func willTerminateNotification(_ notification: Notification) {
        self.actionBlock?(.close, self)
    }
    
    // MARK: - Action Method
    //关闭按钮
    @objc fileprivate func closeAction() {
        if isModal {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
