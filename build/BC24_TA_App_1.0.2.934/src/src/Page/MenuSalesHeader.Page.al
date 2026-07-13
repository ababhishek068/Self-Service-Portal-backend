page 50740 "Menu Sales Header"
{
    PageType = Document;
    SourceTable = "Menu Sale Header";
    SourceTableView = WHERE(Posted = CONST(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Receipt No"; Rec."Receipt No")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receipt No field.';
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sales Type field.';
                    trigger OnValidate()
                    begin

                        if (Rec."Sales Type" = Rec."Sales Type"::Prepayment) then begin
                            "Paid AmountEditable" := false;
                            "Customer NoEditable" := true;
                            "Transaction NoEditable" := false;
                        end
                        else
                            if (Rec."Sales Type" = Rec."Sales Type"::"Pepea Card") or (Rec."Sales Type" = Rec."Sales Type"::"Card Payments") or (Rec."Sales Type" = Rec."Sales Type"::Mpesa) or (Rec."Sales Type" = Rec."Sales Type"::Credit) then begin
                                "Paid AmountEditable" := false;
                                "Customer NoEditable" := false;
                                "Transaction NoEditable" := true;
                                // CurrForm.Balance.editable:=true;
                            end
                            else
                                if (Rec."Sales Type" = Rec."Sales Type"::"Other Sales") then begin
                                    "Paid AmountEditable" := true;
                                    "Customer NoEditable" := false;
                                    "Transaction NoEditable" := true;
                                end

                                else begin
                                    "Paid AmountEditable" := true;
                                    "Customer NoEditable" := false;
                                    "Transaction NoEditable" := false;
                                    // CurrForm.Balance.editable:=true;
                                end;
                    end;
                }
                field("BarCode No."; Rec."BarCode No.")
                {
                    ApplicationArea = basic;
                    Editable = "Customer NoEditable";
                    ToolTip = 'Specifies the value of the BarCode No. field.';
                }
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = basic;
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
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Prepayment Balance"; Rec."Prepayment Balance")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Prepayment Balance field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Cashier Name"; Rec."Cashier Name")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cashier Name field.';
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    Editable = BalanceEditable;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = basic;
                    Editable = "Transaction NoEditable";
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
            part(Control1000000000; "Menu Sales Line")
            {
                ApplicationArea = basic;
                SubPageLink = "Receipt No" = FIELD("Receipt No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Preview Receipt")
            {
                Caption = 'Preview Receipt';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ToolTip = 'Executes the Preview Receipt action.';

                trigger OnAction()
                begin
                    MenuSale.Reset;
                    MenuSale.SetRange(MenuSale."Receipt No", Rec."Receipt No");
                    if MenuSale.Find('-') then
                        REPORT.Run(70135503, true, true, MenuSale);
                end;
            }
            action("Post / Receipt")
            {
                Caption = 'Post / Receipt';
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F12';
                ApplicationArea = basic;
                ToolTip = 'Executes the Post / Receipt action.';
                trigger OnAction()
                begin

                    if PostJrn() = true then begin
                        MenuSale.Reset;
                        MenuSale.SetFilter(MenuSale."Receipt No", Rec."Receipt No");
                        if MenuSale.Find('-') then
                            REPORT.Run(70135503, false, false, MenuSale);

                        MenuSale.Reset;
                        MenuSale.SetFilter(MenuSale."Receipt No", Rec."Receipt No");
                        if MenuSale.Find('-') then begin

                            MenuSale.CalcFields(Amount);
                            MenuSale."Line Amount" := MenuSale.Amount;
                            MenuSale.Posted := true;
                            MenuSale.Modify;
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

        if (Rec."Sales Type" = Rec."Sales Type"::Prepayment) then begin
            "Paid AmountEditable" := false;
            "Customer NoEditable" := true;
            "Transaction NoEditable" := false;
        end
        else
            if (Rec."Sales Type" = Rec."Sales Type"::"Pepea Card") or (Rec."Sales Type" = Rec."Sales Type"::Mpesa) or (Rec."Sales Type" = Rec."Sales Type"::Credit) or (Rec."Sales Type" = Rec."Sales Type"::"Card Payments") then begin
                "Paid AmountEditable" := false;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := true;
                // CurrForm.Balance.editable:=true;
            end
            else
                if (Rec."Sales Type" = Rec."Sales Type"::"Other Sales") then begin
                    "Paid AmountEditable" := true;
                    "Customer NoEditable" := false;
                    "Transaction NoEditable" := true;
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
        Rec."Sales Type" := Rec."Sales Type"::Cash;

        Rec."Cashier Name" := UserId;
        Rec."Sales Point" := 'MESS';
        if (Rec."Sales Type" = Rec."Sales Type"::Prepayment) then begin
            "Paid AmountEditable" := false;
            "Customer NoEditable" := true;
            "Transaction NoEditable" := false;
        end
        else
            if (Rec."Sales Type" = Rec."Sales Type"::"Pepea Card") or (Rec."Sales Type" = Rec."Sales Type"::"Card Payments") or (Rec."Sales Type" = Rec."Sales Type"::Mpesa) or (Rec."Sales Type" = Rec."Sales Type"::Credit) then begin
                "Paid AmountEditable" := false;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := true;
                // CurrForm.Balance.editable:=true;
            end
            else
                if (Rec."Sales Type" = Rec."Sales Type"::"Other Sales") then begin
                    "Paid AmountEditable" := true;
                    "Customer NoEditable" := false;
                    "Transaction NoEditable" := true;
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

        if (Rec."Sales Type" = Rec."Sales Type"::Prepayment) then begin
            "Paid AmountEditable" := false;
            "Customer NoEditable" := true;
            "Transaction NoEditable" := false;
        end
        else
            if (Rec."Sales Type" = Rec."Sales Type"::"Pepea Card") or (Rec."Sales Type" = Rec."Sales Type"::"Card Payments") or (Rec."Sales Type" = Rec."Sales Type"::Mpesa) or (Rec."Sales Type" = Rec."Sales Type"::Credit) then begin
                "Paid AmountEditable" := false;
                "Customer NoEditable" := false;
                "Transaction NoEditable" := true;
                // CurrForm.Balance.editable:=true;
            end
            else
                if (Rec."Sales Type" = Rec."Sales Type"::"Other Sales") then begin
                    "Paid AmountEditable" := true;
                    "Customer NoEditable" := false;
                    "Transaction NoEditable" := true;
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

    procedure UpdateCashBox()
    begin
        //------------------BKK--------------

        BankLedger.Reset;
        SalesLine.Reset;
        MenuRec.Reset;
        if (Rec."Customer Type" <> Rec."Customer Type"::Staff) and (Rec."Customer Type" <> Rec."Customer Type"::Department) then begin

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
        Posted := false;
        Rec.TestField(Date);
        if Rec.Balance < 0 then begin
            Error('The Paid Amount Is Less By ' + Format(Rec.Balance))
        end;

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
            //SaleSetUp.TESTFIELD(SaleSetUp."PEPEA  Receiving Bank Account");
            SaleSetUp.TestField(SaleSetUp."Card Payments Bank Account");
            //SaleSetUp.TESTFIELD(SaleSetUp."Enterprise Meals Exp Account");


            if Rec."Sales Type" = Rec."Sales Type"::Credit then
                SaleSetUp.TestField(SaleSetUp."Department Meals Exp. Account");
        end else begin
            Error('Please Fill The Catering SetUp')
        end;

        Rec."Receiving Bank" := SaleSetUp."Cash Receiving Bank Account";
        if (Rec."Sales Type" = Rec."Sales Type"::Cash) then begin
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
            GrnLine."Account Type" := GrnLine."Account Type"::"Bank Account";
            GrnLine."Account No." := Rec."Receiving Bank";
            GrnLine."Posting Date" := Rec.Date;
            ////GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Customer No";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine.Amount := Amt;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);
        end;

        if (Rec."Sales Type" = Rec."Sales Type"::"Other Sales") then begin
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
            GrnLine."Account Type" := GrnLine."Account Type"::"Bank Account";
            GrnLine."Account No." := Rec."Receiving Bank";
            GrnLine."Posting Date" := Rec.Date;
            ////GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Cash Sale -' + Rec."Transaction No.";
            GrnLine."Bal. Account No." := SaleSetUp."Other Sales Exp Account";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine.Amount := Amt;
            GrnLine.Insert(true);
        end;



        if (Rec."Sales Type" = Rec."Sales Type"::Mpesa) then begin
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
            GrnLine."Account Type" := GrnLine."Account Type"::"Bank Account";
            GrnLine."Account No." := SaleSetUp."MPESA Receiving Bank Account";
            GrnLine."Posting Date" := Rec.Date;
            ////GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Transaction No.";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine.Amount := Amt;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);
        end;

        if (Rec."Sales Type" = Rec."Sales Type"::Credit) then begin
            //"Receiving Bank":=SaleSetUp."MPESA Receiving Bank Account";

            Rec.TestField(Department);
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
            GrnLine."Account Type" := GrnLine."Account Type"::"G/L Account";
            GrnLine."Account No." := SaleSetUp."Department Meals Exp. Account";
            GrnLine."Posting Date" := Rec.Date;
            ////GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec.Department + ' - Department ' + Rec."Transaction No.";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine.Amount := Amt;
            // GrnLine."Shortcut Dimension 1 Code":='M;
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            GrnLine."Shortcut Dimension 2 Code" := Rec.Department;
            GrnLine.Validate(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);
        end;

        if (Rec."Sales Type" = Rec."Sales Type"::Enterprise) then begin
            //"Receiving Bank":=SaleSetUp."MPESA Receiving Bank Account";

            Rec.TestField(Department);
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
            GrnLine."Account Type" := GrnLine."Account Type"::"G/L Account";
            GrnLine."Account No." := SaleSetUp."Enterprise Meals Exp Account";
            GrnLine."Posting Date" := Rec.Date;
            ////GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec.Department + ' - Department ' + Rec."Transaction No.";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine.Amount := Amt;
            // GrnLine."Shortcut Dimension 1 Code":='M;
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            GrnLine."Shortcut Dimension 2 Code" := Rec.Department;
            GrnLine.Validate(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);
        end;



        if (Rec."Sales Type" = Rec."Sales Type"::"Pepea Card") then begin
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
            GrnLine."Account Type" := GrnLine."Account Type"::"Bank Account";
            GrnLine."Account No." := SaleSetUp."PEPEA  Receiving Bank Account";
            GrnLine."Posting Date" := Rec.Date;
            ////GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Transaction No.";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine.Amount := Amt;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);

        end;

        if (Rec."Sales Type" = Rec."Sales Type"::"Card Payments") then begin
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
            GrnLine."Account Type" := GrnLine."Account Type"::"Bank Account";
            GrnLine."Account No." := SaleSetUp."Card Payments Bank Account";
            GrnLine."Posting Date" := Rec.Date;
            ////GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Transaction No.";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine.Amount := Amt;
            //GrnLine."Shortcut Dimension 1 Code":='MAIN';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);

        end;



        if Rec."Sales Type" = Rec."Sales Type"::Prepayment then begin

            Rec.CalcFields("Prepayment Balance");
            Rec.CalcFields(Amount);
            if (Rec."Prepayment Balance" - Rec.Amount) < 0 then Error('The Prepayment balance is not sufficient for the selected transaction');
            if Student."Catering Blocked" = true then Error('Account is blocked. Please Consult Enterprise Finance');

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
            GrnLine."Account Type" := GrnLine."Account Type"::"G/L Account";
            GrnLine."Account No." := SaleSetUp."Catering Control Account";
            GrnLine."Posting Date" := Rec.Date;
            //GrnLine."Document Type" := 0;
            GrnLine."Document No." := Rec."Receipt No";
            GrnLine.Description := 'Food Sale - ' + Rec."Customer No";
            GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
            GrnLine."Bal. Account Type" := GrnLine."Bal. Account Type"::"G/L Account";
            GrnLine.Amount := Amt;
            Posted := true;
            Rec.Modify;
            GrnLine."Shortcut Dimension 1 Code" := 'MAIN';
            GrnLine.Validate(GrnLine."Shortcut Dimension 1 Code");
            // GrnLine."Shortcut Dimension 3 Code":='170';
            // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
            GrnLine.Insert(true);

        end;
        if GLEntry.FindLast() then LastEntry := GLEntry."Entry No.";
        GrnLine.Reset;
        GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
        GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
        if GrnLine.Find('-') then begin
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post B2", GrnLine);
        end;
        // Confirm if posted
        if GLEntry.FindLast() then
            if LastEntry <> GLEntry."Entry No." then Posted := true;

        if Posted = true then begin
            if Rec."Sales Type" = Rec."Sales Type"::Prepayment then begin
                if CateringL.FindLast() then
                    "Line No" := "Line No" + 1;
                "Line No" := CateringL."Entry No";
                CateringL.Init;
                CateringL."Entry No" := "Line No" + 1;
                CateringL."Customer No" := Rec."Customer No";
                CateringL."Entry Type" := CateringL."Entry Type"::Consumption;
                CateringL.Date := Today;
                CateringL.Description := 'Food Sales';
                CateringL.Amount := Rec.Amount * -1;
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
                            MenuRec."Remaining Qty" := MenuRec."Remaining Qty" - SalesLine.Quantity;
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

