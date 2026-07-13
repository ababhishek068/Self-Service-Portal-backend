Page 50736 "Food Menu Line"
{
    Editable = true;
    PageType = ListPart;
    SourceTable = "Food Menu Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(ItemNo; Rec."Item No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No field.';

                    trigger OnValidate()
                    begin
                        Item.SetRange(Item."No.", Rec."Item No");
                        if Item.Find('-') then begin
                            Rec.Description := Item.Description;
                            Rec.Units := Item."Base Unit of Measure";
                            Rec."Unit Cost" := Item."Last Direct Cost";
                            Rec.Location := 'KITCHEN';
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';

                    trigger OnValidate()
                    begin
                        Rec."Total Cost" := Rec."Unit Cost" * Rec.Quantity;
                    end;
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Units field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';

                    trigger OnValidate()
                    begin
                        Rec."Total Cost" := Rec."Unit Cost" * Rec.Quantity;
                    end;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field(Menu; Rec.Menu)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Menu field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }
        }
    }

    actions { }

    var
        Item: Record Item;
}

