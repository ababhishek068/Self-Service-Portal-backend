Report 50208 "Employee Pay Element Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EmployeePayElementSummary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_8631; 8631) { }
            column(HR_Employee_No_; "No.") { }
            dataitem("prPeriod Transactions"; "pr Period Transactions")
            {
                DataItemLink = "Employee Code" = field("No.");
                DataItemTableView = sorting("Employee Code", "Transaction Code", "Period Month", "Period Year", "Reference No");
                column(ReportForNavId_7769; 7769) { }
                column(CompanyInfo_Picture; CompanyInfo.Picture) { }
                column(UserId; UserId) { }
                column(Today; Today) { }

                column(prPeriod_Transactions__Employee_Code_; "Employee Code") { }
                column(Names; Names) { }
                column(prPeriod_Transactions_Amount; Amount) { }
                column(prPeriod_Transactions__Transaction_Code_; "Transaction Code") { }
                column(prPeriod_Transactions__Transaction_Name_; "Transaction Name") { }
                column(User_Name_Caption; User_Name_CaptionLbl) { }
                column(Print_Date_Caption; Print_Date_CaptionLbl) { }
                column(Page_No_Caption; Page_No_CaptionLbl) { }
                column(Employee_Pay_Elements_to_DateCaption; Employee_Pay_Elements_to_DateCaptionLbl) { }
                column(AmountCaption; AmountCaptionLbl) { }
                column(prPeriod_Transactions__Transaction_Name_Caption; FieldCaption("Transaction Name")) { }
                column(prPeriod_Transactions__Transaction_Code_Caption; FieldCaption("Transaction Code")) { }
                column(Prepared_by_______________________________________Date_________________Caption; Prepared_by_______________________________________Date_________________CaptionLbl) { }
                column(Checked_by________________________________________Date_________________Caption; Checked_by________________________________________Date_________________CaptionLbl) { }
                column(Authorized_by____________________________________Date_________________Caption; Authorized_by____________________________________Date_________________CaptionLbl) { }
                column(Approved_by______________________________________Date_________________Caption; Approved_by______________________________________Date_________________CaptionLbl) { }
                column(prPeriod_Transactions_Period_Month; "Period Month") { }
                column(prPeriod_Transactions_Period_Year; "Period Year") { }

                column(prPeriod_Transactions_Reference_No; "Reference No") { }

                trigger OnAfterGetRecord()
                begin
                    if ("prPeriod Transactions"."Group Order" = 8) and ("prPeriod Transactions"."Sub Group Order" = 9) then
                        CurrReport.Skip;
                    if "prPeriod Transactions"."Group Order" = 6 then
                        CurrReport.Skip;

                    if ("prPeriod Transactions"."Group Order" = 4) then
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Transaction Code");
                    if CompanyInfo.Get() then
                        CompanyInfo.CalcFields(CompanyInfo.Picture);
                end;
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        LastFieldNo: Integer;
        CompanyInfo: Record "Company Information";
        Names: Text[250];
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Page_No_CaptionLbl: label 'Page No:';
        Employee_Pay_Elements_to_DateCaptionLbl: label 'Employee Pay Elements to Date';
        AmountCaptionLbl: label 'Amount';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á..                 Date┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á..                   Date┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á..              Date┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á..                Date┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á┬Á';
}

