page 50499 "Posted Imprest Surrender UP"
{
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Imprest Surrender Header";
    SourceTableView = WHERE(Posted = CONST(true));
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
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    ToolTip = 'Specifies the value of the Imprest Issue Doc. No field.';
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Imprest Issue Date field.';
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
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim4 field.';
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
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
            }
            part(Control1102758004; "Imprest Surrender Details UP")
            {
                Editable = false;
                SubPageLink = "Surrender Doc No." = FIELD(No);
            }
            field(Control1102758005; '')
            {
                CaptionClass = Text19044471;
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
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin


                    if Rec.Posted then
                        Error('The transaction has already been posted.');

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

                            ImprestDetails.TestField("Actual Spent");
                            ImprestDetails.TestField("Actual Spent");
                            Rec.TestField("Global Dimension 1 Code");

                            LineNo := LineNo + 1000;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                            GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                            GenJnlLine."Line No." := LineNo;
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := ImprestDetails."Account No:";
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
                            GenJnlLine.Amount := ImprestDetails."Actual Spent";
                            GenJnlLine.Validate(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                            GenJnlLine."Bal. Account No." := ImprestDetails."Imprest Holder";
                            GenJnlLine.Description := 'Imprest Surrendered by staff';
                            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
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

                            //Post Cash Surrender
                            if ImprestDetails."Cash Surrender Amt" > 0 then begin
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
                                GenJnlLine.Amount := -ImprestDetails."Cash Surrender Amt";
                                GenJnlLine.Validate(GenJnlLine.Amount);
                                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                                GenJnlLine."Bal. Account No." := ImprestDetails."Bank/Petty Cash";
                                GenJnlLine.Description := 'Imprest Surrender by staff';
                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                                GenJnlLine."Applies-to ID" := ImprestDetails."Imprest Holder";
                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert;

                            end;

                        //End Post Surrender Journal

                        until ImprestDetails.Next = 0;
                        //Post Entries
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                    end;

                    if JournalPostSuccessful.PostedSuccessfully(Rec.No) then begin
                        Rec.Posted := true;
                        Rec.Status := Rec.Status::Posted;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec."Posted By" := UserId;
                        Rec.Modify;

                        //Post Committment Reversals
                        Doc_Type := Doc_Type::Imprest;
                        BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
                    end;
                end;
            }
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
            separator(Action7) { }

            action("Re-Open")
            {
                ApplicationArea = Basic;
                Image = ReopenCancelled;
                PromotedCategory = Process;
                Promoted = true;
                ToolTip = 'Executes the Re-Open action.';

                trigger OnAction()
                begin
                    Rec.CalcFields("Posted Count");
                    if Rec."Posted Count" > 0 then Error('Please note that you must reverse the transactions before re-opening the document');
                    Rec.Posted := false;
                    Rec."Posted By" := UserId;
                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify;
                end;
            }
            action("...")
            {
                Caption = '...';
                Enabled = false;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the ... action.';

                trigger OnAction()
                begin
                    if Rec."Imprest Issue Doc. No" = '' then
                        Error('Please Select the Imprest Issue Document Number');

                    PaymentLine.Reset;
                    PaymentLine.SetRange(PaymentLine.No, Rec."Imprest Issue Doc. No");
                    PAGE.RunModal(39006085, PaymentLine);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."User ID" := UserId;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        ImprestDetails: Record "Imprest Surrender Details";
        GenledSetup: Record "Cash Office Setup";
        DimName1: Text[60];
        DimName2: Text[60];
        PaymentLine: Record "Payment Line";
        JournalPostSuccessful: Codeunit "Journal Post Successful";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        Text19044471: Label 'Enter Imprest Surrendered Details below';

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

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
    end;
}

