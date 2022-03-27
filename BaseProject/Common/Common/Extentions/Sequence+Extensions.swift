//
//  Sequence+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

extension Sequence where Iterator.Element: Equatable {
    public func removeDuplicates() -> [Iterator.Element] {
        return reduce([], { collection, element in collection.contains(element) ? collection : collection + [element] })
    }
}
