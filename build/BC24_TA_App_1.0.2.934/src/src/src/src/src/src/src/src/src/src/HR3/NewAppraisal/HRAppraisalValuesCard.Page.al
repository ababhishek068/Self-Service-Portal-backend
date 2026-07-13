Page 51116 "HR Appraisal Values - Card"
{
    Caption = 'HR Appraisal Values & Competences';
    PageType = Card;
    SourceTable = "HR Appraisal Val and Compt-UP";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000004; Notes) { }
        }
    }

    actions { }
}

