Page 50225 "Grant Surr List"
{
    CardPageID = "Grant Surrender";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Grant Surrender Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(SurrenderDate; Rec."Surrender Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(PayMode; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field(ChequeNo; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No field.';
                }
            }
        }
    }

    actions { }
}

