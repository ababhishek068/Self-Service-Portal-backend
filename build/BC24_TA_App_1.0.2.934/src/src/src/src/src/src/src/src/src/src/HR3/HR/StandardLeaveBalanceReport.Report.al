Report 50046 "Standard Leave Balance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StandardLeaveBalanceReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_3372; 3372) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
            column(HR_Employee_C__Last_Name_; "Last Name") { }
            column(HR_Employee_C__First_Name_; "First Name") { }
            column(HR_Employee_C__No__; "No.") { }
            column(leavebal; myBal) { }

            trigger OnAfterGetRecord()
            begin
                "HR-Employee".CalcFields("Leave Balance");


                leaveledger.Reset;
                leaveledger.SetRange(leaveledger."Employee No", "HR-Employee"."No.");
                leaveledger.SetFilter(leaveledger."Transaction Date", '%1..%2', StartDate, EndDAte);
                if leaveledger.Find('-') then
                    repeat
                        myBal := myBal + leaveledger."No. of Days";

                    until leaveledger.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDAte; EndDAte)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the value of the End Date field.';
                }
            }
        }

        actions { }
    }

    labels { }

    var
        LastFieldNo: Integer;
        leaveledger: Record "HR Leave Ledger";
        myBal: Decimal;
        StartDate: Date;
        EndDAte: Date;
}

