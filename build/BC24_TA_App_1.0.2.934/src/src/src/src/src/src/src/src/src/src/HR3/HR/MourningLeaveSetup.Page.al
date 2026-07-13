namespace ABH_UAT.ABH_UAT;

page 51583 "Mourning Leave Setup"
{
    ApplicationArea = All;
    Caption = 'Mourning Leave Setup';
    PageType = List;
    SourceTable = "Mourning Leave Setup";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Family Member"; Rec."Family Member")
                {
                    ToolTip = 'Specifies the value of the Family Member field.', Comment = '%';
                }
                field("No of Days"; Rec."No of Days")
                {
                    ToolTip = 'Specifies the value of the No of Days field.', Comment = '%';
                }
            }
        }
    }
}
