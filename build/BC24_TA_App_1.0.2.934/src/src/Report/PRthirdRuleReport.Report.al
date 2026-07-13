Report 50175 "PR third Rule Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AthirdRuleReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("prSalary Card"; "pr Salary Card")
        {
            RequestFilterFields = "Period Filter", "Employee Code";
            column(ReportForNavId_6207; 6207) { }
            column(UserId; UserId) { }
            column(Today; Today) { }
            column(PeriodName; PeriodName) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(companyinfo_Picture; companyinfo.Picture) { }
            column(prSalary_Card__prSalary_Card___Employee_Code_; "prSalary Card"."Employee Code") { }
            column(BasicPay; BasicPay) { }
            column(Athird; Athird) { }
            column(EmployeeName; EmployeeName) { }
            column(NetPay; NetPay) { }
            column(Variance; Variance) { }
            column(TotNetPay; TotNetPay) { }
            column(TotBasicPay; TotBasicPay) { }
            column(TotVariance; TotVariance) { }
            column(A_third_Rule_ReportCaption; A_third_Rule_ReportCaptionLbl) { }
            column(Basic_Pay_Caption; Basic_Pay_CaptionLbl) { }
            column(A_THIRD_Caption; A_THIRD_CaptionLbl) { }
            column(Net_Pay_Caption; Net_Pay_CaptionLbl) { }
            column(User_Name_Caption; User_Name_CaptionLbl) { }
            column(Print_Date_Caption; Print_Date_CaptionLbl) { }
            column(Period_Caption; Period_CaptionLbl) { }
            column(Page_No_Caption; Page_No_CaptionLbl) { }
            column(VarianceCaption; VarianceCaptionLbl) { }
            column(Prepared_by_______________________________________Date_________________Caption; Prepared_by_______________________________________Date_________________CaptionLbl) { }
            column(Checked_by________________________________________Date_________________Caption; Checked_by________________________________________Date_________________CaptionLbl) { }
            column(Authorized_by____________________________________Date_________________Caption; Authorized_by____________________________________Date_________________CaptionLbl) { }
            column(Approved_by______________________________________Date_________________Caption; Approved_by______________________________________Date_________________CaptionLbl) { }
            column(Totals_Caption; Totals_CaptionLbl) { }

            trigger OnAfterGetRecord()
            begin

                objEmp.Reset;
                objEmp.SetRange(objEmp."No.", "Employee Code");
                if objEmp.Find('-') then
                    EmployeeName := objEmp."First Name" + ' ' + objEmp."Middle Name" + ' ' + objEmp."Last Name";

                BasicPay := 0;
                GrossPay := 0;
                NetPay := 0;

                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code", "Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period", SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Group Order", '=1|=4|=9');
                PeriodTrans.SetFilter(PeriodTrans."Sub Group Order", '<=1');
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code", PeriodTrans."Period Month", PeriodTrans."Period Year",
                PeriodTrans."Group Order", PeriodTrans."Sub Group Order");
                if PeriodTrans.Find('-') then
                    repeat
                        if PeriodTrans."Group Order" = 1 then begin
                            BasicPay := PeriodTrans.Amount;
                        end;

                        if PeriodTrans."Group Order" = 4 then begin
                            GrossPay := PeriodTrans.Amount; //Gross pay
                        end;

                        if PeriodTrans."Group Order" = 9 then begin
                            NetPay := PeriodTrans.Amount; //Net pay
                        end;
                    until PeriodTrans.Next = 0;

                Athird := BasicPay * 0.33;
                Variance := NetPay - Athird;

                if NetPay <= 0 then
                    CurrReport.Skip;
                TotBasicPay := TotBasicPay + BasicPay;
                TotGrossPay := TotGrossPay + GrossPay;
                TotNetPay := TotNetPay + NetPay;
                TotVariance := TotVariance + Variance;
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
        PeriodFilter := "prSalary Card".GetFilter("Period Filter");
        if PeriodFilter = '' then Error('You must specify the period filter');

        SelectedPeriod := "prSalary Card".GetRangeMin("Period Filter");
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName := objPeriod."Period Name";


        if companyinfo.Get() then
            companyinfo.CalcFields(companyinfo.Picture);
    end;

    var
        PeriodTrans: Record "pr Period Transactions";
        BasicPay: Decimal;
        GrossPay: Decimal;
        NetPay: Decimal;
        TotBasicPay: Decimal;
        TotGrossPay: Decimal;
        TotNetPay: Decimal;
        EmployeeName: Text[250];
        objEmp: Record "HR-Employee";
        objPeriod: Record "pr Payroll Periods";
        SelectedPeriod: Date;
        PeriodName: Text[250];
        PeriodFilter: Text[250];
        companyinfo: Record "Company Information";
        Athird: Decimal;
        Variance: Decimal;
        TotVariance: Decimal;
        A_third_Rule_ReportCaptionLbl: label 'A third Rule Report';
        Basic_Pay_CaptionLbl: label 'Basic Pay:';
        A_THIRD_CaptionLbl: label 'A THIRD:';
        Net_Pay_CaptionLbl: label 'Net Pay:';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        VarianceCaptionLbl: label 'Variance';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared byÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ..                 DateÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked byÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ..                   DateÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized byÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ..              DateÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved byÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ..                DateÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁ';
        Totals_CaptionLbl: label 'Totals:';
}

