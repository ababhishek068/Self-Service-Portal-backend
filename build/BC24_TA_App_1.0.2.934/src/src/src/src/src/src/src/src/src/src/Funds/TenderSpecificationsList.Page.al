Page 50702 "Tender Specifications List"
{
    PageType = ListPart;
    SourceTable = "Tender Specifications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Specification; Rec.Specification)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specification field.';
                }
                field(NotificationHeader; Rec."Notification Header")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notification Header field.';
                }
            }
        }
    }

    actions { }
}

