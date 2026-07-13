namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

page 51592 "House Allowance Setup"
{
    ApplicationArea = All;
    Caption = 'House Allowance Setup';
    PageType = List;
    SourceTable = "House Allowance Setup";
    UsageCategory = Administration;
    DeleteAllowed=false;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Lower Salary Grade Limit"; Rec."Lower Salary Grade Limit")
                {
                    ToolTip = 'Specifies the value of the Lower Salary Grade Limit field.', Comment = '%';
                }
                field("Upper Salary Grade Limit"; Rec."Upper Salary Grade Limit")
                {
                    ToolTip = 'Specifies the value of the Upper Salary Grade Limit field.', Comment = '%';
                }
                field("Perrcentage of Basic"; Rec."Perrcentage of Basic")
                {
                    ToolTip = 'Specifies the value of the Perrcentage of Basic field.', Comment = '%';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.', Comment = '%';
                }
            }
        }
    }
}
