report 50182 "PR Payroll Summary-Group Codes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PR Payroll Summary-Group Codes.rdlc';
    Caption = 'PR Payroll Summary - Group Codes';
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Transaction Codes"; "PR Transaction Codes")
        {
            DataItemTableView = SORTING("Transaction Code")
                                ORDER(Descending)
                                WHERE("Group Code" = FILTER(<> ''));
            RequestFilterFields = "Group Code", "Transaction Code";
            column(GroupCode_PRTransactionCodes; "PR Transaction Codes"."Group Code") { }
            column(GroupDescription_PRTransactionCodes; "PR Transaction Codes"."Group Description") { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(PeriodName; PeriodName) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(AppliedFilters; AppliedFilters) { }
            column(ReportTitle; ReportTitle) { }
            dataitem("PR Period Transactions"; "PR Period Transactions")
            {
                DataItemLink = "Transaction Code" = FIELD("Transaction Code");
                //DataItemTableView = SORTING()
                RequestFilterFields = "Posting Group";
                column(TransactionName_PRPeriodTransactions; "PR Period Transactions"."Transaction Name") { }
                column(TransactionCode_PRPeriodTransactions; "PR Period Transactions"."Transaction Code") { }
                column(EmployeeCode_PRPeriodTransactions; "PR Period Transactions"."Employee Code") { }
                column(Balance_PRPeriodTransactions; "PR Period Transactions".Balance) { }
                column(Amount_PRPeriodTransactions; "PR Period Transactions".Amount) { }
                column(EmpName; EmpName) { }
                column(IDNumber; IDNumber) { }
                column(BLN_No; BLN_No) { }
                column(ReferenceNo_PRPeriodTransactions; "PR Period Transactions"."Reference No") { }

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

                    EmpName := '';
                    IDNumber := '';

                    CLEAR(HREmp);
                    IF HREmp.GET("PR Period Transactions"."Employee Code") THEN BEGIN
                        EmpName := UPPERCASE(HREmp."Full Name");
                        IDNumber := HREmp."ID Number";
                    END;

                    BLN_No := '';

                    //Get Reference No
                    PREmpTrans.RESET;
                    PREmpTrans.SETRANGE(PREmpTrans."Payroll Period", SelectedPeriod);
                    PREmpTrans.SETRANGE(PREmpTrans."Transaction Code", "PR Period Transactions"."Transaction Code");

                    IF PREmpTrans.FIND('-') THEN BEGIN
                        BLN_No := PREmpTrans."Reference No";
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
                end;

                trigger OnPreDataItem();
                begin

                    "PR Period Transactions".SETRANGE("PR Period Transactions"."Payroll Period", SelectedPeriod);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(SelectedPeriod; SelectedPeriod)
                {
                    Caption = 'Payroll Period';
                    TableRelation = "PR Payroll Periods"."Date Opened";
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field(ReportTitle; ReportTitle)
                {
                    Caption = 'Report Title';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Report Title field.';
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    begin
        IF SelectedPeriod = 0D THEN ERROR('Please enter selected period');

        //Company Info
        fnCompanyInfo;

        //Period Name
        PRPayrollPeriods.RESET;
        PRPayrollPeriods.SETRANGE(PRPayrollPeriods."Date Opened", SelectedPeriod);
        IF PRPayrollPeriods.FIND('-') THEN PeriodName := PRPayrollPeriods."Period Name";


    end;

    var
        SelectedPeriod: Date;
        CompInfo: Record "Company Information";
        PeriodName: Text[30];
        AppliedFilters: Text;
        PRPayrollPeriods: Record "PR Payroll Periods";
        EmpName: Text;
        HREmp: Record "HR-Employee";
        IDNumber: Text;
        PREmpTrans: Record "PR Employee Transactions";
        BLN_No: Text;
        ReportTitle: Text;
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

    procedure fnCompanyInfo();
    begin
        CompInfo.RESET;
        IF CompInfo.GET THEN
            CompInfo.CALCFIELDS(CompInfo.Picture);
    end;
}

