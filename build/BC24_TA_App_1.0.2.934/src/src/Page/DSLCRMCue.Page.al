Page 50283 "DSL CRM Cue"
{
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = Contracts;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(Membership)
            {
                Caption = 'Membership';
                // field("Prospect Members"; "Prospect Members")
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Prospect Members';
                //     DrillDownPageID = "Prospect Member List";
                // }
                // field("Active Members"; "Active Members")
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Active Members';
                //     DrillDownPageID = "Member List";
                // }
                // field("Inactive Members"; "Inactive Members")
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Inactive Members';
                //     DrillDownPageID = "Inactive Member List";
                // }
            }
        }
    }

    //     actions
    //     {
    // Report "Imprest Requisition";
    // Report UnknownReport39005485;
    // Report "Staff Claims Voucher.";
    // Report "Consolidated Procurement Plan";
    // Report "Interbank Details";
    // Report "Food Receipt";
    // Report "Receipts Collections2";
    // Report "Visitors Report";
    // Report "Catering Sales Per Items";
    // Report "PR Company Payslip - II";
    // Report "HMS Laboratory Test Summary";
    // Page "Partners List";
    // Report "HMS Drug Expiration Report";
    // Report "HMS Patient Prescription";
    // Report UnknownReport70135343;
    // Report UnknownReport70135344;
    // Report "HR Employee Per Dimension";
    // Report "Employee Change History";
    // Report "HR Employee Per Dept";
    // Codeunit ""
}
