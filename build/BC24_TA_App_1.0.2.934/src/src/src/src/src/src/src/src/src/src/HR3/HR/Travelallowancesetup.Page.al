namespace ABH_UAT.ABH_UAT;

page 51535 "Travel allowance setup"
{
    ApplicationArea = All;
    Caption = 'Fuel allowance setup';
    PageType = List;
    SourceTable = "Travel Allowance Rates";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the value of the Job Grade field.', Comment = '%';
                }
                field("Job Grade name"; Rec."Job Grade name")
                {
                    ToolTip = 'Specifies the value of the Job Grade name field.', Comment = '%';
                    Editable=false;
                }
                field(level;level){}
                field(Amount;Amount){}
            }
        }
    }
}
