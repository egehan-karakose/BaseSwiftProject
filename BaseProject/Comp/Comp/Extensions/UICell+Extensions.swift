//
//  UICell+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UIKit
import Common

extension UITableViewCell: NibLoadable { }
extension UICollectionViewCell: NibLoadable { }

extension UITableViewCell {
    
    func populate(with viewModel: CellViewModelProtocol?) {
        guard let viewModel = viewModel else { return }
        selectionStyle = viewModel.selectionStyle
        accessoryType = viewModel.accessoryType
        accessoryView = viewModel.accessoryView
        if let separatorInset = viewModel.separatorInset {
            self.separatorInset = separatorInset
        }
    }
    
    public func animateSwipeShowCase(with animationView: UIView, animationWidth: CGFloat? = nil, completion: VoidHandler? = nil) {
        contentView.backgroundColor = .white
        
        let animationViewSize = CGSize(width: animationWidth != nil ? animationWidth~ : bounds.width / 5, height: bounds.height)
        let xPosition = bounds.width - animationViewSize.width
        animationView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: animationViewSize.width,
                                     height: animationViewSize.height)
        animationView.layoutSubviews()
        animationView.updateConstraints()
        insertSubview(animationView, belowSubview: contentView)
        bringSubviewToFront(contentView)
        for view in self.subviews where String(describing: type(of: view)).hasSuffix("SeparatorView") {
            bringSubviewToFront(view)
        }
        
        let transfromByX = bounds.width - xPosition
        
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform.identity.translatedBy(x: -transfromByX, y: 0)
            animationView.transform = CGAffineTransform.identity.translatedBy(x: transfromByX, y: 0)
        }) { (finished) in
            UIView.animateKeyframes(withDuration: 0.4, delay: 0.35, options: [], animations: {
                self.transform = CGAffineTransform.identity
                animationView.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                animationView.removeFromSuperview()
                completion?()
            })
        }
        
    }
    
    public func shakeForSwipe(_ animationView: UIView, desiredWidth: CGFloat) {
        self.shakeForSwipe(animationView, desiredWidth: desiredWidth, completion: nil)
    }
    
    public func shakeForSwipe(_ animationView: UIView, desiredWidth: CGFloat, completion: VoidHandler?) {
        
        let cellViewFrame = CGRect(x: 0,
                                   y: 0,
                                   width: frame.size.width,
                                   height: frame.size.height)
        let cellImageView = UIImageView()
        cellImageView.image = snapshotRows()
        cellImageView.frame = cellViewFrame
        
        let animationViewFrame = CGRect(x: contentView.frame.maxX - desiredWidth,
                                        y: 0,
                                        width: desiredWidth,
                                        height: cellViewFrame.height)
        animationView.frame = animationViewFrame
        addSubview(animationView)
        bringSubviewToFront(animationView)
        animationView.layoutSubviews()
        animationView.updateConstraints()
        
        addSubview(cellImageView)
        bringSubviewToFront(cellImageView)
        
        let oldUserIteraction = isUserInteractionEnabled
        isUserInteractionEnabled = false
        let oldBackgroundColor = contentView.backgroundColor
        contentView.backgroundColor = .white
        contentView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       animations: {
                        cellImageView.transform =  CGAffineTransform(translationX: -desiredWidth, y: 0)
        })
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.5,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       animations: {
                        cellImageView.transform =  CGAffineTransform(translationX: 0, y: 0)
        }) { [weak self] _ in
            self?.contentView.backgroundColor = oldBackgroundColor
            animationView.removeFromSuperview()
            cellImageView.removeFromSuperview()
            self?.isUserInteractionEnabled = oldUserIteraction
            if let completion = completion {
                completion()
            }
        }
        
    }
    
    func snapshotRows() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.bounds.origin.y = frame.origin.y - frame.minY
        layer.render(in: context)
        layer.bounds.origin.y = 0
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func hideSeperator() {
        subviews.forEach { (view) in
            if type(of: view).description().lowercased().contains("separator") {
                view.isHidden = true
            }
        }
    }
}
