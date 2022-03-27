//
//  ValidationClasses.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public protocol Validatable {
    func validate(with validators: [Validator], setErrorText: Bool) -> Bool
    func clearValidationState()
}

public protocol Validator {
    var message: String { get }
}

public class RequiredValidator: Validator {
    
    public private(set) var message: String
    public static let defaultMessage = "Bu alan zorunludur.".localized
    
    public init(message: String = defaultMessage) {
        self.message = message
    }
    
    public init(placeHolder: String) {
        let placeHolderMessage = "Lütfen %@ girin.".localized(placeHolder)
        self.message = placeHolderMessage
    }
    
}

public class TrimRequiredValidator: Validator {
    
    public private(set) var message: String
    public static let defaultMessage = "Bu alan zorunludur.".localized
    
    public init(message: String = defaultMessage) {
        self.message = message
    }
    
    public init(placeHolder: String) {
        let placeHolderMessage = "Lütfen %@ girin.".localized(placeHolder)
        self.message = placeHolderMessage
    }
    
    public func validate(with text: String) -> Bool {
        if text.trimWhitespaces.isEmpty { return false }
        return true
    }
}

public class IbanValidator: Validator {
    
    public private(set) var message: String
    
    public init(message: String = "Girdiğiniz IBAN hatalıdır.".localized) {
        self.message = message
    }
    
    public func validate(with text: String?) -> Bool {
        if text == nil || text!.count < 32 { return false }
        if text!.starts(with: "TR") == false { return false }
        
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: " ")
        let unwantedCharacters = text!.trimmingCharacters(in: allowedCharacters)
        if !unwantedCharacters.isEmpty { return false }
        
        return true
    }
    
}

public class CreditCardNumberValidator: Validator {
    
    public private(set) var message: String
    
    public init(message: String = "Geçerli bir kredi kartı numarası giriniz.".localized) {
        self.message = message
    }
    
    public func validate(with text: String?) -> Bool {
        if text == nil { return false }
        
        var allowedCharacters = CharacterSet.decimalDigits
        allowedCharacters.insert(charactersIn: " ")
        let unwantedCharacters = text!.trimmingCharacters(in: allowedCharacters)
        if !unwantedCharacters.isEmpty { return false }
        
        // Apply Luhn's algorithm
        var sum: Int = 0
        let trimmedText: String = text!.replacingOccurrences(of: " ", with: "")
        let reversedCharacters: [String] = trimmedText.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
}

public class MinimumLengthValidator: Validator {
    
    public private(set) var message: String
    public private(set) var length: Int
    public private(set) var checkEmpty: Bool = true
    
    public init(length: Int, message: String? = nil) {
        self.length = length
        self.message = message ?? "Bu alan en az %@ karakter uzunluğunda olmalıdır.".localized(length.string)
    }
    
    public init(length: Int, message: String? = nil, checkEmpty: Bool) {
        self.length = length
        self.message = message ?? "Bu alan en az %@ karakter uzunluğunda olmalıdır.".localized(length.string)
        self.checkEmpty = checkEmpty
    }
    
    public func validate(with text: String?) -> Bool {
        if checkEmpty {
            if text == nil || text!.count < length { return false }
        } else {
            if text != nil && !text!.isEmpty && text!.count < length { return false }
        }
        return true
    }
    
}

public class MinimumValueValidator: Validator {
    
    public private(set) var message: String
    public private(set) var value: Double
    
    public init(value: Double, message: String? = nil) {
        self.value = value
        self.message = message ?? "Bu alan en az %f olmalıdır.".localized(value)
    }
    
    public func validate(with value: Double?) -> Bool {
        guard let value = value else { return false }
        return value >= self.value
    }
    
}

public class MaximumValueValidator: Validator {
    
    private var initialMessage: String?
    
    public var message: String {
        return initialMessage ?? "Bu alan en fazla %f olmalıdır.".localized(value)
    }
    
    public var value: Double
    
    public init(value: Double, message: String? = nil) {
        self.value = value
        self.initialMessage = message
    }
    
    public func validate(with value: Double?) -> Bool {
        guard let value = value else { return false }
        return value <= self.value
    }
    
}

public class PhoneNumberValidator: Validator {
    
    public private(set) var message: String
    
    public init(message: String = "Girdiğiniz Telefon Numarası hatalıdır.".localized) {
        self.message = message
    }
    
    public func validate(with text: String?) -> Bool {
        if text == nil || text?.removingSpaces.count != 10 { return false }
        
        var allowedCharacters = CharacterSet.decimalDigits
        allowedCharacters.insert(charactersIn: " ")
        let unwantedCharacters = text!.trimmingCharacters(in: allowedCharacters)
        if !unwantedCharacters.isEmpty { return false }
        
        return true
    }
    
}

public class OnlyNumbersValidator: Validator {
    
    public private(set) var message: String
    
    public init(message: String = "Bu alan sadece rakamlardan oluşmalıdır.".localized) {
        self.message = message
    }
    
    public func validate(with text: String?) -> Bool {
        let unwantedCharacters = text!.trimmingCharacters(in: CharacterSet.decimalDigits)
        if !unwantedCharacters.isEmpty { return false }
        
        return true
    }
}

public class RegexValidator: Validator {
    
    private var initialMessage: String?
    
    public var message: String {
        return initialMessage ?? "Lütfen geçerli bir %@ girin.".localized(placeholder)
    }
    
    public var regex: String
    public var placeholder: String

    public init(regex: String, placeholder: String, message: String? = nil) {
        self.regex = regex
        self.placeholder = placeholder
        self.initialMessage = message
    }
    
    public func validate(with value: String?) -> Bool {
        if let value = value, !value.isEmpty,
            !BaseValidator.regex(regex, input: value) {
            return false
        }
        return true
    }
    
}

public class TransactionDayValidator: Validator {
    
    public private(set) var message: String
    public private(set) var firstCharacter: Character?
    
    public init(message: String, firstCharacter: Character?) {
        self.message = message
        self.firstCharacter = firstCharacter
    }
    
    public func validate(with text: String?) -> Bool {
        var text = text?.getNumbers
        if let char = text?.first, firstCharacter == char && (text?.count ?? 0) > 1 {
            text?.removeFirst()
        }
        if (text ?? "").intValue > 31 || (text ?? "").intValue < 1 {
            return false
        }
        return true
    }
}

public class ConsecutiveNumbersValidator: Validator {
    
    public private(set) var message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public func validate(with text: String?) -> Bool {
        guard let text = text else { return false }
        let consecutiveCandidates: [Int] = text.map { Int($0.description) }.compactMap({ $0 })
        let mappedCandidates: [Int] = consecutiveCandidates.map { $0 - 1 }
        let isConsecutive: Bool = mappedCandidates.dropFirst() == consecutiveCandidates.dropLast() ||
            mappedCandidates.dropLast() == consecutiveCandidates.dropFirst()
        return isConsecutive
    }
}

public class FunctionValidator: Validator {
    
    public private(set) var message: String
    public private(set) var function: () -> Bool
    
    public init(message: String, function: @escaping () -> Bool) {
        self.message = message
        self.function = function
    }
    
    public func validate() -> Bool {
        return function()
    }
}

public class ExpectedValueValidator: Validator {
    
    public private(set) var message: String
    public private(set) var expectedValue: String
    
    public init(expectedValue: String, message: String) {
        self.message = message
        self.expectedValue = expectedValue
    }
    
    public func validate(with value: String) -> Bool {
        let trimmedValue = value.trimWhitespaces
        if trimmedValue.isEmpty {
            return false
        }
        
        if trimmedValue == expectedValue {
            return true
        }
        
        return false
    }
    
}
public class PlateValidator: Validator {
    
    public private(set) var message: String
    
    public init(message: String = "Lütfen geçerli bir plaka girin.".localized) {
        self.message = message
    }
    
    public func validate(with text: String?) -> Bool {
        guard let text = text else { return false }
        if let cityCode = Int(text.prefix(2)), cityCode < 82 {
            return true
        }
        return false
    }
}
