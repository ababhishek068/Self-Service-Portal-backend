pageextension 50033 "Sales Header" extends "Sales Invoice"
{
    layout
    {
        addafter("Work Description")
        {
            field("Posting Description1"; Rec."Posting Description")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
            }
        }
        addafter("Invoice Details")
        {
            group("Receipt Details")
            {
                field("Cash Sale"; Rec."Cash Sale")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cash Sale field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Bank Account No field.';
                }
                field("Transaction No"; Rec."Transaction No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Transaction No field.';
                }
            }
        }
    }

    actions
    {
        modify(PostAndNew)
        {
            Visible = false;
        }
        modify(PostAndSend)
        {
            Visible = false;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                CashOfficeSetup: Record "Cash Office Setup";
                Cust: Record Customer;

            begin
                CashOfficeSetup.get;
                Cust.get(Rec."Bill-to Customer No.");
                if (Cust."Cash Customer" = true) or (CashOfficeSetup."Cash Sale Customer No" = Rec."Bill-to Customer No.") then begin
                    if CashOfficeSetup."Cash Sale Invoice Nos" <> '' then begin
                        Rec.TestField("Bank Account No");
                        Rec.TestField("Pay Mode");
                        Rec."Posting No. Series" := CashOfficeSetup."Cash Sale Invoice Nos";
                        Rec.Modify;
                    end;
                end;
                Rec.validate("Shortcut Dimension 1 Code");
                Rec.validate("Shortcut Dimension 2 Code");
            end;

            trigger OnAfterAction()
            var
                SalesInv: Record "Sales Invoice Header";
                SalesLine: Record "Sales Line";
                SalesInvLine: Record "Sales Invoice Line";
                item: Record Item;
                invetorypostgrp: Record "Inventory Posting Group";
                CashOfficeSetup: Record "Cash Office Setup";
                FundCU: codeunit "Funds Mgt Functions";

            begin
                SalesInv.reset;
                SalesInv.setrange("Pre-Assigned No.", Rec."No.");
                if SalesInv.find('-') then begin
                    SalesInv."Shift No" := Rec."Shift No";
                    SalesInv."Sales Person" := Rec."Sales Person";
                    SalesInv."Bank Account No" := Rec."Bank Account No";
                    SalesInv."Pay Mode" := Rec."Pay Mode";
                    SalesInv."Cash Sale" := Rec."Cash Sale";
                    SalesInv."Transaction No" := Rec."Transaction No";
                    SalesInv.modify;

                    SalesLine.reset;
                    SalesLine.setrange("Document No.", SalesInv."No.");
                    if SalesLine.find('-') then begin
                        repeat
                            if SalesLine.Type = SalesLine.Type::Item then begin
                                if CashOfficeSetup.Get() then
                                    if item.get(Salesline."No.") then begin
                                        invetorypostgrp.Reset();
                                        invetorypostgrp.SetRange(code, item."Inventory Posting Group");
                                        if invetorypostgrp.find('-') then
                                            //  SalesLine.TestField(SalesLine."Truck No");
                                            //  SalesLine.TestField(SalesLine."Driver No");
                                            SalesInvLine.reset;
                                        SalesInvLine.setrange("Document No.", SalesLine."Document No.");
                                        SalesInvLine.setrange("No.", SalesLine."No.");
                                        if SalesInvLine.find('-') then
                                            SalesInvLine."Driver No" := SalesLine."Shipping Agent Service Code";
                                        SalesInvLine."Truck No" := SalesLine."Shipping Agent Code";

                                        SalesInvLine.Modify();
                                    end;

                            end;
                        until SalesLine.Next = 0;
                    end;
                end;
                SalesInv.reset;
                SalesInv.setrange("Pre-Assigned No.", Rec."No.");
                if SalesInv.find('-') then begin
                    SalesInv.calcfields("Total Amount");
                    if SalesInv."Cash Sale" = true then begin
                        FundCU.CreateReceipt(SalesInv."Bill-to Customer No.", SalesInv."No.", SalesInv."Total Amount", SalesInv."Bank Account No", SalesInv."Pay Mode", SalesInv."Transaction No", true)
                    end else begin
                        if confirm('Do you want to generate the receipt?', false) then
                            FundCU.CreateReceipt(SalesInv."Bill-to Customer No.", SalesInv."No.", SalesInv."Total Amount", SalesInv."Bank Account No", SalesInv."Pay Mode", SalesInv."Transaction No", false);
                    end;
                end;

            end;
        }
    }


}



