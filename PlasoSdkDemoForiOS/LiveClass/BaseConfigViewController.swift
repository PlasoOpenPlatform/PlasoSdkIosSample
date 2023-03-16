//
//  BaseConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/14.
//

import UIKit
import Eureka

class BaseConfigViewController: FormViewController, ConfigInfoProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc func configInfoParameter() -> [String : Any] {
        return [:]
    }
}
