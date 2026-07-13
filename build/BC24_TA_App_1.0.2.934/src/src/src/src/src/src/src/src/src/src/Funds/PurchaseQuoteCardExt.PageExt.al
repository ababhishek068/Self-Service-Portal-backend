pageextension 50030 "Purchase Quote Card Ext" extends "Purchase Quote"
{

    layout
    {

        modify("Due Date")
        {
            Visible = false;
        }
        modify("Vendor Shipment No.")
        {
            Visible = false;
        }
        modify("Order Date")
        {
            Visible = false;
        }
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Invoice Details")
        {
            Visible = false;
        }
        modify("Shipping and Payment")
        {
            Visible = false;
        }
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Caption = 'User ID';
        }

        addafter("Responsibility Center")
        {
            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the RFQ No. field.';
            }
            field("Requisition No."; Rec."Requisition No.")
            {
                Caption = 'Purchase Requisition No.';
                ApplicationArea = basic;
                Editable = false;
                ToolTip = 'Specifies the value of the Purchase Requisition No. field.';
            }
            field("Posting Description"; Rec."Posting Description")
            {
                Caption = 'Request Description';
                ApplicationArea = basic;
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
            }
            field("Expected Closing Date"; Rec."Expected Closing Date")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Expected Closing Date field.';
            }
            field("Procurement Method Code"; Rec."Procurement Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Procurement Method Code field.';
            }
            field("Assigned Procurement Officer"; Rec."Assigned Procurement Officer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Assigned Procurement Officer field.';
            }



        }
        addafter("Responsibility Center")
        {
            field("Shortcut Dimension 1 Code1"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            }
            field("Shortcut Dimension 2 Code1"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            }
            field("Shortcut Dimension 3 Code1"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
            }
        }

    }
    actions
    {
        addafter(Vendor)
        {
            action(AddRfqNo)
            {
                ApplicationArea = All;
                Caption = 'Synch RFQ No.';
                trigger OnAction()
                var
                    PurchaseLine: Record "Purchase Line";
                begin
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document No.", Rec."No.");
                    if PurchaseLine.FindSet() then
                        repeat
                            PurchaseLine."RFQ No." := Rec."RFQ No.";
                            PurchaseLine.Modify();
                        until PurchaseLine.Next() = 0;

                    Message('posted');
                end;
            }
        }
    }


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type 2" := Rec."Document Type 2"::Quote;
    end;

    trigger OnOpenPage()
    begin
        //if "Expected Closing Date" <> 0DT then begin
        //    if "Expected Closing Date" > CreateDateTime(Today, Time) then Error('You cannot open this quote before the closing date');
        //end;
    end;
}