//
//  CustomTableViewController.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

open class CustomTableViewController: UIViewController, UIScrollViewDelegate {
    
    private var tableViewStyle: UITableView.Style = .grouped
    public var tableView: UITableView!
    var topStackView: UIStackView!
    var bottomStackView: UIStackView!
    private var holderView: UIView!
    
    private var tableViewUnfocusedBottomConstraint: NSLayoutConstraint?
    private var tableViewFocusedBottomConstraint: NSLayoutConstraint?
    public var topStackViewHeightConstraint: NSLayoutConstraint?
    private var lastKeyboardHeight: CGFloat = -1
    private var lastKeyboardWillShow = false
    
    let initialTableHeaderViewTag = 123587253
    let initialTableFooterViewTag = 123587254
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(style: UITableView.Style) {
        tableViewStyle = style
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardStateWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardStateWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidBeginEditing(notification:)),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameDidChange(notification:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }
    
    @objc func keyboardFrameDidChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRect.size.height
        if keyboardHeight == lastKeyboardHeight { return }
        lastKeyboardHeight = keyboardHeight
        tableViewFocusedBottomConstraint?.constant = -keyboardHeight
        view.layoutIfNeeded()
        scrollToFirstResponder()
    }
    
    // FIXME: jump problems
    @objc func keyboardStateWillChange(notification: Notification) {
        let willShow = notification.name == UIResponder.keyboardWillShowNotification
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let animationDurationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        guard let animationDuration = userInfo[animationDurationKey] as? CGFloat else { return }
        let keyboardHeight = keyboardRect.size.height
        if keyboardHeight == lastKeyboardHeight && willShow == lastKeyboardWillShow { return }
        lastKeyboardHeight = keyboardHeight + 1
        lastKeyboardWillShow = willShow
        
        if willShow {
            tableViewUnfocusedBottomConstraint?.isActive = false
            tableViewFocusedBottomConstraint?.constant = -keyboardHeight + getVisibleTabbarHeight()
            tableViewFocusedBottomConstraint?.isActive = true
        } else {
            tableViewFocusedBottomConstraint?.isActive = false
            tableViewUnfocusedBottomConstraint?.isActive = true
        }
        
        UIView.animate(withDuration: TimeInterval(animationDuration)) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func getVisibleTabbarHeight() -> CGFloat {
        guard
            let navigationController = self.parent as? UINavigationController,
            let tabBarController = navigationController.parent as? UITabBarController
            else { return 0 }
        return tabBarController.tabBar.frame.height
    }
    
    func scrollToFirstResponder() {
        guard let firstResponder = tableView.findFirstResponder() else { return }
        guard let cell = firstResponder.findSuperview(of: UITableViewCell.self) else { return }
        guard let indexPath = tableView.indexPathForRow(at: cell.center) else { return }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            // old one
            // guard let rect = self?.tableView.rectForRow(at: indexPath) else { return }
            // self?.tableView.scrollRectToVisible(rect, animated: false)
        }
    }
    
    @objc func textFieldDidBeginEditing(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            self?.scrollToFirstResponder()
        })
    }
    
    private func setupViews() {
        tableView = UITableView(frame: CGRect.zero, style: tableViewStyle)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        tableView.tableHeaderView?.tag = initialTableHeaderViewTag
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 38))
        tableView.tableFooterView?.tag = initialTableFooterViewTag
        tableView.backgroundColor = .appBackgroundGray
        tableView.delaysContentTouches = false
        tableView.estimatedRowHeight = 50
        tableView.estimatedSectionHeaderHeight = 50
        tableView.estimatedSectionFooterHeight = 0
        
        bottomStackView = UIStackView(arrangedSubviews: [])
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .fill
        bottomStackView.distribution = .fill
        bottomStackView.spacing = 4
        bottomStackView.backgroundColor = .appBackgroundGray
        
        topStackView = .init(arrangedSubviews: [])
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .vertical
        topStackView.alignment = .fill
        topStackView.distribution = .fill
        topStackView.spacing = 4
        
        holderView = UIView()
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(topStackView)
        holderView.addSubview(tableView)
        holderView.addSubview(bottomStackView)
        holderView.backgroundColor = UIColor.clear
        
        topStackViewHeightConstraint = topStackView.heightAnchor.constraint(equalToConstant: 0)
        topStackViewHeightConstraint?.isActive = true
    }
    
    public func layoutViews() {
        topStackView.addLeadingConstraint(to: holderView, constant: 0)
        topStackView.addTrailingConstraint(to: holderView, constant: 0)
        topStackView.addSafeAreaTopConstraint(to: holderView, constant: 0)
        
        tableView.addLeadingConstraint(to: holderView, constant: 0)
        tableView.addTrailingConstraint(to: holderView, constant: 0)
        tableView.topAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true

        let heightConstraint = tableView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.size.height)
        heightConstraint.priority = .init(rawValue: 999)
        heightConstraint.isActive = true
        
        bottomStackView.addLeadingConstraint(to: holderView, constant: 0)
        bottomStackView.addTrailingConstraint(to: holderView, constant: 0)
        bottomStackView.addSafeAreaBottomConstraint(to: holderView, constant: 0)
        
        tableViewFocusedBottomConstraint = tableView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
        tableViewUnfocusedBottomConstraint?.isActive = false
        
        tableViewUnfocusedBottomConstraint = bottomStackView.topAnchor
            .constraint(equalTo: tableView.bottomAnchor)
        tableViewUnfocusedBottomConstraint?.isActive = true
        
        view.backgroundColor = .appBackgroundGray
        view.addSubview(holderView)
        view.embed(childView: holderView)
        
        guard !(String(describing: navigationController).contains("BaseNavigationController")) &&
                !(String(describing: self).contains("SearchablePickerController")) else { return }
        
    }
    
    public func layoutViewsFor(isSky: Bool) {
        view.backgroundColor = isSky ? .skyBlue : .appBackgroundGray
        if let navigationController = navigationController {
            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                let buttonAppearance = UIBarButtonItemAppearance()
                navBarAppearance.buttonAppearance = buttonAppearance
                navBarAppearance.doneButtonAppearance = buttonAppearance
                navBarAppearance.backButtonAppearance = buttonAppearance
                navBarAppearance.backgroundColor = isSky ? .skyBlue : .appYellow
                
                navBarAppearance.titleTextAttributes = [
                    .foregroundColor: isSky ? UIColor.white : UIColor.navigationTitle,
                    .font: UIFont.black(of: 16)
                ]
                if navigationController.navigationBar.responds(to: #selector(setter: UINavigationItem.standardAppearance)) {
                    navigationController.navigationBar.standardAppearance = navBarAppearance
                    navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
                }
                
            } else {
                navigationController.navigationBar.backgroundColor = isSky ? .skyBlue : .appYellow
                navigationController.navigationBar.tintColor = isSky ? .white : .navigationTitle
                navigationController.navigationBar.isTranslucent = false
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditingOfFirstResponder()
    }
    
    deinit {
        debugPrint("deinit view controller : \(self)")
    }
    
}
