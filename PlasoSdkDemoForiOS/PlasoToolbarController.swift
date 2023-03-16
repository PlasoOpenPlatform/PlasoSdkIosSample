//
//  PlasoTabBarViewController.swift
//  PlasoStyleUpimeDemo
//
//  Created by liyang on 2021/1/13.
//  Copyright © 2021 plaso. All rights reserved.
//

import UIKit
import Material

class PlasoToolbarController: ToolbarController {
    
    fileprivate var menuButton: IconButton!
    
    override func prepare() {
        super.prepare()
        
        prepareMenuButton()
        prepareToolbar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateUI()
    }
    

    private func updateUI() {
        layoutSubviews()
        // 修改在进入课堂返回后布局出现上移的问题
        if isIphone(), UIDevice.current.orientation.isLandscape != Application.isLandscape {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{
                self.updateUI()
            })
        }
    }
    
}

extension PlasoToolbarController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.imageView?.tintColor = .darkGray
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
    }
    
    fileprivate func prepareToolbar() {
        toolbar.leftViews = [menuButton]
    }
}

extension PlasoToolbarController {
    @objc fileprivate func handleMenuButton() {
        navigationDrawerController?.toggleLeftView()
    }
}
