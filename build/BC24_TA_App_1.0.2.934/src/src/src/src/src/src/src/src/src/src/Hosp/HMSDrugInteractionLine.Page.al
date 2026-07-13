Page 50327 "HMS Drug Interaction Line"
{
    PageType = ListPart;
    SourceTable = "HMS Drug Interaction";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(DrugNo1; Rec."Drug No. 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drug No. 1 field.';
                }
                field(DrugName1; Rec."Drug Name 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drug Name 1 field.';
                }
                field(NotCompatible; Rec."Not Compatible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Not Compatible field.';
                }
                field(AlertRemarks; Rec."Alert Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Alert Remarks field.';
                }
            }
        }
    }

    actions { }
}

