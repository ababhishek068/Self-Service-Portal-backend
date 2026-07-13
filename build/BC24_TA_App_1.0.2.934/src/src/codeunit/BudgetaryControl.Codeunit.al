Codeunit 50044 "Budgetary Control"
{

    trigger OnRun()
    begin
    end;

    var
        BCSetup: Record "Budgetary Control Setup";
        BudgetGL: Code[20];
        Text0001: label 'You Have exceeded the Budget by ';
        Text0002: label ' Do you want to Continue?';
        Text0003: label 'There is no Budget to Check against do you wish to continue?';
        DeleteCommitment: Record "Committment";

    procedure CheckPurchase(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        Commitments: Record "Committment";
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
    begin
        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (PurchHeader."Document Date" < BCSetup."Current Budget Start Date") then begin
                Error('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3', PurchHeader."Document Date",
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            end
            else
                if (PurchHeader."Document Date" > BCSetup."Current Budget End Date") then begin
                    Error('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3', PurchHeader."Document Date",
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
            //Get Commitment Lines
            if Commitments.Find('+') then
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PurchLine.Reset;
            PurchLine.SetRange(PurchLine."Document Type", PurchHeader."Document Type");
            PurchLine.SetRange(PurchLine."Document No.", PurchHeader."No.");
            if PurchLine.FindFirst then begin
                repeat
                    if PurchLine."No." <> '' then begin
                        /*  //Get the Dimension Here
                            IF PurchLine."Line No." <> 0 THEN
                                 DimMgt.ShowDocDim(
                                   DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Dimension Set ID",
                                   PurchLine."Line No.",ShortcutDimCode)
                               ELSE
                                DimMgt.ShowTempDim(ShortcutDimCode);  */
                        //Had to be put here for the sake of Calculating Individual Line Entries

                        //check the type of account in the payments line
                        //Item
                        if PurchLine.Type = PurchLine.Type::Item then begin
                            Item.Reset;
                            if not Item.Get(PurchLine."No.") then
                                Error('Item Does not Exist');

                            //Item.TESTFIELD("Item G/L Budget Account");

                            PurchLine.TestField("G/L Account");

                            BudgetGL := PurchLine."G/L Account";
                        end;
                        //  MESSAGE('FOUND');
                        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
                            FixedAssetsDet.Reset;
                            FixedAssetsDet.SetRange(FixedAssetsDet."No.", PurchLine."No.");
                            if FixedAssetsDet.Find('-') then begin
                                //FixedAssetsDet.CALCFIELDS(FixedAssetsDet."FA Posting Group");
                                FAPostingGRP.Reset;
                                FAPostingGRP.SetRange(FAPostingGRP.Code, FixedAssetsDet."FA Posting Group");
                                if FAPostingGRP.Find('-') then
                                    if PurchLine."FA Posting Type" = PurchLine."fa posting type"::Maintenance then begin
                                        BudgetGL := FAPostingGRP."Maintenance Expense Account";
                                        if BudgetGL = '' then
                                            Error('Ensure Fixed Asset No %1 has the Maintenance G/L Account', PurchLine."No.");
                                    end else begin
                                        BudgetGL := FAPostingGRP."Acquisition Cost Account";
                                        if BudgetGL = '' then
                                            Error('Ensure Fixed Asset No %1 has the Acquisition G/L Account', PurchLine."No.");
                                    end;
                            end;
                        end;

                        if PurchLine.Type = PurchLine.Type::"G/L Account" then begin
                            BudgetGL := PurchLine."No.";
                            if GLAcc.Get(PurchLine."No.") then
                                GLAcc.TestField(GLAcc."Budget Controlled", true);
                        end;

                        //End Checking Account in Payment Line

                        //check the votebook now
                        FirstDay := Dmy2date(1, Date2dmy(PurchHeader."Document Date", 2), Date2dmy(PurchHeader."Document Date", 3));
                        CurrMonth := Date2dmy(PurchHeader."Document Date", 2);
                        if CurrMonth = 12 then begin
                            LastDay := Dmy2date(1, 1, Date2dmy(PurchHeader."Document Date", 3) + 1);
                            LastDay := CalcDate('-1D', LastDay);
                        end
                        else begin
                            CurrMonth := CurrMonth + 1;
                            LastDay := Dmy2date(1, CurrMonth, Date2dmy(PurchHeader."Document Date", 3));
                            LastDay := CalcDate('-1D', LastDay);
                        end;
                        //check the summation of the budget in the database
                        BudgetAmount := 0;
                        Budget.Reset;
                        Budget.SetRange(Budget."Budget Name", BCSetup."Current Budget Code");
                        Budget.SetFilter(Budget.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                        Budget.SetRange(Budget."G/L Account No.", BudgetGL);
                        if BCSetup."Ignore Budget Departments" = false then begin
                            Budget.SetRange(Budget."Global Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                            // IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                            Budget.SetRange(Budget."Global Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                        end;
                        //Budget.SETRANGE(Budget."Budget Dimension 1 Code",ShortcutDimCode[3]);
                        // Budget.SETRANGE(Budget."Budget Dimension 2 Code",ShortcutDimCode[4]);
                        if Budget.Find('-') then begin
                            repeat
                                BudgetAmount := BudgetAmount + Budget.Amount;
                            until Budget.Next = 0;
                        end;

                        //get the committments
                        CommitmentAmount := 0;
                        Commitments.Reset;
                        Commitments.SetCurrentkey(Commitments.Budget, Commitments."G/L Account No.",
                        Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                        Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                        Commitments.SetRange(Commitments.Budget, BCSetup."Current Budget Code");
                        Commitments.SetRange(Commitments."G/L Account No.", BudgetGL);
                        Commitments.SetRange(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);

                        if BCSetup."Ignore Budget Departments" = false then begin
                            Commitments.SetRange(Commitments."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                            //                    IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");

                        end;
                        // Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                        // Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                        Commitments.SetRange(Commitments.Committed, true);
                        Commitments.CalcSums(Commitments.Amount);
                        CommitmentAmount := Commitments.Amount;
                        //check if there is any budget
                        if (BudgetAmount <= 0) then begin
                            Error('No Budget To Check Against');
                        end;

                        //check if the actuals plus the amount is greater then the budget amount
                        if ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)") > BudgetAmount) and
                        (BCSetup."Allow OverExpenditure" = false) then begin
                            Error('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                            PurchLine."Document No.", PurchLine.Type, PurchLine."No.",
                              Format(Abs(BudgetAmount - (CommitmentAmount + ActualsAmount + PurchLine."Outstanding Amount (LCY)"))));
                        end else begin
                            Commitments.Reset;
                            Commitments.Init;
                            EntryNo += 1;
                            Commitments."Line No." := EntryNo;
                            Commitments.Date := Today;
                            Commitments."Posting Date" := PurchHeader."Document Date";
                            if PurchHeader."Document Type" = PurchHeader."document type"::Order then
                                Commitments."Document Type" := Commitments."document type"::LPO
                            else
                                Commitments."Document Type" := Commitments."document type"::Requisition;

                            if PurchHeader."Document Type" = PurchHeader."document type"::Invoice then
                                Commitments."Document Type" := Commitments."document type"::PurchInvoice;

                            Commitments."Document No." := PurchHeader."No.";
                            Commitments.Amount := PurchLine.Amount;
                            Commitments.Description := PurchLine.Description;
                            Commitments."Month Budget" := BudgetAmount;
                            Commitments."Month Actual" := ActualsAmount;
                            Commitments.Committed := true;
                            Commitments."Committed By" := UserId;
                            Commitments."Committed Date" := PurchHeader."Document Date";
                            Commitments."G/L Account No." := BudgetGL;
                            Commitments."Committed Time" := Time;
                            //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                            Commitments.Validate("Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                            Commitments.Validate("Shortcut Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                            //  Commitments.VALIDATE("Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                            //   Commitments.VALIDATE("Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                            Commitments.Committed := true;
                            Commitments.Budget := BCSetup."Current Budget Code";
                            Commitments.Type := Commitments.Type::Vendor;
                            Commitments."Vendor/Cust No." := PurchHeader."Buy-from Vendor No.";
                            Commitments."Document Line No." := PurchLine."Line No.";
                            Commitments."Item No." := PurchLine."No.";
                            Commitments.Insert;
                            //Tag the Purchase Line as Committed
                            PurchLine.Committed := true;
                            PurchLine.Modify;
                            //End Tagging PurchLines as Committed
                        end;
                    end;
                until PurchLine.Next = 0;
            end;
        end
        else//budget control not mandatory
          begin

        end;

    end;

    procedure CheckPayments(var PaymentHeader: Record "Payments Header")
    var
        PayLine: Record "Payment Line";
        Commitments: Record "Committment";
        GLAcc: Record "G/L Account";
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        BudgetAmount: Decimal;
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        EntryNo: Integer;
    begin

        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (PaymentHeader.Date < BCSetup."Current Budget Start Date") then begin
                Error('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3', PaymentHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            end
            else
                if (PaymentHeader.Date > BCSetup."Current Budget End Date") then begin
                    Error('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3', PaymentHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            if Commitments.Find('+') then
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.Reset;
            PayLine.SetRange(PayLine.No, PaymentHeader."No.");
            PayLine.SetRange(PayLine."Account Type", PayLine."account type"::"G/L Account");
            PayLine.SetRange(PayLine."Budgetary Control A/C", true);
            if PayLine.FindFirst then begin
                repeat
                    //check the votebook now
                    FirstDay := Dmy2date(1, Date2dmy(PaymentHeader.Date, 2), Date2dmy(PaymentHeader.Date, 3));
                    CurrMonth := Date2dmy(PaymentHeader.Date, 2);
                    if CurrMonth = 12 then begin
                        LastDay := Dmy2date(1, 1, Date2dmy(PaymentHeader.Date, 3) + 1);
                        LastDay := CalcDate('-1D', LastDay);
                    end
                    else begin
                        CurrMonth := CurrMonth + 1;
                        LastDay := Dmy2date(1, CurrMonth, Date2dmy(PaymentHeader.Date, 3));
                        LastDay := CalcDate('-1D', LastDay);
                    end;

                    BudgetGL := PayLine."Account No.";



                    GLAcc.reset;
                    GLAcc.setrange("No.", BudgetGL);
                    GLAcc.setfilter("Date Filter", '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    if BCSetup."Ignore Budget Departments" = false then begin
                        GLAcc.setfilter("Global Dimension 1 Filter", PayLine."Global Dimension 1 Code");
                        GLAcc.setfilter("Global Dimension 2 Filter", PayLine."Shortcut Dimension 2 Code");
                        GLAcc.setfilter("Global Dimension 3 Filter", PayLine."Shortcut Dimension 3 Code");
                        GLAcc.setfilter("Global Dimension 4 Filter", PayLine."Shortcut Dimension 4 Code");
                    end;
                    if GLAcc.find('-') then begin
                        GLAcc.CalcFields("Net Change");
                        GLAcc.CalcFields("Committment Amount");
                        GLAcc.CalcFields("Budgeted Amount");
                        CommitmentAmount := GLAcc."Committment Amount";
                        BudgetAmount := GLAcc."Budgeted Amount";
                        ActualsAmount := GLAcc."Net Change";

                    end;

                    //check if there is any budget
                    if (BudgetAmount <= 0) and not (BCSetup."Allow OverExpenditure") then begin
                        Error('No Budget To Check Against');
                    end else begin
                        if (BudgetAmount <= 0) then begin
                            if not Confirm(Text0003, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;
                    end;

                    //check if the actuals plus the amount is greater then the budget amount
                    if ((CommitmentAmount + PayLine."NetAmount LCY" + ActualsAmount) > BudgetAmount)
                    and not (BCSetup."Allow OverExpenditure") then begin
                        Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, PayLine.Type, PayLine.No,
                          Format(Abs(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."NetAmount LCY"))));
                    end else begin
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        if ((CommitmentAmount + PayLine."NetAmount LCY" + ActualsAmount) > BudgetAmount) then begin
                            if not Confirm(Text0001 +
                            Format(Abs(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."NetAmount LCY")))
                            + Text0002, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;

                        Commitments.Reset;
                        Commitments.Init;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := Today;
                        Commitments."Posting Date" := PaymentHeader.Date;
                        if PaymentHeader."Payment Type" = PaymentHeader."payment type"::Normal then
                            Commitments."Document Type" := Commitments."document type"::"Payment Voucher"
                        else
                            Commitments."Document Type" := Commitments."document type"::PettyCash;
                        Commitments."Document No." := PaymentHeader."No.";
                        Commitments.Amount := PayLine."NetAmount LCY";
                        Commitments.Description := PaymentHeader."Payment Narration";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := true;
                        Commitments."Committed By" := UserId;
                        Commitments."Committed Date" := PaymentHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := Time;
                        //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments.Validate("Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                        Commitments.Validate("Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                        Commitments.Validate("Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                        Commitments.Validate("Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments."Document Line No." := PayLine."Line No.";
                        Commitments.Insert;
                        //Tag the Payment Line as Committed
                        PayLine.Committed := true;
                        PayLine.Modify;
                        //End Tagging Payment Lines as Committed
                    end;

                until PayLine.Next = 0;
            end;
        end
        else//budget control not mandatory
          begin

        end;
        Message('Budgetary Checking Completed Successfully');
    end;

    procedure CheckImprest(var ImprestHeader: Record "Imprest Header")
    var
        PayLine: Record "Imprest Lines";
        Commitments: Record "Committment";
        GLAcc: Record "G/L Account";
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        BudgetAmount: Decimal;
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        EntryNo: Integer;
    begin

        /************************************************* */
        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ImprestHeader.Date < BCSetup."Current Budget Start Date") then begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            end
            else
                if (ImprestHeader.Date > BCSetup."Current Budget End Date") then begin
                    Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            if Commitments.Find('+') then
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.Reset;
            PayLine.SetRange(PayLine.No, ImprestHeader."No.");
            // PayLine.SetRange(PayLine."Budgetary Control A/C", true);
            if PayLine.FindFirst then begin
                repeat
                    //check the votebook now
                    FirstDay := Dmy2date(1, Date2dmy(ImprestHeader.Date, 2), Date2dmy(ImprestHeader.Date, 3));
                    CurrMonth := Date2dmy(ImprestHeader.Date, 2);
                    if CurrMonth = 12 then begin
                        LastDay := Dmy2date(1, 1, Date2dmy(ImprestHeader.Date, 3) + 1);
                        LastDay := CalcDate('-1D', LastDay);
                    end
                    else begin
                        CurrMonth := CurrMonth + 1;
                        LastDay := Dmy2date(1, CurrMonth, Date2dmy(ImprestHeader.Date, 3));
                        LastDay := CalcDate('-1D', LastDay);
                    end;

                    //The GL Account
                    BudgetGL := PayLine."Account No:";


                    GLAcc.reset;
                    GLAcc.setrange("No.", BudgetGL);
                    GLAcc.setfilter("Date Filter", '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    if BCSetup."Ignore Budget Departments" = false then begin
                        GLAcc.setfilter("Global Dimension 1 Filter", PayLine."Global Dimension 1 Code");
                        GLAcc.setfilter("Global Dimension 2 Filter", PayLine."Shortcut Dimension 2 Code");
                        GLAcc.setfilter("Global Dimension 3 Filter", PayLine."Shortcut Dimension 3 Code");
                        GLAcc.setfilter("Global Dimension 4 Filter", PayLine."Shortcut Dimension 4 Code");
                    end;
                    if GLAcc.find('-') then begin
                        GLAcc.CalcFields("Net Change");
                        GLAcc.CalcFields("Committment Amount");
                        GLAcc.CalcFields("Budgeted Amount");
                        CommitmentAmount := GLAcc."Committment Amount";
                        BudgetAmount := GLAcc."Budgeted Amount";
                        ActualsAmount := GLAcc."Net Change";

                    end;

                    //check if there is any budget
                    if (BudgetAmount <= 0) and not (BCSetup."Allow OverExpenditure") then begin
                        Error('No Budget To Check Against');
                    end else begin
                        if (BudgetAmount <= 0) then begin
                            if not Confirm(Text0003, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;
                    end;

                    //check if the actuals plus the amount is greater then the budget amount
                    if ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount)
                    and not (BCSetup."Allow OverExpenditure") then begin
                        Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, 'Staff Imprest', PayLine.No,
                          Format(Abs(BudgetAmount - (CommitmentAmount + PayLine."Amount LCY"))));
                    end else begin
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        if ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount) then begin
                            if not Confirm(Text0001 +
                            Format(Abs(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."Amount LCY")))
                            + Text0002, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;

                        Commitments.Reset;
                        Commitments.Init;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := Today;
                        Commitments."Posting Date" := ImprestHeader.Date;
                        Commitments."Document Type" := Commitments."document type"::Imprest;
                        Commitments."Document No." := ImprestHeader."No.";
                        Commitments.Amount := PayLine.Amount;
                        Commitments.Description := PayLine.Purpose;
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := true;
                        Commitments."Committed By" := UserId;
                        Commitments."Committed Date" := ImprestHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := Time;
                        //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments.Validate("Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                        Commitments.Validate("Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                        Commitments.Validate("Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                        Commitments.Validate("Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := ImprestHeader."Account Type";
                        Commitments."Vendor/Cust No." := ImprestHeader."Account No.";
                        Commitments."Document Line No." := PayLine."Line No.";
                        Commitments.Insert;
                        //Tag the Imprest Line as Committed
                        PayLine.Committed := true;
                        PayLine.Modify;
                        //End Tagging Imprest Lines as Committed
                    end;

                until PayLine.Next = 0;
            end;
        end
        else//budget control not mandatory
          begin

        end;
        Message('Budgetary Checking Completed Successfully');

    end;

    procedure ReverseEntries(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance; DocNo: Code[20])
    var
        Commitments: Record "Committment";
        EntryNo: Integer;
        CommittedLines: Record "Committment";
    begin
        //Get Commitment Lines
        Commitments.Reset;
        if Commitments.Find('+') then
            EntryNo := Commitments."Line No.";

        CommittedLines.Reset;
        // CommittedLines.SetRange(CommittedLines."Document Type", DocumentType);
        CommittedLines.SetRange(CommittedLines."Document No.", DocNo);
        CommittedLines.SetRange(CommittedLines.Committed, true);
        if CommittedLines.Find('-') then begin
            repeat
                Commitments.Reset;
                Commitments.Init;
                EntryNo += 1;
                Commitments."Line No." := EntryNo;
                Commitments.Date := Today;
                Commitments."Posting Date" := CommittedLines."Posting Date";
                Commitments."Document Type" := CommittedLines."Document Type";
                Commitments."Document No." := CommittedLines."Document No.";
                Commitments.Amount := -CommittedLines.Amount;
                Commitments.Description := CommittedLines.Description;
                Commitments."Month Budget" := CommittedLines."Month Budget";
                Commitments."Month Actual" := CommittedLines."Month Actual";
                Commitments.Committed := false;
                Commitments."Committed By" := UserId;
                Commitments."Committed Date" := CommittedLines."Committed Date";
                Commitments."G/L Account No." := CommittedLines."G/L Account No.";
                Commitments."Committed Time" := Time;
                //     Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                Commitments.Validate("Shortcut Dimension 1 Code", CommittedLines."Shortcut Dimension 1 Code");
                Commitments.Validate("Shortcut Dimension 2 Code", CommittedLines."Shortcut Dimension 2 Code");
                Commitments.Validate("Shortcut Dimension 3 Code", CommittedLines."Shortcut Dimension 3 Code");
                Commitments.Validate("Shortcut Dimension 4 Code", CommittedLines."Shortcut Dimension 4 Code");
                Commitments.Budget := CommittedLines.Budget;
                Commitments."Document Line No." := CommittedLines."Document Line No.";
                Commitments.Insert;

                CommittedLines.Committed := false;
                CommittedLines.modify;
            until CommittedLines.Next = 0;
        end;
    end;

    procedure ReverseEntriesPerItem(DocNo: Code[20]; ItemNo: code[20]; OrderNo: code[20])
    var
        Commitments: Record "Committment";
        EntryNo: Integer;
        CommittedLines: Record "Committment";
    begin
        //Get Commitment Lines
        Commitments.Reset;
        if Commitments.Find('+') then
            EntryNo := Commitments."Line No.";

        CommittedLines.Reset;
        CommittedLines.SetRange(CommittedLines."Item No.", ItemNo);
        CommittedLines.SetRange(CommittedLines."Document No.", DocNo);
        CommittedLines.SetRange(CommittedLines.Committed, true);
        if CommittedLines.Find('-') then begin
            repeat
                Commitments.Reset;
                Commitments.Init;
                EntryNo += 1;
                Commitments."Line No." := EntryNo;
                Commitments.Date := Today;
                Commitments."Posting Date" := CommittedLines."Posting Date";
                Commitments."Document Type" := CommittedLines."Document Type";
                Commitments."Document No." := CommittedLines."Document No.";
                Commitments.Amount := -CommittedLines.Amount;
                Commitments.Description := CommittedLines.Description;
                Commitments."Month Budget" := CommittedLines."Month Budget";
                Commitments."Month Actual" := CommittedLines."Month Actual";
                Commitments.Committed := false;
                Commitments."Committed By" := UserId;
                Commitments."Committed Date" := CommittedLines."Committed Date";
                Commitments."G/L Account No." := CommittedLines."G/L Account No.";
                Commitments."Committed Time" := Time;
                //     Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                Commitments.Validate("Shortcut Dimension 1 Code", CommittedLines."Shortcut Dimension 1 Code");
                Commitments.Validate("Shortcut Dimension 2 Code", CommittedLines."Shortcut Dimension 2 Code");
                Commitments.Validate("Shortcut Dimension 3 Code", CommittedLines."Shortcut Dimension 3 Code");
                Commitments.Validate("Shortcut Dimension 4 Code", CommittedLines."Shortcut Dimension 4 Code");
                Commitments.Budget := CommittedLines.Budget;
                Commitments."Document Line No." := CommittedLines."Document Line No.";
                Commitments."Cancelled By" := OrderNo;
                Commitments.Insert;

                CommittedLines.Committed := false;
                CommittedLines.modify;
            until CommittedLines.Next = 0;
        end;
    end;

    procedure ReversePurchaseReqEntries(PurchaseLines: Record "Purchase Line")
    begin
        //Get Commitment Lines
        DeleteCommitment.Reset;
        //DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."document type"::Requisition);
        DeleteCommitment.SetRange(DeleteCommitment."Document No.", PurchaseLines."Document No.");
        DeleteCommitment.SetRange(DeleteCommitment."Document Line No.", PurchaseLines."Line No.");
        if DeleteCommitment.Find('-') then begin
            DeleteCommitment.Committed := false;
            DeleteCommitment.Cancelled := true;
            DeleteCommitment."Cancelled By" := UserId;
            DeleteCommitment."Cancelled Date" := today;
            DeleteCommitment.Amount := DeleteCommitment.Amount * -1;
            DeleteCommitment.Modify;
        end;
    end;

    procedure CheckFundsAvailability(Payments: Record "Payments Header")
    var
        BankAcc: Record "Bank Account";
        "Current Source A/C Bal.": Decimal;
    begin
        //get the source account balance from the database table
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.", Payments."Paying Bank Account");
        BankAcc.SetRange(BankAcc."Bank Type", BankAcc."bank type"::Cash);
        if BankAcc.FindFirst then begin
            BankAcc.CalcFields(BankAcc.Balance);
            "Current Source A/C Bal." := BankAcc.Balance;
            if ("Current Source A/C Bal." - Payments."Total Net Amount") < 0 then begin
                Error('The transaction will result in a negative balance in the BANK ACCOUNT. %1:%2', BankAcc."No.",
                BankAcc.Name);
            end;
        end;
    end;

    procedure UpdateAnalysisView()
    var
        BudgetaryControl: Record "Budgetary Control Setup";
        AnalysisView: Record "Analysis View";
    begin
        /*//Update Budget Lines
        IF BudgetaryControl.GET THEN BEGIN
          IF BudgetaryControl."Analysis View Code"<>'' THEN BEGIN
           AnalysisView.RESET;
           AnalysisView.SETRANGE(AnalysisView.Code,BudgetaryControl."Analysis View Code");
           IF AnalysisView.FIND('-') THEN
             UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
          END;
        END;  */

        //Update Budget Lines
        if BudgetaryControl.Get then begin
            if BudgetaryControl."Actual Source" = BudgetaryControl."actual source"::"Analysis View Entry" then begin
                if BudgetaryControl."Analysis View Code" = '' then
                    Error('The Analysis view code can not be blank in the budgetary control setup');
            end;
            if BudgetaryControl."Analysis View Code" <> '' then begin
                AnalysisView.Reset;
                AnalysisView.SetRange(AnalysisView.Code, BudgetaryControl."Analysis View Code");
                // if AnalysisView.Find('-') then
                //  UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
            end;
        end;

    end;

    procedure UpdateDim(DimCode: Code[20]; DimValueCode: Code[20])
    begin
        //In 2013 this is not applicable table 361 not supported
        /*IF DimCode = '' THEN
          EXIT;
        WITH GLBudgetDim DO BEGIN
          IF GET(Rec."Entry No.",DimCode) THEN
            DELETE;
          IF DimValueCode <> '' THEN BEGIN
            INIT;
            "Entry No." := Rec."Entry No.";
            "Dimension Code" := DimCode;
            "Dimension Value Code" := DimValueCode;
            INSERT;
          END;
        END; */

    end;

    procedure CheckIfBlocked(BudgetName: Code[20])
    var
        GLBudgetName: Record "G/L Budget Name";
    begin
        GLBudgetName.Get(BudgetName);
        GLBudgetName.TestField(Blocked, false);
    end;

    procedure CheckStaffClaim(var ImprestHeader: Record "Staff Claims Header")
    var
        PayLine: Record "Staff Claim Lines";
        Commitments: Record "Committment";
        GLAcc: Record "G/L Account";
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        BudgetAmount: Decimal;
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        EntryNo: Integer;
    begin

        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ImprestHeader.Date < BCSetup."Current Budget Start Date") then begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            end
            else
                if (ImprestHeader.Date > BCSetup."Current Budget End Date") then begin
                    Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            if Commitments.Find('+') then
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.Reset;
            PayLine.SetRange(PayLine.No, ImprestHeader."No.");
            PayLine.SetRange(PayLine."Budgetary Control A/C", true);
            if PayLine.FindFirst then begin
                repeat
                    //check the votebook now
                    FirstDay := Dmy2date(1, Date2dmy(ImprestHeader.Date, 2), Date2dmy(ImprestHeader.Date, 3));
                    CurrMonth := Date2dmy(ImprestHeader.Date, 2);
                    if CurrMonth = 12 then begin
                        LastDay := Dmy2date(1, 1, Date2dmy(ImprestHeader.Date, 3) + 1);
                        LastDay := CalcDate('-1D', LastDay);
                    end
                    else begin
                        CurrMonth := CurrMonth + 1;
                        LastDay := Dmy2date(1, CurrMonth, Date2dmy(ImprestHeader.Date, 3));
                        LastDay := CalcDate('-1D', LastDay);
                    end;

                    //If Budget is annual then change the Last day
                    if BCSetup."Budget Check Criteria" = BCSetup."budget check criteria"::"Whole Year" then
                        LastDay := BCSetup."Current Budget End Date";

                    //The GL Account
                    BudgetGL := PayLine."Account No:";


                    GLAcc.reset;
                    GLAcc.setrange("No.", BudgetGL);
                    GLAcc.setfilter("Date Filter", '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    if BCSetup."Ignore Budget Departments" = false then begin
                        GLAcc.setfilter("Global Dimension 1 Filter", PayLine."Global Dimension 1 Code");
                        GLAcc.setfilter("Global Dimension 2 Filter", PayLine."Shortcut Dimension 2 Code");
                        GLAcc.setfilter("Global Dimension 3 Filter", PayLine."Shortcut Dimension 3 Code");
                        GLAcc.setfilter("Global Dimension 4 Filter", PayLine."Shortcut Dimension 4 Code");
                    end;
                    if GLAcc.find('-') then begin
                        GLAcc.CalcFields("Net Change");
                        GLAcc.CalcFields("Committment Amount");
                        GLAcc.CalcFields("Budgeted Amount");
                        CommitmentAmount := GLAcc."Committment Amount";
                        BudgetAmount := GLAcc."Budgeted Amount";
                        ActualsAmount := GLAcc."Net Change";
                    end;

                    //check if there is any budget
                    if (BudgetAmount <= 0) and not (BCSetup."Allow OverExpenditure") then begin
                        Error('No Budget To Check Against');
                    end else begin
                        if (BudgetAmount <= 0) then begin
                            if not Confirm(Text0003, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;
                    end;

                    //check if there is any budget
                    if (BudgetAmount <= 0) and not (BCSetup."Allow OverExpenditure") then begin
                        Error('No Budget To Check Against');
                    end else begin
                        if (BudgetAmount <= 0) then begin
                            if not Confirm(Text0003, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;
                    end;

                    //check if the actuals plus the amount is greater then the budget amount
                    if ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount)
                    and not (BCSetup."Allow OverExpenditure") then begin
                        Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, 'Staff Claim', PayLine.No,
                          Format(Abs(BudgetAmount - (CommitmentAmount + PayLine."Amount LCY"))));
                    end else begin
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        if ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount) then begin
                            if not Confirm(Text0001 +
                            Format(Abs(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."Amount LCY")))
                            + Text0002, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;

                        Commitments.Reset;
                        Commitments.Init;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := Today;
                        Commitments."Posting Date" := ImprestHeader.Date;
                        Commitments."Document Type" := Commitments."document type"::StaffClaim;
                        Commitments."Document No." := ImprestHeader."No.";
                        Commitments.Amount := PayLine.Amount;
                        Commitments.Description := PayLine.Purpose;
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := true;
                        Commitments."Committed By" := UserId;
                        Commitments."Committed Date" := ImprestHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := Time;
                        // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments.Validate("Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                        Commitments.Validate("Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                        Commitments.Validate("Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                        Commitments.Validate("Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := ImprestHeader."Account Type";
                        Commitments."Vendor/Cust No." := ImprestHeader."Account No.";
                        //                        Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                        //                        Commitments."Actual Source":=BCSetup."Actual Source";
                        Commitments."Document Line No." := PayLine."Line No.";
                        Commitments.Insert;
                        //Tag the Imprest Line as Committed
                        PayLine.Committed := true;
                        PayLine.Modify;
                        //End Tagging Imprest Lines as Committed
                    end;

                until PayLine.Next = 0;
            end;
        end
        else//budget control not mandatory
          begin

        end;
        Message('Budgetary Checking Completed Successfully');






        /**********************************************************
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
              PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                               CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //The GL Account
                                BudgetGL:=PayLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."G/L Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                            Commitments.setrange(Commitments.Reverse,false);
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."Document Type"::StaffClaim;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                commitments.description := payline.purpose;
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
        //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments.validate("Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code";
                                Commitments.validate("Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code";
                                Commitments.validate("Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code";
                                Commitments.validate("Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments."Document Line No." := PayLine."Line No.";
                                Commitments.INSERT;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=TRUE;
                                  PayLine.MODIFY;
                                //End Tagging Imprest Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        ****************************************/

    end;

    procedure CheckStaffAdvance(var ImprestHeader: Record "Staff Advance Header")
    var
        PayLine: Record "Staff Advance Lines";
        Commitments: Record "Committment";
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        EntryNo: Integer;
    begin

        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ImprestHeader.Date < BCSetup."Current Budget Start Date") then begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            end
            else
                if (ImprestHeader.Date > BCSetup."Current Budget End Date") then begin
                    Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            if Commitments.Find('+') then
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.Reset;
            PayLine.SetRange(PayLine.No, ImprestHeader."No.");
            PayLine.SetRange(PayLine."Budgetary Control A/C", true);
            if PayLine.FindFirst then begin
                repeat
                    //check the votebook now
                    FirstDay := Dmy2date(1, Date2dmy(ImprestHeader.Date, 2), Date2dmy(ImprestHeader.Date, 3));
                    CurrMonth := Date2dmy(ImprestHeader.Date, 2);
                    if CurrMonth = 12 then begin
                        LastDay := Dmy2date(1, 1, Date2dmy(ImprestHeader.Date, 3) + 1);
                        LastDay := CalcDate('-1D', LastDay);
                    end
                    else begin
                        CurrMonth := CurrMonth + 1;
                        LastDay := Dmy2date(1, CurrMonth, Date2dmy(ImprestHeader.Date, 3));
                        LastDay := CalcDate('-1D', LastDay);
                    end;

                    //If Budget is annual then change the Last day
                    if BCSetup."Budget Check Criteria" = BCSetup."budget check criteria"::"Whole Year" then
                        LastDay := BCSetup."Current Budget End Date";

                    //The GL Account
                    BudgetGL := PayLine."Account No:";

                    //check the summation of the budget in the database
                    BudgetAmount := 0;
                    Budget.Reset;
                    Budget.SetRange(Budget."Budget Name", BCSetup."Current Budget Code");
                    Budget.SetFilter(Budget.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    Budget.SetRange(Budget."G/L Account No.", BudgetGL);
                    if BCSetup."Ignore Budget Departments" = false then begin
                        Budget.SetRange(Budget."Global Dimension 1 Code", PayLine."Global Dimension 1 Code");
                        // IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                        Budget.SetRange(Budget."Global Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                        Budget.SetRange(Budget."Budget Dimension 1 Code", PayLine."Shortcut Dimension 3 Code");
                        Budget.SetRange(Budget."Budget Dimension 2 Code", PayLine."Shortcut Dimension 4 Code");
                    end;
                    if Budget.Find('-') then begin
                        repeat
                            BudgetAmount := BudgetAmount + Budget.Amount;
                        until Budget.Next = 0;
                    end;

                    /*
                                      //get the summation on the actuals
                                      //Separate Analysis View and G/L Entry
                                        IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                                        ActualsAmount:=0;
                                        Actuals.RESET;
                                        Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                                        Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                                        Actuals."Posting Date",Actuals."G/L Account No.");
                                        Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                                        Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                                        Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                                        Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                                        Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                        Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                                        Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                                           Actuals.CALCSUMS(Actuals.Amount);
                                           ActualsAmount:= Actuals.Amount;
                                        END ELSE BEGIN
                                            GLAccount.RESET;
                                            GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                            GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                            IF PayLine."Global Dimension 1 Code" <> '' THEN
                                              GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                                            IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                                              GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                                            IF GLAccount.FIND('-') THEN BEGIN
                                             GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                             ActualsAmount:=GLAccount."Net Change";
                                            END;
                                        END;

                    */
                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.Reset;
                    Commitments.SetCurrentkey(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SetRange(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SetRange(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SetRange(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    if BCSetup."Ignore Budget Departments" = false then begin
                        Commitments.SetRange(Commitments."Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                        Commitments.SetRange(Commitments."Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                        Commitments.SetRange(Commitments."Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                        Commitments.SetRange(Commitments."Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                    end;
                    // Commitments.SETRANGE(Commitments.Reverse,FALSE);
                    Commitments.CalcSums(Commitments.Amount);
                    CommitmentAmount := Commitments.Amount;

                    //check if there is any budget
                    if (BudgetAmount <= 0) and not (BCSetup."Allow OverExpenditure") then begin
                        Error('No Budget To Check Against');
                    end else begin
                        if (BudgetAmount <= 0) then begin
                            if not Confirm(Text0003, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;
                    end;

                    //check if the actuals plus the amount is greater then the budget amount
                    if ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount)
                    and not (BCSetup."Allow OverExpenditure") then begin
                        Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, 'Staff Imprest', PayLine.No,
                          Format(Abs(BudgetAmount - (CommitmentAmount + PayLine."Amount LCY"))));
                    end else begin
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        if ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount) then begin
                            if not Confirm(Text0001 +
                            Format(Abs(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."Amount LCY")))
                            + Text0002, true) then begin
                                Error('Budgetary Checking Process Aborted');
                            end;
                        end;

                        Commitments.Reset;
                        Commitments.Init;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := Today;
                        Commitments."Posting Date" := ImprestHeader.Date;
                        Commitments."Document Type" := Commitments."document type"::StaffAdvance;
                        Commitments."Document No." := ImprestHeader."No.";
                        Commitments.Amount := PayLine."Amount LCY";
                        Commitments.Description := PayLine.Purpose;
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := true;
                        Commitments."Committed By" := UserId;
                        Commitments."Committed Date" := ImprestHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := Time;
                        //   Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments.Validate("Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                        Commitments.Validate("Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                        Commitments.Validate("Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                        Commitments.Validate("Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := ImprestHeader."Account Type";
                        Commitments."Vendor/Cust No." := ImprestHeader."Account No.";
                        //                        Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                        //                        Commitments."Actual Source":=BCSetup."Actual Source";
                        Commitments."Document Line No." := PayLine."Line No.";
                        Commitments.Insert;
                        //Tag the Imprest Line as Committed
                        PayLine.Committed := true;
                        PayLine.Modify;
                        //End Tagging Imprest Lines as Committed
                    end;

                until PayLine.Next = 0;
            end;
        end
        else//budget control not mandatory
          begin

        end;
        Message('Budgetary Checking Completed Successfully');



        /*********************
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
              PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                               CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //The GL Account
                                BudgetGL:=PayLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."G/L Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                            Commitments.setrange(Commitments.Reverse,false);
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                commitments.description := payline.purpose;
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
        //                       // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments.validate("Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code";
                                Commitments.validate("Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code";
                                Commitments.validate("Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code";
                                Commitments.validate("Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments."Document Line No." := PayLine."Line No.";
                                Commitments.INSERT;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=TRUE;
                                  PayLine.MODIFY;
                                //End Tagging Imprest Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        *******************************/

    end;

    procedure GetLineAmountToReverse(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender; DocNo: Code[20]; DocLineNo: Integer) TotalAmount: Decimal
    var
        LPO: Record "Purchase Line";
        QtyToInvoice: Decimal;
    begin
        if DocumentType = Documenttype::LPO then begin
            LPO.Reset;
            LPO.SetRange(LPO."Document Type", LPO."document type"::Order);
            LPO.SetRange(LPO."Document No.", DocNo);
            LPO.SetRange(LPO."Line No.", DocLineNo);
            if LPO.Find('-') then begin
                //Take care of reversal which might not
                if LPO."Qty. to Invoice" <> 0 then
                    QtyToInvoice := LPO."Qty. to Invoice"
                else
                    QtyToInvoice := LPO."Outstanding Quantity";

                if LPO."VAT %" = 0 then
                    TotalAmount := QtyToInvoice * LPO."Direct Unit Cost"
                else
                    TotalAmount := (QtyToInvoice * LPO."Direct Unit Cost") * ((LPO."VAT %" + 100) / 100)

            end;
        end;
    end;

    procedure ReverseOrderEntriesFromInvoice(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance; DocNo: Code[20]; LineNo: Integer; Amount: Decimal)
    var
        Commitments: Record "Committment";
        EntryNo: Integer;
        CommittedLines: Record "Committment";
    begin
        //Get Commitment Lines
        Commitments.Reset;
        if Commitments.Find('+') then
            EntryNo := Commitments."Line No.";

        CommittedLines.Reset;
        CommittedLines.SetRange(CommittedLines."Document Type", DocumentType);
        CommittedLines.SetRange(CommittedLines."Document No.", DocNo);
        CommittedLines.SetRange(CommittedLines."Document Line No.", LineNo);
        CommittedLines.SetRange(CommittedLines.Committed, true);
        if CommittedLines.Find('-') then begin
            repeat
                Commitments.Reset;
                Commitments.Init;
                EntryNo += 1;
                Commitments."Line No." := EntryNo;
                Commitments.Date := Today;
                Commitments."Posting Date" := CommittedLines."Posting Date";
                Commitments."Document Type" := CommittedLines."Document Type";
                Commitments."Document No." := CommittedLines."Document No.";
                Commitments.Amount := -Amount;
                Commitments.Description := CommittedLines.Description;
                Commitments."Month Budget" := CommittedLines."Month Budget";
                Commitments."Month Actual" := CommittedLines."Month Actual";
                Commitments.Committed := false;
                Commitments."Committed By" := UserId;
                Commitments."Committed Date" := CommittedLines."Committed Date";
                Commitments."G/L Account No." := CommittedLines."G/L Account No.";
                Commitments."Committed Time" := Time;
                //     Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                Commitments.Validate("Shortcut Dimension 1 Code", CommittedLines."Shortcut Dimension 1 Code");
                Commitments.Validate("Shortcut Dimension 2 Code", CommittedLines."Shortcut Dimension 2 Code");
                Commitments.Validate("Shortcut Dimension 3 Code", CommittedLines."Shortcut Dimension 3 Code");
                Commitments.Validate("Shortcut Dimension 4 Code", CommittedLines."Shortcut Dimension 4 Code");
                Commitments.Budget := CommittedLines.Budget;
                Commitments."Document Line No." := CommittedLines."Document Line No.";
                Commitments."Budget Check Criteria" := CommittedLines."Budget Check Criteria";
                Commitments."Actual Source" := CommittedLines."Actual Source";
                Commitments."Document Line No." := CommittedLines."Line No.";
                Commitments.Insert;

            until CommittedLines.Next = 0;
        end;
    end;

    procedure ReverseOrdersReversal("No.": Code[20])
    var
        PurchLines: Record "Purchase Line";
        PurchRecptLines: Record "Purch. Rcpt. Line";
        DeleteCommitment: Record "Committment";
    begin
        PurchLines.Reset;
        PurchLines.SetRange(PurchLines."Document Type", PurchLines."document type"::Invoice);
        PurchLines.SetRange(PurchLines."Document No.", "No.");
        if PurchLines.Find('-') then begin
            repeat
                if PurchLines.Type <> PurchLines.Type::" " then begin
                    //Get Details of Order from Receipt lines
                    PurchRecptLines.Reset;
                    PurchRecptLines.SetRange(PurchRecptLines."Document No.", PurchLines."Receipt No.");
                    PurchRecptLines.SetRange(PurchRecptLines."Line No.", PurchLines."Receipt Line No.");
                    if PurchRecptLines.Find('-') then begin
                        DeleteCommitment.Reset;
                        DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."document type"::LPO);
                        DeleteCommitment.SetRange(DeleteCommitment."Document No.", PurchRecptLines."Order No.");
                        DeleteCommitment.SetRange(DeleteCommitment."Document Line No.", PurchRecptLines."Order Line No.");
                        DeleteCommitment.SetRange(DeleteCommitment.Committed, false);
                        DeleteCommitment.DeleteAll;

                    end;
                end;
            until PurchLines.Next = 0;
        end;
    end;

    procedure DeleteEntries(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance; DocNo: Code[20])
    var
        Commitments: Record "Committment";
    begin
        Commitments.Reset;
        Commitments.SetRange(Commitments."Document Type", DocumentType);
        Commitments.SetRange(Commitments."Document No.", DocNo);
        Commitments.DeleteAll;
    end;
}

