page 50036 "License Info"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "License Info";
    Caption = 'License Information';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Voice Number"; Rec."Voice Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Voice Number field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';

                }

                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';

                }
                field("Product Line"; Rec."Product Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Line field.';

                }
                field("Product Edition"; Rec."Product Edition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Edition field.';

                }
                field("Product Version"; Rec."Product Version")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Version field.';

                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';

                }
                field("Cummulative Users"; Rec."Cummulative Users")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cummulative Users field.';

                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'License File';
                SubPageLink = "Table ID" = CONST(50099),
                              "No." = FIELD("No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}