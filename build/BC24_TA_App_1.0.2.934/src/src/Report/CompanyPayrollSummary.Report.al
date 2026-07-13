report 50094 "Company Payroll Summary"
{
    DefaultLayout = RDLC;
    Caption = 'Payroll Summary';
    RDLCLayout = './Company Summary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Period Transactions"; "PR Period Transactions")
        {
            DataItemTableView = SORTING("Employee Code", "Transaction Code", "Period Month", "Period Year");
            RequestFilterFields = "Employee Code", "Contract Type";



            //Approvals End


            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationName2; CompanyInformation."Name 2") { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(CompanyInformationAddress2; CompanyInformation.Address) { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(REMOVEMAXITERATION; REMOVEMAXITERATION) { }
            column(TransactionCode_PRPeriodTransactions; "PR Period Transactions"."Transaction Code") { }
            column(TransactionName_PRPeriodTransactions; "PR Period Transactions"."Transaction Name") { }
            column(Amount_PRPeriodTransactions; "PR Period Transactions".Amount) { }
            column(GroupOrder_PRPeriodTransactions; "PR Period Transactions"."Group Order") { }
            column(SubGroupOrder_PRPeriodTransactions; "PR Period Transactions"."Sub Group Order") { }
            column(GroupText_PRPeriodTransactions; "PR Period Transactions"."Group Text") { }
            column(TotalDebits; TotalDebits) { }
            column(TotalCredits; TotalCredits) { }
            column(PensionTransCode; PensionTransCode) { }
            column(Transaction_Group; "Transaction Group") { }
            column(Special_Transaction; "Special Transaction") { }
            column(On_Probation; "On Probation") { }
            column(Contract_Type; "Contract Type") { }
            column(Employee_Status; "Employee Status") { }
            column(TotalDebits2; TotalDebits2) { }
            column(Payment_Mode1; "Payment Mode1") { }
            column(Bank_Code1; "Bank Code1") { }

            column(PayPeriod; PayPeriod) { }

            column(PeriodName; PeriodName) { }
            column(NHIFRelief; NHIFRelief) { }

            column(Gpay; Gpay) { }

            //column(Pension; Pension) { }

            column(NSSF;Pension){}
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
                CalcFields("On Probation");



                PrPayPeriod.reset;
                PrPayPeriod.SetRange("Date Opened", "Payroll Period");
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

                //Approvals End
            end;

            trigger OnPreDataItem();
            begin
                "PR Period Transactions".SETRANGE("Payroll Period", PayPeriod);

                CLEAR(TotalDebits);
                CLEAR(TotalDebits2);
                CLEAR(TotalCredits);
                CLEAR(TotalDeductions);
                CLEAR(TotOthers);
                CLEAR(NHIFRelief);
                CLEAR(TotPension);

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period");
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);

                // PRPeriodTrans.SETFILTER("Transaction Code", '%1|%2', 'GPAY', 'Pension');
                PRPeriodTrans.SETRange("Transaction Code", 'GPAY');
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINd('-') THEN BEGIN
                    repeat
                        Gpay := Gpay + PRPeriodTrans.Amount;
                    until PRPeriodTrans.next = 0;
                END;
                PRPeriodTrans.RESET;
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                PRPeriodTrans.SETRange("Transaction Code", 'Pension');
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINd('-') THEN BEGIN
                    repeat
                        Pension := Pension + PRPeriodTrans.Amount;
                    until PRPeriodTrans.next = 0;
                END;
                PRPeriodTrans.RESET;
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                PRPeriodTrans.SETRange("Transaction Code", PensionTransCode);
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINd('-') THEN BEGIN
                    repeat
                        Pension := Pension + (PRPeriodTrans.Amount * 2);
                    until PRPeriodTrans.next = 0;
                END;

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period");
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                PRPeriodTrans.SETFILTER("Transaction Code", '%1', 'BPAY');
                PRPeriodTrans.SETFILTER("On Probation", '%1', False);
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    repeat
                        if (PRPeriodTrans."Contract Type" <> 'INTERN') and (PRPeriodTrans."Contract Type" <> 'CONTRACT') and (PRPeriodTrans."Contract Type" <> 'SECONDED') then
                            TotalDebits2 := TotalDebits2 + PRPeriodTrans.Amount;
                    until PRPeriodTrans.next = 0;
                END;
                TotalDebits2 := TotalDebits2 * 0.14; //Transfer to Setup

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period");
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                PRPeriodTrans.SETRANGE("Group Text", 'DEDUCTIONS');
                PRPeriodTrans.SETFILTER("Transaction Code", '<>%1', PensionTransCode);
                PRPeriodTrans.SETRANGE("Sub Group Order", 0);
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINDSET THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    TotalDeductions := PRPeriodTrans.Amount;
                END;

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period");
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                PRPeriodTrans.SETFILTER("Transaction Code", '%1|%2|%3', 'NHIF', 'PAYE', 'NPAY');
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINDSET THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    TotOthers := PRPeriodTrans.Amount;
                END;

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period");
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                PRPeriodTrans.SETFILTER("Transaction Code", '%1', 'NHIF-RL');
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINDSET THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    NHIFRelief := PRPeriodTrans.Amount;
                END;

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period");
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                // PRPeriodTrans.SETFILTER("Transaction Code", '%1', PensionTransCode);
                PRPeriodTrans.SETFILTER("Special Transaction", '%1', "Special Transaction"::"Defined Contribution");
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINDSET THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    TotPension := PRPeriodTrans.Amount;
                END;

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period");
                PRPeriodTrans.SETRANGE("Payroll Period", PayPeriod);
                PRPeriodTrans.SETFILTER("Transaction Code", '%1', 'Pension');
                IF "PR Period Transactions".GETFILTER("Employee Code") <> '' THEN
                    PRPeriodTrans.SETRANGE("Employee Code", "PR Period Transactions".GETFILTER("Employee Code"));
                IF PRPeriodTrans.FINDSET THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    TotPension := PRPeriodTrans.Amount * 2;
                END;



                TotalCredits := TotalDeductions + TotOthers + TotPension + NHIFRelief; // + (TotPension * 3);
                TotalDebits := TotalDebits + (TotalDebits2);
                TotalDebits := TotalDebits;
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
                //Caption = 'General';
                group(Options)
                {
                    Caption = 'Options';
                    field("Payroll Period"; PayPeriod)
                    {
                        TableRelation = "PR Payroll Periods"."Date Opened";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PayPeriod field.';
                    }
                    field(PensionTransCode; PensionTransCode)
                    {
                        Caption = 'Pension Transaction Code';
                        TableRelation = "PR Transaction Codes"."Transaction Code";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Pension Transaction Code field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    var
        PRPayrollPeriod: Record "PR Payroll Periods";
    begin
        CompanyInformation.RESET;
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);

        PeriodName := '';
        PRPayrollPeriod.Reset();
        PRPayrollPeriod.SetRange("Date Opened", PayPeriod);
        if PRPayrollPeriod.FindFirst() then begin
            PeriodName := PRPayrollPeriod."Period Name";
        end;

    end;

    var
        CompanyInformation: Record "Company Information";
        REMOVEMAXITERATION: Text;
        PayPeriod: Date;
        TotalDebits: Decimal;
        TotalDebits2: Decimal;
        TotalCredits: Decimal;
        PRPeriodTrans: Record "PR Period Transactions";
        PensionTransCode: Code[10];
        TotalDeductions: Decimal;
        TotOthers: Decimal;
        NHIFRelief: Decimal;
        TotPension: Decimal;
        //TotPension: Decimal;

        PeriodName: text;
        Gpay: Decimal;
        Pension: Decimal;
        //Pension: Decimal;


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

    trigger OnPostReport()
    begin
        //Message('Pension Employer is = %1, Pension Employee is = %2, and Pension * 3 = %3', TotPension * 2, TotPension, TotPension * 3);
    end;
}

