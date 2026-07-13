page 50654 "Leave Family Groups"
{
    PageType = List;
    SourceTable = "Leave Family Groups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Remarks"; Rec.Remarks)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Leave Days field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Leave Family Members")
            {
                ApplicationArea = basic;
                Promoted = true;
                Image = Lot;
                RunObject = Page "Leave Family Employees";
                RunPageLink = Family = FIELD(Code);
                ToolTip = 'Executes the Leave Family Members action.';
            }
        }
    }

}

