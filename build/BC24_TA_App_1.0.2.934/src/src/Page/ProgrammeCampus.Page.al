Page 50172 "Programme Campus"
{
    PageType = List;
    SourceTable = "Programme Campus";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus field.';
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

