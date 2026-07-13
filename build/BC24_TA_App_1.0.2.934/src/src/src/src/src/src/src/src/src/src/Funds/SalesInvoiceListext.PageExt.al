pageextension 50038 "Sales Invoice List ext" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            field("Prepared By"; Rec."Prepared By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepared By field.';

            }
        }

        addafter("External Document No.")
        {
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to Doc. Type field.';

            }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';

            }
            field("Applied Credit Memo No"; Rec."Applied Credit Memo No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applied Credit Memo No field.';

            }
            field(Correction; Rec.Correction)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Correction field.';

            }

            field("Shipping Agent Code1"; Rec."Shipping Agent Code")
            {
                caption = 'Truck No';
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
            }
            field("Ship-to Address1"; Rec."Ship-to Address")
            {
                caption = 'Driver Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the address that the items on the invoice were shipped to.';
            }
            field("Ship-to Address 22"; Rec."Ship-to Address 2")
            {
                caption = 'Drivers ID';
                ApplicationArea = All;
                ToolTip = 'Specifies additional address information.';
            }
            field("Ship-to Name1"; Rec."Ship-to Name")
            {
                caption = 'Transporter';
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the customer at the address that the items are shipped to.';
            }
        }

    }

    actions
    {
        addafter(Print)
        {
            action("SalesInv")
            {
                ApplicationArea = Basic;
                Image = Print;
                Caption = 'Print Invoice';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Executes the Print Invoice action.';
                trigger OnAction()
                var
                    SalesInv: Record "Sales Invoice Header";
                    DelNote: report "Sales - Invoice Cust";
                begin
                    SalesInv.reset;
                    SalesInv.setfilter("No.", Rec."No.");
                    if SalesInv.find('-') then begin
                        DelNote.SetTableView(SalesInv);
                        DelNote.Run();
                    end

                end;
            }
            action("DeliveryNote")
            {
                ApplicationArea = Basic;
                Image = Print;
                Caption = 'Delivery Note';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Executes the Delivery Note action.';
                trigger OnAction()
                var
                    SalesInv: Record "Sales Invoice Header";
                    DelNote: report "Delivery Note";
                begin
                    SalesInv.reset;
                    SalesInv.setfilter("No.", Rec."No.");
                    if SalesInv.find('-') then begin
                        DelNote.SetTableView(SalesInv);
                        DelNote.Run();
                    end

                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.setfilter("Cash Sale", '%1', false);
    end;

}