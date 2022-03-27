//
//  AlertViewModels.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

//FIXME: AlertManager içindeki style'ları protocol üzerinden model ile yürütebiliriz?
public protocol BaseAlertViewModelProtocol {
    var title: String? { get }
    var message: String? { get }
    var topIcon: AlertIcon? { get }
    var shouldDismissWhenTappedAround: Bool { get }
    var actions: [AlertAction]? { get }
}

public protocol CustomAlertViewModelProtocol: BaseAlertViewModelProtocol {
    var customView: UIView? { get }
    var align: NSTextAlignment? { get }
    var attributedMessage: NSAttributedString? { get }
}

public struct CustomAlertViewModel: CustomAlertViewModelProtocol {
    public var align: NSTextAlignment?
    public var title: String?
    public var message: String?
    public var attributedMessage: NSAttributedString?
    public var topIcon: AlertIcon?
    public var shouldDismissWhenTappedAround: Bool = false
    public var actions: [AlertAction]?
    public var customView: UIView?
    
    public init() {}
    
}
