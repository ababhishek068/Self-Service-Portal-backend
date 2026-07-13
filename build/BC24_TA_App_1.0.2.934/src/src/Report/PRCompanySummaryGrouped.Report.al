Report 50289 "PR Company Summary - Grouped"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Transaction Codes"; "PR Transaction Codes")
        {
            RequestFilterFields = "Transaction Type", "Transaction Code";
            column(ReportForNavId_1; 1) { }

            //Approvals Start
            column(Approver1; Approver1) { }
            column(Approver2; Approver2) { }
            column(Approver3; Approver3) { }
            column(Approver4; Approver4) { }
            column(Approver5; Approver5) { }
            column(Signature_UserSetup; UserRec1."User Signature") { }
            column(ApprovalDesignation_UserSetup; UserRec1."Approval Title") { }
            column(Signature_UserSetup2; UserRec2."User Signature") { }
            column(ApprovalDesignation_UserSetup2; UserRec2."Approval Title") { }
            column(Signature_UserSetup3; UserRec3."User Signature") { }
            column(ApprovalDesignation_UserSetup3; UserRec3."Approval Title") { }
            column(Signature_UserSetup4; UserRec4."User Signature") { }
            column(ApprovalDesignation_UserSetup4; UserRec4."Approval Title") { }
            column(Signature_UserSetup5; UserRec5."User Signature") { }
            column(ApprovalDesignation_UserSetup5; UserRec5."Approval Title") { }
            column(UserDesign1; UserDesign1) { }
            column(UserDesign2; UserDesign2) { }
            column(UserDesign3; UserDesign3) { }
            column(UserDesign4; UserDesign4) { }
            column(UserDesign5; UserDesign5) { }
            column(ApprovalDate1; ApprovalDate1) { }
            column(ApprovalDate2; ApprovalDate2) { }
            column(ApprovalDate3; ApprovalDate3) { }
            column(ApprovalDate4; ApprovalDate4) { }
            column(ApprovalDate5; ApprovalDate5) { }
            column(UserName1; UserName1) { }
            column(UserName2; UserName2) { }
            column(UserName3; UserName3) { }
            column(UserName4; UserName4) { }
            column(UserName5; UserName5) { }
            //Approvals End
            column(TransactionCode_PRTransactionCodes; "PR Transaction Codes"."Transaction Code") { }
            column(TransactionName_PRTransactionCodes; "PR Transaction Codes"."Transaction Name") { }
            column(TransactionType_PRTransactionCodes; "PR Transaction Codes"."Transaction Type") { }
            column(Amount; Amount) { }
            column(PeriodFilter; PeriodFilter) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(PeriodName; PeriodName) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(AppliedFilters; AppliedFilters) { }
            column(Variant_PeriodFilter; Variant_PeriodFilter) { }
            column(Variant_PeriodAmount; Variant_PeriodAmount) { }
            column(Variance_Amount; Variance_Amount) { }
            column(Cur_No_Assigned; Cur_No_Assigned) { }
            column(Var_No_Assigned; Var_No_Assigned) { }
            column(VarC_No_Assigned; VarC_No_Assigned) { }
            column(Cur_PNAME; Cur_PNAME) { }
            column(Var_PNAME; Var_PNAME) { }
            column(Num_I; Num_I) { }
            column(Num_D; Num_D) { }
            column(Variance_AmountPercentage; Variance_AmountPercentage) { }

            trigger OnAfterGetRecord()
            begin
                ApprovalEntry.reset;
                //ApprovalEntry.setrange("Document No.", "No.");
                ApprovalEntry.SetRange("Sender ID", 'SASRA\JKIMEU');
                ApprovalEntry.setrange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            UserRec1.reset;
                            UserRec1.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec1.find('-') then begin
                                UserRec1.calcfields("User Signature");
                                UserName1 := UserRec1.UserName;
                                UserDesign1 := UserRec1."Approval Title";
                                ApprovalDate1 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            UserRec2.reset;
                            UserRec2.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec2.find('-') then begin
                                UserRec2.calcfields("User Signature");
                                UserName2 := UserRec2.UserName;
                                UserDesign2 := UserRec2."Approval Title";
                                ApprovalDate2 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 3 then begin
                            UserRec3.reset;
                            UserRec3.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec3.find('-') then begin
                                UserRec3.calcfields("User Signature");
                                UserName3 := UserRec2.UserName;
                                UserDesign3 := UserRec2."Approval Title";
                                ApprovalDate3 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 4 then begin
                            UserRec4.reset;
                            UserRec4.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec4.find('-') then begin
                                UserRec4.calcfields("User Signature");
                                UserName4 := UserRec4.UserName;
                                UserDesign4 := UserRec4."Approval Title";
                                ApprovalDate4 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 5 then begin
                            UserRec5.reset;
                            UserRec5.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec5.find('-') then begin
                                UserRec5.calcfields("User Signature");
                                UserName5 := UserRec5.UserName;
                                UserDesign5 := UserRec5."Approval Title";
                                ApprovalDate5 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                    until ApprovalEntry.next = 0;
                END;
                //Approvals End
                //Initialize
                Amount := 0;
                Variant_PeriodAmount := 0;
                Variance_Amount := 0;
                Variance_AmountPercentage := 0;

                CurPeriod_Zero := false;
                VarPeriod_Zero := false;

                Cur_No_Assigned := 0;
                Var_No_Assigned := 0;
                VarC_No_Assigned := 0;

                //Selected Period
                fn_SR_PeriodTrans;
                if PRPeriodTrans.FindFirst() then begin
                    Cur_No_Assigned := PRPeriodTrans.Count;
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    Amount := PRPeriodTrans.Amount;
                end;

                //Variant Period
                fn_SR_Variant_PeriodTrans;
                if PRPeriodTrans.FindFirst() then begin
                    Var_No_Assigned := PRPeriodTrans.Count;
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    Variant_PeriodAmount := PRPeriodTrans.Amount;
                end;

                //Variance
                Variance_Amount := Amount - Variant_PeriodAmount;
                Variance_Amount := ROUND(Variance_Amount, 0.1, '=');

                VarC_No_Assigned := Cur_No_Assigned - Var_No_Assigned;

                //Output Bool
                if Amount = 0 then CurPeriod_Zero := true;
                if Variant_PeriodAmount = 0 then VarPeriod_Zero := true;
                Variant_PeriodAmount := ROUND(Variant_PeriodAmount, 0.1, '=');

                if VarPeriod_Zero and CurPeriod_Zero then CurrReport.Skip;


                //Variance Percentage
                if Variant_PeriodAmount <> 0 then Variance_AmountPercentage := (Variance_Amount / Variant_PeriodAmount) * 100;
                Variance_AmountPercentage := ROUND(Variance_AmountPercentage, 0.1, '=');


                //Counter
                if "PR Transaction Codes"."Transaction Type" = "PR Transaction Codes"."transaction type"::Income then Num_I += 1;
                if "PR Transaction Codes"."Transaction Type" = "PR Transaction Codes"."transaction type"::Deduction then Num_D += 1;
            end;

            trigger OnPreDataItem()
            begin
                //Skip this trans code
                SetFilter("PR Transaction Codes"."Transaction Code", '<>%1', 'E31');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PeriodFilter; PeriodFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Filter';
                        TableRelation = "PR Payroll Periods";
                        ToolTip = 'Specifies the value of the Period Filter field.';
                    }
                    field(Control4; Variant_PeriodFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant Period Filter';
                        TableRelation = "PR Payroll Periods";
                        ToolTip = 'Specifies the value of the Variant Period Filter field.';
                    }

                }
            }
        }

        actions { }
    }

    labels { }


    trigger OnInitReport()
    begin
        // PeriodFilter := HRCodeunit.fn_GetActiveOrPreviousPayrollPeriod('Current Period');
        //Variant_PeriodFilter := HRCodeunit.fn_GetActiveOrPreviousPayrollPeriod('Previous Period');
    end;

    trigger OnPreReport()
    begin


        //Init
        Cur_PNAME := '';
        Var_PNAME := '';

        Num_I := 0;
        Num_D := 0;

        //Default Payroll Period
        // if PeriodFilter = 0D then begin
        //     PRPayrollPeriods.Reset;
        //     PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed, false);
        //     if PRPayrollPeriods.FindFirst() then PeriodFilter := PRPayrollPeriods."Date Opened";
        // end;

        // //Variant Period Filter
        // if Variant_PeriodFilter = 0D then begin
        //     Variant_PeriodFilter := CalcDate('-1M', PeriodFilter); //Prev Period
        // end;

        //Use Period Name - Curr P
        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods."Date Opened", PeriodFilter);
        if PRPayrollPeriods.FindFirst() then Cur_PNAME := PRPayrollPeriods."Period Name";

        //Use Period Name - Var Period
        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods."Date Opened", Variant_PeriodFilter);
        if PRPayrollPeriods.FindFirst() then Var_PNAME := PRPayrollPeriods."Period Name";

        //Save Filters
        AppliedFilters := 'APPLIED FILTER(s) =' + 'Payroll Period: ' + Format(Cur_PNAME)
                        + txt_DirectorateFilter
                        + "PR Transaction Codes".GetFilters;

        //Company Info
        fnCompanyInfo;


    end;

    var
        PRPeriodTrans: Record "PR Period Transactions";
        PeriodFilter: Date;
        Amount: Decimal;
        CompInfo: Record "Company Information";
        PeriodName: Text[30];
        PRPayrollPeriods: Record "PR Payroll Periods";
        AppliedFilters: Text;
        Variant_PeriodFilter: Date;
        Variant_PeriodAmount: Decimal;
        Variance_Amount: Decimal;
        Variance_AmountPercentage: Decimal;
        CurPeriod_Zero: Boolean;
        VarPeriod_Zero: Boolean;
        Cur_No_Assigned: Integer;
        Var_No_Assigned: Integer;
        VarC_No_Assigned: Integer;
        Num_I: Integer;
        Num_D: Integer;
        Cur_PNAME: Text;
        Var_PNAME: Text;
        txt_DirectorateFilter: Text;

        //Approvals Start
        Approver1: Text;
        Approver2: Text;
        Approver3: Text;
        ApprovalEntry: Record "Approval Entry";
        Approver4: Text;
        Approver5: Text;

        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";
        UserName1: text[100];
        ApprovalDate1: DateTime;
        UserName2: text[100];

        UserDesign1: text[100];
        UserDesign2: text[100];
        ApprovalDate2: DateTime;
        UserName3: text[100];
        UserDesign3: text[100];
        ApprovalDate3: DateTime;
        UserName4: text[100];
        UserDesign4: text[100];
        ApprovalDate4: DateTime;
        UserName5: text[100];
        UserDesign5: text[100];
        ApprovalDate5: DateTime;
    //Approvals Ends

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
            CompInfo.CalcFields(CompInfo.Picture);
    end;

    local procedure fn_SR_PeriodTrans()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", "PR Transaction Codes"."Transaction Code");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
    end;

    local procedure fn_SR_Variant_PeriodTrans()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", "PR Transaction Codes"."Transaction Code");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", Variant_PeriodFilter);
    end;
}

