//
//  KeyValueProtocol.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public protocol KeyValueProtocol {
    func getKeyValueParameter() -> KeyValueModelForCells
}

public protocol KeyValueRowProtocol {
    var keyValueModel: KeyValueProtocol? { get set }
}

public struct KeyValueModelForCells {
    public var key: String?
    public var value: String?
    
    public init(key: String?, value: String?) {
        self.key = key
        self.value = value
    }
}
