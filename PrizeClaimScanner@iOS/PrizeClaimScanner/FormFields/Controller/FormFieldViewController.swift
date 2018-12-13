//
//  FormFieldViewController.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 9/24/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit

class FormFieldViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Address1: UITextField!
    @IBOutlet weak var Address2: UITextField!
    @IBOutlet weak var City: UITextField!
    @IBOutlet weak var Country: UITextField!
    @IBOutlet weak var State: UITextField!
    @IBOutlet weak var Zipcode1: UITextField!
    @IBOutlet weak var Zipcode2: UITextField!
    @IBOutlet weak var SSN: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var TicketNo: UITextField!
    @IBOutlet weak var CheckDigit: UITextField!
    @IBOutlet weak var PrizeClaimed: UITextField!
    @IBOutlet weak var Suffix: UITextField!
    @IBOutlet weak var MI: UITextField!
    @IBOutlet weak var IsLotteryRetailer: UISwitch!
    @IBOutlet weak var IsEmployedRetailer: UISwitch!
    @IBOutlet weak var IsRelatedRetailer: UISwitch!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var AddDate: UIButton!
    @IBOutlet weak var IncomePicker: UIPickerView!
    @IBOutlet weak var EducationPicker: UIPickerView!
    @IBOutlet weak var IsAfricanAmerican: UISwitch!
    @IBOutlet weak var IsAsian: UISwitch!
    @IBOutlet weak var IsHispanic: UISwitch!
    @IBOutlet weak var IsWhite: UISwitch!
    @IBOutlet weak var IsOther: UISwitch!
    @IBOutlet weak var OtherText: UITextField!
    @IBOutlet weak var NumberPeople: UITextField!
    @IBOutlet weak var IsStudent: UISwitch!
    @IBOutlet weak var IsEmployed: UISwitch!
    @IBOutlet weak var IsUnemployed: UISwitch!
    @IBOutlet weak var IsRetired: UISwitch!
    @IBOutlet weak var NoSSN: UISwitch!
    @IBOutlet weak var NotCitizen: UISwitch!
    @IBOutlet weak var GenderPicker: UIPickerView!
    
    var scanParser: ScanParser?
    var isClear = true
    var isPdfView = false
    var incomePickerList: [String] = []
    var educationPickerList: [String] = []
    var genderPickerList: [String] = []
    let textfieldHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: contentView, action: #selector(UIView.endEditing(_:))))
        
        //Ajust View of Textfields
        _ = getAllTextFields(fromView: self.view).map{
            $0.returnKeyType = UIReturnKeyType.done
            $0.delegate = self
            let const = NSLayoutConstraint(item: $0, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: textfieldHeight)
            NSLayoutConstraint.activate([const])
        }
        //Init Values
        incomePickerList = setIncomeList()
        educationPickerList = setEducationList()
        genderPickerList = setGenderList()
        
        IncomePicker.delegate = self
        IncomePicker.dataSource = self
        EducationPicker.delegate = self
        EducationPicker.dataSource = self
        GenderPicker.delegate = self
        GenderPicker.dataSource = self
        
        initValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Capture Data if back to main menu is pressed
        if(!isClear && !isPdfView) {
            captureValues()
        }
        
        //Send notification if PDFView or Main Menu are pressed
        if(isPdfView || !isClear) {
            NotificationService.post(Notifications.scanComplete.rawValue)
        }
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        isClear = true
    }
    
    
    @IBAction func addDatePressed(_ sender: Any) {
        AddDate.isHidden = true
        DatePicker.isHidden = false
    }
    
    @IBAction func viewPdfPressed(_ sender: Any) {
        captureValues()
        isPdfView = true
        if(isValidForm()) {
            navigationController?.popViewController(animated: false)
            NotificationService.post(Notifications.viewPDF.rawValue)
        }
    }
    
    func isValidForm() -> Bool {
        var warningMessage = ""
        
        if(isMissingRequiredTextFields()) {
           warningMessage = "Missing Required Fields\n"
        }
        
        if(scanParser?.isUnderAge() ?? false) {
            warningMessage += "Claimant is under 18 years old\n"
        }
        
        if(Zipcode1.text != "" && Zipcode1.text != nil && Zipcode1.text!.count < 5) {
            warningMessage += "Zipcode is less than 5 digits \n"
            Zipcode1.backgroundColor = Colors.danger
        }
        
        if(SSN.text != "" && SSN.text != nil && SSN.text!.count < 9) {
            warningMessage += "SSN/TIN is less than 9 digits \n"
            SSN.backgroundColor = Colors.danger
        }
        
        if(warningMessage != "") {
            let sb = UIStoryboard(name: "Warning", bundle: nil)
            if let sbRoot = sb.instantiateInitialViewController() {
                let popup = sbRoot as! WarningPopupViewController
                popup.warningMessage = warningMessage
                self.present(popup, animated: true)
                return false
            }
        }
        
        
        return true
    }
    
    func setIncomeList() -> [String]
    {
        var incomeList: [String] = []
        Income.allCases.forEach { (income) in
            incomeList.append(income.rawValue)
        }
        
        return incomeList
    }
    
    func setEducationList() -> [String]
    {
        var educationList: [String] = []
        Education.allCases.forEach { (income) in
            educationList.append(income.rawValue)
        }
        
        return educationList
    }
    
    func setGenderList() -> [String]
    {
        return ["None", "Male", "Female"]
    }
    
    func initValues() {
        
        if let scanData = scanParser?.scanData {
            let phone   = (scanData.ph1 ?? "") + (scanData.ph2 ?? "") + (scanData.ph3 ?? "")
            FirstName.text  = scanData.firstName
            LastName.text   = scanData.lastName
            MI.text         = scanData.middleInitial
            
            if let date = getBirthDate(scanData).date {
                DatePicker.setDate(date, animated: true)
                DatePicker.isHidden = false
                AddDate.isHidden = true
            } else {
                DatePicker.isHidden = true
                AddDate.isHidden = false
            }
            
            Address1.text   = scanData.address1
            Address2.text   = scanData.address2
            City.text       = scanData.city
            Country.text    = scanData.country
            State.text      = scanData.state
            Zipcode1.text   = scanData.zipcode1
            Zipcode2.text   = scanData.zipcode2
            SSN.text        = (scanData.ssn1 ?? "") + (scanData.ssn2 ?? "") + (scanData.ssn3 ?? "")
            Phone.text      = phone.toPhone()
            TicketNo.text   = scanData.ticketno
            CheckDigit.text = scanData.checkDigit
            PrizeClaimed.text = scanData.prizeClaimed
            Suffix.text     = scanData.suffix
            Email.text      = scanData.email
            IsLotteryRetailer.isOn = scanData.isLotteryRetailer
            IsEmployedRetailer.isOn = scanData.isEmployedLotteryRetailer
            IsRelatedRetailer.isOn = scanData.isRelatedLotteryRetailer
            NumberPeople.text = scanData.peopleInHousehold
            NoSSN.isOn = scanData.noSSN
            NotCitizen.isOn = scanData.notCitizen
            initRace()
            initIncome()
            initEducation()
            initOccupation()
            initGender()
        }
    }
    
    func captureValues()
    {
        scanParser?.isFormComplete = true
        let phone = Phone.text?.toNumeric() ?? ""
        let ssn = SSN.text?.toNumeric() ?? ""
        
        scanParser?.scanData.firstName  = FirstName.text ?? ""
        scanParser?.scanData.lastName   = LastName.text ?? ""
        scanParser?.scanData.middleInitial = MI.text ?? ""
        scanParser?.scanData.address1   = Address1.text ?? ""
        scanParser?.scanData.address2   = Address2.text ?? ""
        scanParser?.scanData.city       = City.text ?? ""
        scanParser?.scanData.country    = Country.text ?? ""
        scanParser?.scanData.state      = State.text ?? ""
        scanParser?.scanData.zipcode1   = Zipcode1.text ?? ""
        scanParser?.scanData.zipcode2   = Zipcode2.text ?? ""
        scanParser?.scanData.ticketno   = TicketNo.text ?? ""
        scanParser?.scanData.checkDigit = CheckDigit.text ?? ""
        scanParser?.scanData.prizeClaimed = PrizeClaimed.text ?? ""
        scanParser?.scanData.suffix     = Suffix.text
        scanParser?.scanData.isLotteryRetailer = IsLotteryRetailer.isOn
        scanParser?.scanData.isEmployedLotteryRetailer = IsEmployedRetailer.isOn
        scanParser?.scanData.isRelatedLotteryRetailer = IsRelatedRetailer.isOn
        scanParser?.scanData.ph1 = phone.extractString(start: 0, length: 3)
        scanParser?.scanData.ph2 = phone.extractString(start: 3, length: 3)
        scanParser?.scanData.ph3 = phone.extractString(start: 6, length: 0)
        scanParser?.scanData.ssn1 = ssn.extractString(start: 0, length: 3)
        scanParser?.scanData.ssn2 = ssn.extractString(start: 3, length: 2)
        scanParser?.scanData.ssn3 = ssn.extractString(start: 5, length: 0)
        scanParser?.scanData.email = Email.text
        scanParser?.scanData.noSSN = NoSSN.isOn
        scanParser?.scanData.notCitizen = NotCitizen.isOn
        
        if(!DatePicker.isHidden) {
            let dateComponents = getDatePickerDate()
            scanParser?.scanData.month  = dateComponents.month  != nil ? String(dateComponents.month!)  : ""
            scanParser?.scanData.day    = dateComponents.day    != nil ? String(dateComponents.day!)    : ""
            scanParser?.scanData.year   = dateComponents.year   != nil ? String(dateComponents.year!)   : ""
        }
        
        setRace()
        setIncome()
        setEducation()
        setOccupation()
        setGender()
    }
    
    //Mark: Helper Functions
    
    func initRace() {
        if let scanData = scanParser?.scanData {
            IsAfricanAmerican.isOn = scanData.race.isAfricanAmerican
            IsAsian.isOn = scanData.race.isAsian
            IsWhite.isOn = scanData.race.isWhite
            IsHispanic.isOn = scanData.race.isHispanic
            IsOther.isOn = scanData.race.isOther
            OtherText.text = scanData.race.otherText
        }
    }
    
    func setRace() {
        scanParser?.scanData.race.isAsian = IsAsian.isOn
        scanParser?.scanData.race.isWhite = IsWhite.isOn
        scanParser?.scanData.race.isHispanic = IsHispanic.isOn
        scanParser?.scanData.race.isOther = IsOther.isOn
        scanParser?.scanData.race.isAfricanAmerican = IsAfricanAmerican.isOn
        if(IsOther.isOn) {
            scanParser?.scanData.race.otherText = OtherText.text ?? ""
        } else {
            scanParser?.scanData.race.otherText = ""
        }
    }
    
    func initOccupation() {
        if let scanData = scanParser?.scanData {
            IsStudent.isOn = scanData.occupation.isStudent
            IsEmployed.isOn = scanData.occupation.isEmployed
            IsUnemployed.isOn = scanData.occupation.isUnEmployed
            IsRetired.isOn = scanData.occupation.isRetired
        }
    }
    
    func setOccupation() {
        scanParser?.scanData.occupation.isStudent = IsStudent.isOn
        scanParser?.scanData.occupation.isEmployed = IsEmployed.isOn
        scanParser?.scanData.occupation.isUnEmployed = IsUnemployed.isOn
        scanParser?.scanData.occupation.isRetired = IsRetired.isOn
    }
    
    func initIncome() {
         if let scanData = scanParser?.scanData {
            let index = Income.allCases.firstIndex(where: {$0 == scanData.income}) ?? 0
            IncomePicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func setIncome() {
        scanParser?.scanData.peopleInHousehold = NumberPeople.text ?? ""
        scanParser?.scanData.income = Income(rawValue: incomePickerList[IncomePicker.selectedRow(inComponent: 0)]) ?? Income.None
    }
    
    func initGender() {
        if let scanData = scanParser?.scanData {
            GenderPicker.selectRow(scanData.gender, inComponent: 0, animated: false)
        }
    }
    
    func setGender() {
        scanParser?.scanData.gender = GenderPicker.selectedRow(inComponent: 0)
    }
    
    func initEducation() {
        if let scanData = scanParser?.scanData {
            let index = Education.allCases.firstIndex(where: {$0 == scanData.education}) ?? 0
            EducationPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func setEducation() {
        scanParser?.scanData.education = Education(rawValue: educationPickerList[EducationPicker.selectedRow(inComponent: 0)]) ?? Education.None
    }
    
    func getBirthDate(_ scanData: ScanData) -> DateComponents {
        var dateComponents = DateComponents()
        let month = scanData.month ?? ""
        let day = scanData.day ?? ""
        let year = scanData.year ?? ""
        if(!month.isEmpty && !day.isEmpty && !year.isEmpty) {
            dateComponents.month = Int(month)
            dateComponents.day   = Int(day)
            dateComponents.year  = Int(year)
            dateComponents.calendar = Calendar.current
        }
        return dateComponents
    }
    
    func getDatePickerDate() -> DateComponents {
        let date = DatePicker.date
        let dateComponents = Calendar.current.dateComponents([.month, .day, .year], from: date)
        return dateComponents
    }
    
    func getAllTextFields(fromView: UIView) -> [UITextField] {
        return fromView.subviews.compactMap { (view) -> [UITextField]? in
            if(view is UITextField) {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
            }.flatMap({$0})
    }
    
    func isMissingRequiredTextFields() -> Bool {
        var missing = false
        _ = getAllTextFields(fromView: self.view).map {
            if($0.isRequired && ($0.text?.isEmpty ?? true)) {
                $0.backgroundColor = Colors.danger
                missing = true
            }
        }
        
        if(!AddDate.isHidden) {
            AddDate.tintColor = UIColor.red
            missing = true
        }
        
        return missing
    }
    
    //Mark: TextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isClear = false
        
        if(!textField.isRequired) {
            textField.backgroundColor = UIColor.white
        }
    }

    //Mark: Picker Functions

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == IncomePicker) {
            return incomePickerList.count
        }
        else if(pickerView == EducationPicker){
            return educationPickerList.count
        }
        else if(pickerView == GenderPicker) {
            return genderPickerList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == IncomePicker) {
            return incomePickerList[row]
        }
        else if(pickerView == EducationPicker){
            return educationPickerList[row]
        }
        else if(pickerView == GenderPicker) {
            return genderPickerList[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isClear = false
    }
}
