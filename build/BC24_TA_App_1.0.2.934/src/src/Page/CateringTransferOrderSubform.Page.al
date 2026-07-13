Page 50747 "CateringTransfer Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Transfer Order Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Transfer Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(PlanningFlexibility; Rec."Planning Flexibility")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Planning Flexibility field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(TransferfromBinCode; Rec."Transfer-from Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Transfer-from Bin Code field.';
                }
                field(TransferToBinCode; Rec."Transfer-To Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Transfer-To Bin Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(ReservedQuantityInbnd; Rec."Reserved Quantity Inbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Reserved Quantity Inbnd. field.';
                }
                field(ReservedQuantityShipped; Rec."Reserved Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Reserved Quantity Shipped field.';
                }
                field(ReservedQuantityOutbnd; Rec."Reserved Quantity Outbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Reserved Quantity Outbnd. field.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(QtytoShip; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty. to Ship field.';
                }
                field(QuantityShipped; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Quantity Shipped field.';

                    trigger OnDrillDown()
                    var
                        TransShptLine: Record "Transfer Shipment Line";
                    begin
                        Rec.TestField("Document No.");
                        Rec.TestField("Item No.");
                        TransShptLine.SetCurrentkey("Transfer Order No.", "Item No.", "Shipment Date");
                        TransShptLine.SetRange("Transfer Order No.", Rec."Document No.");
                        TransShptLine.SetRange("Item No.", Rec."Item No.");
                        Page.RunModal(0, TransShptLine);
                    end;
                }
                field(QtytoReceive; Rec."Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Qty. to Receive field.';

                    trigger OnValidate()
                    begin
                        if Rec."Qty. to Receive (Base)" > Rec."Quantity Shipped" then begin
                            Error('You Can Not Receive More Than Shipped Quantity')
                        end;
                    end;
                }
                field(QuantityReceived; Rec."Quantity Received")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Quantity Received field.';

                    trigger OnDrillDown()
                    var
                        TransRcptLine: Record "Transfer Receipt Line";
                    begin
                        Rec.TestField("Document No.");
                        Rec.TestField("Item No.");
                        TransRcptLine.SetCurrentkey("Transfer Order No.", "Item No.", "Receipt Date");
                        TransRcptLine.SetRange("Transfer Order No.", Rec."Document No.");
                        TransRcptLine.SetRange("Item No.", Rec."Item No.");
                        Page.RunModal(0, TransRcptLine);
                    end;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shipment Date field.';
                }
                field(ReceiptDate; Rec."Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt Date field.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    Visible = false;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[3] field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    Visible = false;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[4] field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    Visible = false;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[5] field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    Visible = false;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[6] field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    Visible = false;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[7] field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    Visible = false;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[8] field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];

    // procedure ShowDimensions()
    // begin
    //     Rec.ShowDimensions;
    // end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location)
    begin
    end;

    // procedure ShowReservation()
    // begin
    //     Find;
    //     Rec.ShowReservation;
    // end;

    // procedure OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    // begin
    //     OpenItemTrackingLines(Direction);
    // end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;
}

