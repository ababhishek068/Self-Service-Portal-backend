report 50035 "Stock Transfers"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; "Transfer Header")
        {
            column(No_; "No.") { }
            column(Transfer_from_Code; "Transfer-from Code") { }
            column(Transfer_to_Code; "Transfer-to Code") { }
            column(Posting_Date; "Posting Date") { }
            column(Shipment_Date; "Shipment Date") { }
            column(Receipt_Date; "Receipt Date") { }
            column(Status; Status) { }
            column(ReceiptNo; ReceiptNo) { }
            column(ShipmentNo; ShipmentNo) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            dataitem(TransferLine; "Transfer Line")
            {

                //DataItemLinkReference = "Transfer Header";
                DataItemLink = "Document No." = field("No.");
                column(Quantity; Quantity) { }
                column(Quantity_Shipped; "Quantity Shipped") { }
                column(Quantity_Received; "Quantity Received") { }
            }
            trigger OnAfterGetRecord()
            var
                receiptH: Record "Transfer Receipt Header";
                ShipmentH: Record "Transfer Shipment Header";
            begin
                receiptH.Reset();
                receiptH.SetRange("Transfer Order No.", "No.");
                if receiptH.Find('-') then begin
                    ReceiptNo := receiptH."No."
                end;
                ShipmentH.Reset();
                ShipmentH.SetRange("Transfer Order No.", "No.");
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