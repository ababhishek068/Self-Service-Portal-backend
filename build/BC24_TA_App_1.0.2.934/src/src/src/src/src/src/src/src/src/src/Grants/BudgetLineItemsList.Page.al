Page 51174 "Budget Line Items List"
{
    PageType = List;
    SourceTable = "Budget Line Items";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Use; Rec.Use)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Use field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
            }
        }
    }

    actions { }
}

