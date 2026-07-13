namespace ABH_UAT.ABH_UAT;

page 51566 "Spares and Tools List"
{
    ApplicationArea = All;
    Caption = 'Spares and Tools List';
    PageType = ListPart;
    SourceTable = "SPares and tools";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.', Comment = '%';
                }
                field("Plate No"; Rec."Plate No")
                {
                    ToolTip = 'Specifies the value of the Plate No field.', Comment = '%';
                }
                field("Chassis No"; Rec."Chassis No")
                {
                    ToolTip = 'Specifies the value of the Chassis No field.', Comment = '%';
                }
                field("Spare Code"; Rec."Spare Code")
                {
                    ToolTip = 'Specifies the value of the Spare Code field.', Comment = '%';
                }
                field("Spare description"; Rec."Spare description")
                {
                    ToolTip = 'Specifies the value of the Spare description field.', Comment = '%';
                }
                field(Quanity; Rec.Quanity)
                {
                    ToolTip = 'Specifies the value of the Quanity field.', Comment = '%';
                }
                field("Serial No"; Rec."Serial No")
                {
                    ToolTip = 'Specifies the value of the Serial No field.', Comment = '%';
                }
                field(Condition; Rec.Condition)
                {
                    ToolTip = 'Specifies the value of the Condition field.', Comment = '%';
                }
            }
        }
    }
}
