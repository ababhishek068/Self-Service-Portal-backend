page 50873 "Travel Advance Accounting UP"
{
    Caption = 'Imprest Accounting';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Imprest Surrender Header";
    SourceTableView = WHERE(Posted = CONST(false));
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control';
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    Editable = "Surrender DateEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = "Account No.Editable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Account Name';
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {

                    Editable = "Imprest Issue Doc. NoEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Imprest Issue Doc. No field.';
                }

                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Imprest Issue Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                    trigger OnValidate()
                    begin
                        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
                    end;
                }
                field(DimName1; DimName1)
                {

                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the DimName1 field.';

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                    trigger OnValidate()
                    begin
                        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
                    end;
                }
                field(DimName2; DimName2)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the DimName2 field.';

                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';

                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = "Responsibility CenterEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }



                field("Imp Purpose"; Rec."Imp Purpose")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Imp Purpose field.';
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                part(ImprestLines; "Imprest Surrender Details UP")
                {
                    ApplicationArea = all;
                    Editable = ImprestLinesEditable;
                    SubPageLink = "Surrender Doc No." = FIELD(No);
                }
            }
            field(Control1102758005; '')
            {
                CaptionClass = Text19053222;
                ShowCaption = false;
                Style = Standard;
                StyleExpr = TRUE;
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50884),
                              "No." = FIELD(No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = all;
                ToolTip = 'Executes the Approve action.';

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Pending then
                        Error('The document has already been processed.');

                    if Rec.Amount < 0 then
                        Error('Amount cannot be less than zero.');

                    if Rec.Amount = 0 then
                        Error('Please enter amount.');

                    if Confirm('Are you sure you would like to approve the payment?', false) = true then begin
                        Rec.Status := Rec.Status::"2nd Approval";
                        Rec.Modify;
                        Message('Document approved successfully.');
                    end;
                end;
            }
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
                    ApplicationArea = all;
                    ToolTip = 'Executes the Approvals action.';
                    trigger OnAction()
                    var

                        AppEntry: Record "Approval Entry";
                        AppEntryPage: page "Approval Entries2";
                    begin
                        AppEntry.reset;
                        AppEntry.setrange("Document No.", Rec."No");
                        if AppEntry.find('-') then begin
                            AppEntryPage.SetTableView(AppEntry);
                            AppEntryPage.Run();
                        end;
                    end;
                }
                separator(Separator1102756006) { }
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(status, Rec.status::Pending);
                        //First Check whether all amount entered tally
                        ImprestDetails.Reset;
                        ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.", Rec.No);
                        if ImprestDetails.Find('-') then begin
                            repeat
                            // if (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount then
                            //     Error(Txt0001);

                            until ImprestDetails.Next = 0;
                        end;

                        //Release the ImprestSurrender for Approval
                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(cancellsApproval)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    begin

                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                        Rec.Status := Rec.Status::Pending;
                        Rec.modify;
                    end;
                }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = CancelAllLines;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Cancel Document action.';

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to Cancel this Document?';
                        Text001: Label 'You have selected not to Cancel this Document';
                    begin
                        //TESTFIELD(Status,Status::Approved);
                        if Confirm(Text000, true) then begin
                            //Post Committment Reversals
                            Doc_Type := Doc_Type::ImprestSurrender;
                            BudgetControl.ReverseEntries(Doc_Type, Rec.No);
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end else
                            Error(Text001);
                    end;
                }
                action(RefreshApproval)
                {
                    Caption = 'Refresh Approval';
                    Image = RefreshVoucher;

                    ApplicationArea = Basic;
                    ToolTip = 'Executes the Refresh Approval action.';

                    trigger OnAction()
                    var

                    begin
                        Rec.Validate(Status);
                        Rec.modify;
                    end;
                }
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin



                    Rec.TestField(Status, Rec.Status::Approved);

                    if Rec.Posted then
                        Error('The transaction has already been posted.');

                    //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                    //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                    /*CALCFIELDS("Actual Spent");
                    IF "Actual Spent"=0 THEN
                        IF CONFIRM(Text000,TRUE) THEN
                          UpdateforNoActualSpent
                        ELSE
                           ERROR(Text001);
                     */
                    // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    if GenledSetup.Get then begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        GenJnlLine.DeleteAll;
                    end;

                    if DefaultBatch.Get(GenledSetup."Surrender Template", GenledSetup."Surrender  Batch") then begin
                        DefaultBatch.Delete;
                    end;

                    DefaultBatch.Reset;
                    DefaultBatch."Journal Template Name" := GenledSetup."Surrender Template";
                    DefaultBatch.Name := GenledSetup."Surrender  Batch";
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
                            // if (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount then
                            //     Error(Txt0001);

                            Rec.TestField("Global Dimension 1 Code");

                            LineNo := LineNo + 1000;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                            GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                            GenJnlLine."Line No." := LineNo;
                            GenJnlLine."Source Code" := 'PAYMENTJNL';
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := ImprestDetails."Account No:";
                            GenJnlLine.Validate(GenJnlLine."Account No.");
                            //Set these fields to blanks
                            GenJnlLine."Posting Date" := Rec."Surrender Date";
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
                            GenJnlLine."Bal. Account No." := ImprestDetails."Imprest Holder";
                            Rec.CalcFields("Imp Purpose");
                            GenJnlLine.Description := CopyStr(Rec."Imp Purpose", 1, 30);
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
                            //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                            //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

                            //Application of Surrender entries
                            // if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer then begin
                            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                            GenJnlLine."Applies-to Doc. No." := Rec."Imprest Issue Doc. No";
                            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                            GenJnlLine."Applies-to ID" := Rec."Apply to ID";

                            // end;

                            if GenJnlLine.Amount <> 0 then
                                GenJnlLine.Insert;
                        /*
                        //Post Cash Surrender
                        IF ImprestDetails."Cash Receipt Amount">0 THEN BEGIN
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
                        GenJnlLine."Posting Date":="Surrender Date";
                        GenJnlLine."Document No.":=No;
                        GenJnlLine.Amount:=-ImprestDetails."Cash Receipt Amount";
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
                        //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                        //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                        GenJnlLine."Applies-to ID":=ImprestDetails."Imprest Holder";

                        //Application of Surrender entries
                        IF GenJnlLine."Account Type"=GenJnlLine."Account Type"::Customer THEN BEGIN
                        //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":="PV No";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":="Apply to ID";

                        IF GenJnlLine.Amount<>0 THEN
                        GenJnlLine.INSERT;

                        END;
                        END;
                        //End Post Surrender Journal
                         */
                        until ImprestDetails.Next = 0;
                        //Post Entries
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        //Adjust Gen Jnl Exchange Rate Rounding Balances
                        AdjustGenJnl.Run(GenJnlLine);
                        //End Adjust Gen Jnl Exchange Rate Rounding Balances

                        //GenerateReceipt();

                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                    end;

                    //IF JournalPostSuccessful.PostedSuccessfully THEN BEGIN
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
                    ImprestDetails.reset;
                    ImprestDetails.setrange(ImprestDetails."Surrender Doc No.", Rec.No);
                    if ImprestDetails.find('-') then begin
                        repeat
                            if ReceiptHeader.get(ImprestDetails."Cash Receipt No") then begin
                                ReceiptHeader."Surrender No" := Rec.No;
                                ReceiptHeader.modify;
                            end;
                        until ImprestDetails.next = 0;
                    end;

                    //End Tag
                    //Post Committment Reversals
                    Doc_Type := Doc_Type::Imprest;
                    BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
                    //END;

                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(50290, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Print Accounting")
            {
                Caption = 'Print Accounting';
                Image = Print;
                ToolTip = 'Executes the Print Accounting action.';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
            }
        }
    }

    trigger OnInit()
    begin
        ImprestLinesEditable := true;
        "Responsibility CenterEditable" := true;
        "Imprest Issue Doc. NoEditable" := true;
        "Account No.Editable" := true;
        "Surrender DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."User ID" := UserId;
        Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange(Rcpt.Cashier, UserId);
        if Rcpt.Count > 0 then begin
            if Confirm('There are still some unposted imprest Surrenders. Continue?', false) = false then begin
                Error('There are still some unposted imprest Surrenders. Please utilise them first');
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
    end;

    trigger OnOpenPage()
    begin
        /*IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        AccountName:=GetCustName("Account No.");
        */

    end;

    var
        Rcpt: Record "Imprest Surrender Header";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        ImprestDetails: Record "Imprest Surrender Details";
        // ImprestRequestDet: Record "Payments-Users";
        GenledSetup: Record "Cash Office Setup";
        DimName1: Text[80];
        DimName2: Text[80];
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",ImprestSurrender;
        ImprestReq: Record "Imprest Header";
        UserMgt: Codeunit "User Setup Management BR";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        ReceiptHeader: Record "Receipts Header";
        RecLine: Record "Receipt Line q";
        LastNo: Code[20];
        GenSetUp: Record "Cash Office Setup";
        "No. Series Line": Record "No. Series Line";
        BankRec: Record "Bank Account";
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;
        Text19053222: Label 'Enter Advance Accounting Details below';
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";

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
            ImprestLinesEditable := false;
        end else begin
            "Surrender DateEditable" := true;
            "Account No.Editable" := true;
            "Imprest Issue Doc. NoEditable" := true;
            "Responsibility CenterEditable" := true;
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
        Doc_Type := Doc_Type::Imprest;
        BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
    end;

    procedure CompareAllAmounts()
    begin
    end;

    procedure GenerateReceipt()
    begin
        if ImprestDetails."Cash Receipt Amount" <> 0 then
            Rec.TestField("Received From");

        if BankRec.Get(ImprestDetails."Bank/Petty Cash") then
            BankRec.TestField(BankRec."Receipt No. Series");

        LastNo := '';
        GenSetUp.Get;
        "No. Series Line".SetRange("No. Series Line"."Series Code", GenSetUp."Receipts No");
        if "No. Series Line".Find('-') then begin
            LastNo := BankRec."Receipt No. Series" + '-' + IncStr("No. Series Line"."Last No. Used");
            "No. Series Line"."Last No. Used" := IncStr("No. Series Line"."Last No. Used");
            "No. Series Line".Modify;
        end;


        if ImprestDetails."Cash Surrender Amt" <> 0 then begin

            ReceiptHeader.Init;
            ReceiptHeader."No." := LastNo;
            ReceiptHeader.Date := Rec."Surrender Date";
            ReceiptHeader."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
            ReceiptHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            ReceiptHeader.Validate("Global Dimension 1 Code");
            ReceiptHeader.Validate("Shortcut Dimension 2 Code");
            ReceiptHeader.Cashier := UserId;
            ReceiptHeader."Date Posted" := Today;
            ReceiptHeader."Time Posted" := Time;
            ReceiptHeader.Posted := true;
            ReceiptHeader."Received From" := Rec."Received From";
            ReceiptHeader."Amount Recieved" := ImprestDetails."Cash Receipt Amount";
            ReceiptHeader."Responsibility Center" := 'CUC';
            ReceiptHeader."Bank Code" := ImprestDetails."Bank/Petty Cash";
            ReceiptHeader."Surrender No" := Rec.No;

            if ImprestDetails."Cash Surrender Amt" <> 0 then
                ReceiptHeader.Insert;

            RecLine.Init;
            RecLine.No := LastNo;
            RecLine.Type := 'SURRENDER';
            RecLine."Account No." := Rec."Account No.";
            RecLine."Account Name" := 'Imprest Cash Surrender';
            RecLine.Amount := ImprestDetails."Cash Receipt Amount";
            RecLine.Validate(RecLine.Amount);
            RecLine."Cheque/Deposit Slip No" := ImprestDetails."Cheque/Deposit Slip No";
            RecLine."Cheque/Deposit Slip Date" := ImprestDetails."Cheque/Deposit Slip Date";
            RecLine."Cheque/Deposit Slip Type" := ImprestDetails."Cheque/Deposit Slip Type";
            RecLine."Drawer Bank" := ImprestDetails."Bank/Petty Cash";
            RecLine."Pay Mode" := ImprestDetails."Cash Pay Mode";

            if ImprestDetails."Cash Surrender Amt" <> 0 then
                RecLine.Insert;
        end;
    end;
}

