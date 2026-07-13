namespace ABH_UAT.ABH_UAT;

page 51521 "Probation List"
{
    ApplicationArea = All;
    Caption = 'Probation List';
    PageType = List;
    CardPageId="Probation Header";
    SourceTable = "Probation Header";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Probation Code"; Rec."Probation Code")
                {
                    ToolTip = 'Specifies the value of the Probation Code field.', Comment = '%';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.', Comment = '%';
                }
                field(Manager; Rec.Manager)
                {
                    ToolTip = 'Specifies the value of the Manager field.', Comment = '%';
                }
                field("Manager's Name"; Rec."Manager's Name")
                {
                    ToolTip = 'Specifies the value of the Manager''s Name field.', Comment = '%';
                }
                field("Employ Permanently?"; Rec."Employ Permanently?")
                {
                    ToolTip = 'Specifies the value of the Employ Permanently? field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
            }
        }
    }
}
