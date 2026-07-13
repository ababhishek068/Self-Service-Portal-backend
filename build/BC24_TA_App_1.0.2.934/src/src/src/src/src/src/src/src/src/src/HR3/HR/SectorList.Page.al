namespace Microsoft;

page 51480 "Sector List"
{
    ApplicationArea = All;
    Caption = 'Sector List';
    PageType = List;
    SourceTable = sectors;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                  field("Sector Code"; Rec."Sector Code")
                {
                    ToolTip = 'Specifies the value of the Sector Code field.', Comment = '%';
                }
                field("Sector Name"; Rec."Sector Name")
                {
                    ToolTip = 'Specifies the value of the Sector Name field.', Comment = '%';
                }
            }
        }
    }
}
