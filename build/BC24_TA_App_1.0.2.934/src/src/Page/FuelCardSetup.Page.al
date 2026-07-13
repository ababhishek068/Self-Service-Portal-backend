page 50181 "Fuel Card Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Fuel Card Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Card No"; Rec."Card No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card No field.';
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Vehicle Assigned"; Rec."Vehicle Assigned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Assigned field.';
                }
                field("Card PIN"; Rec."Card PIN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card PIN field.';
                }
                field("Card Limit"; Rec."Card Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card Limit field.';
                }
            }
        }
        area(Factboxes) { }
    }

    actions { }
}