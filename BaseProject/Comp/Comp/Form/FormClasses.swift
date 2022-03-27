//
//  FormVarious.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public protocol ParameterConvertible {
    var parameterValue: Any? { get }
}

public class RowEditingAction {
    var title: String?
    var iconName: String?
    let backgroundColor: UIColor
    let handler: VoidHandler
    
    public init(title: String, backgroundColor: UIColor, _ handler: @escaping VoidHandler) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.handler = handler
    }
    
    public init(iconName: String, backgroundColor: UIColor, _ handler: @escaping VoidHandler) {
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.handler = handler
    }
    
    public init(title: String, iconName: String, backgroundColor: UIColor, _ handler: @escaping VoidHandler) {
        self.title = title
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.handler = handler
    }
}

open class FormRowDataSource: Equatable {

	private let classId = UUID()
	public var identifier: String?
    public var parameter: Parameters? { return nil }
    public var isEnabled: Bool = true
    public var tag: Int?

    // TODO: remove me, it should handled by view model
    public var isSelectable: Bool = true
    public var rowSelected: VoidHandler?
    public var rowDeleted: VoidHandler?
    public var rowEditingAction: RowEditingAction?
    public var tableViewCell: UITableViewCell?
    
    public var validators: [Validator] = []
    public var isValid = true
    
    public func getCell(_ fromTableView: UITableView, reuse: Bool) -> UITableViewCell {
        return UITableViewCell()
    }
    public func register(_ toTableView: UITableView) { }
    public func validate(setErrorText: Bool = true) -> Bool { return true }
    public func clearValidationState() { }
    public func validationStateChanged() { }
	
    public static func == (lhs: FormRowDataSource, rhs: FormRowDataSource) -> Bool {
		return lhs.classId == rhs.classId
	}
    
    public func setSeperatorVisibility(isHidden: Bool, fromTableView: UITableView, reuse: Bool = true) {
        let cell = self.getCell(fromTableView, reuse: reuse)
        cell.separatorInset.left += isHidden ? 500 : 0
    }
}

open class FormRow<Cell: UITableViewCell, ViewModel>: FormRowDataSource, KeyValueRowProtocol {
    
    public var keyValueModel: KeyValueProtocol?
    public var key: String?
    private var cell: Cell?
    private var tableView: UITableView?
    
    public override var parameter: Parameters? {
        guard let key = key else { return nil }
        guard let viewModel = viewModel as? ParameterConvertible else { return nil }
        guard let parameterValue = viewModel.parameterValue else { return nil }
        return [key: parameterValue]
    }
    
    public var viewModel: ViewModel? {
        didSet {
            populate(cell, viewModel: viewModel)
            keyValueModel = viewModel as? KeyValueProtocol
        }
    }
    
    public override func getCell(_ fromTableView: UITableView, reuse: Bool) -> UITableViewCell {
        if cell != nil, reuse {
            cell = fromTableView.dequeue(cell: Cell.self)
        } else {
            if let cachedCell = self.cell {
                populate(cachedCell, viewModel: viewModel)
                return cachedCell
            }
            let cellType = Cell.self
            if cellType.bundle?.path(forResource: cellType.defaultNibName, ofType: "nib") != nil {
                cell = Cell.loadFromNib()
            } else {
                cell = Cell(style: .default, reuseIdentifier: cellType.defaultNibName)
            }
        }
        self.tableView = fromTableView
        populate(cell, viewModel: viewModel)
        tableViewCell = cell
        if let cell = cell {
            return cell
        }
        return UITableViewCell()
    }
    
    public override func register(_ toTableView: UITableView) {
        toTableView.register(Cell.self)
    }
    
    open func populate(_ cell: Cell?, viewModel: ViewModel?) { }
    
    @discardableResult
    public override func validate(setErrorText: Bool = false) -> Bool {
        guard !validators.isEmpty,
            let viewModel = viewModel,
            let validatableViewModel = viewModel as? Validatable else {
                isValid = true
                return true
        }
        isValid = validatableViewModel.validate(with: validators, setErrorText: setErrorText)
        return isValid
    }
    
    public override func clearValidationState() {
        guard !validators.isEmpty,
            let viewModel = viewModel,
            let validatableViewModel = viewModel as? Validatable else {
                isValid = true
                return
        }
        validatableViewModel.clearValidationState()
        populate(cell, viewModel: viewModel)
        isValid = true
    }
    // FIXME: bu fonksiyonları yunus kontrol edecek :)
    // FIXME: bu fonksiyonları yunus kontrol edecek :)
    // FIXME: bu fonksiyonları yunus kontrol edecek :)
    public override func validationStateChanged() {
        let unvalidViewModel = viewModel
        viewModel = unvalidViewModel
    }
    
    public override init() { }
    
    public init(key: String) {
        self.key = key
    }
}

public class FormSection {
    
    public var emptyHeaderHeight: CGFloat?
    public var title: String? {
        didSet {
            guard let oldValue = oldValue else { return }
            isTitleChanged = oldValue != title
        }
    }
    var isTitleChanged: Bool = false
    public var accessoryView: UIView?
    public var leftView: UIView?
    public var isEnabled: Bool = true
    public var rows: [FormRowDataSource]?
    public var footerView: UIView?
    public var headerView: UIView?
    public var backGroundColor: UIColor = UIColor.appBackgroundGray

    public init() { }
    
    public init(title: String?) {
        self.title = title
    }
    
}
