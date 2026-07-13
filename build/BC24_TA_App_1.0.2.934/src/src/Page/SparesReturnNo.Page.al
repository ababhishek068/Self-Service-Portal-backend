namespace ABH_UAT.ABH_UAT;

page 51576 "Spares Return No"
{
    ApplicationArea = All;
    Caption = 'Spares Return List';
    PageType = List;
    SourceTable = "Spare Part Returns";
    UsageCategory = Lists;
    CardPageId="Spare Return Card";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Return No"; Rec."Return No")
                {
                    ToolTip = 'Specifies the value of the Return No field.', Comment = '%';
                }
                field("Vehicle No"; Rec."Vehicle No")
                {
                    ToolTip = 'Specifies the value of the Vehicle No field.', Comment = '%';
                }
                field("Chassis No"; Rec."Chassis No")
                {
                    ToolTip = 'Specifies the value of the Chassis No field.', Comment = '%';
                }
                field("Engine No"; Rec."Engine No")
                {
                    ToolTip = 'Specifies the value of the Engine No field.', Comment = '%';
                }
                field("Garage Code"; Rec."Garage Code")
                {
                    ToolTip = 'Specifies the value of the Garage Code field.', Comment = '%';
                }
                field("Maintenance Code"; Rec."Maintenance Code")
                {
                    ToolTip = 'Specifies the value of the Maintenance Code field.', Comment = '%';
                }
                field("Plate No"; Rec."Plate No")
                {
                    ToolTip = 'Specifies the value of the Plate No field.', Comment = '%';
                }
                field("Numbers of Cylinders "; Rec."Numbers of Cylinders ")
                {
                    ToolTip = 'Specifies the value of the Numbers of Cylinders field.', Comment = '%';
                }
                field("Req Date"; Rec."Req Date")
                {
                    ToolTip = 'Specifies the value of the Req Date field.', Comment = '%';
                }
                field(Colour; Rec.Colour)
                {
                    ToolTip = 'Specifies the value of the Colour field.', Comment = '%';
                }
                field(Condition; Rec.Condition)
                {
                    ToolTip = 'Specifies the value of the Condition field.', Comment = '%';
                }
                field("Asset Value"; Rec."Asset Value")
                {
                    ToolTip = 'Specifies the value of the Asset Value field.', Comment = '%';
                }
                field("Loading Capacity "; Rec."Loading Capacity ")
                {
                    ToolTip = 'Specifies the value of the Loading Capacity field.', Comment = '%';
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.', Comment = '%';
                }
                field("Type of fuel"; Rec."Type of fuel")
                {
                    ToolTip = 'Specifies the value of the Type of fuel field.', Comment = '%';
                }
                field("Received By"; Rec."Received By")
                {
                    ToolTip = 'Specifies the value of the Received By field.', Comment = '%';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ToolTip = 'Specifies the value of the Return Date field.', Comment = '%';
                }
                field("Year of Manufacture"; Rec."Year of Manufacture")
                {
                    ToolTip = 'Specifies the value of the Year of Manufacture field.', Comment = '%';
                }
            }
        }
    }
}
