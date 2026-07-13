namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

page 51581 "Annual Leave Increment Setup"
{
    ApplicationArea = All;
    Caption = 'Annual Leave Increment Setup';
    PageType = List;
    SourceTable = "Annual Leave Increments";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("HR Calendar Yr"; Rec."HR Calendar Yr")
                {
                    ToolTip = 'Specifies the value of the HR Calendar Yr field.', Comment = '%';
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.', Comment = '%';
                }
                field("No of Years to consider for increment"; Rec."No of Years to consider for increment")
                {
                    ToolTip = 'Specifies the value of the No of Years to consider for increment field.', Comment = '%';
                }
                field("No of days to Increment"; Rec."No of days to Increment")
                {
                    ToolTip = 'Specifies the value of the No of days to Increment field.', Comment = '%';
                }
                field("Limit of Years of Service to Consider"; Rec."Limit of Years of Service to Consider")
                {
                    ToolTip = 'Specifies the value of the Limit of Years of Service to Consider field.', Comment = '%';
                }
                field("Created By";Rec."Created By"){Editable=false;}
                field("Date Created";rec."Date Created"){Editable=false;}
                field("Time Created";rec."Time Created"){Editable=false;}
            }
        }
    }
}
