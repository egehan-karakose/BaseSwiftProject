//
//  CustomFunctions.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//
import Foundation

infix operator <->

public func <-> <T>(lhs: Observable<T>?, rhs: @escaping Observer<T>) {
    lhs?.addObserver(observer: rhs)
}
