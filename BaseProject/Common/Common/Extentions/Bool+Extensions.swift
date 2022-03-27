//
//  Bool+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

extension Bool {
    
    public var stringValue: String {
        return self == true ? "Evet".localized : "Hayır".localized
    }
    
}
