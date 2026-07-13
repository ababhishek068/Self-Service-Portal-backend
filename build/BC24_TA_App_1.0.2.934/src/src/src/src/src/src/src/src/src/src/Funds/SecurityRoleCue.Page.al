Page 50760 "Security Role Cue"
{
    PageType = CardPart;
    SourceTable = "Hr Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(AllVisitors)
            {
                Caption = 'All Visitors';
                field(NewVisitors; Rec."New Visitors")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Visitors';
                    DrillDownPageID = "Sec-Visitor Management (New)";
                    ToolTip = 'Specifies the value of the New Visitors field.';
                }
                field(ActiveVisitors; Rec."Active visitors")
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Visitors';
                    DrillDownPageID = "Sec-Visitor Manager (Active)";
                    ToolTip = 'Specifies the value of the Active Visitors field.';
                }
                field(ClearedVisitors; Rec."Cleared Visitors")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cleared Visitors';
                    DrillDownPageID = "Sec-Visitor Manager (Cleared)";
                    ToolTip = 'Specifies the value of the Cleared Visitors field.';
                }
            }
        }
    }

}