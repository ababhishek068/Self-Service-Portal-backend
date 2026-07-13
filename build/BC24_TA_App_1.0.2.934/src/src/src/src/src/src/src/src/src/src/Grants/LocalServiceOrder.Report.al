Report 50129 "Local Service Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/LocalServiceOrder.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Service Header"; "Service Header")
        {
            column(ReportForNavId_1; 1) { }
            column(LSO_NO; "Service Header"."No.") { }
            column(ContractNo; "Service Header"."Contract No.") { }
            column(ResponseDate; "Service Header"."Response Date") { }
            column(Date; "Service Header"."Document Date") { }
            column("To"; "Service Header"."Bill-to Name") { }
            dataitem("Service Item Line"; "Service Item Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(ReportForNavId_6; 6) { }
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

