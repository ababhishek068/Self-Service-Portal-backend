Page 50934 "Job Working Relationships"
{
    PageType = ListPart;
    SourceTable = "Job Working Relationships";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relationship field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

