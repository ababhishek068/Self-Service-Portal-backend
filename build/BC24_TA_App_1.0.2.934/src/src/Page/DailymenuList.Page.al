Page 50742 "Daily menu List"
{
    CardPageID = "Daily Menu";
    Editable = false;
    PageType = List;
    SourceTable = "Daily Menu";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Menu; Rec.Menu)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Menu field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Units field.';
                }
                field(TotalQty; Rec."Total Qty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Qty field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(RemainingQty; Rec."Remaining Qty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remaining Qty field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Menu Date", Today);
    end;
}

