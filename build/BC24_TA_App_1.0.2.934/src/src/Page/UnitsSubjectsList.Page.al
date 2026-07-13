Page 51139 "Units/Subjects List"
{
    PageType = List;
    SourceTable = "Units/Subjects";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Code field.';
                }
                field(Desription; Rec.Desription)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Desription field.';
                }
                field(Prerequisite; Rec.Prerequisite)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prerequisite field.';
                }
                field(CommonUnit; Rec."Common Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Common Unit field.';
                }
                field(StageCode; Rec."Stage Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field(CreditHours; Rec."Credit Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Credit Hours field.';
                }
                field("Unit Category"; Rec."Unit Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Category field.';
                }
                field(GLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(RelatedCourse; Rec."Related Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Related Course field.';
                }


                field(TotalIncome; Rec."Total Income")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Income field.';
                }
                field(StudentsRegistered; Rec."Students Registered")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Students Registered field.';
                }
                field(UnitType; Rec."Unit Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Type field.';
                }
            }
        }
    }

    actions { }
}

