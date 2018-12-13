//
//  ViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/13/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    enum ViewButtons: Int {
        case driverLicense = 1
        case ticket
    }
    
    @IBOutlet weak var scanDL: UIButton!
    @IBOutlet weak var scanTicket: UIButton!
    @IBOutlet weak var scanPdf: UIButton!
    @IBOutlet weak var claimField: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    let scanParser = ScanParser()
    let cameraService = CameraService()
    
    let blue: UIColor = UIColor.init(red: 0, green: 139/255, blue: 194/255, alpha: 1)
    let green: UIColor = UIColor.init(red: 32/255, green: 169/255, blue: 32/255, alpha: 1)
    
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initButtons()
        //Stop any camera session working, e.g. going back from camera view without scanning a barcode
        cameraService.stopCaptureSession()
        subscribeNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanTicketPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "cameraSegue", sender: sender)
    }
    
    @IBAction func scanDLPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "cameraSegue", sender: sender)
        
    }
    
    @IBAction func fillRequiredFieldsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "FormFieldsSegue", sender: sender)
    }
    
    @IBAction func PdfButtonPressed(_ sender: Any) {
        if(scanParser.isUnderAge()) {
            let alertController = UIAlertController(title: "Under Age Warning", message: "Claimant is under 18 years old \n Cannot proceed", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        } else {
            self.performSegue(withIdentifier: "pdfSegue", sender: sender)
        }
    }
    
    @IBAction func sideMenuPressed(_ sender: Any) {
        NotificationService.post(Notifications.toggleSideMenu.rawValue)
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        scanParser.clearData()
        toggleClearBtn()
    }
    //Mark: - Helper Methods
    func subscribeNotifications()
    {
        //Add Notification for HELP PDF
        NotificationService.add(selector: #selector(showHelpPDF), listener: self, name: Notifications.helpMenu.rawValue)
        NotificationService.add(selector: #selector(showAboutPopup), listener: self, name: Notifications.aboutMenu.rawValue)
        NotificationService.add(selector: #selector(showTrainingVideo), listener: self, name: Notifications.videoMenu.rawValue)
        NotificationService.add(selector: #selector(scanComplete), listener: self, name: Notifications.scanComplete.rawValue)
        NotificationService.add(selector: #selector(showPdf), listener: self, name: Notifications.viewPDF.rawValue)
        NotificationService.add(selector: #selector(showEditForm), listener: self, name: Notifications.editForm.rawValue)
    }
    
    @objc func scanComplete() {
        if(scanParser.lastScanSource == .driverLicense) {
            checkUnderAge()
            scanParser.lastScanSource = nil
        }
        toggleClearBtn()
    }
    
    @objc func showPdf() {
        self.performSegue(withIdentifier: "pdfSegue", sender: nil)
    }
    
    @objc func showEditForm() {
        self.performSegue(withIdentifier: "FormFieldsSegue", sender: nil)
    }
    
    func initButtons()
    {
        scanDL.layer.cornerRadius = 10
        scanTicket.layer.cornerRadius = 10
        //scanPdf.layer.cornerRadius = 10
        claimField.layer.cornerRadius = 10
        clearBtn.layer.cornerRadius = 10
        toggleClearBtn()
    }
    
    func toggleClearBtn() {
        if(scanParser.isScanDl || scanParser.isScanTicket || scanParser.isFormComplete)
        {
            clearBtn.isEnabled = true
            clearBtn.backgroundColor = UIColor.init(red: 255/255, green: 173/255, blue: 33/255, alpha: 1)
            clearBtn.tintColor = UIColor.black
            activateButtons()
        } else {
            clearBtn.isEnabled = false
            clearBtn.backgroundColor = UIColor.init(red: 255/255, green: 173/255, blue: 33/255, alpha: 0.4 )
            clearBtn.tintColor = UIColor.gray
            resetButtons()
        }
    }
    
    func resetButtons() {
        scanDL.backgroundColor = blue
        scanTicket.backgroundColor = blue
        claimField.backgroundColor = blue
        scanDL.setImage(nil, for: .normal)
        scanTicket.setImage(nil, for: .normal)
        claimField.setImage(nil, for: .normal)
    }
    
    func activateButtons() {
        if(scanParser.isScanDl) {
            scanDL.backgroundColor = green
            scanDL.setImage(UIImage.init(named: "tick"), for: .normal)
        }
        if(scanParser.isScanTicket) {
            scanTicket.backgroundColor = green
            scanTicket.setImage(UIImage.init(named: "tick"), for: .normal)
        }
        if(scanParser.isFormComplete) {
            claimField.backgroundColor = green
            claimField.setImage(UIImage.init(named: "tick"), for: .normal)
        }
    }
    
    func checkUnderAge() {
        if(scanParser.isUnderAge()) {
            let alertController = UIAlertController(title: "Under Age Warning", message: "Claimant is under 18 years old \n Cannot proceed, data is cleared.", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: {(UIAlertAction) in self.navigationController?.popViewController(animated: true)
                //Clear data of claimant if underage
                self.scanParser.clearData()
                self.toggleClearBtn()
            }))
            self.present(alertController, animated: true)
        }
    }
    
    // Mark: - Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationService.post(Notifications.closeSideMenu.rawValue)
    }
    
    @objc func showHelpPDF() {
        self.performSegue(withIdentifier: "helpSegue", sender: nil)
    }
    
    @objc func showAboutPopup() {
        self.performSegue(withIdentifier: "aboutSegue", sender: nil)
    }
    
    @objc func showTrainingVideo() {
        NotificationService.post(Notifications.closeSideMenu.rawValue)
        if let path = Bundle.main.path(forResource: "training", ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = VideoViewController()
            videoPlayer.player = video
            present(videoPlayer, animated: true) {
                video.play()
            }
            
        }
    }
    
    //Mark: - Segue Code
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        NotificationService.post(Notifications.closeSideMenu.rawValue)
        
        if segue.identifier == "cameraSegue" {
        
            let controller = segue.destination as! CameraBaseViewController
            let button = sender as! UIButton
            
            //Figure which button was pressed to prepare the camera controller for the correct barcode and call back on the delegate
            if(ViewButtons(rawValue: button.tag) == ViewButtons.driverLicense) {
                cameraService.scanSource = ScanSource.driverLicense
                cameraService.scanType = [AVMetadataObject.ObjectType.pdf417]
            } else if(ViewButtons(rawValue: button.tag) == ViewButtons.ticket) {
                cameraService.scanSource = ScanSource.ticket
                cameraService.scanType = [AVMetadataObject.ObjectType.interleaved2of5]
            }
            
            //Assign class to handle scan completion and parsing
            cameraService.scanDelegate = scanParser
            controller.cameraService = cameraService
            
        } else if segue.identifier == "pdfSegue" {
            let controller = segue.destination as! PDFViewController
            controller.scanParser = scanParser
        } else if segue.identifier == "FormFieldsSegue" {
            let controller = segue.destination as! FormFieldViewController
            controller.scanParser = scanParser
        }
    }
    
}

