namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

page 51587 "GC to EC Month Name"
{
    ApplicationArea = All;
    Caption = 'GC to EC Month Name';
    PageType = List;
    SourceTable = "Payroll GC to EC";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Select Date"; Rec."Select Date")
                {
                    ToolTip = 'Specifies the value of the Select Date field.', Comment = '%';
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.', Comment = '%';
                }
                field("EC Month";"EC Month"){}
                field("GC Name"; Rec."GC Name")
                {
                    ToolTip = 'Specifies the value of the GC Name field.', Comment = '%';
                }
                field("EC Name"; Rec."EC Name")
                {
                    ToolTip = 'Specifies the value of the EC Name field.', Comment = '%';
                }
                field("GC Payroll Period Open Date";"GC Payroll Period Open Date"){}
            }
        }
    }
}
