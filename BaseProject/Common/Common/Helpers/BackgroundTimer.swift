//
//  BackgroundTimer.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class BackgroundTimer {
    
    public var eventHandler: VoidHandler?
    private var idleTimer: Timer?
    private var timerStarted: Bool = false
    public var startTime: TimeInterval!

    public init(with tickHandler: VoidHandler?) {
        self.eventHandler = tickHandler
    }
    
    private func resetIdleTimer() {
        if !timerStarted { return }
        
        idleTimer?.invalidate()
        idleTimer = Timer
            .scheduledTimer(timeInterval: 1,
                            target: self,
                            selector: #selector(tick),
                            userInfo: nil,
                            repeats: true)
        if let idleTimer = idleTimer {
            startTime = Date().timeIntervalSinceReferenceDate
            RunLoop.current.add(idleTimer, forMode: .common)
            idleTimer.fire()
        }
    }
    
    @objc private func tick() {
        eventHandler?()
    }

    public func startTimer() {
        timerStarted = true
        resetIdleTimer()
    }
    
    public func stopTimer() {
        idleTimer?.invalidate()
        idleTimer = nil
        timerStarted = false
    }
    
    deinit {
        stopTimer()
    }
    
}
