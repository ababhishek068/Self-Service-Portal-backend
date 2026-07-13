Report 50125 "Posted Counter Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PostedCounterRequisition.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Store Requistion Header"; "Store Requistion Header")
        {
            column(ReportForNavId_1; 1) { }
            column(DocumentNo; "Store Requistion Header"."No.") { }
            column(PointOfIssue; "Store Requistion Header"."Issuing Store") { }
            column(PointofUse; "Store Requistion Header"."Responsibility Center") { }
            column(Date; "Store Requistion Header"."Request date") { }
            column(Picture; Logos.Picture) { }
            dataitem("Store Requistion Lines"; "Store Requistion Lines")
            {
                DataItemLink = "Requistion No" = field("No.");
                column(ReportForNavId_5; 5) { }
                column(ItemNo; "Store Requistion Lines"."No.") { }
                column(Description; "Store Requistion Lines".Description) { }
                column(UnitofIssue; "Store Requistion Lines"."Unit of Measure") { }
                column(QuantitiyIssued; "Store Requistion Lines".Quantity) { }
                column(QuantityRequested; "Store Requistion Lines"."Quantity Requested") { }


                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = field("Requistion No"), "Item No." = field("No.");
                    column(ReportForNavId_1000000001; 1000000001) { }
                    column(LotNo_ReservationEntry; "Item Ledger Entry"."Lot No.") { }
                    column(Quantity_ReservationEntry; "Item Ledger Entry".Quantity) { }
                    column(sno; SNo) { }

                    trigger OnAfterGetRecord()
                    begin
                        SNo += 1;
                        "Store Requistion Lines".Quantity := "Item Ledger Entry".Quantity * -1;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                Logos.get;

                Logos.CalcFields(Logos.Picture);
            end;

        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        SNo := 0;
        SNo2 := 0
    end;

    var
        Logos: Record "Company Information";
        SNo: Integer;
        SNo2: Integer;
}

