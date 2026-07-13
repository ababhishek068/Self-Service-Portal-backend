Page 50170 "Purchase Requisition Subform"
{
    AutoSplitKey = true;
    Caption = 'Purchase Requisition Subform';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type 2" = const(Requisition));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line type.';
                }
                //  field("Expense Code"; "Expense Code")
                // {
                //  ApplicationArea = All;
                //  }
                //  field("Procurement Plan Item No"; "Procurement Plan Item No")
                //  {
                //      ApplicationArea = All;
                // }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnValidate()
                    begin
                        // ShowShortcutDimCode(ShortcutDimCode);
                        // NoOnAfterValidate;

                        // if xRec."No." <> '' then
                        //     RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible=false;
                    ToolTip = 'Specifies information in addition to the description.';
                }
                // field("Item G/L Budget Account"; "Item G/L Budget Account")
                // {
                //      ApplicationArea = All;
                // }
                field("Request Summary"; Rec."Request Summary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request Summary field.';
                }
                // field("WorkPlan No."; "WorkPlan No.")
                //{
                //     ApplicationArea = All;
                //  }
                //field("Expected Receipt Date"; "Expected Receipt Date")
                //{
                // ApplicationArea = All;
                //Editable = false;
                //}
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';

                    // trigger OnValidate()
                    // begin
                    //     RedistributeTotalsOnAfterValidate;
                    // end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';

                    // trigger OnValidate()
                    // begin
                    //     RedistributeTotalsOnAfterValidate;
                    // end;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';

                    // trigger OnValidate()
                    // begin
                    //     RedistributeTotalsOnAfterValidate;
                    //     "Direct Unit Cost" := ROUND("Direct Unit Cost", 0.1, '=');
                    // end;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';


                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';


                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';


                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Committed field.';
                }
                //field("Qty In Store"; "Qty In Store")
                //{
                // ApplicationArea = All;
                // Editable = false;
                //}
                //field("Qty In Proc. Plan"; "Qty In Proc. Plan")
                //{
                //  ApplicationArea = All;
                // Editable = false;
                //}

            }

        }
    }
}