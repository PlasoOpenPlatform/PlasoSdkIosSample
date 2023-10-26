//
//  LeftViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/12.
//

import UIKit
import Eureka

class LeftViewController: FormViewController {
    
    var liveConfigVC: UIViewController?
    var recordConfigVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
        
    private func setupUI() {
        form +++ Section("分类") { section in
            section.header?.height = {150}
        }
        
        <<< LabelRow() { row in
            row.title = "实时课堂"
            row.tag = "live"
        }.cellSetup({ cell, row in
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .gray
            cell.height = {(isIphone() ? 50 : 60)}
        }).onCellSelection({ [weak self] cell, row in
            self?.toolbarController?.transition(to: self?.liveConfigVC ?? LiveConfigViewController())
            self?.navigationDrawerController?.closeLeftView()
        })
        
        <<< LabelRow() { row in
            row.title = "微课"
            row.tag = "mini"
        }.cellSetup({ cell, row in
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .gray
            cell.height = {(isIphone() ? 50 : 60)}
        }).onCellSelection({ [weak self] cell, row in
            self?.toolbarController?.transition(to: self?.recordConfigVC ?? RecordConfigViewController())
            self?.navigationDrawerController?.closeLeftView()
        })
                        
    }
    
}
