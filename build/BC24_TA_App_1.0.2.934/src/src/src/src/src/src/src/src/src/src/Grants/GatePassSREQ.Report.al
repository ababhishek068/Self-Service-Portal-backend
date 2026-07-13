Report 50145 "Gate Pass SREQ"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GatePassSREQ.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Store Requistion Header"; "Store Requistion Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1) { }
            column(Point_of_Issue; "Store Requistion Header"."Issuing Store") { }
            column(Date; "Store Requistion Header"."Issue Date") { }
            column(Picture; Logos.Picture) { }
            column(SerialNo; "Store Requistion Header"."No.") { }
            dataitem("Store Requistion Lines"; "Store Requistion Lines")
            {
                DataItemLink = "Requistion No" = field("No.");
                column(ReportForNavId_4; 4) { }
                column(No; "Store Requistion Lines"."Line No.") { }
                column(Item_Taken; "Store Requistion Lines".Description) { }
                column(Quantity; "Store Requistion Lines".Quantity) { }
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

