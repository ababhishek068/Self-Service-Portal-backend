Page 50458 "Jobs Change Entries"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Jobs Change Entries";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ChangeDate; Rec."Change Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Change Date field.';
                }
                field(ChangeDescription; Rec."Change Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Change Description field.';
                }
                field(OldValue; Rec."Old Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Old Value field.';
                }
                field(NewValue; Rec."New Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the New Value field.';
                }
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the UserID field.';
                }
            }
        }
    }

    actions { }
}

