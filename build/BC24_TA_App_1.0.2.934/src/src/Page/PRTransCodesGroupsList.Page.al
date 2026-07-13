Page 50205 "PR Trans Codes Groups - List"
{
    Caption = 'PR Transaction Codes Groups';
    CardPageID = "PR Trans Codes Groups - Card";
    Editable = false;
    PageType = List;
    SourceTable = "PR Trans Codes Groups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
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
    }

    actions { }
}

