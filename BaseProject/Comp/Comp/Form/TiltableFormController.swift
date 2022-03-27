//
//  TiltableFormController.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public enum TiltStrategy {
    
    case infinite
    case max(times: Int)
    case oncePerLoad
}

open class TiltableFormController: FormController {
    
    public var tiltStrategy = TiltStrategy.infinite
    private var canShake = true
    var timer: Timer?
    public override var data: [FormSection]? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.handleTilt()
            }
        }
    }
    private var didShakeFirstTime = false
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if data == nil { return }
        canShake = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.handleTilt()
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block: { [weak self] _ in
                self?.canShake = true
            })
        }
    }
    
    private func handleTilt() {
        
        if !canShake { return }
        canShake = false
        timer?.invalidate()

        guard getTiltableRows()?.isEmpty == false else {
            canShake = true
            return
        }
        guard canShakeRow() == true else {
            canShake = true
            return
        }
        let backgroundView = SwipeBackgroundView.loadFromNib()
        let row = getTiltableRows()?.first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let cell = row?.tableViewCell else { return }
            if cell.frame.origin.x < 0 { return }
            self?.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.view.isUserInteractionEnabled = true
            }
            cell.shakeForSwipe(backgroundView, desiredWidth: 100)
            self?.didShakeFirstTime = true
            self?.raiseShakeCount()
        }
        
    }
    
    private func getTiltableRows() -> [FormRowDataSource]? {
        guard let tiltableRows = data?
            .filter({ $0.isEnabled })
            .compactMap({ $0.rows })
            .flatMap({ $0 })
            .filter({ $0.isEnabled })
            .filter({ $0.rowDeleted != nil }) else { return nil}
        return tiltableRows
    }
    
    private func canShakeRow() -> Bool {
        switch tiltStrategy {
        case .infinite:
            return true
        case .max(let times):
            guard times >= getShakeCount() else { return false }
        case .oncePerLoad:
            return !didShakeFirstTime
        }
        
        return true
    }
    
    private func getShakeCount() -> Int {
        guard let identifier = controllerIdentifier else { return 0 }
        let defaultsKey = BaseDefaultsKeys.string(value: identifier)
        let shakeCount = BaseDefaults.shared.retrieveInt(with: defaultsKey) ?? 0
        return shakeCount
    }
    
    private func raiseShakeCount() {
        guard let identifier = controllerIdentifier else { return }
        let defaultsKey = BaseDefaultsKeys.string(value: identifier)
        let shakeCount = getShakeCount()
        BaseDefaults.shared.storeInt(with: defaultsKey, value: shakeCount + 1)
    }
    
}

public class SwipeBackgroundView: UIView {
    
}

extension SwipeBackgroundView: NibLoadable {  }
