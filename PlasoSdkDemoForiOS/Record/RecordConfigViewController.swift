//
//  RecordConfigViewController.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/12.
//

import UIKit
import Material
import Eureka

class RecordConfigViewController: UIViewController {

    private let contentView: UIView = UIView()
    private var viewControllers: [BaseConfigViewController] = []
    private let authorizationConfigVC = AuthorizationConfigViewController()
    private let basicConfigVC = RecordBasicConfigViewController()
    private let featureConfigVC = RecordFeatureConfigViewController()
    weak var recorderVC: UpimeRecordProtocol?
    var client: PlasoStyleUpimeClient?
    var recorderArray = [UpimeRecordInfo]()

    let recordDirector : String = {
        if let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
            return documentPath + "/plaso_record"
        }
        return ""
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let option = PlasoStyleUpimeClientOptions()
        option.logDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        client = PlasoStyleUpimeClient.sharedClient(withOption: option)
        
        setupUI()
        initRecordData()
    }
    
    private func initRecordData() {
        client?.getDraftList(withConfigKey: nil, result: { [unowned self] result in
            if let result = result {
                recorderArray = result;
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toolbarController?.toolbar.titleLabel.text = "微课配置"
    }
    
    func setupUI() {
        let headerView = TopBarView.init(titles: ["鉴权", "基本配置", "特性"])
        headerView.setupButtonHandle { [self] title in
            for vc in viewControllers {
                vc.view.isHidden = true
                var showView: UIView?
                if title == "鉴权" {
                    showView = authorizationConfigVC.view
                }
                else if title == "基本配置" {
                    showView = basicConfigVC.view
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
                
        let footerView = FooterView.init("创建微课")
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
            createRecord()
        }
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        viewControllers = [authorizationConfigVC, basicConfigVC, featureConfigVC]
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
    
    func createRecord() {
        let path = recordDirector + "/" + UUID().uuidString
        let recorderVC = PlasoStyleUpimeClient.createRecorder(withPath: path)
        recorderVC.supportDraft = featureConfigVC.draftEnabled()
        recorderVC.supportUndo = featureConfigVC.undoEnabled()
        recorderVC.supportCloudBox = featureConfigVC.cloudDiskEnabled()
        recorderVC.supportLocalFile = featureConfigVC.localFileEnabled()
        recorderVC.files = featureConfigVC.files()
        recorderVC.openFileMode = featureConfigVC.fileDisplayMode()
        recorderVC.waterMark = featureConfigVC.wartermark()
        let wartermarkSize = featureConfigVC.wartermarkSize()
        if wartermarkSize > 0 {
            recorderVC.waterMarkSize = wartermarkSize
        }
        let wartermarkOpacity = featureConfigVC.wartermarkOpacity()
        if wartermarkOpacity > 0 {
            recorderVC.waterMarkOpacity = wartermarkOpacity
        }
        recorderVC.waterMarkDynamic = featureConfigVC.watermarkDynamicEnabled()

        recorderVC.enableInteractPPT = featureConfigVC.interactPPTEnabled()
        recorderVC.recordType = basicConfigVC.recordType()
        recorderVC.delegate = self;

        let configKey = featureConfigVC.configKey()
        if configKey.count > 0 {
            recorderVC.configKey = configKey
        }

        let recordName = basicConfigVC.recordName()
        if recordName.count > 0 {
            recorderVC.defaultRecordName = recordName
        }

        if featureConfigVC.newTeachingAidsEnabled() {
            recorderVC.teachToolTypes = PureUpimeTeachToolType(rawValue: PureUpimeTeachToolType.TRIANGLE.rawValue | PureUpimeTeachToolType.RECT.rawValue | PureUpimeTeachToolType.ELLIPSE.rawValue | PureUpimeTeachToolType.LINE.rawValue | PureUpimeTeachToolType.CIRCLE.rawValue | PureUpimeTeachToolType.DASHEDLINE.rawValue | PureUpimeTeachToolType.SQUARE.rawValue)!
        }

        let env = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOENV) ?? "WWW"
        recorderVC.host = "https://\(env.lowercased()).plaso.cn"
        recorderVC.logDir = NSHomeDirectory();
        recorderVC.modalPresentationCapturesStatusBarAppearance = true
        present(recorderVC, animated: true, completion: nil)
        self.recorderVC = recorderVC
    }

}

extension RecordConfigViewController: PlasoCloudDiskTableViewControllerDelegate {
    
    func cloudDiskTableViewControllerDidSelectFile(file: [String : String]) {
        guard let fileURLString = file["url"] as String? else {
            return
        }
        
        guard let fileURL = URL(string: fileURLString) else {
            return
        }
        
        guard let fileType = file["fileType"] as String? else {
            return
        }
        
        var upimeFileType = UpimeFileType.CANNOTHANDLE
        switch fileType {
        case "Audio":
            upimeFileType = .AUDIO
        case "Video":
            upimeFileType = .VIDEO
        case "PPT":
            upimeFileType = featureConfigVC.pptType()
        case "PDF":
            upimeFileType = .PDF
        case "Word":
            upimeFileType = .WORD
        case "Excel":
            upimeFileType = .EXCEL
        case "Image":
            upimeFileType = .IMAGE
        default:
            upimeFileType = .CANNOTHANDLE
        }
        
        if let vc = self.presentedViewController {
            vc.dismiss(animated: true, completion: nil)
        }
        
        let upimeFile = UpimeFile(url: fileURL, type: upimeFileType)
        upimeFile.title = file["title"]
        recorderVC?.insert(upimeFile)
    }
}

extension RecordConfigViewController {
    func uploadRecorder(_ info:UpimeRecordInfo) {
        let uploadInfo = UpimeUploadInfo()
        uploadInfo.recordId = info.recordId == "" ? UUID().uuidString : info.recordId
        uploadInfo.localPath = info.path
        
        uploadInfo.localPath = updateLocalPath(path: info.path)
        
        uploadInfo.autoDelete = false
        let env = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOENV) ?? "WWW"
        uploadInfo.host = "https://\(env.lowercased()).plaso.cn"
        
        var infoDic = [String: Any]()
        infoDic["appId"] = UserDefaults.standard.string(forKey: UserDefaultsKey.PLASOAPPID) ?? ""
        infoDic["validBegin"] = Int(Date().timeIntervalSince1970)
        infoDic["validTime"] = 1200
        infoDic["recordId"] = uploadInfo.recordId
        let sign = Tool.sign(params: infoDic)
        
        uploadInfo.signedQuery = sign
        PlasoStyleUpimeClient.uploadRecord(uploadInfo, delegate: self)
    }
    
    func updateLocalPath(path:String) -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        
        print(path)
        print(documentPath)
        if let range = path.range(of: "plaso_record/") {
            
            let str = path[range.lowerBound...]
            
            return documentPath + "/" + str
        }
        return path
    }
}

extension RecordConfigViewController: UpimeRecordDelegate {
    
    // 显示资料中心
    func upimeShowCloudDisk(_ upimeEditorVC: UIViewController & UpimeEditorProtocol) {
        let cloudDisk = PlasoCloudDiskTableViewController()
        cloudDisk.delegate = self
        upimeEditorVC.present(UINavigationController(rootViewController: cloudDisk), animated: true, completion: nil)
    }
    
    // 获取签名字符串
    func upimeEditorVC(_ upimeEditorVC: UIViewController & UpimeEditorProtocol, getSignQueryByParams params: [AnyHashable : Any], completion: @escaping (String?) -> Void) {
        var infoDic = params
        infoDic["appId"] = UserDefaults.standard.string(forKey: "PlasoAppID") ?? ""
        infoDic["validBegin"] = Int(Date().timeIntervalSince1970)
        infoDic["validTime"] = 120
        
        guard let info = infoDic as? [String: Any] else {
            completion(nil)
            return
        }
        
        let sign = Tool.sign(params: info)
        completion(sign)
    }
    
    func _updateOrInserRecord(_ info:UpimeRecordInfo) {
        var exsit = false
        var oldIdx = -1
        for (idx,a) in recorderArray.enumerated() {
            if a.recordId == info.recordId {
                exsit = true
                oldIdx = idx
                break
            }
        }
        if !exsit {
            recorderArray.insert(info, at: 0)
        }else {
            recorderArray[oldIdx] = info
        }
    }
    
    // 保存草稿
    func upimeRecordVC(_ upimeRecordVC: UIViewController & UpimeRecordProtocol, didSavedDraftWith info: UpimeRecordInfo) {
        _updateOrInserRecord(info)
    }
    
    // 结束录制
    func upimeRecordVC(_ upimeRecordVC: UIViewController & UpimeRecordProtocol, didFinishWith info: UpimeRecordInfo) {
        _updateOrInserRecord(info)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let alertVC = UIAlertController(title: "上传", message: "是否上传至OSS", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.uploadRecorder(info)
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // 从录制页面退出
    func upimeVC(onClosed upimeVC: UIViewController & UpimeProtocol, meetingID: String, code: Int) {
        upimeVC.dismiss(animated: true, completion: nil)
    }
    
    // 微课环境ready
    func upimeRecordVC(_ upimeRecordVC: UIViewController & UpimeRecordProtocol, miniLessonReadyWithEvent event: [AnyHashable : Any]) {
        print("onMiniLessonReady \(event)")
    }

}

extension RecordConfigViewController: UpimeUploadDelegate {
    // 上传进度回调
    func upimeUpload(_ upimeUpload: NSObject, recordId: String, uploadProgess progess: Int32) {
        print("progress is \(progess)")
    }
    
    // 上传结束代理
    func upimeUpload(_ upimeUpload: NSObject, uploadDidFinish resultCode: Int32, recordId: String, recordInfo info: UpimeRecordInfo?) {
        print("Upload result is \(resultCode), recordId is \(recordId)");
        
        if(resultCode == 0) {
            DispatchQueue.main.async {
                let alertVC = UIAlertController(title: "", message: "上传成功", preferredStyle: .alert)
                self.present(alertVC, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        alertVC.dismiss(animated: true)
                    })
                }
            }
            print("Upload Success!")
        }else {
            DispatchQueue.main.async {
                let alertVC = UIAlertController(title: "", message: "上传失败", preferredStyle: .alert)
                self.present(alertVC, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        alertVC.dismiss(animated: true)
                    })
                }
            }
            print("Upload Failed!")
        }
    }
}
