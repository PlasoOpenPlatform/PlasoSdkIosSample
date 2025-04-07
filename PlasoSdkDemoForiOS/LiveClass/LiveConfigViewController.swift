//
//  MainViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/12.
//

import UIKit
import Material
import PlasoStyleUpime

let AppGroupID = "group.com.plaso.plasostudentipad.group"
let ExtensionName = "PlasoSDKScreenShare"

class LiveConfigViewController: UIViewController {
        
    private let authorizationConfigVC = AuthorizationConfigViewController()
    private let basicConfigVC = BasicConfigViewController()
    private let rtcConfigVC = RTCConfigViewController()
    private let featureConfigVC = FeatureConfigViewController()
    private var viewControllers: [BaseConfigViewController] = []
    private let contentView: UIView = UIView()
    weak var liveVC: (UIViewController & UpimeLiveProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toolbarController?.toolbar.titleLabel.text = "课堂配置"
    }
    
    private func setupUI() {
        let headerView = TopBarView.init(titles: ["鉴权", "基本配置", "RTC", "特性"])
        headerView.setupButtonHandle { [self] title in
            for vc in viewControllers {
                vc.view.isHidden = true
                var showView: UIView?
                if title == "鉴权" {
                    showView = authorizationConfigVC.view
                } else if title == "基本配置" {
                    showView = basicConfigVC.view
                } else if title == "RTC" {
                    showView = rtcConfigVC.view
                } else if title == "特性" {
                    showView = featureConfigVC.view
                }
                showView?.isHidden = false
                if showView != nil {
                    contentView.bringSubviewToFront(showView!)
                }
            }
        }
        
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                
        let footerView = FooterView.init("启动课堂")
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            footerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        } else {
            footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        footerView.setupButtonHandle { [self] in
            startLiveClass()
        }
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        viewControllers = [authorizationConfigVC, basicConfigVC, rtcConfigVC, featureConfigVC]
        for vc in viewControllers.reversed() {
            addChild(vc)
            contentView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            vc.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            vc.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
        
    }

    private func startLiveClass() {
        let query = generateQuery()
        let liveVC = PlasoStyleUpimeClient.createLive(withQuery: query)
        self.liveVC = liveVC
        liveVC.openFileMode = featureConfigVC.fileDisplayMode()
        liveVC.delegate = self
        liveVC.plasoDelegate = self;
        liveVC.supportCloudBox = true
        liveVC.supportLocalFile = true
        liveVC.enableVideoMark = true
        liveVC.uploadLogEnabled = featureConfigVC.uploadLogEnabled()
        liveVC.enableSendMessage = featureConfigVC.sendMessageEnabled()
        liveVC.configKey = featureConfigVC.configKey()
        if featureConfigVC.newTeachingAidsEnabled() {
            liveVC.teachToolTypes = PureUpimeTeachToolType(rawValue: PureUpimeTeachToolType.TRIANGLE.rawValue | PureUpimeTeachToolType.RECT.rawValue | PureUpimeTeachToolType.ELLIPSE.rawValue | PureUpimeTeachToolType.LINE.rawValue | PureUpimeTeachToolType.CIRCLE.rawValue | PureUpimeTeachToolType.DASHEDLINE.rawValue | PureUpimeTeachToolType.SQUARE.rawValue | PureUpimeTeachToolType.ARROW.rawValue | PureUpimeTeachToolType.FANSHAPED.rawValue | PureUpimeTeachToolType.PARALLELOGRAM.rawValue)!
        }

        liveVC.enableInteractPPT = featureConfigVC.interactPPTEnabled()
        liveVC.useNewSmallboard = featureConfigVC.newSmallboardEnabled()
        var toolBoxTypes = PureUpimeToolBoxType.none;
        if (featureConfigVC.classTestEnabled()) {
            toolBoxTypes = PureUpimeToolBoxType.classTest
        }
        if (featureConfigVC.timerEnabled()) {
            toolBoxTypes = PureUpimeToolBoxType(rawValue: toolBoxTypes.rawValue | PureUpimeToolBoxType.timer.rawValue)!
        }
        if (featureConfigVC.smallboardEnabled()) {
            toolBoxTypes = PureUpimeToolBoxType(rawValue: toolBoxTypes.rawValue | PureUpimeToolBoxType.smallBoard.rawValue)!
        }
        if (featureConfigVC.redPackageEnabled()) {
            toolBoxTypes = PureUpimeToolBoxType(rawValue: toolBoxTypes.rawValue | PureUpimeToolBoxType.redPacket.rawValue)!
        }
        if (featureConfigVC.browserEnabled()) {
            toolBoxTypes = PureUpimeToolBoxType(rawValue: toolBoxTypes.rawValue | PureUpimeToolBoxType.browser.rawValue)!
        }
        if (featureConfigVC.responderEnabled()) {
            toolBoxTypes = PureUpimeToolBoxType(rawValue: toolBoxTypes.rawValue | PureUpimeToolBoxType.responder.rawValue)!
        }
        if (featureConfigVC.diceEnabled()) {
            toolBoxTypes = PureUpimeToolBoxType(rawValue: toolBoxTypes.rawValue | PureUpimeToolBoxType.dice.rawValue)!
        }
        liveVC.toolBoxTypes = toolBoxTypes

        if let env = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOENV) {
            liveVC.host = "https://\(env.lowercased()).plaso.cn"
        } else {
            liveVC.host = "https://www.plaso.cn"
        }
        
        let watermark = featureConfigVC.wartermark()
        if watermark.count > 0 {
            liveVC.waterMark = watermark
        }
        
        if featureConfigVC.wartermarkSize() > 0 {
            liveVC.waterMarkSize = featureConfigVC.wartermarkSize()
        }
        
        if featureConfigVC.wartermarkOpacity() > 0 {
            liveVC.waterMarkOpacity = featureConfigVC.wartermarkOpacity()
        }
        
        liveVC.waterMarkDynamic = featureConfigVC.watermarkDynamicEnabled()
        liveVC.supportUndo = featureConfigVC.undoEnabled()
        liveVC.supportHighlighter = featureConfigVC.highLighter()

        if let remindTime = basicConfigVC.remindTime() {
            liveVC.endRemindTime = Int(remindTime.timeIntervalSince1970)
        }

        let redPackageLimit = featureConfigVC.redPackageLimit()
        if redPackageLimit > 0 {
            liveVC.redPacketLimit = Int32(redPackageLimit)
        }

        let permission = basicConfigVC.meetingPermission()
        if permission > 0 {
            liveVC.defaultPermission = Int32(permission)
        }
        
        liveVC.supportSelect = featureConfigVC.toolBarEnabled()
        liveVC.residentCamera = featureConfigVC.residentCameraEnabled()

        let to = WebviewObject()
        to.type = 2
        //to.message = "lalal"
        //to.url = "https://www.qq.com"

        let to2 = WebviewObject()
        to2.type = 1
        to2.message = "lalal"
        //to2.url = "https://www.sina.com"

        liveVC.webviewList = [to,to2]
        
        
        liveVC.enableSaveDocIndex = featureConfigVC.enableSaveDocIndex()
        liveVC.enableSignInLocation = featureConfigVC.enableSignInLocation()
        liveVC.enableVote = featureConfigVC.enableVote()
        liveVC.enableCtlANS = featureConfigVC.enableCtlANS()
        liveVC.shouldShowTeacherMember = featureConfigVC.shouldShowTeacherMember()
        liveVC.shouldShowAssistantMember = featureConfigVC.shouldShowAssistantMember()
        liveVC.enableSaveBoard = featureConfigVC.saveBoardEnabled()
        
        let groupInfo = UpimeIsolatedGroup()
        groupInfo.groupIDs = ["1","2"]
        groupInfo.groupUserCount = 5
        groupInfo.classUserCount = 10
        liveVC.isolatedGroup = groupInfo
        
        DispatchQueue.main.async {
            self.present(liveVC, animated: true, completion: nil)
        }
    }
    
    private func generateQuery() -> String {
        /*
         var MEDIA_TYPE={
             AUDIO    : 1 << 0,//音频互动课堂
             VIDEO    : 1 << 1,//视频互动课堂
             LIVE     : 1 << 2,//直播
             NOUPIME  : 1 << 3,//桌面
             SEPARATED: 1 << 4,//线下头像窗口分离课堂;
             PLATFORM: 1<< 5,//推流至第三方
             MEETING: 1 << 6,//会议直播，数据来源三方推送
             SERIES : 1 << 7,//系列，表示多场次的直播
             STORAGE: 1 << 8, // 存储

             WISDOM: 18,//智慧课堂，使用VIDEO | SEPARATED
             // 废弃
             LIVE_AUDIO : 5,//建议不使用，位|运算实现 1|4
             LIVE_VIDEO : 6,//建议不使用 2|4
             REAL_CAMERA : 15,//建议不使用 1|4
         }
         */
        let beginTime = Int(Date().timeIntervalSince1970)
        var parameters: [String : Any] = [:]
        parameters["beginTime"] = beginTime
        parameters["groupUserCount"] = 3
        parameters["validTime"] = 10800

        for vc in viewControllers {
            let dic = vc.configInfoParameter()
            parameters.appendDic(dic)
        }
        
        print(parameters)
        var query  = Tool.sign(params: parameters)

        return query
    }

}

extension LiveConfigViewController: PlasoFlutterDelegate {
    func plasoFlutterDisposed() {
        DispatchQueue.main.async {
            PlasoStyleUpimeClient.dispose();
        }
    }
}

extension LiveConfigViewController: TextFieldDelegate, UpimeLiveDelegate, UpimeEditorDelegate, PlasoCloudDiskTableViewControllerDelegate {
    
    //-------------------------UpimeEditorDelegate-----------------------------
    /*! @brief 获取签名字符串
     *
     * 当 SDK 在进行一些访问服务器调用的操作时，需要对 http 调用进行签名，出于数据安
     全的考虑，不要 SDK Client 传入 AccessKey 和 SecretKey，只需要 SDK Client 实现该方法，将传入的 Query 参数进行签名，通过 SignCallback 返回即可。保证了 SDK Client 对 Key 的安全性。Query 签名要求请参考签名说明
     *
     * @param upimeEditorVC 当前的ViewController
     * @param params 签名所需的参数
     * @param completion 完成签名后，调用该 Block 将结果返回 SDK
     */
    func upimeEditorVC(_ upimeEditorVC: UIViewController & UpimeEditorProtocol, getSignQueryByParams params: [AnyHashable : Any], completion: @escaping (String?) -> Void) {
        print("params is \(params)")
        var infoDic = params
        infoDic["appId"] = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOAPPID) ?? ""
        infoDic["validBegin"] = Int(Date().timeIntervalSince1970)
        infoDic["validTime"] = 120
        guard let info = infoDic as? [String: Any] else {
            completion(nil)
            return
        }
        let sign = Tool.sign(params: info)
        completion(sign)
    }
    
    func upimeVC(_ upimeVC: UIViewController & UpimeProtocol, getExtFileName info: [Any], result: @escaping (String) -> Void) {
        guard let params = info[1] as? [String: Any] else {
            return
        }
        guard let host = params["host"] as? String else {
            return
        }
        guard let path = params["path"] as? String  else {
            return
        }
        guard let fileName = params["fileName"] as? String  else {
            return
        }
        let url = host+path+fileName
        result(url)
    }
    
    func liveVC(_ liveVC: UIViewController & UpimeLiveProtocol, startScanCode scene: String, params: String, success: @escaping (String, String) -> Void, failed: @escaping (String, String) -> Void) {
        
        print("startScanCode scene:\(scene) params:\(params)")
        let controller = UIViewController()
        controller.view.backgroundColor = .yellow
        
        
        liveVC.present(controller, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                controller.dismiss(animated: true) {
                    print("模拟关闭")
                    success(scene,"testcode")
                }
            }
        }
    }
    
    /// 获取可打开的网页地址
    func liveVC(_ liveVC: UIViewController & UpimeLiveProtocol, getWebviewUrl type: Int32, result: @escaping (String) -> Void) {
        
        let urls = ["https://dev.plaso.cn/static/yxt/?appType=teachingMaterial&token=ptt3-1-ptt3wls-8bd3c8c3dc7f417988bed2ce19baeed8-5.17.700-ANDROID-plaso&androidVersion=5.17.700&platform=plaso"]//"https://www.qq.com",
        let url = urls.randomElement()
        print("open url: \(url!)")
        result(url!)
    }
    
    
    //-------------------------UpimeEditorDelegate----------------------------------
    
    func upimeShowCloudDisk(_ upimeEditorVC: UIViewController & UpimeEditorProtocol) {
        if let vc = upimeEditorVC.presentedViewController {
            vc.dismiss(animated: true, completion: nil)
        }
        let cdVC = PlasoCloudDiskTableViewController.init()
        cdVC.delegate = self
        let nav = UINavigationController.init(rootViewController: cdVC)
        upimeEditorVC.present(nav, animated: true, completion: nil)
    }
    
    func upimeShowCloudDisk(_ upimeEditorVC: UIViewController & UpimeEditorProtocol, checkAi: Bool) {
        if let vc = upimeEditorVC.presentedViewController {
            vc.dismiss(animated: true, completion: nil)
        }
        let cdVC = PlasoCloudDiskTableViewController.init()
        cdVC.delegate = self
        let nav = UINavigationController.init(rootViewController: cdVC)
        upimeEditorVC.present(nav, animated: true, completion: nil)
    }
    
    func upimeVC(onClosed upimeVC: UIViewController & UpimeProtocol, meetingID: String, code: Int) {
        upimeVC.dismiss(animated: true, completion: nil)
    }
    
    //----------------------CloudDiskViewControllerDelegate----------------------------
    
    func cloudDiskTableViewControllerDidSelectFile(file: [String : AnyObject]) {
        guard let urlStr = file["url"] as? String else {
            return
        }
        guard let webUrl = URL(string: urlStr) else {
            return
        }
        guard let fileTypeStr = file["fileType"] as? String else {
            return
        }
        var fileType: UpimeFileType
        if fileTypeStr == "Audio" {
            fileType = .AUDIO
        } else if fileTypeStr == "Video" {
            fileType = .VIDEO
        } else if fileTypeStr == "PDF" {
            fileType = .PDF
        } else if fileTypeStr == "Word" {
            fileType = .WORD
        } else if fileTypeStr == "Excel" {
            fileType = .EXCEL
        } else if fileTypeStr == "Image" {
            fileType = .IMAGE
        } else {
            fileType = .CANNOTHANDLE
        }
        
        defer {
            let upimeFile = UpimeFile.init(url: webUrl, type: fileType)
            upimeFile.title = file["title"] as? String ?? ""
            self.liveVC?.insert(upimeFile)
        }
        
        if let vc = self.liveVC?.presentedViewController {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    func liveVCShouldSendLog(_ liveVC: UIViewController & UpimeLiveProtocol) -> Bool {
        print("Callback bug report")
        return true
    }
    
    //----------------------UITextFieldDelegate----------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}


