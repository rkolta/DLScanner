//
//  PDFService.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/20/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation
import PDFKit

class PDFService {
    
    var scratcherTicketFields: [String] = []
    
    var scratcherCheckDigit: [String] = []
    
    var gameTicketFields: [String] = []
    
    var scratcherPrizeFields: [String] = []
    
    var gamePrizeFields: [String] = []
    
    var pdfView: PDFView
    var pdfData: ScanData?
    var pdfFields: [PDFField] = []
    
    var pdfLocation: String = ""
    
    init(pdfView: PDFView, pdfData: ScanData?) {
        self.pdfView = pdfView
        self.pdfData = pdfData
    }
    
    //MARK: Constants
    let animationDuration: TimeInterval = 0.25
    
    func loadAnnotation() {
        if let annotations = pdfView.document?.page(at: 0)?.annotations {
            setAnnotationValues(annotations)
             //for annotation in annotations {
                //annotation.page?.removeAnnotation(annotation)
            //}
        } else {
            print("No annotation")
        }
        
    }
    
    func setupPDFView() {
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
    }
    
    func loadDocument() {
        if let url = Bundle.main.url(forResource: self.pdfLocation, withExtension: "pdf") {
            let PDFdocument = PDFDocument(url: url)
            pdfView.document = PDFdocument
        } else {
            print("No PDF found")
        }
    }
    
    func scalePDFViewToFit() {
        UIView.animate(withDuration: animationDuration) {
            self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit
            self.pdfView.layoutIfNeeded()
            self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit
        }
    }
    
    // Mark: - Helper functions
    
    func addText(annotation: PDFAnnotation, value: String) {
        let newAnnotation = PDFAnnotation(bounds: annotation.bounds, forType: .freeText, withProperties: nil)
        newAnnotation.contents = value
        newAnnotation.color = .clear
        newAnnotation.font = UIFont(name: "ArialMT", size: 8)
        pdfView.document?.page(at: 0)?.addAnnotation(newAnnotation)
    }
    
    func addBox(annotation: PDFAnnotation) {
        let newAnnotation = PDFAnnotation(bounds: annotation.bounds.insetBy(dx: 2, dy: 2), forType: .square, withProperties: nil)
        newAnnotation.interiorColor = UIColor.black
        pdfView.document?.page(at: 0)?.addAnnotation(newAnnotation)
        
    }
    
    func setAnnotationValues(_ annotations: [PDFAnnotation]){
        for annotation in annotations {
            if(annotation.widgetFieldType != .button) {
                annotation.font = UIFont(name: "ArialMT", size: 8)
                annotation.bounds.size = CGSize(width: annotation.bounds.size.width + 2, height: annotation.bounds.size.height + 2)
            }
            
            setPdfField(annotation: annotation)
            setGameAnnotationValue(annotation: annotation)
            setScratcherCheckDigit(annotation: annotation)
            setPrizeClaimed(annotation: annotation)
            clearAnnotation(annotation: annotation)
        }
    }
    
    func clearAnnotation(annotation: PDFAnnotation) {
        //if(annotation.widgetFieldType != .button) {
            annotation.page?.removeAnnotation(annotation)
        //}
    }
    
    func setPdfField(annotation: PDFAnnotation) {
        let field = pdfFields.first(where: {$0.name == annotation.fieldName})
        if(field == nil) {
            return
        }
        
        guard let tag = field?.tag else { return }
        
        switch tag {
        case .printClear:
            annotation.page?.removeAnnotation(annotation)
        case .male:
            if(Gender(rawValue: Int(field?.value ?? "0")!) == .male) {
                addBox(annotation: annotation)
                //annotation.buttonWidgetState = .onState
            }
        case .female:
            if(Gender(rawValue: Int(field?.value ?? "0")!) == .female) {
                addBox(annotation: annotation)
                //annotation.buttonWidgetState = .onState
            }
        case .question:
            if(Bool(field?.value ?? "false" ) ?? false) {
                addBox(annotation: annotation)
                //annotation.buttonWidgetState = .onState
            }
        case .ssn1, .ssn2, .ssn3:
            annotation.bounds.size = CGSize(width: annotation.bounds.size.width - 2, height: annotation.bounds.size.height - 2)
            addText(annotation: annotation, value: field?.value ?? "")
        default:
            addText(annotation: annotation, value: field?.value ?? "")
            //annotation.setValue(field?.value ?? "", forAnnotationKey: .widgetValue)
        }
        
    }
    
    func setGameAnnotationValue(annotation: PDFAnnotation) {
        //get ticket number
        let ticketno = pdfData?.ticketno ?? ""
        var fields: [String] = []
        
        if((pdfData?.isScratcher ?? false)) {
            fields = scratcherTicketFields
        } else {
            fields = gameTicketFields
        }
        //set correct size for ticket numbers
        if(!fields.contains(annotation.fieldName ?? ""))
        {
            return
        }
        
        annotation.alignment = .left
        //annotation.bounds.size = CGSize(width: 10, height: 12)
        
        // Check to see if annotation is part of game ticket fields
        //Get index of array with fieldname - this will tell us the position in the ticket number
        if let gameIndex: Int = fields.index(of: annotation.fieldName!) {
            if gameIndex < ticketno.count {
                let ticketIndex = ticketno.index(ticketno.startIndex, offsetBy: gameIndex)
                addText(annotation: annotation, value: String(ticketno[ticketIndex]))
                //annotation.setValue(String(ticketno[ticketIndex]), forAnnotationKey: .widgetValue)
            }
        }
    }
    
    func setScratcherCheckDigit(annotation: PDFAnnotation) {
        if(scratcherCheckDigit.contains(annotation.fieldName ?? "") && (pdfData?.isScratcher ?? false) )
        {
            annotation.alignment = .left
            //annotation.bounds.size = CGSize(width: 10, height: 12)
            addText(annotation: annotation, value: pdfData?.checkDigit ?? "")
            //annotation.setValue(pdfData?.checkDigit ?? "", forAnnotationKey: .widgetValue)
        } else
        {
            return
        }
    }
    
    func setPrizeClaimed(annotation: PDFAnnotation)
    {
        var fields: [String] = []
        let prize = pdfData?.prizeClaimed ?? ""
        if((pdfData?.isScratcher ?? false)) {
            fields = scratcherPrizeFields
        } else
        {
            fields = gamePrizeFields
        }
        
        if(fields.contains(annotation.fieldName ?? ""))
        {
            annotation.alignment = .left
            //annotation.bounds.size = CGSize(width: 10, height: 12)
            if let prizeIndex: Int = fields.index(of: annotation.fieldName!) {
                if prizeIndex < prize.count {
                    let prizeAmountIndex = prize.index(prize.startIndex, offsetBy: prizeIndex)
                    addText(annotation: annotation, value: String(prize[prizeAmountIndex]))
                    //annotation.setValue(String(prize[prizeAmountIndex]), forAnnotationKey: .widgetValue)
                }
            }
        } else
        {
            return
        }
        
        
    }
    
}
