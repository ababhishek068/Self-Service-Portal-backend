query 50084 "Store Requisitions Header"
{
    Caption = 'Store Requisitions Header';
    QueryType = Normal;

    elements
    {
        dataitem(StoreRequistionHeader; "Store Requistion Header")
        {
            column(ActionType; "Action Type") { }
            column(ActualExpenditure; "Actual Expenditure") { }
            column(BudgetBalance; "Budget Balance") { }
            column(BudgetCenterName; "Budget Center Name") { }
            column(BudgetedAmount; "Budgeted Amount") { }
            
            column(Committed; Committed) { }
            column(CommittedAmount; "Committed Amount") { }
            column(Dim3; Dim3) { }
            column(Dim4; Dim4) { }
            column(EmployeeNo; "Employee No") { }
            column(FunctionName; "Function Name") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(IgnoreRespCenter; "Ignore Resp. Center") { }
            column(IsHOD; "Is HOD") { }
            column(IsProject; "Is Project") { }
            column(IssueDate; "Issue Date") { }
            column(IssuingStore; "Issuing Store") { }
            column(Justification; Justification) { }
            column(No; "No.") { }
            column(NoSeries; "No. Series") { }
            column(RequestDescription; "Request Description") { }
            column(Requestdate; "Request date") { }
            column(RequesterID; "Requester ID") { }
            column(RequiredDate; "Required Date") { }
            column(RequisitionType; "Requisition Type") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(SRNNo; "SRN.No") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(Status; Status) { }
            column(StoreRequisitionType; "Store Requisition Type") { }
            column(Supplier; Supplier) { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column("TestField"; "Test Field") { }
            column(TotalAmount; TotalAmount) { }
            column(UserID; "User ID") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
