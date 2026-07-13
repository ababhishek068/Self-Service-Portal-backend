Page 50807 "Disposal Line"
{
    PageType = ListPart;
    SourceTable = "Disposal Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(ItemTagNo; Rec."Item/Tag No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Item/Tag No field.';
                }
                field(Control22; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(DisposalPlanNo; Rec."Disposal Plan No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Plan No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(PlannedQuantity; Rec."Planned Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Planned Quantity field.';
                }
                field(ActualDisposalPrice; Rec."Actual Disposal Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Disposal Price field.';
                }
                field(TotalPrice; Rec."Total Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Price field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Disposed; Rec.Disposed)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Disposed field.';
                }
                field(Region; Rec.Department)
                {
                    ApplicationArea = Basic;
                    Caption = 'Directorate';
                    ToolTip = 'Specifies the value of the Directorate field.';
                }
                field(Department; Rec.Region)
                {
                    ApplicationArea = Basic;
                    Caption = 'Department';
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(DisposalMethods; Rec."Disposal Methods")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Methods field.';
                }
                field(ActualQuantity; Rec."Actual Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Quantity field.';
                }
                field(DisposedTo; Rec."Disposed To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposed To field.';
                }
                field(ReservedPrice; Rec."Reserved Price")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Reserved Price field.';
                }
                field(Confirmed; Rec.Confirmed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Confirmed field.';
                }
                field(ConfirmedBy; Rec."Confirmed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Confirmed By field.';
                }
                field(DisposalPeriod; Rec."Disposal Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Period field.';
                }
                field(SerialNo; Rec."Serial No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Serial No field.';
                }
                field(ConfirmationDate; Rec."Confirmation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Confirmation Date field.';
                }
            }
        }
    }

    actions { }
}

