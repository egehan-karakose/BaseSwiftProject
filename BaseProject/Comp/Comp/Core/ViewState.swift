//
//  ViewState.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public enum ViewState {
    case normal
    case disabled
    case selected
    case error(message: String?)
}
