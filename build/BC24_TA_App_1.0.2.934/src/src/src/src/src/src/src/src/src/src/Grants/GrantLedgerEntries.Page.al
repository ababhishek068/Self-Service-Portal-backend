Page 50071 "Grant Ledger Entries"
{
    Caption = 'Grant Ledger Entries';
    DataCaptionFields = "Job No.";
    Editable = false;
    PageType = Card;
    SourceTable = "Job-Ledger Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field(JobTaskNo; Rec."Job Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Task No. field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
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
                field(JobPostingGroup; Rec."Job Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Job Posting Group field.';
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
                    Editable = false;
                    Visible = true;
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
                field(DirectUnitCostLCY; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Direct Unit Cost (LCY) field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    Editable = false;
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
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total Price field.';
                }
                field(TotalPriceLCY; Rec."Total Price (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total Price (LCY) field.';
                }
                field(LineAmountLCY; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line Amount (LCY) field.';
                }
                field(OriginalUnitCost; Rec."Original Unit Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Original Unit Cost field.';
                }
                field(OriginalUnitCostLCY; Rec."Original Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Original Unit Cost (LCY) field.';
                }
                field(OriginalTotalCost; Rec."Original Total Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Original Total Cost field.';
                }
                field(OriginalTotalCostLCY; Rec."Original Total Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Original Total Cost (LCY) field.';
                }
                field(OriginalTotalCostACY; Rec."Original Total Cost (ACY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Original Total Cost (ACY) field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Source Code field.';
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Reason Code field.';
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
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field(LedgerEntryType; Rec."Ledger Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ledger Entry Type field.';
                }
                field(LedgerEntryNo; Rec."Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ledger Entry No. field.';
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(Adjusted; Rec.Adjusted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Adjusted field.';
                }
                field(DateTimeAdjusted; Rec."DateTime Adjusted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the DateTime Adjusted field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Ent&ry';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Ledger Entry Dimensions";
                    RunPageLink = "Entry No." = field("Entry No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(TransferToPlanningLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer To Planning Lines';
                    Ellipsis = true;
                    ToolTip = 'Executes the Transfer To Planning Lines action.';

                    trigger OnAction()
                    begin
                        //JobLedgEntry.COPY(Rec);
                        //CurrPage.SETSELECTIONFILTER(JobLedgEntry);
                        //CLEAR(JobTransferToPlanningLine);
                        //JobTransferToPlanningLine.GetJobLedgEntry(JobLedgEntry);
                        //JobTransferToPlanningLine.RUNMODAL;
                        //CLEAR(JobTransferToPlanningLine);
                    end;
                }
            }
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action.';

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if ActiveField = 1 then;
        if ActiveField = 2 then;
        if ActiveField = 3 then;
        if ActiveField = 4 then;
    end;

    var
        Navigate: Page Navigate;
        ActiveField: Option " ",Cost,CostLCY,PriceLCY,Price;

    procedure SetActiveField(ActiveField2: Integer)
    begin
        ActiveField := ActiveField2;
    end;
}

