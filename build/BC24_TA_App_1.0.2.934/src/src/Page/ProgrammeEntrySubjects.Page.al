Page 50312 "Programme Entry Subjects"
{
    PageType = List;
    SourceTable = "Programme Entry Subjects";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Subject field.';
                }
                field(MinimumGrade; Rec."Minimum Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Grade field.';
                }
                field(MinimumPoints; Rec."Minimum Points")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Points field.';
                }
            }
        }
    }

    actions { }
}

