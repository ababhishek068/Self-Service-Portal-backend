namespace Microsoft;

page 51482 Organogram
{
    ApplicationArea = All;
    Caption = 'Organogram';
    PageType = List;
    SourceTable = Organogram;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(District; Rec.District)
                {
                    ToolTip = 'Specifies the value of the District field.', Comment = '%';
                }
                field("District Name"; Rec."District Name")
                {
                    ToolTip = 'Specifies the value of the District Name field.', Comment = '%';
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.', Comment = '%';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.', Comment = '%';
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.', Comment = '%';
                }
                field(Sector; Rec.Sector)
                {
                    ToolTip = 'Specifies the value of the Sector field.', Comment = '%';
                }
                field("Sector Name"; Rec."Sector Name")
                {
                    ToolTip = 'Specifies the value of the Sector Name field.', Comment = '%';
                }
                
                field("Process Name"; Rec."Process Name")
                {
                    ToolTip = 'Specifies the value of the Process Name field.', Comment = '%';
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ToolTip = 'Specifies the value of the Cost Center field.', Comment = '%';
                }
                field("Cost Centre Name"; Rec."Cost Centre Name")
                {
                    ToolTip = 'Specifies the value of the Cost Centre Name field.', Comment = '%';
                }
            }
        }
    }
}
