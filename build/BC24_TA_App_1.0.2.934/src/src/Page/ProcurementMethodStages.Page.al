namespace ABH_UAT.ABH_UAT;

page 51560 "Procurement Method Stages"
{
    ApplicationArea = All;
    Caption = 'Procurement Method Stages';
    PageType = List;
    SourceTable = "Procurement Method Stages";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Procurement Method"; Rec."Procurement Method")
                {
                    ToolTip = 'Specifies the value of the Procurement Method field.', Comment = '%';
                }
                field("Stage Code"; Rec."Stage Code")
                {
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field("Stage Description"; Rec."Stage Description")
                {
                    ToolTip = 'Specifies the value of the Stage Description field.';
                }
                field("Minimum Duration"; Rec."Minimum Duration")
                {
                    ToolTip = 'Specifies the value of the Minimum Duration field.';
                }
                field("Maximum Duration"; Rec."Maximum Duration")
                {
                    ToolTip = 'Specifies the value of the Maximum Duration field.';
                }
            }
        }
    }
}
