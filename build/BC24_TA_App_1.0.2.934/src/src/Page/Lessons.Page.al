Page 50114 Lessons
{
    PageType = List;
    SourceTable = Lessons;
    ApplicationArea = All;

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
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Descrition; Rec.Descrition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Descrition field.';
                }
                field(FullTimePartTime; Rec."Full Time/Part Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Full Time/Part Time field.';
                }
                field(StartTime; Rec."Start Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Time field.';
                }
                field(EndTime; Rec."End Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Time field.';
                }
                field(NoOfHours; Rec."No Of Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No Of Hours field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }

            }
        }
    }

    actions { }
}

