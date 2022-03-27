//
//  UIImageViewHelper.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public protocol ImageLoader {
    func load(with url: String?,
              errorImage: UIImage?,
              placeholder: UIImage?,
              cache: URLCache?,
              ignoreCache: Bool,
              loadCompletion: @escaping (UIImage?) -> Void)
}

public class UIImageViewHelper {
    public var imageLoader: ImageLoader?
    
    private init() {}
    
    public static let shared = UIImageViewHelper()
}
