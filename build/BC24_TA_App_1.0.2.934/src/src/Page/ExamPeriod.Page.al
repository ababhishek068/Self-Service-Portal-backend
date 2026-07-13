Page 50020 "Exam Period"
{
    PageType = List;
    SourceTable = "Exam Periods";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(ExamPeriod; Rec."Exam Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Period field.';
                }
                field(GraduationDate; Rec."Graduation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Graduation Date field.';
                }
            }
        }
    }

    actions { }
}

