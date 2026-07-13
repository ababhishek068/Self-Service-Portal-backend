page 50597 "Posted ItemCash Accounting UP"
{
    Caption = 'ItemCash Accounting';
    DeleteAllowed = false;
    PageType = Card;
    UsageCategory = Documents;
    ApplicationArea = all;
    SourceTable = "Imprest Surrender Header";
    SourceTableView = WHERE(Posted = CONST(true),
                            "Imprest Surrender Type" = FILTER("Item Cash"));
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control';
    editable = false;
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

                    trigger OnValidate()
                    begin
                        AccountName := GetCustName(Rec."Account No.");
                    end;
                }
                field(AccountName; AccountName)
                {
                    Editable = false;
                    Caption = 'Account Name';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    Caption = 'Item/Cash Issue Doc. No.';
                    Editable = "Imprest Issue Doc. NoEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item/Cash Issue Doc. No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    Caption = 'Item/Cash Issue Date';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item/Cash Issue Date field.';
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
                    Caption = 'Campus Name';
                    ToolTip = 'Specifies the value of the Campus Name field.';
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
                    Caption = 'Department Name';
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = "Responsibility CenterEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }

                field("Imp Purpose"; Rec."Imp Purpose")
                {
                    Caption = 'Purpose';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                part(ImprestLines; "ItemCash Surrender Details UP")
                {
                    ApplicationArea = all;
                    Editable = ImprestLinesEditable;
                    SubPageLink = "Surrender Doc No." = FIELD(No);
                }
            }
            field(Control2; '')
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
                SubPageLink = "Table ID" = CONST(70135168),
                              "No." = FIELD(No);
            }
        }
    }

    actions
    {
        area(processing)
        {



            separator(Separator1102756006) { }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;

                PromotedIsBig = true;
                ApplicationArea = basic;
                PromotedCategory = Category4;
                Visible = false;
                ToolTip = 'Executes the Send A&pproval Request action.';
                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Pending);
                    //Ensure No Items That should be committed that are not
                    ImprestDetails.Reset;
                    ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.", Rec.No);
                    if ImprestDetails.Find('-') then begin
                        repeat
                            if ImprestDetails."Account No:" <> '' then begin
                                ImprestDetails.TestField(Location);
                                ImprestDetails.TestField("Actual Spent");
                                Rec.TestField("Global Dimension 1 Code");

                            end;
                        until ImprestDetails.next = 0;
                    end;

                    //Release the PV for Approval
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
                ApplicationArea = basic;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';
                trigger OnAction()
                begin
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }

            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = basic;
                ToolTip = 'Executes the Post action.';
                trigger OnAction()
                var
                    CashOfficeSetup: Record "Cash Office Setup";
                begin

                    //TESTFIELD(Status,Status::Approved);

                    if Rec.Posted then
                        Error('The transaction has already been posted.');

                    CashOfficeSetup.get;
                    CashOfficeSetup.TestField("Item Cash Purchase Control Ac.");
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
                    // Post Surrender Items
                    PostItems();
                    GenerateGRN();

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

                            //IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                            //ERROR(Txt0001);
                            ImprestDetails.TestField(Location);
                            Rec.TestField("Global Dimension 1 Code");

                            LineNo := LineNo + 1000;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                            GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                            GenJnlLine."Line No." := LineNo;
                            GenJnlLine."Source Code" := 'PAYMENTJNL';
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := CashOfficeSetup."Item Cash Purchase Control Ac.";
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
                            if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer then begin
                                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                                GenJnlLine."Applies-to Doc. No." := Rec."PV No";
                                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                                GenJnlLine."Applies-to ID" := Rec."Apply to ID";

                            end;

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

                        //  GenerateReceipt();

                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                    end;

                    //


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
                PromotedCategory = Report;
                ApplicationArea = basic;
                ToolTip = 'Executes the Print action.';
                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(70134763, true, true, Rec);
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

            group(Approval)
            {
                Caption = 'Approval';

                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    ApplicationArea = all;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    ApplicationArea = basic;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = CONST(39005498),
                                  "Document No." = FIELD("No. Series");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Comments action.';
                }
                action(updateItewm)
                {
                    Visible = false;
                    ToolTip = 'Executes the updateItewm action.';
                    trigger OnAction()
                    begin
                        PostItems();
                    end;
                }
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
        Rec."Imprest Surrender Type" := Rec."Imprest Surrender Type"::"Item Cash";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        Rec."Imprest Surrender Type" := Rec."Imprest Surrender Type"::"Item Cash";
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
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        ImprestReq: Record "Imprest Header";
        UserMgt: Codeunit "User Setup Management BR";
        AccountName: Text[100];
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
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ItmJnline: Record "Item Journal Line";
        InventorySetup: Record "Cash Office Setup";
        ReqLine: Record "Imprest Surrender Details";
        PurchRcpHeader: Record "Purch. Rcpt. Header";
        PurchRcpLine: Record "Purch. Rcpt. Line";
        ItemCashAccLine: Record "Imprest Surrender Details";

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

    local procedure PostItems()
    begin
        ReqLine.Reset;
        ReqLine.SetRange(ReqLine."Surrender Doc No.", Rec.No);
        ReqLine.SetFilter(ReqLine.Quantity, '>%1', 0);
        //ReqLine.TESTFIELD(Location);
        if ReqLine.Find('-') then begin
            if InventorySetup.Get then begin
                InventorySetup.TestField(InventorySetup."Items issue Template");
                InventorySetup.TestField(InventorySetup."Items Issue Batch");
                ItmJnline.Reset;
                ItmJnline.SetRange(ItmJnline."Journal Template Name", InventorySetup."Items issue Template");
                ItmJnline.SetRange(ItmJnline."Journal Batch Name", InventorySetup."Items Issue Batch");
                if ItmJnline.Find('-') then ItmJnline.DeleteAll;
            end;
            repeat
            begin
                //receive
                LineNo := LineNo + 1000;

                ItmJnline.Init;
                ItmJnline."Journal Template Name" := InventorySetup."Items issue Template";
                ItmJnline."Journal Batch Name" := InventorySetup."Items Issue Batch";
                ItmJnline."Line No." := LineNo;
                ItmJnline."Entry Type" := ItmJnline."Entry Type"::Purchase;
                ItmJnline."Document No." := Rec.No;
                ItmJnline."Item No." := ReqLine."Account No:";
                ItmJnline.Validate("Item No.");
                ItmJnline."Location Code" := ReqLine.Location;
                ItmJnline.Validate("Location Code");
                ItmJnline."Posting Date" := Rec."Surrender Date";
                ItmJnline.Description := ReqLine."Account Name";
                ItmJnline."Unit Cost" := ReqLine."Unit Cost (LCY)";
                ItmJnline.Validate("Unit Cost");
                ItmJnline.Quantity := ReqLine.Quantity;
                ItmJnline."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                ItmJnline.Validate("Shortcut Dimension 1 Code");
                ItmJnline."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                ItmJnline.Validate("Shortcut Dimension 2 Code");
                ItmJnline.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                ItmJnline.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                ItmJnline.Validate(Quantity);
                ItmJnline."Unit Amount" := ReqLine."Unit Cost (LCY)";
                ItmJnline.Validate("Unit Amount");
                ItmJnline."Reason Code" := '';
                ItmJnline.Validate("Reason Code");
                ItmJnline.Insert;
            end;
            until ReqLine.Next = 0;
        end;

        //Post Entries
        ItmJnline.Reset;
        ItmJnline.SetRange(ItmJnline."Journal Template Name", InventorySetup."Items issue Template");
        //
        ItmJnline.SetRange(ItmJnline."Journal Batch Name", InventorySetup."Items Issue Batch");
        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItmJnline);
        //End Post entries

        //Modify All
    end;

    local procedure GenerateGRN()
    begin
        PurchRcpHeader.Init;
        PurchRcpHeader."Buy-from Vendor No." := 'VEND00001';
        PurchRcpHeader."No." := Rec.No;
        PurchRcpHeader."Pay-to Vendor No." := 'VEND00001';
        PurchRcpHeader."Your Reference" := 'Cash vendor';
        PurchRcpHeader."Order Date" := Rec."Surrender Date";
        PurchRcpHeader."Posting Date" := Rec."Date Posted";
        PurchRcpHeader."Expected Receipt Date" := Rec."Date Posted";
        PurchRcpHeader."Posting Description" := 'CASH';
        PurchRcpHeader."Location Code" := 'MAIN';
        PurchRcpHeader."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        PurchRcpHeader."Shortcut Dimension 2 Code" := Rec."Global Dimension 2 Code";
        PurchRcpHeader."Order No." := Rec.No;
        PurchRcpHeader.Insert;
        ItemCashAccLine.Reset;
        ItemCashAccLine.SetRange(ItemCashAccLine."Surrender Doc No.", Rec.No);
        if ItemCashAccLine.Find('-') then begin
            repeat
                PurchRcpLine.Init;
                PurchRcpLine."Document No." := Rec.No;
                PurchRcpLine."Buy-from Vendor No." := 'VEND00001';
                PurchRcpLine."Line No." := PurchRcpLine."Line No." + 1000;
                PurchRcpLine.Type := PurchRcpLine.Type::Item;
                PurchRcpLine."No." := ItemCashAccLine."Account No:";
                PurchRcpLine."Location Code" := ItemCashAccLine.Location;
                PurchRcpLine."Unit of Measure" := ItemCashAccLine."Unit of Measure";
                PurchRcpLine.Quantity := ItemCashAccLine.Quantity;
                PurchRcpLine."Direct Unit Cost" := ItemCashAccLine."Unit Cost (LCY)";
                PurchRcpLine."Unit Cost (LCY)" := ItemCashAccLine."Unit Cost (LCY)";
                PurchRcpLine."Unit of Measure Code" := ItemCashAccLine."Unit of Measure";
                PurchRcpLine."Quantity (Base)" := ItemCashAccLine.Quantity;
                PurchRcpLine."Qty. Invoiced (Base)" := ItemCashAccLine.Quantity;
                PurchRcpLine.Insert;


            until ItemCashAccLine.Next = 0;
        end;
    end;
}

