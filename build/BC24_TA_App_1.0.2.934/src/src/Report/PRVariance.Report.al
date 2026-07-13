Report 50283 PRVariance
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'PR Variance Report';

    dataset
    {
        dataitem("prPeriod Transactions"; "pr Period Transactions")
        {
            RequestFilterFields = "Employee Code", "Transaction Code", "Payroll Period", "Current Payroll Period Filter";

            DataItemTableView = WHERE("Transaction Code" = filter(<> 'TOT-DED|TXCHRG|TXBP|GPAY|NPAY'));
            column(Employee_Code; "Employee Code") { }
            column(Transaction_Code; "Transaction Code") { }
            column(Transaction_Name; "Transaction Name") { }
            column(Payroll_Period; "Payroll Period") { }
            column(Prev__Payroll_Period_Filter; "prPeriod Transactions".getfilter("Current Payroll Period Filter")) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            column(Amount; Amount) { }

            column(CurrentAmount; CurrentAmount) { }

            column(EmpName; EmpName) { }

            column(Transaction_Type; "Transaction Type") { }
            column(ApproverID_ApprovalEntry; "ApprovalEntry".UserID) { }
            column(LastDateTimeModified_ApprovalEntry; '') { }

            column(Signature_PreparedBy; UserRec."User Signature") { }
            column(PreparedByDesignation_UserSetup; UserRec."Approval Title") { }
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

            column(SendDate; SendDate) { }
            column(SenderDesign; SenderDesign) { }
            column(SenderName; SenderName) { }
            column(SenderSignature; UserRec6."User Signature") { }

            trigger OnAfterGetRecord()
            begin

                Clear(EmpName);

                HREmp.Reset();
                if HREmp.Get("prPeriod Transactions"."Employee Code") then EmpName := HREmp."Full Name";

                CurrentAmount := 0;

                prTrans.reset;
                prtrans.setrange("Employee Code", "prPeriod Transactions"."Employee Code");
                prtrans.setrange("Transaction Code", "prPeriod Transactions"."Transaction Code");
                prtrans.setfilter("Payroll Period", getfilter("prPeriod Transactions"."Current Payroll Period Filter"));
                if prtrans.find('-') then
                    CurrentAmount := prTrans.Amount;

                if CurrentAmount = "prPeriod Transactions".Amount then
                    CurrReport.Skip();

                //IF (CurrentAmount - "prPeriod Transactions".amount) < 0.01 then CurrReport.Skip();

                PrPayPeriod.reset;
                PrPayPeriod.SetRange("Date Opened", "prPeriod Transactions"."Payroll Period");
                PrPayPeriod.setrange("Approval Status", PrPayPeriod."Approval Status"::Approved);
                if PrPayPeriod.find('-') then begin
                    ApprovalEntry.reset;

                    if ApprovalEntry.find('-') then begin
                        repeat
                            if ApprovalEntry."Sequence No" = 1 then begin
                                UserRec1.reset;
                                UserRec1.setrange("User ID", ApprovalEntry.UserID);
                                if UserRec1.find('-') then begin
                                    UserRec1.calcfields("User Signature");
                                    UserName1 := UserRec1.UserName;
                                    UserDesign1 := UserRec1."Approval Title";
                                    ApprovalDate1 := PrPayPeriod."Date Approved";
                                end;
                            end;
                            if ApprovalEntry."Sequence No" = 2 then begin
                                UserRec2.reset;
                                UserRec2.setrange("User ID", ApprovalEntry.UserID);
                                if UserRec2.find('-') then begin
                                    UserRec2.calcfields("User Signature");
                                    UserName2 := UserRec2.UserName;
                                    UserDesign2 := UserRec2."Approval Title";
                                    ApprovalDate2 := PrPayPeriod."Date Approved";
                                end;
                            end;
                            if ApprovalEntry."Sequence No" = 3 then begin
                                UserRec3.reset;
                                UserRec3.setrange("User ID", ApprovalEntry.UserID);
                                if UserRec3.find('-') then begin
                                    UserRec3.calcfields("User Signature");
                                    UserName3 := UserRec3.UserName;
                                    UserDesign3 := UserRec3."Approval Title";
                                    ApprovalDate3 := PrPayPeriod."Date Approved";
                                end;
                            end;
                            if ApprovalEntry."Sequence No" = 4 then begin
                                UserRec4.reset;
                                UserRec4.setrange("User ID", ApprovalEntry.UserID);
                                if UserRec4.find('-') then begin
                                    UserRec4.calcfields("User Signature");
                                    UserName4 := UserRec4.UserName;
                                    UserDesign4 := UserRec4."Approval Title";
                                    ApprovalDate4 := PrPayPeriod."Date Approved";
                                end;
                            end;
                            if ApprovalEntry."Sequence No" = 5 then begin
                                UserRec5.reset;
                                UserRec5.setrange("User ID", ApprovalEntry.UserID);
                                if UserRec5.find('-') then begin
                                    UserRec5.calcfields("User Signature");
                                    UserName5 := UserRec5.UserName;
                                    UserDesign5 := UserRec5."Approval Title";
                                    ApprovalDate5 := PrPayPeriod."Date Approved";
                                end;
                            end;
                            if ApprovalEntry."Sequence No" = 0 then begin
                                UserRec6.reset;
                                UserRec6.setrange("User ID", ApprovalEntry.UserID);
                                if UserRec6.find('-') then begin
                                    UserRec6.calcfields("User Signature");
                                    SenderName := UserRec6.UserName;
                                    SenderDesign := UserRec6."Approval Title";
                                    SendDate := PrPayPeriod."Date Approved";
                                end;
                            end;

                        until ApprovalEntry.next = 0;
                    end;
                end;



            end;

            trigger OnPreDataItem()
            begin
                CompInf.get;
                CompInf.CalcFields(Picture);
                if "prPeriod Transactions".getfilter("Payroll Period") = '' then
                    error('Please select the Current Payroll period');
                if "prPeriod Transactions".getfilter("Current Payroll Period Filter") = '' then
                    error('Please select the Prev. Payroll period');
            end;
        }

    }



    var
        CompInf: Record "Company Information";
        prTrans: Record "pr Period Transactions";
        CurrentAmount: Decimal;

        EmpName: Text;

        HREmp: Record "HR-Employee";
        //Approvals Start
        PrPayPeriod: record "PR Payroll Periods";
        ApprovalEntry: Record "Payroll Approvers";
        UserRec: Record "User Setup";
        UserRec6: Record "User Setup";
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
        SenderName: text[100];
        SenderDesign: text[100];
        SendDate: DateTime;

    //Approvals Ends
}