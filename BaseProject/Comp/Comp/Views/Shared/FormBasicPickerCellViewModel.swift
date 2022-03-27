//
//  FormBasicPickerCellViewModel.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

open class FormBasicPickerCellViewModel: CellViewModel, FormBasicPickerCellViewModelProtocol, KeyValueProtocol {
    public var accessoryImage: UIImage?
    public var seperatorVisible: Bool? = true
    public var lineVisible: Bool? = true
    public var enumValue: Any?
    public var title: String
    public var key: String?
    public var isEnabled: Bool = true
    public var shouldUpdateTableViw = true
    public var isTitleHidden: Bool?
    public var titleColor: UIColor?
    public var valueColor: UIColor?
    public var valueText: String? {
        didSet {
            if valueText != oldValue {
                shouldUpdateTableViw = true
            }
            errorText = nil
        }
    }
    
    public var errorText: String? {
        didSet {
            if errorText != oldValue {
                shouldUpdateTableViw = true
            }
        }
    }
    
    public init(with title: String) {
        self.title = title
        super.init()
    }
    
    public func getKeyValueParameter() -> KeyValueModelForCells {
        return KeyValueModelForCells(key: key, value: enumValue as? String)
    }
    
}

extension FormBasicPickerCellViewModel: ParameterConvertible {
    
    public var parameterValue: Any? {
        return enumValue
    }
    
}

extension FormBasicPickerCellViewModel: Validatable {
    
    public func validate(with validators: [Validator], setErrorText: Bool) -> Bool {
        for validator in validators {
            if let requiredValidator = validator as? RequiredValidator {
                if valueText == nil || valueText == "Seçiniz".localized {
                    if setErrorText {
                        errorText = requiredValidator.message == RequiredValidator.defaultMessage ?
                            "Lütfen seçim yapın".localized : requiredValidator.message
                    }
                    return false
                }
            } else if let expectedValueValidator = validator as? ExpectedValueValidator, let valueText = valueText {
                if expectedValueValidator.validate(with: valueText) == false {
                    if setErrorText {
                        errorText = expectedValueValidator.message
                    }
                    return false
                }
            } else if let functionValidator = validator as? FunctionValidator {
                guard functionValidator.function() == true else {
                    errorText = functionValidator.message
                    return false
                }
            }
        }
        return true
    }
    
    public func clearValidationState() {
        errorText = nil
    }
    
}
