//
//  AppAuthorizationViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/13.
//

import UIKit
import Eureka

class AuthorizationConfigViewController: BaseConfigViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .green
        setupUI()
    }
    
    private func setupUI() {
        form
        +++ Section("环境设置") 

        <<< ActionSheetRow<String>() {
            $0.title = "当前环境"
            $0.selectorTitle = "切换环境"
            $0.options = ["WWW", "TEST", "DEV"]
            let env = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOENV) ?? "WWW"
            $0.value = env
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }.onChange({ row in
            if let env = row.value {
                UserDefaults.standard.set(env, forKey: UserDefaultsKey.PLASOENV)
            }
        })
    
        <<< TextRow(RowTag.APPID) {
            $0.title = "AppId"
            $0.placeholder = "AppId"
            if let appId = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOAPPID) {
                $0.value = appId
                AppConfig.appId = appId
            }
        }.onCellHighlightChanged({ cell, row in
            if row.isHighlighted == false, let appId = row.value {
                AppConfig.appId = appId
                UserDefaults.standard.set(appId, forKey: UserDefaultsKey.PLASOAPPID)
            }
        })
        <<< TextRow(RowTag.APPKEY) {
            $0.title = "AppKey"
            $0.placeholder = "AppKey"
            if let appKey = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOAPPKEY) {
                $0.value = appKey
                AppConfig.appKey = appKey
            }
        }.onCellHighlightChanged({ cell, row in
            if row.isHighlighted == false, let appKey = row.value {
                AppConfig.appKey = appKey
                UserDefaults.standard.set(appKey, forKey: UserDefaultsKey.PLASOAPPKEY)
            }
        })

        +++ Section("版本信息")
        <<< LabelRow() {
            let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
            let sdkVersion = PlasoStyleUpimeClient.versionInfo()
            $0.value = "v\(versionString) - build: \(buildString) - sdk: \(sdkVersion)"
        }.cellSetup({ cell, row in
            cell.accessoryType = .none
            cell.selectionStyle = .none
        })

    }

    override func configInfoParameter() -> [String : Any] {
        let appId = form.rowBy(tag: RowTag.APPID)?.baseValue ?? ""
        let appKey = form.rowBy(tag: RowTag.APPKEY)?.baseValue ?? ""
        UserDefaults.standard.set(appId, forKey: UserDefaultsKey.PLASOAPPID)
        UserDefaults.standard.set(appKey, forKey: UserDefaultsKey.PLASOAPPKEY)
        var dic: [String : Any] = [:]
        dic["appId"] = appId
        return dic
    }

}

