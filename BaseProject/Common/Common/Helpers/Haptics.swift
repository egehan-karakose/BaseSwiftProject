//
//  Haptics.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

// swiftlint:disable line_length

public class Haptics {
    
    public static let sharedInstance = Haptics()
    private init() {
        // Intentionally unimplemented...
    }
    
    private var impactFeedbackGeneratorTouchDown: Any! = {
        if #available(iOS 10.0, *) {
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedBackGenerator.prepare()
            return impactFeedBackGenerator
        } else {
            return nil
        }
    }()
    private var impactFeedbackGeneratorTouchUp: Any! = {
        if #available(iOS 10.0, *) {
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedBackGenerator.prepare()
            return impactFeedBackGenerator
        } else {
            return nil
        }
    }()
    private var notificationFeedbackGenerator: Any! = {
        if #available(iOS 10.0, *) {
            let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator.prepare()
            return notificationFeedbackGenerator
        } else {
            return nil
        }
    }()
    private var selectionFeedbackGenerator: Any! = {
        if #available(iOS 10.0, *) {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            return selectionFeedbackGenerator
        } else {
            return nil
        }
    }()
    
    public func makeKeyTouchDownImpact() {
        if let castedImpactFeedbackGenerator = self.impactFeedbackGeneratorTouchDown as? UIImpactFeedbackGenerator, #available(iOS 10.0, *) {
            castedImpactFeedbackGenerator.impactOccurred()
        }
    }
    
    public func makeKeyTouchupImpact() {
        if let castedImpactFeedbackGenerator = self.impactFeedbackGeneratorTouchUp as? UIImpactFeedbackGenerator, #available(iOS 10.0, *) {
            castedImpactFeedbackGenerator.impactOccurred()
        }
    }
    
    public func makeErrorImpact() {
        if let castedNotificationFeedbackGenerator = self.notificationFeedbackGenerator as? UINotificationFeedbackGenerator, #available(iOS 10.0, *) {
            castedNotificationFeedbackGenerator.notificationOccurred(.error)
        }
    }
    
    public func makeSelectionImpact() {
        if let castedSelectionFeedbackGenerator = self.selectionFeedbackGenerator as? UISelectionFeedbackGenerator, #available(iOS 10.0, *) {
            castedSelectionFeedbackGenerator.selectionChanged()
        }
    }
    
}
