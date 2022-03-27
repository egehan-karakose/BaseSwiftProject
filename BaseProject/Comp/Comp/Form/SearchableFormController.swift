//
//  SearchableFormController.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

class CustomSearchBar: UISearchBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }
    
}

class CustomSearchController: UISearchController, UISearchBarDelegate {
    
    lazy var customSearchBar: CustomSearchBar = {
        let result = CustomSearchBar(frame: .zero)
        result.backgroundColor = .white
        result.delegate = self
        return result
    }()
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let currentText = searchBar.text else {
            isActive = false
            return
        }
        if currentText == "" {
            isActive = false
        }
    }
    
    override var searchBar: UISearchBar {
        return customSearchBar
    }
    
}

open class SearchableFormController: TiltableFormController, UISearchResultsUpdating {
    
    private var searchController: CustomSearchController?
    public var searchTextPlaceholder: String? = "Ara".localized {
        didSet {
            searchController?.searchBar.placeholder = searchTextPlaceholder ?? "Ara".localized
        }
    }
    
    private var initialData: [FormSection]?
    private var filteredData: [FormSection]?
    
    open func filterRow(row: FormRowDataSource, searchText: String) -> Bool {
        return true
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeHideKeyboardActionWhenTappedAround()
    }
    
    open func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        guard let searchText = text else { return }
        if (searchText.isEmpty || searchText.count < 2) && initialData == nil {
            initialData = data
            return
        } else if (searchText.isEmpty || searchText.count < 2) && initialData != nil {
            data = initialData
            handleEmptySearchState()
            return
        }
        let processedSearchText = searchText.lowercased()
        filterSections(searchText: processedSearchText)
    }
    
    func filterSections(searchText: String) {
        guard initialData != nil else { return }
        
        let section = initialData?
            .compactMap({ $0.rows })
            .flatMap({ $0 })
            .filter({ row in
                return filterRow(row: row, searchText: searchText)
            })
            .reduce(into: FormSection(), { section, row in
                if section.rows == nil { section.rows = [] }
                section.rows?.append(row)
            })
        filteredData = section?.rows == nil ? [] : [section!]
        data = filteredData
        handleEmptySearchState()
    }
    
    public func setSearchEnabled() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            automaticallyAdjustsScrollViewInsets = true
        }
        searchController = CustomSearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = searchTextPlaceholder ?? "Ara".localized
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.tintColor = .appYellow
        searchController?.searchBar.textField?.addToolBar()
        searchController?.searchBar.subviews.forEach({ (view) in
            view.subviews.forEach({ (subView) in
                if subView.isKind(of: UITextField.self) {
                    if let textField = subView as? UITextField {
                        textField.backgroundColor = .white
                        textField.borderStyle = .none
                        textField.layer.borderColor = UIColor.appLightGray.cgColor
                        textField.layer.borderWidth = 1
                        textField.layer.cornerRadius = 6.0
                        textField.clipsToBounds = true
                        if let leftview = textField.leftView {
                            leftview.frame = CGRect(x: leftview.frame.origin.x, y: leftview.frame.origin.y,
                                                    width: leftview.frame.width + 7, height: leftview.frame.height)
                            leftview.contentMode = .scaleAspectFit
                            textField.layoutSubviews()
                        }
                    }
                }
            })
        })
        
        if #available(iOS 13.0, *) {
            searchController?.searchBar.searchTextField.backgroundColor = UIColor.white
            searchController?.searchBar.backgroundColor = .white
            tableView.tableHeaderView = searchController?.searchBar
        } else if #available(iOS 11.0, *) {
            searchController?.searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: 6.5)
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        } else {
            searchController?.searchBar.backgroundColor = .white
            tableView.tableHeaderView = searchController?.searchBar
        }
    
        definesPresentationContext = true
        navigationController?.view.layoutSubviews()
        view.setNeedsLayout()
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    public func setSearchDisabled() {
        searchController = nil
        
        if #available(iOS 13.0, *) {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        } else if #available(iOS 11.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.navigationItem.searchController = nil
                self?.navigationController?.view.layoutSubviews()
                
                self?.view.setNeedsLayout()
                self?.navigationController?.view.setNeedsLayout()
                self?.navigationController?.view.layoutIfNeeded()
            }
        } else {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        }
    }
    
    public func hideSearchBar() {
        searchController?.searchBar.isHidden = true
    }
    
    public func showSearchBar() {
        searchController?.searchBar.isHidden = false
    }
    
    public func clearSearchBar() {
        searchController?.searchBar.text = nil
        searchController?.searchBar.endEditing(true)
        initialData = nil
    }
    
    override func shouldShowEmptyDataView() -> Bool? {
        let superResult = super.shouldShowEmptyDataView()
        guard let searchText = searchController?.searchBar.text else { return superResult }
        if searchText.isEmpty { return superResult }
        return nil
    }
    
    private func handleEmptySearchState() {
        guard shouldShowEmptyDataView() == nil else { return }
        guard let searchText = searchController?.searchBar.text else { return }
        if !searchText.isEmpty && data?.filter({ $0.isEnabled }).isEmpty == true {
            let view = SearchEmptyContentView.loadFromNib()
            if let currentNavigationController = navigationController {
                view.navigationBarHeight = currentNavigationController.navigationBar.frame.size.height
            }
            let viewModel = SearchEmptyContentViewModel(with: searchText, shouldSetGenericTitle: true)
            view.populate(with: viewModel)
            tableView.backgroundView = view
        } else {
            tableView.backgroundView = nil
        }
    }
    
}

extension SearchableFormController {
    
    func initializeHideKeyboardActionWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
