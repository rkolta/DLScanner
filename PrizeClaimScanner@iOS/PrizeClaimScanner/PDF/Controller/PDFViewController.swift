//
//  PDFViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/16/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController  {
    
    //MARK: - Network Services
    var printService: PrintService = PrintService()
    var networkService: NetworkService = NetworkService()
    
    //MARK: - Variables
    var pdfService: PDFService?
    var scanParser: ScanParser?
    
    //MARK: - Outlets
    @IBOutlet weak var pdfView: PDFView!

    //MARK: - Button Actions
    
    @IBAction func printPdfPressed(_ sender: Any) {
        //Print PDF documents
        printService.printPDF(pdfView.document?.dataRepresentation())
    }
    
    @IBAction func editPressed(_ sender: Any) {
        navigationController?.popViewController(animated: false)
        NotificationService.post(Notifications.editForm.rawValue)
    }
    
    //MARK: - Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printService.scanParser = scanParser
        pdfService = ClaimFormV2(pdfView: pdfView, pdfData: scanParser?.scanData)
        pdfService?.loadDocument()
        pdfService?.setupPDFView()
        //Loop through annotations
        pdfService?.loadAnnotation()
        //Check WiFi connection
        checkWiFiConnected()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        //go to top of the PDF page
        if let page = pdfView.document?.page(at: 0) {
            pdfView.go(to: CGRect(x: pdfView.bounds.minX, y: pdfView.bounds.maxY, width: 10, height: 10), on: page)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.pdfService?.scalePDFViewToFit()
        }, completion: nil)
    }
    
    //MARK: - Helpers
    
    func checkWiFiConnected() {
        
        if(!networkService.isWiFi()) {
            let warningMessage = "No Wi-Fi Connection detected.\n Please check your Wi-Fi settings to use printing functionality."
            let sb = UIStoryboard(name: "Warning", bundle: nil)
            if let sbRoot = sb.instantiateInitialViewController() {
                let popup = sbRoot as! WarningPopupViewController
                popup.warningMessage = warningMessage
                self.present(popup, animated: true)
            }
        }
    }

}
