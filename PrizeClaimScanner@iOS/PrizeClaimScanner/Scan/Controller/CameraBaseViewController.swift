//
//  ScanDLViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/16/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class CameraBaseViewController: UIViewController {
    
    //MARK: - Variables
   
    var cameraService: CameraService?
    
    @IBOutlet weak var toolbar: UINavigationBar!
    
    @IBOutlet weak var flashButton: UIBarButtonItem!
    
    //MARK: - Events
    
    @IBAction func torchTogglePress(_ sender: Any) {
        cameraService?.toggleTorch(flashButton: flashButton)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraService?.setViews(mainView: view, navigationController: navigationController)
        cameraService?.startCamera()
        if(cameraService?.hasTorch() ?? false) {
            view.bringSubviewToFront(toolbar)
        } else {
            toolbar.isHidden = true
        }
    }
    
    //Called when iPhone or iPad is in landscape mode and transitioned to portrait or vice versa
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cameraService?.forcePortraitOrientation(size: size)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraService?.stopCaptureSession()
    }
    
    
}
