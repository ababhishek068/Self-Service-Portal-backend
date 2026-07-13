Page 51257 "HR Appraisal Dept. Obj. Setup"
{
    Caption = 'HR Appraisal Departmental Objectives Setup';
    PageType = List;
    SourceTable = "HR Appraisal Dept. Obj. Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Perspective Type"; Rec."Perspective Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Perspective Type field.';
                }
                field("Perspective Description"; Rec."Perspective Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Perspective Description field.';
                }
                field("Objective Code"; Rec."Objective Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objective Code field.';
                }
                field("Objective Description"; Rec."Objective Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objective Description field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000003; Notes) { }
        }
    }

    actions { }
}

