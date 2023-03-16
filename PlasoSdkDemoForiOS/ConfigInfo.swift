//
//  ConfigInfo.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/12.
//

import UIKit

enum CellType: String {
    case label, control, textfiled, selection
}

class ConfigInfo: NSObject {
    
    private var tag: String = ""
    private var title: String = ""
    private var type: CellType = .label

}
