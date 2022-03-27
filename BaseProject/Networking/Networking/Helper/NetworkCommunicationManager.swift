//
//  NetworkCommunicationManager.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public class NetworkCommunicationManager {
    
    public static let shared = NetworkCommunicationManager()
    
    private init() {}
    
    public var logout: VoidHandler?
}

