Page 50560 "ICT Service/Maintenance Card"
{
    PageType = Card;
    SourceTable = "ICT Service/Maintenance Req";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
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
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Asset Owner field.';
                }
                field("Asset Owner Name"; Rec."Asset Owner Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Owner Name field.';
                }
                field("Service Details"; Rec."Service Details")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Service Details field.';
                }
                field("Service Status"; Rec."Service Status")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Service Status field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Service Date"; Rec."Service Date")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Service Date field.';
                }
                field("Last Service Date"; Rec."Last Service Date")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Last Service Date field.';
                    trigger OnValidate()

                    begin
                        Rec."Next Service Date" := Rec."Last Service Date" + 183;
                    end;
                }
                field("Next Service Date"; Rec."Next Service Date")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
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

