report 50317 "Legal Management"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Legal Management"; "Legal Management")
        {
            RequestFilterFields = Status;
            column(No; No) { }

            column(Requestdate; "Request date") { }
            column(RequiredDate; "Required Date") { }
            column(RequestCategory; "Visitor Category") { }
            column(Control16; "Visitor Number") { }
            column(Name; "Visitor Name") { }
            column(IDNumber; "ID Number") { }
            column(Department; Department) { }
            column(PhoneNumber; "Phone Number") { }
            column(Description; "Purpose of Visit") { }
            column(LitigationStatus; "Litigation Status") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(FunctionName; "Function Name") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(DepartmentName; "Budget Center Name") { }
            column(Status; Status) { }
            column(ConcernedDepartmentNotified; "Concerned Department Notified") { }
            column(DocumentsAttached; "Documents Attached?") { }
            column(InitiatedBy; "Initiated By") { }
            column(ClearedBy; "Cleared By") { }
            column(IssueDate; "Issue Date") { }
        }
    }









}