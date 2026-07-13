Page 50853 "Staff Claims"
{
    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Staff Claims Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                    ToolTip = 'Specifies the value of the Date field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(Description; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field(BudgetCenterName; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(StaffNoName; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff No/Name';
                    ToolTip = 'Specifies the value of the Staff No/Name field.';
                }
                field("Basic Pay";"Basic Pay"){editable=false;}
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                    // Editable = false;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Currency CodeEditable";
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(PayingBankAccount; Rec."Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                    //  Editable = "Paying Bank AccountEditable";
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = Basic;
                    Caption = 'Claim Description';
                    ToolTip = 'Specifies the value of the Claim Description field.';
                }
                field(TotalNetAmount; Rec."Total Net Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field(TotalNetAmountLCY; Rec."Total Net Amount LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount LCY field.';
                }
                field(PostingDate; Rec."Payment Release Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                    Editable = "Payment Release DateEditable";
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(PayMode; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                    // Editable = "Pay ModeEditable";
                }
                field(ChequeEFTNo; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque/EFT No.';
                    ToolTip = 'Specifies the value of the Cheque/EFT No. field.';
                    //  Editable = "Cheque No.Editable";
                }
                field(PayReleasedate; Rec."Payment Release Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';

                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requestor ID';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requestor ID field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Claim From Imprest"; Rec."Claim From Imprest")
                {
                    ApplicationArea = Basic;
                    Editable = TRUE;
                    ToolTip = 'Specifies the value of the Claim From Imprest field.';
                }
                field("Imprest Doc No"; Rec."Imprest Doc No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Imprest Doc No field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    Visible = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                    Visible = true;
                }
            }
            part(PVLines; "Staff Claim Lines")
            {
                SubPageLink = No = field("No.");


            }
            systempart(Control1000000004; MyNotes) { }
            systempart(Control1000000003; Links) { }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50885),
                              "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(PostPaymentandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;
                    ToolTip = 'Executes the Post Payment and Print action.';

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;

                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        Report.Run(Report::"Staff Claims Voucher.", true, true, Rec);
                        Rec.Reset;
                    end;
                }
                separator(Action1102755021) { }
                action(PostPayment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;
                    ToolTip = 'Executes the Post Payment action.';

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;
                    end;
                }
                separator(Action1102755009) { }
                action(CheckBudgetaryAvailability)
                {
                    ApplicationArea = Basic;
                    Caption = 'Check Budgetary Availability';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Check Budgetary Availability action.';

                    trigger OnAction()
                    var
                        BCSetup: Record "Budgetary Control Setup";
                    begin
                        CashOfficeSetup.Get;
                        if CashOfficeSetup."Apply Cash Expenditure Limit" then
                            if Rec."Pay Mode" = Rec."pay mode"::Cash then
                                if Rec."Total Net Amount" > CashOfficeSetup."Expenditure Limit Amount(LCY)" then
                                    Error('The document has exceeded the cash expenditure limit.');

                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                            exit;

                        Rec.TestField(Status, 0);
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //First Check whether other lines are already committed.
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."document type"::StaffClaim);
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
                        if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type", Commitments."document type"::StaffClaim);
                            Commitments.SetRange(Commitments."Document No.", Rec."No.");
                            Commitments.DeleteAll;
                        end;

                        CheckBudgetAvail.CheckStaffClaim(Rec);
                    end;
                }
                action(CancelBudgetCommitment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Budget Commitment';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Budget Commitment action.';

                    trigger OnAction()
                    begin
                        if Confirm('Do you Wish to Cancel the Commitment entries for this document', false) = false then begin exit end;

                        Commitments.Reset;
                        // Commitments.SetRange(Commitments."Document Type", Commitments."document type"::StaffClaim);
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
                        Commitments.DeleteAll;

                        PayLine.Reset;
                        PayLine.SetRange(PayLine."No", Rec."No.");
                        if PayLine.Find('-') then begin
                            repeat
                                PayLine.Committed := false;
                                PayLine.Modify;
                            until PayLine.Next = 0;
                        end;
                    end;
                }
                separator(Action1102755033) { }
                action(PrintPreview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Print/Preview action.';

                    trigger OnAction()
                    begin
                        //if Status <> Status::Pending then
                        //    Error('You can only print after the document is Approved');

                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        Report.Run(Report::"Staff Claims Voucher.", true, true, Rec);
                        Rec.Reset;
                    end;
                }
                separator(Action1102756006) { }
                action(ReOpenDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'ReOpen Document';
                    Image = ReOpen;
                    ToolTip = 'Executes the ReOpen Document action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if not Confirm('Are you sure you want to ReOpen the Document?', false) then exit;
                        Rec.Status := Rec.Status::Pending;
                    end;
                }
                action(CancelDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Document action.';

                    trigger OnAction()
                    var
                        Text000: label 'Are you sure you want to Cancel this Document?';
                        Text001: label 'You have selected not to Cancel this Document';
                    begin


                        //TESTFIELD(Status,Status::Approved);
                        if (Rec.Status = Rec.Status::Approved) or (Rec.Status = Rec.Status::Pending) then begin
                            if Confirm(Text000, true) then begin
                                //Post Committment Reversals
                                Doc_Type := Doc_type::Imprest;
                                BudgetControl.ReverseEntries(Doc_Type, Rec."No.");
                                Rec.Status := Rec.Status::Cancelled;
                                Rec.Modify;
                            end else
                                Error(Text001);

                        end;
                    end;
                }
                action(UploadDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Upload Document';
                    Image = Upload;
                    ToolTip = 'Executes the Upload Document action.';

                    trigger OnAction()
                    var
                        vartest: Variant;
                    begin
                        if Upload('Upload file', 'C:\', 'Text file(*.txt)|*.txt|PDF file(*.pdf)|*.pdf|ALL file(*)|*', 'Doc.txt', vartest) then begin
                            /*  Links.INIT;
                              Links."Link ID":=0;
                            //"No."  Links."Record ID":=;
                              Links.URL1:='\\128.0.1.74:\tsl\'+USERID;
                              Links.INSERT(TRUE);
                            */
                            Rec.AddLink('\\128.0.1.74:\' + UserId);
                            Message('File Uploaded Successfully')
                        end
                        else
                            Message('File Uploaded Successfully');

                    end;
                }
                action(Download)
                {
                    ApplicationArea = Basic;
                    Caption = 'Download';
                    ToolTip = 'Executes the Download action.';

                    trigger OnAction()
                    var
                        vartest: Variant;
                    begin
                        Download('Upload file', 'C:\', 'Text file(*.txt)|*.txt|PDF file(*.pdf)|*.pdf|ALL file(*)|*', 'Doc.txt', vartest)
                    end;
                }
                action("Create Payment Voucher")
                {
                    ApplicationArea = Basic;
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Create Payment Voucher action.';

                    trigger OnAction()
                    var
                        PVHeadEr: Record "Payments Header";
                        STClaimLines: Record "Staff Claim Lines";
                        PaymentLines: Record "Payment Line";
                        EntryNo: Integer;
                    begin
                        CheckImprestRequiredItems;
                        PVHeadEr.Reset;
                        PVHeadEr.SetRange(PVHeadEr."Creation Doc No.", Rec."No.");
                        PVHeadEr.SetFilter(PVHeadEr.Status, '<>%1', PVHeadEr.Status::Cancelled);
                        if PVHeadEr.Find('-') = true then
                            Error('Payment Voucher has already been created for Staff Claim, the payment voucher no is %1', PVHeadEr."No.");

                        Rec.TestField(Status, Rec.Status::Approved);
                        Rec.TestField("Pay Mode");
                        CheckIfIsAboveCashLimit;
                        Rec.TestField("Paying Bank Account");

                        if not Confirm('Are you sure you want to create a Payment Voucher for %1', false, Rec."No.") then
                            Error('Creation of Payment Voucher Stopped') else begin

                            PVHeadEr.Init;
                            PVHeadEr.Date := Rec.Date;
                            PVHeadEr.Payee := Rec.Payee;
                            PVHeadEr."On Behalf Of" := Rec."On Behalf Of";
                            PVHeadEr.Cashier := Rec.Cashier;
                            PVHeadEr.Status := Rec.Status;
                            if Rec."Pay Mode" = Rec."pay mode"::Cash then
                                PVHeadEr."Payment Type" := PVHeadEr."payment type"::"Petty Cash"
                            else
                                if Rec."Pay Mode" = Rec."pay mode"::Cheque then
                                    PVHeadEr."Payment Type" := PVHeadEr."payment type"::Normal;
                            PVHeadEr."Pay Mode" := Rec."Pay Mode";
                            PVHeadEr."Paying Bank Account" := Rec."Paying Bank Account";
                            PVHeadEr.Validate("Paying Bank Account");
                            PVHeadEr."Cheque No." := Rec."Cheque No.";
                            PVHeadEr."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                            PVHeadEr.Validate("Global Dimension 1 Code");
                            PVHeadEr."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            PVHeadEr.Validate("Shortcut Dimension 2 Code");
                            PVHeadEr."Responsibility Center" := Rec."Responsibility Center";
                            PVHeadEr."Payment Release Date" := Rec."Payment Release Date";
                            PVHeadEr."Shortcut Dimension 3 Code" := Rec."Shortcut Dimension 3 Code";
                            PVHeadEr.Validate("Shortcut Dimension 3 Code");
                            PVHeadEr."Shortcut Dimension 4 Code" := Rec."Shortcut Dimension 4 Code";
                            PVHeadEr.Validate("Shortcut Dimension 4 Code");
                            PVHeadEr."Payment Narration" := CopyStr(Rec.Purpose, 1, 50);
                            PVHeadEr."Creation Doc No." := Rec."No.";
                            PVHeadEr.Insert(true);

                            STClaimLines.Reset;
                            STClaimLines.SetRange(STClaimLines."No", Rec."No.");
                            if STClaimLines.Find('-') then begin


                                /*
                                PaymentLines.RESET;
                                IF PaymentLines.FIND('+') THEN BEGIN
                                EntryNo:=PaymentLines."Line No.";
                                END;
                                */


                                EntryNo := 1;

                                repeat

                                    PaymentLines.Init;
                                    PaymentLines."Line No." := 0;
                                    //MESSAGE('%1',EntryNo);
                                    PaymentLines.No := PVHeadEr."No.";
                                    // PaymentLines."Account Type":=STClaimLines."account type"::Customer;
                                    PaymentLines."Account No." := STClaimLines."Account No:";
                                    PaymentLines."Account Name" := STClaimLines."Account Name";//Payee;
                                    PaymentLines.Type := STClaimLines."Advance Type";
                                    PaymentLines.Amount := STClaimLines.Amount;
                                    PaymentLines.Validate(Amount);
                                    PaymentLines."Net Amount" := STClaimLines.Amount;
                                    PaymentLines."Global Dimension 1 Code" := STClaimLines."Global Dimension 1 Code";
                                    PaymentLines.Validate("Global Dimension 1 Code");
                                    PaymentLines."Shortcut Dimension 2 Code" := STClaimLines."Shortcut Dimension 2 Code";
                                    PaymentLines.Validate("Shortcut Dimension 2 Code");
                                    //  PaymentLines."Dimension Set ID" := STClaimLines."Dimension Set ID";
                                    PaymentLines.Insert(true);

                                until STClaimLines.Next = 0;
                            end;
                            /*
                            ApprovalEntry.RESET;
                            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.","No.");
                            IF ApprovalEntry.FIND('-') THEN BEGIN
                            REPEAT
                            AppEntry.INIT;
                            AppEntry."Table ID":=39005904;
                            AppEntry."Document Type":=AppEntry."Document Type"::"Payment Voucher";
                            AppEntry."Document No.":=PVHeadEr."No.";
                            AppEntry."Sequence No.":=ApprovalEntry."Sequence No.";
                            AppEntry."Approval Code":=ApprovalEntry."Approval Code";
                            AppEntry."Sender ID":=ApprovalEntry."Sender ID";
                            AppEntry."Salespers./Purch. Code":=ApprovalEntry."Salespers./Purch. Code";
                            AppEntry."Approver ID":=ApprovalEntry."Approver ID";
                            AppEntry.Status:=ApprovalEntry.Status;
                            AppEntry."Date-Time Sent for Approval":=ApprovalEntry."Date-Time Sent for Approval";
                            AppEntry."Last Date-Time Modified":=ApprovalEntry."Last Date-Time Modified";
                            AppEntry."Last Modified By ID":=ApprovalEntry."Last Modified By ID";
                            AppEntry."Due Date":=ApprovalEntry."Due Date";
                            AppEntry.Amount:=ApprovalEntry.Amount;
                            AppEntry."Amount (LCY)":=ApprovalEntry."Amount (LCY)";
                            AppEntry."Currency Code":=ApprovalEntry."Currency Code";
                            AppEntry."Approval Type":=ApprovalEntry."Approval Type";
                            AppEntry."Limit Type":=ApprovalEntry."Limit Type";
                            AppEntry."Available Credit Limit (LCY)":=ApprovalEntry."Available Credit Limit (LCY)";
                            AppEntry.Comment:=ApprovalEntry.Comment;
                            AppEntry.INSERT;
                            UNTIL ApprovalEntry.NEXT=0
                            END;
                            */
                        end;

                        Rec.Posted := true;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec."Posted By" := UserId;
                        Rec.Modify;


                        if Rec."Pay Mode" = Rec."pay mode"::Cash then
                            Page.Run(39005902, PVHeadEr)
                        else
                            Page.Run(39005905, PVHeadEr);

                    end;
                }
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    begin
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                            Error('There are some lines that have not been committed');

                        Rec.TestField(Status, Rec.Status::Pending);

                        VarVariant := Rec;
                        if ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) then
                            ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                    begin

                        VarVariant := Rec;
                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = Basic;
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

            group(Approval)
            {
                Caption = 'Approval';

                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Reject action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Delegate action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = const(39005530),
                                  "Document No." = field("No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Comments action.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
        CurrPageUpdate;
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        "Currency CodeEditable" := true;
        DateEditable := true;
        ShortcutDimension2CodeEditable := true;
        GlobalDimension1CodeEditable := true;
        "Cheque No.Editable" := true;
        "Pay ModeEditable" := true;
        "Paying Bank AccountEditable" := true;
        "Payment Release DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        //check if the documenent has been added while another one is still pending
        TravReqHeader.Reset;
        //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
        TravReqHeader.SetRange(TravReqHeader.Cashier, UserId);
        TravReqHeader.SetRange(TravReqHeader.Status, Rec.Status::Pending);

        if TravReqHeader.Count > 0 then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;
        //*********************************END ****************************************//


        Rec."Payment Type" := Rec."payment type"::Imprest;
        Rec."Account Type" := Rec."account type"::Customer;
        //CurrPage.UPDATE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        UpdateControls;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin

        UpdateControls;

        SetDocNoVisible;
    end;

    var
        PayLine: Record "Staff Claim Lines";
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        // PCheck: Codeunit "Budget Allocation FP";
        Post: Boolean;
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record Committment;
        JournlPosted: Codeunit "Journal Post Successful";
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        BudgetControl: Codeunit "Budgetary Control";
        TravReqHeader: Record "Staff Claims Header";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
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
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CashOfficeSetup: Record "Cash Office Setup";
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";

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
        PayLine.SetRange(PayLine."No", Rec."No.");
        PayLine.SetRange(PayLine.Committed, false);
        PayLine.SetRange(PayLine."Budgetary Control A/C", true);
        if PayLine.Find('-') then
            Exists := true;
    end;

    procedure PostImprest()
    begin

        if Temp.Get(UserId) then begin
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.DeleteAll;
        end;

        //CREDIT BANK
        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."Source No." := Rec."Account No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";

        GenJnlLine."Account No." := Rec."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        // GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine.Description := Rec.Purpose;
        Rec.CalcFields("Total Net Amount");
        GenJnlLine."Credit Amount" := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine."Credit Amount");
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        /* Customer */
        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."Source No." := Rec."Account No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;

        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        // GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine.Description := Rec.Purpose;
        Rec.CalcFields("Total Net Amount");
        GenJnlLine."Debit Amount" := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine."Debit Amount");
        // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        // GenJnlLine."Bal. Account No." := '2330';
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        /* Customer */
        /* balance */
        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."Source No." := Rec."Account No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";

        //GenJnlLine."Account No." := '120028';
        GenJnlLine."Account No.":=PayLine."Account No:";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        // GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine.Description := Rec.Purpose;
        Rec.CalcFields("Total Net Amount");
        GenJnlLine."Credit Amount" := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine."Credit Amount");
        // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        // GenJnlLine."Bal. Account No." := '2330';
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;
        /* balance */


        //DEBIT RESPECTIVE G/L ACCOUNT(S)
        PayLine.Reset;
        PayLine.SetRange("No", Rec."No.");
        if PayLine.Find('-') then begin
            repeat
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Posting Date" := Rec."Payment Release Date";
                GenJnlLine."Source No." := Rec."Account No.";
                //GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Document No." := Rec."No.";
                GenJnlLine."External Document No." := Rec."Cheque No.";
                GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                GenJnlLine."Account No." := PayLine."Account No:";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine.Description := Rec.Purpose;
                // GenJnlLine."Job No.":=PayLine."Job No.";
                // GenJnlLine."Job Task No.":=PayLine."Job Task No.";
                if GenJnlLine."Job No." <> '' then
                    GenJnlLine."Job Quantity" := 1;
                GenJnlLine."Debit Amount" := PayLine.Amount;
                GenJnlLine.Validate(GenJnlLine."Debit Amount");
                //Added for Currency Codes
                GenJnlLine."Currency Code" := Rec."Currency Code";
                GenJnlLine.Validate("Currency Code");
                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                GenJnlLine.Validate("Currency Factor");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                //GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                //GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
                // GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;

            until PayLine.Next = 0
        end;


        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        //Adjust Gen Jnl Exchange Rate Rounding Balances
        AdjustGenJnl.Run(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances


        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
        /*IF "Pay Mode"="Pay Mode"::EFT THEN
        IF CONFIRM('Do you wish to generate EFT File')=TRUE THEN BEGIN
          doctype:='Claim';
         GenerateEFTFile.FnGenerateEFT("No.",Payee,"Cheque No.","Paying Bank Account","Total Net Amount",doctype,"Account No.")
          END ELSE
          MESSAGE('EFT File generation skipped');*/
        Post := false;
        Post := JournlPosted.PostedSuccessfully(Rec."No.");
        if Post then begin
            Rec.Posted := true;
            Rec."Date Posted" := Today;
            Rec."Time Posted" := Time;
            Rec."Posted By" := UserId;
            Rec.Status := Rec.Status::Posted;
            Rec.Modify;
        end;

    end;

    procedure CheckImprestRequiredItems()
    begin

        Rec.TestField("Payment Release Date");
        Rec.TestField("Paying Bank Account");
        Rec.TestField("Account No.");
        Rec.TestField(Status, Rec.Status::Approved);

        if Rec.Posted then begin
            Error('The Document has already been posted');
        end;


        /*Check if the user has selected all the relevant fields*/

        Temp.Get(UserId);
        JTemplate := Temp."Claim Template";
        JBatch := Temp."Claim  Batch";

        if JTemplate = '' then begin
            Error('Ensure the Staff Claims Template is set up in Cash Office Setup');
        end;

        if JBatch = '' then begin
            Error('Ensure the Staff Claims Batch is set up in the Cash Office Setup')
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
            //CurrPage.UpdateControls();
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
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrPage.UpdateControls();
        end else begin
            GlobalDimension1CodeEditable := false;
            ShortcutDimension2CodeEditable := false;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := false;
            ShortcutDimension4CodeEditable := false;
            DateEditable := false;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := false;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        end
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Staff Claim Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange("No", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Staff Claim Lines";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange("No", Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No:" = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;

            //     IF JobsSetup.GET THEN
            //      IF JobPostingGroup.GET(JobsSetup."Default Job Posting Group") THEN
            //        IF PayLines."Account No:" = JobPostingGroup."WIP Costs Account" THEN
            //          BEGIN
            //            IF (PayLines."Job No." = '') OR (PayLines."Job Task No." = '' ) THEN
            //              AllKeyFieldsEntered:=FALSE;
            //          END

            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        CurrPage.Update;
    end;

    procedure CheckIfIsAboveCashLimit()
    var
        CashOfficeSetup: Record "Cash Office Setup";
    begin
        //if above cash limit then pay mode must be cheque
        if Rec."Pay Mode" <> Rec."pay mode"::Cash then exit;
        Rec.CalcFields("Total Net Amount");
        CashOfficeSetup.Get;
        if Rec."Total Net Amount" >= CashOfficeSetup."Minimum Cheque Creation Amount" then
            Error('The specified amount %1 should be created as a cheque.', Rec."Total Net Amount");
    end;

    procedure RecordLinkCheck(StaffClaimsHeader: Record "Staff Claims Header") RecordLnkExist: Boolean
    var
        objRecordLnk: Record "Record Link";
        TableCaption: RecordID;
        objRecord_Link: RecordRef;
    begin
        objRecord_Link.GetTable(StaffClaimsHeader);
        TableCaption := objRecord_Link.RecordId;
        objRecordLnk.Reset;
        objRecordLnk.SetRange(objRecordLnk."Record ID", TableCaption);
        if objRecordLnk.Find('-') then exit(true) else exit(false);
    end;

    local procedure SetDocNoVisible()
    begin
        //DocNoVisible := DocumentNoVisibility.FundsMgtDocumentNoIsVisible(DocType::"Staff Claim","No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}

