//
//  MainViewController.swift
//  UpimetUIKitApp
//
//  Created by jing jiang on 2023/1/20.
//

import UIKit

class MainViewController: UIViewController {

    lazy var liveConfigVC: LiveConfigViewController =  {
        let controller  = LiveConfigViewController()
        return controller
    }()

    lazy var recorderConfigVC: RecordConfigViewController =  {
        let controller  = RecordConfigViewController()
        return controller
    }()

//    lazy var performanceVC: PerformanceController =  {
//        let controller  = PerformanceController()
//        return controller
//    }()
//
//    lazy var playerVC: PlayerEnterViewController = {
//        let controller = PlayerEnterViewController()
//        return controller
//    }()

    let spliteController = UISplitViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        let navLeft = LeftViewController()
        navLeft.delegate = self

        let mainNavVC = UINavigationController(rootViewController: navLeft)
        let detailVC = UINavigationController(rootViewController: liveConfigVC)
        if #available(iOS 13.0, *) {
            detailVC.view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        detailVC.navigationBar.isTranslucent = false
        //detailVC.navigationBar.backgroundColor = .white
        detailVC.navigationBar.isHidden = false
        
        mainNavVC.navigationBar.backgroundColor = detailVC.navigationBar.backgroundColor
        
        spliteController.viewControllers = [mainNavVC, detailVC]
        spliteController.preferredDisplayMode = .allVisible

        addFullScreen(childViewController: spliteController)

        showDisplayModeButtonItem(detailVC.topViewController!)
    }

    func showDisplayModeButtonItem(_ detailVC: UIViewController) {
        detailVC.navigationItem.leftItemsSupplementBackButton = true
        detailVC.navigationItem.leftBarButtonItem = spliteController.displayModeButtonItem
    }

    /// 添加子vc
    /// - Parameter child: child
    func addFullScreen(childViewController child: UIViewController) {
      guard child.parent == nil else {
        return
      }

      addChild(child)
      view.addSubview(child.view)

      child.view.translatesAutoresizingMaskIntoConstraints = false
      let constraints = [
        view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
        view.topAnchor.constraint(equalTo: child.view.topAnchor),
        view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
      ]
      constraints.forEach { $0.isActive = true }
      view.addConstraints(constraints)

      child.didMove(toParent: self)
    }
}

extension MainViewController: NavLeftDelegate {

    func navItemSelected(_ item: String) {

        guard let detailVC = spliteController.viewControllers.last as? UINavigationController else {
            return

        }
        switch item {
        case "实时课堂":
            detailVC.setViewControllers([liveConfigVC], animated: false)
        case "微课":
            detailVC.setViewControllers([recorderConfigVC], animated: false)
//        case "播放器":
//            detailVC.setViewControllers([playerVC], animated: false)
//
//        case "Performance":
//            detailVC.setViewControllers([performanceVC], animated: false)
        default:
            break
        }

        guard let vc = detailVC.topViewController else {
            return
        }

        showDisplayModeButtonItem(vc)

    }

}

extension MainViewController: UISplitViewControllerDelegate {

}
