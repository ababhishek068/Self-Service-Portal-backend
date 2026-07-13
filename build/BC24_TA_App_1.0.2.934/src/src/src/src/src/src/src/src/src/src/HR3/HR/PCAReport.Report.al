Report 50189 "PCA Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PCAReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("prEmployee Trans PCA"; "prEmployee Trans PCA")
        {
            RequestFilterFields = "Start Date";
            column(ReportForNavId_1; 1) { }
            column(EmployeeCode_prEmployeeTransPCA; "prEmployee Trans PCA"."Employee Code") { }
            column(TransactionCode_prEmployeeTransPCA; "prEmployee Trans PCA"."Transaction Code") { }
            column(TransactionName_prEmployeeTransPCA; "prEmployee Trans PCA"."Transaction Name") { }
            column(Amount_prEmployeeTransPCA; "prEmployee Trans PCA".Amount) { }
            column(CompLogo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(EndDate_prEmployeeTransPCA; "prEmployee Trans PCA"."Start Date") { }

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
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
        CompInf: Record "Company Information";
}

