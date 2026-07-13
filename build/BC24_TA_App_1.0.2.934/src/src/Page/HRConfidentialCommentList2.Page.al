page 50189 "HR Confidential Comment List2"
{
    SourceTable = "HR Confidential Information2";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Confidential Code"; Rec."Confidential Code")
                {
                    ToolTip = 'Specifies the value of the Confidential Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                }

            }
        }
    }

}