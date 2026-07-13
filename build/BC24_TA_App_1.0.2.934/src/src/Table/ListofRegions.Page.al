namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

page 51584 "List of Regions"
{
    ApplicationArea = All;
    Caption = 'List of Regions';
    PageType = List;
    SourceTable = Region;
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Taxed; Rec.Taxed)
                {
                    ToolTip = 'Specifies the value of the Taxed field.', Comment = '%';
                }
            }
        }
    }
}
