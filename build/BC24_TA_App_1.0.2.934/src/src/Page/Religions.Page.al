Page 50437 Religions
{
    CardPageID = "Religions Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Religions;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = Basic;
                    Caption = 'Denomination';
                    ToolTip = 'Specifies the value of the Denomination field.';
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

