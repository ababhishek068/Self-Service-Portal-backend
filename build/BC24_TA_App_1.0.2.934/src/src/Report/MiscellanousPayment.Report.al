report 50002 "Miscellanous Payment"
{
    ApplicationArea = All;
    Caption = 'Miscellanous Payment';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './NewLayouts/MiscellanousPayment.rdl';
    dataset
    {
        dataitem("Petty Requisition"; "Petty Requisition")
        {
            column(Amount; Amount)
            {
            }
            column(Payee; Payee)
            {
            }
            column(Purpose; Purpose)
            {
            }
            column(Req_No; Req_No)
            {
            }
            column(RequestedBy; "Requested By")
            {
            }
            column(RequisitionDate; "Requisition Date")
            {
            }
            column(Status; Status) { }
            column(logo; compinf.Picture) { }
            column(cname; compinf.Name) { }
            column(docname; docname) { }
            column(inwords; inwords) { }
            column(infigure; infigure) { }
            column(requestedbyy; requestedby) { }
            column(checkedby; checkedby) { }
            column(Approvedby; Approvedby) { }
            column(ReceivedBy; ReceivedBy) { }
            column(paymrs; paymrs) { }
            column(Purposeofpay; Purposeofpay) { }
            column(TimeRequested; "Time Requested") { }
            column(NumberText; NumberText[1]) { }
            column(CurrCode; CurrCode) { }
            trigger OnAfterGetRecord()
            begin
                CheckReport.FormatNoText(NumberText, Amount, 1033, '');

                GLSetup.Get();
                if "Petty Requisition"."Currency Code" = '' then begin
                    CurrCode := GLSetup."LCY Code";
                end else
                    CurrCode := "Petty Requisition"."Currency Code";
            end;
        }



    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        compinf.Get();
        compinf.CalcFields(Picture)
    end;

    var
        compinf: record "Company Information";
        docname: label 'Miscellaneous Payment-Requisition Form';
        inwords: label 'Amount in words';
        infigure: label 'In figure';
        requestedby: label 'Requested by';
        checkedby: label 'Checked By';
        Approvedby: label 'Approved By';
        ReceivedBy: label 'Received By';
        paymrs: label 'Pay to Mr/Mrs';
        Purposeofpay: label 'Purpose of Payment';
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[80];
        GLSetup: Record "General Ledger Setup";
        CurrCode: code[10];

}
