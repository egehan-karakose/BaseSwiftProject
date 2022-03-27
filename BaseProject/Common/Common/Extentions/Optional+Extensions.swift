//
//  Optional+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    subscript(safe index: Wrapped.Index) -> Wrapped.Element? {
        guard let self = self else { return nil }
        return self[safe: index]
    }
}

//swiftlint:disable force_cast
public extension Optional {
    func withDefault<T>(_ defaultValue: T) -> T {
        switch self {
        case .none:
            return defaultValue
        case .some(let value):
            return value as! T
        }
    }
}
