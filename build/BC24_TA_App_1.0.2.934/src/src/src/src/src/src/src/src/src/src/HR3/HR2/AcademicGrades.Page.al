Page 51171 "Academic Grades"
{
    PageType = List;
    SourceTable = "Academic Qua Grades";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(QualificationLevel; Rec."Qualification Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Level field.';
                }
                field(GradeCode; Rec."Grade Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions { }
}

