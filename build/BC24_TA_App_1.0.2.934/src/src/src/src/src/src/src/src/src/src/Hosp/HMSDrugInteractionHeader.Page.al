page 50420 "HMS Drug Interaction Header"
{
    PageType = Document;
    SourceTable = Item;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ToolTip = 'Specifies a description of the item.';
                }
            }
            part(Control1102760000; "HMS Drug Interaction Line")
            {
                SubPageLink = "Drug No." = FIELD("No.");
            }
        }
    }

    actions { }
}

