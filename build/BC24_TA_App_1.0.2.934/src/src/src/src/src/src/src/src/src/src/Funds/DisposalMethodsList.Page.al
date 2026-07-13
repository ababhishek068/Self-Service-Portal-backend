Page 50809 "Disposal Methods List"
{
    PageType = List;
    SourceTable = "Disposal Methods";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DisposalMethods; Rec."Disposal Methods")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Methods field.';
                }
                field(DisposalDescription; Rec."Disposal Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Description field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
            }
        }
    }

    actions { }
}

