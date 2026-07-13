Page 50453 "Project areas of focus new"
{
    Caption = 'Select areas of focus that apply to yiour study';
    PageType = ListPart;
    SourceTable = "Project Study areas new";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Invcode; Rec."Inv. code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Inv. code field.';
                }
                field(AreaofFocus; Rec."Area of Focus")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Area of Focus field.';
                }
            }
        }
    }

    actions { }
}

