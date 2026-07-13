Page 50685 "Corporate  Role Cue"
{
    PageType = CardPart;
    SourceTable = "Hr Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(Control5)
            {
                Caption = 'Legal Matters Summary';
                field(NewLegal; Rec."New Legal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the New Legal field.';
                }
                field(ApprovedLegal; Rec."Approved Legal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approved Legal field.';
                }
                field(PostedLegal; Rec."Posted Legal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted Legal field.';
                }
            }
        }
    }

}