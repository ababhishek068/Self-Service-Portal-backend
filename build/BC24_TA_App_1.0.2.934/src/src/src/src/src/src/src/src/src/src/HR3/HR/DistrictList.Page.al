namespace Microsoft;

page 51477 "District List"
{
    ApplicationArea = All;
    Caption = 'District List';
    PageType = List;
    SourceTable = Departments;
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
                field("Department Code";"Department Code")
                {  Caption = 'Department/District Code';
                    ToolTip = 'Specifies the value of the Caption Department/District Code field.', Comment = '%';
                }
                field("Department Name";"Department Name"){
                    Caption = 'Department/District Name';
                }
                field(level;level){}
                
            }
        }
    }
}
