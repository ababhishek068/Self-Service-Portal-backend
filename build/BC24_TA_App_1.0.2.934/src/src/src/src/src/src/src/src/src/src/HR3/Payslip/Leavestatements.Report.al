namespace PTL.HRMIS;

using Microsoft.Foundation.Company;

Report 50368 "Leave statements1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Leavestatements.rdl';
    ApplicationArea = All;
    dataset
    {
        dataitem("HR Leave Allocation"; "HR Leave Allocation")
        {
            RequestFilterFields = "No.", "Posting Date", "Calendar Code", "Leave Type";
            DataItemTableView = where(Posted = filter(true));
            
            column(ReportForNavId_6; 6)
            {
            }
            column(DocumentNo_HRLeaveLedger; "HR Leave Allocation"."Document No.")
            {
            }
            column(LeaveType_HRLeaveLedger; "HR Leave Allocation"."Leave Type")
            {
            }
            column(TransactionDate_HRLeaveLedger; "HR Leave Allocation"."Posting Date")
            {
            }
            column(EmployeeNo_HRLeaveLedger; "HR Leave Allocation"."No.")
            {
            }
            column(TransactionType_HRLeaveLedger; "HR Leave Allocation"."Posting Type")
            {
            }
            column(NoofDays_HRLeaveLedger; "HR Leave Allocation"."No. of Days")
            {
            }
            column(TransactionDescription_HRLeaveLedger; "HR Leave Allocation"."Posting Description")
            {
            }
            column(EntryType_HRLeaveLedger; "HR Leave Allocation"."Entry Type")
            {
            }
            column(Application_Start_Date; "Application Start Date")
            {

            }
            column(Application_End_Date; "Application End Date")
            {

            }
            column(Application_Return_Date; "Application Return Date")
            {

            }
            column(CompLogo; CompInf.Picture)
            {
            }
            column(CompName; CompInf.Name)
            {
            }
            column(LeaveBalance;LeaveBalance)
            {

            }
            column(CompEmail; CompInf."E-Mail")
            {
            }
            column(CompAddress; CompInf.Address) { }
            column(Names; HREmp."First Name" + ' ' + HREmp."Middle Name" + '  ' + HREmp."Last Name")
            {
            }

            trigger OnAfterGetRecord()
            var
                hrLeaveLedger: Record "HR Leave Allocation";
                
            begin
                if HREmp.Get("HR Leave Allocation"."No.") then;
                
                hrLeaveLedger.Reset();
                hrLeaveLedger.SetRange("No.", "HR Leave Allocation"."No.");
                hrLeaveLedger.SetRange("Leave Type", "HR Leave Allocation"."Leave Type");
                hrLeaveLedger.SetRange(Posted, true);
                if hrLeaveLedger.FindSet() then begin
                    hrLeaveLedger.CalcSums("No. of Days");
                    LeaveBalance := hrLeaveLedger."No. of Days";
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get();
                CompInf.CalcFields(CompInf.Picture); 
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInf: Record "Company Information";
        HREmp: Record "HR-Employee";
        EndDate: Date;
        ReturnDate: Date;
        StartDate: Date;
        LeaveBalance: Decimal;
}
