Page 50390 "Asset Info Register List"
{
    CardPageID = "Asset Info Register Card";
    Editable = false;
    PageType = List;
    SourceTable = "Asset Information Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Asset No"; Rec."Reg Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset No field.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Description field.';
                }
                field("Assigned Staff"; Rec."Assigned Staff")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned Staff field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field("Location/Office"; Rec."Location/Office")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location/Office field.';
                }
                field("Last Service Date"; Rec."Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Service Date field.';
                }
                field("Duration of Next Service"; Rec."Duration of Next Service")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration of Next Service field.';
                }
                field("Next Service Date"; Rec."Next Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Service Date field.';
                }
                field(CostofAsset; Rec."Cost of Asset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cost of Asset field.';
                }
                field(DateAcquiredInstalled; Rec."Date Acquired / Installed.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Acquired / Installed. field.';
                }
                field(AssetCategory; Rec."Asset Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Category field.';
                }
                field(RepairsandMaintenanceCost; Rec."Repairs and Maintenance Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Repairs and Maintenance Cost field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Outlook) { }
        }
    }

    actions { }
}

