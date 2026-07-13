namespace ABH_UAT.ABH_UAT;

page 51533 "Vendor Evaluation List"
{
    ApplicationArea = All;
    Caption = 'Vendor Evaluation List';
    PageType = List;
    SourceTable = "Vendor Evaluation Header";
    UsageCategory = Lists;
    CardPageId = "Vendor Evaluation Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Evaluation Code";"Evaluation Code"){}
                field(Vendor;Vendor){}
                field("Vendor Name";"Vendor Name"){}
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                }
                field("Employee name"; Rec."Employee name")
                {
                    ToolTip = 'Specifies the value of the Employee name field.', Comment = '%';
                }
                
                field("Date Created";"Date Created"){}
            }
        }
    }
}
