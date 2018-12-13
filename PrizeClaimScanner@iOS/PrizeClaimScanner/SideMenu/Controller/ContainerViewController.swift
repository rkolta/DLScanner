//
//  ContainerViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 8/9/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    var sideMenuOpen = false
    var containerWidth: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeNotifications()
    }

    @objc func toggleSideMenu() {
        if sideMenuOpen {
            sideMenuConstraint.constant = containerWidth * -1
            sideMenuOpen = false
        } else {
            sideMenuConstraint.constant = 0
            sideMenuOpen = true
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func closeSideMenu() {
        if sideMenuOpen {
            sideMenuConstraint.constant = containerWidth * -1
            sideMenuOpen = false
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Helper Functions
    
    func subscribeNotifications() {
        NotificationService.add(selector: #selector(toggleSideMenu), listener: self, name: Notifications.toggleSideMenu.rawValue)
        NotificationService.add(selector: #selector(closeSideMenu), listener: self, name: Notifications.closeSideMenu.rawValue)
    }

}
