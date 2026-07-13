
Page 50561 "ICT Asset Register List"
{
    PageType = List;
    SourceTable = "ICT Asset Register";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Asset No"; Rec."Asset No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset No field.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Description field.';
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
                field("Asset Location"; Rec."Asset Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Location field.';
                }
                field("Last Service Date"; Rec."Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Service Date field.';
                }
                field("Next Service Date"; Rec."Next Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Service Date field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Outlook) { }
        }
    }
}

