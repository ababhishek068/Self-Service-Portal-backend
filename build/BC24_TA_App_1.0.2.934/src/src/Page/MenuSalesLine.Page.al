Page 50741 "Menu Sales Line"
{
    PageType = ListPart;
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

                        DailyMenu.Reset;
                        DailyMenu.SetRange(DailyMenu.Menu, Rec.Menu);
                        //  DailyMenu.SETRANGE(DailyMenu."Menu Date",TODAY);
                        //DailyMenu.SETRANGE(DailyMenu.Type,DailyMenu.Type::Student);
                        if DailyMenu.Find('-') then begin
                            if DailyMenu."Remaining Qty" < 1 then begin
                                // ERROR('The Selected Menu Item is Out Of Stock')
                            end
                            else begin
                                Rec."Unit Cost" := DailyMenu."Unit Cost";
                                Rec.Quantity := 1;
                                Rec.Amount := DailyMenu."Unit Cost";
                                Rec.Description := DailyMenu.Description;
                            end;
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';

                    trigger OnValidate()
                    begin
                        Rec.Amount := Rec.Quantity * Rec."Unit Cost";
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }

    actions { }

    var
        DailyMenu: Record "Daily Menu";
}

