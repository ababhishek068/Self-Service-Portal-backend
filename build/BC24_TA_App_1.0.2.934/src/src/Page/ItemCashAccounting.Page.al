page 50915 "Item/Cash Accounting"
{
    CardPageID = "ItemCash Accounting UP";
    PageType = List;
    SourceTable = "Imprest Surrender Header";
    SourceTableView = WHERE(Status = FILTER(<> Posted),
                            "Imprest Surrender Type" = FILTER("Item Cash"));


    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Net Amount field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque No field.';
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque Date field.';
                }
                field("Cheque Type"; Rec."Cheque Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque Type field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account No field.';
                }
                field("Cashier Bank Account"; Rec."Cashier Bank Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cashier Bank Account field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Grouping field.';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field("Bank Type"; Rec."Bank Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Type field.';
                }
                field("PV Type"; Rec."PV Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PV Type field.';
                }
                field("Apply to ID"; Rec."Apply to ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Apply to ID field.';
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Imprest Issue Date field.';
                }
                field(Surrendered; Rec.Surrendered)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Surrendered field.';
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Imprest Issue Doc. No field.';
                }
                field("Vote Book"; Rec."Vote Book")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vote Book field.';
                }
                field("Total Allocation"; Rec."Total Allocation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Allocation field.';
                }
                field("Total Expenditure"; Rec."Total Expenditure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Expenditure field.';
                }
                field("Total Commitments"; Rec."Total Commitments")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Commitments field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field("Balance Less this Entry"; Rec."Balance Less this Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Balance Less this Entry field.';
                }
                field("Petty Cash"; Rec."Petty Cash")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Petty Cash field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Issue Voucher Type"; Rec."Issue Voucher Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Issue Voucher Type field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Amount Surrendered LCY"; Rec."Amount Surrendered LCY")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount Surrendered LCY field.';
                }
                field("PV No"; Rec."PV No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PV No field.';
                }
                field("Print No."; Rec."Print No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Print No. field.';
                }
                field("Cash Surrender Amt"; Rec."Cash Surrender Amt")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cash Surrender Amt field.';
                }
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
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::ImprestSurrender;
                        ApprovalEntries.SetRecordFilters(DATABASE::"Imprest Surrender Header", DocumentType, Rec.No);
                        ApprovalEntries.Run;
                    end;
                }
                separator(Separator5) { }
                action(sendApproval)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    begin
                        //First Check whether all amount entered tally
                        ImprestDetails.Reset;
                        ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.", Rec.No);
                        if ImprestDetails.Find('-') then begin
                            repeat
                                if (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount then
                                    Error('Receipt Amount and Imprest Should be equal to Imprest Amount..');

                            until ImprestDetails.Next = 0;
                        end;
                    end;
                }
                action(cancellsApproval)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        DocType := DocType::ImprestSurrender;
                        showmessage := true;
                        ManualCancel := true;
                        Clear(tableNo);
                        // tableNo:=DATABASE::"Appraisal Objective";
                        //IF ApprovalMgt.CancelApproval(tableNo,DocType,Rec.No,showmessage,ManualCancel) THEN;

                        // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
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
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                var
                    Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
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
                            if (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount then
                                Error(Txt0001);

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
                            GenJnlLine.Amount := -ImprestDetails."Actual Spent";
                            GenJnlLine.Validate(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                            GenJnlLine."Bal. Account No." := ImprestDetails."Imprest Holder";
                            GenJnlLine.Description := 'Imprest Surrendered by staff';
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
                                //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                                GenJnlLine."Applies-to Doc. No." := Rec."PV No";
                                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                                GenJnlLine."Applies-to ID" := Rec."Apply to ID";

                            end;

                            if GenJnlLine.Amount <> 0 then
                                GenJnlLine.Insert;

                            //Post Cash Surrender
                            if ImprestDetails."Cash Receipt Amount" > 0 then begin
                                if ImprestDetails."Bank/Petty Cash" = '' then
                                    Error('Select a Bank Code where the Cash Surrender will be posted');
                                LineNo := LineNo + 1000;
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                                GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                GenJnlLine."Account No." := ImprestDetails."Imprest Holder";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                //Set these fields to blanks
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
                                GenJnlLine."Posting Date" := Rec."Surrender Date";
                                GenJnlLine."Document No." := Rec.No;
                                GenJnlLine.Amount := -ImprestDetails."Cash Receipt Amount";
                                GenJnlLine.Validate(GenJnlLine.Amount);
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.Validate("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.Validate("Currency Factor");

                                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                                GenJnlLine."Bal. Account No." := ImprestDetails."Bank/Petty Cash";
                                GenJnlLine.Description := 'Imprest Surrender by staff';
                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                                //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                GenJnlLine."Applies-to ID" := ImprestDetails."Imprest Holder";

                                //Application of Surrender entries
                                if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                                    GenJnlLine."Applies-to Doc. No." := Rec."PV No";
                                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := Rec."Apply to ID";

                                    if GenJnlLine.Amount <> 0 then
                                        GenJnlLine.Insert;

                                end;
                            end;
                        //End Post Surrender Journal

                        until ImprestDetails.Next = 0;
                        //Post Entries

                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        //Adjust Gen Jnl Exchange Rate Rounding Balances
                        AdjustGenJnl.Run(GenJnlLine);
                        //End Adjust Gen Jnl Exchange Rate Rounding Balances



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
                    GenerateReceipt();
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
                    REPORT.Run(70134763, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Imprest Surrender Type" := Rec."Imprest Surrender Type"::"Item Cash";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Imprest Surrender Type" := Rec."Imprest Surrender Type"::"Item Cash";
    end;

    var
        ApprovalEntries: Page "Approval Entries";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        ImprestDetails: Record "Imprest Surrender Details";
        //  ImprestRequestDet: Record "Payments-Users";
        GenledSetup: Record "Cash Office Setup";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        ImprestReq: Record "Imprest Header";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender;
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        PurchRcpHeader: Record "Purch. Rcpt. Header";
        PurchRcpLine: Record "Purch. Rcpt. Line";
        ItemCashAccLine: Record "Imprest Surrender Details";

    local procedure GenerateReceipt()
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

