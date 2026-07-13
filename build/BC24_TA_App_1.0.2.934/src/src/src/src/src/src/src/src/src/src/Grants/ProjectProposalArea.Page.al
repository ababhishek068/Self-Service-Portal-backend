Page 50474 "Project/Proposal Area"
{
    PageType = ListPart;
    SourceTable = "Proposal/Projects Areas";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ProposalAreaCode; Rec."Proposal Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposal Area Code field.';
                }
                field(ProposalAreaDescription; Rec."Proposal Area Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposal Area Description field.';
                }
            }
        }
    }

    actions { }
}

