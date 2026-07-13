Page 51289 "PR Transaction Code Card"
{
    PageType = Card;
    SourceTable = "PR Transaction Codes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field(TransactionCode; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }

                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }

                field(Frequency; Rec."Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Frequency field.';
                }

                field(BalanceType; Rec."Balance Type")
                {
                    ApplicationArea = All;
                    ValuesAllowed = None, Increasing, Reducing;
                    ToolTip = 'Specifies the value of the Balance Type field.';
                }
                field(Taxable; Rec.Taxable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Taxable field.';
                }


                field(DisableProration; Rec."Disable Proration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disable Proration field.';
                }

                field("Skip Transfer in Next Period"; Rec."Skip Transfer in Next Period")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Skip Transfer in Next Period field.';
                }
                field("Transaction Charge Code"; Rec."Transaction Charge Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction Charge Code field.';
                }
                field(IsFormula; Rec."Is Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Formula field.';
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Formula field.';
                }
                field("Formula %"; Rec."Formula %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Formula % field.';
                }

                field("Is Formula for employer"; Rec."Is Formula for employer")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Formula for employer field.';
                }

                field(GLAccount; Rec."GL Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field(GLAccountName; Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the G/L Account Name field.';
                }
                field(Transportallowancecalculation;Transportallowancecalculation){
                    Caption='Use for statutory transport allowance?';
                }
                field(Subledger; Rec.Subledger)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Subledger field.';
                }
                field(CustomerPostingGroup; Rec.CustomerPostingGroup)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CustomerPostingGroup field.';
                }
                field("Imprest Surrender"; Rec."Imprest Surrender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Surrender field.';
                }
                field("Is Leave Allowance"; Rec."Is Leave Allowance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Leave Allowance field.';
                }
                field(isHouseAllowance; Rec.isHouseAllowance)
                {
                    caption = 'Is House Allowance';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is House Allowance field.';
                }
            }
            group(OtherSetUps)
            {
                Caption = 'Other Set-Ups';
                field(SpecialTransDeductions; Rec."Special Trans Deductions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Trans Deductions field.';
                }
                field(SpecialTransIncomes; Rec."Special Trans Incomes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Trans Incomes field.';
                }
                field(RepaymentMethod; Rec."Repayment Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repayment Method field.';
                }
                field(coopparameters; Rec."coop parameters")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Categorization field.';
                }

                field("Deduct Premium"; Rec."Deduct Premium")
                {
                    ToolTip = 'Specifies the value of the Deduct Premium field.';

                }

                field("Intrest Transaction Code"; Rec."Intrest Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Intrest Transaction Code field.';

                }

                field("Interest Rate"; Rec."Interest Rate")
                {
                    ToolTip = 'Specifies the value of the Interest Rate field.';

                }
            }
            group(Grouping)
            {
                Caption = 'Grouping';
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = All;
                    TableRelation = "PR Transaction Codes";
                    ToolTip = 'Specifies the value of the Group Code field.';
                }
                field(GroupDescription; Rec."Group Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group Description field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Assign Formulae Per Directorate")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "PR Transaction Formula List";
                RunPageLink = "Transaction Code" = field("Transaction Code");
                ToolTip = 'Executes the Assign Formulae Per Directorate action.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateControl_SpecialTrans
    end;

    var
        IsFormulaPerDirecEDITABLE: Boolean;

    local procedure UpdateControl_SpecialTrans()
    begin
        if Rec."Is Formula Per Directorate" then begin
            IsFormulaPerDirecEDITABLE := false;

            Rec."Is Formula" := false;
            Rec."Employer Deduction" := false;
            Rec."Include Employer Deduction" := false;
            Rec."Is Formula for employer" := '';
            Rec.Formula := '';
        end else begin
            IsFormulaPerDirecEDITABLE := true;
        end;
    end;
}

