#pragma implicitwith disable
page 50897 "Travel Advance Request UP"
{
    Caption = 'Imprest Request';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Imprest Header";
    UsageCategory = Documents;
    ApplicationArea = all;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control';
    SourceTableView = WHERE(Posted = FILTER(false),
                            Status = FILTER(<> Cancelled));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    Editable = DateEditable;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = GlobalDimension1CodeEditable;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Function Name field.';
                    // Caption = 'Campus Name';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = ShortcutDimension2CodeEditable;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                }
                field("Department Name"; Rec."Budget Center Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Department Name';
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Work Activity"; Rec."Work Activity")
                {
                    ToolTip = 'Specifies the value of the Work Activity field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    //  Caption = 'School Code';

                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }

                field("Account Type"; Rec."Account Type")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(Payee; Rec.Payee)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field("Negotiated Exchange Rate"; Rec."Negotiated Exchange Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Negotiated Exchange Rate field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    // Editable = "Currency CodeEditable";
                    //  Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    //  Editable = "Paying Bank AccountEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field("Imprest Due Type"; Rec."Imprest Due Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Imprest Due Type field.';
                }
                field(Status; Rec.Status)
                {
                     Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Net Amount LCY field.';
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Caption = 'Payment Release Date';
                    //  Editable = "Payment Release DateEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    // Editable = "Pay ModeEditable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }

                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    // Editable = "Cheque No.Editable";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque/EFT No. field.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Expected Return Date field.';
                }
                field("Purchase Requisition"; Rec."Purchase Requisition")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purchase Requisition field.';
                }
                field("Memo No"; Rec."Memo No")
                {
                    Caption = 'Imprest Memo No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Imprest Memo No. field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    Visible = false;
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                part(PVLines; "Imprest Details UP")
                {

                    ApplicationArea = all;
                    SubPageLink = No = FIELD("No.");
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50891),
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
                Caption = 'Post Imprest';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                PromotedCategory = Process;
                ToolTip = 'Executes the Post Imprest action.';

                trigger OnAction()
                begin
                    if Confirm('Post Document?', true) = false then exit;

                    PostImprest();
                end;
            }
            separator(Separator24) { }
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

                    AppEntry: Record "Approval Entry";
                    AppEntryPage: page "Approval Entries2";
                begin
                    AppEntry.reset;
                    AppEntry.setrange("Document No.", Rec."No.");
                    if AppEntry.find('-') then begin
                        AppEntryPage.SetTableView(AppEntry);
                        AppEntryPage.Run();
                    end;
                    //ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    webportal: Codeunit HRWebportal;
                begin
                    Rec.CheckOutstandingImprest();
                    if not LinesExists then
                        Error('There are no Lines created for this Document');

                    if not AllFieldsEntered then
                        Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                    if LinesCommitmentStatus then
                        Error('There are some lines that have not been committed');
                    Rec.TestField("Responsibility Center");
                    Rec.TestField(Status, Rec.Status::Pending);
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);
                    webportal.SendApprovalEmailAlert(Rec."No.", 70135176, UserId);

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
                    /* DocType:=DocType::Imprest;
                     showmessage:=TRUE;
                     ManualCancel:=TRUE;
                     CLEAR(tableNo);
                     tableNo:=DATABASE::"Imprest Header";
                      IF ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) THEN;*/

                    // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;

                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    Rec.Status := Rec.Status::Pending;
                    Rec.Modify();

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
            action("Update Dimensions")
            {
                Caption = 'Update Dimensions';
                Image = PrintAttachment;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Report;
                ToolTip = 'Executes the Update Dimensions action.';

                trigger OnAction()
                var
                    ImpH: Record "Imprest Header";
                    ImpRep: report "Imprest Requisition";
                begin
                    //if Status <> Status::Approved then
                    //   Error('You can only print after the document is released for approval');

                    ImpH.Reset;
                    ImpH.SetFilter("No.", Rec."No.");
                    if ImpH.find('-') then begin
                        imprep.SetTableView(ImpH);
                        ImpRep.Run();
                    end;

                end;
            }
            separator(Separator13) { }
            action("Check Budgetary Availability")
            {
                Caption = 'Check Budgetary Availability';
                Image = CheckLedger;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Category5;
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
                ApplicationArea = all;
                PromotedCategory = Category5;
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
        }
        area(Reporting)
        {

            action("Print/Preview")
            {
                Caption = 'Print/Preview';
                Image = PrintAttachment;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction()
                var
                    ImpLines: record "Imprest Lines";
                    ImpRep: report "Imprest Requisition";
                begin
                    if Rec.Status <> Rec.Status::Approved then
                        //  Error('You can only print after the document is released fr approval');
                        ImpLines.reset;
                    ImpLines.setfilter(No, Rec."No.");
                    if ImpLines.find('-') then begin
                        ImpRep.SetTableView(ImpLines);
                        ImpRep.Run();
                    end;

                end;
            }
            separator(Separator5) { }
            action("Cancel Document")
            {
                Caption = 'Cancel Document';
                Image = CancelAllLines;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Process;
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
                ApplicationArea = all;
                PromotedCategory = Process;
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
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = all;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print Accounting Request action.';

                trigger OnAction()
                begin

                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    // REPORT.Run(70135446, true, true, Rec);
                    Rec.Reset;
                end;
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

    var
        UserSetup: Record "User Setup";
        HR: Record "HR-Employee";
    begin

        // "Payment Type" := "Payment Type"::Imprest;
        Rec."Account Type" := Rec."Account Type"::Customer;
        if UserSetup.Get(Database.UserId) then begin
            Rec."Account No." := UserSetup."Imprest Account";
            if HR.get(UserSetup."Employee No.") then
                Rec."Is HOD" := HR."Is HOD";
        end;
        ImprestHeader.Reset;
        ImprestHeader.SetRange(ImprestHeader.Posted, false);
        ImprestHeader.SetRange(ImprestHeader.Cashier, UserId);
        if ImprestHeader.Count > 0 then begin
            if Confirm('There are still some unposted Requisition documents. Continue?', false) = false then begin
                Error('There are still some unposted Requisition documents. Please utilise them first');
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
        ImprestHeader: Record "Imprest Header";
        PayLine: Record "Payment Line";
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        Post: Boolean;
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record Committment;
        UserMgt: Codeunit "User Setup Management BR";
        JournlPosted: Codeunit "Journal Post Successful";
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

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
        ImprestLine: Record "Imprest Lines";
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
        ImprestLine.Reset;
        ImprestLine.SetRange(ImprestLine.No, Rec."No.");
        ImprestLine.SetRange(ImprestLine.Committed, false);
        //ImprestLineSetRange(ImprestLine."Budgetary Control A/C", true);
        if ImprestLine.Find('-') then
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
        GenJnlLine.ValidateShortcutDimCode(5, Rec."Shortcut Dimension 5 Code");
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
        Post := false;
        Post := JournlPosted.PostedSuccessfully(Rec."No.");

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
                if (PayLines."Account No:" = '') or (PayLines.Amount <= 0) then
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

    procedure PortalSendforApproval(var Table_id: Integer; var Doc_No: Code[20]; var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application",PCA,StaffMovement,"Medical Claims/General Claims","Tuition waiver","Leave Extension Requisition"," Staff Update ",Graduation,"Campus Transfer","Programme Transfer","Additional Units",Defferal,StudyMode,ExamRemark,SpecialExam,Supplimentary; var Status: Option Open,"Pending Approval",Cancelled,Approved; WebUser: Text[50]; var ResponsibilityCenter: Code[30])
    var
    // ApprovalMgt: Codeunit "Approvals Management";
    begin
        if not LinesExists then
            Error('There are no Lines created for this Document');

        if not AllFieldsEntered then
            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

        //Ensure No Items That should be committed that are not
        if LinesCommitmentStatus then
            Error('There are some lines that have not been committed');

        //Release the Imprest for Approval

        //ApprovalMgt.SendApproval(Table_id, Doc_No, Doc_Type, Status, '', ResponsibilityCenter);
    end;
}

#pragma implicitwith restore

