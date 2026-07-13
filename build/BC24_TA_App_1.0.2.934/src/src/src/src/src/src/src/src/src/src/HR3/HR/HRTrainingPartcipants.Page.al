Page 50608 "HR Training Partcipants"
{
    PageType = List;
    SourceTable = "HR Training Participants";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TrainingCode; Rec."Training Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Code field.';
                }
                field(EmployeeCode; Rec."Employee Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }
                field(Employeename; Rec."Employee name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee name field.';
                }
                field(Objectives; Rec.Objectives)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objectives field.';
                }
            }
        }
    }

    actions { }
}

