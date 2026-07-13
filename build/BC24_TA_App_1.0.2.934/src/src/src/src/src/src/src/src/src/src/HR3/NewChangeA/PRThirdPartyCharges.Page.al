page 51333 "PR Third Party Charges"
{

    ApplicationArea = All;
    Caption = 'PR Third Party Charges';
    PageType = List;
    SourceTable = "PR Third Party Charges";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }

                field("Charge Per Transaction"; Rec."Charge Per Transaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Per Transaction field.';
                }

            }
        }
    }

}
