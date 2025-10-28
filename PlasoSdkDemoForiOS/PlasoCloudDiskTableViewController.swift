//
//  PlasoCloudDiskTableViewController.swift
//  PlasoStyleUpimeDemo
//
//  Created by liyang on 2021/1/14.
//  Copyright © 2021 plaso. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - Decodable Models
struct APIResponse: Decodable {
    let data: FileListData
}

struct FileListData: Decodable {
    let files: [FileItem]
}

struct FileItem: Decodable {
    let id: String
    let originalName: String
    let url: String
    let convertPages: Int?
}

@objc protocol PlasoCloudDiskTableViewControllerDelegate {
    @objc optional
    func cloudDiskTableViewControllerDidSelectFile(file: [String: AnyObject])
}

class PlasoCloudDiskTableViewController: UITableViewController {
    
    @objc var delegate: PlasoCloudDiskTableViewControllerDelegate?
    
    let segmentedControl = UISegmentedControl(items: ["未解析文件", "预解析文件"])
    
    var unparsedFileList = [
        [
            "title": "直角三角形",
            "url": "https://hls.videocc.net/ca19080b2e/a/ca19080b2e18fe999693b78a10d304fa.m3u8?device=desktop&pid=1665558120704X1832259",
            "fileType": "Video",
        ],
        [
            "title": "ene - original",
            "url": "http://192.168.2.243:8000/M3U8Example/ene%20-%20original.m3u8",
            "fileType": "Video",
        ],
        [
            "title": "未显示?",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/6336972900000024cd000002.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "problem_pdf",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/problem_pdf.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "字体颜色标注不显示",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/9AU4%E7%82%B9%E8%AF%84.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "旋转PDF",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/001_This%20Is%20My%20Body.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "PDF页数192-打开崩溃",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/%E5%B0%8F%E5%8D%87%E5%88%9D%E8%AF%AD%E6%96%87%E7%BB%BC%E5%90%88%E7%B4%A0%E8%B4%A8%E7%8F%AD%EF%BC%886%E7%A7%8B%EF%BC%89-%E5%86%85%E5%AE%B9.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "手写错位",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/%E6%89%8B%E5%86%99%E9%94%99%E4%BD%8D.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "第7页显示错误",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/2022%E5%B9%B4%E6%B1%9F%E8%8B%8F%E7%9C%81%E5%8D%97%E4%BA%AC%E5%B8%82%E4%B8%AD%E8%80%83%E7%89%A9%E7%90%86%E4%B8%89%E6%A8%A1%E8%AF%95%E5%8D%B7%EF%BC%88%E4%B8%8A%E8%AF%BE%E7%89%88%EF%BC%89.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "陈瑞-白狐.mp3",
            "url": "https://file.plaso.cn/upime/demo/file_center/%E9%99%88%E7%91%9E%20-%20%E7%99%BD%E7%8B%90.mp3",
            "fileType": "Audio",
        ],
        [
            "title": "121.89m.mp4",
            "url": "https://file.plaso.cn/upime/demo/file_center/121.89m.mp4",
            "fileType": "Video",
        ],
        [
            "title": "plaso_1610183429017_1.doc",
            "url": "https://file.plaso.cn/upime/demo/file_center/plaso_1610183429017_1.docx",
            "fileType": "Word",
        ],
        [
            "title": "plaso_1610184007827_2.xls",
            "url": "https://file.plaso.cn/upime/demo/file_center/plaso_1610184007827_2.xlsx",
            "fileType": "Excel",
        ],
        [
            "title": "Word 最后一页无法解析crash",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/%E4%B8%83%E5%B9%B4%E7%BA%A7%E5%90%8C%E6%AD%A5%E7%AC%AC14%E8%AE%B2%EF%BC%9A%E6%95%B4%E5%BC%8F%E7%9A%84%E9%99%A4%E6%B3%95.doc",
            "fileType": "Word",
        ],
        [
            "title": "Word 手写无法显示",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/%E6%95%B0%E5%88%97%E5%92%8C%E8%A7%A3%E4%B8%89%E8%A7%92%E5%BD%A2%EF%BC%88%E4%B9%A6%E5%86%99%E8%BF%87%E7%A8%8B%EF%BC%89.docx",
            "fileType": "Word",
        ],
        [
            "title": "带视频出错PPT（旧模式)",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/49594_100_1664972853208.pptx",
            "fileType": "PPT",
        ],
        [
            "title": " PPT错位",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/%E8%AF%BE%E4%BB%B6-%E9%94%99%E4%BD%8D.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "新人培训.pptx",
            "url": "https://file.plaso.cn/upime/demo/file_center/1.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "pptx swpier",
            "url": "https://file.plaso.cn/upime/demo/file_center/swpier.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "pptx pri",
            "url": "https://file.plaso.cn/upime/demo/file_center/testpptnoPri.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "gif",
            "url": "https://c-ssl.duitang.com/uploads/item/201812/01/20181201234638_fFTBy.thumb.1000_0.gif",
            "fileType": "Image",
        ],
        [
            "title": "jpg",
            "url": "https://file02.16sucai.com/d/file/2014/0427/071875652097059bbbffe106f9ce3a93.jpg",
            "fileType": "Image",
        ],
        [
            "title": "png",
            "url": "https://pic.ntimg.cn/20110325/2457331_234414423000_2.png",
            "fileType": "Image",
        ],
        [
            "title": "带音频的PPT",
            "url": "https://file-plaso.oss-cn-hangzhou.aliyuncs.com/dev-plaso/c2c/myfile/8613776561823/1651900016702_1651900014947.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "波普先生的企鹅A20210810定-完全无切换.pptx",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/1.%E6%B3%A2%E6%99%AE%E5%85%88%E7%94%9F%E7%9A%84%E4%BC%81%E9%B9%85A20210810%E5%AE%9A-%E5%AE%8C%E5%85%A8%E6%97%A0%E5%88%87%E6%8D%A2.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "移动端不触发-平面图形计数进阶最终版.pptx",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/%E7%A7%BB%E5%8A%A8%E7%AB%AF%E4%B8%8D%E8%A7%A6%E5%8F%91-%E5%B9%B3%E9%9D%A2%E5%9B%BE%E5%BD%A2%E8%AE%A1%E6%95%B0%E8%BF%9B%E9%98%B6%E6%9C%80%E7%BB%88%E7%89%88.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "oss 预解析ppt-ispring",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/1325/1600103_0_1674012465650.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 波普先生的企鹅A20210810定.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673677904726.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 带gif的.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673678522768.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 带音频的.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673678526165.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 解析失败_含有批注.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673678528681.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 页面白屏_17-30.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673678537382.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring ppt_test.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673678575674.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1700425_0_1657528034184.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673679050637.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1700425_0_1657528030807.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673679052313.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1641896967164_1641896962742.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673679059538.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1643004239916_1643004238730.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673679062839.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1649642691661_1649642691650.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673679065762.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1643004928290_1643004923061.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673679070761.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1643004206235_1643004196546.pptx",
            "url" :"https://file.plaso.cn/dev-plaso/teaching/801448/1701830_0_1673679070941.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "ppt-ispring 1025484_0_1675660076072.pptx",
            "url" :"https://file.plaso.cn/test-plaso/teaching/1139/1025484_0_1675660076072.pptx",
            "fileType": "PPT",
        ],
    ] as [[String: AnyObject]]
    var preparsedFileList = [[String: AnyObject]]()
    
    lazy var addButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addBarButtonClicked))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CloudDiskCell")
        
        fetchParsedData()
        updateAddButtonVisibility()
    }
    
    func fetchParsedData() {
        let url = "http://120.55.3.51:3000/api/files/list?status=completed&limit=10000&offset=0"
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(url, headers: headers).responseDecodable(of: APIResponse.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let apiResponse):
                let fileItems = apiResponse.data.files
                self.preparsedFileList = fileItems.map { fileItem in
                    return [
                        "id": fileItem.id as AnyObject,
                        "title": fileItem.originalName as AnyObject,
                        "url": fileItem.url as AnyObject,
                        "fileType": self.fileType(from: fileItem.url, parsed: true) as AnyObject,
                        "totalPages": fileItem.convertPages as AnyObject
                    ]
                }
                
                DispatchQueue.main.async {
                    if self.segmentedControl.selectedSegmentIndex == 1 {
                        self.tableView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func fileType(from url: String, parsed: Bool = false) -> String {
        if url.hasSuffix(".mp4") || url.hasSuffix(".m3u8") {
            return "Video"
        } else if url.hasSuffix(".mp3") {
            return "Audio"
        } else if url.hasSuffix(".pdf") {
            return "PDF"
        } else if url.hasSuffix(".ppt") || url.hasSuffix(".pptx") {
            return parsed ? "IPPT" : "PPT"
        } else if url.hasSuffix(".doc") || url.hasSuffix(".docx") {
            return "Word"
        } else if url.hasSuffix(".xls") || url.hasSuffix(".xlsx") {
            return "Excel"
        } else if url.hasSuffix(".gif") || url.hasSuffix(".jpg") || url.hasSuffix(".png") {
            return "Image"
        }
        return "None"
    }
    
    @objc func segmentedControlValueChanged() {
        tableView.reloadData()
        updateAddButtonVisibility()
    }
    
    func updateAddButtonVisibility() {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.navigationItem.rightBarButtonItem = addButtonItem
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func addBarButtonClicked() {
        let addVC = PlasoCloudDiskAddViewController()
        addVC.delegate = delegate
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return unparsedFileList.count
        } else {
            return preparsedFileList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CloudDiskCell", for: indexPath)
        let file: [String: AnyObject]
        if segmentedControl.selectedSegmentIndex == 0 {
            file = unparsedFileList[indexPath.row]
        } else {
            file = preparsedFileList[indexPath.row]
        }
        cell.textLabel?.text = file["title"] as? String ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file: [String: AnyObject]
        if segmentedControl.selectedSegmentIndex == 0 {
            file = unparsedFileList[indexPath.row]
        } else {
            file = preparsedFileList[indexPath.row]
        }
        delegate?.cloudDiskTableViewControllerDidSelectFile?(file: file)
    }
}

class PlasoCloudDiskAddViewController: UIViewController {
    
    @objc var delegate: PlasoCloudDiskTableViewControllerDelegate?
    
    let titleList = [
        "None",
        "PPT",
        "Image",
        "PDF",
        "Word",
        "Excel",
        "Audio",
        "Video",
    ]
    
    let titleTextField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "文件标题"
        return textField
    }()
    
    let urlTextField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "文件URL"
        return textField
    }()
    
    var fileTypeSegmentedControl : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加文件"
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelBarButtonClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(addBarButtonClicked))
        
        configSubView()
    }
    
    func configSubView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        }
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(urlTextField)
        
        fileTypeSegmentedControl = UISegmentedControl(items: titleList)
        fileTypeSegmentedControl.selectedSegmentIndex = 0
        stackView.addArrangedSubview(fileTypeSegmentedControl)
    }
    
    @objc func cancelBarButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addBarButtonClicked() {
        let fileInfo = [
            "title": titleTextField.text ?? "",
            "url": urlTextField.text ?? "",
            "fileType": fileTypeSegmentedControl.titleForSegment(at: fileTypeSegmentedControl.selectedSegmentIndex) ?? "None",
        ] as!  [String: AnyObject]
        dismiss(animated: true, completion: nil)
        delegate?.cloudDiskTableViewControllerDidSelectFile?(file: fileInfo)
    }
}
