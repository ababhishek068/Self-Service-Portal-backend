page 51452 "Petty Cash Card"
{
    ApplicationArea = All;
    Caption = 'Petty Cash Card';
    PageType = Card;
    SourceTable = "Petty Requisition";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Req_No; Rec.Req_No)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Req_No field.', Comment = '%';
                }
                field(Payee; Rec.Payee)
                {
                    ToolTip = 'Specifies the value of the Payee field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                }
                field("Currency Code"; "Currency Code")
                {
                    ToolTip = 'Specifies the currency.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ToolTip = 'Specifies the value of the Requisition Date field.', Comment = '%';
                }
                field("Time Requested"; Rec."Time Requested")
                {
                    ToolTip = 'Specifies the value of the Time Requested field.', Comment = '%';
                }
                field(Status; Status)
                {
                    ToolTip = 'Specifies the approval status.', Comment = '%';
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Print Miscellaneous Payment")
            {
                Caption = 'Print/Preview';
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Approved);
                    Rec.Reset;
                    Rec.SetFilter(Req_No, Rec.Req_No);
                    if rec.FindFirst() then begin
                        REPORT.Run(50002, true, false, Rec);
                    end;

                end;
            }


        }




    }
    var

    // Rec: Record "Petty Requisition";



}