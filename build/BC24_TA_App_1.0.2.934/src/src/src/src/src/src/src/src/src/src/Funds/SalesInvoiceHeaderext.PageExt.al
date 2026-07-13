pageextension 50035 "Sales Invoice Header ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Work Description")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies any text that is entered to accompany the posting, for example for information to auditors.';
            }
        }
        addafter("External Document No.")
        {
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
                    CashSale: report "Sales - Invoice Cash";
                begin
                    SalesInv.reset;
                    SalesInv.setfilter("No.", Rec."No.");
                    if SalesInv.find('-') then begin
                        DelNote.SetTableView(SalesInv);
                        CashSale.SetTableView(SalesInv);
                        if Rec."Cash Sale" = true then
                            CashSale.run()
                        else
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
            action("GenReceipt")
            {
                ApplicationArea = Basic;
                Image = Print;
                Caption = 'Generate Receipt';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Executes the Generate Receipt action.';
                trigger OnAction()
                var
                    FundCU: Codeunit "Funds Mgt Functions";
                begin
                    Rec.calcfields("Total Amount");
                    if Confirm('Do you want to proceed to Receipting') then
                        FundCU.CreateReceipt(Rec."Bill-to Customer No.", Rec."No.", Rec."Total Amount", '', 0, '', false);
                    //message('Successfully created, please check last receipt no from receipting process for posting');

                end;
            }

        }
    }


}