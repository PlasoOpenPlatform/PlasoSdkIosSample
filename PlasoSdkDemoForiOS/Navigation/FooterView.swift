//
//  FooterView.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/14.
//

import UIKit

class FooterView: UIView {
    typealias ButtonClickedBlock = () -> ()
    
    private var buttonHandle: ButtonClickedBlock?
    
    init(_ title: String) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let startButton = UIButton(type: .custom)
        startButton.setTitle(title, for: .normal)
        startButton.setTitleColor(.blue, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        startButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        startButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let lineView = UIView()
        lineView.backgroundColor = RGBCOLOR(r: 220, 220, 220, 1)
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    @available(*, unavailable, renamed: "init(titles:)")
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, renamed: "init(titles:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonHandle(_ handle: @escaping ButtonClickedBlock) {
        self.buttonHandle = handle
    }
    
    @objc func startButtonClicked() {
        self.buttonHandle?()
    }
    
}
