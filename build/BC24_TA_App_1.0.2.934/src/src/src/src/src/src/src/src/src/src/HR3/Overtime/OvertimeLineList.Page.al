namespace ABH_UAT.ABH_UAT;

page 51536 "Overtime Line List"
{
    ApplicationArea = All;
    Caption = 'Overtime Line List';
    PageType = ListPart;
    SourceTable = "Overtime Lines";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee code"; Rec."Employee code")
                {
                    ToolTip = 'Specifies the value of the Employee code field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("6AM-6PM";rec."6AM-6PM"){}
                field("6AM-6PM total";rec."6AM-6PM Amount"){}
                field("6PM-10PM";Rec."6PM-10PM"){}
                field("6PM-10PM total";rec."6PM-10PM total"){}
                field("10PM-6AM";rec."10PM-6AM"){}  
                field("10PM-6AM Total";rec."10PM-6AM Total"){}              
                field(Weekend; Rec.Weekend)
                {
                    ToolTip = 'Specifies the value of the Weekend field.', Comment = '%';
                }
                field("Weekend Total"; Rec."Weekend Total")
                {
                    ToolTip = 'Specifies the value of the Weekend Total field.', Comment = '%';
                }
                field(Holiday; Rec.Holiday)
                {
                    ToolTip = 'Specifies the value of the Holiday field.', Comment = '%';
                }
                field("Holiday Total"; Rec."Holiday Total")
                {
                    ToolTip = 'Specifies the value of the Holiday Total field.', Comment = '%';
                }
                field("Line Total"; Rec."Line Total")
                {
                    ToolTip = 'Specifies the value of the Line Total field.', Comment = '%';
                }
            }
        }
    }
}
