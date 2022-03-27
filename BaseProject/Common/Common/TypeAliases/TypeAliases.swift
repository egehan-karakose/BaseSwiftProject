//
//  TypeAliases.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public typealias Parameters = [String: Any]
// swiftlint:disable void_handler
public typealias VoidHandler = (() -> Void)
// swiftlint:enable void_handler

// swiftlint:disable bool_handler
public typealias BoolHandler = ((Bool) -> Void)
public typealias OptionalBoolHandler = ((Bool?) -> Void)
// swiftlint:enable bool_handler

public typealias ControllerHandler = ((UIViewController?) -> Void)

public typealias HandlerWithBoolHandler = ((@escaping BoolHandler) -> Void)
public typealias HandlerWithControllerHandler = ((@escaping ControllerHandler) -> Void)

public typealias StringHandler = ((String) -> Void)
public typealias OptionalStringHandler = ((String?) -> Void)
public typealias IntHandler = ((Int) -> Void)
public typealias DateHandler = ((_ newDate: Date?) -> Void)
public typealias ImageHandler = ((UIImage?) -> Void)
public typealias AlertActionHandler = (title: String, type: Int, handler: VoidHandler?)
public typealias AlertCarrier = (title: String?, message: String?, actions: [AlertActionHandler]?)
public typealias LocationAuthHandler = ((_ isEnabled: Bool, _ alertCarrier: AlertCarrier?) -> Void)
public typealias OptionalDictionaryHandler = ((_ deepLink: [String: String]?) -> Void)
public typealias UIViewControllerHandler = ((UIViewController) -> Void)
