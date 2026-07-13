namespace ABH_UAT.ABH_UAT;

page 51538 "Overtime List"
{
    ApplicationArea = All;
    Caption = 'Overtime List';
    PageType = List;
    SourceTable = "Overtime Header-ta";
    UsageCategory = Lists;
    DeleteAllowed=false;
    ModifyAllowed=false;
    CardPageId="Overtime Card.";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Overtime ID"; Rec."Overtime ID")
                {
                    ToolTip = 'Specifies the value of the Overtime ID field.', Comment = '%';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Code field.', Comment = '%';
                }
                field("Period Month"; Rec."Period Month")
                {
                    ToolTip = 'Specifies the value of the Period Month field.', Comment = '%';
                }
                field("Period Year"; Rec."Period Year")
                {
                    ToolTip = 'Specifies the value of the Period Year field.', Comment = '%';
                }
            }
        }
    }
}
