//
//  Image+Extension.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import UIKit

public extension UIImage {
    
    func resized(toWidth width: CGFloat, shouldConglobate: Bool = false) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        if shouldConglobate {
            UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height), cornerRadius: width/2).addClip()
        }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func blackAndWhiteImage(radians: CGFloat = .pi / 2) -> UIImage? {
        guard let currentCGImage = self.cgImage else { return nil }
        
        let currentCIImage = CIImage(cgImage: currentCGImage)
        let filter = CIFilter(name: "CIColorMonochrome")
        
        filter?.setValue(currentCIImage, forKey: "inputImage")
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")
        
        guard let outputImage = filter?.outputImage else { return nil }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            print(processedImage.size)
            return processedImage.rotate(radians: radians)
        }
        return nil
    }
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    
    func cropToBounds(rect: CGRect) -> UIImage? {
        guard let cgimage = self.cgImage else { return nil }

        if let imageRef = cgimage.cropping(to: rect) {
            return UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        }

        return nil
    }
    
}
