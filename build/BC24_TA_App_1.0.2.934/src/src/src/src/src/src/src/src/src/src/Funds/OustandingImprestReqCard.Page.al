Page 50968 "Oustanding Imprest Req Card"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approvals';
    SourceTable = "InterBank Transfers";
    SourceTableView = where(Posted = filter(false), Type = filter("Outstanding Imprest"));
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
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                label(Control1102758030)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19025618;
                    Style = Standard;
                    StyleExpr = true;
                }
                field(ReceivingTransferType; Rec."Receiving Transfer Type")
                {
                    ApplicationArea = Basic;
                    Editable = ReceivingTransferTypeEditable;
                    ToolTip = 'Specifies the value of the Receiving Transfer Type field.';
                }
                field(RecieptResponsibilityCenter; Rec."Reciept Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = RecieptResponsibilityCenterEdi;
                    ToolTip = 'Specifies the value of the Reciept Responsibility Center field.';
                }
                field(ReceiptRespCentre; Rec."Receipt Resp Centre")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt Resp Centre field.';
                }
                field(ReceivingAccount; Rec."Receiving Account")
                {
                    ApplicationArea = Basic;
                    Editable = "Receiving AccountEditable";
                    ToolTip = 'Specifies the value of the Receiving Account field.';

                    trigger OnValidate()
                    begin
                        ReceivingAccountOnAfterValidat;
                        CurrPage.Update;
                    end;
                }
                field(ReceivingBankAccountName; Rec."Receiving Bank Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receiving Bank Account Name field.';
                }
                field(CurrencyCodeDestination; Rec."Currency Code Destination")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code Destination field.';
                }
                field(Amount; Rec."Amount 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                    Editable = "Amount 2Editable";
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(ReceivingNegotiableRate; Rec."Negotiable Rate2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Receiving Negotiable Rate';
                    ToolTip = 'Specifies the value of the Receiving Negotiable Rate field.';
                }
                field(ExchRateDestination; Rec."Exch. Rate Destination")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Exch. Rate Destination field.';
                }
                field(RequestAmtLCY; Rec."Request Amt LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Amt LCY field.';
                }
                field("Receiving Depot Code"; Rec."Receiving Depot Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Depot Code field.';
                }
                field("Receiving Department Code"; Rec."Receiving Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Department Code field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = RemarksEditable;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                group(Sending)
                {
                    Caption = 'Sending';
                    Editable = "Source Transfer TypeEditable";
                }
                field(SourceTransferType; Rec."Source Transfer Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Transfer Type field.';
                }
                field("Source Department Code"; Rec."Source Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Budget Center Code field.';
                }
                field("Source Depot Code"; Rec."Source Depot Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Funtion Code field.';
                }
                field(SendingResponsibilityCenter; Rec."Sending Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sending Responsibility Center field.';
                }
                field(SendingRespCentre; Rec."Sending Resp Centre")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sending Resp Centre field.';
                }
                field(PayingAccount; Rec."Paying Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Account field.';

                    trigger OnValidate()
                    begin
                        PayingAccountOnAfterValidate;
                    end;
                }
                field(PayingBankAccountName; Rec."Paying  Bank Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Paying  Bank Account Name field.';
                }
                field(CurrencyCodeSource; Rec."Currency Code Source")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code Source field.';
                }
                field(PayableNegotiableRate; Rec."Negotiable Rate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payable Negotiable Rate';
                    ToolTip = 'Specifies the value of the Payable Negotiable Rate field.';
                }
                field(Control1102758027; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(PayAmtLCY; Rec."Pay Amt LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Amt LCY field.';
                }
                field(ExternalDocNo; Rec."External Doc No.")
                {
                    ApplicationArea = Basic;
                    Editable = "External Doc No.Editable";
                    ToolTip = 'Specifies the value of the External Doc No. field.';
                }
                field(TransferReleaseDate; Rec."Transfer Release Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Transfer Release DateEditable";
                    ToolTip = 'Specifies the value of the Transfer Release Date field.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';

                SubPageLink = "Table ID" = CONST(70135167),
                "No." = FIELD(No);

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
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Print action.';

                    trigger OnAction()
                    begin
                        Rec.Reset;
                        Rec.SetRange(No, Rec.No);
                        Report.Run(70135460, true, true, Rec);
                        Rec.Reset;
                    end;
                }
                action(CancelDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Document';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Document action.';

                    trigger OnAction()
                    var
                        Text000: label 'Are you sure you want to Cancel this Document?';
                        Text001: label 'You have selected not to Cancel this Document';
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        if Confirm(Text000, true) then begin
                            Rec.Status := Rec.Status::Cancelled;
                            Rec."Cancelled By" := UserId;
                            Rec."Date Cancelled" := Today;
                            Rec."Time Cancelled" := Time;
                            Rec.Modify;
                        end else
                            Error(Text001);
                    end;
                }
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = '&Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the &Post action.';

                trigger OnAction()
                begin
                    TempBatch.Reset;
                    TempBatch.SetRange(TempBatch.UserID, UserId);
                    if TempBatch.Find('-') then begin
                        Rec."Inter Bank Template Name" := TempBatch."Inter Bank Template Name";
                        Rec."Inter Bank Journal Batch" := TempBatch."Inter Bank Batch Name";
                    end;

                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.TestField("Transfer Release Date");
                    //get the source account balance from the database table
                    BankAcc.Reset;
                    BankAcc.SetRange(BankAcc."No.", Rec."Paying Account");
                    BankAcc.SetRange(BankAcc."Bank Type", BankAcc."bank type"::Cash);
                    if BankAcc.FindFirst then begin
                        BankAcc.CalcFields(BankAcc.Balance);
                        Rec."Current Source A/C Bal." := BankAcc.Balance;
                        if (Rec."Current Source A/C Bal." - Rec.Amount) < 0 then begin
                            Error('The transaction will result in a negative balance in a CASH ACCOUNT.');
                        end;
                    end;
                    if Rec.Amount = 0 then begin
                        Error('Please ensure Amount to Transfer is entered');
                    end;
                    /*Check if the user's batch has any records within it*/
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", Rec."Inter Bank Template Name");
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Rec."Inter Bank Journal Batch");
                    GenJnlLine.DeleteAll;

                    LineNo := 1000;

                    GenJnlLine.Init;
                    /*Insert the lines*/
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                    GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                    GenJnlLine."Posting Date" := Rec."Transfer Release Date";
                    GenJnlLine."Document No." := Rec.No;
                    if Rec."Receiving Transfer Type" = Rec."receiving transfer type"::"Intra-Company" then begin
                        GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
                    end
                    else
                        if Rec."Receiving Transfer Type" = Rec."receiving transfer type"::"Inter-Company" then begin
                            GenJnlLine."Account Type" := GenJnlLine."account type"::"IC Partner";
                        end;

                    GenJnlLine."Account No." := Rec."Receiving Account";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + Format(Rec.No);
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Receiving Depot Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Receiving Department Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code1");
                    GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code1");
                    GenJnlLine."External Document No." := Rec."External Doc No.";

                    GenJnlLine.Description := Rec.Remarks;
                    if Rec.Remarks = '' then begin
                        GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + Format(Rec.No);
                    end;
                    GenJnlLine."Currency Code" := Rec."Currency Code Destination";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    if Rec."Currency Code Destination" <> '' then begin
                        GenJnlLine."Currency Factor" := 1 / Rec."Negotiable Rate2";//"Reciprical 2";
                        GenJnlLine.Validate(GenJnlLine."Currency Factor");
                        GenJnlLine.Amount := Rec."Amount 2";
                    end else
                        GenJnlLine.Amount := Rec."Request Amt LCY";
                    GenJnlLine.Validate(GenJnlLine.Amount);

                    GenJnlLine.Insert;
                    GenJnlLine.Init;
                    /*Insert the lines*/
                    GenJnlLine."Line No." := LineNo + 1;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                    GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                    GenJnlLine."Posting Date" := Rec."Transfer Release Date";
                    GenJnlLine."Document No." := Rec.No;
                    if Rec."Source Transfer Type" = Rec."source transfer type"::"Intra-Company" then begin
                        GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
                    end
                    else
                        if Rec."Source Transfer Type" = Rec."source transfer type"::"Inter-Company" then begin
                            GenJnlLine."Account Type" := GenJnlLine."account type"::"IC Partner";
                        end;


                    GenJnlLine."Account No." := Rec."Paying Account";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Source Depot Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Source Department Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                    GenJnlLine."External Document No." := Rec."External Doc No.";
                    GenJnlLine.Description := Rec.Remarks;
                    if Rec.Remarks = '' then begin
                        GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + Format(Rec.No);
                    end;
                    if Rec."Currency Code Source" <> '' then begin
                        GenJnlLine."Currency Code" := Rec."Currency Code Source";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := 1 / Rec."Negotiable Rate";
                        if Rec."Negotiable Rate" > 0 then
                            GenJnlLine.Amount := -Rec.Amount;
                    end else
                        GenJnlLine.Amount := -Rec."Pay Amt LCY";
                    GenJnlLine.Validate(GenJnlLine.Amount);

                    GenJnlLine.Insert;
                    Post := false;
                    Commit;
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
                    Post := JournalPostedSuccessfully.PostedSuccessfully(Rec.No);

                    if Post then begin
                        Rec.Posted := true;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec."Posted By" := UserId;
                        Rec.Modify;
                        Message('The Journal Has Been Posted Successfully');
                    end;

                end;
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";

                    begin
                        Rec.TestField("Receipt Resp Centre");
                        Rec.TestField("Receiving Account");
                        Rec.TestField(Amount);
                        Rec.TestField("Amount 2");
                        Rec.TestField("Source Department Code");
                        Rec.TestField("Source Department Code");
                        Rec.TestField("Source Depot Code");
                        Rec.TestField("Paying Account");
                        Rec.TestField("Receiving Depot Code");
                        Rec.TestField("Receiving Department Code");
                        Rec.TestField("Sending Responsibility Center");
                        VarVariant := Rec;
                        if ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) then
                            ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
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
            }
            group(Navigate)
            {
                Caption = 'Navigate';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        if Rec."Currency Code Source" <> '' then begin

            "Exch. Rate SourceVisible" := true;
        end
        else begin
            "Exch. Rate SourceVisible" := false;
        end;

        if Rec."Currency Code Destination" <> '' then begin
            "Exch. Rate DestinationVisible" := true;
        end
        else begin
            "Exch. Rate DestinationVisible" := false;
        end;

        UpdateControl;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        /*"Transfer Release DateEditable" := TRUE;
        "External Doc No.Editable" := TRUE;
        "Exch. Rate SourceEditable" := TRUE;
        AmountEditable := TRUE;
        "Paying AccountEditable" := TRUE;
        SendingResponsibilityCenterEdi := TRUE;*/
        "Source Transfer TypeEditable" := true;
        /*"Exch. Rate DestinationEditable" := TRUE;
        RemarksEditable := TRUE;
        "Amount 2Editable" := TRUE;
        "Receiving AccountEditable" := TRUE;
        RecieptResponsibilityCenterEdi := TRUE;
        ReceivingTransferTypeEditable := TRUE;
        DateEditable := TRUE;*/

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Date := Today;
        Rec."Inter Bank Template Name" := JTemplate;
        Rec."Inter Bank Journal Batch" := JBatch;
        Rec.Type := Rec.Type::"Outstanding Imprest";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Reciept Responsibility Center" := UserMgt.GetPurchasesFilter();
        //VALIDATE( "Reciept Responsibility Center");
        Rec.Status := Rec.Status::Pending;
        Rec."Created By" := UserId;

        UpdateControl;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Reciept Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;


        TempBatch.Reset;

        TempBatch.SetRange(TempBatch.UserID, UserId);
        if TempBatch.Find('-') then begin
            JTemplate := TempBatch."Inter Bank Template Name";
            JBatch := TempBatch."Inter Bank Batch Name";
        end;

        if Rec."Currency Code Destination" <> '' then begin
            "Exch. Rate DestinationVisible" := true;
        end
        else begin
            "Exch. Rate DestinationVisible" := false;
        end;

        UpdateControl;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TempBatch: Record "Cash Office User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        Post: Boolean;
        BankAcc: Record "Bank Account";
        JournalPostedSuccessfully: Codeunit "Journal Post Successful";
        UserMgt: Codeunit "User Setup Management BR";
        [InDataSet]
        "Exch. Rate DestinationVisible": Boolean;
        [InDataSet]
        "Exch. Rate SourceVisible": Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        ReceivingTransferTypeEditable: Boolean;
        [InDataSet]
        RecieptResponsibilityCenterEdi: Boolean;
        [InDataSet]
        "Receiving AccountEditable": Boolean;
        [InDataSet]
        "Amount 2Editable": Boolean;
        [InDataSet]
        RemarksEditable: Boolean;
        [InDataSet]
        "Exch. Rate DestinationEditable": Boolean;
        [InDataSet]
        "Source Transfer TypeEditable": Boolean;
        [InDataSet]
        SendingResponsibilityCenterEdi: Boolean;
        [InDataSet]
        "Paying AccountEditable": Boolean;
        [InDataSet]
        AmountEditable: Boolean;
        [InDataSet]
        "Exch. Rate SourceEditable": Boolean;
        [InDataSet]
        "External Doc No.Editable": Boolean;
        [InDataSet]
        "Transfer Release DateEditable": Boolean;
        Text19025618: label 'Requesting Details';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;

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
            DateEditable := false;
            ReceivingTransferTypeEditable := false;
            RecieptResponsibilityCenterEdi := false;
            "Receiving AccountEditable" := false;
            "Amount 2Editable" := false;
            RemarksEditable := false;
            "Exch. Rate DestinationEditable" := false;

        end else begin
            DateEditable := true;
            ReceivingTransferTypeEditable := true;
            RecieptResponsibilityCenterEdi := true;
            "Receiving AccountEditable" := true;
            "Amount 2Editable" := true;
            RemarksEditable := true;
            "Exch. Rate DestinationEditable" := true;


        end;

        if Rec.Status = Rec.Status::Approved then begin
            "Source Transfer TypeEditable" := false;
            SendingResponsibilityCenterEdi := false;
            "Paying AccountEditable" := false;
            AmountEditable := false;
            "Paying AccountEditable" := false;
            "Exch. Rate SourceEditable" := false;
            "External Doc No.Editable" := true;
            "Transfer Release DateEditable" := true;
        end else begin
            "Source Transfer TypeEditable" := false;
            SendingResponsibilityCenterEdi := false;
            AmountEditable := false;
            "Paying AccountEditable" := false;
            "Exch. Rate SourceEditable" := false;
            "External Doc No.Editable" := false;
            "Transfer Release DateEditable" := false;
        end;
    end;

    local procedure ReceivingAccountOnAfterValidat()
    begin
        //check if the currency code field has been filled in
        "Exch. Rate DestinationVisible" := false;
        if Rec."Currency Code Destination" <> '' then begin
            "Exch. Rate DestinationVisible" := true;
        end;
    end;

    local procedure PayingAccountOnAfterValidate()
    begin
        //check if the currency code field has been filled in
        "Exch. Rate SourceVisible" := false;
        if Rec."Currency Code Source" <> '' then begin
            "Exch. Rate SourceVisible" := true;
        end;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}

