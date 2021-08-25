//
//  ViewController.swift
//  TWSJPlayerView
//
//  Created by zhengzeqin on 08/25/2021.
//  Copyright (c) 2021 zhengzeqin. All rights reserved.
//

import UIKit
import TWSJPlayerView
import SnapKit
class ViewController: UIViewController {

    fileprivate struct Metric {
        static let videoSelectedWidth: CGFloat = 200
        static let videoSelectedHeight: CGFloat = 195
    }
    
    fileprivate lazy var selectVideoViewBtn: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        btn.setTitleColor(.gray, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(selectVideoViewBtn)
        selectVideoViewBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(Metric.videoSelectedWidth)
            make.height.equalTo(Metric.videoSelectedHeight)
        }
    }

    @objc fileprivate func clickAction(_ btn: UIButton) {
        let dvc: TWSJPlayerViewController = TWSJPlayerViewController()
        let configure = TWSJPlayerViewConfigure()
        configure.isShowClose = true
        configure.isAutoPlay = false
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
//        self.navigationController?.pushViewController(dvc, animated: true)
    }

}

