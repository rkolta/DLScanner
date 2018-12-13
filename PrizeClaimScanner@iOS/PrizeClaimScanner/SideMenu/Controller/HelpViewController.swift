//
//  HelpViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 8/13/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit
import PDFKit

class HelpViewController: UIViewController {

     var pdfService: PDFService?
    
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfService = PDFService(pdfView: pdfView, pdfData: nil)
        pdfService?.pdfLocation = "helpPDF"
        pdfService?.loadDocument()
        self.pdfService?.scalePDFViewToFit()
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
}
