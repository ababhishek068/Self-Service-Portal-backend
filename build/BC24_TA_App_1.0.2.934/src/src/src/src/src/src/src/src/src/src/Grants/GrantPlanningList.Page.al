Page 50217 "Grant Planning List"
{
    AutoSplitKey = true;
    Caption = 'Grant Budget List';
    DataCaptionExpression = Rec.Caption;
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Job-Planning Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line Type field.';
                }
                field(BudgetPeriod; Rec."Budget Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Period field.';
                }
                field(GrantNo; Rec."Grant No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grant No.';
                    ToolTip = 'Specifies the value of the Grant No. field.';
                }
                field(GrantTaskNo; Rec."Grant Task No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grant Task No.';
                    ToolTip = 'Specifies the value of the Grant Task No. field.';
                }
                field(TotalYear1; Rec."Total Year 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Year 1 field.';
                }
                field(TotalYear2; Rec."Total Year 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Year 2 field.';
                }
                field(TotalYear3; Rec."Total Year 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Year 3 field.';
                }
                field(TotalYear4; Rec."Total Year 4")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Year 4 field.';
                }
                field(TotalYear5; Rec."Total Year 5")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Year 5 field.';
                }
                field(TotalYear6; Rec."Total Year 6")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Year 6 field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(PlanningDate; Rec."Planning Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Planning Date field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expense Account field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(TransferedToBudget; Rec."Transfered To Budget")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfered To Budget field.';
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
                field(AuditProvision; Rec."Audit Provision")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Provision field.';
                }
                field(CurrencyDate; Rec."Currency Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Date field.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(Partner; Rec.Partner)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Partner field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
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
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field(WorkTypeCode; Rec."Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Work Type Code field.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(QuantityBase; Rec."Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Quantity (Base) field.';
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
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
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
                    ToolTip = 'Specifies the value of the Line Discount Amount field.';
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
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
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Transferred field.';
                }
                field(DisbursedAmount; Rec."Disbursed Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disbursed Amount field.';
                }
                field(AccountedAmount; Rec."Accounted Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accounted Amount field.';
                }
                field(UnaccountedAmount; Rec."Unaccounted Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unaccounted Amount field.';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced field.';
                }
                field(InvoiceType; Rec."Invoice Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
                field(InvoiceNo; Rec."Invoice No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                }
                field(InvoicedCostAmountLCY; Rec."Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced Cost Amount (LCY) field.';
                }
                field(InvoicedAmountLCY; Rec."Invoiced Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced Amount (LCY) field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field(LotNo; Rec."Lot No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field(GrantContractEntryNo; Rec."Grant Contract Entry No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grant Contract Entry No.';
                    ToolTip = 'Specifies the value of the Grant Contract Entry No. field.';
                }
                field(LedgerEntryType; Rec."Ledger Entry Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ledger Entry Type field.';
                }
                field(LedgerEntryNo; Rec."Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ledger Entry No. field.';
                }
                field(SystemCreatedEntry; Rec."System-Created Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the System-Created Entry field.';
                }
                field(BudgetLineItem; Rec."Budget Line Item")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Line Item field.';
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
                action(EditPlanningLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Edit Planning Lines';
                    Ellipsis = true;
                    Image = EditLines;
                    ToolTip = 'Executes the Edit Planning Lines action.';

                    trigger OnAction()
                    var
                        JT: Record "Job-Task";
                    begin

                        Rec.TestField("Grant No.");
                        Rec.TestField("Grant Task No.");
                        JT.Get(Rec."Grant No.", Rec."Grant Task No.");
                        JT.FilterGroup := 2;
                        JT.SetRange("Grant No.", Rec."Grant No.");
                        JT.SetRange("Grant Task Type", JT."grant task type"::Posting);
                        //IF JT.FIND('-') THEN
                        JT.FilterGroup := 0;

                        Page.RunModal(Page::"Grant Planning Lines", JT);
                    end;
                }
                action(CreateSalesInvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create &Sales Invoice';
                    Ellipsis = true;
                    Image = Invoice;
                    ToolTip = 'Executes the Create &Sales Invoice action.';

                    trigger OnAction()
                    begin
                        CreateSalesInvoice(false);
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
                        CreateSalesInvoice(true);
                    end;
                }
                action(GetSalesCreditMemo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Sales/Credit Memo';
                    Ellipsis = true;
                    Image = GetSourceDoc;
                    ToolTip = 'Executes the Get Sales/Credit Memo action.';

                    trigger OnAction()
                    begin
                        //JobCreateInvoice.GetSalesInvoice(Rec);
                    end;
                }
                action(TransferLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Lines';
                    ToolTip = 'Executes the Transfer Lines action.';

                    trigger OnAction()
                    begin
                        Job.Reset();
                        Job.SetRange(Job."No.", Rec."Grant No.");
                        if Job.Find('-') then begin
                            if Job."Approval Status" <> Job."approval status"::Approved then Error('The grant has to be approved to set budget');
                        end;

                        if Confirm('Are you sure you want to Transfer Lines to Budget?', false) = true then begin

                            Job.Reset();
                            Job.Get(Rec."Grant No.");
                            StartDate := Job."Starting Date";

                            BudgetSetup.Find('-');
                            PlanningLines.Reset();
                            PlanningLines.SetRange(PlanningLines."Grant No.", Rec."Grant No.");
                            PlanningLines.SetRange(PlanningLines.Type, PlanningLines.Type::"G/L Account");
                            //PlanningLines.SETRANGE(PlanningLines.Partner,' ');
                            PlanningLines.SetRange(PlanningLines."Budget in use", true);
                            if PlanningLines.Find('-') then begin
                                repeat

                                    if PlanningLines."Transfered To Budget" = false then begin

                                        BudgetEntry.Reset;
                                        if BudgetEntry.Find('+') then begin
                                            LastEntryNo := BudgetEntry."Entry No.";
                                            //ERROR('%1',LastEntryNo);
                                        end;

                                        BudgetEntry.Init;
                                        BudgetEntry."Entry No." := LastEntryNo + 1;
                                        BudgetEntry."Budget Name" := BudgetSetup."Current Budget Code";
                                        BudgetEntry.Date := StartDate;
                                        BudgetEntry."G/L Account No." := PlanningLines."No.";
                                        BudgetEntry.Description := PlanningLines.Description;
                                        BudgetEntry.Amount := PlanningLines."Total Cost (LCY)";
                                        BudgetEntry.Donor := PlanningLines."Global Dimension 2 Code";
                                        BudgetEntry."Project No" := PlanningLines."Global Dimension 1 Code";
                                        BudgetEntry."Global Dimension 1 Code" := PlanningLines."Global Dimension 1 Code";
                                        BudgetEntry."Contract Entry No" := PlanningLines."Grant Contract Entry No.";
                                        BudgetEntry.Insert;
                                        PlanningLines."Transfered To Budget" := true;
                                        PlanningLines.Modify;

                                        Commit;
                                    end else begin
                                        BudgetEntry.Reset;
                                        BudgetEntry.SetRange(BudgetEntry."Contract Entry No", PlanningLines."Grant Contract Entry No.");
                                        if BudgetEntry.Find('-') then begin
                                            BudgetEntry.Date := StartDate;
                                            BudgetEntry."Budget Name" := BudgetSetup."Current Budget Code";
                                            BudgetEntry."G/L Account No." := PlanningLines."No.";
                                            BudgetEntry.Description := PlanningLines.Description;
                                            BudgetEntry.Donor := PlanningLines."Global Dimension 1 Code";
                                            BudgetEntry."Project No" := PlanningLines."Global Dimension 2 Code";

                                            BudgetEntry."Global Dimension 2 Code" := PlanningLines."Grant No.";
                                            BudgetEntry.Amount := PlanningLines."Total Cost (LCY)";
                                            BudgetEntry."Global Dimension 1 Code" := PlanningLines."Global Dimension 1 Code";
                                            BudgetEntry.Modify;
                                        end
                                    end

                                until PlanningLines.Next = 0;


                                Message('Transfer Complete.');
                            end
                        end
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Unaccounted Amount" := Rec."Disbursed Amount" - Rec."Accounted Amount";
    end;

    trigger OnOpenPage()
    begin
        if ActiveField = 1 then;
        if ActiveField = 2 then;
        if ActiveField = 3 then;
        if ActiveField = 4 then;
    end;

    var
        //JobCreateInvoice: Codeunit UnknownCodeunit70134686;
        ActiveField: Option " ",Cost,CostLCY,PriceLCY,Price;
        Job: Record jobs;
        StartDate: Date;
        BudgetSetup: Record "Budgetary Control Setup";
        PlanningLines: Record "Job-Planning Line";
        BudgetEntry: Record "G/L Budget Entry";
        LastEntryNo: Integer;

    procedure CreateSalesInvoice(CrMemo: Boolean)
    var
        JobPlanningLine: Record "Job-Planning Line";
    //JobCreateInvoice: Codeunit UnknownCodeunit70134686;
    begin
        Rec.TestField("Line No.");
        JobPlanningLine.Copy(Rec);
        CurrPage.SetSelectionFilter(JobPlanningLine);
        //JobCreateInvoice.CreateSalesInvoice(JobPlanningLine,CrMemo)
    end;

    procedure SetActiveField(ActiveField2: Integer)
    begin
        ActiveField := ActiveField2;
    end;
}

