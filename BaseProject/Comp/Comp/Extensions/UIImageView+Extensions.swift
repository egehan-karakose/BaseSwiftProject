//
//  UIImageView+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

// swiftlint:disable unused_closure_parameter
// swiftlint:disable line_length
public extension UIImageView {
    
    func load64(with base64: String) {
        if let decodedData = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
            let image = UIImage(data: decodedData) {
            self.transition(toImage: image)
        }
    }
    
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve],
                          animations: { [weak self] in
                            self?.image = image
                          },
                          completion: nil)
    }
    
    func setTint(color: UIColor, image: UIImage?) {
        self.image = image
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    public func startGif(resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else { return }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for index in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        self.animationImages = images
        self.startAnimating()
    }
    
    public func setGif(resourceName: String, repeatCount: Int? = nil, initialIsFirst: Bool = true) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else { return }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for index in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                if index == 0 && initialIsFirst {
                    self.image = UIImage(cgImage: image)
                } else if index == imageCount - 1 && !initialIsFirst {
                    self.image = UIImage(cgImage: image)
                }
                images.append(UIImage(cgImage: image))
            }
        }
        self.animationImages = images
        
        if let repeatCount = repeatCount {
            self.animationRepeatCount = repeatCount
        }
    }
}
