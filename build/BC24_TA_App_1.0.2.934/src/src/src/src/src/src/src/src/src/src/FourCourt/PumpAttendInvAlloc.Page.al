page 51402 "Pump Attend. Inv. Alloc."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Pump Attend. Invoice Alloc.";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No field.';

                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fuel Type field.';

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';

                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }

                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';

                }
                field("Sale Unit Price"; Rec."Sale Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sale Unit Price field.';
                }
                field("Reg No."; Rec."Reg No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reg No. field.';

                }
                field("Driver Names"; Rec."Driver Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driver Names field.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';

                }
                field(Suggested; Rec.Suggested)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Suggested field.';

                }
            }
        }
        area(Factboxes) { }
    }
    actions
    {
        area(Processing)
        {
            action(SuggestInv)
            {
                Caption = 'Suggest Invoices';
                Image = Suggest;
                ApplicationArea = basic;
                ToolTip = 'Executes the Suggest Invoices action.';
                trigger OnAction()
                var
                    SalesInv: Record "Sales Invoice Header";
                    SalesLine: record "Sales Invoice Line";
                    PumpReading: Record "Pump Reading Header";
                    InvAlloc: Record "Pump Attend. Invoice Alloc.";
                    Ln: integer;
                begin
                    if PumpReading.get(Rec.No) then begin
                        InvAlloc.reset;
                        InvAlloc.setrange(No, Rec.No);
                        InvAlloc.setrange(Suggested, true);
                        if InvAlloc.find('-') then
                            InvAlloc.DeleteAll();

                        SalesInv.reset;
                        SalesInv.SetRange("Shift No", PumpReading."Shift No");
                        SalesInv.SetRange("Sales Person", PumpReading."Staff No");
                        if SalesInv.find('-') then begin
                            repeat
                                SalesLine.reset;
                                SalesLine.SetRange("Document No.", SalesInv."No.");
                                if SalesLine.Find('-') then begin
                                    repeat
                                        Ln := Ln + 1;
                                        InvAlloc.init;
                                        InvAlloc."Customer No" := SalesInv."Sell-to Customer No.";
                                        InvAlloc.Names := SalesInv."Bill-to Name";
                                        InvAlloc."Fuel Type" := SalesLine."No.";
                                        InvAlloc.validate("Fuel Type");
                                        InvAlloc.No := Rec.No;
                                        InvAlloc.Amount := SalesLine."Line Amount";
                                        InvAlloc."Sale Unit Price" := SalesLine."Unit Price";
                                        InvAlloc."Line No" := Ln;
                                        InvAlloc."Shift No" := PumpReading."Shift No";
                                        InvAlloc."Staff No" := PumpReading."Staff No";
                                        InvAlloc.Quantity := SalesLine.Quantity;
                                        InvAlloc."Reg No." := SalesLine."Truck No";
                                        InvAlloc."Driver Names" := SalesLine."Driver No";
                                        InvAlloc.Suggested := true;
                                        InvAlloc."Suggested Inv No." := SalesInv."No.";

                                        InvAlloc.insert;
                                    until SalesLine.next = 0;
                                end;
                            until SalesInv.next = 0;
                        end;
                    end;
                end;
            }
        }
    }

}