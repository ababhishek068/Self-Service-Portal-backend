namespace ABH_UAT.ABH_UAT;

page 51496 "Staff Advance-Pending Approval"
{
    ApplicationArea = All;
    Caption = 'Staff Advance-Pending Approval';
    CardPageId="Staff Advance-Pending card";
    PageType = List;
    SourceTable = "Staff Advance";
    UsageCategory = Lists;    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
            }
        }
    }
}
