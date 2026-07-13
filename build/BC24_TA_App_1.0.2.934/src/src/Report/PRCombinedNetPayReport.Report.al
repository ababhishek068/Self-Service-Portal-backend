report 50117 "PR Combined Net Pay Report"
{
    // version FIN-24-AUG-18

    DefaultLayout = RDLC;
    Caption = 'Net Pay Combined';
    RDLCLayout = './PR Combined Net Pay Report.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")

        {
            DataItemTableView = WHERE(Status = CONST(active));
            RequestFilterFields = "No.", "Contract Type";
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Address2; CompInfo."Address 2") { }
            column(CompInfo_City; CompInfo.City) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(CompInfo_PhoneNo; CompInfo."Phone No.") { }
            column(No_HREmployees; "HR-Employee"."No.") { }
            column(FirstName_HREmployees; "HR-Employee"."First Name") { }
            column(MiddleName_HREmployees; "HR-Employee"."Middle Name") { }
            column(LastName_HREmployees; "HR-Employee"."Last Name") { }

            column(Contract_Type; "HR-Employee"."Contract Type") { }
            column(Date_Of_Birth; "Date Of Birth") { }
            column(SelectedPeriod; SelectedPeriod) { }
            column(PeriodName; PeriodName) { }
            column(TotalGrossPay; TotalGrossPay) { }
            column(TotalDeductions; TotalDeductions) { }
            column(NetPay; NetPay) { }
            column(BasicPay; BasicPay) { }


            column(LineNo; LineNo) { }
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

            trigger OnAfterGetRecord();
            begin
                CLEAR(TotalGrossPay);
                CLEAR(StatutoryDeductions);
                CLEAR(OtherDeductions);
                CLEAR(TotalDeductions);
                CLEAR(NetPay);

                LineNo := LineNo + 1;


                //GROSS PAY
                fnSetrangePRPeriodTrans;
                PRPeriodTrans.SETRANGE("Transaction Code", 'GPAY');
                IF PRPeriodTrans.FINDFIRST() THEN BEGIN
                    TotalGrossPay := PRPeriodTrans.Amount;
                END;

                //STATUTORIES
                fnSetrangePRPeriodTrans;
                PRPeriodTrans.SETRANGE("Group Text", 'STATUTORIES');
                IF PRPeriodTrans.FINDFIRST THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    StatutoryDeductions := PRPeriodTrans.Amount;
                END;

                //OTHER DEDUCTIONS
                fnSetrangePRPeriodTrans;
                PRPeriodTrans.SETRANGE("Transaction Code", 'TOT-DED');
                IF PRPeriodTrans.FINDFIRST THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    OtherDeductions := PRPeriodTrans.Amount;
                END;

                //TOTAL DEDUCTIONS
                TotalDeductions := StatutoryDeductions + OtherDeductions;

                //NET PAY
                fnSetrangePRPeriodTrans;
                PRPeriodTrans.SETRANGE("Transaction Code", 'NPAY');
                IF PRPeriodTrans.FINDFIRST THEN BEGIN
                    NetPay := PRPeriodTrans.Amount;
                END;
                //Basic PAY
                fnSetrangePRPeriodTrans;
                PRPeriodTrans.SETRANGE("Transaction Code", 'BPAY');
                IF PRPeriodTrans.FINDFIRST THEN BEGIN
                    BasicPay := PRPeriodTrans.Amount;
                END;
                PrPayPeriod.reset;
                PrPayPeriod.SetRange("Date Opened", SelectedPeriod);
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

                if NetPay = 0 then CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(SelectedPeriod; SelectedPeriod)
                    {
                        Caption = 'Selected Period';
                        TableRelation = "PR Payroll Periods"."Date Opened";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Selected Period field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    begin
        CompInfo.RESET;
        CompInfo.GET;

        CompInfo.CALCFIELDS(Picture);

        IF SelectedPeriod = 0D THEN ERROR('Please select payroll period');

        PRPayrollPeriods.RESET;
        PRPayrollPeriods.SETRANGE("Date Opened", SelectedPeriod);
        IF PRPayrollPeriods.FINDFIRST THEN PeriodName := PRPayrollPeriods."Period Name";

        CLEAR(LineNo);
    end;

    var
        CompInfo: Record "Company Information";
        PRPayrollPeriods: Record "PR Payroll Periods";
        SelectedPeriod: Date;
        PRPeriodTrans: Record "PR Period Transactions";
        PeriodName: Text;
        TotalGrossPay: Decimal;
        TotalDeductions: Decimal;
        NetPay: Decimal;
        LineNo: Integer;
        StatutoryDeductions: Decimal;
        OtherDeductions: Decimal;
        BasicPay: Decimal;
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

    local procedure fnSetrangePRPeriodTrans();
    begin
        PRPeriodTrans.RESET;
        PRPeriodTrans.SETRANGE("Payroll Period", SelectedPeriod);
        PRPeriodTrans.SETRANGE("Employee Code", "HR-Employee"."No.");
    end;
}

