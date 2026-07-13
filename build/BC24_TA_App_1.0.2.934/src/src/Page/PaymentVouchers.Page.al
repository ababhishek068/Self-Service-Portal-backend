page 50890 "Payment Vouchers"
{
    CardPageID = "Payment Header";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTable = "Payments Header";
    SourceTableView = WHERE("Payment Type" = FILTER(Normal),
                            Status = FILTER(Pending | "Pending Approval" | "Approved"));


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }

                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field("Total Payment Amount"; Rec."Total Payment Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payment Amount field.';
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total VAT Amount field.';
                }
                field("Total Witholding Tax Amount"; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Witholding Tax Amount field.';
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field("Current Status"; Rec."Current Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Status field.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Base Amount field.';
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
                field("Currency Reciprical"; Rec."Currency Reciprical")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Reciprical field.';
                }
                field("Current Source A/C Bal."; Rec."Current Source A/C Bal.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Source A/C Bal. field.';
                }
                field("Cancellation Remarks"; Rec."Cancellation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancellation Remarks field.';
                }
                field("Register Number"; Rec."Register Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Register Number field.';
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Entry No. field.';
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Entry No. field.';
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Currency Code field.';
                }
                field("Total Payment Amount LCY"; Rec."Total Payment Amount LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payment Amount LCY field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }

                field("Cheque Type"; Rec."Cheque Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Type field.';
                }
                field("Total Retention Amount"; Rec."Total Retention Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Retention Amount field.';
                }
                field("Payment Narration"; Rec."Payment Narration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Narration field.';
                }
                field("Total PAYE Amount"; Rec."Total PAYE Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total PAYE Amount field.';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reference No. field.';
                }
                field("Cheque Printed"; Rec."Cheque Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Printed field.';
                }
                field("Apply to Document Type"; Rec."Apply to Document Type")
                {
                    ToolTip = 'Specifies the value of the Apply to Document Type field.';
                }
                field("Apply to Document No"; Rec."Apply to Document No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Apply to Document No field.';
                }
                field("Imprest No."; Rec."Imprest No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Imprest No. field.';
                }
                field("Claim No."; Rec."Claim No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim No. field.';
                }
                field("PF No"; Rec."PF No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PF No field.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action(postPvold)
                {
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the Post Payment action.';

                    trigger OnAction()
                    begin
                        //Post PV Entries
                        CurrPage.SaveRecord;
                        CheckPVRequiredItems(Rec);
                        PostPaymentVoucher(Rec);
                    end;
                }
                action(postPvs)
                {
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Post Payment action.';

                    trigger OnAction()
                    begin
                        //Post PV Entries
                        Rec.CalcFields("Posted Count");
                        if Rec."Posted Count" > 0 then Error('Posted entries exists in the ledger for the selected document');

                        CurrPage.SaveRecord;
                        CheckPVRequiredItems(Rec);
                        PostPaymentVoucher(Rec);

                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(70134999, true, true, Rec);
                    end;
                }
                action(CopyPV)
                {
                    Caption = 'Duplicate This Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Duplicate This Payment action.';

                    trigger OnAction()
                    var
                        PLines: Record "Payment Line";
                        CurPLines: Record "Payment Line";
                        PHeader: Record "Payments Header";
                        noseries: Codeunit "No. Series";
                        newPVNo: Code[20];
                    begin
                        //Copy PV Entries
                        newPVNo := noseries.GetNextNo('P/V', 0D, true);

                        PHeader.Init();
                        PHeader."No." := newPVNo;
                        PHeader.Insert();

                        CurPLines.Reset();
                        CurPLines.SetRange(CurPLines."Document No", Rec."No.");
                        if CurPLines.Find('-') then begin
                            repeat
                                PLines.Init();
                                PLines.No := CurPLines.No;
                                PLines."Document No" := newPVNo;
                                PLines."Type" := CurPLines."Type";
                                PLines."Pay Mode" := CurPLines."Pay Mode";
                                PLines."Cheque No" := CurPLines."Cheque No";
                                PLines.Insert();
                            until CurPLines.Next = 0;
                        end;
                        Rec.Reset;

                        Rec.Reset;

                        Rec.SetFilter("No.", newPVNo);
                        Page.Run(70135421, Rec);
                    end;
                }
                separator(Separator13) { }
                action(Approvals)
                {
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
                action(sendApproval)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        if not LinesExists then
                            Error('There are no Lines created for this Document');
                        Rec.TestField(Status, Rec.Status::Pending);
                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                            Error('Please Check the Budget before you Proceed');

                        //Release the PV for Approval
                        State := State::Open;
                        if Rec.Status <> Rec.Status::Pending then State := State::"Pending Approval";
                        DocType := DocType::"Payment Voucher";
                        Clear(tableNo);
                        tableNo := DATABASE::"Payments Header";
                        // ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State) THEN;
                        //  ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,'',"Responsibility Center"); // ,"Responsibility Center"
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
                        //  ApprovalMgt: Codeunit "Approvals Management";
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        DocType := DocType::"Payment Voucher";
                        showmessage := true;
                        ManualCancel := true;
                        Clear(tableNo);
                        tableNo := DATABASE::"Payments Header";
                        // if ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) then;
                    end;
                }
                separator(Separator9) { }
                action(CheckBudget)
                {
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
                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                            exit;
                        //Ensure only Pending Documents are commited
                        Rec.TestField(Status, Rec.Status::Pending);

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                        //First Check whether other lines are already committed.
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::"Payment Voucher");
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
                        if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::"Payment Voucher");
                            Commitments.SetRange(Commitments."Document No.", Rec."No.");
                            Commitments.DeleteAll;
                        end;

                        CheckBudgetAvail.CheckPayments(Rec);
                    end;
                }
                action(CancelBudget)
                {
                    Caption = 'Cancel Budget Commitment';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Budget Commitment action.';

                    trigger OnAction()
                    begin
                        //Ensure only Pending Documents are commited
                        Rec.TestField(Status, Rec.Status::Pending);

                        if Confirm('Do you Wish to Cancel the Commitment entries for this document', false) = false then begin exit end;

                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::"Payment Voucher");
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
                separator(Separator6) { }
                action(Print)
                {
                    Caption = 'Print/Preview';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = true;
                    ToolTip = 'Executes the Print/Preview action.';

                    trigger OnAction()
                    var
                        PVReport: Report "Payment Voucher New";
                        PVLine: Record "Payment Line";
                    begin

                        if Rec.Status <> Rec.Status::Approved then
                            Error('You cannot Print until the document is released for approval');

                        PVLine.reset;
                        PVLine.setfilter(No, Rec."No.");
                        if PVLine.find('-') then begin
                            PVReport.SetTableView(PVLine);
                            PVReport.Run();
                        end;

                        CurrPage.Update;
                        CurrPage.SaveRecord;
                    end;

                }
                separator(Separator3) { }
                action(CanelDoc)
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Document action.';

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to cancel this Document?';
                        Text001: Label 'You have selected not to Cancel the Document';
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        if Confirm(Text000, true) then begin
                            //Post Reversal Entries for Commitments
                            Doc_Type := Doc_Type::"Payment Voucher";
                            CheckBudgetAvail.ReverseEntries(Doc_Type, Rec."No.");
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end else
                            Error(Text001);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserTemp: record "Cash Office User Template";

    begin
        if UserTemp.get(Database.UserId) then
            if UserTemp."Source of Funds" <> '' then
                Rec.setfilter("Shortcut Dimension 3 Code", UserTemp."Source of Funds");

    end;

    var
        PayLine: Record "Payment Line";
        Payments: Record "Payments Header";
        TarriffCodes: Record "Tariff Codes";
        GenJnlLine: Record "Gen. Journal Line";
        CashierLinks: Record "Cash Office User Template";
        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "Payments Header";
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record Committment;
        JournlPosted: Codeunit "Journal Post Successful";
        Doc_Type: Option LPO,RCodeVarequisition,Imprest,"Payment Voucher";
        DocPrint: Codeunit "Document-Print";
        CheckLedger: Record "Check Ledger Entry";
        CheckManagement: Codeunit CheckManagement;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Cheque TypeEditable": Boolean;
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        "Payment NarrationEditable": Boolean;
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
        PVLinesEditable: Boolean;
        PayingBankAccountEditable: Boolean;
        ImprestHeader: Record "Imprest Header";
        PaymodeEditable: Boolean;
        Text001: Label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text000: Label 'Do you want to Void Check No %1';
        Text002: Label 'You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';

    procedure PostPaymentVoucherx(rec: Record "Payments Header")
    begin


        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;
        GenJnlLine.DeleteAll;
        GenJnlLine.Reset;

        Payments.Reset;
        Payments.SetRange(Payments."No.", Rec."No.");
        if Payments.Find('-') then begin
            PayLine.Reset;
            PayLine.SetRange(PayLine.No, Payments."No.");
            if PayLine.Find('-') then begin
                repeat
                    PostHeader(Payments);
                until PayLine.Next = 0;
            end;

            Post := false;
            Post := JournlPosted.PostedSuccessfully(Rec."No.");
            if Post then begin
                Rec.Posted := true;
                Rec.Status := Payments.Status::Posted;
                Rec."Posted By" := UserId;
                Rec."Date Posted" := Today;
                Rec."Time Posted" := Time;
                Rec.Modify;

                //Post Reversal Entries for Commitments
                Doc_Type := Doc_Type::"Payment Voucher";
                CheckBudgetAvail.ReverseEntries(Doc_Type, Rec."No.");
            end;
        end;
    end;

    procedure PostHeaderx(var Payment: Record "Payments Header")
    begin

        if (Payments."Pay Mode" = Payments."Pay Mode"::Cheque) and (Rec."Cheque Type" = Rec."Cheque Type"::" ") then
            Error('Cheque type has to be specified');

        if Payments."Pay Mode" = Payments."Pay Mode"::Cheque then begin
            if (Payments."Cheque No." = '') and (Rec."Cheque Type" = Rec."Cheque Type"::"Manual Check") then begin
                Error('Please ensure that the cheque number is inserted');
            end;
        end;

        if Payments."Pay Mode" = Payments."Pay Mode"::EFT then begin
            if Payments."Cheque No." = '' then begin
                Error('Please ensure that the EFT number is inserted');
            end;
        end;

        if Payments."Pay Mode" = Payments."Pay Mode"::"Account Transfer" then begin
            if Payments."Cheque No." = '' then begin
                Error('Please ensure that the Letter of Credit ref no. is entered.');
            end;
        end;
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);

        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;


        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Payment."Payment Release Date";
        /*IF CustomerPayLinesExist THEN
         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
        ELSE
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment; */
        GenJnlLine."Document No." := Payments."No.";
        GenJnlLine."External Document No." := Payments."Cheque No.";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := Payments."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        GenJnlLine."Currency Code" := Payments."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        //CurrFactor
        //GenJnlLine."Currency Factor" := Payments."Currency Factor";
        // GenJnlLine.Validate("Currency Factor");

        Payments.CalcFields(Payments."Total Net Amount", Payments."Total VAT Amount");
        GenJnlLine.Amount := -(Payments."Total Net Amount");
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';

        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        GenJnlLine.Description := CopyStr('Pay To:' + Payments.Payee, 1, 50);
        GenJnlLine.Validate(GenJnlLine.Description);

        if Rec."Pay Mode" <> Rec."Pay Mode"::Cheque then begin
            GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" "
        end else begin
            if Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check" then
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check"
            else
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" "

        end;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        //Post Other Payment Journal Entries

        PostPV(Payments);

    end;

    procedure GetAppliedEntries(var LineNo: Integer) InvText: Text[100]
    var
        Appl: Record "CshMgt Application";
    begin

        InvText := '';
        Appl.Reset;
        Appl.SetRange(Appl."Document Type", Appl."Document Type"::PV);
        Appl.SetRange(Appl."Document No.", Rec."No.");
        Appl.SetRange(Appl."Line No.", LineNo);
        if Appl.FindFirst then begin
            repeat
                InvText := CopyStr(InvText + ',' + Appl."Appl. Doc. No", 1, 50);
            until Appl.Next = 0;
        end;
    end;

    procedure InsertApproval()
    var
        Appl: Record "CshMgt Approvals";
        LineNo: Integer;
    begin
        LineNo := 0;
        Appl.Reset;
        if Appl.FindLast then begin
            LineNo := Appl."Line No.";
        end;

        LineNo := LineNo + 1;

        Appl.Reset;
        Appl.Init;
        Appl."Line No." := LineNo;
        Appl."Document Type" := Appl."Document Type"::PV;
        Appl."Document No." := Rec."No.";
        Appl."Document Date" := Rec.Date;
        Appl."Process Date" := Today;
        Appl."Process Time" := Time;
        Appl."Process User ID" := UserId;
        Appl."Process Name" := Rec."Current Status";
        //Appl."Process Machine":=ENVIRON('COMPUTERNAME');
        Appl.Insert;
    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCSetup: Record "Budgetary Control Setup";
    begin
        if BCSetup.Get() then begin
            if not BCSetup.Mandatory then begin
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

    procedure CheckPVRequiredItems(rec: Record "Payments Header")
    begin
        if Rec.Posted then begin
            Error('The Document has already been posted');
        end;

        Rec.TestField(Status, Rec.Status::Approved);
        Rec.TestField("Paying Bank Account");
        Rec.TestField("Pay Mode");
        Rec.TestField("Payment Release Date");
        //Confirm whether Bank Has the Cash
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
         CheckBudgetAvail.CheckFundsAvailability(Rec);*/

        //Confirm Payment Release Date is today);
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
          TESTFIELD("Payment Release Date",WORKDATE);*/

        /*Check if the user has selected all the relevant fields*/
        Temp.Get(UserId);

        JTemplate := Temp."Payment Journal Template";
        JBatch := Temp."Payment Journal Batch";

        if JTemplate = '' then begin
            Error('Ensure the PV Template is set up in Cash Office Setup');
        end;
        if JBatch = '' then begin
            Error('Ensure the PV Batch is set up in the Cash Office Setup')
        end;
        if (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) and (Rec."Cheque No." = '') then
            Error('Kindly specify the Cheque No');
        if (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) and (Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check") then begin
            if not Confirm(Text002, false) then
                Error('You have selected to Abort PV Posting');
        end;
        //Check whether there is any printed cheques and lines not posted
        CheckLedger.Reset;
        CheckLedger.SetRange(CheckLedger."Document No.", Rec."No.");
        CheckLedger.SetRange(CheckLedger."Entry Status", CheckLedger."Entry Status"::Printed);
        if CheckLedger.Find('-') then begin
            //Ask whether to void the printed cheque
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.FindFirst;
            if Confirm(Text000, false, CheckLedger."Check No.") then
                CheckManagement.VoidCheck(GenJnlLine)
            else
                Error(Text001, Rec."No.", CheckLedger."Check No.");
        end;

    end;

    procedure PostPVx(var Payment: Record "Payments Header")
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Payments."No.");
        if PayLine.Find('-') then begin

            repeat
                strText := GetAppliedEntries(PayLine."Line No.");
                Payment.TestField(Payment.Payee);
                PayLine.TestField(PayLine.Amount);
                // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

                //BANK
                if PayLine."Pay Mode" = PayLine."Pay Mode"::Cash then begin
                    CashierLinks.Reset;
                    CashierLinks.SetRange(CashierLinks.UserID, UserId);
                end;

                //CHEQUE
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document No." := PayLine.No;
                /*IF PayLine."Account Type"=PayLine."Account Type"::Customer THEN
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                ELSE
                  GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;*/
                //GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine.Description := CopyStr(PayLine."Transaction Name" + ':' + Payment.Payee, 1, 50);
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate("Currency Code");
                // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                // GenJnlLine.Validate("Currency Factor");
                if PayLine."VAT Code" = '' then begin
                    GenJnlLine.Amount := PayLine."Net Amount";
                end
                else begin
                    GenJnlLine.Amount := PayLine."Net Amount";
                end;
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."VAT Prod. Posting Group" := PayLine."VAT Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Applies-to Doc. No.";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";
                //JEFF
                if PayLine."Account Type" = PayLine."Account Type"::"Fixed Asset" then begin
                    GenJnlLine."FA Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost"
                end;
                //JEFF

                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                /*
                //Post VAT to GL[VAT GL]
                TarriffCodes.RESET;
                TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."VAT Code");
                IF TarriffCodes.FIND('-') THEN BEGIN
                TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                LineNo:=LineNo+1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":=JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name":=JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code":='PAYMENTJNL';
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Posting Date":=Payment."Payment Release Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PayLine.No;
                GenJnlLine."External Document No.":=Payments."Cheque No.";
                GenJnlLine."Account Type":=TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No.":=TarriffCodes."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code":=Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor":=Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");

                GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount:=-PayLine."VAT Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No.":='';
                GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50);
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

                IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
                END;
                 */
                //POST W/TAX to Respective W/TAX GL Account
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Withholding Tax Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    // GenJnlLine."Account Type" := TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    // GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."Withholding Tax Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := CopyStr('W/Tax:' + Format(PayLine."Account Name") + '::' + strText, 1, 50);
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;
                end;


                //POST P.A.Y.E to Respective P.A.Y.E GL Account
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."PAYE Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    // GenJnlLine."Account Type" := TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    // GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."PAYE Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := CopyStr('P.A.Y.E:' + Format(PayLine."Account Name") + '::' + strText, 1, 50);
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;
                end;

                /*
                //Post VAT Balancing Entry Goes to Vendor
                LineNo:=LineNo+1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":=JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name":=JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code":='PAYMENTJNL';
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Posting Date":=Payment."Payment Release Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PayLine.No;
                GenJnlLine."External Document No.":=Payments."Cheque No.";
                GenJnlLine."Account Type":=PayLine."Account Type";
                GenJnlLine."Account No.":=PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code":=Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor":=Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");

                IF PayLine."VAT Code"='' THEN
                  BEGIN
                    GenJnlLine.Amount:=0;
                  END
                ELSE
                  BEGIN
                    GenJnlLine.Amount:=PayLine."VAT Amount";
                  END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No.":='';
                GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50) ;
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
                IF GenJnlLine.Amount<>0 THEN
                GenJnlLine.INSERT;
                 */
                //Post W/TAX Balancing Entry Goes to Vendor
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                //GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate(GenJnlLine."Currency Code");
                //CurrFactor
                // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                // GenJnlLine.Validate("Currency Factor");

                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount := PayLine."Withholding Tax Amount";
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := CopyStr(Payments.Payee, 1, 50);
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;


            until PayLine.Next = 0;

            Commit;
            //Post the Journal Lines
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.Run(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances


            //Before posting if paymode is cheque print the cheque
            if (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) and (Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check") then begin
                DocPrint.PrintCheck(GenJnlLine);
                CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance", GenJnlLine);
                //Confirm Cheque printed //Not necessary.
            end;

            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            Post := false;
            Post := JournlPosted.PostedSuccessfully(Rec."No.");
            if Post then begin
                if PayLine.FindFirst then begin
                    repeat
                        PayLine."Date Posted" := Today;
                        PayLine."Time Posted" := Time;
                        PayLine."Posted By" := UserId;
                        PayLine.Status := PayLine.Status::Posted;
                        PayLine.Modify;
                    until PayLine.Next = 0;
                end;
            end;

        end;

    end;

    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::Approved then begin
            "Payment Release DateEditable" := false;
            PayingBankAccountEditable := false;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrForm."Pay Mode".EDITABLE:=FALSE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Currency CodeEditable" := false;
            "Cheque No.Editable" := false;
            "Cheque TypeEditable" := false;
            PaymodeEditable := false;
            "Invoice Currency CodeEditable" := true;
        end else begin
            "Payment Release DateEditable" := true;
            PaymodeEditable := true;
            PayingBankAccountEditable := true;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrForm."Pay Mode".EDITABLE:=TRUE;
            if Rec."Pay Mode" = Rec."Pay Mode"::Cheque then
                "Cheque TypeEditable" := true;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            if Rec."Cheque Type" <> Rec."Cheque Type"::"Computer Check" then
                "Cheque No.Editable" := true;
            "Invoice Currency CodeEditable" := false;


        end;


        if Rec.Status = Rec.Status::Pending then begin
            "Currency CodeEditable" := false;
            GlobalDimension1CodeEditable := true;
            "Payment NarrationEditable" := true;
            ShortcutDimension2CodeEditable := true;
            PayeeEditable := true;
            ShortcutDimension3CodeEditable := true;
            ShortcutDimension4CodeEditable := true;
            DateEditable := true;
            PVLinesEditable := true;


        end else begin
            "Currency CodeEditable" := false;
            GlobalDimension1CodeEditable := false;
            "Payment NarrationEditable" := false;
            ShortcutDimension2CodeEditable := false;
            PayeeEditable := false;
            ShortcutDimension3CodeEditable := false;
            ShortcutDimension4CodeEditable := false;
            DateEditable := false;
            PVLinesEditable := false;



        end
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Payment Line";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure AllFieldsEnteredx(): Boolean
    var
        PayLines: Record "Payment Line";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No." = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    procedure CustomerPayLinesExist(): Boolean
    var
        PayLine: Record "Payment Line";
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");
        PayLine.SetRange(PayLine."Account Type", PayLine."Account Type"::Customer);
        exit(PayLine.FindFirst);
    end;

    procedure PopulateCheckJournal(var Payment: Record "Payments Header")
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");
        if PayLine.Find('-') then begin

            repeat
                //  strText:=GetAppliedEntries(PayLine."Line No.");
                Payment.TestField(Payment.Payee);
                PayLine.TestField(PayLine.Amount);
                // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

                //BANK
                if PayLine."Pay Mode" <> PayLine."Pay Mode"::Cheque then;

                //CHEQUE
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Rec."Payment Release Date";
                GenJnlLine."Document No." := PayLine.No;
                if PayLine."Account Type" = PayLine."Account Type"::Customer then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                else
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                //GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Rec."Cheque No.";

                GenJnlLine."Currency Code" := Rec."Currency Code";
                GenJnlLine.Validate("Currency Code");
                // GenJnlLine."Currency Factor" := "Currency Factor";
                // GenJnlLine.Validate("Currency Factor");
                if PayLine."VAT Code" = '' then begin
                    GenJnlLine.Amount := PayLine."Net Amount";
                end
                else begin
                    GenJnlLine.Amount := PayLine."Net Amount";
                end;
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."VAT Prod. Posting Group" := PayLine."VAT Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Applies-to Doc. No.";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";
                GenJnlLine.Description := Rec.Payee;
                ///GenJnlLine."Received By":=Payee;
                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;


            until PayLine.Next = 0;

        end;
    end;

    // local procedure OnAfterGetCurrRecord()
    // begin
    //     xRec := Rec;
    //     UpdateControls();
    // end;

    procedure PostPaymentVoucher(rec: Record "Payments Header")
    begin
        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;
        GenJnlLine.DeleteAll;
        GenJnlLine.Reset;

        Payments.Reset;
        Payments.SetRange(Payments."No.", Rec."No.");
        if Payments.Find('-') then begin
            PayLine.Reset;
            PayLine.SetRange(PayLine.No, Payments."No.");
            if PayLine.Find('-') then begin
                repeat
                    PostHeader(Payments);
                until PayLine.Next = 0;
            end;

            Post := false;
            Post := JournlPosted.PostedSuccessfully(Rec."No.");
            if Post then begin
                Rec.Posted := true;
                Rec.Status := Payments.Status::Posted;
                Rec."Posted By" := UserId;
                Rec."Date Posted" := Today;
                Rec."Time Posted" := Time;
                Rec.Modify;


                //Post Reversal Entries for Commitments
                Doc_Type := Doc_Type::"Payment Voucher";
                CheckBudgetAvail.ReverseEntries(Doc_Type, Rec."No.");

                if ImprestHeader.Get(Rec."Apply to Document No") then begin
                    ImprestHeader.Posted := true;
                    ImprestHeader."Date Posted" := Today;
                    ImprestHeader."Time Posted" := Time;
                    ImprestHeader."Posted By" := UserId;
                    ImprestHeader."Cheque No." := Rec."Cheque No.";
                    ImprestHeader.Status := ImprestHeader.Status::Posted;
                    ImprestHeader."Payment Voucher No" := Rec."No.";
                    ImprestHeader.Modify;
                end;
                if PVHead.Get(Rec."Apply to Document No") then begin
                    PVHead.Posted := true;
                    PVHead."Date Posted" := Today;
                    PVHead."Time Posted" := Time;
                    PVHead."Posted By" := UserId;
                    PVHead.Status := PVHead.Status::Posted;
                    PVHead.Modify;
                end;

            end;

        end;
    end;

    procedure PostHeader(var Payment: Record "Payments Header")
    begin

        //IF (Payments."Pay Mode"=Payments."Pay Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Computer Check") THEN
        //  ERROR('Cheque type has to be specified');
        /*
        IF Payments."Pay Mode"=Payments."Pay Mode"::Cheque THEN BEGIN
            IF (Payments."Cheque No."='') AND ("Cheque Type"="Cheque Type"::"2") THEN
              BEGIN
                ERROR('Please ensure that the cheque number is inserted');
              END;
        END;
        
        IF Payments."Pay Mode"=Payments."Pay Mode"::EFT THEN
          BEGIN
            IF Payments."Cheque No."='' THEN;
          END;
        
        IF Payments."Pay Mode"=Payments."Pay Mode"::"Account Transfer" THEN
          BEGIN
            IF Payments."Cheque No."='' THEN
              BEGIN
                ERROR('Please ensure that the Letter of Credit ref no. is entered.');
              END;
          END;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
        
          IF GenJnlLine.FIND('+') THEN
            BEGIN
              LineNo:=GenJnlLine."Line No."+1000;
            END
          ELSE
            BEGIN
              LineNo:=1000;
            END;
        
        
        LineNo:=LineNo+1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name":=JTemplate;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name":=JBatch;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No.":=LineNo;
        GenJnlLine."Source Code":='PAYMENTJNL';
        GenJnlLine."Posting Date":=Payment."Payment Release Date";
        IF CustomerPayLinesExist THEN
         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
        ELSE
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No.":=Payments."No.";
        GenJnlLine."External Document No.":=Payments."Cheque No.";
        
        GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No.":=Payments."Paying Bank Account";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        
        GenJnlLine."Currency Code":=Payments."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        Payments.CALCFIELDS(Payments."Total Net Amount");
        GenJnlLine.Amount:=-(Payments."Total Net Amount" );
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No.":='';
        
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
        
        GenJnlLine.Description:=COPYSTR('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        
        IF "Pay Mode"<>"Pay Mode"::Cheque THEN  BEGIN
        GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
        END ELSE BEGIN
        IF "Cheque Type"="Cheque Type"::"Manual Check" THEN
         GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::"Computer Check"
        ELSE
           GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
        
        END;
        IF GenJnlLine.Amount<>0 THEN
        GenJnlLine.INSERT;
        
        //Post Other Payment Journal Entries
        PostPV(Payments);
        */ /////////////////////////////////////////////////// From John

        if (Payments."Pay Mode" = Payments."Pay Mode"::Cheque) and (Rec."Cheque Type" = Rec."Cheque Type"::" ") then
            Error('Cheque type has to be specified');

        if Payments."Pay Mode" = Payments."Pay Mode"::Cheque then begin
            if (Payments."Cheque No." = '') and (Rec."Cheque Type" = Rec."Cheque Type"::"Manual Check") then begin
                Error('Please ensure that the cheque number is inserted');
            end;
        end;

        if Payments."Pay Mode" = Payments."Pay Mode"::EFT then begin
            if Payments."Cheque No." = '' then begin
                Error('Please ensure that the EFT number is inserted');
            end;
        end;

        if Payments."Pay Mode" = Payments."Pay Mode"::"Account Transfer" then begin
            if Payments."Cheque No." = '' then begin
                Error('Please ensure that the Letter of Credit ref no. is entered.');
            end;
        end;
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);

        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;


        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Payment."Payment Release Date";
        if CustomerPayLinesExist then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Payments."No.";
        GenJnlLine."External Document No." := Payments."Cheque No.";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := Payments."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        GenJnlLine."Currency Code" := Payments."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        //CurrFactor
        // GenJnlLine."Currency Factor" := Payments."Currency Factor";
        // GenJnlLine.Validate("Currency Factor");

        Payments.CalcFields(Payments."Total Net Amount", Payments."Total VAT Amount");
        GenJnlLine.Amount := -(Payments."Total Net Amount");
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';

        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

        GenJnlLine.Description := CopyStr(Rec."Payment Narration", 1, 50);//COPYSTR('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.Validate(GenJnlLine.Description);

        if Rec."Pay Mode" <> Rec."Pay Mode"::Cheque then begin
            GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" "
        end else begin
            if Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check" then
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check"
            else
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" "

        end;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        //Post Other Payment Journal Entries
        PostPV(Payments);

    end;

    procedure PostPV(var Payment: Record "Payments Header")
    begin
        /*
       PayLine.RESET;
       PayLine.SETRANGE(PayLine.No,Payments."No.");
       IF PayLine.FIND('-') THEN BEGIN

       REPEAT
           strText:=GetAppliedEntries(PayLine."Line No.");
           Payment.TESTFIELD(Payment.Payee);
           PayLine.TESTFIELD(PayLine.Amount);
           PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

           //BANK
           IF PayLine."Pay Mode"=PayLine."Pay Mode"::Cash THEN BEGIN
             CashierLinks.RESET;
             CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
           END;

           //CHEQUE
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document No.":=PayLine.No;
           IF PayLine."Account Type"=PayLine."Account Type"::Customer THEN
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
           ELSE
             GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Account Type":=PayLine."Account Type";
           GenJnlLine."Account No.":=PayLine."Account No.";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine.Description:=COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
           GenJnlLine.Payee:=Payment.Payee;
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE("Currency Code");
           GenJnlLine."Currency Factor":=Payments."Currency Factor";
           GenJnlLine.VALIDATE("Currency Factor");
           IF PayLine."VAT Code"='' THEN
             BEGIN
               GenJnlLine.Amount:=PayLine."Net Amount" ;
             END
           ELSE
             BEGIN
               GenJnlLine.Amount:=PayLine."Net Amount";
             END;
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."VAT Prod. Posting Group":=PayLine."VAT Prod. Posting Group";
           GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
           //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
           GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
           GenJnlLine."Applies-to Doc. No.":=PayLine."Applies-to Doc. No.";
           GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
           GenJnlLine."Applies-to ID":=PayLine."Applies-to ID";

           IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;

           //Post VAT to GL[VAT GL]
           TarriffCodes.RESET;
           TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."VAT Code");
           IF TarriffCodes.FIND('-') THEN BEGIN
           //TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Document No.":=PayLine.No;
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
           GenJnlLine."Account No.":=TarriffCodes."G/L Account";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
           GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
           GenJnlLine."Gen. Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
           GenJnlLine."Gen. Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
           GenJnlLine."VAT Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
           GenJnlLine."VAT Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
           GenJnlLine.Amount:=-PayLine."VAT Amount";
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
           GenJnlLine."Bal. Account No.":='';
           GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50);
           GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

           IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
           END;

           //POST W/TAX to Respective W/TAX GL Account
           TarriffCodes.RESET;
           TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."Withholding Tax Code");
           IF TarriffCodes.FIND('-') THEN BEGIN
           //TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Document No.":=PayLine.No;
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
           GenJnlLine."Account No.":=TarriffCodes."G/L Account";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
           GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
           GenJnlLine."Gen. Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
           GenJnlLine."Gen. Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
           GenJnlLine."VAT Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
           GenJnlLine."VAT Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
           GenJnlLine.Amount:=-PayLine."Withholding Tax Amount";
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
           GenJnlLine."Bal. Account No.":='';
           GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine.Description:=COPYSTR('W/Tax:' + FORMAT(PayLine."Account Name") +'::' + strText,1,50);
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

           IF GenJnlLine.Amount<>0 THEN
           GenJnlLine.INSERT;
           END;
           //POST Retention GL Account
           if PayLine."Retention  Amount"<>0 then begin
           TarriffCodes.RESET;
           TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."Retention Code");
           IF TarriffCodes.FIND('-') THEN BEGIN
           TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Document No.":=PayLine.No;
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
           GenJnlLine."Account No.":=TarriffCodes."G/L Account";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
           GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
           GenJnlLine."Gen. Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
           GenJnlLine."Gen. Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
           GenJnlLine."VAT Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
           GenJnlLine."VAT Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
           GenJnlLine.Amount:=-PayLine."Retention  Amount";
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
           GenJnlLine."Bal. Account No.":='';
           GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine.Description:=COPYSTR('Retention:' + FORMAT(PayLine."Account Name") +'::' + strText,1,50);
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

           IF GenJnlLine.Amount<>0 THEN
           GenJnlLine.INSERT;
           END;
           end;
           //Post PAYE to GL[PAYE GL] -----JOSEH
           TarriffCodes.RESET;
           TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."PAYE Code");
           IF TarriffCodes.FIND('-') THEN BEGIN
           //TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Document No.":=PayLine.No;
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
           GenJnlLine."Account No.":=TarriffCodes."G/L Account";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
           GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
           GenJnlLine."Gen. Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
           GenJnlLine."Gen. Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
           GenJnlLine."VAT Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
           GenJnlLine."VAT Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
           GenJnlLine.Amount:=-PayLine."PAYE Amount";
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
           GenJnlLine."Bal. Account No.":='';
           GenJnlLine.Description:=COPYSTR('PAYE:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50);
           GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

           IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
           END;


           //Post VAT Balancing Entry Goes to Vendor
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Document No.":=PayLine.No;
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine."Account Type":=PayLine."Account Type";
           GenJnlLine."Account No.":=PayLine."Account No.";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
           IF PayLine."VAT Code"='' THEN
             BEGIN
               GenJnlLine.Amount:=0;
             END
           ELSE
             BEGIN
               GenJnlLine.Amount:=PayLine."VAT Amount";
             END;
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
           GenJnlLine."Bal. Account No.":='';
           GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50) ;
           GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
           GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
           GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
           GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
           GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
           IF GenJnlLine.Amount<>0 THEN
           GenJnlLine.INSERT;

           //Post W/TAX Balancing Entry Goes to Vendor
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Document No.":=PayLine.No;
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine."Account Type":=PayLine."Account Type";
           GenJnlLine."Account No.":=PayLine."Account No.";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
           GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
           GenJnlLine."Gen. Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
           GenJnlLine."Gen. Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
           GenJnlLine."VAT Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
           GenJnlLine."VAT Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
           GenJnlLine.Amount:=PayLine."Withholding Tax Amount";
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
           GenJnlLine."Bal. Account No.":='';
           GenJnlLine.Description:=COPYSTR('W/Tax:' + strText ,1,50);
           GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
           GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
           GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
           GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
           GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
           IF GenJnlLine.Amount<>0 THEN
           GenJnlLine.INSERT;


           //EFT
           IF Payments."Pay Mode"=Payments."Pay Mode"::EFT THEN BEGIN
           IF PayLine."Account No."<>'' THEN BEGIN
           BankPayment.RESET;
           BankPayment.SETRANGE(BankPayment."Doc No","No.");
           IF BankPayment.FIND('-') THEN BankPayment.DELETE;
           PayLine.TESTFIELD(PayLine."Vendor Bank Account");
           BankPayment.INIT;
           BankPayment."Doc No":=Rec."No.";
           BankPayment.Payee:=PayLine."Account No.";
           BankPayment.Amount:="Total Payment Amount"-("Total Witholding Tax Amount"+"Total Retention Amount"+"Total VAT Amount");
           BankPayment."Bank A/C No":=PayLine."Vendor Bank Account";
           VBank.RESET;
           VBank.SETRANGE(VBank."Vendor No.",PayLine."Account No.");
           VBank.SETRANGE(VBank.Code,PayLine."Vendor Bank Account");
           IF VBank.FIND('-') THEN BEGIN
           VBank.TESTFIELD(VBank."Bank Branch No.");
           VBank.TESTFIELD(VBank."Bank Account No.");
           BankPayment."Bank A/C No":=FORMAT(VBank."Bank Account No.");
           BankPayment."Bank Branch No":=FORMAT(VBank."Bank Branch No.");
           BankPayment."Bank Code":=FORMAT(VBank.Code);
           BankPayment."Bank A/C Name":=VBank.Name
           END;
           BankPayment.Date:=TODAY;
           BankPayment.INSERT;
           END;
           END;

           //Post PAYE Balancing Entry Goes to Vendor(Lecturer)----JLL
           LineNo:=LineNo+1000;
           GenJnlLine.INIT;
           GenJnlLine."Journal Template Name":=JTemplate;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
           GenJnlLine."Journal Batch Name":=JBatch;
           GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
           GenJnlLine."Source Code":='PAYMENTJNL';
           GenJnlLine."Line No.":=LineNo;
           GenJnlLine."Posting Date":=Payment."Payment Release Date";
           GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
           GenJnlLine."Document No.":=PayLine.No;
           GenJnlLine."External Document No.":=Payments."Cheque No.";
           GenJnlLine."Account Type":=PayLine."Account Type";
           GenJnlLine."Account No.":=PayLine."Account No.";
           GenJnlLine.VALIDATE(GenJnlLine."Account No.");
           GenJnlLine."Currency Code":=Payments."Currency Code";
           GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
           GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
           GenJnlLine."Gen. Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
           GenJnlLine."Gen. Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
           GenJnlLine."VAT Bus. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
           GenJnlLine."VAT Prod. Posting Group":='';
           GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
           GenJnlLine.Amount:=PayLine."PAYE Amount";
           GenJnlLine.VALIDATE(GenJnlLine.Amount);
           GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
           GenJnlLine."Bal. Account No.":='';
           GenJnlLine.Description:=COPYSTR('PAYE:' + strText ,1,50);
           GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
           GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
           GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
           GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
           GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
           GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
           GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
           GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
           GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
           IF GenJnlLine.Amount<>0 THEN
           GenJnlLine.INSERT;


       UNTIL PayLine.NEXT=0;

       COMMIT;
       //Post the Journal Lines
       GenJnlLine.RESET;
       GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
       GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
       //Adjust Gen Jnl Exchange Rate Rounding Balances
          AdjustGenJnl.RUN(GenJnlLine);
       //End Adjust Gen Jnl Exchange Rate Rounding Balances


       //Before posting if paymode is cheque print the cheque
       IF ("Pay Mode"="Pay Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Manual Check") THEN BEGIN
       //DocPrint.PrintCheck(GenJnlLine);
       //CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance",GenJnlLine);
       //Confirm Cheque printed //Not necessary.
       END;


       //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);

       Post:=FALSE;
       Post:=JournlPosted.PostedSuccessfully();
       IF Post THEN
         BEGIN
           IF PayLine.FINDFIRST THEN
             BEGIN
               REPEAT
                 PayLine."Date Posted":=TODAY;
                 PayLine."Time Posted":=TIME;
                 PayLine."Posted By":=USERID;
                 PayLine.Status:=PayLine.Status::Posted;
                 PayLine.MODIFY;
              UNTIL PayLine.NEXT=0;
            END;
         END;

       END;

       IF PayLine."Document Type"=PayLine."Document Type"::Imprest
       THEN BEGIN
       ImprestHeader.RESET;
       ImprestHeader.SETRANGE(ImprestHeader."No.",PayLine."Document No");
       IF ImprestHeader.FIND('-') THEN BEGIN
       ImprestHeader."Payment Voucher No":=PayLine.No;
       ImprestHeader.Posted:=TRUE;
       ImprestHeader."Date Posted":=TODAY;
       ImprestHeader."Time Posted":=TIME;
       ImprestHeader."Posted By":=USERID;
       ImprestHeader.MODIFY;
       END;
       END;

       IF PayLine."Document Type"=PayLine."Document Type"::Claim
       THEN BEGIN
       Payments.RESET;
       Payments.SETRANGE(Payments."No.",PayLine."Document No");
       IF Payments.FIND('-') THEN BEGIN
       Payments.Posted:=TRUE;
       Payments."Date Posted":=TODAY;
       Payments."Time Posted":=TIME;
       Payments."Posted By":=USERID;
       Payments.MODIFY;
       END;
       END;


       */ ///////////////////////////////////////////////////// From JM
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Payments."No.");
        if PayLine.Find('-') then begin

            repeat
                strText := GetAppliedEntries(PayLine."Line No.");
                Payment.TestField(Payment.Payee);
                PayLine.TestField(PayLine.Amount);
                if PayLine."PAYE Amount" > 0 then PayLine.TestField(PayLine."KRA Pin No.");//dennos please return

                // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

                //BANK
                if PayLine."Pay Mode" = PayLine."Pay Mode"::Cash then begin
                    CashierLinks.Reset;
                    CashierLinks.SetRange(CashierLinks.UserID, UserId);
                end;

                //CHEQUE
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document No." := PayLine.No;
                if CustomerPayLinesExist then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                else
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                //GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine.Description := CopyStr(Rec."Payment Narration", 1, 50);
                //    GenJnlLine.Description:=COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate("Currency Code");
                // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                // GenJnlLine.Validate("Currency Factor");
                if PayLine."VAT Code" = '' then begin
                    GenJnlLine.Amount := PayLine."Net Amount";
                end
                else begin
                    GenJnlLine.Amount := PayLine.Amount;
                end;
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."VAT Prod. Posting Group" := PayLine."VAT Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Applies-to Doc. No.";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";

                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;

                //Post RETENTION to GL[RETENTION GL]
                if PayLine."Retention Code" <> '' then begin

                    TarriffCodes.Reset;
                    TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Retention Code");
                    if TarriffCodes.Find('-') then begin
                        TarriffCodes.TestField(TarriffCodes."G/L Account");
                        LineNo := LineNo + 1000;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Payment."Payment Release Date";
                        if CustomerPayLinesExist then
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                        else
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No." := PayLine.No;
                        GenJnlLine."External Document No." := Payments."Cheque No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Account No." := TarriffCodes."G/L Account";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := Payments."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        //CurrFactor
                        //  GenJnlLine."Currency Factor" := Payments."Currency Factor";
                        //  GenJnlLine.Validate("Currency Factor");

                        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := -PayLine."Retention  Amount";
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Description := CopyStr('RETENTION:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                        if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                    end;

                    // Retention to balancing
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    if CustomerPayLinesExist then
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                    else
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    //GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine."Account No." := PayLine."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    // GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := PayLine."Retention  Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('RETENTION:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;


                end;


                ///////////////Post VAT WITHHELD////////////////////////////////////////////////////

                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Withholding Tax Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := TarriffCodes."Account Type";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."VAT Withheld Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('VAT WITHHELD:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                end;

                ////////////////////////////END VAT WITHHELD to GL//////////////////////////////////////////////
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."VAT Code");
                if TarriffCodes.Find('-') then begin
                    // TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    //GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    //GenJnlLine."Bal. Account Type":=GenJnlLine."Account Type"::Vendor;
                    //GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine."Account No." := PayLine."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    //GenJnlLine."Account No.":=TarriffCodes."G/L Account";
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := PayLine."VAT Withheld Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('VAT WITHHELD:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    // IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
                end;

                ////////////////////END BALANCING VAT WITHHELD/////////////////////////////////////////////////////////////


                //POST W/TAX to Respective W/TAX GL Account
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Withholding Tax Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    if CustomerPayLinesExist then
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                    else
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := TarriffCodes."Account Type";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    //GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    // GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."Withholding Tax Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := CopyStr('W/Tax:' + Format(PayLine."Account Name") + '::' + strText, 1, 50);
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;
                end;


                ///////////////Post P.A.Y.E////////////////////////////////////////////////////

                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."PAYE Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := TarriffCodes."Account Type";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."PAYE Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('p.a.y.e:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                end;

                //Post VAT Balancing Entry Goes to Vendor
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                if CustomerPayLinesExist then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                else
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                //GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate(GenJnlLine."Currency Code");
                //CurrFactor
                // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                // GenJnlLine.Validate("Currency Factor");

                if PayLine."VAT Code" = '' then begin
                    GenJnlLine.Amount := 0;
                end
                else begin
                    GenJnlLine.Amount := PayLine."VAT Amount";
                end;
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := CopyStr('VAT:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                if GenJnlLine.Amount <> 0 then
                    //  GenJnlLine.INSERT;


                    /*
                        //Post W/TAX Balancing Entry Goes to Vendor
                        LineNo:=LineNo+1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":=JTemplate;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":=JBatch;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Source Code":='PAYMENTJNL';
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Posting Date":=Payment."Payment Release Date";
                        IF CustomerPayLinesExist THEN
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        ELSE
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No.":=PayLine.No;
                        GenJnlLine."External Document No.":=Payments."Cheque No.";
                        GenJnlLine."Account Type":=PayLine."Account Type";
                        GenJnlLine."Account No.":=PayLine."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=Payments."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        //CurrFactor
                        GenJnlLine."Currency Factor":=Payments."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");

                        GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount:=PayLine."Withholding Tax Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.Description:=COPYSTR('W/Tax:' + strText ,1,50);
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
                        GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
                        IF GenJnlLine.Amount<>0 THEN
                        GenJnlLine.INSERT;
                        */
                    //Post P.A.YE Balancing Entry Goes to Vendor
                    LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                if CustomerPayLinesExist then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                else
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                //GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate(GenJnlLine."Currency Code");
                //CurrFactor
                // GenJnlLine."Currency Factor" := Payments."Currency Factor";
                // GenJnlLine.Validate("Currency Factor");

                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount := PayLine."PAYE Amount";
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := CopyStr('PAYE:' + strText, 1, 50);
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;


            until PayLine.Next = 0;

            Commit;



            //Post the Journal Lines
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.Run(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances


            //Before posting if paymode is cheque print the cheque
            if (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) and (Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check") then begin
                DocPrint.PrintCheck(GenJnlLine);
                //CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance",GenJnlLine);
                //Confirm Cheque printed //Not necessary.
            end;

            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

            Post := false;
            Post := JournlPosted.PostedSuccessfully(Rec."No.");
            if Post then begin
                if PayLine.FindFirst then begin
                    repeat
                        PayLine."Date Posted" := Today;
                        PayLine."Time Posted" := Time;
                        PayLine."Posted By" := UserId;
                        PayLine.Status := PayLine.Status::Posted;
                        PayLine.Modify;
                    until PayLine.Next = 0;
                end;

                //update creation doc as posted
                /* IF StaffClaim.GET("Creation Doc No.") THEN
                    BEGIN
                      StaffClaim."Date Posted":=TODAY;
                      StaffClaim."Time Posted":=TIME;
                      StaffClaim."Posted By":=USERID;
                      StaffClaim.Status:=Status::Posted;
                      StaffClaim.Posted:=TRUE;
                      StaffClaim.MODIFY;
                    END;
                  IF AdvanceHeader.GET("Creation Doc No.") THEN
                    BEGIN
                      AdvanceHeader."Date Posted":=TODAY;
                      AdvanceHeader."Time Posted":=TIME;
                      AdvanceHeader."Posted By":=USERID;
                      AdvanceHeader.Status:=Status::Posted;
                      AdvanceHeader.Posted:=TRUE;
                      AdvanceHeader.MODIFY;
                    END;
                  IF PayReqHeader.GET("Creation Doc No.") THEN
                    BEGIN
                      PayReqHeader."Date Posted":=TODAY;
                      PayReqHeader."Time Posted":=TIME;
                      PayReqHeader."Posted By":=USERID;
                      PayReqHeader.Status:=Status::Posted;
                      PayReqHeader.Posted:=TRUE;
                      PayReqHeader.MODIFY;
                    END;
                    */
            end;



        end;

    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Payment Line";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No." = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;
}

