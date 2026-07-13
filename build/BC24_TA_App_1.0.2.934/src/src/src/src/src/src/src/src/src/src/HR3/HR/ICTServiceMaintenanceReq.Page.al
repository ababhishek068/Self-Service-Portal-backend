Page 50306 "ICT Service/Maintenance Req"
{
    CardPageID = "ICT Service/Maintenance Card";
    Editable = false;
    PageType = List;
    SourceTable = "ICT Service/Maintenance Req";
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
                field("Asset Owner"; Rec."Asset Owner")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Owner field.';
                }
                field("Asset Owner Name"; Rec."Asset Owner Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Owner Name field.';
                }
                field("Assigned Officer"; Rec."Assigned Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned Officer field.';
                }
                field("Assined Officer Name"; Rec."Assined Officer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assined Officer Name field.';
                }
                field("Service Status"; Rec."Service Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Service Status field.';
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

