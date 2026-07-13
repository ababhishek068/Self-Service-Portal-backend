Page 50559 "Asset Movement Register List"
{
    CardPageID = "Asset Movement Card";
    Editable = false;
    PageType = List;
    SourceTable = "Asset Movement Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doc No. field.';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset No field.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Description field.';
                }
                field(Requestor; Rec.Requestor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requestor field.';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requestor Name field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Outlook) { }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102755006>")
            {
                Caption = '&Reports';
                Image = Report2;
                action("<Action1102755024>")
                {
                    ApplicationArea = basic;
                    Caption = 'Asset Movement Register';
                    RunObject = Report "AssetMovement Register";
                    ToolTip = 'Executes the Asset Movement Register action.';

                }
                action(assetrepair)
                {
                    ApplicationArea = basic;
                    Caption = 'Asset Repair Report';
                    RunObject = report "Asset Repair Report";
                    ToolTip = 'Executes the Asset Repair Report action.';
                }
                action(assetTransfer)
                {
                    ApplicationArea = basic;
                    Caption = 'Asset Transfer Report"';
                    RunObject = report "Asset Transter Report";
                    ToolTip = 'Executes the Asset Transfer Report" action.';
                }
            }
        }
    }
}

