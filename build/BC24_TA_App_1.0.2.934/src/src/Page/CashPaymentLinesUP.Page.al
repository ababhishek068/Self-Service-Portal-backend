Page 50884 "Cash Payment Lines UP"
{
    PageType = ListPart;
    SourceTable = "Payment Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                    trigger OnValidate()
                    begin
                        if Rec."Account Type" = Rec."Account Type"::"G/L Account" then begin
                            GroupingVisible := false
                        end else
                            GroupingVisible := true;

                        CurrPage.Update();
                    end;
                }
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = GroupingVisible;
                    ToolTip = 'Specifies the value of the Grouping field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(AccountName; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';

                    trigger OnValidate()
                    begin
                        //check if the payment reference is for farmer purchase
                        if Rec."Payment Reference" = Rec."payment reference"::"Farmer Purchase" then begin
                            if Rec.Amount <> xRec.Amount then begin
                                Error('Amount cannot be modified');
                            end;
                        end;

                        Rec."Amount With VAT" := Rec.Amount;
                        if Rec."Account Type" in [Rec."account type"::Customer, Rec."account type"::Vendor,
                        Rec."account type"::"G/L Account", Rec."account type"::"Bank Account", Rec."account type"::"Fixed Asset"] then
                            case Rec."Account Type" of
                                Rec."account type"::"G/L Account":
                                    begin

                                        Rec.TestField(Amount);
                                        RecPayTypes.Reset;
                                        RecPayTypes.SetRange(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        if RecPayTypes.Find('-') then begin
                                            if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then begin
                                                RecPayTypes.TestField(RecPayTypes."VAT Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                if TarriffCodes.Find('-') then begin
                                                    Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                end;
                                            end
                                            else begin
                                                Rec."VAT Amount" := 0;
                                            end;

                                            if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."withholding tax chargeable"::Yes then begin
                                                RecPayTypes.TestField(RecPayTypes."Withholding Tax Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                if TarriffCodes.Find('-') then begin
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."Withholding Tax Amount" := (Rec.Amount - Rec."VAT Amount") * (TarriffCodes.Percentage / 100);
                                                end;
                                            end
                                            else begin
                                                Rec."Withholding Tax Amount" := 0;
                                            end;
                                        end;
                                    end;
                                Rec."account type"::Customer:
                                    begin

                                        Rec.TestField(Amount);
                                        RecPayTypes.Reset;
                                        RecPayTypes.SetRange(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        if RecPayTypes.Find('-') then begin
                                            if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then begin
                                                Rec.TestField("VAT Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, Rec."VAT Code");
                                                if TarriffCodes.Find('-') then begin
                                                    //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    //
                                                end;
                                            end
                                            else begin
                                                Rec."VAT Amount" := 0;
                                            end;

                                            if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."withholding tax chargeable"::Yes then begin
                                                Rec.TestField("Withholding Tax Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, Rec."Withholding Tax Code");
                                                if TarriffCodes.Find('-') then begin
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;

                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");

                                                end;
                                            end
                                            else begin
                                                Rec."Withholding Tax Amount" := 0;
                                            end;
                                        end;



                                    end;
                                Rec."account type"::Vendor:
                                    begin

                                        Rec.TestField(Amount);
                                        RecPayTypes.Reset;
                                        RecPayTypes.SetRange(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        if RecPayTypes.Find('-') then begin
                                            if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then begin
                                                Rec.TestField("VAT Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, Rec."VAT Code");
                                                if TarriffCodes.Find('-') then begin
                                                    Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    //
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    //
                                                end;
                                            end
                                            else begin
                                                Rec."VAT Amount" := 0;
                                            end;

                                            if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."withholding tax chargeable"::Yes then begin
                                                Rec.TestField("Withholding Tax Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, Rec."Withholding Tax Code");
                                                if TarriffCodes.Find('-') then begin
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    //
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                    //
                                                end;
                                            end
                                            else begin
                                                Rec."Withholding Tax Amount" := 0;
                                            end;
                                        end;


                                    end;
                                Rec."account type"::"Bank Account":
                                    begin

                                        Rec.TestField(Amount);
                                        RecPayTypes.Reset;
                                        RecPayTypes.SetRange(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        if RecPayTypes.Find('-') then begin
                                            if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then begin
                                                RecPayTypes.TestField(RecPayTypes."VAT Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                if TarriffCodes.Find('-') then begin
                                                    //
                                                    Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    //
                                                end;
                                            end
                                            else begin
                                                Rec."VAT Amount" := 0;
                                            end;

                                            if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."withholding tax chargeable"::Yes then begin
                                                RecPayTypes.TestField(RecPayTypes."Withholding Tax Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                if TarriffCodes.Find('-') then begin
                                                    //
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                    //
                                                end;
                                            end
                                            else begin
                                                Rec."Withholding Tax Amount" := 0;
                                            end;
                                        end;


                                    end;
                                Rec."account type"::"Fixed Asset":
                                    begin

                                        Rec.TestField(Amount);
                                        RecPayTypes.Reset;
                                        RecPayTypes.SetRange(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        if RecPayTypes.Find('-') then begin
                                            if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then begin
                                                RecPayTypes.TestField(RecPayTypes."VAT Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                if TarriffCodes.Find('-') then begin
                                                    //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                end;
                                            end
                                            else begin
                                                Rec."VAT Amount" := 0;
                                            end;

                                            if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."withholding tax chargeable"::Yes then begin
                                                RecPayTypes.TestField(RecPayTypes."Withholding Tax Code");
                                                TarriffCodes.Reset;
                                                TarriffCodes.SetRange(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                if TarriffCodes.Find('-') then begin
                                                    //
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                    //
                                                end;
                                            end
                                            else begin
                                                Rec."Withholding Tax Amount" := 0;
                                            end;
                                        end;


                                    end;
                            end;


                        Rec."Net Amount" := Rec.Amount - Rec."Withholding Tax Amount";
                        Rec.Validate("Net Amount");
                    end;
                }
                field(NetAmount; Rec."Net Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Net Amount field.';
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    caption = 'Payment Narration';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Narration field.';

                }
                field("Shift No"; Rec."Shift No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shift No field.';

                }
                field(ApplytoID; Rec."Apply to ID")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Lookup = true;
                    ToolTip = 'Specifies the value of the Apply to ID field.';
                }

                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field("Committed Amount"; Rec."Committed Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed Amount field.';
                }
                field("Actual Expenditure"; Rec."Actual Expenditure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Expenditure field.';
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        BudgetConRec: Record "Budgetary Control Setup";
    begin
        BudgetConRec.get;
        Rec.SetFilter("Date Filter", '%1..%2', BudgetConRec."Current Budget Start Date", BudgetConRec."Current Budget End Date");
        Rec.CalcFields("Committed Amount");
        Rec.CalcFields("Budgeted Amount");
        Rec.CalcFields("Actual Expenditure");
    end;


    var
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes";
        GroupingVisible: Boolean;
}

