//
//  claimFormV1.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/26/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import PDFKit

//Version 1 of Claim Form - found on CALottery website
class ClaimFormV1: PDFService {
    
    override var pdfLocation: String {
        get {
            return "claimform"
        }
        set {
            super.pdfLocation = newValue
        }
    }

    override var scratcherTicketFields: [String] {
        get{
            return ["form1[0].#subform[0].TextField3[18]",
                    "form1[0].#subform[0].TextField3[19]",
                    "form1[0].#subform[0].TextField3[20]",
                    "form1[0].#subform[0].TextField3[21]",
                    "form1[0].#subform[0].TextField3[22]",
                    "form1[0].#subform[0].TextField3[23]",
                    "form1[0].#subform[0].TextField3[24]",
                    "form1[0].#subform[0].TextField3[25]",
                    "form1[0].#subform[0].TextField3[26]",
                    "form1[0].#subform[0].TextField3[27]",
                    "form1[0].#subform[0].TextField3[28]",
                    "form1[0].#subform[0].TextField3[30]",
                    "form1[0].#subform[0].TextField3[31]",
                    "form1[0].#subform[0].TextField3[32]",
                    "form1[0].#subform[0].TextField3[33]",
                    "form1[0].#subform[0].TextField3[34]",
                    "form1[0].#subform[0].TextField3[35]"]
        } set {
            super.scratcherTicketFields = newValue
        }
    }
    
    override var scratcherCheckDigit: [String] {
        get {
            return ["form1[0].#subform[0].TextField3[29]"]
        }
        set {
            super.scratcherCheckDigit = newValue
        }
    }
    
    override var gameTicketFields: [String] {
        get {
            return [
                "form1[0].#subform[0].TextField3[36]",
                "form1[0].#subform[0].TextField3[37]",
                "form1[0].#subform[0].TextField3[38]",
                "form1[0].#subform[0].TextField3[39]",
                "form1[0].#subform[0].TextField3[40]",
                "form1[0].#subform[0].TextField3[41]",
                "form1[0].#subform[0].TextField3[42]",
                "form1[0].#subform[0].TextField3[43]",
                "form1[0].#subform[0].TextField3[44]",
                "form1[0].#subform[0].TextField3[45]",
                "form1[0].#subform[0].TextField3[46]",
                "form1[0].#subform[0].TextField3[47]",
                "form1[0].#subform[0].TextField3[48]",
                "form1[0].#subform[0].TextField3[49]",
                "form1[0].#subform[0].TextField3[50]",
                "form1[0].#subform[0].TextField3[51]",
                "form1[0].#subform[0].TextField3[52]",
                "form1[0].#subform[0].TextField3[53]"
            ]
        }
        set {
            super.gameTicketFields = newValue
        }
    }
    
    override init(pdfView: PDFView, pdfData: ScanData?) {
        super.init(pdfView: pdfView, pdfData: pdfData)
        pdfFields = getFieldMappings()
    }
    
    func getFieldMappings() -> [PDFField] {
        guard let pdfData = pdfData else { return [] }
        return [
            PDFField(name: "form1[0].#subform[0].TextField1[4]",  tag: PDFFieldTag.firstname, value: pdfData.firstName!),
            PDFField(name: "form1[0].#subform[0].TextField1[0]",  tag: PDFFieldTag.lastname,  value: pdfData.lastName!),
            PDFField(name: "form1[0].#subform[0].TextField1[6]",  tag: PDFFieldTag.suffix,    value: pdfData.suffix!),
            PDFField(name: "form1[0].#subform[0].TextField1[1]",  tag: PDFFieldTag.month,     value: pdfData.month!),
            PDFField(name: "form1[0].#subform[0].TextField1[2]",  tag: PDFFieldTag.day,       value: pdfData.day!),
            PDFField(name: "form1[0].#subform[0].TextField1[3]",  tag: PDFFieldTag.year,      value: pdfData.year!),
            PDFField(name: "form1[0].#subform[0].TextField1[10]", tag: PDFFieldTag.address1,  value: pdfData.address1!),
            PDFField(name: "form1[0].#subform[0].TextField1[11]", tag: PDFFieldTag.address2,  value: pdfData.address2!),
            PDFField(name: "form1[0].#subform[0].TextField1[12]", tag: PDFFieldTag.city,      value: pdfData.city!),
            PDFField(name: "form1[0].#subform[0].TextField1[13]", tag: PDFFieldTag.country,   value: pdfData.country!),
            PDFField(name: "form1[0].#subform[0].TextField1[14]", tag: PDFFieldTag.email,     value: ""),
            PDFField(name: "form1[0].#subform[0].TextField1[15]", tag: PDFFieldTag.state,     value: pdfData.state!),
            PDFField(name: "form1[0].#subform[0].TextField1[16]", tag: PDFFieldTag.zipcode1,  value: pdfData.zipcode1!),
            PDFField(name: "form1[0].#subform[0].TextField1[17]", tag: PDFFieldTag.zipcode2,  value: pdfData.zipcode2!),
            PDFField(name: "form1[0].#subform[0].TextField1[7]",  tag: PDFFieldTag.ssn1,      value: pdfData.ssn1!),
            PDFField(name: "form1[0].#subform[0].TextField1[8]",  tag: PDFFieldTag.ssn2,      value: pdfData.ssn2!),
            PDFField(name: "form1[0].#subform[0].TextField1[9]",  tag: PDFFieldTag.ssn3,      value: pdfData.ssn3!),
            PDFField(name: "form1[0].#subform[0].CheckBox2[20]",  tag: PDFFieldTag.male,      value: String(pdfData.gender)),
            PDFField(name: "form1[0].#subform[0].CheckBox2[21]",  tag: PDFFieldTag.female,    value: String(pdfData.gender))
        ]
        
    }
    
}
