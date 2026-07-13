pageextension 50025 "Sales Order Subform ext" extends "Sales Order Subform"
{
    layout
    {
        addafter("Location Code")
        {
            // field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            // {
            //     ApplicationArea = basic;
            // }
        }

        addafter("Qty. to Invoice")
        {
            field("Qty to Invoice Forced"; Rec."Qty to Invoice Forced")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Qty to Invoice Forced field.';
            }
        }

        addafter(Quantity)
        {
            // field("Unit Volume"; "Unit Volume")
            // {
            //     Caption = 'Observed Qty';
            // }
        }

        addafter("Gen. Prod. Posting Group")
        {
            field("Shipping Agent Code1"; Rec."Shipping Agent Code")
            {
                Caption = 'Vessel';
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
            }
        }
    }

    actions
    {
        addAfter("Co&mments")
        {
            action("Required Materials")
            {
                ApplicationArea = basic;
                image = SuggestItemPrice;
                ToolTip = 'Executes the Required Materials action.';
                trigger onAction()
                var
                    ItemMat: Record "Prod. Item Material";
                    SalesLine: Record "Sales Line";
                    OrderItemMat: Record "Prod.Order Item Material";
                    OrderItemMatPage: page "Prod. Order Item Material";
                    Ln: Integer;
                begin
                    OrderItemMat.reset;
                    OrderItemMat.setrange("Order No", Rec."Document No.");
                    if OrderItemMat.find('-') then
                        OrderItemMat.DeleteAll();

                    SalesLine.reset;
                    SalesLine.setrange("Document No.", Rec."Document No.");
                    SalesLine.setrange(Type, SalesLine.Type::Item);
                    if SalesLine.find('-') then begin
                        repeat
                            ItemMat.reset;
                            ItemMat.setrange("Item No", SalesLine."No.");
                            if ItemMat.find('-') then begin
                                repeat
                                    Ln := Ln + 1;
                                    OrderItemMat.init;
                                    OrderItemMat."Order No" := Rec."Document No.";
                                    OrderItemMat."Item No" := SalesLine."No.";
                                    OrderItemMat."Material Code" := ItemMat."Material Code";
                                    OrderItemMat.Description := ItemMat.Description;
                                    OrderItemMat.Quantity := ItemMat.Quantity;
                                    OrderItemMat."Line No" := Ln;
                                    OrderItemMat.insert;
                                until itemMat.next = 0;
                            end;
                        until SalesLine.next = 0;
                    end;
                    OrderItemMat.reset;
                    OrderItemMat.setrange("Order No", Rec."Document No.");
                    if OrderItemMat.find('-') then begin
                        OrderItemMatPage.SetTableView(OrderItemMat);
                        OrderItemMatPage.Run();
                    end;
                end;

            }
        }
    }


}