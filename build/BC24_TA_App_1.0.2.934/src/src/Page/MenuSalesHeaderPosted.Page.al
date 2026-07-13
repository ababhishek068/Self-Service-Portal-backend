Page 50752 "Menu Sales Header-Posted"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = Document;
    SourceTable = "Menu Sale Header";
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(ReceiptNo; Rec."Receipt No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receipt No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(CustomerType; Rec."Customer Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Customer Type field.';

                    trigger OnValidate()
                    begin
                        if (Rec."Customer Type" = Rec."customer type"::Staff) or (Rec."Customer Type" = Rec."customer type"::Department) then begin
                            "Paid AmountEditable" := false;
                            BalanceEditable := false;
                        end
                        else begin
                            "Paid AmountEditable" := true;
                            // CurrForm.Balance.editable:=true;
                        end;
                    end;
                }
                field(SalesType; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sales Type field.';

                    trigger OnValidate()
                    begin

                        if (Rec."Sales Type" = Rec."sales type"::Prepayment) then begin
                            "Paid AmountEditable" := false;
                            "Customer NoEditable" := true;
                            "Transaction NoEditable" := false;
                        end
                        else
                            if (Rec."Sales Type" = Rec."sales type"::"Pepea Card") or (Rec."Sales Type" = Rec."sales type"::Mpesa) then begin
                                "Paid AmountEditable" := false;
                                "Customer NoEditable" := false;
                                "Transaction NoEditable" := true;
                                // CurrForm.Balance.editable:=true;
                            end
                            else begin
                                "Paid AmountEditable" := true;
                                "Customer NoEditable" := false;
                                "Transaction NoEditable" := false;
                                // CurrForm.Balance.editable:=true;
                            end;
                    end;
                }
                field(BarCodeNo; Rec."BarCode No.")
                {
                    ApplicationArea = Basic;
                    Editable = "Customer NoEditable";
                    ToolTip = 'Specifies the value of the BarCode No. field.';
                }
                field(CustomerNo; Rec."Customer No")
                {
                    ApplicationArea = Basic;
                    Editable = "Customer NoEditable";
                    ToolTip = 'Specifies the value of the Customer No field.';

                    trigger OnValidate()
                    begin
                        Student.Reset;
                        Student.SetRange(Student."No.", Rec."Customer No");
                        if Student.Find('-') then begin
                            Rec."Customer Name" := Student.Name
                        end;
                    end;
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(PrepaymentBalance; Rec."Prepayment Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Prepayment Balance field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(CashierName; Rec."Cashier Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cashier Name field.';
                }
                field(PaidAmount; Rec."Paid Amount")
                {
                    ApplicationArea = Basic;
                    Editable = "Paid AmountEditable";
                    ToolTip = 'Specifies the value of the Paid Amount field.';

                    trigger OnValidate()
                    begin
                        SalesLine.Reset;
                        Amt := 0;
                        SalesLine.SetRange(SalesLine."Receipt No", Rec."Receipt No");
                        if SalesLine.Find('-') then begin
                            repeat
                                Amt := Amt + SalesLine.Amount;
                            until SalesLine.Next = 0;
                        end;
                        Rec.Balance := Rec."Paid Amount" - Amt;
                    end;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    Editable = BalanceEditable;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
                field(ReversedBy; Rec."Reversed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reversed By field.';
                }
                field(ReversedDate; Rec."Reversed Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reversed Date field.';
                }
                field(TransactionNo; Rec."Transaction No.")
                {
                    ApplicationArea = Basic;
                    Editable = "Transaction NoEditable";
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
            }
            part(Control1000000000; "Menu Sales Line")
            {
                SubPageLink = "Receipt No" = field("Receipt No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PreviewReceipt)
            {
                ApplicationArea = Basic;
                Caption = 'Preview Receipt';
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                ToolTip = 'Executes the Preview Receipt action.';

                trigger OnAction()
                begin
                    MenuSale.Reset;
                    MenuSale.SetRange(MenuSale."Receipt No", Rec."Receipt No");
                    if MenuSale.Find('-') then
                        Report.Run(70135503, true, true, MenuSale);
                end;
            }
            action(Reverse)
            {
                ApplicationArea = Basic;
                Caption = 'Reverse Receipt';
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F12';
                ToolTip = 'Executes the Reverse Receipt action.';

                trigger OnAction()
                begin

                    UserSEtup.Get(UserId);
                    if UserSEtup."Allow Transaction Reversal" = false then Error('Please note that you dont have the rights to reverse the receipt!');
                    if Confirm('Do you really want to reverse the receipt?') then begin
                        if PostJrn() = true then begin
                            Rec.CalcFields(Amount);
                            Rec."Line Amount" := Rec.Amount;
                            Rec.Reversed := true;
                            Rec."Reversed By" := UserId;
                            Rec."Reversed Date" := Today;
                            Rec.Modify;
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Cashier Name", UserId);
    end;

    trigger OnInit()
    begin
        //"Paid AmountEditable" := TRUE;

        if (Rec."Sales Type" = Rec."sales type"::Prepayment) then begin
            "Paid AmountEditable" := false;
            "Customer NoEditable" := true;
            "Transaction NoEditable" := false;
        end
        else
            if (Rec."Sales Type" = Rec."sales type"::"Pepea Card") or (Rec."Sales Type" = Rec."sales type"::Mpesa) then begin
                "Paid AmountEditable" := false;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := true;
                // CurrForm.Balance.editable:=true;
            end
            else begin
                "Paid AmountEditable" := true;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := false;
                // CurrForm.Balance.editable:=true;
            end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Cashier Name" := UserId;
        Rec."Sales Point" := 'MESS';
        if (Rec."Sales Type" = Rec."sales type"::Prepayment) then begin
            "Paid AmountEditable" := false;
            "Customer NoEditable" := true;
            "Transaction NoEditable" := false;
        end
        else
            if (Rec."Sales Type" = Rec."sales type"::"Pepea Card") or (Rec."Sales Type" = Rec."sales type"::Mpesa) then begin
                "Paid AmountEditable" := false;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := true;
                // CurrForm.Balance.editable:=true;
            end
            else begin
                "Paid AmountEditable" := true;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := false;
                // CurrForm.Balance.editable:=true;
            end;
        SaleSetUp.Get();

        //"Receiving Bank":=SaleSetUp."Cash Receiving Bank Account";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        if (Rec."Sales Type" = Rec."sales type"::Prepayment) then begin
            "Paid AmountEditable" := false;
            "Customer NoEditable" := true;
            "Transaction NoEditable" := false;
        end
        else
            if (Rec."Sales Type" = Rec."sales type"::"Pepea Card") or (Rec."Sales Type" = Rec."sales type"::Mpesa) then begin
                "Paid AmountEditable" := false;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := true;
                // CurrForm.Balance.editable:=true;
            end
            else begin
                "Paid AmountEditable" := true;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := false;
                // CurrForm.Balance.editable:=true;
            end;
    end;

    var
        Student: Record Customer;
        BankLedger: Record "Bank Account Ledger Entry";
        SalesLine: Record "Menu Sales Line";
        Amt: Decimal;
        "Line No": Integer;
        MenuRec: Record "Daily Menu";
        MenuSale: Record "Menu Sale Header";
        GrnLine: Record "Gen. Journal Line";
        SaleSetUp: Record "Catering SetUp";
        Temp: Text[30];
        Batch: Text[30];
        [InDataSet]
        "Paid AmountEditable": Boolean;
        [InDataSet]
        BalanceEditable: Boolean;
        CateringL: Record "Catering Prepayment Ledger";
        GLEntry: Record "G/L Entry";
        LastEntry: Integer;
        "Customer NoEditable": Boolean;
        "Transaction NoEditable": Boolean;
        IsPosted: Boolean;
        UserSEtup: Record "User Setup";

    procedure UpdateCashBox()
    begin
        //------------------BKK--------------

        BankLedger.Reset;
        SalesLine.Reset;
        MenuRec.Reset;
        if (Rec."Customer Type" <> Rec."customer type"::Staff) and (Rec."Customer Type" <> Rec."customer type"::Department) then begin

            Amt := 0;
            Rec.TestField(Date);
            //TESTFIELD("Cashier No");
            Rec.TestField("Receiving Bank");
            //TESTFIELD("Paid Amount");
            if Rec.Balance < 0 then begin
                Error('The Paid Amount Is Less By ' + Format(Rec.Balance))
            end;
            if BankLedger.FindLast() then begin
                "Line No" := BankLedger."Entry No." + 1
            end
            else begin
                "Line No" := 1
            end;
            SalesLine.SetRange(SalesLine."Receipt No", Rec."Receipt No");
            if SalesLine.Find('-') then begin
                repeat
                    Amt := Amt + SalesLine.Amount;
                until SalesLine.Next = 0;
            end;

            if Amt = 0 then begin
                Error('There is Nothing In The Sales Line')
            end;

            BankLedger.Init;
            BankLedger."Entry No." := "Line No";
            BankLedger."Bank Account No." := Rec."Receiving Bank";
            BankLedger."Posting Date" := Rec.Date;
            BankLedger."Document No." := Rec."Receipt No";
            BankLedger.Description := Rec."Receipt No" + ' ' + Rec."Customer Name";
            BankLedger.Amount := Amt;
            BankLedger."Remaining Amount" := Amt;
            BankLedger."Amount (LCY)" := Amt;
            BankLedger."User ID" := Rec."Cashier No";
            BankLedger.Open := true;
            BankLedger."Document Date" := Rec.Date;
            BankLedger.Insert(true);
        end;
        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Receipt No", Rec."Receipt No");
        if SalesLine.Find('-') then begin
            repeat
                MenuRec.Reset;
                MenuRec.SetRange(MenuRec."Menu Date", Rec.Date);
                MenuRec.SetRange(MenuRec.Menu, SalesLine.Menu);
                // MenuRec.SETRANGE(MenuRec.Type,MenuRec.Type::Student);
                if MenuRec.Find('-') then begin
                    MenuRec."Remaining Qty" := MenuRec."Remaining Qty" - SalesLine.Quantity;
                    MenuRec.Modify;
                end;
            until SalesLine.Next = 0;
        end;

        //MESSAGE('Money Taken') ;
    end;

    procedure PostJrn() Posted: Boolean
    begin
        //  Posted:=FALSE;
        // TESTFIELD(Date) ;
        //TESTFIELD("Paid Amount");
        //TESTFIELD("Cashier);
        //TESTFIELD("Receiving Bank");

        Amt := 0;
        SalesLine.SetRange(SalesLine."Receipt No", Rec."Receipt No");
        if SalesLine.Find('-') then begin
            repeat
                Amt := Amt + SalesLine.Amount;
            until SalesLine.Next = 0;
        end;
        if Amt = 0 then begin
            Error('There is Nothing In The Sales Line')
        end;
        if SaleSetUp.Get() then begin
            Temp := SaleSetUp."Sales Template";
            Batch := SaleSetUp."Sales Batch";
            SaleSetUp.TestField(SaleSetUp."Catering Income Account");
            SaleSetUp.TestField(SaleSetUp."Catering Control Account");
            SaleSetUp.TestField(SaleSetUp."Cash Receiving Bank Account");
            SaleSetUp.TestField(SaleSetUp."MPESA Receiving Bank Account");
            SaleSetUp.TestField(SaleSetUp."PEPEA  Receiving Bank Account");
        end else begin
            //  ERROR('Please Fill The Catering SetUp')
        end;

        Rec."Receiving Bank" := SaleSetUp."Cash Receiving Bank Account";
        // IF ("Sales Type"="Sales Type"::Cash) OR ("Sales Type"="Sales Type"::Mpesa) OR  ("Sales Type"="Sales Type"::"Pepea Card") THEN BEGIN
        if (Rec."Sales Type" = Rec."sales type"::Cash) then begin
            Rec.TestField("Paid Amount");
            GrnLine.Reset;
            GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
            GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
            if GrnLine.Find('-') then begin
                GrnLine.DeleteAll;
            end;

            GrnLine.Init;
            GrnLine."Journal Template Name" := Temp;
            GrnLine."Journal Batch Name" := Batch;
            GrnLine."Line No." := "Line No";
            GrnLine."Account Type" := GrnLine."account type"::"Bank Account";
            GrnLine."Account No." := Rec."Receiving Bank";
            GrnLine."Posting Date" := Rec.Date;
            //GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Customer No" + '-Reversal';
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine."Bal. Account Type" := GrnLine."bal. account type"::"G/L Account";
            GrnLine.Amount := Amt * -1;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);

        end;


        if (Rec."Sales Type" = Rec."sales type"::Mpesa) then begin
            //"Receiving Bank":=SaleSetUp."MPESA Receiving Bank Account";
            Rec.TestField("Transaction No.");
            GrnLine.Reset;
            GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
            GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
            if GrnLine.Find('-') then begin
                GrnLine.DeleteAll;
            end;

            GrnLine.Init;
            GrnLine."Journal Template Name" := Temp;
            GrnLine."Journal Batch Name" := Batch;
            GrnLine."Line No." := "Line No";
            GrnLine."Account Type" := GrnLine."account type"::"Bank Account";
            GrnLine."Account No." := SaleSetUp."MPESA Receiving Bank Account";
            GrnLine."Posting Date" := Rec.Date;
            //GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Transaction No." + '-Reversal';
            ;
            GrnLine."Bal. Account Type" := GrnLine."bal. account type"::"G/L Account";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine.Amount := Amt * -1;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);
        end;

        if (Rec."Sales Type" = Rec."sales type"::"Pepea Card") then begin
            //"Receiving Bank":=SaleSetUp."PEPEA  Receiving Bank Account";
            //TESTFIELD("Paid Amount");
            GrnLine.Reset;
            GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
            GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
            if GrnLine.Find('-') then begin
                GrnLine.DeleteAll;
            end;

            GrnLine.Init;
            GrnLine."Journal Template Name" := Temp;
            GrnLine."Journal Batch Name" := Batch;
            GrnLine."Line No." := "Line No";
            GrnLine."Account Type" := GrnLine."account type"::"Bank Account";
            GrnLine."Account No." := SaleSetUp."PEPEA  Receiving Bank Account";
            GrnLine."Posting Date" := Rec.Date;
            //GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Transaction No." + '-Reversal';
            ;
            GrnLine."Bal. Account Type" := GrnLine."bal. account type"::"G/L Account";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine.Amount := Amt * -1;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);

        end;


        if Rec."Sales Type" = Rec."sales type"::Prepayment then begin
            // MenuSale.TESTFIELD(MenuSale."Customer No");
            Rec.CalcFields("Prepayment Balance");
            Rec.CalcFields(Amount);
            //IF ("Prepayment Balance"-Amount)<0 THEN ERROR('The Prepayment balance is not sufficient for the selected transaction');

            GrnLine.Reset;
            GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
            GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
            if GrnLine.Find('-') then begin
                GrnLine.DeleteAll;
            end;

            GrnLine.Init;
            GrnLine."Journal Template Name" := Temp;
            GrnLine."Journal Batch Name" := Batch;
            GrnLine."Line No." := "Line No";
            GrnLine."Account Type" := GrnLine."account type"::"G/L Account";
            GrnLine."Account No." := SaleSetUp."Catering Control Account";
            GrnLine."Posting Date" := Rec.Date;
            //GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Customer No" + '-Reversal';
            ;
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine."Bal. Account Type" := GrnLine."bal. account type"::"G/L Account";
            GrnLine.Amount := Amt * -1;
            Posted := true;
            Rec.Modify;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);

        end;
        if GLEntry.FindLast() then LastEntry := GLEntry."Entry No.";
        GrnLine.Reset;
        GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
        GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
        if GrnLine.Find('-') then begin
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2", GrnLine);
        end;
        // Confirm if posted
        if GLEntry.FindLast() then
            if LastEntry <> GLEntry."Entry No." then IsPosted := true;

        if IsPosted = true then begin
            if Rec."Sales Type" = Rec."sales type"::Prepayment then begin
                if CateringL.FindLast() then
                    "Line No" := "Line No" + 1;
                "Line No" := CateringL."Entry No";
                CateringL.Init;
                CateringL."Entry No" := "Line No" + 1;
                CateringL."Customer No" := Rec."Customer No";
                CateringL."Entry Type" := CateringL."entry type"::Consumption;
                CateringL.Date := Today;
                CateringL.Description := 'Food Sales-Reversal';
                ;
                CateringL.Amount := Rec.Amount;
                CateringL."User ID" := UserId;
                CateringL.Insert;

                SalesLine.Reset;
                SalesLine.SetRange(SalesLine."Receipt No", Rec."Receipt No");
                if SalesLine.Find('-') then begin
                    repeat
                        MenuRec.Reset;
                        MenuRec.SetRange(MenuRec."Menu Date", Rec.Date);
                        MenuRec.SetRange(MenuRec.Menu, SalesLine.Menu);
                        // MenuRec.SETRANGE(MenuRec.Type,MenuRec.Type::Student);
                        if MenuRec.Find('-') then begin
                            MenuRec."Remaining Qty" := MenuRec."Remaining Qty" + SalesLine.Quantity;

                            MenuRec.Modify;
                        end;
                    until SalesLine.Next = 0;
                end;
            end;
        end;
    end;

    // local procedure OnAfterGetCurrRecord()
    // begin
    //     xRec := Rec;
    //     //  "Customer Type":="Customer Type"::Student;
    //     "Cashier Name" := UserId;
    // end;
}

