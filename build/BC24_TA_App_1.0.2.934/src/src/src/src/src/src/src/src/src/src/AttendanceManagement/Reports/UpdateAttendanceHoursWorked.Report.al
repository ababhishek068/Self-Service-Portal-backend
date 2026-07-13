namespace PTL.HRMIS;

report 52202554 "Update Attendance Hours Worked"
{
    ApplicationArea = All;
    Caption = 'Update Attendance Hours Worked';
    UsageCategory = Tasks;
    dataset
    {
        dataitem(HREmployee; "HR-Employee")
        {
            DataItemTableView = where(Status = filter("Active"));
            trigger OnAfterGetRecord()
            begin
                if fromDate = 0D then
                    fromDate := Today;
                if toDate = 0D then
                    toDate := Today;

               // PTLFactory.UpdateWorkingHours(fromDate, toDate, HREmployee."No.");
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("From Date"; fromDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'From Date';
                    Caption = 'From Date';
                }
                field("To Date"; toDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'To Date';
                    Caption = 'To Date';
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var
       // PTLFactory: Codeunit "PTL Factory";
        fromDate: Date;
        toDate: Date;
}
