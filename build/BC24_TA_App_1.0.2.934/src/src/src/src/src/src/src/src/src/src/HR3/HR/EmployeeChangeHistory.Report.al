Report 50234 "Employee Change History"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EmployeeChangeHistory.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Change Entries"; "HR Change Entries")
        {
            RequestFilterFields = "employee No", "Change Date";
            column(ReportForNavId_1; 1) { }
            column(employeeNo_HRChangeEntries; "HR Change Entries"."employee No") { }
            column(ChangeDate_HRChangeEntries; "HR Change Entries"."Change Date") { }
            column(ChangeDescription_HRChangeEntries; "HR Change Entries"."Change Description") { }
            column(OldValue_HRChangeEntries; "HR Change Entries"."Old Value") { }
            column(NewValue_HRChangeEntries; "HR Change Entries"."New Value") { }
            column(UserID_HRChangeEntries; "HR Change Entries".UserID) { }
            column(Names; HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name") { }
            column(LOgo; CompInf.Picture) { }

            trigger OnAfterGetRecord()
            begin
                if HREmp.Get("HR Change Entries"."employee No") then;
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
        HREmp: Record "HR-Employee";
        CompInf: Record "Company Information";
}

