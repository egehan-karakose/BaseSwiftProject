//
//  AlertManager.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Common
import PKHUD

// swiftlint:disable function_parameter_count

public var publicResponder: UIViewController!


public enum AlertIcon: Equatable {
    case successIcon
    case warningIcon
    case emptySuccessIcon
    case infoIcon
	case custom(imageName: String)
    case largeIcon(image: UIImage)
    
	var iconImage: UIImage? {
		switch self {
		case .successIcon:
			return UIImage(named: "doneIcon")
		case .warningIcon:
			return UIImage(named: "warning")
		case .emptySuccessIcon:
            return UIImage(named: "successIcon")
        case .infoIcon:
            return UIImage(named: "ic_info")
        case .custom(let imageName):
            return UIImage(named: imageName)
        case .largeIcon(let image):
            return image
        }
	}
}

public enum AlertStyle {
    //swiftlint:disable line_length
    case style1(title: String?, message: String?, topIcon: AlertIcon?, shouldDismissWhenTappedAround: Bool, actions: [AlertAction]?)
    case style2(title: String?, placeHolder: String?, initialText: String?, isEnabled: Bool, maxLength: Int, acceptables: CharacterSet?, keyboardType: UIKeyboardType?, cancelButtonTitle: String?, approveButtonTitle: String?, shouldDismissWhenTappedAround: Bool, dismissHandler: (String?) -> Void, minLength: Int?)
    case neverDismiss(title: String?, message: String?, topIcon: AlertIcon?, shouldDismissWhenTappedAround: Bool, actions: [AlertAction]?)
    case custom(viewModel: CustomAlertViewModelProtocol)

}

open class AlertAction {
    public enum Style: Int {
        case `default`
        case cancel
        case destructive
    }
    
    open var title: String?
    open var style: AlertAction.Style = .default
    open var handler: VoidHandler?
    
    public init(title: String?, style: AlertAction.Style = .default, handler: VoidHandler? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

public func showAlertForTelephoneBanking(message: String?, phoneNumber: String?) {
    guard let phoneNumber = phoneNumber else { return }
    let cancelAction = AlertAction(title: "VAZGEÇ".localized, style: .cancel) {
        dismissAlert()
    }
    let callAction = AlertAction(title: "ÇAĞRI MERKEZİNİ ARA".localized, style: .default) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    showAlert(withTitle: "Hata".localized, message: message, actions: [ cancelAction, callAction ])
}

public func showAlert(withMessage message: String?, buttonTitle: String = "DEVAM".localized, handler: VoidHandler?) {
    let action = AlertAction(title: buttonTitle, style: .default, handler: handler)
    showAlert(withTitle: "Hata".localized, message: message, shouldDismissWhenTappedAround: false, actions: [action])
}

public func showAlertWithDefaultAction(withTitle title: String?, message: String?) {
    let doneAction = DesignatedAlertActions.doneAction.action
    showAlert(withTitle: title, message: message, shouldDismissWhenTappedAround: false, actions: [doneAction])
}

public func showAlert(message: String?, topIcon: AlertIcon, shouldDismissWhenTappedAround: Bool? = nil, actions: [AlertAction]? = nil, didDismiss: VoidHandler? = nil) {
    showAlert(withTitle: nil, message: message, topIcon: topIcon, shouldDismissWhenTappedAround: shouldDismissWhenTappedAround, actions: actions, didDismiss: didDismiss)
    
}

public func showAlert(withTitle title: String?, message: String?, topIcon: AlertIcon? = nil, shouldDismissWhenTappedAround: Bool? = nil, actions: [AlertAction]? = nil, didDismiss: VoidHandler? = nil) {
    func operation() {
        var dismissWhenTappedAround: Bool = true
        if let receivedShouldDismissWhenTappedAround = shouldDismissWhenTappedAround {
            dismissWhenTappedAround = receivedShouldDismissWhenTappedAround
        }
        if let receivedActions = actions, !receivedActions.isEmpty {
            dismissWhenTappedAround = false
            //iş birimi talebi ile yapıldı. buton varken boşlukta kapanma talep edilirse TND-5246
            // bu talep kapsamında yapıldığını iletiriz.
        }
        
        var titleTmp: String? = title
        var topAlertIcon: AlertIcon? = topIcon
        if let title = title, title == "Hata".localized {
            topAlertIcon = AlertIcon.warningIcon
            titleTmp = nil
        }
        
        UIAccessibility.post(notification: .announcement, argument: "\(title.withDefault("")), \(message.withDefault(""))")
        AlertManager().showAlertViewWith(style: .style1(title: titleTmp, message: message, topIcon: topAlertIcon, shouldDismissWhenTappedAround: dismissWhenTappedAround, actions: actions), didDismiss: didDismiss)
    }
    if Thread.isMainThread {
        operation()
    } else {
        DispatchQueue.main.async {
            operation()
        }
    }
    
}

public func showNeverDismissAlert(withTitle title: String?, message: String?, topIcon: AlertIcon? = nil, shouldDismissWhenTappedAround: Bool? = nil, actions: [AlertAction]? = nil, didDismiss: VoidHandler? = nil) {
    func operation() {
        var dismissWhenTappedAround: Bool = true
        if let receivedActions = actions, receivedActions.count > 1 {
            dismissWhenTappedAround = false
        }
        if let receivedShouldDismissWhenTappedAround = shouldDismissWhenTappedAround {
            dismissWhenTappedAround = receivedShouldDismissWhenTappedAround
        }
        AlertManager().showAlertViewWith(style: .neverDismiss(title: title, message: message, topIcon: topIcon, shouldDismissWhenTappedAround: dismissWhenTappedAround, actions: actions), didDismiss: didDismiss)
    }
    if Thread.isMainThread {
        operation()
    } else {
        DispatchQueue.main.async {
            operation()
        }
    }
}

public func showAlert(withTextInput title: String?, placeHolder: String?, initialText: String? = nil, isEnabled: Bool = true, maxLength: Int, acceptables: CharacterSet?, keyboardType: UIKeyboardType?, cancelButtonTitle: String?, approveButtonTitle: String?, dismissHandler: @escaping (String?) -> Void, minLength: Int = 0, didDismiss: VoidHandler? = nil) {
    func operation() {
        AlertManager().showAlertViewWith(style: .style2(title: title, placeHolder: placeHolder, initialText: initialText, isEnabled: isEnabled, maxLength: maxLength, acceptables: acceptables, keyboardType: keyboardType, cancelButtonTitle: cancelButtonTitle, approveButtonTitle: approveButtonTitle, shouldDismissWhenTappedAround: false, dismissHandler: dismissHandler, minLength: minLength), didDismiss: didDismiss)
    }
    if Thread.isMainThread {
        operation()
    } else {
        DispatchQueue.main.async {
            operation()
        }
    }
}

public func showAlert(withCustom viewModel: CustomAlertViewModelProtocol) {
    func operation() {
        AlertManager().showAlertViewWith(style: .custom(viewModel: viewModel), didDismiss: nil)
    }
    if Thread.isMainThread {
        operation()
    } else {
        DispatchQueue.main.async {
            operation()
        }
    }
}

public func dismissAlert() {
    DispatchQueue.main.async {
        AlertManager().dismissAlert()
    }
}

public class AlertManager {
    
    public init() { }
    
    public class func getRootViewController() -> UIViewController! {
        if let receivedPublicResponder = publicResponder {
            return receivedPublicResponder
        } else {
            guard let appDelegateWindow = UIApplication.shared.delegate?.window,
                let window = appDelegateWindow,
                let rootViewController = window.rootViewController else { return nil }
            var topController: UIViewController!
            if let presentedController = rootViewController.presentedViewController {
                topController = presentedController
            } else {
                topController = rootViewController
            }
            
            guard let tapBar = topController as? UITabBarController, let selectedViewController = tapBar.selectedViewController else {
                if let presentedController = topController?.presentedViewController {
                    if presentedController.view.isHidden && !presentedController.view.isOpaque {
                        return topController
                    }
                    return presentedController
                }
                return topController
            }
            
            topController = selectedViewController
            
            if topController.presentedViewController != nil {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
            } else {
                topController = tapBar
            }
            
            return topController
        }
    }
    
    public class func getIndTabbarViewController() -> UIViewController? {
        let rootViewController = getRootViewController()
        
        guard let baseNavigationController = rootViewController as? UINavigationController,
              !baseNavigationController.viewControllers.isEmpty else { return nil }
        
        return baseNavigationController.viewControllers[0]
    }
    
    public class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    private class func getAlertHolderView() -> AlertHolderView! {
        guard let currentViewController = getRootViewController(),
            let view = currentViewController.view,
            let alertHolderView = view.subviews.filter({ $0.isKind(of: AlertHolderView.self) }).first as? AlertHolderView else { return nil }
        return alertHolderView
    }
    
    public func showAlertViewWith(style: AlertStyle, completion: ((AlertView?) -> Void)? = nil, didDismiss: VoidHandler? = nil) {
        HUD.hide()
        var delay: Double = 0.0
        var alertHolderView: AlertHolderView!
        if let currentAlertHolderView = AlertManager.getAlertHolderView() {
            alertHolderView = currentAlertHolderView
            delay = 0.4
        } else {
            guard let currentControllerView = AlertManager.getRootViewController().view else { return }
            let newAlertHolderView = AlertHolderView()
            let lastSubView = currentControllerView.subviews.last
            newAlertHolderView.fitInto(view: currentControllerView)
            if let receivedLastSubView = lastSubView {
                newAlertHolderView.bringSubviewToFront(receivedLastSubView)
            }
            alertHolderView = newAlertHolderView
        }
        alertHolderView.accessibilityViewIsModal = true
        alertHolderView?.showAlertWith(style: style, completion: completion, didDismiss: didDismiss, delay: delay)
    }
    
    func dismissAlert() {
        guard let alertHolderView = AlertManager.getAlertHolderView() else { return }
        alertHolderView.dismissAlert()
    }
    
}
