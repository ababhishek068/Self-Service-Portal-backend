Report 50115 "On Leave Report"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;


    dataset
    {
        dataitem("HR Leave Application"; "HR Leave Application")
        {
            DataItemTableView = sorting("Application Code") where(Status = const(Posted));
            column(Employee_No_; "Employee No.") { }

            column(Empoyee_Name; "Empoyee Name") { }

            column(Start_Date; "Start Date") { }

            column(End_Date; "End Date") { }
            column(Return_Date; "Return Date") { }

            column(Leave_Type; "Leave Type") { }

            column(Days_Applied; "Days Applied") { }
            column(CompLogo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            trigger OnAfterGetRecord()
            begin
                if not ((Today >= "Start Date") and (Today <= "Return Date")) then
                    CurrReport.Skip();
            end;

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

