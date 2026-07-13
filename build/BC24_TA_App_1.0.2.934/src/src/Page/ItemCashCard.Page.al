page 50913 "Item/Cash Card"
{
    Caption = 'Item Cash Requisition';
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Check Budget Availlability';
    SourceTable = "Imprest Header";
    SourceTableView = WHERE(Posted = FILTER(false),
                            Status = FILTER(<> Cancelled),
                            "imprest TYpe" = FILTER("Item Cash"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control54)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Editable = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    Editable = DateEditable;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(Payee; Rec.Payee)
                {
                    Caption = 'Staff Name';
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = GlobalDimension1CodeEditable;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    Caption = 'Campus Name';
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Campus Name field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = ShortcutDimension2CodeEditable;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Department Name"; Rec."Budget Center Name")
                {
                    Caption = 'Department Name';
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Source of Funds';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source of Funds field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    // Caption = 'Source of Funds';
                    CaptionClass = '1,1';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    // Caption = 'Source of Funds';
                    CaptionClass = '1,1';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Caption = 'Payment Release Date';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field("Actual Expenditure"; Rec."Actual Expenditure")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Actual Expenditure field.';
                }
                field("Committed Amount"; Rec."Committed Amount")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Committed Amount field.';
                }
                field("Budget Balance"; Rec."Budget Balance")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Budget Balance field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    Caption = 'Paying Cash Account';
                    Editable = true;
                    Visible = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Paying Cash Account field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Caption = 'Cash Account Name';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cash Account Name field.';
                }
                field("Purchase Requisition"; Rec."Purchase Requisition")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Purchase Requisition field.';
                }
            }
            part(PVLines; "ItemCash Details UP")
            {
                ApplicationArea = basic;
                SubPageLink = No = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70135176),
                              "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post Imprest")
            {
                Caption = 'Post';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                Visible = true;
                ApplicationArea = basic;
                PromotedCategory = Process;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    if Confirm('Post Document?', true) = false then exit;

                    PostImprest();
                end;
            }
            separator(Separator24) { }
            separator(Separator13) { }
            action("Check Budgetary Availability")
            {
                Caption = 'Check Budgetary Availability';
                Image = CheckLedger;
                Promoted = true;
                PromotedCategory = Category5;
                ApplicationArea = basic;
                ToolTip = 'Executes the Check Budgetary Availability action.';
                trigger OnAction()
                var
                    BCSetup: Record "Budgetary Control Setup";
                begin

                    BCSetup.Get;
                    if not BCSetup.Mandatory then
                        exit;

                    if not LinesExists then
                        Error('There are no Lines created for this Document');

                    if not AllFieldsEntered then
                        Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                    //First Check whether other lines are already committed.
                    Commitments.Reset;
                    Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Imprest);
                    Commitments.SetRange(Commitments."Document No.", Rec."No.");
                    if Commitments.Find('-') then begin
                        if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Imprest);
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
                        Commitments.DeleteAll;
                    end;

                    CheckBudgetAvail.CheckImprest(Rec);
                end;
            }
            action("Cancel Budget Commitment")
            {
                Caption = 'Cancel Budget Commitment';
                Image = CancelledEntries;
                Promoted = true;
                PromotedCategory = Category5;
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Budget Commitment action.';
                trigger OnAction()
                begin
                    if Confirm('Do you Wish to Cancel the Commitment entries for this document', false) = false then begin exit end;

                    Commitments.Reset;
                    Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Imprest);
                    Commitments.SetRange(Commitments."Document No.", Rec."No.");
                    Commitments.DeleteAll;

                    PayLine.Reset;
                    PayLine.SetRange(PayLine.No, Rec."No.");
                    if PayLine.Find('-') then begin
                        repeat
                            PayLine.Committed := false;
                            PayLine.Modify;
                        until PayLine.Next = 0;
                    end;
                end;
            }
            separator(Separator9) { }
            action("Print/Preview")
            {
                Caption = 'Print/Preview';
                Image = PrintAttachment;
                Promoted = true;
                ApplicationArea = basic;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print/Preview action.';
                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Approved then
                        Error('You can only print after the document is released for approval');
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(70134926, true, true, Rec);
                    Rec.Reset;
                end;
            }
            separator(Separator5) { }
            action("Cancel Document")
            {
                Caption = 'Cancel Document';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Document action.';
                trigger OnAction()
                var
                    Text000: Label 'Are you sure you want to Cancel this Document?';
                    Text001: Label 'You have selected not to Cancel this Document';
                begin
                    //TESTFIELD(Status,Status::Approved);
                    if Confirm(Text000, true) then begin
                        //Post Committment Reversals
                        Doc_Type := Doc_Type::Imprest;
                        BudgetControl.ReverseEntries(Doc_Type, Rec."No.");
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.Modify;
                    end else
                        Error(Text001);
                end;
            }
            action(Action21)
            {
                Caption = 'Post Imprest';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Post Imprest action.';

                trigger OnAction()
                begin
                    if Confirm('Post Document?', true) = false then exit;

                    PostImprest();
                end;
            }
            action("Print Accounting Request")
            {
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print Accounting Request action.';
                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Approved);
                    if Confirm('Print', true) then begin
                        //Post Committment Reversals
                        Doc_Type := Doc_Type::Imprest;
                        BudgetControl.ReverseEntries(Doc_Type, Rec."No.");
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.Modify;
                    end else
                        Error('Document Cancelled Successfully');
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                begin
                    if not LinesExists then
                        Error('There are no Lines created for this Document');
                    Rec.TestField(Status, Rec.Status::Pending);

                    if not AllFieldsEntered then
                        Error('Please enter all the required information in the lines. (Account No,Amount,Qunatity');

                    if LinesCommitmentStatus then
                        Error('Please Check the Budget before you Proceed');
                    Rec.Testfield("Account No.");

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
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                end;
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
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Comments action.';
                }
            }
        }
    }


    trigger OnInit()
    begin
        DateEditable := true;
        ShortcutDimension2CodeEditable := true;
        GlobalDimension1CodeEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."imprest TYpe" := Rec."imprest TYpe"::"Item Cash";
        Rec."Payment Type" := Rec."Payment Type"::Imprest;
        Rec."Account Type" := Rec."Account Type"::Customer;

        Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange(Rcpt.Cashier, UserId);
        if Rcpt.Count > 0 then begin
            if Confirm('There are still some unposted imprests. Continue?', false) = false then begin
                Error('There are still some unposted imprests. Please utilise them first');
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        /* "Global Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
         VALIDATE("Global Dimension 1 Code");
         "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
         VALIDATE("Shortcut Dimension 2 Code");
         "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(USERID,3);
         VALIDATE("Shortcut Dimension 3 Code");
         "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(USERID,4);
         VALIDATE("Shortcut Dimension 4 Code");*/


        //"Budget Name":=Setup."Current Budget";
        Rec."imprest TYpe" := Rec."imprest TYpe"::"Item Cash";
        if UserSetup.Get(UserId) then begin
            Rec."Account Type" := Rec."account type"::Customer;
            Rec."Account No." := UserSetup."Imprest Account";
            if UserSetup."Employee No." = '' then Error('You have not been created as an imprest user...\Consult the Finance department for guidance.');
            //"Shortcut Dimension 2 Code" := UserSetup.Department;
            //"Global Dimension 1 Code" := UserSetup."Campus Code";
            //"Responsibility Center"

            Rec.Validate("Account No.");
        end else
            Error('You have not been created as an imprest user...\Consult the Finance department for guidance.');


    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        UpdateControls;
    end;

    var
        Rcpt: Record "Imprest Header";
        PayLine: Record "Payment Line";
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        UserSetup: Record "User Setup";
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record Committment;
        UserMgt: Codeunit "User Setup Management BR";
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application",PCA,StaffMovement,"Medical Claims/General Claims","Tuition waiver","Leave Extension Requisition"," Staff Update ",Graduation,"Campus Transfer","Programme Transfer","Additional Units",Defferal,StudyMode,ExamRemark,SpecialExam,Supplimentary;
        BudgetControl: Codeunit "Budgetary Control";
        GLEntry: Record "G/L Entry";
        LastEntry: Integer;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Paying Bank AccountEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        OpenApprovalEntriesExistForCurrUser: Boolean;



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
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");
        PayLine.SetRange(PayLine.Committed, false);
        PayLine.SetRange(PayLine."Budgetary Control A/C", true);
        if PayLine.Find('-') then
            Exists := true;
    end;

    procedure PostImprest()
    begin
        Rec.TestField("Payment Release Date");
        Rec.TestField("Paying Bank Account");
        Rec.TestField("Account No.");
        Rec.TestField("Account Type", Rec."Account Type"::Customer);

        if Rec.Posted = true then Error('The Document is already Posted!');
        /*Check if the user has selcted all the relevant fields*/
        Temp.Get(UserId);
        JTemplate := Temp."Imprest Template";
        JBatch := Temp."Imprest  Batch";

        if JTemplate = '' then Error('Please ensure that the Imprest Template is setup in the cash management setup!!');
        if JBatch = '' then Error('Please ensure that the Imprest Batch is setup in the cash management setup!!');

        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");
        if PayLine.Find('-') then begin
        end else begin
            //ERROR('There are no lines created for this document!');
        end;

        if Temp.Get(UserId) then begin
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.DeleteAll;
        end;

        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec.Date;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine.Description := 'Imprest: ' + Rec."Account No." + ':' + Rec.Payee;
        Rec.CalcFields("Total Net Amount");
        GenJnlLine.Amount := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        /*
        GenJnlLine."Currency Factor":=Payments."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
        */
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        if GLEntry.FindLast then LastEntry := GLEntry."Entry No.";

        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
        Rec.Posted := true;
        Rec."Date Posted" := Today;
        Rec."Time Posted" := Time;
        Rec."Posted By" := UserId;
        Rec.Status := Rec.Status::Posted;
        Rec.Modify;

        //EFT
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");
        if PayLine.Find('-') then begin
            repeat
            /* IF "Pay Mode"="Pay Mode"::EFT THEN BEGIN
             IF PayLine."Account No."<>'' THEN BEGIN
             BankPayment.SETRANGE(BankPayment."Doc No","No.");
             IF BankPayment.FIND('-') THEN BankPayment.DELETE;

             PayLine.TESTFIELD(PayLine."EFT Bank Account No");
            // PayLine.TESTFIELD(PayLine."EFT Branch No.");
             PayLine.TESTFIELD(PayLine."EFT Bank Code");
             PayLine.TESTFIELD(PayLine."EFT Account Name");

             BankPayment.INIT;
             BankPayment."Doc No":=Rec."No.";
             BankPayment.Payee:=PayLine."Account No.";
             BankPayment.Amount:="Total Payment Amount"-("Total Witholding Tax Amount"+"Total VAT Amount");
             BankPayment."Bank A/C No":=PayLine."EFT Bank Account No";
           //  BankPayment."Bank Branch No":=PayLine."EFT Branch No.";
           //  BankPayment."Bank Code":=PayLine."EFT Bank Code";
             BankPayment."Bank A/C Name":=PayLine."EFT Account Name";
            // END;
             BankPayment.Date:=TODAY;
             BankPayment.INSERT;
             END;
             END; */
            until PayLine.Next = 0;
        end;
        //Post:= FALSE;
        //Post:=JournlPosted.PostedSuccessfully();

    end;

    procedure CheckImprestRequiredItems()
    begin

        Rec.TestField("Payment Release Date");
        Rec.TestField("Paying Bank Account");
        Rec.TestField("Account No.");
        Rec.TestField("Account Type", Rec."Account Type"::Customer);

        if Rec.Posted then begin
            Error('The Document has already been posted');
        end;

        Rec.TestField(Status, Rec.Status::Approved);

        /*Check if the user has selected all the relevant fields*/

        Temp.Get(UserId);
        JTemplate := Temp."Imprest Template";
        JBatch := Temp."Imprest  Batch";

        if JTemplate = '' then begin
            Error('Ensure the Imprest Template is set up in Cash Office Setup');
        end;

        if JBatch = '' then begin
            Error('Ensure the Imprest Batch is set up in the Cash Office Setup')
        end;

        if not LinesExists then
            Error('There are no Lines created for this Document');

    end;

    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::Approved then begin
            "Payment Release DateEditable" := false;
            "Paying Bank AccountEditable" := false;
            "Pay ModeEditable" := false;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Cheque No.Editable" := false;
            // CurrForm."Serial No".EDITABLE:=FALSE;
            // CurrPage.UpdateControls();
        end else begin
            "Payment Release DateEditable" := true;
            "Paying Bank AccountEditable" := true;
            "Pay ModeEditable" := true;
            "Cheque No.Editable" := true;
            //CurrForm."Currency Code".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        end;

        if Rec.Status = Rec.Status::Pending then begin
            GlobalDimension1CodeEditable := true;
            ShortcutDimension2CodeEditable := true;
            //CurrForm.Payee.EDITABLE:=TRUE;
            ShortcutDimension3CodeEditable := true;
            ShortcutDimension4CodeEditable := true;
            DateEditable := true;
            //CurrForm."Account No.".EDITABLE:=TRUE;
            "Currency CodeEditable" := true;
            //  CurrForm."Serial No".EDITABLE:=TRUE;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrPage.UpdateControls();
        end else begin
            GlobalDimension1CodeEditable := false;
            ShortcutDimension2CodeEditable := true;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := false;
            ShortcutDimension4CodeEditable := false;
            DateEditable := false;
            //  CurrForm."Serial No".EDITABLE:=FALSE;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := false;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        end
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Imprest Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Imprest Lines";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No:" = '') or (PayLines.Amount <= 0) or (PayLines.Quantity <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}

