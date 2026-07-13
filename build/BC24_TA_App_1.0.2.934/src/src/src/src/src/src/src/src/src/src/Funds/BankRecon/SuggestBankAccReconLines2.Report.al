report 50021 "Suggest BankAcc. Recon. Lines2"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem4558; "Bank Account")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord();
            begin
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                BankAccLedgEntry.SETRANGE("Bank Account No.", "No.");
                BankAccLedgEntry.SETRANGE("Posting Date", 0D, Today);
                BankAccLedgEntry.SETRANGE(Open, TRUE);
                BankAccLedgEntry.setrange(reversed, false);
                BankAccLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                EOFBankAccLedgEntries := NOT BankAccLedgEntry.FIND('-');

                IF IncludeChecks THEN BEGIN
                    CheckLedgEntry.RESET;
                    CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Check Date");
                    CheckLedgEntry.SETRANGE("Bank Account No.", "No.");
                    CheckLedgEntry.SETRANGE("Check Date", 0D, Today);

                    CheckLedgEntry.SETFILTER(
                      "Entry Status", '%1|%2', CheckLedgEntry."Entry Status"::Posted,
                      CheckLedgEntry."Entry Status"::"Financially Voided");
                    CheckLedgEntry.SETRANGE(Open, TRUE);
                    CheckLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                    EOFCheckLedgEntries := NOT CheckLedgEntry.FIND('-');
                END;

                WHILE (NOT EOFBankAccLedgEntries) OR (IncludeChecks AND (NOT EOFCheckLedgEntries)) DO
                    CASE TRUE OF
                        NOT IncludeChecks:
                            BEGIN
                                EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            END;
                        (NOT EOFBankAccLedgEntries) AND (NOT EOFCheckLedgEntries) AND
                        (BankAccLedgEntry."Posting Date" <= CheckLedgEntry."Check Date"):
                            BEGIN
                                CheckLedgEntry2.RESET;
                                CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SETRANGE(Open, TRUE);
                                IF NOT CheckLedgEntry2.FINDFIRST THEN
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            END;
                        (NOT EOFBankAccLedgEntries) AND (NOT EOFCheckLedgEntries) AND
                        (BankAccLedgEntry."Posting Date" > CheckLedgEntry."Check Date"):
                            BEGIN
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                            END;
                        (NOT EOFBankAccLedgEntries) AND EOFCheckLedgEntries:
                            BEGIN
                                CheckLedgEntry2.RESET;
                                CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SETRANGE(Open, TRUE);
                                IF NOT CheckLedgEntry2.FINDFIRST THEN
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            END;
                        EOFBankAccLedgEntries AND (NOT EOFCheckLedgEntries):
                            BEGIN
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                            END;
                    END;
            end;

            trigger OnPreDataItem();
            begin
                IF EndDate = 0D THEN
                    ERROR(Text000);

                BankAccReconLine.FilterBankRecLines(BankAccRecon);
                IF NOT BankAccReconLine.FINDLAST THEN BEGIN
                    BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
                    BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
                    BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
                    BankAccReconLine."Statement Line No." := 0;
                END;

                SETRANGE("No.", BankAccRecon."Bank Account No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Statement Period")
                    {
                        Caption = 'Statement Period';
                        field(StartingDate; StartDate)
                        {
                            Caption = 'Starting Date';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Starting Date field.';
                        }
                        field(EndingDate; EndDate)
                        {
                            Caption = 'Ending Date';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Ending Date field.';
                        }
                    }
                    field(IncludeChecks; IncludeChecks)
                    {
                        Caption = 'Include Checks';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Checks field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    var
        Text000: Label 'Enter the Ending Date.';
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        StartDate: Date;
        EndDate: Date;
        IncludeChecks: Boolean;
        EOFBankAccLedgEntries: Boolean;
        EOFCheckLedgEntries: Boolean;

    procedure SetStmt(var BankAccRecon2: Record "Bank Acc. Reconciliation");
    begin
        BankAccRecon := BankAccRecon2;
        EndDate := BankAccRecon."Statement Date";
    end;

    local procedure EnterBankAccLine(var BankAccLedgEntry2: Record "Bank Account Ledger Entry");
    begin
        BankAccReconLine.INIT;
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := BankAccLedgEntry2."Posting Date";
        BankAccReconLine.Description := BankAccLedgEntry2.Description;
        BankAccReconLine."Document No." := copystr(BankAccLedgEntry2."Document No.", 1, maxstrlen(BankAccReconLine."Document No."));
        BankAccReconLine."Statement Amount" := BankAccLedgEntry2."Remaining Amount";
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        BankAccReconLine."Account No." := BankAccLedgEntry2."Bal. Account No.";
        BankAccLedgEntry2.CALCFIELDS("Customer Name");
        BankAccReconLine."Account Name" := BankAccLedgEntry2."Customer Name";

        // BankAccReconLine.Type := BankAccReconLine.Type::"Bank Account Ledger Entry";
        BankAccReconLine."Document Date" := BankAccLedgEntry2."Document Date";
        BankAccReconLine.Reversed := BankAccLedgEntry2.Reversed;
        // added to add the Cheque No.
        BankAccReconLine."Check No." := CopyStr(BankAccLedgEntry2."External Document No.", 1, mAXSTRLEN(BankAccReconLine."Check No."));
        //BankAccReconLine.Reconciled:=TRUE;
        BankAccReconLine."Bank Ledger Entry Line No" := BankAccLedgEntry2."Entry No.";
        // end of addition
        BankAccReconLine."Applied Entries" := 1;
        BankAccSetStmtNo.SetReconNo(BankAccLedgEntry2, BankAccReconLine);
        BankAccReconLine.INSERT;
    end;

    local procedure EnterCheckLine(var CheckLedgEntry3: Record "Check Ledger Entry");
    begin
        BankAccReconLine.INIT;
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := CheckLedgEntry3."Check Date";
        BankAccReconLine.Description := CheckLedgEntry3.Description;
        BankAccReconLine."Statement Amount" := -CheckLedgEntry3.Amount;
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        // BankAccReconLine.Type := BankAccReconLine.Type::"Check Ledger Entry";
        BankAccReconLine."Check No." := CheckLedgEntry3."Check No.";
        // added to add the Cheque No.
        //BankAccReconLine.Reconciled:=TRUE;
        // end of addition

        //BankAccReconLine."Applied Entries" := 1;
        //CheckSetStmtNo.SetReconNo(CheckLedgEntry3,BankAccReconLine);
        BankAccReconLine.INSERT;
    end;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewIncludeChecks: Boolean);
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        IncludeChecks := NewIncludeChecks;
    end;
}

