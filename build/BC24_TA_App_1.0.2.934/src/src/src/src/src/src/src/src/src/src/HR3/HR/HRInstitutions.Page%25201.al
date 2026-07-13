page 51461 "HR Institutions"
{
    ApplicationArea = All;
    Caption = 'HR Institutions List';
    CardPageId="HR Institutions";
    PageType = List;
    SourceTable = "Hr Institutions";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Institution Code"; Rec."Institution Code")
                {
                    ToolTip = 'Specifies the value of the Institution Code field.';
                }
                field("Institution Name"; Rec."Institution Name")
                {
                    ToolTip = 'Specifies the value of the Institution Name field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
            }
        }
    }
}
