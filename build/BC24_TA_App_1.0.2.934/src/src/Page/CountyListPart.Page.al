page 50273 "Region List Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Region;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Target; Rec.Target)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target field.';

                }
                field(Achieved; Rec.Achieved)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Achieved field.';

                }
                field(PercAchieved; PercAchieved)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PercAchieved field.';

                }
            }
        }

    }
    trigger OnAfterGetCurrRecord()
    begin
        Rec.calcfields(Achieved);
        PercAchieved := 0;
        if Rec.target > 0 then begin
            PercAchieved := (Rec.Achieved / Rec.Target) * 100;

        end
    end;

    var
        PercAchieved: decimal;
}