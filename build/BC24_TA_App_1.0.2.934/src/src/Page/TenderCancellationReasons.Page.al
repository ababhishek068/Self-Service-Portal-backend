namespace ABH_UAT.ABH_UAT;

page 51552 "Tender Cancellation Reasons"
{
    ApplicationArea = All;
    Caption = 'Tender Cancellation Reasons';
    PageType = List;
    SourceTable = "Tender Cancellation Reasons";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ToolTip = 'Specifies the value of the Reason Description field.', Comment = '%';
                }
            }
        }
    }
}
