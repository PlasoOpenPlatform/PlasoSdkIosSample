//
//  TopBarView.swift
//  PlasoSdkDemoForiOS
//
//  Created by 徐丹阳 on 2022/12/13.
//

import UIKit

class TopBarView: UIView {
    
    typealias ButtonClickedBlock = (_ title: String) -> ()
    
    private var buttonArray: [UIButton] = []
    private var selectionLine: UIView = UIView()
    private var selectionLineLayoutCenterX: NSLayoutConstraint?
    private var selectionLineLayoutWidth: NSLayoutConstraint?
    private var buttonHandle: ButtonClickedBlock?
    
    init(titles: [String]) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = isIphone() ? 10 : 20
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        for str in titles {
            let button = UIButton(type: .custom)
            button.setTitle(str, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.addTarget(self, action: #selector(headerButtonClicked(_:)), for: .touchUpInside)
            buttonArray.append(button)
            stackView.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.sizeToFit()
            let width = (button.titleLabel?.bounds.size.width ?? 80) + (isIphone() ? 20 : 40)
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            button.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        }
        
        buttonArray.first?.isSelected = true
        
        selectionLine.backgroundColor = .lightGray
        stackView.addSubview(selectionLine)
        selectionLine.translatesAutoresizingMaskIntoConstraints = false
        selectionLine.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        selectionLine.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true
        selectionLineLayoutWidth = selectionLine.widthAnchor.constraint(equalToConstant: buttonArray.first?.titleLabel?.bounds.size.width ?? 50)
        selectionLineLayoutWidth?.isActive = true
        selectionLineLayoutCenterX = selectionLine.centerXAnchor.constraint(equalTo: self.buttonArray.first?.centerXAnchor ?? stackView.centerXAnchor)
        selectionLineLayoutCenterX?.isActive = true
    }
    
    @available(*, unavailable, renamed: "init(titles:)")
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, renamed: "init(titles:)")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func headerButtonClicked(_ sender: UIButton) {
        for button in buttonArray {
            button.isSelected = false
            if sender == button {
                button.isSelected = true
            }
        }
        
        if selectionLineLayoutCenterX != nil {
            selectionLineLayoutCenterX?.isActive = false
            selectionLine.removeConstraint(selectionLineLayoutCenterX!)
            selectionLineLayoutCenterX = selectionLine.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
            selectionLineLayoutCenterX?.isActive = true
        }
        
        if selectionLineLayoutWidth != nil {
            selectionLineLayoutWidth?.isActive = false
            selectionLine.removeConstraint(selectionLineLayoutWidth!)
            selectionLineLayoutWidth = selectionLine.widthAnchor.constraint(equalTo: sender.titleLabel?.widthAnchor ?? sender.widthAnchor)
            selectionLineLayoutWidth?.isActive = true
        }
        
        if let text = sender.titleLabel?.text {
            self.buttonHandle?(text)
        }
    }
    
    func setupButtonHandle(_ handle: @escaping ButtonClickedBlock) {
        self.buttonHandle = handle
    }
    
}
