Page 50322 "HR Changes list"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "HR Change Entries";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field(employeeNo; Rec."employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the employee No field.';
                }
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

