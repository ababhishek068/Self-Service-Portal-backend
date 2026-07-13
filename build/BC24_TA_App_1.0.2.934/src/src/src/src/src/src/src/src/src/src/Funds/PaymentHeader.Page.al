page 51381 "Payment Header"
{
    Caption = 'Payment Voucher';
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = "Payments Header";
    UsageCategory = Documents;
    ApplicationArea = Basic;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    Editable = DateEditable;
                    Importance = Promoted;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    //  Caption = 'Direc';
                    Editable = GlobalDimension1CodeEditable;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    // Caption = 'Campus Description';
                    Caption = '                ';
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {

                    Editable = ShortcutDimension2CodeEditable;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Caption = '                ';

                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension2CodeEditable;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    //  Caption = 'School Code';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    Caption = '                ';
                    // Caption = 'School Name';
                    Editable = ShortcutDimension2CodeEditable;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    //  Visible = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                    // Caption = 'School Code';
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    //  Visible = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                    // Caption = 'School Code';
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension2CodeEditable;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';

                    trigger OnValidate()
                    begin
                        if Rec.Status <> Rec.Status::Approved then
                            PayingBankAccountEditable := false;
                    end;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    //  Editable = PaymodeEditable;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }

                field("Cheque Type"; Rec."Cheque Type")
                {
                    //  Editable = "Cheque TypeEditable";
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Type field.';

                    trigger OnValidate()
                    begin
                        if Rec."Cheque Type" = Rec."Cheque Type"::"Manual Check" then
                            "Cheque No.Editable" := false
                        else
                            "Cheque No.Editable" := true;
                    end;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque/EFT No. field.';
                }

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }

                field("Negotiated Exchange Rate"; Rec."Negotiated Exchange Rate")
                {
                    //  Editable = "Currency CodeEditable";
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Negotiated Exchange Rate field.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    //  Editable = "Currency CodeEditable";
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';

                }

                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    //  Editable = "Payment Release DateEditable";
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field(Payee; Rec.Payee)
                {
                    Caption = 'Payment to';
                    Importance = Promoted;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment to field.';
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension2CodeEditable;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field("Payment Narration"; Rec."Payment Narration")
                {
                    Editable = "Payment NarrationEditable";
                    Importance = Promoted;
                    MultiLine = true;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Narration field.';
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    Editable = "Invoice Currency CodeEditable";
                    Visible = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Currency Code field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Caption = 'Prepared By';
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field(Status; Rec.Status)
                {
                    // Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Total Payment Amount"; Rec."Total Payment Amount")
                {
                    Importance = Additional;
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Payment Amount field.';
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    Importance = Additional;
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total VAT Amount field.';
                }
                field("Total Witholding Tax Amount"; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Witholding Tax Amount field.';
                }
                field("Total Retention Amount"; Rec."Total Retention Amount")
                {
                    Importance = Additional;
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Retention Amount field.';
                }
                field("Total VAT Withholding Amount"; Rec."Total VAT Withholding Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total VAT Withholding Amount field.';
                }
                field("Total PAYE Amount"; Rec."Total PAYE Amount")
                {
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total PAYE Amount field.';
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    Caption = 'Total Net Amount';
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field("Total Payment Amount LCY"; Rec."Total Payment Amount LCY")
                {
                    Caption = 'Total Net Amount LCY';
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount LCY field.';
                }

                field("Bank Criteria"; Rec."Bank Criteria")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Criteria field.';
                }
                field("Final Approver Status"; Rec."Final Approver Status")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Approver Status field.';
                }
                field("Final Approver Seq No"; Rec."Final Approver Seq No")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Approver Seq No field.';
                }



            }
            part(PVLines; "Payment Lines")
            {
                ApplicationArea = Basic;
                SubPageLink = No = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50887),
                              "No." = FIELD("No.");
            }
            part("Payments Application List"; "Payments Application List")
            {
                ApplicationArea = All;
                Caption = 'Applied Invoices';
                SubPageLink = No = field("No.");
            }

        }
    }

    actions
    {
        area(processing)
        {

            action(postPvs)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.CalcFields("Posted Count");
                    Rec.CalcFields("Reversed PV");
                    if (Rec."Posted Count" > 0) and (Rec."Reversed PV" = false) then begin// ERROR('Posted entries exists in the ledger for the selected document');
                        Rec.Posted := true;
                        Rec.Status := Rec.Status::Posted;
                        Rec."Posted By" := UserId;
                        Rec.Modify;
                    end else begin
                        //Post PV Entries
                        CurrPage.SaveRecord;
                        CheckPVRequiredItems(Rec);
                        PostPaymentVoucher(Rec);
                    end;
                end;
            }
        }
        area(Navigation)

        {
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


                    // ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);

                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                begin
                    if not LinesExists then
                        Error('There are no Lines created for this Document');
                    //IF NOT AllKeyFieldsEntered THEN
                    //   ERROR('There are missing key fields in the lines');
                    if not AllFieldsEntered then
                        Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                    Rec.TestField(Status, Rec.Status::Pending);
                    //Ensure No Items That should be committed that are not
                    if LinesCommitmentStatus then
                        Error('Please Check the Budget before you Proceed');

                    // Rec.TestField("Responsibility Center");
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
                ApplicationArea = Basic;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin
                    /*DocType:=DocType::"Payment Voucher";
                    showmessage:=TRUE;
                    ManualCancel:=TRUE;
                    CLEAR(tableNo);
                    tableNo:=DATABASE::"Payments Header";
                     IF ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) THEN;*/

                    Rec.TestField(Status, Rec.Status::"Pending Approval");
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                end;
            }
            separator(Separator40) { }
            action(CheckBudget)
            {
                Caption = 'Check Budgetary Availability';
                Image = Balance;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ApplicationArea = Basic;
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
                ApplicationArea = Basic;
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
        area(Reporting)
        {

            action(Print)
            {
                Caption = 'Print/Preview';
                Image = ConfirmAndPrint;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Payment Voucher New";
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Print/Preview action.';
                trigger OnAction()
                var
                    SRN: report "Payment Voucher New";
                    SRNRec: Record "Payment Line";
                begin
                    SRNRec.Reset;
                    SRNRec.SetFilter(SRNRec.No, Rec."No.");
                    if SRNRec.Find('-') then begin
                        SRN.SetTableView(SRNRec);
                        SRN.run();
                    end;
                    // REPORT.Run(70135450, true, true, SRNRec);
                end;

                /*   trigger OnAction()
                  var
                      PVReport: Report "Payment Voucher New";
                      PVLine: Record "Payment Line";
                      CashOffice: Record "Cash Office Setup";
                      ApprovalEntry: Record "Approval Entry";
                      PVReport3: Report "Payment Voucher New3";
                      PVReport4: Report "Payment Voucher New4";
                      PVReport6: Report "Payment Voucher New6";
                  begin

                      // if Status <> Status::Approved then
                      //     Error('You cannot Print until the document is released for approval');
                      CashOffice.Get();
                      if CashOffice."Multiple PV Layouts" = false then begin
                          PVLine.reset;
                          PVLine.setfilter(No, Rec."No.");
                          if PVLine.find('-') then begin
                              PVReport.SetTableView(PVLine);
                              PVReport.Run();
                          end;
                      end else begin
                          ApprovalEntry.Reset();
                          ApprovalEntry.SetRange(ApprovalEntry."Record ID to Approve", Rec.RecordId);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%1', 6);
                          if ApprovalEntry.Find('-') then begin
                              PVLine.reset;
                              PVLine.setfilter(No, Rec."No.");
                              if PVLine.find('-') then begin
                                  PVReport6.SetTableView(PVLine);
                                  PVReport6.Run();
                              end;
                          end;

                          ApprovalEntry.Reset();
                          ApprovalEntry.SetRange(ApprovalEntry."Record ID to Approve", Rec.RecordId);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%<>1', 6);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%<>1', 5);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%1', 4);
                          if ApprovalEntry.Find('-') then begin
                              PVLine.reset;
                              PVLine.setfilter(No, Rec."No.");
                              if PVLine.find('-') then begin
                                  PVReport4.SetTableView(PVLine);
                                  PVReport4.Run();
                              end;
                          end;

                          ApprovalEntry.Reset();
                          ApprovalEntry.SetRange(ApprovalEntry."Record ID to Approve", Rec.RecordId);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%<>1', 6);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%<>1', 5);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%<>1', 4);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%1', 3);
                          if ApprovalEntry.Find('-') then begin
                              PVLine.reset;
                              PVLine.setfilter(No, Rec."No.");
                              if PVLine.find('-') then begin
                                  PVReport3.SetTableView(PVLine);
                                  PVReport3.Run();
                              end;
                          end;

                          ApprovalEntry.Reset();
                          ApprovalEntry.SetRange(ApprovalEntry."Record ID to Approve", Rec.RecordId);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%<>1', 6);
                          ApprovalEntry.SetFilter(ApprovalEntry."Sequence No.", '%1', 5);
                          if ApprovalEntry.Find('-') then begin
                              PVLine.reset;
                              PVLine.setfilter(No, Rec."No.");
                              if PVLine.find('-') then begin
                                  PVReport.SetTableView(PVLine);
                                  PVReport.Run();
                              end;
                          end;

                      end;



                      CurrPage.Update;
                      CurrPage.SaveRecord;
                  end; */
            }
            action("Print HR PV")
            {
                Caption = 'Print Payment Voucher-HR';
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "HR Payment Voucher";
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Print/Preview action.';
                /*trigger OnAction()
                begin
                    Phead.reset;
                    Phead.setrange(Phead."No.", "No.");
                    if Phead.FindFirst() then begin
                        report.Run(50359, true, false, Phead);
                    end;
                end;
                */
            }
            action("Print Applied Invoice")
            {
                Image = PaymentHistory;
                ToolTip = 'Executes the Print Applied Invoice action.';


            }
            action(Bank_Letter)
            {
                Caption = 'Bank Letter';
                ToolTip = 'Executes the Bank Letter action.';

                trigger OnAction()
                var
                // FilterbyPayline: Record "Student Payment";
                begin
                    /*IF Status=Status::Pending THEN
                       ERROR('You cannot Print until the document is released for approval');
                    FilterbyPayline.RESET;
                    FilterbyPayline.SETFILTER(FilterbyPayline.No,"No.");
                    //REPORT.RUN(70134901,TRUE,TRUE,FilterbyPayline);
                    RESET;*/

                end;
            }
            separator(Separator34) { }
            action(CanelDoc)
            {
                Caption = 'Cancel Document';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = Basic;
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

            action(CopyDoc)
            {
                Caption = 'Copy Document';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Copy Document action.';

                trigger OnAction()
                var
                    Text000: Label 'Are you sure you want to copy this Document?';
                    Text001: Label 'You have selected not to copy the Document';

                    PLines: Record "Payment Line";
                    CurPLines: Record "Payment Line";
                    PHeader: Record "Payments Header";
                    noseries: Codeunit "No. Series";
                    newPVNo: Code[20];
                begin
                    //TestField(Status, Status::Approved);
                    if Confirm(Text000, true) then begin
                        //Post Reversal Entries for Commitments
                        //Copy PV Entries
                        newPVNo := noseries.GetNextNo('P/V', 0D, true);

                        PHeader.Init();
                        PHeader."No." := newPVNo;
                        PHeader.Date := Rec."Date";
                        PHeader."Currency Factor" := Rec."Currency Factor";
                        PHeader."Currency Code" := Rec."Currency Code";
                        PHeader.Payee := Rec.Payee;
                        PHeader."On Behalf Of" := Rec."On Behalf Of";
                        PHeader.Cashier := Rec.Cashier;
                        PHeader.Insert();

                        CurPLines.Reset();
                        CurPLines.SetRange(CurPLines.No, Rec."No.");
                        if CurPLines.Find('-') then begin
                            repeat
                                PLines.Init();
                                PLines.No := newPVNo;
                                PLines."Type" := CurPLines."Type";
                                PLines."Account No." := CurPLines."Account No.";
                                PLines."Date" := CurPLines."Date";
                                PLines."Pay Mode" := CurPLines."Pay Mode";
                                PLines."Cheque No" := CurPLines."Cheque No";
                                PLines."Cheque Date" := CurPLines."Cheque Date";
                                PLines."Cheque Type" := CurPLines."Cheque Type";
                                PLines."Bank Code" := CurPLines."Bank Code";
                                PLines."Received From" := CurPLines."Received From";
                                PLines."On Behalf Of" := CurPLines."On Behalf Of";
                                PLines."Cashier" := CurPLines."Cashier";
                                PLines."Account Type" := CurPLines."Account Type";
                                PLines."Account Name" := CurPLines."Account Name";
                                PLines."Posted" := CurPLines."Posted";
                                PLines."Date Posted" := CurPLines."Date Posted";
                                PLines."Time Posted" := CurPLines."Time Posted";
                                PLines."Posted By" := CurPLines."Posted By";
                                PLines."Amount" := CurPLines."Amount";
                                PLines."Remarks" := CurPLines."Remarks";
                                PLines."Transaction Name" := CurPLines."Transaction Name";
                                PLines."VAT Code" := CurPLines."VAT Code";
                                PLines."Withholding Tax Code" := CurPLines."Withholding Tax Code";
                                PLines."VAT Amount" := CurPLines."VAT Amount";
                                PLines."Withholding Tax Amount" := CurPLines."Withholding Tax Amount";
                                PLines."Net Amount" := CurPLines."Net Amount";
                                PLines."Paying Bank Account" := CurPLines."Paying Bank Account";
                                PLines."Payee" := CurPLines."Payee";
                                PLines."Global Dimension 1 Code" := CurPLines."Global Dimension 1 Code";
                                PLines."Branch Code" := CurPLines."Branch Code";
                                PLines."Bank Account No" := CurPLines."Bank Account No";
                                PLines."Cashier Bank Account" := CurPLines."Cashier Bank Account";
                                PLines."Status" := CurPLines."Status";
                                PLines."Select" := CurPLines."Select";
                                PLines."Grouping" := CurPLines."Grouping";
                                PLines."Payment Type" := CurPLines."Payment Type";
                                PLines."Bank Type" := CurPLines."Bank Type";
                                PLines."PV Type" := CurPLines."PV Type";
                                PLines."Apply to" := CurPLines."Apply to";
                                PLines."Apply to ID" := CurPLines."Apply to ID";
                                PLines."No of Units" := CurPLines."No of Units";
                                PLines."Surrender Date" := CurPLines."Surrender Date";
                                PLines."Surrendered" := CurPLines."Surrendered";
                                PLines."Vote Book" := CurPLines."Vote Book";
                                PLines."Total Allocation" := CurPLines."Total Allocation";
                                PLines."Total Expenditure" := CurPLines."Total Expenditure";
                                PLines."Total Commitments" := CurPLines."Total Commitments";
                                PLines."Balance" := CurPLines."Balance";
                                PLines."Balance Less this Entry" := CurPLines."Balance Less this Entry";
                                PLines."Applicant Designation" := CurPLines."Applicant Designation";
                                PLines."Petty Cash" := CurPLines."Petty Cash";
                                PLines."Shortcut Dimension 2 Code" := CurPLines."Shortcut Dimension 2 Code";
                                PLines."Imprest Request No" := CurPLines."Imprest Request No";
                                PLines."Batched Imprest Tot" := CurPLines."Batched Imprest Tot";
                                PLines."Function Name" := CurPLines."Function Name";
                                PLines."Budget Center Name" := CurPLines."Budget Center Name";
                                PLines."Farmer Purchase No" := CurPLines."Farmer Purchase No";
                                PLines."Transporter Ananlysis No" := CurPLines."Transporter Ananlysis No";
                                PLines."User ID" := CurPLines."User ID";
                                PLines."Journal Template" := CurPLines."Journal Template";
                                PLines."Journal Batch" := CurPLines."Journal Batch";
                                PLines."Require Surrender" := CurPLines."Require Surrender";
                                PLines."Select to Surrender" := CurPLines."Select to Surrender";
                                PLines."Payment Reference" := CurPLines."Payment Reference";
                                PLines."ID Number" := CurPLines."ID Number";
                                PLines."VAT Rate" := CurPLines."VAT Rate";
                                PLines."Amount With VAT" := CurPLines."Amount With VAT";
                                PLines."Currency Code" := CurPLines."Currency Code";
                                PLines."Exchange Rate" := CurPLines."Exchange Rate";
                                PLines."Currency Reciprical" := CurPLines."Currency Reciprical";
                                PLines."Shortcut Dimension 3 Code" := CurPLines."Shortcut Dimension 3 Code";
                                PLines."Shortcut Dimension 4 Code" := CurPLines."Shortcut Dimension 4 Code";
                                PLines."Committed" := CurPLines."Committed";
                                PLines."Currency Factor" := CurPLines."Currency Factor";
                                PLines."NetAmount LCY" := CurPLines."NetAmount LCY";
                                PLines."Retention  Amount" := CurPLines."Retention  Amount";
                                PLines."Retention Rate" := CurPLines."Retention Rate";
                                PLines."Vendor Bank Account" := CurPLines."Vendor Bank Account";
                                PLines."EFT Bank Account No" := CurPLines."EFT Bank Account No";
                                PLines."EFT Bank Code" := CurPLines."EFT Bank Code";
                                PLines."EFT Account Name" := CurPLines."EFT Account Name";
                                PLines."Document Type" := CurPLines."Document Type";
                                PLines."Document No" := CurPLines."Document No";
                                PLines."Document Line" := CurPLines."Document Line";
                                PLines."PAYE Amount" := CurPLines."PAYE Amount";
                                PLines."PAYE Code" := CurPLines."PAYE Code";
                                PLines."Budget Name" := CurPLines."Budget Name";
                                PLines."Budget Balance" := CurPLines."Budget Balance";
                                PLines."VAT Withheld Amount" := CurPLines."VAT Withheld Amount";
                                PLines."VAT Withheld Code" := CurPLines."VAT Withheld Code";
                                PLines."VAT Six % Rate" := CurPLines."VAT Six % Rate";
                                PLines."Not Vatable" := CurPLines."Not Vatable";
                                PLines."Council No." := CurPLines."Council No.";
                                PLines."PAYE Rate" := CurPLines."PAYE Rate";
                                PLines."Medical Claim Type" := CurPLines."Medical Claim Type";
                                PLines."Medical Ref. No" := CurPLines."Medical Ref. No";
                                PLines."Commission" := CurPLines."Commission";
                                PLines."Commision Amount" := CurPLines."Commision Amount";
                                PLines."Student No" := CurPLines."Student No";
                                PLines."KRA Pin No." := CurPLines."KRA Pin No.";
                                PLines."G/L Account" := CurPLines."G/L Account";
                                PLines."Shift No" := CurPLines."Shift No";
                                PLines."Shortcut Dimension 5 Code" := CurPLines."Shortcut Dimension 5 Code";
                                PLines."Sales Person" := CurPLines."Sales Person";
                                PLines."Excise Code" := CurPLines."Excise Code";
                                PLines."Excise  Amount" := CurPLines."Excise  Amount";
                                PLines."Excise Rate" := CurPLines."Excise Rate";
                                //PLines."Budget Control A_C" := CurPLines."Budget Control A_C";
                                PLines."LPO No" := CurPLines."LPO No";
                                PLines."Amount Taxed" := CurPLines."Amount Taxed";

                                PLines.Insert();
                            until CurPLines.Next = 0;
                        end;




                    end else
                        Error(Text001);
                end;
            }

            action(RefreshCurrency)
            {
                Caption = 'Refresh Currency';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Refresh Currency action.';

                trigger OnAction()
                var
                    Text000: Label 'Are you sure you want to refresh this Document?';
                    Text001: Label 'You have selected not to refresh the Document';
                begin
                    //TestField(Status, Status::Approved);
                    if Confirm(Text000, true) then begin
                        Rec.UpdateCurrencyFactor();
                        Rec.Modify;
                    end else
                        Error(Text001);
                end;
            }

            action(ForceOpen)
            {
                Caption = 'Force Open';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Force Open action.';

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Pending then
                        Rec.Status := Rec.Status::Approved
                    else
                        if Rec.Status = Rec.Status::Approved then
                            Rec.Status := Rec.Status::Pending;
                    rec.Modify();
                end;
            }
            action(ShowInvDet)
            {
                Caption = 'Show Invoice Details';
                Enabled = false;
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Show Invoice Details action.';
                /*
                                trigger OnAction()
                                begin

                                    if PurchInvHeader.Get(CurrPage.PVLines.PAGE.GetDocNo) then begin
                                        PAGE.RunModal(138, PurchInvHeader)
                                    end else begin
                                        Message('not found')
                                    end;
                                end;
                                */
            }
            separator(Separator57) { }
            action("Reverse Posted Entries")
            {
                ToolTip = 'Executes the Reverse Posted Entries action.';

                trigger OnAction()
                begin
                    Rec.CalcFields("Posted Count");
                    if Rec."Posted Count" = 0 then Error('Posted entries does not exists in the ledgers for the selected document');
                    if Confirm('Do you want to reverse the posted entries?') then begin
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."Document No.", Rec."No.");
                        if GLEntry.Find('-') then GLEntry.DeleteAll;

                        VEntry.Reset;
                        VEntry.SetRange(VEntry."Document No.", Rec."No.");
                        if VEntry.Find('-') then VEntry.DeleteAll;

                        DVEntry.Reset;
                        DVEntry.SetRange(DVEntry."Document No.", Rec."No.");
                        if DVEntry.Find('-') then DVEntry.DeleteAll;

                        BEntry.Reset;
                        BEntry.SetRange(BEntry."Document No.", Rec."No.");
                        if BEntry.Find('-') then BEntry.DeleteAll;
                    end;
                end;
            }
            action(Test)
            {
                ToolTip = 'Executes the Test action.';

                trigger OnAction()
                begin
                    Message(DelStr('SEVEN', 1, 2));  //VEN
                    Message(DelStr('SEVEN', 3));  //SE
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin

        PVLinesEditable := true;
        DateEditable := true;
        PayeeEditable := true;
        ShortcutDimension2CodeEditable := true;
        "Payment NarrationEditable" := true;
        GlobalDimension1CodeEditable := true;
        //"Currency CodeEditable" := FALSE;
        "Invoice Currency CodeEditable" := true;
        "Cheque TypeEditable" := true;
        "Payment Release DateEditable" := true;
        "Cheque No.Editable" := true;
        PaymodeEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Payment Type" := Rec."Payment Type"::Normal;

        rcpt.Reset;
        rcpt.SetRange(rcpt.Posted, false);
        rcpt.SetRange(rcpt.Cashier, UserId);
        if rcpt.Count > 0 then begin
            if Confirm('There are still some unposted payments. Continue?', false) = false then begin
                Error('There are still some unposted payments. Please utilise them first');
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
         VALIDATE("Shortcut Dimension 4 Code");
         "Responsibility Center":='MAIN';*/
        //OnAfterGetCurrRecord;

    end;

    trigger OnOpenPage()
    begin

        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;


        UpdateControls;
        UpdatePageControls();
    end;

    var
        Phead: record "Payments Header";
        Text001: Label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text000: Label 'Do you want to Void Check No %1';
        Text002: Label 'You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';
        rcpt: Record "Payments Header";
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
        UserMgt: Codeunit "User Setup Management BR";
        JournlPosted: Codeunit "Journal Post Successful";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
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

        // PvApplication: Record "Payments Application Lines";
        GLEntry: Record "G/L Entry";
        VEntry: Record "Vendor Ledger Entry";
        DVEntry: Record "Detailed Vendor Ledg. Entry";
        BEntry: Record "Bank Account Ledger Entry";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
    // ApprovalsMgmt: Codeunit "Approvals Mgmt.";

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
        Rec.TestField("Payment Narration");
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
        //IF ("Pay Mode"="Pay Mode"::Cheque) AND ("Cheque No."='') THEN
        // ERROR('Kindly specify the Cheque No');
        if Rec."Pay Mode" = Rec."Pay Mode"::Cheque then begin
            if StrLen(Rec."Cheque No.") <> 6 then begin
                Error('Invalid Cheque Number inserted');
            end;
        end;
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

    procedure UpdatePageControls()
    begin

        IF Rec.Status <> Rec.Status::Approved THEN BEGIN
            "Payment Release DateEditable" := FALSE;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrForm."Pay Mode".EDITABLE:=FALSE;
            //CurrForm."Currency Code".EDITABLE:=TRUE;
            "Cheque No.Editable" := FALSE;
            "Cheque TypeEditable" := FALSE;
            PaymodeEditable := TRUE;
            "Invoice Currency CodeEditable" := TRUE;
        END ELSE BEGIN
            "Payment Release DateEditable" := TRUE;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrForm."Pay Mode".EDITABLE:=TRUE;
            IF Rec."Pay Mode" = Rec."Pay Mode"::Cheque THEN
                "Cheque TypeEditable" := TRUE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            IF Rec."Cheque Type" <> Rec."Cheque Type"::"Computer Check" THEN
                "Cheque No.Editable" := TRUE;
            "Invoice Currency CodeEditable" := FALSE;
            PaymodeEditable := TRUE;
            //BankEditabl:=TRUE;
            //OnBehalfEditable:=TRUE;
            //RespEditabl:=TRUE;

        END;
        IF Rec.Status = Rec.Status::Pending THEN BEGIN
            "Currency CodeEditable" := TRUE;
            GlobalDimension1CodeEditable := TRUE;
            "Payment NarrationEditable" := TRUE;
            ShortcutDimension2CodeEditable := TRUE;
            PayeeEditable := TRUE;
            ShortcutDimension3CodeEditable := TRUE;
            ShortcutDimension4CodeEditable := TRUE;
            DateEditable := TRUE;
            PaymodeEditable := TRUE;
            //BankEditabl:=TRUE;
            //OnBehalfEditable:=TRUE;
            //RespEditabl:=TRUE;

            PVLinesEditable := TRUE;
        END ELSE BEGIN
            "Currency CodeEditable" := FALSE;
            GlobalDimension1CodeEditable := FALSE;
            "Payment NarrationEditable" := FALSE;
            ShortcutDimension2CodeEditable := FALSE;
            PayeeEditable := TRUE;
            ShortcutDimension3CodeEditable := FALSE;
            ShortcutDimension4CodeEditable := FALSE;
            DateEditable := FALSE;
            PVLinesEditable := FALSE;
        END;

        IF Rec.Status = Rec.Status::Posted THEN BEGIN
            PaymodeEditable := FALSE;
            //BankEditabl:=FALSE;
            //OnBehalfEditable:=FALSE;
            //RespEditabl:=FALSE;
            PVLinesEditable := FALSE;
        END;
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

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Payment Line";
    begin
        AllKeyFieldsEntered := true;
        Rec.TestField("Payment Narration");
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No." = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;
            // if PayLines."PAYE Code" <> '' then PayLines.TestField(PayLines."KRA Pin No.");
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
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := PayLine."Account Type";
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
                //GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";
                GenJnlLine.Description := Rec.Payee;
                ///GenJnlLine."Received By":=Payee;
                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;


            until PayLine.Next = 0;

        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;

    procedure PostPaymentVoucher(rec: Record "Payments Header")
    var
        ClaimHeader: Record "Staff Claims Header";
        DocType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance;
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

            //Post:=FALSE;
            //Post:=JournlPosted.PostedSuccessfully();
            //IF Post THEN  BEGIN
            Rec.Posted := true;
            Rec.Status := Payments.Status::Posted;
            Rec."Posted By" := UserId;
            Rec."Date Posted" := Today;
            Rec."Time Posted" := Time;
            if Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check" then
                Rec."Cheque Printed" := true;
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
            if ClaimHeader.Get(Rec."Apply to Document No") then begin
                ClaimHeader.Posted := true;
                ClaimHeader."Date Posted" := Today;
                ClaimHeader."Time Posted" := Time;
                ClaimHeader."Posted By" := UserId;
                ClaimHeader."Cheque No." := Rec."Cheque No.";
                ClaimHeader.Status := ImprestHeader.Status::Posted;
                ClaimHeader."Payment Voucher No" := Rec."No.";
                ClaimHeader.Modify;
                DocType := DocType::StaffClaim;
                CheckBudgetAvail.ReverseEntries(DocType, Rec."Apply to Document No");
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

        //END;
    end;

    procedure PostHeader(var Payment: Record "Payments Header")
    var
        recCurrency: Record "Currency Exchange Rate";
    begin

        //----adjust currency---
        if Payment."Negotiated Exchange Rate" <> 0 then begin
            recCurrency.Reset();
            recCurrency.SetRange(recCurrency."Starting Date", Payment."Payment Release Date");
            recCurrency.SetRange(recCurrency."Currency Code", Payment."Currency Code");
            if recCurrency.Find('-') then begin
                recCurrency."Relational Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Adjustment Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Relational Adjmt Exch Rate Amt" := Payment."Negotiated Exchange Rate";
                recCurrency.Modify;
            end else begin
                recCurrency.Init();
                recCurrency."Starting Date" := Payment."Payment Release Date";
                recCurrency."Currency Code" := Payment."Currency Code";
                recCurrency."Exchange Rate Amount" := 1;
                recCurrency."Relational Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Adjustment Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Relational Adjmt Exch Rate Amt" := Payment."Negotiated Exchange Rate";
                recCurrency.Insert();
            end;
        end;

        if Payments."Pay Mode" = Payments."Pay Mode"::EFT then begin
            if (Payments."Cheque No." = '') and (Payments."Cheque Type" = Payments."Cheque Type"::"Computer Check") then begin
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
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
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
    var
        recCurrency: Record "Currency Exchange Rate";

    begin

        if Payment."Currency Code" <> '' then begin
            Payment.testfield("Negotiated Exchange Rate");

        end;
        //----adjust currency---
        if Payment."Negotiated Exchange Rate" <> 0 then begin
            recCurrency.Reset();
            recCurrency.SetRange(recCurrency."Starting Date", Payment."Payment Release Date");
            recCurrency.SetRange(recCurrency."Currency Code", Payment."Currency Code");
            if recCurrency.Find('-') then begin
                recCurrency."Relational Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Adjustment Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Relational Adjmt Exch Rate Amt" := Payment."Negotiated Exchange Rate";
                recCurrency.Modify;
            end else begin
                recCurrency.Init();
                recCurrency."Starting Date" := Payment."Payment Release Date";
                recCurrency."Currency Code" := Payment."Currency Code";
                recCurrency."Exchange Rate Amount" := 1;
                recCurrency."Relational Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Adjustment Exch. Rate Amount" := Payment."Negotiated Exchange Rate";
                recCurrency."Relational Adjmt Exch Rate Amt" := Payment."Negotiated Exchange Rate";
                recCurrency.Insert();
            end;
        end;

        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Payments."No.");
        if PayLine.Find('-') then begin

            repeat
                strText := GetAppliedEntries(PayLine."Line No.");
                Payment.TestField(Payment.Payee);
                PayLine.TestField(PayLine.Amount);
                //IF PayLine."PAYE Amount">0 THEN PayLine.TESTFIELD(PayLine."KRA Pin No.");
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
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine.Description := CopyStr(Rec."Payment Narration", 1, 50);
                //    GenJnlLine.Description:=COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate("Currency Code");
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                //  GenJnlLine.Validate("Currency Factor");

                if PayLine."VAT Code" = '' then begin
                    GenJnlLine.Amount := PayLine."Net Amount";
                    ;//..
                end
                else
                    if PayLine."VAT Withheld Code" = '' then begin
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
                //GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";

                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;

                //Post RETENTION to GL[RETENTION GL]
                if PayLine."Retention Code" <> '' then begin

                    TarriffCodes.Reset;
                    TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Retention Code");
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
                        // if CustomerPayLinesExist then
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        //else
                        //    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PayLine.No;
                        GenJnlLine."External Document No." := Payments."Cheque No.";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";
                        GenJnlLine."Account No." := TarriffCodes."Account No.";
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
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := PayLine."Account Type";
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
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."VAT Withheld Code");
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
                /// 
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."VAT Withheld Code");
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
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    //GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    //GenJnlLine."Bal. Account Type":=GenJnlLine."Account Type"::Vendor;
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine."Account No." := PayLine."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");

                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
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

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
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
                    //  if CustomerPayLinesExist then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    // else
                    //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := TarriffCodes."Account Type";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor  Dennis
                    GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    GenJnlLine.Validate("Currency Factor");

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
                    //GenJnlLine."Bal. Account Type" := PayLine."Account Type";
                    // GenJnlLine."Bal. Account No.":=PayLine."Account No.";
                    // GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
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
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
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
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate(GenJnlLine."Currency Code");
                //CurrFactor
                // GenJnlLine."Currency Factor"GenJnlLine."Currency Factor" := Payments."Currency Factor";
                //  GenJnlLine.Validate("Currency Factor");

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

                    //Post W/TAX Balancing Entry Goes to Vendor
                    TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Withholding Tax Code");
                if TarriffCodes.Find('-') then begin
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
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine."Account No." := PayLine."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    // GenJnlLine."Currency Factor" := Payments."Currency Factor";
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
                    GenJnlLine.Amount := PayLine."Withholding Tax Amount";//1
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('W/Tax:' + strText, 1, 50);
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
                end;
                //Post P.A.YE Balancing Entry Goes to Vendor
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."PAYE Code");
                if TarriffCodes.Find('-') then begin
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
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice
                    else
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine."Account No." := PayLine."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    //GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    //GenJnlLine.Validate("Currency Factor");

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

                end
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
                END; */
            //  end;

        end;

    end;

}


