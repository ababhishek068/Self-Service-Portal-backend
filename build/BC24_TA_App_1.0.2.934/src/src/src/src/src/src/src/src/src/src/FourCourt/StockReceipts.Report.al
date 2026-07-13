report 50038 "Stock Receipts"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; "Transfer Receipt Header")
        {
            column(No_; "No.") { }
            column(Transfer_from_Code; "Transfer-from Code") { }
            column(Transfer_to_Code; "Transfer-to Code") { }
            column(Posting_Date; "Posting Date") { }
            column(Transfer_Order_No_; "Transfer Order No.") { }
            column(Transfer_Order_Date; "Transfer Order Date") { }

            column(Shipment_Date; "Shipment Date") { }
            column(Receipt_Date; "Receipt Date") { }

            column(ReceiptNo; ReceiptNo) { }
            column(ShipmentNo; ShipmentNo) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            dataitem(TransferLine; "Transfer Receipt Line")
            {

                //DataItemLinkReference = "Transfer Header";
                DataItemLink = "Document No." = field("No.");
                column(Quantity; Quantity) { }
            }
            trigger OnAfterGetRecord()
            var
                receiptH: Record "Transfer Receipt Header";
                ShipmentH: Record "Transfer Shipment Header";
            begin
                receiptH.Reset();
                receiptH.SetRange("Transfer Order No.", "Transfer Order No.");
                if receiptH.Find('-') then begin
                    ReceiptNo := receiptH."No."
                end;
                ShipmentH.Reset();
                ShipmentH.SetRange("Transfer Order No.", "Transfer Order No.");
                if ShipmentH.Find('-') then begin
                    ShipmentNo := ShipmentH."No."
                end;

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; )
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        ReceiptNo: code[20];
        ShipmentNo: code[20];
        CompInf: Record "Company Information";


}