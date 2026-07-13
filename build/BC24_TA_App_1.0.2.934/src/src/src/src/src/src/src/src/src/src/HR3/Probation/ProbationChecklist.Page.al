namespace ABH_UAT.ABH_UAT;

page 51520 "Probation Checklist"
{
    ApplicationArea = All;
    Caption = 'Probation Checklist';
    PageType = List;
    SourceTable = "Probation Rating Factors";
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
                    Editable=false;
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
