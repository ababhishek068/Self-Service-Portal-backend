Page 50724 "HR Leave Types List"
{
    CardPageID = "HR Leave Types Card";
    Editable = false;
    PageType = List;
    SourceTable = "HR Leave Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
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
                field(Days; Rec.Days)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Days field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755003; Outlook) { }
            systempart(Control1102755004; Notes) { }
        }
    }

    actions { }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

