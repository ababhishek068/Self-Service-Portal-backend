page 50214 "Procurement Methods List"
{
    // version W/P

    CardPageID = "Procurement Methods Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    //Editable = false;
    PageType = List;
    SourceTable = "Procurement Methods";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }

        }
    }


}

