//
//  FormTextField.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

// swiftlint:disable file_length
public protocol FormTextFieldViewModelEventSource {
    var textChangedHandler: ((_ newValue: String?) -> Void)? { get }
    var endEditHandler: VoidHandler? { get }
    var beginEditHandler: VoidHandler? { get }
}

public protocol FormTextFieldViewModelDataSource {
    
    var isEnabled: Bool { get set }
    var text: String? { get set}
    var placeholder: String? { get }
    var accesibilityPlaceholder: String? { get }
    var maskString: String? { get }
    var canDeleteMaskPrefix: Bool { get }
    var keyboardType: UIKeyboardType? { get }
    var isSecureTextEntry: Bool { get }
    var maxLength: Int { get }
    var descriptionText: String? { get }
    var errorText: String? { get set }
    var accessoryView: UIView? { get }
    var allowedCharacters: CharacterSet? { get }
    var contentType: UITextContentType? { get }
    var autoCorrectionType: UITextAutocorrectionType? { get }
    var seperatorVisible: Bool? { get }
    var disabledFont: UIFont? { get set }
    var disabledTextColor: UIColor? { get set }
    var autocapitalizationType: UITextAutocapitalizationType? { get set }
    var shouldChangeCharacters: ((_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool)? { get }
    var becomeFirstResponder: Bool? { get set }
    
    var shouldChangeCharactersAndParent: ((_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> String)? { get }
}

public protocol FormTextFieldViewModelProtocol: FormTextFieldViewModelDataSource, FormTextFieldViewModelEventSource {
    
}

public class FormTextField: UIView {
    
    @IBOutlet private weak var verticalStackView: UIStackView!
    @IBOutlet private weak var accessoryStackView: UIStackView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: JMMaskTextField!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var textFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var verticalStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var verticalStackViewBottomConstraint: NSLayoutConstraint!
    
    private var innerViewModel = FormTextFieldInnerViewModel()
    private var viewModel: FormTextFieldViewModelProtocol?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    public func populate(with viewModel: FormTextFieldViewModelProtocol) {
        self.viewModel = viewModel
        innerViewModel.text = viewModel.text
        innerViewModel.placeholder = viewModel.placeholder
        if let accesibility = viewModel.accesibilityPlaceholder, !accesibility.isEmpty {
            innerViewModel.accesibilityPlaceholder = accesibility
        } else {
            innerViewModel.accesibilityPlaceholder = viewModel.placeholder?.accesibilityString
        }
        innerViewModel.maskString = viewModel.maskString
        innerViewModel.canDeleteMaskPrefix = viewModel.canDeleteMaskPrefix
        innerViewModel.keyboardType = viewModel.keyboardType
        innerViewModel.isSecureTextEntry = viewModel.isSecureTextEntry
        innerViewModel.maxLength = viewModel.maxLength
        innerViewModel.descriptionText = viewModel.descriptionText
        innerViewModel.errorText = viewModel.errorText
        innerViewModel.accessoryView = viewModel.accessoryView
        innerViewModel.allowedCharacters = viewModel.allowedCharacters
        innerViewModel.contentType = viewModel.contentType
        innerViewModel.autoCorrectionType = viewModel.autoCorrectionType
        innerViewModel.disabledFont = viewModel.disabledFont
        innerViewModel.disabledTextColor = viewModel.disabledTextColor
        innerViewModel.autocapitalizationType = viewModel.autocapitalizationType
        textField.isEnabled = viewModel.isEnabled
        
        if viewModel.becomeFirstResponder ?? false {
            textField.becomeFirstResponder()
        }
        populateInner(with: innerViewModel)
    }
    
    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        titleLabel.addGestureRecognizer(tapGestureRecognizer)
        titleLabel.isUserInteractionEnabled = true
        titleLabel.textColor = .appGray
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        textField.tintColor = .appOrange
        textField.textColor = .appBlack2
        populateInner(with: innerViewModel)
    }
    
    @objc func handleTap(_ sender: Any?) {
        if viewModel?.isEnabled != false {
            innerViewModel.viewState = .editing
        }
        textField.becomeFirstResponder()
    }
    
    @objc func textChanged(_ sender: Any?) {
        let newValue = textField.text
        innerViewModel.text = newValue
        viewModel?.text = newValue
        viewModel?.textChangedHandler?(newValue)
    }
    
    private func populateInner(with viewModel: FormTextFieldInnerViewModel) {
        
        if innerViewModel.shouldUpdateTableViw {
            beginUpdatesIfAvailable()
        }
        
        self.innerViewModel = viewModel
        titleLabel.font = viewModel.titleLabelFont
        titleLabel.text = viewModel.placeholder
        titleLabel.accessibilityLabel = viewModel.accesibilityPlaceholder
        titleLabel.textColor = viewModel.titleLabelColor
        
        if let autoCorrectionType = viewModel.autoCorrectionType {
            textField.autocorrectionType = autoCorrectionType
        }
        textField.isHiddenInStackView = !viewModel.isTextFieldVisible
        textField.alpha = viewModel.isTextFieldVisible ? 1 : 0
        textField.isSecureTextEntry = viewModel.isSecureTextEntry
        textField.keyboardType = viewModel.keyboardType ?? .asciiCapable
        if textField.text != viewModel.text {
            textField.text = viewModel.text
        }
        
        textField.maskString = viewModel.maskString
        textField.canDeletePrefix = viewModel.canDeleteMaskPrefix

        if textField.isEnabled == true {
            textField.textColor = UIColor.appBlack2
        } else {
            if viewModel.disabledFont != nil {
                textField.font = viewModel.disabledFont
            }
            if viewModel.disabledTextColor != nil {
                textField.textColor = viewModel.disabledTextColor
            } else {
                textField.textColor = UIColor.appGray
            }
        }
        if let autocapitalizationType = viewModel.autocapitalizationType {
            textField.autocapitalizationType = autocapitalizationType
        }
        verticalStackViewTopConstraint.constant = viewModel.isTextFieldVisible ? 0 : 18
        
        if #available(iOS 11.0, *) {
            let spacing: CGFloat = viewModel.isTextFieldVisible ? 4 : 7
            verticalStackView.setCustomSpacing(spacing, after: titleLabel)
            verticalStackView.setCustomSpacing(7, after: textField)
        }
        
        for subview in accessoryStackView.subviews {
            subview.removeFromSuperview()
        }
        
        if let accessoryView = viewModel.accessoryView {
            accessoryStackView.addArrangedSubview(accessoryView)
            accessoryView.setNeedsLayout()
            accessoryView.layoutIfNeeded()
            textFieldTrailingConstraint.constant = accessoryStackView.frame.width + 10
        } else {
            textFieldTrailingConstraint.constant = 0
        }
        
        lineView.backgroundColor = viewModel.lineViewBackgroundColor
        descriptionLabel.textColor = viewModel.descriptionLabelTextColor
        descriptionLabel.isHiddenInStackView = !viewModel.isDescriptionLabelVisible
        descriptionLabel.alpha = viewModel.isDescriptionLabelVisible ? 1 : 0
        descriptionLabel.text = viewModel.descriptionLabelText
        
        verticalStackViewBottomConstraint.constant = viewModel.isDescriptionLabelVisible ? 3 : 0
        
        if innerViewModel.shouldUpdateTableViw {
            endUpdatesIfAvailable()
        }
        
        innerViewModel.shouldUpdateTableViw = false
    }
    
    private func beginUpdatesIfAvailable() {
        guard let controller = findViewController() as? CustomTableViewController else { return }
        guard let tableView = controller.tableView else { return }
        tableView.beginUpdates()
    }
    
    private func endUpdatesIfAvailable() {
        guard let controller = findViewController() as? CustomTableViewController else { return }
        guard let tableView = controller.tableView else { return }
        layoutIfNeeded()
        tableView.endUpdates()
    }
    
    public func setTag(tag: Int) {
        textField.tag = tag
    }
    
    public func addToolBar() {
        textField.addToolBar()
    }
}

extension FormTextField: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let formController = findViewController() as? FormController,
            let viewToFocus = formController.nextAvailableViewToFocus() else {
            textField.resignFirstResponder()
            return true
        }
        viewToFocus.becomeFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        innerViewModel.viewState = .editing
        innerViewModel.errorText = nil
        viewModel?.errorText = nil
        populateInner(with: innerViewModel)
        
        if let beginEdit = viewModel?.beginEditHandler {
            beginEdit()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        innerViewModel.viewState = .empty
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
        populateInner(with: innerViewModel)
        validateRowIfAvailable()
        
        if let endEdit = viewModel?.endEditHandler {
            endEdit()
        }
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        if !string.isEmpty && string.replacingInverted(of: innerViewModel.allowedCharacters, with: "").isEmpty {
            return false
        }
        
        if let shouldChangeCharacters = viewModel?.shouldChangeCharacters {
            return shouldChangeCharacters(textField, range, string)
        }
        
        let oldText = textField.text as NSString?
        var newText = oldText?.replacingCharacters(in: range, with: string)
        
        if let shouldChangeCharacters = viewModel?.shouldChangeCharactersAndParent {
            newText = shouldChangeCharacters(textField, range, string)
        }

        // remove unwanted characters
        newText = newText?.replacingInverted(of: innerViewModel.allowedCharacters, with: "")
        
        // check length
        if (newText?.count ?? 0) > innerViewModel.maxLength &&
            ((oldText?.length ?? 0) <= innerViewModel.maxLength || (innerViewModel.maskString ?? "").isEmpty == false || string == " " ) {
            newText = String(newText?.prefix(innerViewModel.maxLength) ?? "")
            
            if (innerViewModel.maskString ?? "").isEmpty == true && string.count == 1 && (oldText?.length ?? 0) <= innerViewModel.maxLength {
                return false
            } else if (oldText?.length ?? 0) > innerViewModel.maxLength && string == " " {
                textField.sanitizeText(newText, replacement: string)
                return false
                // bu kısım önerilen text seçilince ios 12 de sorun oluyor. string == " " bu kontrol hep onun için
            }
        }
        
        // apply mask
        if let maskString = viewModel?.maskString {
            let mask = JMStringMask(mask: maskString)
            newText = mask.mask(string: newText) ?? newText
        }
        if string.count > 1 {
            textField.sanitizeText(newText, replacement: string)
            return false
        }
        
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.addToolBar()
        return true
    }
    
}

extension FormTextField {
    
    func validateRowIfAvailable() {
        guard let controller = findViewController() as? FormController else { return }
        guard let cell = findSuperview(of: UITableViewCell.self) else { return }
        guard let indexPath = controller.tableView.indexPathForRow(at: cell.center) else { return }
        guard let row = controller.rowAtIndexPath(indexPath: indexPath) else { return }
        if row.validate() == false {
            row.validationStateChanged()
        }
    }
    
}

extension FormTextField {
    
    private enum FormViewState {
        case editing
        case error
        case empty
        case filled
    }

    private class FormTextFieldInnerViewModel {
        
        // MARK: Public
        var shouldUpdateTableViw = true
        
        var text: String?
        var placeholder: String?
        var accesibilityPlaceholder: String?
        var maskString: String?
        var canDeleteMaskPrefix: Bool = false
        var keyboardType: UIKeyboardType?
        var isSecureTextEntry: Bool = false
        var maxLength: Int = 10000
        var autoCorrectionType: UITextAutocorrectionType?
        var disabledFont: UIFont?
        var disabledTextColor: UIColor?
        var autocapitalizationType: UITextAutocapitalizationType?
        var descriptionText: String? {
            didSet {
                if descriptionText != oldValue {
                    shouldUpdateTableViw = true
                }
            }
        }
        var errorText: String? {
            didSet {
                if errorText != oldValue {
                    shouldUpdateTableViw = true
                }
            }
        }
        
        var accessoryView: UIView? {
            didSet {
                if accessoryView != oldValue {
                    shouldUpdateTableViw = true
                }
            }
        }
        
        var allowedCharacters: CharacterSet?
        var contentType: UITextContentType?
        
        // MARK: Internal
        
        var viewState: FormViewState = .empty {
            didSet {
                if viewState != oldValue {
                    shouldUpdateTableViw = true
                }
            }
        }
        
        var titleLabelFont: UIFont {
            if viewState == .editing { return .regular(of: 12) }
            return isTextEmpty ? .regular(of: 14) : .regular(of: 12)
        }
        
        var titleLabelColor: UIColor {
            if viewState == .editing { return .appOrange }
            if errorText != nil && !isTextEmpty { return .appRed }
            return .appGray
        }
        
        var isTextFieldVisible: Bool {
            if viewState == .editing { return true }
            return !isTextEmpty
        }
        
        var lineViewBackgroundColor: UIColor {
            if viewState == .editing { return .appOrange }
            if errorText != nil { return .appRed }
            return .appLightGray
        }
        
        var descriptionLabelTextColor: UIColor { // +
            if errorText != nil { return .appRed }
            if viewState == .error { return .appRed }
            return .appLightGray
        }
        
        var descriptionLabelText: String? { // +
            if errorText != nil { return errorText }
            if descriptionText != nil { return descriptionText }
            return nil
        }
        
        var isDescriptionLabelVisible: Bool { // +
            return descriptionLabelText != nil ? true : false
        }
        
        // MARK: Private
        
        private var isTextEmpty: Bool {
            return text == nil || text?.isEmpty == true
        }
        
    }
    
}

extension FormTextField: NibLoadable { }
// swiftlint:enable file_length
