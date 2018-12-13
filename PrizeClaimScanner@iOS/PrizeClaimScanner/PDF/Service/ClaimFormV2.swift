//
//  claimFormV1.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/26/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import PDFKit

//Version 1 of Claim Form - found on CALottery website
class ClaimFormV2: PDFService {
    
    override var pdfLocation: String {
        get {
           return "claimform2"
        }
        set {
            super.pdfLocation = newValue
        }
    }
    
    override var scratcherTicketFields: [String] {
        get{
            return [
                "form1[0].Page1[0].TicNumWrap1[0].TN1[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN2[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN3[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN4[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN5[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN6[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN7[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN8[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN9[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN10[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN11[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN13[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN14[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN15[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN16[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN17[0]",
                "form1[0].Page1[0].TicNumWrap1[0].TN18[0]"
            ]
        } set {
            super.scratcherTicketFields = newValue
        }
    }
    
    override var scratcherCheckDigit: [String] {
        get {
            return ["form1[0].Page1[0].TicNumWrap1[0].TN12[0]"]
        }
        set {
            super.scratcherCheckDigit = newValue
        }
    }
    
    override var gameTicketFields: [String] {
        get {
            return [
                "form1[0].Page1[0].TicNumWrap1[1].TN1[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN2[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN3[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN4[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN5[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN6[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN7[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN8[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN9[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN10[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN11[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN12[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN13[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN14[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN15[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN16[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN17[0]",
                "form1[0].Page1[0].TicNumWrap1[1].TN18[0]"
            ]
        }
        set {
            super.gameTicketFields = newValue
        }
    }
    
    override var gamePrizeFields: [String] {
        get {
            return [
                "form1[0].Page1[0].TextField3[9]",
                "form1[0].Page1[0].TextField3[10]",
                "form1[0].Page1[0].TextField3[11]",
                "form1[0].Page1[0].TextField3[13]",
                "form1[0].Page1[0].TextField3[16]",
                "form1[0].Page1[0].TextField3[12]",
                "form1[0].Page1[0].TextField3[14]",
                "form1[0].Page1[0].TextField3[15]",
                "form1[0].Page1[0].TextField3[17]",
            ]
        }
        set {
            super.gamePrizeFields = newValue
        }
    }
    
    override var scratcherPrizeFields: [String] {
        get {
            return [
                "form1[0].Page1[0].TextField3[0]",
                "form1[0].Page1[0].TextField3[1]",
                "form1[0].Page1[0].TextField3[2]",
                "form1[0].Page1[0].TextField3[4]",
                "form1[0].Page1[0].TextField3[7]",
                "form1[0].Page1[0].TextField3[3]",
                "form1[0].Page1[0].TextField3[5]",
                "form1[0].Page1[0].TextField3[6]",
                "form1[0].Page1[0].TextField3[8]",
            ]
        }
        set {
            super.gamePrizeFields = newValue
        }
    }
    
    override init(pdfView: PDFView, pdfData: ScanData?) {
        super.init(pdfView: pdfView, pdfData: pdfData)
        pdfFields = getFieldMappings()
    }
    
    func getFieldMappings() -> [PDFField] {
        guard let pdfData = pdfData else { return [] }
        return [
            PDFField(name: "form1[0].Page1[0].FirstNameIF[0]",  tag: .firstname, value: pdfData.firstName!),
            PDFField(name: "form1[0].Page1[0].LastNameIF[0]",   tag: .lastname,  value: pdfData.lastName!),
            PDFField(name: "form1[0].Page1[0].SuffixIF[0]",     tag: .suffix,    value: pdfData.suffix!),
            PDFField(name: "form1[0].Page1[0].DOBIF1[0]",       tag: .month,     value: pdfData.month!),
            PDFField(name: "form1[0].Page1[0].DOBIF2[0]",       tag: .day,       value: pdfData.day!),
            PDFField(name: "form1[0].Page1[0].DOBIF3[0]",       tag: .year,      value: pdfData.year!),
            PDFField(name: "form1[0].Page1[0].AddreIF[0]",      tag: .address1,  value: pdfData.address1!),
            PDFField(name: "form1[0].Page1[0].Address2IF[0]",   tag: .address2,  value: pdfData.address2!),
            PDFField(name: "form1[0].Page1[0].CityIF[0]",       tag: .city,      value: pdfData.city!),
            PDFField(name: "form1[0].Page1[0].CountryIF[0]",    tag: .country,   value: pdfData.country!),
            PDFField(name: "form1[0].Page1[0].EmailIF[0]",      tag: .email,     value: pdfData.email!),
            PDFField(name: "form1[0].Page1[0].StateIF[0]",      tag: .state,     value: pdfData.state!),
            PDFField(name: "form1[0].Page1[0].ZipIF1[0]",       tag: .zipcode1,  value: pdfData.zipcode1!),
            PDFField(name: "form1[0].Page1[0].ZipIF2[0]",       tag: .zipcode2,  value: pdfData.zipcode2!),
            PDFField(name: "form1[0].Page1[0].Pass1[0]",        tag: .ssn1,      value: pdfData.ssn1!),
            PDFField(name: "form1[0].Page1[0].Pass2[0]",        tag: .ssn2,      value: pdfData.ssn2!),
            PDFField(name: "form1[0].Page1[0].Pass3[0]",        tag: .ssn3,      value: pdfData.ssn3!),
            PDFField(name: "form1[0].Page1[0].CheckBox2[14]",   tag: .male,      value: String(pdfData.gender)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[15]",   tag: .female,    value: String(pdfData.gender)),
            PDFField(name: "form1[0].Page1[0].PhoneIF1[0]",     tag: .ph1,       value: pdfData.ph1!),
            PDFField(name: "form1[0].Page1[0].PhoneIF2[0]",     tag: .ph2,       value: pdfData.ph2!),
            PDFField(name: "form1[0].Page1[0].PhoneIF3[0]",     tag: .ph3,       value: pdfData.ph3!),
            PDFField(name: "form1[0].Page1[0].CBYes1[0]",       tag: .question,  value: String(pdfData.isLotteryRetailer)),
            PDFField(name: "form1[0].Page1[0].CBNo1[0]",        tag: .question,  value: String(!pdfData.isLotteryRetailer)),
            PDFField(name: "form1[0].Page1[0].CBYes2[0]",       tag: .question,  value: String(pdfData.isEmployedLotteryRetailer)),
            PDFField(name: "form1[0].Page1[0].CBNo2[0]",        tag: .question,  value: String(!pdfData.isEmployedLotteryRetailer)),
            PDFField(name: "form1[0].Page1[0].CBYes3[0]",       tag: .question,  value: String(pdfData.isRelatedLotteryRetailer)),
            PDFField(name: "form1[0].Page1[0].CBNo3[0]",        tag: .question,  value: String(!pdfData.isRelatedLotteryRetailer)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[0]",    tag: .question,  value: String(pdfData.race.isAfricanAmerican)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[1]",    tag: .question,  value: String(pdfData.race.isAsian)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[2]",    tag: .question,  value: String(pdfData.race.isHispanic)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[3]",    tag: .question,  value: String(pdfData.race.isWhite)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[4]",    tag: .question,  value: String(pdfData.race.isOther)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[5]",    tag: .question,  value: String(pdfData.income == Income.Under25)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[6]",    tag: .question,  value: String(pdfData.income == Income.From20To35)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[7]",    tag: .question,  value: String(pdfData.income == Income.From35To50)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[8]",    tag: .question,  value: String(pdfData.income == Income.From50to75)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[9]",    tag: .question,  value: String(pdfData.income == Income.Over75)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[10]",   tag: .question,  value: String(pdfData.education == Education.NoHighSchool)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[11]",   tag: .question,  value: String(pdfData.education == Education.GraduateHighSchool)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[12]",   tag: .question,  value: String(pdfData.education == Education.SomeCollege)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[13]",   tag: .question,  value: String(pdfData.education == Education.Graduate)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[16]",   tag: .question,  value: String(pdfData.occupation.isStudent)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[17]",   tag: .question,  value: String(pdfData.occupation.isEmployed)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[18]",   tag: .question,  value: String(pdfData.occupation.isUnEmployed)),
            PDFField(name: "form1[0].Page1[0].CheckBox2[19]",   tag: .question,  value: String(pdfData.occupation.isRetired)),
            PDFField(name: "form1[0].Page1[0].TextField2[1]",   tag: .field,     value: pdfData.peopleInHousehold),
            PDFField(name: "form1[0].Page1[0].TextField2[0]",   tag: .field,     value: pdfData.race.otherText),
            PDFField(name: "form1[0].Page1[0].MIIF[0]",         tag: .field,     value: pdfData.middleInitial!),
            PDFField(name: "form1[0].Page1[0].PrintClear1[0]",  tag: .printClear,value: ""),
            PDFField(name: "form1[0].Page1[0].PrintButton1[0]", tag: .printClear,value: ""),
            PDFField(name: "form1[0].Page1[0].CBSSN[0]",        tag: .question,  value: String(pdfData.noSSN)),
            PDFField(name: "form1[0].Page1[0].CBSSN[1]",        tag: .question,  value: String(pdfData.notCitizen))
        ]
        
    }
    
}
