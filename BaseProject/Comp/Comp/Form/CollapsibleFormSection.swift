//
//  CollapsibleFormSection.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public final class CollapsibleFormSection: FormSection {
    
    private lazy var imgView = UIImageView()
    
    private var tempRows: [FormRowDataSource]?
    private var dockedRows: [FormRowDataSource]?
    private var isExpanded: Bool = true
    private var forceUpdate: Bool
    private var isheaderViewClickEnabled: Bool
    private var isCollapsedForInitial: Bool
    private var isFirstTime: Bool = true
    
    private var expandAnimation: UITableView.RowAnimation
    private var collapseAnimation: UITableView.RowAnimation
    
    fileprivate var onCollapsed: (() -> Void)?
    fileprivate var onExpanded: (() -> Void)?
    
    public override var rows: [FormRowDataSource]? {
        didSet {
            setTempRowsIfNeeded()
            if let lastRow = rows?.last as? FormBasicPickerRow, let rowViewModel = lastRow.viewModel as? FormBasicPickerCellViewModel {
                rowViewModel.lineVisible = false
            }
            
            setCollapseForInitialIfNeeded()
        }
    }
    
    fileprivate init(title: String, rows: [FormRowDataSource], forceUpdate: Bool,
                     isheaderViewClickEnabled: Bool, expandAnimation: UITableView.RowAnimation,
                     collapseAnimation: UITableView.RowAnimation, isCollapsedForInitial: Bool) {
        self.forceUpdate = forceUpdate
        self.isheaderViewClickEnabled = isheaderViewClickEnabled
        self.expandAnimation = expandAnimation
        self.collapseAnimation = collapseAnimation
        self.isCollapsedForInitial = isCollapsedForInitial
        self.isExpanded = !isCollapsedForInitial
        
        super.init()
        
        self.title = title
        self.rows = rows
        self.headerView = createHeaderView()
        if let controller = getTopFormController() {
            controller.showEmptySectionTitles = true
        }
    }
    
    private func createHeaderView() -> UIView {
        let containerView = createHeaderContainerView()
        let sectionHeaderView = createSectionHeaderView()
        
        sectionHeaderView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 53)
        containerView.addSubview(sectionHeaderView)
        
        return containerView
    }
    
    private func createHeaderContainerView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 73))
        containerView.backgroundColor = .appBackgroundGray
        return containerView
    }
    
    private func createSectionHeaderView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        
        let imgView = createImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imgView)
        
        imgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let label = UILabel()
        label.font = .regular(of: 14)
        label.textColor = .appBlack1
        label.text = title
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: 16).isActive = true
        
        if isheaderViewClickEnabled {
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onStateChange)))
        }
        
        return view
    }
    
    private func createImageView() -> UIImageView {
        var angle: CGFloat = .pi / 2
        if !isCollapsedForInitial {
            angle *= -1
        }
        imgView.image = UIImage(named: "rightArrow", in: .uiComp, compatibleWith: nil)?.rotate(radians: angle)
        imgView.contentMode = .scaleAspectFit
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onStateChange)))
        return imgView
    }
    
    private func getTopFormController() -> FormController? {
        return AlertManager.getTopViewController() as? FormController
    }
    
    fileprivate func setDockedRows(with indexes: [Int]?) {
        guard let rows = self.rows, let indexes = indexes else { return }
        dockedRows = [FormRowDataSource]()
        for index in indexes where index < rows.count {
            dockedRows?.append(rows[index])
        }
    }
    
    fileprivate func setDockedRows(with dockedRows: [FormRowDataSource]?) {
        guard let dockedRows = dockedRows else { return }
        self.dockedRows = dockedRows
    }
}

extension CollapsibleFormSection {
    
    private func setCollapseForInitialIfNeeded() {
        if isFirstTime && isCollapsedForInitial {
            isFirstTime = false
            rows = []
        }
    }
    
    private func setTempRowsIfNeeded() {
        if let rows = self.rows, rows.count >= getTempRowsCount() {
            tempRows = rows
        }
    }
    
    private func getTempRowsCount() -> Int {
        guard let tempRows = self.tempRows else { return 0 }
        return tempRows.count
    }
    
    @objc private func onStateChange() {
        onTap()
    }
    
    private func updateIsExpanded() {
        isExpanded = !isExpanded
        rotateImageView()
    }
    
    private func rotateImageView() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.imgView.transform = self.imgView.transform.rotated(by: .pi)
        })
    }
    
    private func reloadSection(rows: [FormRowDataSource]?, animation: UITableView.RowAnimation) {
        self.rows = rows
        if forceUpdate, let controller = getTopFormController() {
            controller.reloadSection(self, animation: animation)
        }
    }
}

extension CollapsibleFormSection {
    
    public func onTap() {
        isExpanded ? forceCollapse() : forceExpand()
    }
    
    public func forceExpand() {
        reloadSection(rows: tempRows, animation: expandAnimation)
        onExpanded?()
        updateIsExpanded()
    }
    
    public func forceCollapse() {
        reloadSection(rows: dockedRows, animation: collapseAnimation)
        onCollapsed?()
        updateIsExpanded()
    }
}

extension CollapsibleFormSection {
    
    public class Builder {
        
        private var title: String
        private var indexes: [Int]?
        private var dockedRows: [FormRowDataSource]?
        private var rows: [FormRowDataSource]
        private var forceUpdate: Bool = true
        private var isheaderViewClickEnabled: Bool = true
        private var expandAnimation: UITableView.RowAnimation = .fade
        private var collapseAnimation: UITableView.RowAnimation = .fade
        private var onCollapsed: (() -> Void)?
        private var onExpanded: (() -> Void)?
        private var isCollapsedForInitial: Bool = true
        
        public init(title: String, rows: [FormRowDataSource]) {
            self.title = title
            self.rows = rows
        }
          
        @discardableResult
        public func setDockedRows(indexes: [Int]) -> Builder {
            if self.dockedRows != nil {
                fatalError("Can not be used indexes and dockedRows together")
            }
            self.indexes = indexes
            return self
        }
        
        @discardableResult
        public func setDockedRows(rows: [FormRowDataSource]) -> Builder {
            if self.indexes != nil {
                fatalError("Can not be used indexes and dockedRows together")
            }
            self.dockedRows = rows
            return self
        }
        
        @discardableResult
        public func setForceUpdate(forceUpdate: Bool) -> Builder {
            self.forceUpdate = forceUpdate
            return self
        }
        
        @discardableResult
        public func setIsHeaderViewClickEnabled(isEnable: Bool) -> Builder {
            self.isheaderViewClickEnabled = isEnable
            return self
        }
        
        @discardableResult
        public func setExpandAnimation(animation: UITableView.RowAnimation) -> Builder {
            self.expandAnimation = animation
            return self
        }
        
        @discardableResult
        public func setCollapseAnimation(animation: UITableView.RowAnimation) -> Builder {
            self.collapseAnimation = animation
            return self
        }
        
        @discardableResult
        public func setOnCollapsed(onCollapsed: @escaping (() -> Void)) -> Builder {
            self.onCollapsed = onCollapsed
            return self
        }
        
        @discardableResult
        public func setOnExpanded(onExpanded: @escaping (() -> Void)) -> Builder {
            self.onExpanded = onExpanded
            return self
        }
        
        @discardableResult
        public func setCollapsedForInitial(collapsed: Bool) -> Builder {
            self.isCollapsedForInitial = collapsed
            return self
        }

        public func build() -> CollapsibleFormSection {
            let section = CollapsibleFormSection(title: title, rows: rows, forceUpdate: forceUpdate,
                                                 isheaderViewClickEnabled: isheaderViewClickEnabled,
                                                 expandAnimation: expandAnimation,
                                                 collapseAnimation: collapseAnimation,
                                                 isCollapsedForInitial: isCollapsedForInitial)
            section.onCollapsed = onCollapsed
            section.onExpanded = onExpanded
            section.setDockedRows(with: indexes)
            section.setDockedRows(with: dockedRows)
            return section
        }
    }
}
