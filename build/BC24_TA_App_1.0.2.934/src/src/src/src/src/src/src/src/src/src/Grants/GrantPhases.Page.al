Page 50084 "Grant Phases"
{
    CardPageID = "Grant Phase Card";
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = "Grant Phases";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(DisbursementDate; Rec."Technical Reporting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disbursement Date';
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                }
                field(NextDisbursmentdueDate; Rec."Financial Reporting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Next Disbursment due Date';
                    ToolTip = 'Specifies the value of the Next Disbursment due Date field.';
                }
            }
        }
    }

    actions { }
}

