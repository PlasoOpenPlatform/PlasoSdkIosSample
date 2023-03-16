//
//  RecordBasicConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/15.
//

import UIKit
import Eureka

class RecordBasicConfigViewController: BaseConfigViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        form
        +++ Section("微课")
        <<< TextRow(RowTag.RECORDNAME) {
            $0.title = "微课名称"
            $0.placeholder = "请输入微课名称"
        }
        +++ Section("格式")
        <<< CheckRow(RowTag.AUDIO) {
            $0.title = "音频"
            $0.value = true
        }.onCellSelection({ cell, row in
            setupSelectedInSection(row)
        })
        <<< CheckRow() {
            $0.title = "视频"
            $0.value = false
        }.onCellSelection({ cell, row in
            setupSelectedInSection(row)
        })
        
    }

}

extension RecordBasicConfigViewController {
    func recordType() -> PureUpimeRecordType {
        let isAudio = form.rowBy(tag: RowTag.AUDIO)?.baseValue as? Bool ?? false
        return isAudio ? .audio : .video
    }
    
    func recordName() -> String {
        return form.rowBy(tag: RowTag.RECORDNAME)?.baseValue as? String ?? ""
    }
    
}
