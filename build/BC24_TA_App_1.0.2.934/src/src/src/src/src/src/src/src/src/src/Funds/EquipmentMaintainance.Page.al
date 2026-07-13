page 51017 "Equipment Maintainance"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Equipment Maint Register";
    SourceTableView = where(Type = const(Maintainance));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset No. field.';

                }
                field("Description."; Rec."Description.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description. field.';

                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.';

                }
                field("Correction Measure"; Rec."Correction Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction Measure field.';

                }
                field("Time Frame"; Rec."Time Frame")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Frame field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(EquipMaint)
            {
                ApplicationArea = All;
                Caption = 'Equipment Maintainance';
                RunObject = report "Plant & Equipment Maint";
                ToolTip = 'Executes the Equipment Maintainance action.';
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.type::Maintainance;
    end;
}