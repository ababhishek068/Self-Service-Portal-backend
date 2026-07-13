Report 50049 "Organizational Structure"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StudentID.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Name; Name) { }
            column(Picture; Picture) { }
            trigger OnAfterGetRecord()
            begin
                CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

