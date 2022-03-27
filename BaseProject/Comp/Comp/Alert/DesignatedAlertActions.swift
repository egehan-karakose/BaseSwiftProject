//
//  DesignatedAlertActions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public enum DesignatedAlertActions {
    
    case doneAction
    case doneActionWithHandler(_ handler: VoidHandler?)
    case approveAction
    case approveActionWithHandler(_ handler: VoidHandler?)
    case shareAction
    case shareActionWithHandler(_ handler: VoidHandler?)
    case quitAction
    case quitActionWithHandler(_ handler: VoidHandler?)
    case cancelAction

    
    
    public var action: AlertAction {
        switch self {
        case .doneAction:
            return AlertAction(title: "TAMAM".localized, style: .default)
        case .doneActionWithHandler(let handler):
            return AlertAction(title: "TAMAM".localized, style: .default, handler: handler)
        case .approveAction:
            return AlertAction(title: "Onay".localized, style: .default)
        case .approveActionWithHandler(let handler):
            return AlertAction(title: "Onay".localized, style: .default, handler: handler)
        case .shareAction:
            return AlertAction(title: "Paylaş".localized, style: .default)
        case .shareActionWithHandler(let handler):
            return AlertAction(title: "Paylaş".localized, style: .default, handler: handler)
        case .quitAction:
            return AlertAction(title: "Vazgeç".localized, style: .cancel)
        case .quitActionWithHandler(let handler):
            return AlertAction(title: "Vazgeç".localized, style: .cancel, handler: handler)
        case .cancelAction:
            return AlertAction(title: "İptal".localized, style: .cancel)
        }
    }
    
}
