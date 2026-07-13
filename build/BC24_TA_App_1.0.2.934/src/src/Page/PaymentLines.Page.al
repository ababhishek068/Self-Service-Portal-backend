Page 50889 "Payment Lines"
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
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(DocumentNo; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Document No field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }

                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(DocumentLine; Rec."Document Line")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Document Line field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No. field.';


                    trigger OnValidate()
                    var
                        BudgetControl: Record "Budgetary Control Setup";
                    begin
                        BudgetControl.get;
                        Rec.setfilter("Date Filter", '%1..%2', BudgetControl."Current Budget Start Date", BudgetControl."Current Budget End Date");
                        Rec.CalcFields("Budgeted Amount");
                        Rec.CalcFields("Committed Amount");
                        //CalcFields("Actual Expenditure");

                    end;
                }

                field(PayMode; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Grouping field.';
                }
                field(AccountName; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(Narration; Rec."Transaction Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Narration';
                    ToolTip = 'Specifies the value of the Narration field.';
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


                    end;
                }
                field("Budget Control A/C"; Rec."Budget Control A/C")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Control A/C field.';
                }
                field(NotVatable; Rec."Not Vatable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Not Vatable field.';
                }
                field(VATWithheldAmount; Rec."VAT Withheld Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Withheld Amount field.';
                }
                field(VATWithheldCode; Rec."VAT Withheld Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Withheld Code field.';
                }
                field(VATSixRate; Rec."VAT Six % Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Six % Rate field.';
                }

                field(WithholdingTaxCode; Rec."Withholding Tax Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Code field.';
                }
                field(NetAmount; Rec."Net Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Net Amount field.';
                }
                field(BudgetGLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Budget G/L Account';
                    ToolTip = 'Specifies the value of the Budget G/L Account field.';
                }
                field(BudgetedAmount; Rec."Budgeted Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field(ActualExpenditure; Rec."Actual Expenditure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Expenditure field.';
                }
                field(CommittedAmount; Rec."Committed Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed Amount field.';
                }
                field(Balances; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Balances';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Balances field.';
                }
                field("Council No."; Rec."Council No.")
                {
                    Caption = 'Board Member No.';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Board Member No. field.';
                }

                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(WithholdingTaxAmount; Rec."Withholding Tax Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Amount field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(AppliestoDocType; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Applies-to Doc. Type field.';
                }
                field(AppliestoDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';
                }
                field(AppliestoID; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applies-to ID field.';
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Committed field.';
                }
                field(BudgetaryControlAC; Rec."Budgetary Control A/C")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budgetary Control A/C field.';
                }
                field(VATCode; Rec."VAT Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the VAT Code field.';
                }
                field(VATRate; Rec."VAT Rate")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the VAT Rate field.';
                }
                field(VATAmount; Rec."VAT Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Amount field.';
                }
                field(RetentionCode; Rec."Retention Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retention Code field.';
                }
                field("Excise Code"; Rec."Excise Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Excise Code field.';
                }
                field("PAYE Code"; Rec."PAYE Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PAYE Code field.';
                }
                field("PAYE Rate"; Rec."PAYE Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PAYE Rate field.';
                }
                field("PAYE Amount"; Rec."PAYE Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PAYE Amount field.';
                }
                field(RetentionAmount; Rec."Retention  Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retention  Amount field.';
                }
                field("Excise  Amount"; Rec."Excise  Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Excise  Amount field.';
                }
                field("Excise Rate"; Rec."Excise Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Excise Rate field.';
                }
                field(CommisionAmount; Rec."Commision Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Commision Amount field.';
                }
                field("Shift No"; Rec."Shift No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shift No field.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Include in VAT"; Rec."Include in VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Include in VAT field.';
                }

                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        BudgetControl: Record "Budgetary Control Setup";
    begin
        BudgetControl.get;
        Rec.setfilter("Date Filter", '%1..%2', BudgetControl."Current Budget Start Date", BudgetControl."Current Budget End Date");
        Rec.CalcFields("Budgeted Amount");
        Rec.CalcFields("Committed Amount");
        //CalcFields("Actual Expenditure");

    end;

    procedure GetDocNo(): Code[20]
    begin
        //EXIT("Inv Doc No");
    end;
}

