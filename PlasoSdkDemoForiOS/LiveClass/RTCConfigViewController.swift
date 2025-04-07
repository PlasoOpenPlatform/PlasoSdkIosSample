//
//  RTCConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/13.
//

import UIKit
import Eureka

class RTCConfigViewController: BaseConfigViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .blue }
        
        form
        +++ Section("格式")
        <<< CheckRow(RowTag.AUDIO) {
            $0.title = "音频"
            $0.value = false
        }.onCellSelection({ cell, row in
            setupSelectedInSection(row)
        })
        <<< CheckRow() {
            $0.title = "视频"
            $0.value = true
        }.onCellSelection({ cell, row in
            setupSelectedInSection(row)
        })
                
        +++ Section("模式")
        <<< TextRow(RowTag.APPTYPE) {
            $0.title = "AppType"
            $0.value = "livaclassSDK"
        }
        
        <<< ActionSheetRow<String>(RowTag.SHARPNESS) {
            $0.title = "清晰度"
            $0.options = ["标清(10)", "高清(20)", "超清(30)"]
            $0.value = "标清(10)"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }
    
    }
    
    override func configInfoParameter() -> [String : Any] {
        let appType = form.rowBy(tag: RowTag.APPTYPE)?.baseValue ?? "liveclassSDK"
        let isAudio = form.rowBy(tag: RowTag.AUDIO)?.baseValue as? Bool ?? false
        let mediaType = isAudio ? "audio" : "video"
        let sharpness = form.rowBy(tag: RowTag.SHARPNESS)?.baseValue as? String ?? ""
        let sharpnessNum = (["标清(10)", "高清(20)", "超清(30)"].firstIndex(of: sharpness) ?? 0 + 1) * 10
        let isAgora = form.rowBy(tag: RowTag.AGORA)?.baseValue as? Bool ?? true
        
        var dic: [String : Any] = [:]
        dic["appType"] = appType
        dic["mediaType"] = mediaType
        dic["d_sharpness"] = sharpnessNum
        dic["vendorType"] = isAgora ? 2 : 3  //2. agora 3. trtc
                
        return dic
    }

}


