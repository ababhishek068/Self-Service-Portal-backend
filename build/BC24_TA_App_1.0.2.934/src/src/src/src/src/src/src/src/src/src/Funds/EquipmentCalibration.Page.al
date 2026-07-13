page 51014 "Equipment Calibration"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Equipment Maint Register";
    SourceTableView = where(Type = const(Calibration));
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
                field("Date of Calibration"; Rec."Date of Calibration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Calibration field.';

                }
                field("Date due for Calibration"; Rec."Date due for Calibration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date due for Calibration field.';

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
            action(Calibration)
            {
                Caption = 'Equipment Calibration';
                ApplicationArea = All;
                RunObject = report "Equipment Calibration Register";
                ToolTip = 'Executes the Equipment Calibration action.';
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.type::Calibration;
    end;
}