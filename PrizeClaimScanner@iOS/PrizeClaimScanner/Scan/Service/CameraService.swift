//
//  CameraService.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/24/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraService: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: - Variables
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var scanFrameView: UIView?
    var scanFrameTemplate: UIView?
    var scanDelegate: ScannerDelegate?
    var scanType = [AVMetadataObject.ObjectType.pdf417] //default value
    var scanSource: ScanSource = .driverLicense //default value
    var mainView: UIView?
    var navigationController: UINavigationController?
    let captureMetadataOutput = AVCaptureMetadataOutput()
    
    func setViews(mainView: UIView?, navigationController: UINavigationController?) {
        self.mainView = mainView
        self.navigationController = navigationController
    }
    
    //MARK: - Functions
    
    func startCamera() {
        //Find camera if capture device is not instantiated
        if(captureDevice == nil) {
            findCameraDevice()
        }
        
        if(captureDevice != nil) {
            displayCameraSession()
        }
    }
    
    func findCameraDevice() {
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        if let device = deviceDiscoverySession.devices.first {
            captureDevice = device
        } else {
            print("Failed to get the camera device")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(input)
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        } catch {
            print(error)
            return
        }
    }
    
    func displayCameraSession() {
        
        //stop incase of session is running
        stopCaptureSession()

        captureMetadataOutput.metadataObjectTypes = scanType
        guard let mainView = mainView else { print("Missing View"); return }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = mainView.layer.bounds
        
        mainView.layer.addSublayer(videoPreviewLayer!)
        
        startCaptureSession()
        
        scanFrameTemplate = UIView()
        scanFrameView = UIView()
        
        //Add red line in the middle
        addScanLine(scanFrameTemplate)
        
        //Add blue square for detected code
        addDetectedCodeBorder(scanFrameView)
        
    }
    
    func addScanLine(_ scanFrameTemplate: UIView?) {
        
        guard let mainView = mainView else { print("Missing View"); return }
        
        if let scanFrameTemplate = scanFrameTemplate {
            scanFrameTemplate.layer.borderColor = UIColor.red.cgColor
            scanFrameTemplate.layer.borderWidth = 5
            scanFrameTemplate.frame = CGRect(x: mainView.bounds.minX, y: mainView.bounds.midY, width: mainView.bounds.maxX, height: 5)
            mainView.addSubview(scanFrameTemplate)
            mainView.bringSubviewToFront(scanFrameTemplate)
        }
    }
    
    func addDetectedCodeBorder(_ scanFrameView: UIView?) {
        
        guard let mainView = mainView else { print("Missing View"); return }
        
        if let scanFrameView = scanFrameView {
            scanFrameView.layer.borderColor = UIColor.green.cgColor
            scanFrameView.layer.borderWidth = 4
            mainView.addSubview(scanFrameView)
            mainView.bringSubviewToFront(scanFrameView)
        }
    }
    
    func hasTorch() -> Bool {
        return captureDevice?.hasTorch ?? false
    }
    
    func toggleTorch(flashButton: UIBarButtonItem) {
        if(captureDevice?.hasTorch == true) {
            do {
                try captureDevice?.lockForConfiguration()
                if(captureDevice?.torchMode == AVCaptureDevice.TorchMode.on) {
                    captureDevice?.torchMode = AVCaptureDevice.TorchMode.off
                    flashButton.image = UIImage(named: "torch-off")
                } else {
                    try captureDevice?.setTorchModeOn(level: 0.1)
                    flashButton.image = UIImage(named: "torch-on")
                }
                captureDevice?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    func callDelegate(_ data: String?) {
        
        switch scanSource {
        case .driverLicense:
            scanDelegate?.scanDLComplete(data: data)
        case .ticket:
            scanDelegate?.scanTicketComplete(data: data)
        }
    }
    
    func forcePortraitOrientation(size: CGSize) {
        
        videoPreviewLayer?.frame.size = size
        if let videoPreviewLayer = videoPreviewLayer {
            //redraw middle red line
            scanFrameTemplate?.frame = CGRect(x: videoPreviewLayer.bounds.minX, y: videoPreviewLayer.bounds.midY, width: videoPreviewLayer.bounds.maxX, height: 5)
        }
    }
    
    func stopCaptureSession() {
        if(captureSession.isRunning) {
            captureSession.stopRunning()
        }
    }
    
    func startCaptureSession() {
        if(!captureSession.isRunning) {
            let queue = DispatchQueue(label: "SerialQueue")
            queue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    //MARK: - Events
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        guard let navigationController = navigationController else { print("Missing Navigation Controller"); return }
        
        if metadataObjects.count == 0 {
            scanFrameView?.frame = CGRect.zero
            return
        }
        
        //Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if scanType.contains(metadataObj.type) {
            let barCodeObj = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            scanFrameView?.frame = barCodeObj!.bounds
            
            if(metadataObj.stringValue != nil) {
                //let alert = UIAlertController(title: "License Details", message: metadataObj.stringValue, preferredStyle: .alert)
                // self.present(alert, animated: true)
                callDelegate(metadataObj.stringValue)
                stopCaptureSession()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                AudioServicesPlaySystemSound(1114)
                navigationController.popViewController(animated: true)
            }
        }
    }
    
    
}
