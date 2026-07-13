Page 51421 "Destination Code Card"
{
    PageType = Card;
    SourceTable = "Travel Destination";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(DestinationCode; Rec."Destination Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Code field.';
                }
                field(DestinationName; Rec."Destination Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Name field.';
                }
                field(DestinationType; Rec."Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Type field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7; Outlook) { }
            systempart(Control8; Notes) { }
            systempart(Control9; MyNotes) { }
            systempart(Control10; Links) { }
        }
    }

    actions
    {
        area(processing)
        {
            action(DestinationRate)
            {
                ApplicationArea = Basic;
                Caption = 'Destination Rate';
                Image = Travel;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Destination Rate List";
                RunPageLink = "Destination Code" = field("Destination Code");
                ToolTip = 'Executes the Destination Rate action.';
            }
        }
    }
}

