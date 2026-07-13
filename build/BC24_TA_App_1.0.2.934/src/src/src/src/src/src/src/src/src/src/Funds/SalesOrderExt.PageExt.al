pageextension 50061 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Ship-to Contact1"; Rec."Ship-to Contact")
            {
                caption = 'Truck No';
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the contact person at the address that the items are shipped to.';
            }
            field("Ship-to Address1"; Rec."Ship-to Address")
            {
                caption = 'Driver Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
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

        addafter("Work Order")
        {
            action(Print2)
            {
                caption = 'Print Order';
                ApplicationArea = basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print Order action.';
                trigger OnAction()
                var
                    SaleQoueRep: report "Sales - Order Report";
                    SHeader: record "Sales Header";
                begin
                    sheader.reset;
                    sHeader.setfilter("No.", Rec."No.");
                    if sheader.find('-') then begin
                        SaleQoueRep.SetTableView(sheader);
                        SaleQoueRep.Run();
                    end;
                end;
            }
            action(Print3)
            {
                caption = 'Print Inspection';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print Inspection action.';
                trigger OnAction()
                var
                    SaleQoueRep: report "Sales - Order Inspection";
                    SHeader: record "Sales Header";
                begin
                    sheader.reset;
                    sHeader.setfilter("No.", Rec."No.");
                    if sheader.find('-') then begin
                        SaleQoueRep.SetTableView(sheader);
                        SaleQoueRep.Run();
                    end;
                end;
            }
            action(Print4)
            {
                caption = 'Print Feedback Form';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print Feedback Form action.';
                trigger OnAction()
                var
                    SaleQoueRep: report "Sales - Order Feedback";
                    SHeader: record "Sales Header";
                begin
                    sheader.reset;
                    sHeader.setfilter("No.", Rec."No.");
                    if sheader.find('-') then begin
                        SaleQoueRep.SetTableView(sheader);
                        SaleQoueRep.Run();
                    end;
                end;
            }
        }
        addafter(Invoices)
        {
            action(AssemblyOrders1)
            {
                caption = 'Assembly Order';
                ApplicationArea = basic;
                Image = OrderTracking;
                PromotedCategory = Process;
                Promoted = true;
                RunObject = page "Assembly Order";
                RunPageLink = "Document Type" = filter(Order), "No." = field("No.");
                ToolTip = 'Executes the Assembly Order action.';
            }
        }
    }
}