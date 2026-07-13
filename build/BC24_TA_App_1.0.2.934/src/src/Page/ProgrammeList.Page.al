Page 50313 "Programme List"
{


    SourceTable = Programme;
    CardPageId = Programmes;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = basic;
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Main Programme Code"; Rec."Main Programme Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Main Programme Code field.';
                }
                field("Programme Cluster"; Rec."Programme Cluster")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Cluster field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(ExamCategory; Rec."Exam Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Category field.';
                }
                field("Graduation Units"; Rec."Graduation Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Graduation Units field.';
                }
                field("Teaching Weeks"; Rec."Teaching Weeks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Teaching Weeks field.';
                }
                field("Old Carriculum"; Rec."Old Carriculum")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Old Carriculum field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(SchoolCode; Rec."School Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the School Code field.';
                }


                field(Dean; Rec.Dean)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dean field.';
                }
                field("Minimum Grade"; Rec."Minimum Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Grade field.';
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Semesters)
            {
                ApplicationArea = Basic;
                Caption = 'Semesters';
                Ellipsis = true;
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Programme Semesters";
                RunPageLink = "Programme Code" = field(Code);
                ToolTip = 'Executes the Semesters action.';
            }
            action(StudImp)
            {
                ApplicationArea = Basic;
                Caption = 'Import Students';
                Ellipsis = true;
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Import Students action.';
                //RunObject = Page "Stud Imp";
                //  RunPageLink = "Programme Code" = field(Code);
            }
        }
    }
}

