
report 50282 "prDeductions Variance Report2"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;


    dataset
    {
        dataitem("pr Period Transactions"; "pr Period Transactions")
        {
            DataItemTableView = SORTING("Transaction Code", "Payroll Period", "Reference No")
                                ORDER(Ascending);
            RequestFilterFields = "Transaction Code";
            column(USERID; USERID) { }
            column(TODAY; TODAY) { }
            column(PeriodName; PeriodName) { }
            column(CurrReport_PAGENO; CurrReport.PAGENO) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(prPeriod_Transactions__prPeriod_Transactions___Transaction_Name_; "pr Period Transactions"."Transaction Name") { }
            column(prPeriod_Transactions_Amount; Amount) { }
            column(Amount_PrevMonth; Amount - PrevMonth) { }
            column(prPeriod_Transactions__Employee_Code_; "Employee Code") { }
            column(strEmpName; strEmpName) { }
            column(prPeriod_Transactions__prPeriod_Transactions___Transaction_Name__Control1102756017; "pr Period Transactions"."Transaction Name") { }
            column(PrevMonth; PrevMonth) { }
            column(GrandTotal; GrandTotal) { }
            column(PrevMonthTot; PrevMonthTot) { }
            column(GrandTotal_PrevMonthTot; GrandTotal - PrevMonthTot) { }
            column(Transactions_Variant_ReportCaption; Transactions_Variant_ReportCaptionLbl) { }
            column(User_Name_Caption; User_Name_CaptionLbl) { }
            column(Print_Date_Caption; Print_Date_CaptionLbl) { }
            column(Period_Caption; Period_CaptionLbl) { }
            column(Page_No_Caption; Page_No_CaptionLbl) { }
            column(Description_Caption; Description_CaptionLbl) { }
            column(Period_Amount_Caption; Period_Amount_CaptionLbl) { }
            column(Variant_Caption; Variant_CaptionLbl) { }
            column(Employee_No_Caption; Employee_No_CaptionLbl) { }
            column(Employee_Name_Caption; Employee_Name_CaptionLbl) { }
            column(Prev__Month_Caption; Prev__Month_CaptionLbl) { }
            column(Prepared_by_______________________________________Date_________________Caption; Prepared_by_______________________________________Date_________________CaptionLbl) { }
            column(Checked_by________________________________________Date_________________Caption; Checked_by________________________________________Date_________________CaptionLbl) { }
            column(Authorized_by____________________________________Date_________________Caption; Authorized_by____________________________________Date_________________CaptionLbl) { }
            column(Approved_by______________________________________Date_________________Caption; Approved_by______________________________________Date_________________CaptionLbl) { }
            column(Grand_Total_Caption; Grand_Total_CaptionLbl) { }
            column(prPeriod_Transactions_Transaction_Code; "Transaction Code") { }
            column(prPeriod_Transactions_Period_Month; "Period Month") { }
            column(prPeriod_Transactions_Period_Year; "Period Year") { }
            column(prPeriod_Transactions_Membership; "Reference No") { }
            column(prPeriod_Transactions_Reference_No; "Reference No") { }
            column(prPeriod_Transactions_Group_Order; "Group Order") { }

            trigger OnAfterGetRecord()
            begin
                //Get the staff details (header)
                objEmp.SETRANGE(objEmp."No.", "Employee Code");
                IF objEmp.FIND('-') THEN BEGIN
                    strEmpName := objEmp."Last Name" + ' ' + objEmp."First Name" + ' ' + objEmp."Middle Name";
                END;
                "pr Period Transactions".SETRANGE("pr Period Transactions"."Employee Code");
                "pr Period Transactions".SETRANGE("Payroll Period", SelectedPeriod);
                "pr Period Transactions".SETfilter("Payroll Period", '%1', Periods);
                //"pr Period Transactions".SETFILTER("Group Order",'=7|=8');

                PrevMonth := 0;
                PeriodTrans2.RESET;
                //PeriodTrans2.SETRANGE(PeriodTrans2."Period Year", "pr Period Transactions"."Period Year");
                //IF "pr Period Transactions"."Period Month" = 1 THEN BEGIN
                //PeriodTrans2.SETRANGE(PeriodTrans2."Period Month", 12);
                //PeriodTrans2.SETRANGE(PeriodTrans2."Period Year", "pr Period Transactions"."Period Year" - 1);
                //END ELSE BEGIN
                //PeriodTrans2.SETRANGE(PeriodTrans2."Period Month", "pr Period Transactions"."Period Month" - 1);
                //END;
                //PeriodTrans2.SETFILTER(PeriodTrans2."Group Order",'=7|=8');
                PeriodTrans2.SETRANGE(PeriodTrans2."Payroll Period", selectedperiod2);
                PeriodTrans2.SETRANGE(PeriodTrans2."Transaction Code", "pr Period Transactions"."Transaction Code");
                PeriodTrans2.SETRANGE(PeriodTrans2."Employee Code", "pr Period Transactions"."Employee Code");
                IF PeriodTrans2.FIND('-') THEN
                    PrevMonth := PeriodTrans2.Amount;


                IF PrevMonth = Amount THEN
                    CurrReport.SKIP;

                //Transactions in prev month not in this month
                "pr Period Transactions".SETRANGE("pr Period Transactions"."Employee Code");
                "pr Period Transactions".SETRANGE("Payroll Period", SelectedPeriod2);
                "pr Period Transactions".SETfilter("Payroll Period", '%1', Periods);
                //"pr Period Transactions".SETFILTER("Group Order",'=7|=8');

                PrevMonth := 0;
                PeriodTrans2.RESET;
                //PeriodTrans2.SETRANGE(PeriodTrans2."Period Year", "pr Period Transactions"."Period Year");
                //IF "pr Period Transactions"."Period Month" = 1 THEN BEGIN
                //PeriodTrans2.SETRANGE(PeriodTrans2."Period Month", 12);
                //PeriodTrans2.SETRANGE(PeriodTrans2."Period Year", "pr Period Transactions"."Period Year" - 1);
                //END ELSE BEGIN
                // PeriodTrans2.SETRANGE(PeriodTrans2."Period Month", "pr Period Transactions"."Period Month" - 1);
                //END;
                //PeriodTrans2.SETFILTER(PeriodTrans2."Group Order",'=7|=8');
                PeriodTrans2.SETRANGE(PeriodTrans2."Payroll Period", SelectedPeriod);
                PeriodTrans2.SETRANGE(PeriodTrans2."Transaction Code", "pr Period Transactions"."Transaction Code");
                PeriodTrans2.SETRANGE(PeriodTrans2."Employee Code", "pr Period Transactions"."Employee Code");
                IF PeriodTrans2.FIND('-') THEN
                    PrevMonth := PeriodTrans2.Amount;


                IF PrevMonth = Amount THEN
                    CurrReport.SKIP;

                GrandTotal := GrandTotal + Amount;
                GrandBalance := GrandBalance + Balance;
                PrevMonthTot := PrevMonthTot + PrevMonth;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Period Year");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Periods; Periods)
                {
                    Caption = 'Period';
                    TableRelation = "pr Payroll Periods"."Date Opened";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Period field.';
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        //SelectedPeriod:="pr Period Transactions".GETRANGEMIN("Payroll Period");
        objPeriod.RESET;
        objPeriod.SETRANGE(objPeriod."Date Opened", SelectedPeriod);
        IF objPeriod.FIND('-') THEN BEGIN
            PeriodName := objPeriod."Period Name";
        END;



        IF CompanyInfo.GET() THEN
            CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
    end;

    var
        LastFieldNo: Integer;
        objPeriod: Record "pr Payroll Periods";
        SelectedPeriod: Date;
        selectedperiod2: date;
        PeriodName: Text[30];
        GrandTotal: Decimal;
        strEmpName: Text[100];
        objEmp: Record "HR-Employee";
        GrandBalance: Decimal;
        CompanyInfo: Record "Company Information";
        PrevMonth: Decimal;
        PeriodTrans2: Record "pr Period Transactions";
        PrevMonthTot: Decimal;
        Transactions_Variant_ReportCaptionLbl: Label 'Transactions Variant Report';
        User_Name_CaptionLbl: Label 'User Name:';
        Print_Date_CaptionLbl: Label 'Print Date:';
        Period_CaptionLbl: Label 'Period:';
        Page_No_CaptionLbl: Label 'Page No:';
        Description_CaptionLbl: Label 'Description:';
        Period_Amount_CaptionLbl: Label 'Period Amount:';
        Variant_CaptionLbl: Label 'Variant:';
        Employee_No_CaptionLbl: Label 'Employee No.';
        Employee_Name_CaptionLbl: Label 'Employee Name:';
        Prev__Month_CaptionLbl: Label 'Prev. Month:';
        Prepared_by_______________________________________Date_________________CaptionLbl: Label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: Label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: Label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: Label 'Approved by……………………………………………………..                Date……………………………………………';
        Grand_Total_CaptionLbl: Label 'Grand Total:';
        Periods: Date;
}


