query 50085 "Store Requisition Lines"
{
    Caption = 'Store Requisition Lines';
    QueryType = Normal;

    elements
    {
        dataitem(StoreRequistionLines; "Store Requistion Lines")
        {
            column(ActionType; "Action Type") { }
            column(ActualExpenditure; "Actual Expenditure") { }
            column(BudgetBalance; "Budget Balance") { }
            column(BudgetName; "Budget Name") { }
            column(Committed; Committed) { }
            column(CurrentActualsAmount; "Current Actuals Amount") { }
            column(CurrentMonthBudget; "Current Month Budget") { }
            column(Description; Description) { }
            column(Description2; "Description 2") { }
            column(IssueQuantity; "Issue Quantity") { }
            column(IssuingStore; "Issuing Store") { }
            column(LastDateofIssue; "Last Date of Issue") { }
            column(LastQuantityIssued; "Last Quantity Issued") { }
            column(LineAmount; "Line Amount") { }
            column(LineNo; "Line No.") { }
            column(LotNo; "Lot No.") { }
            column(No; "No.") { }
            column(Qtyinstore; "Qty in store") { }
            column(Quantity; Quantity) { }
            column(QuantityIssued; "Quantity Issued") { }
            column(QuantityRequested; "Quantity Requested") { }
            column(QuantityToIssue; "Quantity To Issue") { }
            column(Remarks; Remarks) { }
            column(RequestStatus; "Request Status") { }
            column(RequistionNo; "Requistion No") { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TempJournalNo; "Temp. Journal No.") { }
            column(TotalBudget; "Total Budget") { }
            column("Type"; "Type") { }
            column(UnitCost; "Unit Cost") { }
            column(UnitofMeasure; "Unit of Measure") { }
            column(VoteAccount; "Vote Account") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
