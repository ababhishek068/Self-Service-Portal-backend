Page 50969 "Marketting List Approved"
{
    caption = 'Approved Marketting List';
    CardPageID = "Marketting Card";
    PageType = List;
    SourceTable = Jobs;
    SourceTableView = where(Status = const(Market),
                            "Approval Status" = filter(Approved));
    Editable = false;
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

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Stakeholder; Rec.Stakeholder)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stakeholder field.';
                }


                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }

            }
        }
    }

    actions { }
}

