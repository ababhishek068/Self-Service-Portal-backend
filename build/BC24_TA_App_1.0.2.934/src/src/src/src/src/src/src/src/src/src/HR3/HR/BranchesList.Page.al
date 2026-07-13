namespace Microsoft;

page 51478 "Branches List"
{
    ApplicationArea = All;
    Caption = 'Branches List';
    PageType = List;
    SourceTable = Branches;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sector Code";"Sector Code")
                {
                    ToolTip = 'Specifies the value of the Sector Code field.', Comment = '%';
                }
                field("Department/District Code";"Department/District Code")
                {
                    ToolTip = 'Specifies the value of the Department/District Code field.', Comment = '%';
                }
                // field("Department/District"; Rec."Department/District Code")
                // {
                //     ToolTip = 'Specifies the value of the Branch Name field.', Comment = '%';
                // }
                field("Division/Branch Code";"Division/Branch Code"){}
                field("Division/Branch Name";"Division/Branch Name"){}
                field(level;level){}
                field(Taxed;Taxed){
                    Caption='Not Taxed';
                }
            }
        }
    }
}
