Page 50876 "Posted Imprest Requisitions UP"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Imprest Header";
    SourceTableView = where(Posted = const(true));
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDimension1CodeEditable;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(FunctionName; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension2CodeEditable;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(BudgetCenterName; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension3CodeEditable;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension4CodeEditable;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = "Account No.Editable";
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    Editable = PayeeEditable;
                    ToolTip = 'Specifies the value of the Payee field.';
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
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
                field(TotalNetAmount; Rec."Total Net Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
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
                    Editable = "Pay ModeEditable";
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field(PaymentVoucherNo; Rec."Payment Voucher No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Voucher No field.';
                }
                field(DatePosted; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(TimePosted; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field(PostedBy; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
            }
            part(PVLines; "Imprest Details UP")
            {
                ApplicationArea = basic;
                Editable = false;
                SubPageLink = No = field("No.");
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
            group(Functions)
            {
                Caption = '&Functions';
                action(PrintPreview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    ToolTip = 'Executes the Print/Preview action.';
                    //Visible = false;

                    trigger OnAction()
                    var
                        ImpLines: record "Imprest Lines";
                        ImpRep: report "Imprest Requisition";
                    begin
                        //   if Status <> Status::Approved then
                        //  Error('You can only print after the document is released fr approval');
                        ImpLines.reset;
                        ImpLines.setfilter(No, Rec."No.");
                        if ImpLines.find('-') then begin
                            ImpRep.SetTableView(ImpLines);
                            ImpRep.Run();
                        end;

                    end;
                }
                action("Print Accounting Request")
                {
                    ApplicationArea = Basic;
                    Image = PrintAttachment;
                    ToolTip = 'Executes the Print Accounting Request action.';

                    trigger OnAction()
                    var
                        ImpSurr: Record "Imprest Surrender Header";
                    begin

                        ImpSurr.Reset;
                        ImpSurr.SetFilter("Imprest Issue Doc. No", Rec."No.");
                        if ImpSurr.Find('-') then begin
                            Report.Run(70135446, true, true, ImpSurr);
                        end;
                    end;
                }
                separator(Action7) { }

                action("Re-Open")
                {
                    ApplicationArea = Basic;
                    Image = ReopenCancelled;
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
            }
        }
    }



    trigger OnInit()
    begin
        "Account No.Editable" := true;
        DateEditable := true;
        ShortcutDimension4CodeEditable := true;
        ShortcutDimension3CodeEditable := true;
        PayeeEditable := true;
        ShortcutDimension2CodeEditable := true;
        GlobalDimension1CodeEditable := true;
        "Currency CodeEditable" := true;
        "Pay ModeEditable" := true;
        "Payment Release DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Payment Type" := Rec."payment type"::Imprest;
        Rec."Account Type" := Rec."account type"::Customer;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();

    end;

    var
        PayLine: Record "Payment Line";
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        Post: Boolean;
        UserMgt: Codeunit "User Setup Management BR";
        JournlPosted: Codeunit "Journal Post Successful";
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        PayeeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;

    procedure LinesCommitmentStatus() Exists: Boolean
    begin
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
        GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        Rec.CalcFields("Total Net Amount");
        GenJnlLine.Amount := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
        GenJnlLine.Description := 'Imprest: ' + Rec."Account No." + ':' + Rec.Payee;
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;


        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);

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
        Rec.TestField("Account Type", Rec."account type"::Customer);

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

    end;

    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::Approved then begin
            "Payment Release DateEditable" := false;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            "Pay ModeEditable" := false;
            "Currency CodeEditable" := false;
            //CurrPage.UpdateControls();
        end else begin
            "Payment Release DateEditable" := true;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            "Pay ModeEditable" := true;
            "Currency CodeEditable" := true;
            // CurrPage.UpdateControls();
        end;

        if Rec.Status = Rec.Status::Pending then begin
            GlobalDimension1CodeEditable := true;
            ShortcutDimension2CodeEditable := true;
            PayeeEditable := true;
            ShortcutDimension3CodeEditable := true;
            ShortcutDimension4CodeEditable := true;
            DateEditable := true;
            "Account No.Editable" := true;
            //CurrPage.UpdateControls();
        end else begin
            GlobalDimension1CodeEditable := false;
            ShortcutDimension2CodeEditable := false;
            PayeeEditable := false;
            ShortcutDimension3CodeEditable := false;
            ShortcutDimension4CodeEditable := false;
            DateEditable := false;
            "Account No.Editable" := false;
            //CurrPage.UpdateControls();
        end
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}

