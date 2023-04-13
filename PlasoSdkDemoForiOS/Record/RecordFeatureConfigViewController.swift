//
//  RecordFeatureConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/15.
//

import UIKit
import Eureka

class RecordFeatureConfigViewController: BaseConfigViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
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
        <<< TextRow(RowTag.CONFIGKEY) {
            $0.title = "ConfigKey"
            $0.placeholder = "请输入ConfigKey"
        }
        <<< IntRow(RowTag.FILES) {
            $0.title = "Files"
            $0.value = 1
        }
        <<< LabelRow() { row in
            row.title = "打开网页"
        }.cellSetup({ cell, row in
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .gray
        }).onCellSelection({ [weak self] cell, row in
            row.deselect()
            let controller = AWebViewController()
            controller.url = PLASOOFFICIALWEBURL
            let nav = UINavigationController.init(rootViewController: controller)
            self?.present(nav, animated: true, completion: nil)
        })
        
        +++ Section("开关")
        <<< SwitchRow(RowTag.DRAFT) {
            $0.title = "支持草稿"
            $0.value = true
        }
        <<< SwitchRow(RowTag.UNDOENABLED) {
            $0.title = "支持撤销"
            $0.value = true
        }
        <<< SwitchRow(RowTag.CLOUDDISK) {
            $0.title = "支持云盘"
            $0.value = true
        }
        <<< SwitchRow(RowTag.LOCALFILE) {
            $0.title = "支持本地文件"
            $0.value = true
        }
        <<< SwitchRow(RowTag.NEWTEACHINGAIDSENABLED) {
            $0.title = "新教具"
            $0.value = true
        }
        <<< SwitchRow(RowTag.INTERACTPPTENABLED) {
            $0.title = "可交互PPT"
            $0.value = true
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
    }


}

extension RecordFeatureConfigViewController {
    func configKey() -> String {
        return form.rowBy(tag: RowTag.CONFIGKEY)?.baseValue as? String ?? ""
    }
    
    func interactPPTEnabled() -> Bool {
        return form.rowBy(tag: RowTag.INTERACTPPTENABLED)?.baseValue as? Bool ?? true
    }
    
    private func watermarkEnabled() -> Bool {
        return form.rowBy(tag: RowTag.WATERMARKENABLED)?.baseValue as? Bool ?? false
    }
    
    func wartermarkSize() -> Double {
        return watermarkEnabled() ? Double(form.rowBy(tag: RowTag.WATERMARKSIZE)?.baseValue as? Int ?? 0) : 0
    }
    
    func wartermark() -> String {
        return watermarkEnabled() ? (form.rowBy(tag: RowTag.WATERMARK)?.baseValue as? String ?? "") : ""
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
    
    func newTeachingAidsEnabled() -> Bool {
        return form.rowBy(tag: RowTag.NEWTEACHINGAIDSENABLED)?.baseValue as? Bool ?? true
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
    
    func draftEnabled() -> Bool {
        return form.rowBy(tag: RowTag.DRAFT)?.baseValue as? Bool ?? true
    }
    
    func cloudDiskEnabled() -> Bool {
        return form.rowBy(tag: RowTag.CLOUDDISK)?.baseValue as? Bool ?? true
    }
    
    func localFileEnabled() -> Bool {
        return form.rowBy(tag: RowTag.LOCALFILE)?.baseValue as? Bool ?? true
    }
    
    func files() -> Int {
        return form.rowBy(tag: RowTag.FILES)?.baseValue as? Int ?? 1
    }
    
    func fileDisplayMode() -> UpimeOpenFileMode {
        let type = form.rowBy(tag: RowTag.FILETYPE)?.baseValue as? String ?? ""
        return type == "图片模式" ? .picture : .window
    }
}
