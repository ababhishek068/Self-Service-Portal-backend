Page 50446 "Days Of Week"
{
    PageType = List;
    SourceTable = "Day Of Week";
    ApplicationArea = All;
    // SourceTableView = where(Exams = const(false));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Exams; Rec.Exams)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exams field.';
                }


            }
        }
    }

    actions { }
}

