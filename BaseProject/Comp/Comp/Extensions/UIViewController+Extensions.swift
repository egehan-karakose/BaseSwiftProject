//
//  UIViewController+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UIKit
import Common

public extension UIViewController {
    
    var controllerIdentifier: String? {
        let unprocessedControllerIdentifier = String(describing: self)
        guard let controllerIdentifier = unprocessedControllerIdentifier.removing(charactersOf: "<")
            .split(separator: ":").first else { return nil }
        let controllerIdentifierTypeName = String(controllerIdentifier)
        return controllerIdentifierTypeName.isEmpty ? nil :  controllerIdentifierTypeName
    }
    
    func showShareImageActivity(with image: UIImage, completion: VoidHandler? = nil) {
        if let dataImage = image.jpegData(compressionQuality: 0.8) {
            showShareActivity(with: [dataImage], completion: completion)
        } else {
            showShareActivity(with: [image], completion: completion)
        }
    }
    
    func showShareActivity(with items: [Any], completion: VoidHandler? = nil) {
        var sharingItems = [Any]()
        items.forEach({
            if $0 is String {
                sharingItems.append("\n\($0)")
            } else {
                sharingItems.append($0)
            }
        })
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionHandler = {
            (activity, success) in
            completion?()
        }
        if let presented = presentedViewController {
            presented.present(activityViewController, animated: true, completion: nil)
        } else {
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var isModal: Bool {
        // TODO: find a better way to determine if current viewcontroller is modally presented as popover
        if tabBarController != nil {
            return false
        }
        return UIScreen.main.bounds.height != view.bounds.height
    }
    
}

protocol ModallyPresentable {
    var isModallyPresented: Bool { get set }
}

extension UIViewController: ModallyPresentable {
    private static var _isModallyPresented = [String: Bool]()
    
    public var isModallyPresented: Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIViewController._isModallyPresented[tmpAddress] ?? false
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIViewController._isModallyPresented[tmpAddress] = newValue
        }
    }
    
    public func checkNavigationBarLayout() {
        if isModallyPresented, #available(iOS 13.0, *) {
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.setNeedsLayout()
            }
        }
    }
}
