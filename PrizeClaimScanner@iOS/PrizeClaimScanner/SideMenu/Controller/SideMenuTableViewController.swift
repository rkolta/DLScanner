//
//  SideMenuTableViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 8/9/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        loadBackground()
    }
    
    @IBAction func HelpPressed(_ sender: Any) {
        NotificationService.post(Notifications.helpMenu.rawValue)
    }
    
    
    @IBAction func VideoPressed(_ sender: Any) {
        NotificationService.post(Notifications.videoMenu.rawValue)
    }
    
    
    @IBAction func AboutPressed(_ sender: Any) {
        NotificationService.post(Notifications.aboutMenu.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            NotificationService.post(Notifications.helpMenu.rawValue)
        case 1:
            NotificationService.post(Notifications.videoMenu.rawValue)
        case 2:
            NotificationService.post(Notifications.aboutMenu.rawValue)
        default:
            break;
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    
    //MARK: - Helper Functions
    
    func loadBackground() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tableView.bounds
        
        self.tableView.backgroundView = blurView
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
}
