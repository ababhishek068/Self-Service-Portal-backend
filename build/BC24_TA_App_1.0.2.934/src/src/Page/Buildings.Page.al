page 50977 Buildings
{
    PageType = List;
    SourceTable = Building;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {

            action("Lecture Rooms")
            {
                ApplicationArea = basic;
                Caption = 'Lecture Rooms';
                RunObject = Page "Lecture Rooms";
                RunPageLink = "Building Code" = FIELD(Code);
                ToolTip = 'Executes the Lecture Rooms action.';
            }
            separator(Separator1102760000) { }
            action(Labs)
            {
                ApplicationArea = basic;
                Caption = 'Labs';
                RunObject = Page "Lecture Rooms - Labs";
                RunPageLink = "Building Code" = FIELD(Code);
                ToolTip = 'Executes the Labs action.';
            }

        }
    }
}

