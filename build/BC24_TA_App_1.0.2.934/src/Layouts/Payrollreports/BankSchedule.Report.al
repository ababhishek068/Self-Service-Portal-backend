namespace microsoft;
using Microsoft.Foundation.Company;

report 50373 "Bank Schedule"
{
    ApplicationArea = All;
    Caption = 'Bank Schedule';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payrollreports/Bankschedule.rdl';
    dataset
    {
        dataitem(prPeriodTransactions; "pr Period Transactions")
        {
            RequestFilterFields = "Payroll Period";
            column(TransactionCode; "Transaction Code")
            {
            }
            column(EmployeeCode; "Employee Code")
            {
            }
            column(TransactionName; "Transaction Name")
            {
            }
            column(Amount; Amount)
            {
            }
            column(GroupOrder; "Group Order")
            {
            }
            column(SubGroupOrder; "Sub Group Order")
            {
            }
            column(PeriodMonth; "Period Month")
            {
            }
            column(PeriodYear; "Period Year")
            {
            }
            column(PayrollPeriod; "Payroll Period")
            {
            }
            column(FullName; FullName) { }
            column(RowNum; RowNum) { }
            column(CompanyInformation_picture; CompanyInformation.Picture) { }
            column(CompanyInformation_name; CompanyInformation.Name) { }
            column(CompanyInformation_address; CompanyInformation.Address) { }
            column(CompanyInformation_email; CompanyInformation."E-Mail") { }
            column(counter;counter){}
            trigger OnAfterGetRecord()
            begin
                FullName := '';
                RowNum := RowNum + 1;
                if HREmployee.Get(prPeriodTransactions."Employee Code") then
                    FullName := UpperCase(HREmployee."First Name"+ ' '+HREmployee."Middle Name"+' '+HREmployee."Last Name");
                    counter:=counter+1;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        counter:=0;
        if prPeriodTransactions.GetFilter(prPeriodTransactions."Payroll Period") = '' then begin
            prPayrollPeriods.Reset();
            prPayrollPeriods.SetRange(prPayrollPeriods.Closed, false);
            if prPayrollPeriods.FindFirst() then begin
                prPeriodTransactions.SetFilter(prPeriodTransactions."Payroll Period", Format(prPayrollPeriods."Date Opened"));
            end;
        end;
    end;

    trigger OnPreReport()
    begin
        prPeriodTransactions.SetCurrentKey(prPeriodTransactions."Employee Code", prPeriodTransactions."Period Month", prPeriodTransactions."Period Year", prPeriodTransactions."Group Order", prPeriodTransactions."Sub Group Order");
        
    end;

    var
        CompanyInformation: Record "Company Information";
        prPayrollPeriods: Record "pr Payroll Periods";
        FullName: Text[250];
        RowNum: Integer;
        HREmployee: Record "HR-Employee";
        counter: integer;

}
