//
//  Constant.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/14.
//

import UIKit

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
    static let ONLINENUMBER = "OnlineNumber"
    static let SHARPNESS = "Sharpness"
    static let SCREENRATIO = "ScreenRatio"
    static let AGORA = "Agora"
    static let CUSTOMADDRESSENABLED = "CustomAddressEnabled"
    static let CUSTOMADDRESS = "CustomAddress"
    static let FILETYPE = "FileType"
    static let SENDMESSAGEENABLED = "SendMessageEnabled"
    static let CONFIGKEY = "ConfigKey"
    static let BLUETOOTHENABLED = "BluetoothEnabled"
    static let NEWTEACHINGAIDSENABLED = "NewTeachingAidsEnabled"
    static let INTERACTPPTENABLED = "InteractPPTEnabled"
    static let NEWSMALLBOARD = "NewSmallboard"
    static let CLASSTEST = "ClassTest"
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
    static let REDPACKAGELIMIT = "RedPackageLimit"
    static let MEETINGPERMISSION = "MeetingPermission"
    static let TOOLBARENABLED = "ToolBarEnabled"
    static let MOBILETEACHING = "MobileTeachingEnabled"
    static let RESIDENTCAMERA = "ResidentCameraEnabled"
    static let AUXILIARYCAMERA = "AuxiliaryCameraEnabled"
    static let NEWPPT = "NewPPTEnabled"
    static let INVITECODE = "InviteCode"
    static let INVITEURL = "InviteURL"
    static let PLATFORM = "Platform"
    static let DURATION = "Duration"
    static let DATE = "Date"
    static let DRAFT = "Draft"
    static let CLOUDDISK = "CloudDisk"
    static let LOCALFILE = "LocalFile"
    static let FILES = "Files"
    static let RECORDNAME = "RecordName"

}

