namespace Microsoft;

page 51479 "Departments List"
{
    ApplicationArea = All;
    Caption = 'Departments/Districts List';
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
               
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department/District Code field.', Comment = '%';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department/District Name field.', Comment = '%';
                }
                field(level;level){}
            }
        }
    }
}
