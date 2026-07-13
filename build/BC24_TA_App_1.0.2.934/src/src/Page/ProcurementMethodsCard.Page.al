page 50222 "Procurement Methods Card"
{
    // version W/P

    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Procurement Methods";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Rec.Code)
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

            part("Procurement Methods Sub Page"; "Procurement Methods Sub Page")
            {
                // SubPageLink = "Procurement Method" = FIELD(Code);
                ApplicationArea = All;
            }



        }
    }

}
