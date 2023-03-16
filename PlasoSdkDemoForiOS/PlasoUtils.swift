//
//  PlasoUtils.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/12.
//

import UIKit
import Eureka

let SCREENWIDTH = UIScreen.main.bounds.size.width
let SCREENHEIGHT = UIScreen.main.bounds.size.height

func RGBCOLOR(r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) -> UIColor {
    return UIColor(red:(r)/255.0, green:(g)/255.0, blue:(b)/255.0, alpha:(a))
}

func isIphone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

func setupSelectedInSection(_ selectedRow: BaseRow) {
    for row in selectedRow.section?.allRows ?? [BaseRow()] {
        row.baseValue = false
        if row == selectedRow {
            row.baseValue = true
        }
        row.updateCell()
    }
}

extension Dictionary {
    mutating func appendDic(_ dic: Dictionary) {
        for (key, value) in dic {
            self.updateValue(value, forKey: key)
        }
    }
}
