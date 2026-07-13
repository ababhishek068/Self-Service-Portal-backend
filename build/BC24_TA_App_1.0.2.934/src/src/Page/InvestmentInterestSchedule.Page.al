Page 50244 "Investment Interest Schedule"
{
    PageType = List;
    SourceTable = "Investment Interest Schedule";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Investment No."; Rec."Investment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment No. field.';
                }
                field("Archived Versions"; Rec."Archived Versions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Archived Versions field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Interest Calculated"; Rec."Interest Calculated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Calculated field.';
                }
                field("Investment Withholding Tax"; Rec."Investment Withholding Tax")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Withholding Tax field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
            }
        }
    }

    actions { }
}

