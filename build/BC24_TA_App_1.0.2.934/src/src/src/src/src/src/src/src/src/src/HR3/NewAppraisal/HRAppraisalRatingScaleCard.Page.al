Page 51100 "HR Appraisal Rating Scale Card"
{
    PageType = Card;
    SourceTable = "HR Appraisal Rating Scale - UP";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field("Rating Scale"; Rec."Rating Scale")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rating Scale field.';
                }
                field("Score Option"; Rec."Score Option")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score Option field.';
                }
                field("Rating Descriptors"; Rec."Rating Descriptors")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rating Descriptors field.';
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000007; Notes) { }
        }
    }

    actions { }
}

