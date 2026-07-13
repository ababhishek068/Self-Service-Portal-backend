page 50857 "Posted Interbank Transfers UP"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "InterBank Transfers";
    SourceTableView = WHERE(Posted = CONST(true));
    UsageCategory = History;
    ApplicationArea = basic;
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
                    Enabled = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    Editable = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Control1102758030; '')
                {
                    CaptionClass = Text19025618;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                }
                field("Receiving Transfer Type"; Rec."Receiving Transfer Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Transfer Type field.';
                }
                field("Reciept Responsibility Center"; Rec."Reciept Responsibility Center")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reciept Responsibility Center field.';
                }
                field(Control1102758029; '')
                {
                    CaptionClass = Text19044997;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                }
                field("Receipt Resp Centre"; Rec."Receipt Resp Centre")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receipt Resp Centre field.';
                }
                field("Receiving Account"; Rec."Receiving Account")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Account field.';

                    trigger OnValidate()
                    begin
                        ReceivingAccountOnAfterValidat;
                    end;
                }
                field("Receiving Bank Account Name"; Rec."Receiving Bank Account Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Bank Account Name field.';
                }
                field("Currency Code Destination"; Rec."Currency Code Destination")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Currency Code Destination field.';
                }
                field("Amount 2"; Rec."Amount 2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount 2 field.';
                }
                field("Request Amt LCY"; Rec."Request Amt LCY")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Request Amt LCY field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Source Transfer Type"; Rec."Source Transfer Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Transfer Type field.';
                }
                field("Sending Responsibility Center"; Rec."Sending Responsibility Center")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sending Responsibility Center field.';
                }
                field("Sending Resp Centre"; Rec."Sending Resp Centre")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sending Resp Centre field.';
                }
                field("Paying Account"; Rec."Paying Account")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Paying Account field.';

                    trigger OnValidate()
                    begin
                        PayingAccountOnAfterValidate;
                    end;
                }
                field("Paying  Bank Account Name"; Rec."Paying  Bank Account Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Paying  Bank Account Name field.';
                }
                field("Currency Code Source"; Rec."Currency Code Source")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Currency Code Source field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Pay Amt LCY"; Rec."Pay Amt LCY")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Pay Amt LCY field.';
                }
                field("Exch. Rate Destination"; Rec."Exch. Rate Destination")
                {
                    Visible = "Exch. Rate DestinationVisible";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Exch. Rate Destination field.';
                }
                field("Exch. Rate Source"; Rec."Exch. Rate Source")
                {
                    Visible = "Exch. Rate SourceVisible";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Exch. Rate Source field.';
                }
                field("External Doc No."; Rec."External Doc No.")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the External Doc No. field.';
                }
                group("Transfer Lines")
                {

                    part(Control9; "Interbank Transfer Lines")
                    {
                        ApplicationArea = basic;
                        SubPageLink = "No." = FIELD(No);
                    }
                }
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70135167),
                              "No." = FIELD("No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Post")
            {
                Caption = '&Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the &Post action.';

                trigger OnAction()
                begin

                    Rec.TestField(Status, Rec.Status::Approved);

                    //Check whether the two LCY amounts are same
                    if Rec."Request Amt LCY" <> Rec."Pay Amt LCY" then
                        Error('The [Requested Amount in LCY] should be same as the [Paid Amount in LCY]');
                    //get the source account balance from the database table
                    BankAcc.Reset;
                    BankAcc.SetRange(BankAcc."No.", Rec."Paying Account");
                    BankAcc.SetRange(BankAcc."Bank Type", BankAcc."Bank Type"::Cash);

                    if BankAcc.FindFirst then begin
                        BankAcc.CalcFields(BankAcc."Balance (LCY)");
                        Rec."Current Source A/C Bal." := BankAcc."Balance (LCY)";
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
                    /*Insert the new lines to be updated*/
                    GenJnlLine.Init;
                    /*Insert the lines*/
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                    GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    if Rec."Receiving Transfer Type" = Rec."Receiving Transfer Type"::"Intra-Company" then begin
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    end
                    else
                        if Rec."Receiving Transfer Type" = Rec."Receiving Transfer Type"::"Inter-Company" then begin
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"IC Partner";
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

                    GenJnlLine.Description := Rec.Remarks;
                    if Rec.Remarks = '' then begin GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + Format(Rec.No); end;
                    GenJnlLine."Currency Code" := Rec."Currency Code Destination";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    if Rec."Currency Code Destination" <> '' then begin
                        GenJnlLine."Currency Factor" := Rec."Reciprical 2";
                        GenJnlLine.Validate(GenJnlLine."Currency Factor");
                    end;
                    GenJnlLine.Amount := Rec."Amount 2";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine.Insert;


                    GenJnlLine.Init;
                    /*Insert the lines*/
                    GenJnlLine."Line No." := LineNo + 1;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                    GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    if Rec."Source Transfer Type" = Rec."Source Transfer Type"::"Intra-Company" then begin
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    end
                    else
                        if Rec."Source Transfer Type" = Rec."Source Transfer Type"::"Inter-Company" then begin
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"IC Partner";
                        end;


                    GenJnlLine."Account No." := Rec."Paying Account";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Source Depot Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Source Department Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                    GenJnlLine.Description := Rec.Remarks;
                    if Rec.Remarks = '' then begin GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + Format(Rec.No); end;
                    GenJnlLine."Currency Code" := Rec."Currency Code Source";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    if Rec."Currency Code Source" <> '' then begin
                        GenJnlLine."Currency Factor" := Rec."Reciprical 1";
                        GenJnlLine.Validate(GenJnlLine."Currency Factor");
                    end;
                    GenJnlLine.Amount := -Rec.Amount;
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine.Insert;
                    Post := false;
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
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

            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Visible = false;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    DocumentType: Option Interbank;
                begin
                    DocumentType := DocumentType::Interbank;
                    ApprovalEntries.SetRecordFilters(DATABASE::"InterBank Transfers", DocumentType, Rec.No);
                    ApprovalEntries.Run;
                end;
            }
            separator(Separator1102756004) { }
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
                    Rec.SetRange(No, Rec.No);
                    REPORT.Run(70135460, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Re-Open")
            {
                Image = ReleaseDoc;
                ApplicationArea = basic;
                ToolTip = 'Executes the Re-Open action.';


                trigger OnAction()
                begin
                    if Confirm('Do you really want to re-open the document') then begin
                        Rec.CalcFields("Reversed PV");
                        Rec.CalcFields("Posted Count");
                        if Rec."Posted Count" > 0 then
                            Rec.TestField("Reversed PV", true);
                        Rec.Posted := false;
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify;
                    end;
                end;
            }

        }
    }



    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Date := Today;
        Rec."Inter Bank Template Name" := JTemplate;
        Rec."Inter Bank Journal Batch" := JBatch;
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

        /*Check if the user has the batches selected*/
        if (JTemplate = '') or (JBatch = '') then begin
            Error('Please ensure you are setup as an interbank transfer user');
        end;

        /*
       IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
         FILTERGROUP(2);
         SETRANGE("Reciept Responsibility Center" ,UserMgt.GetPurchasesFilter());
         FILTERGROUP(0);
       END;
          //Reciept Responsibility Center
          */

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
        Text19025618: Label 'Requesting Details';
        Text19044997: Label 'Source Details';
        ApprovalEntries: Page "Approval Entries";

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

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
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
}

