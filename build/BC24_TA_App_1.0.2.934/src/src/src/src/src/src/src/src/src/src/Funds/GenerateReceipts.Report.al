Report 50323 "Generate Receipts"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Transactions Buffer"; "Bank Transactions Buffer")
        {
            DataItemTableView = sorting("Transaction Code") where(Posted = const(false), "Bank Code" = filter(<> ''), "Stud Exist" = filter(true));
            RequestFilterFields = Date;
            column(ReportForNavId_4756; 4756) { }

            trigger OnAfterGetRecord()
            begin
                CashOfficeUserTemp.get(Database.UserId);
                CashOfficeUserTemp.TestField("Receipt Journal Template");
                CashOfficeUserTemp.TestField("Receipt Journal Batch");

                if Cust.get("Student No.") then begin
                    if BankRec.get("Bank Code") then begin
                        BankRec.TestField("Receipt No. Series");
                        ReceiptNo := NoSeries.GetNextNo(BankRec."Receipt No. Series", today, true);
                        GenJnl.Init;
                        GenJnl."Line No." := GenJnl."Line No." + 10000;
                        GenJnl."Posting Date" := DT2DATE("Transcation Date");
                        GenJnl."Document No." := ReceiptNo;
                        GenJnl."External Document No." := "Transaction Code";
                        GenJnl.Validate(GenJnl."Document No.");
                        GenJnl."Journal Template Name" := CashOfficeUserTemp."Receipt Journal Template";
                        GenJnl."Journal Batch Name" := CashOfficeUserTemp."Receipt Journal Batch";
                        GenJnl."Account Type" := GenJnl."account type"::Customer;
                        GenJnl.Amount := Amount;
                        GenJnl.Validate(GenJnl."Account No.");
                        GenJnl.Validate(GenJnl.Amount);
                        GenJnl.Description := Description;
                        GenJnl."Bal. Account Type" := GenJnl."account type"::"Bank Account";
                        GenJnl."Bal. Account No." := "Bank Code";
                        GenJnl."Shortcut Dimension 1 Code" := "Global Dimension1 Code";
                        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                        GenJnl.Insert;

                        Posted := true;
                        Modify;

                    end;
                end;


            end;

            trigger OnPostDataItem()
            begin

                GenJnl.SETRANGE("Journal Template Name", CashOfficeUserTemp."Receipt Journal Template");
                GenJnl.SETRANGE("Journal Batch Name", CashOfficeUserTemp."Receipt Journal Batch");
                IF GenJnl.FIND('-') THEN BEGIN
                    REPEAT
                        GLPosting.RUN(GenJnl);
                    UNTIL GenJnl.NEXT = 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                /*
                IF TransType = TransType::" " THEN
                ERROR('You must specify the trasaction type.');
                */
                TransType := Transtype::"Direct Bank Deposit";

                LineNo := 0;
                GenJnl.RESET;
                GenJnl.SETRANGE("Journal Template Name", CashOfficeUserTemp."Receipt Journal Template");
                GenJnl.SETRANGE("Journal Batch Name", CashOfficeUserTemp."Receipt Journal Batch");
                GenJnl.DELETEALL;

            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        BankRec: record "Bank Account";
        CashOfficeUserTemp: Record "Cash Office User Template";
        NoSeries: Codeunit "No. Series";
        Cust: Record Customer;
        GenJnl: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post B2";
        LineNo: Integer;
        TransType: Option " ","Direct Bank Deposit",HELB,Bursary,CDF;
        ReceiptNo: Code[20];
}

