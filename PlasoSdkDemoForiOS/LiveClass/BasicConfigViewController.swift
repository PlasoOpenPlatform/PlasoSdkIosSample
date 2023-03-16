//
//  BasicConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/13.
//

import UIKit
import Eureka

class BasicConfigViewController: BaseConfigViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .blue }

        form
        +++ Section("个人") 
        <<< ActionSheetRow<String>(RowTag.USERTYPE) {
            $0.title = "角色"
            $0.selectorTitle = "选择角色类型"
            $0.options = ["speaker", "listener", "assistant", "visitor", "superlistener", "weblistener"]
            $0.value = "speaker"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }
        <<< TextRow(RowTag.USERNAME) {
            $0.title = "UserName"
            $0.placeholder = "UserName"
            let userName = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOUSERNAME) ?? "hello"
            $0.value = userName
        }.onCellHighlightChanged({ cell, row in
            if row.isHighlighted == false, let userName = row.value {
                UserDefaults.standard.set(userName, forKey: UserDefaultsKey.PLASOUSERNAME)
            }
        })
        <<< TextRow(RowTag.LOGINNAME) {
            $0.title = "LoginName"
            $0.placeholder = "LoginName"
            let loginName = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOLOGINNAME) ?? "testUser"
            $0.value = loginName
        }.onCellHighlightChanged({ cell, row in
            if row.isHighlighted == false, let loginName = row.value {
                UserDefaults.standard.set(loginName, forKey: UserDefaultsKey.PLASOLOGINNAME)
            }
        })
    
        +++ Section("课堂")
        <<< TextRow(RowTag.MEETINGID) {
            $0.title = "MeetingId"
            $0.placeholder = "MeetingId"
            let meetingId = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOMEETINGID) ?? "test"
            $0.value = meetingId
        }.onCellHighlightChanged({ cell, row in
            if row.isHighlighted == false, let meetingId = row.value {
                UserDefaults.standard.set(meetingId, forKey: UserDefaultsKey.PLASOMEETINGID)
            }
        })
        
        <<< LabelRow(RowTag.MEETINGTYPE) {
            $0.title = "课堂类型"
            $0.value = "public"
        }
        <<< LabelRow(RowTag.SCREENRATIO) {
            //目前仅支持两种输入，1：1280x720（16:9的课堂，字母是x，不是*）2：不写（4:3的课堂）
            $0.title = "屏幕比例"
            $0.value = "1280x720"
        }
        <<< IntRow() {
            $0.title = "课程时长(分钟)"
            $0.value = 20
        }
        <<< IntRow(RowTag.ONLINENUMBER) {
            $0.title = "上台人数(1vN)"
            $0.value = 6
        }
        
        +++ Section("提醒时间")
        <<< DateRow(RowTag.DATE) {
            $0.value = Date()
            $0.title = "日期"
        }
        <<< CountDownInlineRow(RowTag.TIME) {
            $0.value = Date()
            $0.title = "时间"
        }
    }
    
    private func resetSelected(_ selectedRow: BaseRow) {
        for row in selectedRow.section?.allRows ?? [BaseRow()] {
            row.baseValue = false
            if row == selectedRow {
                row.baseValue = true
            }
            row.updateCell()
        }
    }
    
    override func configInfoParameter() -> [String : Any] {
        var dic: [String : Any] = [:]

        let loginName = form.rowBy(tag: RowTag.LOGINNAME)?.baseValue ?? ""
        let userName = form.rowBy(tag: RowTag.USERNAME)?.baseValue ?? ""
        let meetingId = form.rowBy(tag: RowTag.MEETINGID)?.baseValue ?? ""
        let meetingType = form.rowBy(tag: RowTag.MEETINGTYPE)?.baseValue ?? ""
        let userType = form.rowBy(tag: RowTag.USERTYPE)?.baseValue ?? ""
        let onlineNumber = form.rowBy(tag: RowTag.ONLINENUMBER)?.baseValue ?? 6
        if let screenRatio = form.rowBy(tag: RowTag.SCREENRATIO)?.baseValue {
            dic["d_dimension"] = screenRatio
        }
        
        if let duration = form.rowBy(tag: RowTag.SCREENRATIO)?.baseValue as? Int {
            let lessonDuration = duration * 60
            dic["validTime"] = lessonDuration
            dic["endTime"] = Int(Date().timeIntervalSince1970) + lessonDuration
        }
            
        dic["loginName"] = loginName
        dic["userName"] = userName
        dic["meetingId"] = meetingId
        dic["meetingType"] = meetingType
        dic["userType"] = userType
        dic["onlineMode"] = onlineNumber

        return dic
    }

}

extension BasicConfigViewController {
    func meetingPermission() -> Int {
        return form.rowBy(tag: RowTag.MEETINGPERMISSION)?.baseValue as? Int ?? 0
    }
    
    func remindTime() -> Date? {
        return form.rowBy(tag: RowTag.DATE)?.baseValue as? Date
    }
}
