pageextension 50039 "Bank Account Recon." extends "Bank Acc. Reconciliation"
{
    layout
    {
        addafter(StatementEndingBalance)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = basic;
                Editable = false;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
        addbefore(Control8)
        {
            group("Reconciliation Lines")
            {
                part(Smt; "Bank Acc. Reconciliation Lines")
                {
                    ApplicationArea = basic;
                    caption = 'Bank Reconciliation Lines';
                    SubPageLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                }
            }
        }
    }
    actions
    {

        modify(Post)
        {
            trigger OnBeforeAction()
            var
                UserRec: record "User Setup";
            begin
                UserRec.Get(Database.UserId);
                UserRec.TestField("Can Post Bank Recon.");
                PostToPostedBankAccLedgerEntry(Rec);
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            var
                UserRec: record "User Setup";
            begin
                UserRec.Get(Database.UserId);
                UserRec.TestField("Can Post Bank Recon.");
                PostToPostedBankAccLedgerEntry(Rec);
            end;
        }


        modify("&Test Report")
        {
            Visible = false;
        }
        addafter(MatchAutomatically)
        {
            action(MatchAuto)
            {
                ApplicationArea = basic;
                PromotedCategory = Process;
                Promoted = true;
                Image = MapAccounts;
                Caption = 'Match Automatically.';
                Visible = false;
                ToolTip = 'Executes the Match Automatically. action.';
                trigger OnAction()
                begin
                    Rec.SETRANGE("Statement Type", Rec."Statement Type");
                    Rec.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                    Rec.SETRANGE("Statement No.", Rec."Statement No.");
                    REPORT.RUN(REPORT::"Match Bank Entries2", TRUE, TRUE, Rec);
                end;
            }
        }
        addafter("&Test Report")
        {
            action("&Test Report1")
            {
                ApplicationArea = basic;
                PromotedCategory = Report;
                Promoted = true;
                Caption = 'Test Report';
                ToolTip = 'Executes the Test Report action.';
                trigger OnAction()
                var
                    BankRec: Record "Bank Acc. Reconciliation";
                begin
                    BankRec.reset;
                    BankRec.setfilter("Statement No.", Rec."Statement No.");
                    BankRec.setfilter("Bank Account No.", Rec."Bank Account No.");
                    if BankRec.find('-') then
                        PostToPostedBankAccLedgerEntry(BankRec);
                    Commit();

                    BankRec.reset;
                    BankRec.setfilter("Statement No.", Rec."Statement No.");
                    BankRec.setfilter("Bank Account No.", Rec."Bank Account No.");
                    if BankRec.find('-') then
                        report.run(1408, true, true, BankRec);
                end;
            }

        }
        addafter(Post)
        {
            action("UpdateExtDocNo")
            {
                ApplicationArea = basic;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Update External Document No';
                ToolTip = 'Executes the Update External Document No action.';
                trigger OnAction()
                begin
                    UpdateExternalDocumentNo(Rec."Bank Account No.", Rec);
                    message('Complete');
                end;
            }
        }
        addbefore(Post)
        {
            group("Approval")
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
                        AppEntry.setrange("Document No.", Rec."Statement No.");
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

                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                    end;
                }
            }
        }


    }

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";

    procedure UpdateExternalDocumentNo(BankNo: Code[20]; BankAccRecon: Record "Bank Acc. Reconciliation")

    Var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccountLedgerEntry.RESET;

        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Bank Account No.", Rec."Bank Account No.");
        BankAccountLedgerEntry.SETFILTER(BankAccountLedgerEntry."Posting Date", '%1..%2', 0D, BankAccRecon."Statement Date");
        IF BankAccountLedgerEntry.FIND('-') THEN BEGIN
            REPEAT
                if BankAccountLedgerEntry."External Document No." = '' then begin
                    BankAccountLedgerEntry."External Document No." := BankAccountLedgerEntry."Bal. Account No.";
                    BankAccountLedgerEntry.modify;
                end;
            until BankAccountLedgerEntry.next = 0;
        end;
    end;

    procedure PostToPostedBankAccLedgerEntry(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccount: Record "Bank Account";
        PosteBankAccountLedgerEntry: Record "PosteBank Account Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        //get the net change of the bank
        BankAccount.RESET;
        BankAccount.SETRANGE(BankAccount."No.", BankAccRecon."Bank Account No.");
        IF BankAccount.FIND('-') THEN BEGIN
            BankAccount.CALCFIELDS(BankAccount."Net Change");
        END;

        PosteBankAccountLedgerEntry.RESET;
        PosteBankAccountLedgerEntry.SETRANGE(PosteBankAccountLedgerEntry."Bank Account No.", BankAccRecon."Bank Account No.");
        PosteBankAccountLedgerEntry.SETRANGE(PosteBankAccountLedgerEntry."Statement No.", BankAccRecon."Statement No.");
        //PosteBankAccountLedgerEntry.SETRANGE(PosteBankAccountLedgerEntry."Entry No.", BankAccountLedgerEntry."Entry No.");
        IF PosteBankAccountLedgerEntry.FIND('-') THEN
            PosteBankAccountLedgerEntry.DELETEALL;

        BankAccountLedgerEntry.RESET;
        BankAccountLedgerEntry.SETCURRENTKEY("Bank Account No.", Open);
        // BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Statement No.", BankAccRecon."Statement No.");
        // BankAccountLedgerEntry.SETRANGE(Open, TRUE);
        // BankAccountLedgerEntry.SETRANGE(
        //"Statement Status", BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied");
        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Bank Account No.", BankAccRecon."Bank Account No.");
        BankAccountLedgerEntry.SETFILTER(BankAccountLedgerEntry."Posting Date", '%1..%2', 0D, BankAccRecon."Statement Date");
        IF BankAccountLedgerEntry.FIND('-') THEN BEGIN
            REPEAT
                PosteBankAccountLedgerEntry.INIT;
                PosteBankAccountLedgerEntry."Posting Date" := BankAccountLedgerEntry."Posting Date";
                PosteBankAccountLedgerEntry."Bank Account No." := BankAccountLedgerEntry."Bank Account No.";
                PosteBankAccountLedgerEntry."Document No." := BankAccountLedgerEntry."Document No.";
                PosteBankAccountLedgerEntry."External Document No." := BankAccountLedgerEntry."External Document No.";
                PosteBankAccountLedgerEntry.Reversed := BankAccountLedgerEntry.Reversed;
                PosteBankAccountLedgerEntry.Open := BankAccountLedgerEntry.Open;
                PosteBankAccountLedgerEntry."Statement Status" := BankAccountLedgerEntry."Statement Status";
                PosteBankAccountLedgerEntry."Entry No." := BankAccountLedgerEntry."Entry No.";
                PosteBankAccountLedgerEntry."Bal. Account No." := BankAccountLedgerEntry."Bank Account No.";
                //PosteBankAccountLedgerEntry."Bank Net Change":=BankAccount."Net Change";
                PosteBankAccountLedgerEntry."Statement No." := BankAccRecon."Statement No.";  //BankAccountLedgerEntry."Statement No.";
                PosteBankAccountLedgerEntry.Description := BankAccountLedgerEntry.Description;
                PosteBankAccountLedgerEntry.Amount := BankAccountLedgerEntry.Amount;
                PosteBankAccountLedgerEntry."Statement Difference" := BankAccountLedgerEntry."Statement Difference";
                // PosteBankAccountLedgerEntry.TRANSFERFIELDS(BankAccountLedgerEntry);

                PosteBankAccountLedgerEntry.INSERT;
            UNTIL BankAccountLedgerEntry.NEXT = 0;
        END;
    end;
}