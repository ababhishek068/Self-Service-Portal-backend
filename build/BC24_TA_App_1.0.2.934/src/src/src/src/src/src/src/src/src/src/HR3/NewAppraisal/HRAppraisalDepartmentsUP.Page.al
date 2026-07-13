Page 51090 "HR Appraisal Departments - UP"
{
    Caption = 'HR Appraisal Departmental Objectives';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = "Dimension Value";
    SourceTableView = where("Global Dimension No." = const(1));
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
                    ToolTip = 'Specifies the code for the dimension value.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a descriptive name for the dimension value.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000005; Notes) { }
        }
    }

    actions
    {
        area(processing)
        {
            action("Department Objectives")
            {
                ApplicationArea = Basic;
                Image = Answers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Appraisal Dept. Obj. Setup";
                RunPageLink = "Department Code" = field(Code);
                ToolTip = 'Executes the Department Objectives action.';
            }
        }
    }
}

