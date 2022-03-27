//
//  FormController.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

extension UITableView {
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

open class FormController: CustomTableViewController {
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    public var screenCode: Int? = nil
    public var reuseHeaders: Bool = false
    public var reuseCells: Bool = false
    public var isFormScreen: Bool = false {
        didSet {
            updateSeparators()
        }
    }
    open var presentController: Bool = false
    public var viewReadyForPush: VoidHandler?
    public var showEmptySectionTitles: Bool = false
    public var closeKeyboardIfPossible: Bool = true
    public var clearsSelectionOnViewWillAppear: Bool = false
    public var clearsSelectionOnViewDidDisappear: Bool = false
    public var isWarningResultSectionExist: Bool = false
    public var emptyDataViewModel: FormEmptyDataViewModelProtocol?
    public var textFieldIndexArray: [TextFieldTagIndex] = [TextFieldTagIndex]()
    public var backButtonHandler: VoidHandler?

    public var bottomStackViewModel: BottomStackViewModel? {
        didSet {
            UIView.performWithoutAnimation {
                populateBottomStackView()
            }
        }
    }
    
    public var topStackViewModel: TopStackViewModel? {
        didSet {
            UIView.performWithoutAnimation {
                populateTopStackView()
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    public init() {
        super.init(style: .grouped)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.title = ""
    }
    
    public func setAccesibilityTitle(controllerTitle: String, controllerAccesibilityTitle: String) {
        let label = UILabel.init()
        label.text = controllerTitle
        label.accessibilityLabel = controllerAccesibilityTitle
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        navigationItem.titleView = label
        accessibilityLabel = controllerAccesibilityTitle
    }
    
    private func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        if backButtonHandler != nil {
            makeBackButton()
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideTabbar()
        if clearsSelectionOnViewWillAppear { deselectSelectedRow() }
        if closeKeyboardIfPossible { view.endEditingOfFirstResponder() }
        updateSeparators()
        
        if isModal, #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func showOrHideTabbar() {
        if let navigationController = self.navigationController {
            tabBarController?.tabBar.isHidden = navigationController.viewControllers.count > 1
        }
    }
    
    private func updateSeparators() {
        tableView.separatorColor = isFormScreen == true ? .clear : .appLightGray
        if isFormScreen == true {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if closeKeyboardIfPossible { view.endEditingOfFirstResponder() }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if clearsSelectionOnViewDidDisappear {
            deselectSelectedRow()
        }
    }
    
    public var data: [FormSection]? {
        didSet {
            textFieldIndexArray.removeAll()
            if let data = data, !data.isEmpty {
                data.forEach({ section in
                    section.rows?.forEach({row in
                        row.register(tableView)
                    })
                })
            }
            tableView.reloadData()
            handleEmptyDataViewVisibility()
        }
    }
    
    func makeBackButton() {
        let backImage = UIImage(named: "navigation_back")
        let item = UIBarButtonItem(image: backImage,
                                   style: .plain,
                                   target: self,
                                   action: #selector(backButtonAction))
        self.navigationItem.setLeftBarButton(item, animated: true)
    }
    
    @objc func backButtonAction() {
        if let handler = backButtonHandler {
            handler()
        }
    }
    
    // MARK: Empty Data
    
    private func canShowEmptyDataView() -> Bool {
        guard emptyDataViewModel != nil else { return false }
        guard data != nil else { return false }
        return true
    }
    
    func shouldShowEmptyDataView() -> Bool? {
        guard canShowEmptyDataView() else { return false }
        let visibleRows = data?
            .filter({ $0.isEnabled })
            .compactMap({ $0.rows })
            .flatMap({ $0 })
            .filter({ $0.isEnabled })
        return visibleRows?.isEmpty == true
    }
    
}
