//
//  InnerFeatureConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/16.
//

import UIKit
import Eureka
import AVFoundation

class InnerFeatureConfigViewController: BaseConfigViewController {
    var player : AVPlayer?
    private var musicTag: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        form
        +++ Section("厂商")
        <<< CheckRow(RowTag.AGORA) {
            $0.title = "声网"
            $0.value = true
        }.onCellSelection({ cell, row in
            setupSelectedInSection(row)
        })
        <<< CheckRow() {
            $0.title = "腾讯"
            $0.value = false
        }.onCellSelection({ cell, row in
            setupSelectedInSection(row)
        })
        
        
        +++ Section("开关")
        <<< SwitchRow(RowTag.DOUBLETEACHER) {
            $0.title = "双师"
            $0.value = false
        }
        <<< SwitchRow(RowTag.MOBILETEACHING) {
            $0.title = "移动授课"
            $0.value = false
        }
        <<< SwitchRow(RowTag.AUXILIARYCAMERA) {
            $0.title = "辅助摄像头"
            $0.value = true
        }
        <<< SwitchRow(RowTag.BLUETOOTHENABLED) {
            $0.title = "蓝牙"
            $0.value = false
        }
        
        +++ Section("PPT")
        <<< ActionSheetRow<String>(RowTag.NEWPPT) {
            $0.title = "PPT类型"
            $0.selectorTitle = "选择PPT解析类型"
            $0.options = ["微软模式", "大西模式", "iSpring模式"]
            $0.value = "微软模式"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }

        +++ Section("")
        <<< TextRow(RowTag.INVITECODE) {
            $0.title = "邀请码"
            $0.placeholder = "请输入邀请码"
        }
        <<< TextRow(RowTag.INVITEURL) {
            $0.title = "邀请链接"
            $0.placeholder = "请输入邀请链接"
        }
        <<< TextRow(RowTag.PLATFORM) {
            $0.title = "平台方"
            $0.placeholder = "请输入平台方"
        }

        
        +++ Section("")
        <<< SwitchRow(RowTag.CUSTOMADDRESSENABLED) {
            $0.title = "自定义地址开关"
            $0.value = false
        }
        <<< TextRow(RowTag.CUSTOMADDRESS) {
            $0.title = "自定义地址"
            $0.value = "ws:192.168.3.56:9081"
            $0.hidden = "$CustomAddressEnabled == false"
        }
        
        +++ Section("音乐")
        <<< LabelRow() {
            $0.title = "播放音乐1"
        }.onCellSelection({ [weak self] cell, row in
            self?.playMusicAction(true)
        })
        <<< LabelRow() {
            $0.title = "播放音乐2"
        }.onCellSelection({ [weak self] cell, row in
            self?.playMusicAction(false)
        })
        <<< LabelRow() {
            $0.title = "停止播放"
        }.onCellSelection({ [weak self] cell, row in
            self?.stopMusicAction()
        })
        <<< LabelRow() {
            $0.title = "切换模式"
        }.onCellSelection({ [weak self] cell, row in
            self?.switchMusicAction()
        })

    }
    
    override func configInfoParameter() -> [String : Any] {
        let isAgora = form.rowBy(tag: RowTag.AGORA)?.baseValue as? Bool ?? true
        var dic: [String : Any] = [:]
        dic["vendorType"] = isAgora ? 2 : 3  //2. agora 3. trtc
                
        return dic
    }

}

//MARK: 获取配置的方法
extension InnerFeatureConfigViewController {
    func doubleTeacherEnabled() -> Bool {
        return form.rowBy(tag: RowTag.DOUBLETEACHER)?.baseValue as? Bool ?? false
    }
    
    func mobileTeachingEnabled() -> Bool {
        return form.rowBy(tag: RowTag.MOBILETEACHING)?.baseValue as? Bool ?? false
    }
    
    func auxiliaryCameraEnabled() -> Bool {
        return form.rowBy(tag: RowTag.AUXILIARYCAMERA)?.baseValue as? Bool ?? true
    }
    
    func bluetoothEnabled() -> Bool {
        return form.rowBy(tag: RowTag.BLUETOOTHENABLED)?.baseValue as? Bool ?? false
    }
    
    func inviteCode() -> String {
        return form.rowBy(tag: RowTag.INVITECODE)?.baseValue as? String ?? ""
    }
    
    func inviteURL() -> String {
        return form.rowBy(tag: RowTag.INVITEURL)?.baseValue as? String ?? ""
    }
    
    func platform() -> String {
        return form.rowBy(tag: RowTag.PLATFORM)?.baseValue as? String ?? ""
    }
    
    func customAddress() -> String {
        let enabled = form.rowBy(tag: RowTag.CUSTOMADDRESSENABLED)?.baseValue as? Bool ?? false
        return enabled ? (form.rowBy(tag: RowTag.CUSTOMADDRESS)?.baseValue as? String ?? "") : ""
    }
    
    func pptType() -> UpimeFileType {
        let ppt = form.rowBy(tag: RowTag.NEWPPT)?.baseValue as? String ?? ""
        
        switch ppt {
        case "大西模式":
            return UpimeFileType.NEW_PPT
        case "iSpring模式":
            return UpimeFileType.ISPRING_PPT
        default:
            return UpimeFileType.PPT
        }
    }
    
}

//MARK: 播放音乐
extension InnerFeatureConfigViewController {
    @objc func playMusicAction(_ usedefault:Bool) {
        do {
            if usedefault {
                let categoryOptions : AVAudioSession.CategoryOptions = [.mixWithOthers , .allowBluetooth ,.defaultToSpeaker]
                
                // try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
                try? AVAudioSession.sharedInstance().setCategory(.soloAmbient, options: categoryOptions)
                try? AVAudioSession.sharedInstance().setMode(.default)
                
                let session = AVAudioSession.sharedInstance()
                
                print("session: category \(session.category) \(session.categoryOptions) \(session.mode)")
            } else {
                let categoryOptions : AVAudioSession.CategoryOptions = [.mixWithOthers , .allowBluetooth ,.defaultToSpeaker]
                try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: categoryOptions)
                try? AVAudioSession.sharedInstance().setMode(.voiceChat)
                
                let session = AVAudioSession.sharedInstance()
                
                print("session: category \(session.category) \(session.categoryOptions) \(session.mode)")
            }
            
            guard let url = URL(string: "https://file.plaso.cn/test-plaso/teaching/1139/1024044_0_1630738880808.mp3") else {
                print("url   invalid")
                return
            }
            let playerItem = AVPlayerItem(url: url)
            player =   AVPlayer(playerItem: playerItem)
            player?.play()
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object:  self.player!.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
            }
            
            print("play:\(url)")
        }
    }
    
    @objc func stopMusicAction() {
        if nil != player {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player!)
            player!.pause()
            player = nil
        }
    }
    
    @objc func switchMusicAction() {
        
        if musicTag % 2 == 0 {
            let categoryOptions : AVAudioSession.CategoryOptions = [.mixWithOthers , .allowBluetooth ,.defaultToSpeaker]
            
            // try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try? AVAudioSession.sharedInstance().setCategory(.soloAmbient, options: categoryOptions)
            try? AVAudioSession.sharedInstance().setMode(.default)
            
            let session = AVAudioSession.sharedInstance()
            
            print("session: category \(session.category) \(session.categoryOptions) \(session.mode)")
        } else {
            let categoryOptions : AVAudioSession.CategoryOptions = [.mixWithOthers , .allowBluetooth ,.defaultToSpeaker]
            
            // try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: categoryOptions)
            try? AVAudioSession.sharedInstance().setMode(.voiceChat)
            
            let session = AVAudioSession.sharedInstance()
            
            print("session: category \(session.category) \(session.categoryOptions) \(session.mode)")
        }
        
        musicTag += 1
    }
}

