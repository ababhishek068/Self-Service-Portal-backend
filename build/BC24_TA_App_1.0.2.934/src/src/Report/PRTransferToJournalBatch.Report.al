Report 50168 "PR Transfer To Journal Batch"
{
    Caption = 'PR Transfer To Journal';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Transaction Codes"; "PR Transaction Codes")
        {
            RequestFilterFields = "Transaction Code";
            column(ReportForNavId_9285; 9285) { }

            trigger OnAfterGetRecord()
            begin


                //For use when posting Pension and Pension


                LineNumber := LineNumber + 10;

                PeriodTrans.Reset;
                PeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
                PeriodTrans.SetRange(PeriodTrans."Transaction Code", "Transaction Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period", SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Journal Account Code", '<>%1', '');
                //PeriodTrans.SetRange(PeriodTrans."Posting Group", SelectedPostingGroup);
                //Added
                if EmployeeNo <> '' then begin
                    PeriodTrans.SetFilter("Employee Code", EmployeeNo);
                end;

                //Added
                if PeriodTrans.FindFirst() then begin
                    //REPEAT
                    PostingGroup.Get(PeriodTrans."Posting Group");
                    PostingGroup.TestField("SSF Employer Account");
                    PostingGroup.TestField("SSF Employee Account");
                    PostingGroup.TestField("Pension Employer Acc");
                    PostingGroup.TestField("Pension Employee Acc");
                    //Sum all trans
                    PeriodTrans.CalcSums(PeriodTrans.Amount);

                    MyDialog.Update(1, PeriodTrans."Transaction Code" + ' - ' + PeriodTrans."Transaction Name");

                    if PeriodTrans."Journal Account Code" <> '' then begin
                        AmountToDebit := 0;
                        AmountToCredit := 0;
                        if PeriodTrans."Post As" = PeriodTrans."post as"::Debit then
                            AmountToDebit := PeriodTrans.Amount;

                        if PeriodTrans."Post As" = PeriodTrans."post as"::Credit then
                            AmountToCredit := PeriodTrans.Amount;

                        if PeriodTrans."Journal Account Type" = Jac::"G/L Account" then  //GL
                            IntegerPostAs := 0;   //0 debit
                        if PeriodTrans."Journal Account Type" = Jac::Customer then
                            IntegerPostAs := 1;  // 1 =
                        if PeriodTrans."Journal Account Type" = Jac::Vendor then
                            IntegerPostAs := 2;  // 1 =

                        SaccoTransactionType := Saccotransactiontype::" ";

                        if PeriodTrans."Coop Parameters" = PeriodTrans."coop parameters"::Loan then
                            SaccoTransactionType := Saccotransactiontype::Repayment;

                        if PeriodTrans."Coop Parameters" = PeriodTrans."coop parameters"::"Loan Interest" then
                            SaccoTransactionType := Saccotransactiontype::"Interest Paid";

                        if PeriodTrans."Coop Parameters" = PeriodTrans."coop parameters"::Welfare then
                            SaccoTransactionType := Saccotransactiontype::"Welfare Contribution";

                        if PeriodTrans."Coop Parameters" = PeriodTrans."coop parameters"::Shares then
                            SaccoTransactionType := Saccotransactiontype::"Deposit Contribution";



                        CreateJnlEntry(IntegerPostAs, PeriodTrans."Journal Account Code",
                        GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Transaction Code", AmountToDebit, AmountToCredit,
                        PeriodTrans."Post As", '', SaccoTransactionType);

                        //Pension
                        //    IF PeriodTrans."coop parameters"=PeriodTrans."coop parameters"::Pension THEN BEGIN
                        TransCode.Reset;
                        TransCode.SetRange(TransCode."Transaction Code", PeriodTrans."Transaction Code");
                        TransCode.SetRange(TransCode."Special Trans Deductions", TransCode."Special Trans Deductions"::"Defined Contribution");
                        if TransCode.Find('-') then begin

                            //Moe
                            //Get from Employer Deduction
                            EmployerDed.Reset;
                            EmployerDed.SetRange(EmployerDed."Employee Code", PeriodTrans."Employee Code");
                            EmployerDed.SetRange(EmployerDed."Transaction Code", PeriodTrans."Transaction Code");
                            EmployerDed.SetRange(EmployerDed."Payroll Period", PeriodTrans."Payroll Period");
                            if EmployerDed.Find('-') then begin
                                CreateJnlEntry(0, PostingGroup."Pension Employee Acc",
                                GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Transaction Code", 0,
                               EmployerDed.Amount, PeriodTrans."Post As", '', SaccoTransactionType);

                                //Debit Staff Expense
                                CreateJnlEntry(0, PostingGroup."Pension Employer Acc",
                                GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Transaction Code", EmployerDed.Amount, 0, 1, '',
                                SaccoTransactionType);

                            end;
                            //Moe
                        end;

                        //Pension
                        if PeriodTrans."Coop Parameters" = PeriodTrans."coop parameters"::Pension then begin
                            //Credit Payables
                            //Credit Payables

                            CreateJnlEntry(0, PostingGroup."SSF Employee Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Transaction Code", 0, PeriodTrans.Amount,
                            PeriodTrans."Post As", '', SaccoTransactionType);

                            //Debit Staff Expense

                            CreateJnlEntry(0, PostingGroup."SSF Employer Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."Transaction Code", PeriodTrans.Amount, 0, 1, '',
                            SaccoTransactionType);


                        end;

                    end;

                    //UNTIL PeriodTrans.NEXT=0;
                end;
            end;


            trigger OnPostDataItem()
            begin
                EndTime := CreateDatetime(Today, Time);
                TotalTimeTaken := EndTime - StartTime;



                MyDialog.Close();
                Message('Payroll Journal Generated Succesfully [%1]', TotalTimeTaken);
            end;

            trigger OnPreDataItem()
            begin
                BNAME := 'PAYROLL';

                GenJnlBatch.Reset;
                GenJnlBatch.SetRange(GenJnlBatch."Journal Template Name", 'GENERAL');
                GenJnlBatch.SetRange(GenJnlBatch.Name, BNAME);
                if GenJnlBatch.FINDSET() then begin
                    GenJournalLine.DeleteAll;
                end;


                LineNo := 10000;

                //Create batch
                GenJnlBatch.Reset;
                GenJnlBatch.SetRange(GenJnlBatch."Journal Template Name", 'GENERAL');
                GenJnlBatch.SetRange(GenJnlBatch.Name, BNAME);
                if GenJnlBatch.FindFirst() = false then begin
                    GenJnlBatch.Init;
                    GenJnlBatch."Journal Template Name" := 'GENERAL';
                    GenJnlBatch.Name := BNAME;
                    GenJnlBatch.Insert;

                end;
                // End Create Batch

                "Slip/Receipt No" := UpperCase(objPeriod."Period Name");
                DialogInfo := Text0006 + Text0009 + Text0010;
                MyDialog.Open(DialogInfo);
            END;

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(General)
                {
                    Caption = 'Options';
                    field(PeriodFilter; PeriodFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Payroll Period';
                        TableRelation = "PR Payroll Periods";
                        ToolTip = 'Specifies the value of the Payroll Period field.';
                    }
                    // field(SelectedPostingGroup; SelectedPostingGroup)
                    // {
                    //     ApplicationArea = Basic;
                    //     Caption = 'Posting Group';
                    //     TableRelation = "PR Employee Posting Groups".Code;
                    // }
                    field(EmployeeNo; EmployeeNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Employee No.';
                        TableRelation = "HR-Employee"."No.";
                        ToolTip = 'Specifies the value of the Employee No. field.';
                    }
                }
            }
        }

        actions { }

        trigger OnOpenPage()
        begin
            PRPayrollPeriods.Reset();
            PRPayrollPeriods.SetRange(Closed, false);
            if PRPayrollPeriods.FindFirst() then PeriodFilter := PRPayrollPeriods."Date Opened";
        end;
    }

    labels { }

    trigger OnPreReport()
    begin
        StartTime := CreateDatetime(Today, Time);
        EndTime := CreateDatetime(0D, 0T);
        Clear(TotalTimeTaken);

        if PeriodFilter = 0D then Error('You must specify the period filter');
        //if SelectedPostingGroup = '' then Error('Please select Posting Group to transfer to Journal');
        SelectedPeriod := PeriodFilter;
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName := objPeriod."Period Name";

        PostingDate := CalcDate('1M-1D', SelectedPeriod);
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);

        //Dan - Ensure All TransCode have respective GL
        TransCode.Reset;
        TransCode.SetFilter(TransCode."Transaction Code", '<>%1', '');
        if TransCode.FindFirst then begin
            repeat
            //TransCode.TestField(TransCode."GL Account");
            until TransCode.Next = 0;
        end;
        //Dan - Ensure All TransCode have respective GL
    end;

    var
        PRPayrollPeriods: Record "PR Payroll Periods";
        GenJournalLine: Record "Gen. Journal Line";
        PeriodTrans: Record "PR Period Transactions";
        objPeriod: Record "PR Payroll Periods";
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Date;
        CompanyInfo: Record "Company Information";
        LineNo: Integer;
        GeneraljnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        "Slip/Receipt No": Code[50];
        PostingGroup: Record "PR Employee Posting Groups";
        AmountToDebit: Decimal;
        AmountToCredit: Decimal;
        IntegerPostAs: Integer;
        SaccoTransactionType: Option " ","Registration Fee",Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Welfare Contribution","Deposit Contribution","Loan Penalty","Application Fee","Appraisal Fee",Investment,"Unallocated Funds","Shares Capital","Loan Adjustment",Dividend,"Withholding Tax","Administration Fee","Welfare Contribution 2";
        PostingDate: Date;
        GlobalDim1: Code[20];
        GlobalDim2: Code[20];
        EmployerDed: Record "PR Employer Deductions";
        TransCode: Record "PR Transaction Codes";
        LineNumber: Integer;
        MyDialog: Dialog;
        JAC: Option " ","G/L Account",Customer,Vendor;
        StartTime: DateTime;
        EndTime: DateTime;
        TotalTimeTaken: Duration;
        Text0006: label '#1############################3######';
        DialogInfo: Text;
        Text0009: label '#2######';
        Text0010: label '#3######';
        EmployeeNo: Code[100];
        BNAME: Code[20];

    procedure CreateJnlEntry(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]; GlobalDime1: Code[20]; GlobalDime2: Code[20]; Description: Text[150]; DebitAmount: Decimal; CreditAmount: Decimal; PostAs: Option " ",Debit,Credit; LoanNo: Code[20]; TransType: Option " ","Registration Fee",Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Benevolent Fund","Deposit Contribution","Loan Penalty","Application Fee","Appraisal Fee",Investment,"Unallocated Funds","Shares Capital","Loan Adjustment",Dividend,"Withholding Tax","Administration Fee Due","Loan Guard",Prepayment,"Administration Fee Paid","Car Savings","SchFees Savings","Holiday Savings","CIC Fixed Deposit","Withdrawable Savings","Children Savings","KMA Investment","KMA Fixed Deposit","UAP Premiums","UAP Admin Fee","Direct Debit")
    begin

        LineNumber := LineNumber + 100;
        GeneraljnlLine.Init;
        GeneraljnlLine."Journal Template Name" := 'GENERAL';
        GeneraljnlLine."Journal Batch Name" := BNAME;
        GeneraljnlLine."Line No." := LineNumber;
        GeneraljnlLine."Document No." := "Slip/Receipt No";
        //GeneraljnlLine."Loan No":=LoanNo;
        //GeneraljnlLine."Transaction Type":=TransType;
        GeneraljnlLine."Posting Date" := PostingDate;
        GeneraljnlLine."Account Type" := AccountType;
        GeneraljnlLine."Account No." := AccountNo;
        GeneraljnlLine.Validate(GeneraljnlLine."Account No.");
        GeneraljnlLine.Description := Description;
        if PostAs = Postas::Debit then begin
            GeneraljnlLine."Debit Amount" := DebitAmount;
            GeneraljnlLine.Validate("Debit Amount");
        end else begin
            GeneraljnlLine."Credit Amount" := CreditAmount;
            GeneraljnlLine.Validate("Credit Amount");
        end;
        GeneraljnlLine."Shortcut Dimension 1 Code" := GlobalDime1;
        GeneraljnlLine.Validate(GeneraljnlLine."Shortcut Dimension 1 Code");
        GeneraljnlLine."Shortcut Dimension 2 Code" := GlobalDime2;
        GeneraljnlLine.Validate(GeneraljnlLine."Shortcut Dimension 2 Code");
        if GeneraljnlLine.Amount <> 0 then
            GeneraljnlLine.Insert;
    end;
}

