Page 50744 "Menu Sales Line Staff"
{
    PageType = List;
    SourceTable = "Menu Sales Line";
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
                    LookupPageID = "Daily menu List";
                    ToolTip = 'Specifies the value of the Menu field.';

                    trigger OnValidate()
                    begin
                        DailyMenu.SetRange(DailyMenu.Menu, Rec.Menu);
                        DailyMenu.SetRange(DailyMenu."Menu Date", Today);
                        if DailyMenu.Find('-') then begin
                            Rec."Unit Cost" := DailyMenu."Unit Cost"
                        end;
                    end;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }

    actions { }

    var
        DailyMenu: Record "Daily Menu";
}

