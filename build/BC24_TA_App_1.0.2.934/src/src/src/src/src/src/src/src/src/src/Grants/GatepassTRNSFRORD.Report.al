Report 50146 "Gate pass TRNSFR_ORD"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GatepassTRNSFRORD.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1) { }
            column(Point_of_Issue; "Transfer Shipment Header"."Transfer-from Name") { }
            column(Destination; "Transfer Shipment Header"."Transfer-to Name") { }
            column(Date; "Transfer Shipment Header"."Posting Date") { }
            column(Picture; Logos.Picture) { }
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(ReportForNavId_5; 5) { }
                column(No; "Transfer Shipment Line"."Line No.") { }
                column(Item_Taken; "Transfer Shipment Line".Description) { }
                column(Quantity; "Transfer Shipment Line".Quantity) { }
                column(Status; State) { }

                trigger OnAfterGetRecord()
                begin
                    State := 'Functional';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Logos.get;
                Logos.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        State: Text;
        Logos: Record "Company Information";
}

