Page 50553 "Internal Audit Notifications"
{
    PageType = List;
    SourceTable = "Audit Notifications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Objectives1; Rec.Objectives1)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objectives1 field.';
                }
                field(Objectives2; Rec.Objectives2)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objectives2 field.';
                }
                field(Criteria1; Rec.Criteria1)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Criteria1 field.';
                }
                field(Read; Rec."Read?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Read? field.';
                }
                field("Audit Date"; Rec."Audit Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Date field.';
                }
                field(Criteria2; Rec.Criteria2)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Criteria2 field.';
                }
            }
        }
    }

    actions { }
}

