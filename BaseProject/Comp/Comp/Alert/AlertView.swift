//
//  AlertView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Common

// swiftlint:disable line_length
// swiftlint:disable file_length

protocol AlertViewDelegate: class {
    func dismissAlert()
}

public class AlertView: UIView {
    
    weak var delegate: AlertViewDelegate!
    var selfYConstraint: NSLayoutConstraint!
    var shouldDismissWhenTappedAround: Bool = false
    var dontDismissOneTime: Bool = false
    var didDismissCallBack: VoidHandler?
    private var textField = FormTextField.loadFromNib()
    private var textFieldViewModel = FormTextFieldViewModel()
    private var validator: MinimumLengthValidator?
    private var inputDoneButton: UIButton!
    private var dismissActionHandler: VoidHandler!
    private var currentStyle: AlertStyle!
    private var messageLabel: UILabel?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(with style: AlertStyle) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 12.0
        clipsToBounds = true
        alpha = 0.0
        setupUI()
        setupContent(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        var screenWidth = UIScreen.main.bounds.size.width
        if screenWidth > 414.0 {
            screenWidth = 414.0
        }
        stackView.fitInto(view: self, paddings: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0))
        stackView.widthAnchor.constraint(equalToConstant: screenWidth - 64.0).isActive = true
        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0).isActive = true
        layoutIfNeeded()
    }
    
    // swiftlint:disable cyclomatic_complexity
    private func setupContent(style: AlertStyle) {
        switch style {
        case .style1(_, _, _, let shouldDismissWhenTappedAround, _):
            self.shouldDismissWhenTappedAround = shouldDismissWhenTappedAround
        case .style2(_, _, _, _, _, _, _, _, _, let shouldDismissWhenTappedAround, _, _):
            self.shouldDismissWhenTappedAround = shouldDismissWhenTappedAround
        case .neverDismiss(_, _, _, let shouldDismissWhenTappedAround, _):
            self.shouldDismissWhenTappedAround = shouldDismissWhenTappedAround
        case .custom(let viewModel):
            self.shouldDismissWhenTappedAround = viewModel.shouldDismissWhenTappedAround
        }
        currentStyle = style
        switch style {
        case .style1(let title, let message, let topIcon, _, let actions):
            var isLargeIcon = false
            if let receivedTopIcon = topIcon, let icon = receivedTopIcon.iconImage {
                isLargeIcon = receivedTopIcon == .largeIcon(image: icon)
                create(icon: icon, isLargeIcon: isLargeIcon)
            }
            if let receivedTitle = title {
                let nextLineAddition = (message == nil) ? "\n" : ""
                create(title: receivedTitle + nextLineAddition, isLargeIcon: isLargeIcon)
            }
            if let receivedMessage = message {
                let previousLineAddition = (title == nil ? "\n" : "")
                let nextLineAddition = "\n"
                create(message: previousLineAddition + receivedMessage + nextLineAddition)
            }
            if let receivedActions = actions {
                create(actions: receivedActions)
            } else {
                createDismissButton(handler: nil)
            }
        case .style2(let title, let placeHolder, let initialText, let isEnabled, let maxLength, let acceptables, let keyboardType, let cancelButtonTitle, let approveButtonTitle, _, let dismissHandler, let minLength):
            if let receivedTitle = title {
                create(title: receivedTitle)
            }
            createTextField(placeHolder: placeHolder, initialText: initialText, isEnabled: isEnabled, maxLength: maxLength, acceptables: acceptables, keyboardType: keyboardType, minLength: minLength)
            createInputButton(cancelTitle: cancelButtonTitle, approveTitle: approveButtonTitle, handler: dismissHandler, minLength: minLength)
            if let receivedInitialText = initialText, receivedInitialText.trimmingCharacters(in: .whitespacesAndNewlines) != "", let currentInputDoneButton = self.inputDoneButton {
                currentInputDoneButton.isEnabled = true
            }
        case .neverDismiss(let title, let message, let topIcon, _, let actions):
            if let receivedTopIcon = topIcon, let icon = receivedTopIcon.iconImage {
                create(icon: icon)
            }
            if let receivedTitle = title {
                let nextLineAddition = (message == nil) ? "\n" : ""
                create(title: receivedTitle + nextLineAddition)
            }
            if let receivedMessage = message {
                let nextLineAddition = "\n"
                create(message: receivedMessage + nextLineAddition)
            }
            if let receivedActions = actions {
                create(actions: receivedActions)
            } else {
                createDismissButton(handler: nil)
            }
        case .custom(let viewModel):
            createCustomView(viewModel: viewModel)
        }
    }
    // swiftlint:enable cyclomatic_complexity
    
    private func create(icon: UIImage, isLargeIcon: Bool = false) {
        let holderView = UIView()
        let imageView = UIImageView()
        let imageSize = isLargeIcon ? CGFloat(172.0) : CGFloat(72.0)
        imageView.contentMode = .scaleAspectFit
        imageView.image = icon
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: holderView.centerXAnchor, constant: 0.0).isActive = true
        let imageViewCenterYConstraint = imageView.centerYAnchor.constraint(equalTo: holderView.centerYAnchor, constant: 0.0)
        imageViewCenterYConstraint.priority = UILayoutPriority(rawValue: 999)
        imageViewCenterYConstraint.isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        let imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize)
        imageViewHeightConstraint.priority = UILayoutPriority(999)
        imageViewHeightConstraint.isActive = true
        imageView.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 24.0).isActive = true
        let imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: 0.0)
        imageViewBottomConstraint.priority = UILayoutPriority(999)
        imageViewBottomConstraint.isActive = true
        holderView.layoutIfNeeded()
        stackView.addArrangedSubview(holderView)
    }
    
    private func create(title: String, isLargeIcon: Bool = false) {
        let holderView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .textColor
        label.numberOfLines = 0
        label.text = title
        label.accessibilityLabel = title
        holderView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: holderView.centerXAnchor, constant: 0.0).isActive = true
        let labelCenterYConstraint = label.centerYAnchor.constraint(equalTo: holderView.centerYAnchor, constant: 0.0)
        labelCenterYConstraint.priority = UILayoutPriority(999)
        labelCenterYConstraint.isActive = true
        label.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 24.0).isActive = true
        let labelBottomConstraint = label.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -6.0)
        labelBottomConstraint.priority = UILayoutPriority(999)
        labelBottomConstraint.isActive = true
        label.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 0.0).isActive = true
        label.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: 0.0).isActive = true
        holderView.layoutIfNeeded()
        if !isLargeIcon {
            stackView.addArrangedSubview(holderView)
        } else {
            stackView.insertArrangedSubview(holderView, at: 0)
        }
       
    }
    
    private func create(message: String, attributedMessage: NSAttributedString? = nil , align: NSTextAlignment = .center) {
        let holderView = UIView()
        messageLabel = UILabel()
        messageLabel?.translatesAutoresizingMaskIntoConstraints = false
        messageLabel?.font = UIFont.systemFont(ofSize: 14.0)
        messageLabel?.textAlignment = align
        messageLabel?.lineBreakMode = .byWordWrapping
        messageLabel?.textColor = .descriptionTextColor
        messageLabel?.numberOfLines = 0
        if let attributedMessage = attributedMessage {
            messageLabel?.attributedText = attributedMessage
        } else {
            messageLabel?.text = message
        }
        messageLabel?.accessibilityLabel = message
        holderView.addSubview(messageLabel!)
        messageLabel?.centerXAnchor.constraint(equalTo: holderView.centerXAnchor, constant: 0.0).isActive = true
        let labelCenterYConstraint = messageLabel?.centerYAnchor.constraint(equalTo: holderView.centerYAnchor, constant: 0.0)
        labelCenterYConstraint?.priority = UILayoutPriority(999)
        labelCenterYConstraint?.isActive = true
        messageLabel?.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 6.0).isActive = true
        let labelBottomConstraint = messageLabel?.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -6.0)
        labelBottomConstraint?.priority = UILayoutPriority(999)
        labelBottomConstraint?.isActive = true
        messageLabel?.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 0.0).isActive = true
        messageLabel?.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: 0.0).isActive = true
        holderView.layoutIfNeeded()
        stackView.addArrangedSubview(holderView)
    }
    
    public func update(message: String?) {
        messageLabel?.text = message
    }
    
    private func create(actions: [AlertAction]) {
        let reOrderedActions = reOrderActionsByItsStyles(actions: actions)
        if reOrderedActions.isEmpty {
            createDismissButton(handler: nil)
        } else {
            let buttons = reOrderedActions.map({ createButtonBy(action: $0) })
            align(buttons: buttons)
        }
    }
    
    // swiftlint:disable function_body_length
    private func align(buttons: [UIButton]) {
        if buttons.count == 1 {
            let firstButton = buttons[0]
            let holderView = UIView()
            holderView.addSubview(firstButton)
            let holderViewHeightConstraint = holderView.heightAnchor.constraint(equalToConstant: 60.0)
            holderViewHeightConstraint.priority = UILayoutPriority(999)
            holderViewHeightConstraint.isActive = true
            firstButton.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 6.0).isActive = true
            let firstButtonBottomConstraint = firstButton.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -16.0)
            firstButtonBottomConstraint.priority = UILayoutPriority(999)
            firstButtonBottomConstraint.isActive = true
            firstButton.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 0.0).isActive = true
            firstButton.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: 0.0).isActive = true
            holderView.layoutIfNeeded()
            stackView.addArrangedSubview(holderView)
        } else if buttons.count == 2 {
            var firstButton = buttons[0]
            let secondButton = buttons[1]
            if firstButton.isKind(of: PrimaryButton.self) && secondButton.isKind(of: SecondaryButton.self) {
                if let primaryButton = firstButton as? PrimaryButton {
                    primaryButton.buttonText = primaryButton.buttonText.uppercased()
                    firstButton = primaryButton
                }
            }
            let holderView = UIView()
            holderView.addSubview(secondButton)
            holderView.addSubview(firstButton)
            let holderViewHeightConstraint = holderView.heightAnchor.constraint(equalToConstant: 60.0)
            holderViewHeightConstraint.priority = UILayoutPriority(999)
            holderViewHeightConstraint.isActive = true
            secondButton.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 6.0).isActive = true
            let secondButtonBottomConstraint = secondButton.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -16.0)
            secondButtonBottomConstraint.priority = UILayoutPriority(999)
            secondButtonBottomConstraint.isActive = true
            secondButton.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 0.0).isActive = true
            let secondButtonTrailingConstraint = secondButton.trailingAnchor.constraint(equalTo: holderView.centerXAnchor, constant: -6.0)
            secondButtonTrailingConstraint.priority = UILayoutPriority(999)
            secondButtonTrailingConstraint.isActive = true
            firstButton.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 6.0).isActive = true
            let firstButtonBottomConstraint = firstButton.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -16.0)
            firstButtonBottomConstraint.priority = UILayoutPriority(999)
            firstButtonBottomConstraint.isActive = true
            firstButton.leadingAnchor.constraint(equalTo: holderView.centerXAnchor, constant: 6.0).isActive = true
            let firstButtonTrailingAnchor = firstButton.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: 0.0)
            firstButtonTrailingAnchor.priority = UILayoutPriority(999)
            firstButtonTrailingAnchor.isActive = true
            holderView.layoutIfNeeded()
            stackView.addArrangedSubview(holderView)
        } else if buttons.count > 2 {
            let holderView = UIView()
            let holderViewHeightConstraint = holderView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0)
            holderViewHeightConstraint.priority = UILayoutPriority(999)
            holderViewHeightConstraint.isActive = true
            buttons.forEach { (button) in
                var previousButton: UIView!
                if !holderView.subviews.isEmpty {
                    previousButton = holderView.subviews.last
                }
                holderView.addSubview(button)
                if let currentPreviousButton = previousButton {
                    let buttonTopAnchor = button.topAnchor.constraint(equalTo: currentPreviousButton.bottomAnchor, constant: 10.0)
                    buttonTopAnchor.priority = UILayoutPriority(999)
                    buttonTopAnchor.isActive = true
                } else {
                    button.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 6.0).isActive = true
                }
                button.leadingAnchor.constraint(equalTo: holderView.leadingAnchor, constant: 0.0).isActive = true
                button.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: 0.0).isActive = true
            }
            if let lastButton = holderView.subviews.last {
                lastButton.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -16.0).isActive = true
            }
            holderView.layoutIfNeeded()
            stackView.addArrangedSubview(holderView)
        }
    }
    
    private func createCustomView(viewModel: CustomAlertViewModelProtocol) {
        if let icon = viewModel.topIcon, let iconImage = icon.iconImage {
            create(icon: iconImage)
        }
        if let receivedTitle = viewModel.title {
            create(title: receivedTitle)
        }
        if let receivedMessage = viewModel.message {
            if let align = viewModel.align {
                create(message: receivedMessage, align: align)
            } else {
                create(message: receivedMessage)
            }
        }
        if let attributedMessage = viewModel.attributedMessage {
            if let align = viewModel.align {
                create(message: "", attributedMessage: attributedMessage, align: align)
               
            } else {
                create(message: "", attributedMessage: attributedMessage)
            }
        }
        
        let holderView = UIView()
        viewModel.customView?.fitInto(view: holderView, paddings: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0))
        stackView.addArrangedSubview(holderView)
        
        if let receivedActions = viewModel.actions {
            create(actions: receivedActions)
        } else {
            createDismissButton(handler: nil)
        }
        
    }
    
    private func reOrderActionsByItsStyles(actions: [AlertAction]) -> [AlertAction] {
        var returnActions = actions
        if actions.count > 1 {
            let destructives = actions.filter({ $0.style == .destructive})
            let cancels = actions.filter({ $0.style == .cancel})
            let defaults = actions.filter({ $0.style == .default})
            returnActions = defaults + cancels + destructives
        }
        return returnActions
    }
    
    private func createButtonBy(action: AlertAction) -> UIButton {
        switch action.style {
        case .default:
            return createDefaultButtonBy(action: action)
        case .cancel:
            return createCancelButtonBy(action: action)
        case .destructive:
            return createDestructiveButtonBy(action: action)
        }
    }
    
    private func createDefaultButtonBy(action: AlertAction) -> UIButton {
        let primaryButton = PrimaryButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.buttonText = action.title ?? ""
        primaryButton.isEnabled = true
        primaryButton.buttonAction { [weak self] (_) in
            if let currentHandler = action.handler {
                currentHandler()
            }
            guard let self = self, let currentDelegate = self.delegate else { return }
            if self.dontDismissOneTime {
                self.endEditing(true)
                self.dontDismissOneTime = false
                return
            }
            if let receivedCurrentStyle = self.currentStyle {
                switch receivedCurrentStyle {
                case .style1:
                    currentDelegate.dismissAlert()
                case .style2:
                    currentDelegate.dismissAlert()
                case .neverDismiss, .custom:
                    break
                }
            }
            
        }
        return primaryButton
    }
    
    private func createCancelButtonBy(action: AlertAction) -> UIButton {
        let secondaryButton = SecondaryButton()
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.buttonText = action.title ?? ""
        secondaryButton.isEnabled = true
        secondaryButton.buttonAction { [weak self] (_) in
            if let currentHandler = action.handler {
                currentHandler()
            }
            guard let self = self, let currentDelegate = self.delegate else { return }
            currentDelegate.dismissAlert()
        }
        return secondaryButton
    }
    
    private func createDestructiveButtonBy(action: AlertAction) -> UIButton {
        let secondaryButton = SecondaryButton()
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.buttonColor = .appRed
        secondaryButton.buttonActiveColor = .appDarkRed
        secondaryButton.buttonText = action.title ?? ""
        secondaryButton.isEnabled = true
        secondaryButton.buttonAction { [weak self] (_) in
            if let currentHandler = action.handler {
                currentHandler()
            }
            guard let self = self, let currentDelegate = self.delegate else { return }
            currentDelegate.dismissAlert()
        }
        return secondaryButton
    }
    
    private func createTextField(placeHolder: String?, initialText: String?, isEnabled: Bool, maxLength: Int, acceptables: CharacterSet?, keyboardType: UIKeyboardType?, minLength: Int? = 0) {
        let holderView = UIView()
        if let minLength = minLength, minLength > 0 {
            let placeHolder = placeHolder.withDefault("Bu alan".localized).capitalizeFirst()
            let errorMessage = "%@ en az %@ karakter olmalıdır.".localized(placeHolder, minLength.string)
            validator = MinimumLengthValidator(length: minLength, message: errorMessage)
        }
        textFieldViewModel.isEnabled = isEnabled
        textFieldViewModel.text = initialText
        textFieldViewModel.placeholder = placeHolder
        textFieldViewModel.maxLength = maxLength
        textFieldViewModel.allowedCharacters = acceptables
        textFieldViewModel.keyboardType = keyboardType ?? .default
        textFieldViewModel.beginEditHandler = { [weak self] in
            self?.textFieldViewModel.errorText = ""
        }
        textFieldViewModel.endEditHandler = { [weak self] in
            self?.chechTextboxErrorState(validator: self?.validator)
            self?.textField.layoutIfNeeded()
            self?.layoutIfNeeded()
        }
        
        textField.populate(with: textFieldViewModel)
        textField.fitInto(view: holderView, paddings: UIEdgeInsets(top: 12.0, left: 0.0, bottom: 10.0, right: 0.0))
        stackView.addArrangedSubview(holderView)
    }
    
    private func createInputButton(cancelTitle: String?, approveTitle: String?, handler: @escaping (String?) -> Void, minLength: Int?) {
        let secondaryButtonAction = AlertAction(title: cancelTitle ?? "Vazgeç".localized, style: .cancel) { [weak self] in
            handler(nil)
            guard let self = self, let currentDelegate = self.delegate else { return }
            currentDelegate.dismissAlert()
        }
        let secondaryButton = createButtonBy(action: secondaryButtonAction)
        let primaryButtonAction = AlertAction(title: approveTitle ?? "ONAYLA".localized, style: .default) { [weak self] in
            guard let self = self else { return }
            if !self.chechTextboxErrorState(validator: self.validator) {
                self.dontDismissOneTime = true
                return
            }
            handler(self.textFieldViewModel.text)
            guard let currentDelegate = self.delegate else { return }
            currentDelegate.dismissAlert()
        }
        inputDoneButton = createButtonBy(action: primaryButtonAction)
        inputDoneButton.isEnabled = true
        align(buttons: [inputDoneButton, secondaryButton])
    }
    
    @discardableResult
    private func chechTextboxErrorState(validator: Validator?) -> Bool {
        if let validator = validator {
            let isValid = textFieldViewModel.validate(with: [validator], setErrorText: true)
            textField.populate(with: textFieldViewModel)
            if isValid {
                textFieldViewModel.clearValidationState()
                textField.populate(with: textFieldViewModel)
            }
            return isValid
        }
        return true
    }
    
    private func createDismissButton(handler: VoidHandler?) {
        dismissActionHandler = handler
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "dismissIcon"), for: .normal)
        button.accessibilityLabel = "Kapat".localized
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
        self.addSubview(button)
        button.topAnchor.constraint(equalTo: topAnchor, constant: 4.0).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        layoutIfNeeded()
    }
    
    @objc private func dismissButtonAction() {
        if let currentDelegate = self.delegate {
            currentDelegate.dismissAlert()
        }
        guard let currentDismissActionHandler = dismissActionHandler else { return }
        currentDismissActionHandler()
    }
    
    public func dismissFirstResponder() {
        if let receivedCurrentStyle = currentStyle {
            switch receivedCurrentStyle {
            case .style2:
                textField.resignFirstResponder()
            default:
                break
            }
        }
    }
    
}
