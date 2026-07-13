Report 50070 "Validate Employee Pointers"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;

    dataset
    {
        dataitem(UnknownTable50072; "HR-Employee")
        {
            DataItemTableView = sorting("No.") order(ascending) where(Status = filter(Active));

            trigger OnAfterGetRecord()
            begin
                Validate(Grade);
                Modify();
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

    end;
}

