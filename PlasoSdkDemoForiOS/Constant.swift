//
//  Constant.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/14.
//

import UIKit
import Eureka

let PLASOOFFICIALWEBURL = "https://www.plaso.cn/"

protocol ConfigInfoProtocol {
    func configInfoParameter() -> [String : Any]
}

public struct UserDefaultsKey {
    static let PLASOENV = "PlasoEnv"
    static let PLASOAPPID = "PlasoAppID"
    static let PLASOAPPKEY = "PlasoAppKey"
    static let PLASOMEETINGID = "meetIDKey"
    static let PLASOUSERNAME = "userNameKey"
    static let PLASOLOGINNAME = "loginNameKey"
    static let PLASOROLEKEY = "roleKey"

}

public struct RowTag {
    static let APPID = "AppId"
    static let APPKEY = "AppKey"
    static let APPTYPE = "AppType"
    static let LOGINNAME = "LoginName"
    static let USERNAME = "UserName"
    static let AUDIO = "Audio"
    static let MEETINGID = "MeetingId"
    static let MEETINGTYPE = "MeetingType"
    static let USERTYPE = "UserType"
    static let DOUBLETEACHER = "DoubleTeacher"
    static let LIVE = "Live" //直播
    static let CommentLIVE = "CommentLIVE" // 评论直播
    static let ONLINENUMBER = "OnlineNumber"
    static let SHARPNESS = "Sharpness"
    static let SCREENRATIO = "ScreenRatio"
    static let DURATION = "Duration"
    static let AGORA = "Agora"
    static let CUSTOMADDRESSENABLED = "CustomAddressEnabled"
    static let CUSTOMADDRESS = "CustomAddress"
    static let FILETYPE = "FileType"
    static let SENDMESSAGEENABLED = "SendMessageEnabled"
    static let CONFIGKEY = "ConfigKey"
    static let BLUETOOTHENABLED = "BluetoothEnabled"
    static let NEWTEACHINGAIDSENABLED = "NewTeachingAidsEnabled"
    static let INTERACTPPTENABLED = "InteractPPTEnabled"
    static let UPLOADLOGENABLED = "UploadLogEnabled"
    static let NEWSMALLBOARD = "NewSmallboard"
    static let CLASSTEST = "ClassTest"
    static let NEWCLASSTEST = "NewClassTest"
    static let TIMERENABLED = "TimerEnabled"
    static let SMALLBOARDENABLED = "SmallEnabled"
    static let REDPACKAGE = "RedPackage"
    static let BROWSERENABLED = "BrowserEnabled"
    static let RESPONDERENABLED = "ResponderEnabled"
    static let DICEENABLED = "DiceEnabled"
    static let WATERMARKENABLED = "watermark_enabled"
    static let WATERMARKSIZE = "WatermarkSize"
    static let WATERMARK = "Watermark"
    static let WATERMARKOPACITY = "WatermarkOpacity"
    static let WATERMARKDYNAMIC = "WatermarkDynamic"
    static let UNDOENABLED = "UndoEnabeld"
    static let HighLIGHTER = "SupportHighLight"
    static let REDPACKAGELIMIT = "RedPackageLimit"
    static let OBJECTERASER = "ObjectEraser"
    static let MEETINGPERMISSION = "MeetingPermission"
    static let TOOLBARENABLED = "ToolBarEnabled"
    static let MOBILETEACHING = "MobileTeachingEnabled"
    static let RESIDENTCAMERA = "ResidentCameraEnabled"
    static let AUXILIARYCAMERA = "AuxiliaryCameraEnabled"
    static let NEWPPT = "NewPPTEnabled"
    static let INVITECODE = "InviteCode"
    static let INVITEURL = "InviteURL"
    static let PLATFORM = "Platform"
    static let DATE = "Date"
    static let DRAFT = "Draft"
    static let CLOUDDISK = "CloudDisk"
    static let SAVEBOARD = "SaveBoard"
    static let SHAREBOARDTOHISTORY = "shareBoardToHistory"
    static let LOCALFILE = "LocalFile"
    static let FILES = "Files"
    static let RECORDNAME = "RecordName"
    static let CURRENTENV = "CurrentEnv"
    static let ENABLESAVEDOCINDEX = "ENABLESAVEDOCINDEX"
    static let ENABLESIGNINLOCATION = "ENABLESIGNINLOCATION"
    static let LIVESIGNENABLED = "LiveSignEnabled"
    static let LIVEOFFLINESIGNENABLED = "LiveOfflineSignEnabled"
    static let VOTEENABLED = "VoteEnabled"
    static let CTLANSENABLED = "CtlANSEnabled"

    static let LIVECONNECT_ENABLE = "LIVECONNECT_ENABLE"
    static let LIVECONNECT_CAMERA_ENABLE = "LIVECONNECT_CAMERA_ENABLE"
    
    static let MEMBER_TEACHER = "MEMBER_TEACHER"
    static let MEMBER_ASSISTANT = "MEMBER_ASSISTANT"

    
}

/// 对象擦类型
enum ObjectEraserType: UInt, CaseIterable {
    case pointErase = 0
    case handwritingOnly = 1
    case handwritingTextBox = 3
    case handwritingShapes = 5
    case handwritingTextBoxShapes = 7

    var displayText: String {
        switch self {
        case .pointErase: return "点擦"
        case .handwritingOnly: return "对象擦（手写）"
        case .handwritingTextBox: return "对象擦（手写+文本框）"
        case .handwritingShapes: return "对象擦（手写+图形）"
        case .handwritingTextBoxShapes: return "对象擦（手写+文本框+图形）"
        }
    }

    static func from(text: String) -> ObjectEraserType? {
        return allCases.first { $0.displayText == text }
    }
    
    static func from(row: BaseRow?) -> UInt {
        if let selectedText = row?.baseValue as? String,
           let selectedEnum = ObjectEraserType.from(text: selectedText) {
            return selectedEnum.rawValue
        }
        return ObjectEraserType.pointErase.rawValue
    }
}
