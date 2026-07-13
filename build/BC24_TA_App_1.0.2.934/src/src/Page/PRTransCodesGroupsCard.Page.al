Page 50204 "PR Trans Codes Groups - Card"
{
    Caption = 'PR Transaction Codes Groups Card';
    PageType = Card;
    SourceTable = "PR Trans Codes Groups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1102756000)
            {
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Group Code field.';
                }
                field(GroupDescription; Rec."Group Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Group Description field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control3; Outlook) { }
        }
    }

    actions { }
}

