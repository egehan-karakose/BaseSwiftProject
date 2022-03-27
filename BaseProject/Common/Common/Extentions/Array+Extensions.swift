//
//  Array+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

public extension Optional where Wrapped: Collection {
    
    func hasElements() -> Bool {
        guard let self = self else { return false }
        return !self.isEmpty
    }
    
}

public extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueArray: [Element] = []
        forEach { item in
            if !uniqueArray.contains(where: { $0 == item }) {
                uniqueArray.append(item)
            }
        }
        return uniqueArray
    }
}

public extension Array {
    
    mutating func append(elements: Element...) {
        elements.forEach { (element) in
            append(element)
        }
    }
    
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
