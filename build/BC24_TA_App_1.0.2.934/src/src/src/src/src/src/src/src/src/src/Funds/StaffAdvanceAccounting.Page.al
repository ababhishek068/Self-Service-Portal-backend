page 50901 "Staff Advance Accounting"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Staff Advance Surrender Header";
    SourceTableView = WHERE(Posted = CONST(false),
                            Status = FILTER(<> Cancelled));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    Editable = "Surrender DateEditable";
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = "Account No.Editable";
                    ToolTip = 'Specifies the value of the Account No. field.';

                    trigger OnValidate()
                    begin
                        AccountName := GetCustName(Rec."Account No.");
                    end;
                }
                field(AccountName; AccountName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    Editable = "Imprest Issue Doc. NoEditable";
                    ToolTip = 'Specifies the value of the Advance Issue Doc. No field.';
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    Caption = 'Advance Issue Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Advance Issue Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                    trigger OnValidate()
                    begin
                        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
                    end;
                }
                field(DimName1; DimName1)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                    trigger OnValidate()
                    begin
                        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
                    end;
                }
                field(DimName2; DimName2)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = "Responsibility CenterEditable";
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Surrender Posting Date"; Rec."Surrender Posting Date")
                {
                    Editable = "Surrender Posting DateEditable";
                    ToolTip = 'Specifies the value of the Surrender Posting Date field.';
                }
                field("Allow Overexpenditure"; Rec."Allow Overexpenditure")
                {
                    ToolTip = 'Specifies the value of the Allow Overexpenditure field.';
                }
                field("Open for Overexpenditure by"; Rec."Open for Overexpenditure by")
                {
                    ToolTip = 'Specifies the value of the Open for Overexpenditure by field.';
                }
                field("Date opened for OvExpenditure"; Rec."Date opened for OvExpenditure")
                {
                    ToolTip = 'Specifies the value of the Date opened for OvExpenditure field.';
                }
            }
            part(ImprestLines; "Staff Advanc Surrender Details")
            {
                Editable = ImprestLinesEditable;
                SubPageLink = "Surrender Doc No." = FIELD(No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Approvals action.';


                }
                separator(Separator1102756006) { }
                action(Post)
                {
                    Caption = 'Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Post action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        Rec.TestField("Surrender Posting Date");


                        if Rec.Posted then
                            Error('The transaction has already been posted.');
                        /*
                        //Ensure actual spent does not exceed the amount on original document
                         CALCFIELDS("Actual Spent","Cash Receipt Amount") ;
                          IF "Actual Spent"+"Cash Receipt Amount" > Amount THEN
                             ERROR('The actual Amount spent should not exceed the amount issued ');
                          */
                        //Get the Cash office user template
                        Temp.Get(UserId);
                        SurrBatch := Temp."Advance Surr Batch";
                        SurrTemplate := Temp."Advance Surr Template";


                        //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                        //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                        Rec.CalcFields("Actual Spent");
                        if Rec."Actual Spent" = 0 then
                            if Confirm(Text000, true) then
                                UpdateforNoActualSpent
                            else
                                Error(Text001);

                        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                        if GenledSetup.Get then begin
                            GenJnlLine.Reset;
                            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", SurrTemplate);
                            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", SurrBatch);
                            GenJnlLine.DeleteAll;
                        end;

                        if DefaultBatch.Get(SurrTemplate, SurrBatch) then begin
                            DefaultBatch.Delete;
                        end;

                        DefaultBatch.Reset;
                        DefaultBatch."Journal Template Name" := SurrTemplate;
                        DefaultBatch.Name := SurrBatch;
                        DefaultBatch.Insert;
                        LineNo := 0;

                        ImprestDetails.Reset;
                        ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.", Rec.No);
                        if ImprestDetails.Find('-') then begin
                            repeat
                                //Post Surrender Journal
                                //Compare the amount issued =amount on cash reciecied.
                                //Created new field for zero spent
                                //

                                //ImprestDetails.TESTFIELD("Actual Spent");
                                //ImprestDetails.TESTFIELD("Actual Spent");
                                /*
                                IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                                   ERROR(Txt0001);
                                       */
                                Rec.TestField("Global Dimension 1 Code");


                                LineNo := LineNo + 1000;
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := SurrTemplate;
                                GenJnlLine."Journal Batch Name" := SurrBatch;
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Source Code" := 'PAYMENTJNL';
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                GenJnlLine."Account No." := ImprestDetails."Account No:";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
                                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                                GenJnlLine.Validate("Gen. Posting Type");
                                GenJnlLine."Gen. Bus. Posting Group" := '';
                                GenJnlLine.Validate("Gen. Bus. Posting Group");
                                GenJnlLine."Gen. Prod. Posting Group" := '';
                                GenJnlLine.Validate("Gen. Prod. Posting Group");
                                GenJnlLine."VAT Bus. Posting Group" := '';
                                GenJnlLine.Validate("VAT Bus. Posting Group");
                                GenJnlLine."VAT Prod. Posting Group" := '';
                                GenJnlLine.Validate("VAT Prod. Posting Group");
                                GenJnlLine."Document No." := Rec.No;
                                GenJnlLine.Amount := ImprestDetails."Actual Spent";
                                GenJnlLine.Validate(GenJnlLine.Amount);
                                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                                GenJnlLine."Bal. Account No." := ImprestDetails."Advance Holder";
                                //GenJnlLine.Description:='Advance Surrendered by staff';
                                GenJnlLine.Description := 'Advance Surrender: ' + Rec."Account No." + ':' + Rec.Payee;
                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.Validate("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.Validate("Currency Factor");

                                GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                                //Application of Surrender entries
                                if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer then begin
                                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    GenJnlLine."Applies-to Doc. No." := Rec."Imprest Issue Doc. No";
                                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := Rec."Apply to ID";
                                end;

                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert;
                            /*
                            //Post Cash Surrender
                            IF ImprestDetails."Cash Surrender Amt">0 THEN BEGIN
                             IF ImprestDetails."Bank/Petty Cash"='' THEN
                               ERROR('Select a Bank Code where the Cash Surrender will be posted');
                            LineNo:=LineNo+1000;
                            GenJnlLine.INIT;
                            GenJnlLine."Journal Template Name":=GenledSetup."Surrender Template";
                            GenJnlLine."Journal Batch Name":=GenledSetup."Surrender  Batch";
                            GenJnlLine."Line No.":=LineNo;
                            GenJnlLine."Account Type":=GenJnlLine."Account Type"::Customer;
                            GenJnlLine."Account No.":=ImprestDetails."Imprest Holder";
                            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                            //Set these fields to blanks
                            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                            GenJnlLine.VALIDATE("Gen. Posting Type");
                            GenJnlLine."Gen. Bus. Posting Group":='';
                            GenJnlLine.VALIDATE("Gen. Bus. Posting Group");
                            GenJnlLine."Gen. Prod. Posting Group":='';
                            GenJnlLine.VALIDATE("Gen. Prod. Posting Group");
                            GenJnlLine."VAT Bus. Posting Group":='';
                            GenJnlLine.VALIDATE("VAT Bus. Posting Group");
                            GenJnlLine."VAT Prod. Posting Group":='';
                            GenJnlLine.VALIDATE("VAT Prod. Posting Group");
                            GenJnlLine."Posting Date":="Surrender Posting Date";
                            GenJnlLine."Document No.":=No;
                            GenJnlLine.Amount:=-ImprestDetails."Cash Surrender Amt";
                            GenJnlLine.VALIDATE(GenJnlLine.Amount);
                            GenJnlLine."Currency Code":="Currency Code";
                            GenJnlLine.VALIDATE("Currency Code");
                            //Take care of Currency Factor
                              GenJnlLine."Currency Factor":="Currency Factor";
                              GenJnlLine.VALIDATE("Currency Factor");

                            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
                            GenJnlLine."Bal. Account No.":=ImprestDetails."Bank/Petty Cash";
                            GenJnlLine.Description:='Imprest Surrender by staff';
                            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                            GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                            GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                            GenJnlLine."Applies-to ID":=ImprestDetails."Imprest Holder";
                            IF GenJnlLine.Amount<>0 THEN
                            GenJnlLine.INSERT;

                            END;
                             */
                            //End Post Surrender Journal

                            until ImprestDetails.Next = 0;
                            //Post Entries
                            GenJnlLine.Reset;
                            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", SurrTemplate);
                            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", SurrBatch);
                            //Adjust Gen Jnl Exchange Rate Rounding Balances
                            AdjustGenJnl.Run(GenJnlLine);
                            //End Adjust Gen Jnl Exchange Rate Rounding Balances

                            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                        end;

                        if JournalPostSuccessful.PostedSuccessfully(Rec.No) then begin
                            Rec.Posted := true;
                            Rec.Status := Rec.Status::Posted;
                            Rec."Date Posted" := Today;
                            Rec."Time Posted" := Time;
                            Rec."Posted By" := UserId;
                            Rec.Modify;
                            //kate
                            //Create Entries for the Overspent Figures
                            Rec.CalcFields("Difference Owed");
                            if Rec."Difference Owed" > 0 then begin
                                Payline.SetFilter("Surrender Doc No.", Rec.No);
                                Payline.SetFilter("Difference Owed", '>%1', 0);
                                CreateOverSpentBatch;
                            end;
                            //Create Entries for the Overspent Figures

                            //Tag the Source Imprest Requisition as Surrendered
                            ImprestReq.Reset;
                            ImprestReq.SetRange(ImprestReq."No.", Rec."Imprest Issue Doc. No");
                            if ImprestReq.Find('-') then begin
                                ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
                                ImprestReq.Modify;
                            end;

                            //End Tag
                            //Post Committment Reversals
                            Doc_Type := Doc_Type::StaffSurrender;
                            BudgetControl.ReverseEntries(Doc_Type, Rec.No);
                        end;

                    end;
                }
                separator(Separator1102755014) { }
                action("Check Budgetary Availability")
                {
                    Caption = 'Check Budgetary Availability';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Check Budgetary Availability action.';

                    trigger OnAction()
                    begin
                        //Ensure actual spent does not exceed the amount on original document
                        Rec.CalcFields("Actual Spent", "Cash Receipt Amount");
                        if Rec."Actual Spent" + Rec."Cash Receipt Amount" > Rec.Amount then
                            Error('The actual Amount spent should not exceed the amount issued ');

                        //Post Committment Reversals of the Staff Advance if it had not been reversed
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffAdvance);
                        Commitments.SetRange(Commitments."Document No.", Rec."Imprest Issue Doc. No");
                        Commitments.SetRange(Commitments.Committed, false);
                        if not Commitments.Find('-') then begin
                            Doc_Type := Doc_Type::StaffAdvance;
                            BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
                        end;

                        //First Check whether other lines are already committed.
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffSurrender);
                        Commitments.SetRange(Commitments."Document No.", Rec.No);
                        if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffSurrender);
                            Commitments.SetRange(Commitments."Document No.", Rec.No);
                            Commitments.DeleteAll;
                        end;

                        //Check the Budget here
                        // CheckBudgetAvail.CheckStaffAdvSurr(Rec);
                    end;
                }
                action("Cancel Budgetary Allocation")
                {
                    Caption = 'Cancel Budgetary Allocation';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Budgetary Allocation action.';

                    trigger OnAction()
                    begin
                        if Confirm('Do you Wish to Cancel the Commitment entries for this document', false) = false then begin exit end;

                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffSurrender);
                        Commitments.SetRange(Commitments."Document No.", Rec.No);
                        Commitments.DeleteAll;

                        Payline.Reset;
                        Payline.SetRange(Payline."Surrender Doc No.", Rec.No);
                        if Payline.Find('-') then begin
                            repeat
                                Payline.Committed := false;
                                Payline.Modify;
                            until Payline.Next = 0;
                        end;
                    end;
                }
                separator(Separator1102755012) { }
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction()
                    begin
                        /*
                        //Ensure actual spent does not exceed the amount on original document
                        CALCFIELDS("Actual Spent","Cash Receipt Amount") ;
                         IF "Actual Spent"+"Cash Receipt Amount" > Amount THEN
                            ERROR('The actual Amount spent should not exceed the amount issued ');


                      //First Check whether all amount entered tally
                      ImprestDetails.RESET;
                      ImprestDetails.SETRANGE(ImprestDetails."Surrender Doc No.",No);
                      IF ImprestDetails.FIND('-') THEN BEGIN
                      REPEAT
                        IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                            ERROR(Txt0001);

                      UNTIL ImprestDetails.NEXT = 0;
                      END;
                      */
                        //Ensure No Items That should be committed that are not
                        //IF LinesCommitmentStatus THEN
                        // ERROR('There are some lines that have not been committed');

                        //Release the ImprestSurrender for Approval
                        State := State::Open;
                        if Rec.Status <> Rec.Status::Pending then State := State::"Pending Approval";
                        DocType := DocType::"Staff Advance Accounting";
                        Clear(tableNo);
                        tableNo := 39005640;
                        // IF ApprovalMgt.SendApproval(tableNo,Rec.No,DocType,State) THEN;

                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction()
                    var
                    // ApprovalMgt: Codeunit "Approvals Management";
                    begin
                        DocType := DocType::"Staff Advance Accounting";
                        showmessage := true;
                        ManualCancel := true;
                        Clear(tableNo);
                        tableNo := 39005640;
                        //  if ApprovalMgt.CancelApproval(tableNo,DocType,Rec.No,showmessage,ManualCancel) then;
                    end;
                }
                separator(Separator1000000000) { }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Document action.';

                    trigger OnAction()
                    begin
                        //Post Committment Reversals
                        Rec.TestField(Status, Rec.Status::Approved);
                        if Confirm(Text002, true) then begin
                            Doc_Type := Doc_Type::Imprest;
                            BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end;
                    end;
                }
                separator(Separator1102755015) { }
                action("Open for OverExpenditure")
                {
                    Caption = 'Open for OverExpenditure';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Open for OverExpenditure action.';

                    trigger OnAction()
                    begin
                        //Opening should only be for Pending Documents
                        Rec.TestField(Status, Rec.Status::Pending);
                        //Open for Overexpenditure
                        Rec."Allow Overexpenditure" := true;
                        Rec."Open for Overexpenditure by" := UserId;
                        Rec."Date opened for OvExpenditure" := Today;
                        Rec.Modify;
                        //Open lines
                        Payline.Reset;
                        Payline.SetRange(Payline."Surrender Doc No.", Rec.No);
                        if Payline.Find('-') then begin
                            repeat
                                Payline."Allow Overexpenditure" := true;
                                Payline."Open for Overexpenditure by" := UserId;
                                Payline."Date opened for OvExpenditure" := Today;
                                Payline.Modify;
                            until Payline.Next = 0;
                        end;
                        //End open for Overexpenditure
                    end;
                }
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(70134815, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }



    trigger OnInit()
    begin
        ImprestLinesEditable := true;
        "Surrender Posting DateEditable" := true;
        "Responsibility CenterEditable" := true;
        "Imprest Issue Doc. NoEditable" := true;
        "Surrender DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        //check if the documenent has been added while another one is still pending
        TravAccHeader.Reset;
        TravAccHeader.SetRange(TravAccHeader.Cashier, UserId);
        TravAccHeader.SetRange(TravAccHeader.Status, Rec.Status::Pending);

        if TravAccHeader.Count > 0 then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;
        //*********************************END ****************************************//

        Rec."User ID" := UserId;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();

    end;

    trigger OnOpenPage()
    begin
        //SETFILTER(Status,'<>Cancelled');

        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        AccountName := GetCustName(Rec."Account No.");
    end;

    var
        showmessage: Boolean;
        ManualCancel: Boolean;
        State: Option Open,"Pending Approval",Cancelled,Approved;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
        tableNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        ImprestDetails: Record "Staff Advanc Surrender Details";
        //  ImprestRequestDet: Record "Payments-Users";
        GenledSetup: Record "Cash Office Setup";
        DimName1: Text[60];
        DimName2: Text[60];
        JournalPostSuccessful: Codeunit "Journal Post Successful";
        Commitments: Record Committment;
        BCSetup: Record "Budgetary Control Setup";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
        ImprestReq: Record "Staff Advance Header";
        UserMgt: Codeunit "User Setup Management BR";
        AccountName: Text[100];
        Text000: Label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: Label 'Document Not Posted';
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        Text002: Label 'Are you sure you want to Cancel this Document?';
        TravAccHeader: Record "Staff Advance Surrender Header";
        Payline: Record "Staff Advanc Surrender Details";
        Temp: Record "Cash Office User Template";
        SurrBatch: Code[10];
        SurrTemplate: Code[10];
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Surrender Posting DateEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;

    procedure GetDimensionName(var "Code": Code[20]; DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name := '';

        GLSetup.Reset;
        GLSetup.Get();

        DimVal.Reset;
        DimVal.SetRange(DimVal.Code, Code);

        if DimNo = 1 then begin
            DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 1 Code");
        end
        else
            if DimNo = 2 then begin
                DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 2 Code");
            end;
        if DimVal.Find('-') then begin
            Name := DimVal.Name;
        end;

    end;

    procedure UpdateControl()
    begin
        if Rec.Status <> Rec.Status::Pending then begin
            "Surrender DateEditable" := false;
            "Account No.Editable" := false;
            "Imprest Issue Doc. NoEditable" := false;
            "Responsibility CenterEditable" := false;
            "Surrender Posting DateEditable" := true;
            ImprestLinesEditable := false;
        end else begin
            "Surrender DateEditable" := true;
            "Account No.Editable" := true;
            "Imprest Issue Doc. NoEditable" := true;
            "Responsibility CenterEditable" := true;
            "Surrender Posting DateEditable" := false;
            ImprestLinesEditable := true;

        end;
    end;

    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Customer;
    begin
        Name := '';
        if Cust.Get(No) then
            Name := Cust.Name;
        exit(Name);
    end;

    procedure UpdateforNoActualSpent()
    begin
        Rec.Posted := true;
        Rec.Status := Rec.Status::Posted;
        Rec."Date Posted" := Today;
        Rec."Time Posted" := Time;
        Rec."Posted By" := UserId;
        Rec.Modify;
        //Tag the Source Imprest Requisition as Surrendered
        ImprestReq.Reset;
        ImprestReq.SetRange(ImprestReq."No.", Rec."Imprest Issue Doc. No");
        if ImprestReq.Find('-') then begin
            ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
            ImprestReq.Modify;
        end;
        //End Tag
        //Post Committment Reversals
        Doc_Type := Doc_Type::StaffSurrender;
        BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
    end;

    procedure CompareAllAmounts()
    begin
    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
    begin
        if BCsetup.Get() then begin
            if not BCsetup.Mandatory then begin
                Exists := false;
                exit;
            end;
        end else begin
            Exists := false;
            exit;
        end;
        Exists := false;
        Payline.Reset;
        Payline.SetRange(Payline."Surrender Doc No.", Rec.No);
        Payline.SetRange(Payline.Committed, false);
        Payline.SetRange(Payline."Budgetary Control A/C", true);
        if Payline.Find('-') then
            Exists := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //Update Controls as necessary
        //SETFILTER(Status,'<>Cancelled');
        UpdateControl;
        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
        AccountName := GetCustName(Rec."Account No.");
    end;

    procedure CreateOverSpentBatch()
    var
        PaymentHeader: Record "Payments Header";
        PaymentLines: Record "Payment Line";
        LineNo: Integer;
        Ok: Boolean;
        ClaimsHeader: Record "Staff Claims Header";
        ClaimsLines: Record "Staff Claim Lines";
    begin

        BCSetup.Get;
        if BCSetup."Raise Document" = BCSetup."Raise Document"::"Raise PV" then begin
            PaymentHeader.Init;
            PaymentHeader."No." := '';
            PaymentHeader.Validate("No.");
            PaymentHeader.Date := 0D;
            PaymentHeader.Validate(Date);
            PaymentHeader."Currency Code" := Rec."Currency Code";
            PaymentHeader.Validate("Currency Code");
            PaymentHeader."Paying Bank Account" := Rec."Paying Bank Account";
            //PaymentHeader.VALIDATE("Paying Bank Account");
            PaymentHeader."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
            PaymentHeader.Validate("Global Dimension 1 Code");
            PaymentHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            PaymentHeader.Validate("Shortcut Dimension 2 Code");
            PaymentHeader."Pay Mode" := Rec."Pay Mode";
            PaymentHeader.Validate("Pay Mode");
            PaymentHeader."Responsibility Center" := Rec."Responsibility Center";
            PaymentHeader.Payee := Rec.Payee;
            PaymentHeader."Payment Narration" := 'OverSpent money during travel';
            Ok := PaymentHeader.Insert(true);

            LineNo := 1000;
            if Payline.Find('-') then
                repeat
                begin
                    PaymentLines.Init;
                    PaymentLines."Line No." := LineNo + 1;
                    LineNo := PaymentLines."Line No.";
                    PaymentLines.No := PaymentHeader."No.";
                    PaymentLines.Type := Payline."Imprest Type";
                    PaymentLines.Validate(Type);
                    PaymentLines.Date := Today;
                    PaymentLines."Pay Mode" := PaymentHeader."Pay Mode";
                    PaymentLines."Paying Bank Account" := PaymentHeader."Paying Bank Account";
                    PaymentLines.Payee := Rec.Payee;
                    PaymentLines."Global Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                    PaymentLines."Shortcut Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";
                    PaymentLines."Currency Code" := PaymentHeader."Currency Code";
                    PaymentLines.Amount := Payline."Difference Owed";
                    PaymentLines.Insert(true);
                end;
                until Payline.Next = 0;
            if Ok then
                Message('A NEW PAYMENT VOUCHER HAS BEEN RAISED WITH THE NUMBER ' + PaymentHeader."No.")
            else
                Error('ERROR CREATING PAYMENT VOUCHER FOR OVER PAYMENT');
        end;
        if BCSetup."Raise Document" = BCSetup."Raise Document"::"Raise Claim" then begin
            ClaimsHeader.Init;
            ClaimsHeader."No." := '';
            ClaimsHeader.Validate("No.");
            ClaimsHeader.Date := 0D;
            ClaimsHeader.Validate(Date);
            ClaimsHeader."Currency Code" := Rec."Currency Code";
            ClaimsHeader.Validate("Currency Code");
            ClaimsHeader."Paying Bank Account" := Rec."Paying Bank Account";
            ClaimsHeader.Validate("Paying Bank Account");
            ClaimsHeader."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
            ClaimsHeader.Validate("Global Dimension 1 Code");
            ClaimsHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            ClaimsHeader.Validate("Shortcut Dimension 2 Code");
            ClaimsHeader."Responsibility Center" := Rec."Responsibility Center";
            ClaimsHeader."Pay Mode" := Rec."Pay Mode";
            ClaimsHeader.Validate("Pay Mode");
            ClaimsHeader.Payee := Rec.Payee;
            ClaimsHeader.Purpose := 'Overspent Money during travel';
            Ok := ClaimsHeader.Insert(true);

            LineNo := 1000;
            if Payline.Find('-') then
                repeat
                begin
                    ClaimsLines.Init;
                    ClaimsLines."Line No." := LineNo + 1;
                    //LineNo:=ClaimsLines"Line No.";
                    ClaimsLines.No := ClaimsHeader."No.";
                    ///ClaimsLines."Type of Surrender":=ImprestOSDetails."Imprest Type";
                    //ClaimsLines.VALIDATE(Type);
                    ClaimsLines."Due Date" := Today;

                    //ClaimsLines."Paying Bank Account":=ClaimsHeader."Paying Bank Account";
                    //ClaimsLines.Payee:=Payee;
                    ClaimsLines."Global Dimension 1 Code" := ClaimsHeader."Global Dimension 1 Code";
                    ClaimsLines."Shortcut Dimension 2 Code" := ClaimsHeader."Shortcut Dimension 2 Code";
                    ClaimsLines."Currency Code" := ClaimsHeader."Currency Code";
                    ClaimsLines.Amount := Payline."Difference Owed";
                    ClaimsLines.Insert(true);
                end;
                until Payline.Next = 0;
            if Ok then
                Message('A new claim voucher has been raised with Number ' + ClaimsHeader."No.")
            else
                Error('Error creating Claim voucher for overspent payment');
        end;
    end;
}

