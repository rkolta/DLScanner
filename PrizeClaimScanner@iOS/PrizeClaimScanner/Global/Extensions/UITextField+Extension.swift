import UIKit
private var __maxLengths = [UITextField: Int]()
private var __isPhone = [UITextField: Bool] ()
private var __isNumeric = [UITextField: Bool]()
private var __isRequired = [UITextField: Bool]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fixMaxLength), for: .editingChanged)
        }
    }
    
    @IBInspectable var isPhone: Bool {
        get {
            guard let p = __isPhone[self] else {
                return false // (global default-limit. or just, Int.max)
            }
            return p
        }
        set {
            __isPhone[self] = newValue
            addTarget(self, action: #selector(formatPhone), for: .editingChanged)
        }
    }
    
    @IBInspectable var isNumeric: Bool {
        get {
            guard let n = __isNumeric[self] else {
                return false // (global default-limit. or just, Int.max)
            }
            return n
        }
        set {
            __isNumeric[self] = newValue
            addTarget(self, action: #selector(formatNumber), for: .editingChanged)
        }
    }
    
    
    @IBInspectable var isRequired: Bool {
        get {
            guard let n = __isRequired[self] else {
                return false // (global default-limit. or just, Int.max)
            }
            return n
        }
        set {
            __isRequired[self] = newValue
            addTarget(self, action: #selector(formatRequired), for: .editingChanged)
        }
    }
    
    //Mark: Functions
    
    @objc func fixMaxLength(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    @objc func formatPhone(textField: UITextField) {
        let t = textField.text
        
        guard let number = t?.toPhone() else {
            return
        }
        textField.text = number
    }
    
    @objc func formatNumber(textField: UITextField) {
        let t = textField.text
        textField.text = t?.toNumeric()
    }
    
    @objc func formatRequired(textField: UITextField) {
        let t = textField.text
        if(t == "") {
            textField.backgroundColor = Colors.danger
            
        } else {
            textField.backgroundColor = UIColor.white
        }
    }
}

