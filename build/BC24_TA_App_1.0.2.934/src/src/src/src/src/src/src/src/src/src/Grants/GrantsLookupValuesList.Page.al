Page 50219 "Grants Lookup Values List"
{
    Caption = 'Close Out Checklist Setup';
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Grants Lookup Values";
    SourceTableView = sorting(Order, Type, Code)
                      order(ascending);
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = true;
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Caption = 'Checklist Details';
                    Editable = true;
                    ToolTip = 'Specifies the value of the Checklist Details field.';
                }
                field(Grantsno; Rec."Grants no.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grants no. field.';
                }
            }
        }
    }

    actions { }
}

