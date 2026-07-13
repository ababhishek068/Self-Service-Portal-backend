namespace ABH_UAT.ABH_UAT;

page 51547 "Vendor Evaluation Checklist"
{
    ApplicationArea = All;
    Caption = 'Vendor Evaluation Checklist';
    PageType = List;
    SourceTable = "Vendor Evaluation Factors";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Rating Factor"; Rec."Rating Factor")
                {
                    ToolTip = 'Specifies the value of the Rating Factor field.', Comment = '%';
                }
                field("Active?"; Rec."Active?")
                {
                    ToolTip = 'Specifies the value of the Active? field.', Comment = '%';
                }
            }
        }
    }
}
