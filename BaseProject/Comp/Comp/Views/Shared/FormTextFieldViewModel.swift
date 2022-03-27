//
//  FormTextFieldViewModel.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

open class FormTextFieldViewModel: FormTextFieldViewModelProtocol, KeyValueProtocol {
    public var seperatorVisible: Bool? = true
    public var textChangedHandler: ((String?) -> Void)?
    public var isEnabled: Bool = true
    public var text: String?
    public var key: String?
    public var value: String?
    public var placeholder: String?
    public var accesibilityPlaceholder: String?
    public var maskString: String?
    public var canDeleteMaskPrefix: Bool = false
    public var keyboardType: UIKeyboardType?
    public var isSecureTextEntry: Bool = false
    public var maxLength: Int = 10000
    public var descriptionText: String?
    public var errorText: String?
    public var accessoryView: UIView?
    public var allowedCharacters: CharacterSet?
    public var contentType: UITextContentType?
    public var autoCorrectionType: UITextAutocorrectionType?
    public var disabledFont: UIFont?
    public var disabledTextColor: UIColor?
    public var autocapitalizationType: UITextAutocapitalizationType?
    public var becomeFirstResponder: Bool?
    
    public var shouldChangeCharacters: ((UITextField, NSRange, String) -> Bool)?
    public var shouldChangeCharactersAndParent: ((UITextField, NSRange, String) -> String)?
    public var endEditHandler: VoidHandler?
    public var beginEditHandler: VoidHandler?
    
    public init() { }
    
    public func getKeyValueParameter() -> KeyValueModelForCells {
        if isEnabled {
            return KeyValueModelForCells(key: key, value: text)
        } else {
            return KeyValueModelForCells(key: key, value: value)
        }
        
    }
}

extension FormTextFieldViewModel: ParameterConvertible {
    
    public var parameterValue: Any? {
        return text
    }
    
}

extension FormTextFieldViewModel: Validatable {
    
    // swiftlint:disable cyclomatic_complexity
    public func validate(with validators: [Validator], setErrorText: Bool) -> Bool {
        for validator in validators {
            if let requiredValidator = validator as? RequiredValidator {
                if text == nil || text!.isEmpty {
                    if setErrorText { errorText = requiredValidator.message }
                    return false
                }
            }
            if let ibanValidator = validator as? IbanValidator {
                if ibanValidator.validate(with: text) == false {
                    if setErrorText { errorText = ibanValidator.message }
                    return false
                }
            }
            if let trimValidator = validator as? TrimRequiredValidator {
                if trimValidator.validate(with: text ?? "") == false {
                    if setErrorText { errorText = trimValidator.message }
                    return false
                }
            }
            if let minimumLengthValidator = validator as? MinimumLengthValidator {
                if minimumLengthValidator.validate(with: text) == false {
                    if setErrorText { errorText = minimumLengthValidator.message }
                    return false
                }
            }
            if let minimumValueValidator = validator as? MinimumValueValidator {
                if minimumValueValidator.validate(with: Double(text ?? "")) == false {
                    if setErrorText { errorText = minimumValueValidator.message }
                    return false
                }
            }
            if let maximumValueValidator = validator as? MaximumValueValidator {
                if maximumValueValidator.validate(with: Double(text?.getNumbers ?? "")) == false {
                    if setErrorText { errorText = maximumValueValidator.message }
                    return false
                }
            }
            if let cardNumberValidator = validator as? CreditCardNumberValidator {
                if cardNumberValidator.validate(with: text) == false {
                    if setErrorText { errorText = cardNumberValidator.message }
                    return false
                }
            }
            if let phoneNumberValidator = validator as? PhoneNumberValidator {
                if phoneNumberValidator.validate(with: text) == false {
                    if setErrorText { errorText = phoneNumberValidator.message }
                    return false
                }
            }
            if let onlyNumbersValidator = validator as? OnlyNumbersValidator {
                if onlyNumbersValidator.validate(with: text) == false {
                    if setErrorText { errorText = onlyNumbersValidator.message }
                    return false
                }
            }
            
            if let transactionDayValidator = validator as? TransactionDayValidator {
                if transactionDayValidator.validate(with: text) == false {
                    if setErrorText { errorText = transactionDayValidator.message }
                    return false
                }
            }
            
            if let regexValidator = validator as? RegexValidator {
                if regexValidator.validate(with: text) == false {
                    if setErrorText { errorText = regexValidator.message }
                    return false
                }
            }
            
            if let functionValidator = validator as? FunctionValidator {
                if functionValidator.function() == false {
                    if setErrorText { errorText = functionValidator.message }
                    return false
                }
            }
            
            if let plateValidator = validator as? PlateValidator {
                if plateValidator.validate(with: text) == false {
                    if setErrorText { errorText = plateValidator.message }
                    return false
                }
            }
        }
        return true
    }
    // swiftlint:enable cyclomatic_complexity
    
    public func clearValidationState() {
        errorText = nil
    }
    
}

public class FormIbanTextFieldViewModel: FormTextFieldViewModel {
    
    public override init() {
        super.init()
        placeholder = "IBAN".localized
        maskString = "TR## #### #### #### #### #### ##"
        keyboardType = .numbersAndPunctuation
        allowedCharacters = CharacterSet.alphanumerics
        autoCorrectionType = .no
        maxLength = 24
        
        shouldChangeCharactersAndParent = { textField, range, replacementString -> String in
            let oldText = textField.text as NSString?
            var newText = oldText?.replacingCharacters(in: range, with: replacementString)
            let newReplacementString = String(replacementString)
            if newReplacementString.count > 1 {
                newText = newText?.getNumbers
                if (newText?.isEmpty)~ {
                    return "TR"
                }
                return newText ?? "TR"
            }
            
            return newText ?? "TR"
            
        }
    }
    
}

public class FormCreditCardNumberTextFieldViewModel: FormTextFieldViewModel {
    
    public override init() {
        super.init()
        placeholder = "Kart Numarası".localized
        maskString = "#### #### #### ####"
        keyboardType = .numberPad
        allowedCharacters = .decimalDigits
        maxLength = 16

        shouldChangeCharactersAndParent = { textField, range, replacementString -> String in
            let oldText = textField.text as NSString?
            var newText = oldText?.replacingCharacters(in: range, with: replacementString)
            let newReplacementString = String(replacementString)
            if newReplacementString.count > 1 {
                newText = newText?.getNumbers
                return newText ?? ""
            }
            
            return newText ?? ""
            
        }
    }
}

public class PhoneNumberTextFieldViewModel: FormTextFieldViewModel {
    
    public override init() {
        super.init()
        placeholder = "Telefon".localized
        maskString = "5## ### ## ##"
        canDeleteMaskPrefix = true
        keyboardType = .phonePad
        allowedCharacters = .decimalDigits
        shouldChangeCharactersAndParent = { textField, range, replacementString -> String in
            let oldText = textField.text as NSString?
            var newText = oldText?.replacingCharacters(in: range, with: replacementString)
            let newReplacementString = String(replacementString)
            if newReplacementString.count > 1 {
                newText = newText?.getNumbers
                return newText ?? ""
            }
            
            return newText ?? ""
        }
    }
    
}

public class FormTextFieldCountViewModel: FormTextFieldViewModel {
    
    private var accessoryLabel: UILabel!
    
    public override var text: String? {
        didSet {
            calculateAccessoryLabelText()
        }
    }
    
    public override var maxLength: Int {
        didSet {
            calculateAccessoryLabelText()
        }
    }
    
    private func calculateAccessoryLabelText() {
        let textLength = text == nil ? 0 : text!.count
        accessoryLabel.text = "\(textLength)/\(maxLength)"
    }
    
    public override init() {
        super.init()
        accessoryLabel = UILabel()
        calculateAccessoryLabelText()
        accessoryLabel.font = .regular(of: 11)
        accessoryLabel.textColor = .appDarkGray
        accessoryView = accessoryLabel
    }
    
}
