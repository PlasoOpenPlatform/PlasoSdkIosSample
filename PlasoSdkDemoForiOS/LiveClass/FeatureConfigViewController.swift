//
//  FeatureConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/13.
//

import UIKit
import Eureka

class FeatureConfigViewController: BaseConfigViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    private func setupUI() {
        
        form
        +++ Section("水印功能")
        <<< SwitchRow("watermark_enabled") {
            $0.title = "开启水印"
            $0.value = false
        }

        <<< TextRow(RowTag.WATERMARK) {
            $0.title = "水印文字"
            $0.hidden = "$watermark_enabled == false"
            $0.placeholder = "请输入水印文字"
        }

        <<< IntRow(RowTag.WATERMARKSIZE) {
            $0.title = "水印大小"
            $0.hidden = "$watermark_enabled == false"
            $0.placeholder = "请输入水印大小"
        }
        
        <<< IntRow(RowTag.WATERMARKOPACITY) {
            $0.title = "水印透明度"
            $0.hidden = "$watermark_enabled == false"
            $0.placeholder = "请输入水印透明度"
        }
        
        <<< SwitchRow(RowTag.WATERMARKDYNAMIC) {
            $0.title = "动态水印"
            $0.value = false
            $0.hidden = "$watermark_enabled == false"
        }

        +++ Section("功能")
        <<< ActionSheetRow<String>(RowTag.FILETYPE) {
            $0.title = "文件类型"
            $0.selectorTitle = "选择文件类型"
            $0.options = ["图片模式", "窗口模式"]
            $0.value = "图片模式"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }
    
        <<< SwitchRow(RowTag.SENDMESSAGEENABLED) {
            $0.title = "允许发送消息"
            $0.value = true
        }
        <<< SwitchRow(RowTag.UNDOENABLED) {
            $0.title = "支持撤销"
            $0.value = true
        }
        <<< TextRow(RowTag.CONFIGKEY) {
            $0.title = "ConfigKey"
            $0.placeholder = "请输入ConfigKey"
        }
        <<< SwitchRow(RowTag.INTERACTPPTENABLED) {
            $0.title = "可交互PPT"
            $0.value = true
        }
        
        +++ Section("工具栏")
        <<< SwitchRow(RowTag.TOOLBARENABLED) {
            $0.title = "支持工具栏选择"
            $0.value = true
        }
        <<< SwitchRow(RowTag.NEWTEACHINGAIDSENABLED) {
            $0.title = "新教具"
            $0.value = true
        }
        <<< SwitchRow(RowTag.NEWSMALLBOARD) {
            $0.title = "新小黑板"
            $0.value = true
        }
        <<< SwitchRow(RowTag.CLASSTEST) {
            $0.title = "添加随堂测"
            $0.value = true
        }
        <<< SwitchRow(RowTag.TIMERENABLED) {
            $0.title = "添加定时器"
            $0.value = true
        }
        <<< SwitchRow(RowTag.SMALLBOARDENABLED) {
            $0.title = "添加小黑板"
            $0.value = true
        }
        <<< SwitchRow(RowTag.REDPACKAGE) {
            $0.title = "添加红包雨"
            $0.value = true
        }
        <<< SwitchRow(RowTag.BROWSERENABLED) {
            $0.title = "添加浏览器"
            $0.value = true
        }
        <<< SwitchRow(RowTag.RESPONDERENABLED) {
            $0.title = "添加抢答器"
            $0.value = true
        }
        <<< SwitchRow(RowTag.DICEENABLED) {
            $0.title = "添加骰子"
            $0.value = true
        }
        <<< SwitchRow(RowTag.RESIDENTCAMERA) {
            $0.title = "常驻摄像头"
            $0.value = true
        }


        <<< IntRow(RowTag.REDPACKAGELIMIT) {
            $0.title = "红包雨上限"
            $0.placeholder = "请输入红包雨个数上限"
        }
        
    }
    
    override func configInfoParameter() -> [String : Any] {
        return [:]
    }

}

extension FeatureConfigViewController {
    
    func fileDisplayMode() -> UpimeOpenFileMode {
        let type = form.rowBy(tag: RowTag.FILETYPE)?.baseValue as? String ?? ""
        return type == "图片模式" ? .picture : .window
    }
    
    func sendMessageEnabled() -> Bool {
        return form.rowBy(tag: RowTag.SENDMESSAGEENABLED)?.baseValue as? Bool ?? true
    }
    
    func configKey() -> String {
        return form.rowBy(tag: RowTag.CONFIGKEY)?.baseValue as? String ?? ""
    }
    
    func newTeachingAidsEnabled() -> Bool {
        return form.rowBy(tag: RowTag.NEWTEACHINGAIDSENABLED)?.baseValue as? Bool ?? true
    }
    
    func interactPPTEnabled() -> Bool {
        return form.rowBy(tag: RowTag.INTERACTPPTENABLED)?.baseValue as? Bool ?? true
    }
    
    func newSmallboardEnabled() -> Bool {
        return form.rowBy(tag: RowTag.NEWSMALLBOARD)?.baseValue as? Bool ?? true
    }
    
    func classTestEnabled() -> Bool {
        return form.rowBy(tag: RowTag.CLASSTEST)?.baseValue as? Bool ?? true
    }
    
    func timerEnabled() -> Bool {
        return form.rowBy(tag: RowTag.TIMERENABLED)?.baseValue as? Bool ?? true
    }
    
    func smallboardEnabled() -> Bool {
        return form.rowBy(tag: RowTag.SMALLBOARDENABLED)?.baseValue as? Bool ?? true
    }
    
    func redPackageEnabled() -> Bool {
        return form.rowBy(tag: RowTag.REDPACKAGE)?.baseValue as? Bool ?? true
    }
    
    func browserEnabled() -> Bool {
        return form.rowBy(tag: RowTag.BROWSERENABLED)?.baseValue as? Bool ?? true
    }
    
    func responderEnabled() -> Bool {
        return form.rowBy(tag: RowTag.RESPONDERENABLED)?.baseValue as? Bool ?? true
    }
    
    func diceEnabled() -> Bool {
        return form.rowBy(tag: RowTag.DICEENABLED)?.baseValue as? Bool ?? true
    }
    
    private func watermarkEnabled() -> Bool {
        return form.rowBy(tag: RowTag.WATERMARKENABLED)?.baseValue as? Bool ?? false
    }
    
    func wartermark() -> String {
        return watermarkEnabled() ? (form.rowBy(tag: RowTag.WATERMARK)?.baseValue as? String ?? "") : ""
    }
    
    func wartermarkSize() -> Double {
        return watermarkEnabled() ? Double(form.rowBy(tag: RowTag.WATERMARKSIZE)?.baseValue as? Int ?? 0) : 0
    }

    func wartermarkOpacity() -> Double {
        return watermarkEnabled() ? Double(form.rowBy(tag: RowTag.WATERMARKOPACITY)?.baseValue as? Int ?? 0) : 0
    }
    
    func watermarkDynamicEnabled() -> Bool {
        return watermarkEnabled() ? (form.rowBy(tag: RowTag.WATERMARKDYNAMIC)?.baseValue as? Bool ?? false) : false
    }
    
    func undoEnabled() -> Bool {
        return form.rowBy(tag: RowTag.UNDOENABLED)?.baseValue as? Bool ?? true
    }
    
    func redPackageLimit() -> Int {
        return form.rowBy(tag: RowTag.REDPACKAGELIMIT)?.baseValue as? Int ?? 0
    }
    
    func toolBarEnabled() -> Bool {
        return form.rowBy(tag: RowTag.TOOLBARENABLED)?.baseValue as? Bool ?? true
    }
    
    func residentCameraEnabled() -> Bool {
        return form.rowBy(tag: RowTag.RESIDENTCAMERA)?.baseValue as? Bool ?? true
    }
    

    
}
