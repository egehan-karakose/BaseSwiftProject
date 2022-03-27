//
//  FormControllerCells.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

//swiftlint:disable all

import Foundation

//swiftlint:disable file_length

//public class DateRow: FormRow<DatePickerCell, DatePickerViewModelProtocol> {
//
//    public override func populate(_ cell: DatePickerCell?, viewModel: DatePickerViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//
//}
//
//public class MonthAndYearPickerRow: FormRow<MonthAndYearDatePickerCell, MonthAndYearDatePickerCellViewModelProtocol> {
//
//    public override func populate(_ cell: MonthAndYearDatePickerCell?, viewModel: MonthAndYearDatePickerCellViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class AmountRow: FormRow<VKFAmountCell, VKFAmountCellViewModelProtocol> {
//
//    public override func populate(_ cell: VKFAmountCell?, viewModel: VKFAmountCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class DocumentRow: FormRow<DocumentCell, DocumentCellViewModelProtocol> {
//    public override func populate(_ cell: DocumentCell?, viewModel: DocumentCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class InformationRow: FormRow<InformationCell, InformationCellViewModelProtocol> {
//    public override func populate(_ cell: InformationCell?, viewModel: InformationCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class DepositCalculateItemRow: FormRow<DepositCalculateItemCell, DepositCalculateItemViewModelProtocol> {
//    public override func populate(_ cell: DepositCalculateItemCell?, viewModel: DepositCalculateItemViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class CumulativeCalculateItemRow: FormRow<CumulativeCalculateItemCell, CumulativeCalculateItemViewModelProtocol> {
//    public override func populate(_ cell: CumulativeCalculateItemCell?, viewModel: CumulativeCalculateItemViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class CheckboxTwoLinesRow: FormRow<CheckboxTwoLinesCell, CheckboxTwoLinesViewModelProtocol> {
//    public override func populate(_ cell: CheckboxTwoLinesCell?, viewModel: CheckboxTwoLinesViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class MenuRow: FormRow<MenuCell, MenuCellViewModelProtocol> {
//
//    public override func populate(_ cell: MenuCell?, viewModel: MenuCellViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//
//}
//
//public class DynamicMenuRow: FormRow<NewTagMenuCell, NewTagMenuCellViewModelProtocol> {
//    public override func populate(_ cell: NewTagMenuCell?, viewModel: NewTagMenuCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.decideProfileAndPopulate(with: viewModel)
//    }
//}
//
//public class AccountRow: FormRow<ChequeAccountCell, AccountCellViewModelProtocol> {
//
//    override public func populate(_ cell: ChequeAccountCell?, viewModel: AccountCellViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//
//}
//
//public class FormAccountRow: FormRow<FormAccountCell, FormAccountCellViewModelProtocol> {
//
//    override public func populate(_ cell: FormAccountCell?, viewModel: FormAccountCellViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class SegmentRow: FormRow<SegmentControlCell, SegmentControlCellViewModelProtocol> {
//
//    override public func populate(_ cell: SegmentControlCell?, viewModel: SegmentControlCellViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//
//}
//
//public class TextFieldRow: FormRow<TextFieldCell, TextFieldViewModelProtocol> {
//
//    override public func populate(_ cell: TextFieldCell?, viewModel: TextFieldViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//
//}
//
//public class BasicPickerRow: FormRow<DropDownCell, BasicPickerViewModelProtocol> {
//
//    override public func populate(_ cell: DropDownCell?, viewModel: BasicPickerViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//
//}
//
//public class ButtonRow: FormRow<ButtonCell, ButtonCellViewModelProtocol> {
//
//    override public func getCell(_ fromTableView: UITableView, reuse: Bool) -> UITableViewCell {
//        let cell = super.getCell(fromTableView, reuse: reuse ) as? ButtonCell
//        cell?.rowSelected = { [weak self] () in
//            self?.rowSelected?()
//        }
//        return cell ?? UITableViewCell()
//    }
//
//    public override func populate(_ cell: ButtonCell?, viewModel: ButtonCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//        cell?.selectionStyle = .none
//    }
//
//}
//
//public class ApproverRow: FormRow<ApproverCell, ApproverCellViewModelProtocol> {
//
//    override public func populate(_ cell: ApproverCell?, viewModel: ApproverCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class MerchantRow: FormRow<MerchantCell, MerchantCellViewModelProtocol> {
//
//    override public func populate(_ cell: MerchantCell?, viewModel: MerchantCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class ConfirmationKeyValueRow: FormRow<ConfirmationKeyValueCell, ConfirmationKeyValueCellViewModelProtocol> {
//
//    public override func populate(_ cell: ConfirmationKeyValueCell?, viewModel: ConfirmationKeyValueCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class CheckBoxRow: FormRow<CheckBoxCell, CheckBoxCellViewModelProtocol> {
//
//    public override func populate(_ cell: CheckBoxCell?, viewModel: CheckBoxCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class SwitchRow: FormRow<SwitchCell, SwitchCellViewModelProtocol> {
//
//    public override func populate(_ cell: SwitchCell?, viewModel: SwitchCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class StringPickerRow: FormRow<StringPickerCell, StringPickerCellViewModelProtocol> {
//
//    public override func populate(_ cell: StringPickerCell?, viewModel: StringPickerCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class TitleValueRow: FormRow<TitleValueCell, TitleValueCellViewModelProtocol> {
//
//    public override func populate(_ cell: TitleValueCell?, viewModel: TitleValueCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class CountdownTimerRow: FormRow<CountdownTimerCell, CountdownTimerCellViewModelProtocol> {
//
//    public override func populate(_ cell: CountdownTimerCell?, viewModel: CountdownTimerCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class ChequeRow: FormRow<ChequeCell, ChequeCellViewModelProtocol> {
//
//    public override func populate(_ cell: ChequeCell?, viewModel: ChequeCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class DisclosureRow: FormRow<DisclosureCell, DisclosureCellViewModelProtocol> {
//
//    public override func populate(_ cell: DisclosureCell?, viewModel: DisclosureCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class LabelRow: FormRow<LabelCell, LabelCellViewModelProtocol> {
//
//    public override func populate(_ cell: LabelCell?, viewModel: LabelCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class AccountTransactionsRow: FormRow<AccountTransactionCell, AccountTransactionCellViewModelProtocol> {
//
//    public override func populate(_ cell: AccountTransactionCell?, viewModel: AccountTransactionCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        guard let cell = cell else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class AccountBalanceRow: FormRow<AccountBalanceCell, AccountBalanceCellViewModelProtocol> {
//
//    public override func populate(_ cell: AccountBalanceCell?, viewModel: AccountBalanceCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        guard let cell = cell else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class InvestmentAccountBalanceRow: FormRow<InvestmentAccountTransactionCell, InvestmentAccountTransactionCellViewModelProtocol> {
//
//    public override func populate(_ cell: InvestmentAccountTransactionCell?, viewModel: InvestmentAccountTransactionCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        guard let cell = cell else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
public class FormTextFieldRow: FormRow<FormTextFieldCell, FormTextFieldViewModelProtocol> {

    override public func populate(_ cell: FormTextFieldCell?, viewModel: FormTextFieldViewModelProtocol?) {
        guard let cell = cell else { return }
        guard let viewModel = viewModel else { return }
        cell.populate(with: viewModel, tag: self.tag ?? 0)

        rowSelected = {
            cell.setSelected(true, animated: true)
        }
    }

}
//
//public class TransferDetailWithCheckboxRow: FormRow<TransferDetailWithCheckboxCell, TransferDetailWithCheckboxCellViewModelProtocol> {
//
//    public override func populate(_ cell: TransferDetailWithCheckboxCell?, viewModel: TransferDetailWithCheckboxCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
public class FormBasicPickerRow: FormRow<FormBasicPickerCell, FormBasicPickerCellViewModelProtocol> {

    override public func populate(_ cell: FormBasicPickerCell?, viewModel: FormBasicPickerCellViewModelProtocol?) {
        guard let cell = cell else { return }
        guard let viewModel = viewModel else { return }
        cell.populate(with: viewModel)
    }

}
//
//public class FixedDatePickerRow: FormRow<FixedDatePickerCell, FixedDatePickerCellViewModelProtocol> {
//
//    public override func populate(_ cell: FixedDatePickerCell?, viewModel: FixedDatePickerCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class FormAmountRow: FormRow<FormAmountCell, FormAmountTextFieldViewModelProtocol> {
//
//    override public func populate(_ cell: FormAmountCell?, viewModel: FormAmountTextFieldViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel, tag: self.tag ?? 0)
//    }
//
//}
//
//public class ResultFormControllerRow: FormRow<ResultFormCell, ResultFormCellViewModelProtocol> {
//
//    public override func populate(_ cell: ResultFormCell?, viewModel: ResultFormCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class DateDisplayRow: FormRow<DateDisplayCell, DateDisplayCellViewModelProtocol> {
//
//    public override func populate(_ cell: DateDisplayCell?, viewModel: DateDisplayCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//        cell?.rowSelected = { [weak self] in
//            self?.rowSelected?()
//        }
//    }
//
//}
//
//public class EmptyRow: FormRow<EmptyDividerCell, EmptyDividerCellViewModelProtocol> {
//
//    public override func populate(_ cell: EmptyDividerCell?, viewModel: EmptyDividerCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class EmptyCellRow: FormRow<EmptyCell, EmptyCellViewModel> {
//    public override func populate(_ cell: EmptyCell?, viewModel: EmptyCellViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class KeyValueWithCheckboxRow: FormRow<KeyValueWithCheckboxCell, KeyValueWithCheckboxCellViewModelProtocol> {
//
//    public override func populate(_ cell: KeyValueWithCheckboxCell?, viewModel: KeyValueWithCheckboxCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class KeyValueWithIconRow: FormRow<KeyValueWithIconCell, KeyValueWithIconCellProtocol> {
//
//    public override func populate(_ cell: KeyValueWithIconCell?, viewModel: KeyValueWithIconCellProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class ConfirmationWithIconRow: FormRow<ConfirmationKeyValueWithIconCell, ConfirmationKeyValueIconCellViewModelProtocol> {
//
//    public override func populate(_ cell: ConfirmationKeyValueWithIconCell?, viewModel: ConfirmationKeyValueIconCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class InformationWithTitleRow: FormRow<InformationWithTitleCell, InformationWithTitleCellViewModelProtocol> {
//
//    public override func populate(_ cell: InformationWithTitleCell?, viewModel: InformationWithTitleCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class KeyValueCheckboxWithoutGestureRow: FormRow<KeyValueCheckBoxWithoutGestureCell, KeyValueCheckBoxWithoutGestureCellProtocol> {
//
//    public override func populate(_ cell: KeyValueCheckBoxWithoutGestureCell?, viewModel: KeyValueCheckBoxWithoutGestureCellProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class KeyValueWithLabelRow: FormRow<KeyValueWithLabelCell, KeyValueWithLabelCellViewModelProtocol> {
//
//    public override func populate(_ cell: KeyValueWithLabelCell?, viewModel: KeyValueWithLabelCellViewModelProtocol?) {
//
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class CardNumberRow: FormRow<CardNumberCell, CardNumberCellViewModelProtocol> {
//
//    public override func populate(_ cell: CardNumberCell?, viewModel: CardNumberCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class MaskedCardNumberRow: FormRow<MaskedCardNumberCell, MaskedCardNumberCellViewModelProtocol> {
//
//    public override func populate(_ cell: MaskedCardNumberCell?, viewModel: MaskedCardNumberCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class CVVRow: FormRow<CVVCell, CVVCellViewModelProtocol> {
//
//    public override func populate(_ cell: CVVCell?, viewModel: CVVCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class PasswordRow: FormRow<PasswordCell, PasswordCellViewModelProtocol> {
//
//    public override func populate(_ cell: PasswordCell?, viewModel: PasswordCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//
//        rowSelected = {
//            cell?.setSelected(true, animated: true)
//        }
//    }
//}
//
//public class ActivationCodeRow: FormRow<ActivationCodeCell, ActivationCodeCellViewModelProtocol> {
//
//    public override func populate(_ cell: ActivationCodeCell?, viewModel: ActivationCodeCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class MobilePasswordPickerHeaderRow: FormRow<MobilePasswordPickerHeaderCell, MobilePasswordPickerHeaderCellViewModelProtocol> {
//
//    public override func populate(_ cell: MobilePasswordPickerHeaderCell?, viewModel: MobilePasswordPickerHeaderCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class PickerRulesRow: FormRow<PickerRulesCell, PickerRulesCellViewModelProtocol> {
//
//    public override func populate(_ cell: PickerRulesCell?, viewModel: PickerRulesCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class PickerRow: FormRow<PickerCell, PickerRowViewModelProtocol> {
//
//    public override func populate(_ cell: PickerCell?, viewModel: PickerRowViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class BirthDatePickerRow: FormRow<BirthDatePickerCell, BirthDatePickerRowViewModelProtocol> {
//
//    public override func populate(_ cell: BirthDatePickerCell?, viewModel: BirthDatePickerRowViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class BirtCertificateNumberRow: FormRow<BirtCertificateNumberCell, BirtCertificateNumberRowViewModelProtocol> {
//
//    public override func populate(_ cell: BirtCertificateNumberCell?, viewModel: BirtCertificateNumberRowViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class IdentityDocumentNoRow: FormRow<IdentityDocumentNoCell, IdentityDocumentNoCellViewModelProtocol> {
//
//    public override func populate(_ cell: IdentityDocumentNoCell?, viewModel: IdentityDocumentNoCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class OfflinePasswordRow: FormRow<OfflinePasswordCell, OfflinePasswordCellProtocol> {
//
//    public override func populate(_ cell: OfflinePasswordCell?, viewModel: OfflinePasswordCellProtocol?) {
//        guard let offlinePasswordViewModel = viewModel else { return }
//        cell?.populate(with: offlinePasswordViewModel)
//    }
//}
//
//public class MessageListRow: FormRow<MessageListCell, MessageListCellViewModelProtocol> {
//
//    public override func populate(_ cell: MessageListCell?, viewModel: MessageListCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class FormCheckBoxRow: FormRow<FormCheckBoxCell, FormCheckBoxViewModelProtocol> {
//
//    override public func populate(_ cell: FormCheckBoxCell?, viewModel: FormCheckBoxViewModelProtocol?) {
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class ResultScreenMessageRow: FormRow<ResultScreenMessageCell, ResultScreenMessageCellViewModelProtocol> {
//
//    public override func populate(_ cell: ResultScreenMessageCell?, viewModel: ResultScreenMessageCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class ResultScreenAddTransactionRow: FormRow<ResultScreenAddTransactionCell, ResultScreenAddTransactionViewModelProtocol> {
//
//    public override func populate(_ cell: ResultScreenAddTransactionCell?, viewModel: ResultScreenAddTransactionViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class ResultScreenTransactionComplateRow: FormRow<ResultScreenTransactionComplateCell, ResultScreenTransactionComplateModelProtocol> {
//
//    public override func populate(_ cell: ResultScreenTransactionComplateCell?, viewModel: ResultScreenTransactionComplateModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class InformationWithLabelRow: FormRow<InformationWithLabelCell, InformationWithLabelCellProtocol> {
//    public override func populate(_ cell: InformationWithLabelCell?, viewModel: InformationWithLabelCellProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class InactiveProfileRow: FormRow<InactiveProfileCell, InactiveProfileCellViewModelProtocol> {
//
//    public override func populate(_ cell: InactiveProfileCell?, viewModel: InactiveProfileCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class UpdateUserRow: FormRow<UpdateUserCell, UpdateUserCellViewModelProtocol> {
//
//    public override func populate(_ cell: UpdateUserCell?, viewModel: UpdateUserCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class ProfileRow: FormRow<ProfileCell, ProfileCellViewModelProtocol> {
//
//    public override func populate(_ cell: ProfileCell?, viewModel: ProfileCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class WebViewRow: FormRow<WebViewCell, WebViewCellViewModelProtocol> {
//
//    public override func populate(_ cell: WebViewCell?, viewModel: WebViewCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class BranchInfoRow: FormRow<BranchInfoCell, BranchInfoCellViewModelProtocol> {
//    public override func populate(_ cell: BranchInfoCell?, viewModel: BranchInfoCellViewModelProtocol?){
//        guard let viewModel = viewModel else { return}
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class SummaryListRow: FormRow<SummaryListCell, SummaryListRowDataSource> {
//
//    public override func populate(_ cell: SummaryListCell?, viewModel: SummaryListRowDataSource?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class NewBeeTableRow: FormRow<NewBeeTableCell, NewBeeTableViewModel> {
//    override public func populate(_ cell: NewBeeTableCell?, viewModel: NewBeeTableViewModel?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class InvoiceViewRow: FormRow<InvoiceViewCell, InvoiceViewModel> {
//    public override func populate(_ cell: InvoiceViewCell?, viewModel: InvoiceViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class DelayedPaymentRow: FormRow<DelayedPaymentCell, DelayedViewModel> {
//    public override func populate(_ cell: DelayedPaymentCell?, viewModel: DelayedViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class OtherBankViewRow: FormRow<OtherBankCell, OtherBankViewModel> {
//    public override func populate(_ cell: OtherBankCell?, viewModel: OtherBankViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class SegmentedControllRow: FormRow<SegmentedControllCell, SegmentedControllCellViewModelProtocol> {
//    public override func populate(_ cell: SegmentedControllCell?, viewModel: SegmentedControllCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class CardRow: FormRow<CardCell, CardCellViewModelProtocol> {
//
//    public override func getCell(_ fromTableView: UITableView, reuse: Bool) -> UITableViewCell {
//        let cell = super.getCell(fromTableView, reuse: reuse ) as? CardCell
//        cell?.rowSelected = { [weak self] () in
//            self?.rowSelected?()
//        }
//        return cell ?? UITableViewCell()
//    }
//
//    public override func populate(_ cell: CardCell?, viewModel: CardCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class CardTransactionRow: FormRow<CardTransactionCell, CardTransactionCellViewModelProtocol> {
//
//    public override func populate(_ cell: CardTransactionCell?, viewModel: CardTransactionCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class CardShippingTransactionRow: FormRow<CardShippingTransactionCell, CardShippingTransactionCellViewModelProtocol> {
//
//    public override func populate(_ cell: CardShippingTransactionCell?, viewModel: CardShippingTransactionCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class DynamicKeyValueInfoRow: FormRow<DynamicKeyValueInfoCell, DynamicKeyValueInfoCellViewModelProtocol> {
//    public override func populate(_ cell: DynamicKeyValueInfoCell?, viewModel: DynamicKeyValueInfoCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class InfoViewRow: FormRow<InfoViewCell, InfoViewCellModel> {
//    public override func populate(_ cell: InfoViewCell?, viewModel: InfoViewCellModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class RetailAssetsRow: FormRow<RetailAssetsViewCell, RetailAssetsCellModel> {
//    public override func populate(_ cell: RetailAssetsViewCell?, viewModel: RetailAssetsCellModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.decideProfileAndPopulate(with: viewModel)
//    }
//}
//
//public class ExpensePackageRow: FormRow<ExpensePackage, ExpensePackageViewModel> {
//    public override func populate(_ cell: ExpensePackage?, viewModel: ExpensePackageViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class DonationListItemRow: FormRow<DonationCell, DonationListItemViewModel> {
//    public override func populate(_ cell: DonationCell?, viewModel: DonationListItemViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class BulletListRow: FormRow<BulletList, BulletListViewModel> {
//    public override func populate(_ cell: BulletList?, viewModel: BulletListViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class KeyValueCardRow: FormRow<KeyValueCardItemsCell, KeyValueCardItemsCellViewModelProtocol> {
//
//    public override func populate(_ cell: KeyValueCardItemsCell?, viewModel: KeyValueCardItemsCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//
//}
//
//public class IndividualAssetsCell: FormRow<AssetsCell, AssetsCellViewModelProtocol> {
//
//    override public func populate(_ cell: AssetsCell?, viewModel: AssetsCellViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class InformationDetailRow: FormRow<InformationDetailCell, InformationDetailCellViewModelProtocol> {
//
//    override public func populate(_ cell: InformationDetailCell?, viewModel: InformationDetailCellViewModelProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class ActionsRow: FormRow<FormActionsCell, FormActionsCellProtocol> {
//
//    override public func populate(_ cell: FormActionsCell?, viewModel: FormActionsCellProtocol?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//public class LabelImageRow: FormRow<LabelImageCell, LabelImageCellViewModelProtocol> {
//
//    public override func populate(_ cell: LabelImageCell?, viewModel: LabelImageCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class LabelLottieRow: FormRow<LabelLottieCell, LabelLottieCellViewModelProtocol> {
//
//    public override func populate(_ cell: LabelLottieCell?, viewModel: LabelLottieCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class SearchBarRow: FormRow<SearchBarCell, SearchBarCellProtocol> {
//
//    public override func populate(_ cell: SearchBarCell?, viewModel: SearchBarCellProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class MoneyTransferToMobileItemRow: FormRow<MoneyTransferToMobileItemCell, MoneyTransferToMobileItemCellViewModelProtocol> {
//
//    public override func populate(_ cell: MoneyTransferToMobileItemCell?, viewModel: MoneyTransferToMobileItemCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class PercentPickerRow: FormRow<PercentPickerCell, PercentPickerCellViewModelProtocol> {
//    public override func populate(_ cell: PercentPickerCell?, viewModel: PercentPickerCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class PercentBarRow: FormRow<PercentBarCell, PercentBarCellViewModelProtocol> {
//    public override func populate(_ cell: PercentBarCell?, viewModel: PercentBarCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class CashFlowChartRow: FormRow<CashFlowChartCell, CashFlowChartModel> {
//    override public func populate(_ cell: CashFlowChartCell?, viewModel: CashFlowChartModel?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class VgoStatusRow: FormRow<VgoStatusCell, VgoStatusViewModel> {
//    override public func populate(_ cell: VgoStatusCell?, viewModel: VgoStatusViewModel?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//    public class InfoWithIconRow: FormRow<InfoWithIconCell, InfoWithIconViewModel> {
//    override public func populate(_ cell: InfoWithIconCell?, viewModel: InfoWithIconViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class IdCardRow: FormRow<IDCardCell, IDCardCellViewModel> {
//    override public func populate(_ cell: IDCardCell?, viewModel: IDCardCellViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class KeyValueVerticalRow: FormRow<KeyValueVerticalCell, KeyValueVerticalCellViewModelProtocol> {
//    public override func populate(_ cell: KeyValueVerticalCell?, viewModel: KeyValueVerticalCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class HorizontalDetailRow: FormRow<HorizontalDetailCell, HorizontalDetailCellViewModelProtocol> {
//    public override func populate(_ cell: HorizontalDetailCell?, viewModel: HorizontalDetailCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class HorizontalRow: FormRow<HorizontalCell, HorizontalCellModel> {
//    override public func populate(_ cell: HorizontalCell?, viewModel: HorizontalCellModel?) {
//        guard let cell = cell else { return }
//        guard let viewModel = viewModel else { return }
//        cell.populate(with: viewModel)
//    }
//}
//
//public class CheckboxWithImageRow: FormRow<CheckboxWithImageCell, CheckboxWithImageCellViewModelProtocol> {
//
//    public override func populate(_ cell: CheckboxWithImageCell?, viewModel: CheckboxWithImageCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//
//    public class FundBonoRow: FormRow<FundBonoCell, FundBonoViewModelProtocol> {
//        public override func populate(_ cell: FundBonoCell?, viewModel: FundBonoViewModelProtocol?) {
//            guard let viewModel = viewModel else { return }
//            cell?.populate(with: viewModel)
//        }
//    }
//
//public class SkyCampaignRow: FormRow<SkyCampaignCell, SkyCampaignCellViewModelProtocol> {
//
//    public override func populate(_ cell: SkyCampaignCell?, viewModel: SkyCampaignCellViewModelProtocol?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class SkyImageRow: FormRow<SkyImageCell, SkyImageCellViewModel> {
//
//    public override func populate(_ cell: SkyImageCell?, viewModel: SkyImageCellViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class SkyTotalAmountRow: FormRow<SkyTotalAmountCellTableViewCell, SkyTotalAmountCellViewModel> {
//
//    public override func populate(_ cell: SkyTotalAmountCellTableViewCell?, viewModel: SkyTotalAmountCellViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class SkyComingSoonRow: FormRow<SkyComingSoonCell, SkyComingSoonCellViewModel> {
//
//    public override func populate(_ cell: SkyComingSoonCell?, viewModel: SkyComingSoonCellViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class InvoiceSummaryMenuItemRow: FormRow<InvoiceSummaryMenuItemCell, InvoiceSummaryMenuItemViewModel> {
//
//    public override func populate(_ cell: InvoiceSummaryMenuItemCell?, viewModel: InvoiceSummaryMenuItemViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
//
//public class IncomingPaymentsRow: FormRow<IncomingPaymentsCell, IncomingPaymentsViewModel> {
//
//    public override func populate(_ cell: IncomingPaymentsCell?, viewModel: IncomingPaymentsViewModel?) {
//        guard let viewModel = viewModel else { return }
//        cell?.populate(with: viewModel)
//    }
//}
