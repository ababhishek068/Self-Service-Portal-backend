Report 50233 "Leave statements"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Leavestatements.rdlc';
    ApplicationArea = All;
    dataset
    {
        dataitem("HR Leave Ledger"; "HR Leave Allocation")
        {
            RequestFilterFields = "No.", "Posting Date", "Calendar Code";
            column(ReportForNavId_6; 6) { }
            column(DocumentNo_HRLeaveLedger; "HR Leave Ledger"."Document No.") { }
            column(LeaveType_HRLeaveLedger; "HR Leave Ledger"."Leave Type") { }
            column(TransactionDate_HRLeaveLedger; "HR Leave Ledger"."Posting Date") { }
            column(EmployeeNo_HRLeaveLedger; "HR Leave Ledger"."No.") { }
            column(TransactionType_HRLeaveLedger; "HR Leave Ledger"."Posting Type") { }
            column(NoofDays_HRLeaveLedger; "HR Leave Ledger"."No. of Days") { }
            column(TransactionDescription_HRLeaveLedger; "HR Leave Ledger"."Posting Description") { }
            column(EntryType_HRLeaveLedger; "HR Leave Ledger"."Entry Type") { }
            column(CompLogo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(Names; HREmp."First Name" + ' ' + HREmp."Middle Name" + '  ' + HREmp."Last Name") { }
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }
            column(ReturnDate; ReturnDate) { }

            trigger OnAfterGetRecord()
            var
                LvApp: Record "HR Leave Application";
            begin
                StartDate := 0D;
                EndDate := 0D;
                ReturnDate := 0D;
                if HREmp.Get("HR Leave Ledger"."No.") then;
                LvApp.Reset();
                LvApp.SetRange("Application Code", "Document No.");
                if LvApp.Find('-') then begin
                    StartDate := LvApp."Start Date";
                    EndDate := LvApp."End Date";
                    ReturnDate := LvApp."Return Date";
                end;
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
        StartDate: Date;
        EndDate: Date;
        ReturnDate: Date;
}

