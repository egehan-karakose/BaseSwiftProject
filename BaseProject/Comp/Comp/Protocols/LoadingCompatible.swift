//
//  LoadingCompatible.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public protocol LoadingCompatible {
    var loadingEnabled: Bool { get }
    var loading: Bool { get }
}
