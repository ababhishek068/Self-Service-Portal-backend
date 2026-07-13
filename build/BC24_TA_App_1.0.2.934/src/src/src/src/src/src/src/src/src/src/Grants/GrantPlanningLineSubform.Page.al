Page 50065 "Grant Planning Line Subform"
{
    AutoSplitKey = true;
    Caption = 'Grant Budget Line Subform';
    DataCaptionExpression = Rec.Caption;
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Job-Planning Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Editable = TypeEditable;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(DonorExpenseCode; Rec."Donor Expense Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Donor Expense Code field.';
                }
                field(PlanningDate; Rec."Planning Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Planning Date field.';
                }
                field(BudgetPeriod; Rec."Budget Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Period field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expense Account field.';

                }
                field(Restriction; Rec.Restriction)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Restriction field.';
                }
                field(GrantContractEntryNo; Rec."Grant Contract Entry No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grant Contract Entry No.';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Grant Contract Entry No. field.';
                }
                field(PendingdonorIssues; Rec."Pending donor Issues")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pending donor Issues field.';
                }
                field(Budgetinuse; Rec."Budget in use")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget in use field.';
                }
                field(SpecialConditionforTravel; Rec."Special Condition for Travel")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Special Condition for Travel field.';
                }
                field(AuditProvision; Rec."Audit Provision")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Audit Provision field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(CurrencyDate; Rec."Currency Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Currency DateEditable";
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Date field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = DescriptionEditable;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Partner; Rec.Partner)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Partner field.';
                }
                field(BudgetGroupingCode; Rec."Budget Grouping Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Grouping Code field.';
                }
                field(IncomeAccount; Rec."Income Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Income Account field.';
                }
                field(Description3; Rec."Description 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description 3 field.';
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Variant CodeEditable";
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Location CodeEditable";
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field(WorkTypeCode; Rec."Work Type Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Work Type CodeEditable";
                    Visible = false;
                    ToolTip = 'Specifies the value of the Work Type Code field.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Unit of Measure CodeEditable";
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = QuantityEditable;
                    ToolTip = 'Specifies the value of the Quantity field.';

                    trigger OnValidate()
                    begin
                        //Check if quantity is less than zero
                        if (Rec.Quantity <= 0) then
                            Error('Quantity should not be less than 0');
                        // END
                    end;
                }
                field(DirectUnitCostLCY; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Direct Unit Cost (LCY) field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = "Unit CostEditable";
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(UnitCostLCY; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost (LCY) field.';
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field(TotalCostLCY; Rec."Total Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Cost (LCY) field.';
                }
                field(OwnContribution; Rec."ICIPE Contribution")
                {
                    ApplicationArea = Basic;
                    Caption = '<Own Contribution>';
                    ToolTip = 'Specifies the value of the <Own Contribution> field.';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = "Unit PriceEditable";
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(UnitPriceLCY; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit Price (LCY) field.';
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    Editable = "Line AmountEditable";
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field(LineAmountLCY; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line Amount (LCY) field.';
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Editable = "Line Discount AmountEditable";
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line Discount Amount field.';
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    Editable = "Line Discount %Editable";
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line Discount % field.';
                }
                field(TotalPrice; Rec."Total Price")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total Price field.';
                }
                field(TotalPriceLCY; Rec."Total Price (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total Price (LCY) field.';
                }
                field(InvoicedAmountLCY; Rec."Invoiced Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Invoiced Amount (LCY) field.';
                }
                field(InvoicedCostAmountLCY; Rec."Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Invoiced Cost Amount (LCY) field.';
                }
                field(InvoiceType; Rec."Invoice Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
                field(InvoiceNo; Rec."Invoice No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Invoiced field.';
                }
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Transferred field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(GrantTaskNo; Rec."Grant Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grant Task No. field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CreateSalesInvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create &Sales Invoice';
                    Ellipsis = true;
                    Image = Invoice;
                    ToolTip = 'Executes the Create &Sales Invoice action.';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #39004417. Unsupported part was commented. Please check it.
                        /*CurrPage.PlanningLines.FORM.*/
                        _CreateSalesInvoice(false);

                    end;
                }
                action(CreateSalesCreditMemo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Sales &Credit Memo';
                    Ellipsis = true;
                    Image = CreditMemo;
                    ToolTip = 'Executes the Create Sales &Credit Memo action.';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #39004417. Unsupported part was commented. Please check it.
                        /*CurrPage.PlanningLines.FORM.*/
                        _CreateSalesInvoice(true);

                    end;
                }
                action(GetSalesInvoiceCreditMemo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Sales Invoice/Credit Memo';
                    Ellipsis = true;
                    ToolTip = 'Executes the Get Sales Invoice/Credit Memo action.';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #39004417. Unsupported part was commented. Please check it.
                        /*CurrPage.PlanningLines.FORM.*/
                        GetInvoice;

                    end;
                }
            }
        }
    }



    trigger OnInit()
    begin
        "Unit CostEditable" := true;
        "Line AmountEditable" := true;
        "Line Discount %Editable" := true;
        "Line Discount AmountEditable" := true;
        "Unit PriceEditable" := true;
        "Work Type CodeEditable" := true;
        "Location CodeEditable" := true;
        "Variant CodeEditable" := true;
        "Unit of Measure CodeEditable" := true;
        QuantityEditable := true;
        DescriptionEditable := true;
        "No.Editable" := true;
        TypeEditable := true;
        "Currency DateEditable" := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField(Transferred, false);

        if Rec."System-Created Entry" = true then
            if not Confirm(Text001, false) then
                Error('')
            else
                Rec."System-Created Entry" := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);

    end;

    var
        Text001: label 'This Job Planning Line is generated automatically. Do you want to continue?';
        [InDataSet]
        "Currency DateEditable": Boolean;
        [InDataSet]
        TypeEditable: Boolean;
        [InDataSet]
        "No.Editable": Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        QuantityEditable: Boolean;
        [InDataSet]
        "Unit of Measure CodeEditable": Boolean;
        [InDataSet]
        "Variant CodeEditable": Boolean;
        [InDataSet]
        "Location CodeEditable": Boolean;
        [InDataSet]
        "Work Type CodeEditable": Boolean;
        [InDataSet]
        "Unit PriceEditable": Boolean;
        [InDataSet]
        "Line Discount AmountEditable": Boolean;
        [InDataSet]
        "Line Discount %Editable": Boolean;
        [InDataSet]
        "Line AmountEditable": Boolean;
        [InDataSet]
        "Unit CostEditable": Boolean;

    procedure _CreateSalesInvoice(CrMemo: Boolean)
    var
        JobPlanningLine: Record "Job-Planning Line";
    //JobCreateInvoice: Codeunit "HR Leave Jnl.-Post";
    begin
        Rec.TestField("Line No.");
        JobPlanningLine.Copy(Rec);
        CurrPage.SetSelectionFilter(JobPlanningLine);
        //JobCreateInvoice.CreateSalesInvoice(JobPlanningLine,CrMemo)
    end;

    procedure CreateSalesInvoice(CrMemo: Boolean)
    var
        JobPlanningLine: Record "Job-Planning Line";
    // JobCreateInvoice: Codeunit UnknownCodeunit70134686;
    begin
        Rec.TestField("Line No.");
        JobPlanningLine.Copy(Rec);
        CurrPage.SetSelectionFilter(JobPlanningLine);
        //JobCreateInvoice.CreateSalesInvoice(JobPlanningLine,CrMemo)
    end;

    local procedure SetEditable(Edit: Boolean)
    begin
        //CurrForm."Line Type".EDITABLE := Edit;
        //CurrForm."Planning Date".EDITABLE := Edit;
        "Currency DateEditable" := Edit;
        //CurrForm."Document No.".EDITABLE := Edit;
        TypeEditable := Edit;
        "No.Editable" := Edit;
        DescriptionEditable := Edit;
        QuantityEditable := Edit;
        "Unit of Measure CodeEditable" := Edit;
        "Variant CodeEditable" := Edit;
        "Location CodeEditable" := Edit;
        "Work Type CodeEditable" := Edit;
        "Unit PriceEditable" := Edit;
        "Line Discount AmountEditable" := Edit;
        "Line Discount %Editable" := Edit;
        "Line AmountEditable" := Edit;
        "Unit CostEditable" := Edit;
    end;

    procedure GetInvoice()
    var
    // JobCreateInvoice: Codeunit UnknownCodeunit70134686;
    begin
        //JobCreateInvoice.GetSalesInvoice(Rec);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        SetEditable(not Rec.Transferred);
    end;
}

