//
//  WarningPopupViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 10/19/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit

class WarningPopupViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    
    var warningMessage: String = ""
    
    @IBOutlet weak var viewFrame: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFrame.layer.cornerRadius = 20
        closeBtn.layer.cornerRadius = 10
        message.text = warningMessage
        // Do any additional setup after loading the view.
    }
   
    

    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
