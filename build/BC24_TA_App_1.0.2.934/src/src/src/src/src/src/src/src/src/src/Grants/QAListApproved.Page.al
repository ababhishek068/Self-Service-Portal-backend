Page 50400 "QA List Approved"
{
    caption = 'Approved Quality Assuarnce';
    CardPageID = "Quality Assuarance Card";
    PageType = List;
    SourceTable = Jobs;
    SourceTableView = where(Status = const(QA),
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

