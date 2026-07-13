Page 51098 "HR Appraisal Perspectives"
{
    PageType = List;
    SourceTable = "HR Appraisal Pespectives";
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Perspective Type"; Rec."Perspective Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Perspective Type field.';
                }
                field("Perspective Description"; Rec."Perspective Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Perspective Description field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
            }
        }
    }

    actions { }
}

