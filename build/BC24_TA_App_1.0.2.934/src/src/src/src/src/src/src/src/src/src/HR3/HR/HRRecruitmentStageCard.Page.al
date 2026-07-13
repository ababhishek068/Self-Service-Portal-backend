page 51006 "HR Recruitment  Stage Card"
{
    PageType = Card;
    SourceTable = "HR Recruitment Stages";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Job)
            {
                action(Requirements)
                {
                    Caption = 'Requirements';
                    ApplicationArea = basic;
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HR Stage Requirement Lines";
                    RunPageLink = "Stage Code" = FIELD(Code);
                    ToolTip = 'Executes the Requirements action.';
                }
            }
        }
    }
}

