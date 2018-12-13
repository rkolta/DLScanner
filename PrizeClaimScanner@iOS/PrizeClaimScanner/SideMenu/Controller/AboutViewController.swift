//
//  AboutViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 8/14/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var viewFrame: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFrame.layer.cornerRadius = 20
        doneButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
