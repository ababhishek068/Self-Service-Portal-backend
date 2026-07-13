Page 51165 "Compliance main List"
{
    InsertAllowed = true;
    PageType = List;
    SourceTable = "Grants Compliance";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GrantNo; Rec."Grant No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grant No field.';
                }
                field(SerialNo; Rec."Compliance Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No.';
                    Editable = true;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostComplianceReport)
            {
                ApplicationArea = Basic;
                Caption = 'Post Compliance Report';
                ToolTip = 'Executes the Post Compliance Report action.';
            }
        }
    }
}

