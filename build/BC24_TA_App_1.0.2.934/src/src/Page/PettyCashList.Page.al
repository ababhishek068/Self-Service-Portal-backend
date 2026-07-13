page 50483 "Petty Cash List"
{
    ApplicationArea = All;
    Caption = 'Petty Cash List';
    PageType = List;
    CardPageId = "Petty Cash Card";
    SourceTable = "Petty Requisition";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Req_No; Rec.Req_No)
                {
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
                    ToolTip = 'Specifies the approval status';
                }

            }
        }
    }
}
