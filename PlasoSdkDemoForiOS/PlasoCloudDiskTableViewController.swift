//
//  PlasoCloudDiskTableViewController.swift
//  PlasoStyleUpimeDemo
//
//  Created by liyang on 2021/1/14.
//  Copyright © 2021 plaso. All rights reserved.
//

import UIKit

@objc protocol PlasoCloudDiskTableViewControllerDelegate {
    @objc optional
    func cloudDiskTableViewControllerDidSelectFile(file: [String: String])
}

class PlasoCloudDiskTableViewController: UITableViewController {
    
    @objc var delegate: PlasoCloudDiskTableViewControllerDelegate?
    
    
    var fileList:[[String: String]] = [
        [
            "title": "Music.mp3",
            "url": "https://file.plaso.cn/test-plaso/teaching/1139/1024044_0_1630738880808.mp3",
            "fileType": "Audio",
        ],
            [
                "title": "问题视频课件m3u8",
                "url": "http://192.168.1.100:8081/m3u8/62f2006d10991d185c473da06db673a2_1.m3u8",
                "fileType": "Video",
            ],
        [
            "title": "problem_pdf",
            "url": "https://hz-public-files.oss-cn-hangzhou.aliyuncs.com/dev-plaso/dev-prod/problem_pdf.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "Music Plaso.mp3",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/xihai.mp3",
            "fileType": "Audio",
        ],
        [
            "title": "15_1628302197111.pdf",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/15_1628302197111.pdf",
            "fileType": "PDF",
        ],
        [
            "title": "bb.mp4",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/bb.mp4",
            "fileType": "Video",
        ],
        [
            "title": "chengzhifeiHangyejiedu222.mp4",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/chengzhifeiHangyejiedu222.mp4",
            "fileType": "Video",
        ],
        
        [
            "title": "plaso_1610183429017_1.doc",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/plaso_1610183429017_1.docx",
            "fileType": "Word",
        ],
        [
            "title": "Test.xls",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/plaso_1610184007827_2.xlsx",
            "fileType": "Excel",
        ],
        [
            "title": "pptx1",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/sdk%E6%96%B0%E4%BA%BA%E5%9F%B9%E8%AE%AD.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "pptx swpier",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/swpier.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "pptx swpier2",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/swpier2.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "pptx swpier3",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/swpier3.pptx",
            "fileType": "PPT",
        ],
        [
            "title": "pptx pri",
            "url": "https://file.plaso.cn/dev-plaso/liveclass/wyytestfile/testpptnoPri.pptx",
            "fileType": "PPT",
        ],
        
        
        
        
        [
            "title": "Video.mp4",
            "url": "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
            "fileType": "Video",
        ],
        [
            "title": "Test.ppt",
            "url": "https://file-examples-com.github.io/uploads/2017/08/file_example_PPT_250kB.ppt",
            "fileType": "PPT",
        ],
        [
            "title": "Test.doc",
            "url": "https://file-examples-com.github.io/uploads/2017/02/file-sample_100kB.doc",
            "fileType": "Word",
        ],
        [
            "title": "Test.xls",
            "url": "https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_10.xls",
            "fileType": "Excel",
        ],
        [
            "title": "Test.pdf",
            "url": "https://file-examples-com.github.io/uploads/2017/10/file-sample_150kB.pdf",
            "fileType": "PDF",
        ],
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addBarButtonClicked))
        self.tableView .register(UITableViewCell.self, forCellReuseIdentifier: "CloudDiskCell")
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
        return fileList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CloudDiskCell", for: indexPath)
        cell.textLabel?.text = fileList[indexPath.row]["title"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.cloudDiskTableViewControllerDidSelectFile?(file: fileList[indexPath.row])
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
        ]
        dismiss(animated: true, completion: nil)
        delegate?.cloudDiskTableViewControllerDidSelectFile?(file: fileInfo)
    }
}
