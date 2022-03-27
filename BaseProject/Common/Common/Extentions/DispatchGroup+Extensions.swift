//
//  DispatchGroup+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation
public extension DispatchGroup {
    
    func executeRequest(_ executables: ((@escaping (Decodable) -> Void) -> Void)..., completion:  @escaping ([Decodable]) -> Void) {
        var items: [Decodable] = []
        for executable in executables {
            self.enter()
            executable({ item in
                items.append(item)
                self.leave()
            })
        }
        self.notify(queue: .main) {
            completion(items)
        }
    }
    
    func executeCompletables(_ executables: [((@escaping VoidHandler) -> Void)], completion:  @escaping VoidHandler) {
        for executable in executables {
            self.enter()
            executable({
                self.leave()
            })
        }
        self.notify(queue: .main) {
            completion()
        }
    }
    
}
