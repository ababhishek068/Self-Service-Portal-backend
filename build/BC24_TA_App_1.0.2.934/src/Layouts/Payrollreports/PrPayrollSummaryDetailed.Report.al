namespace microsoft;
using Microsoft.Foundation.Company;

report 52202724 "Pr Payroll Summary Detailed"
{
    ApplicationArea = All;
    Caption = 'Pr Payroll Summary Detailed';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payrollreports/payrollSummaryDetailed.rdl';
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
            column(preparedbyName; preparedbyName) { }
            column(preparedbyJobTitle; preparedbyJobTitle) { }
            column(RowNum; RowNum) { }
            column(CompanyInformation_picture; CompanyInformation.Picture) { }
            column(CompanyInformation_name; cname) { }
            column(CompanyInformation_address; CompanyInformation.Address) { }
            column(CompanyInformation_email; CompanyInformation."E-Mail") { }
            column(counter; counter) { }
            column(prmonth;prmonth){}
            column(dateprinted;dateprinted){}
            column(timeprinted;timeprinted){}
            column(Preparedby;Preparedby){}
            trigger OnAfterGetRecord()
            begin
                FullName := '';
                RowNum := RowNum + 1;
                counter := counter + 1;
                if HREmployee.Get(prPeriodTransactions."Employee Code") then begin

                    if (HREmployee.Title = HREmployee.Title::Prof) or (HREmployee.Title = HREmployee.Title::"Dr.") then begin
                        FullName := UpperCase(HREmployee."First Name" + ' ' + HREmployee."Middle Name") + '  (' + Format(HREmployee.Title) + ')';
                    end else begin
                        FullName := UpperCase(HREmployee."First Name" + ' ' + HREmployee."Middle Name");
                    end;
                end;
                ECnaming.Reset();
                ECnaming.SetRange(ECnaming.Month,Date2DMY(prPeriodTransactions."Payroll Period",2));
                if ECnaming.FindFirst() then begin                    

                    prmonth:=ECnaming."GC Payroll Period Open Date";
                end;
                dateprinted:=Today;
                timeprinted:=time;

            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
                cname := CompanyInformation.Name;

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
        if prPeriodTransactions.GetFilter(prPeriodTransactions."Payroll Period") = '' then begin
            prPayrollPeriods.Reset();
            prPayrollPeriods.SetRange(prPayrollPeriods.Closed, false);
            if prPayrollPeriods.FindFirst() then begin
                prPeriodTransactions.SetFilter(prPeriodTransactions."Payroll Period", Format(prPayrollPeriods."Date Opened"));
            end;
            counter := 0;
        end;
        Preparedby := UserId;
        hremps.Reset();
        hremps.SetRange(hremps."User ID");
        if hremps.FindFirst() then begin
            preparedbyName := hremps."First Name" + ' ' + hremps."Middle Name" + '' + hremps."Last Name";
            preparedbyJobTitle := hremps."Job Title";
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
        Preparedby: code[50];
        preparedbyName: Text[100];
        preparedbyJobTitle: Text[100];
        checkedby: code[50];
        CheckedbyName: Text[100];
        checkedbyJobTitle: Text[100];
        checkedby2: code[50];
        CheckedbyName2: Text[100];
        checkedbyJobTitle2: Text[100];
        Approvedby: code[50];
        ApprovedbyName: Text[100];
        ApprovedbyJobTitle: Text[100];
        Authorizedby: code[50];
        AuthorizedbyName: Text[100];
        AuthorizedbyJobTitle: Text[100];
        hremps: Record "HR-Employee";
        cname: text[100];
        prmonth:Date;
        ECnaming: Record "Payroll GC to EC";
        dateprinted: date;
        timeprinted:time;


}
