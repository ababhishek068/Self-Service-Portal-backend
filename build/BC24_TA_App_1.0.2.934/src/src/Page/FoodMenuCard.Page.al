Page 50735 "Food Menu Card"
{
    PageType = Document;
    SourceTable = "Food Menu";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ItemsCost; Rec."Items Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Items Cost field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';

                    trigger OnValidate()
                    begin
                        Rec.Amount := (Rec."Unit Cost" * Rec.Quantity) + Rec."Items Cost";
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';

                    trigger OnValidate()
                    begin
                        Rec.Amount := Rec."Unit Cost" + Rec."Items Cost";
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';

                    trigger OnValidate()
                    begin
                        Rec.Amount := (Rec."Unit Cost" * Rec.Quantity) + Rec."Items Cost";
                    end;
                }
                field(UnitsOfMeasure; Rec."Units Of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Units Of Measure field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                group(Line)
                {
                    part(Control1000000002; "Food Menu Line")
                    {
                        ApplicationArea = basic;
                        Caption = 'Recipe';
                        SubPageLink = Menu = field(Code),
                                  Type = field(Type);
                    }
                }
            }
        }
    }

    actions { }

    trigger OnModifyRecord(): Boolean
    begin
        Rec.Amount := Rec."Items Cost" + Rec."Unit Cost";
    end;

    local procedure AmountOnInputChange(var Text: Text[1024])
    begin
        Rec.Amount := Rec."Unit Cost" + Rec."Items Cost";
    end;
}

