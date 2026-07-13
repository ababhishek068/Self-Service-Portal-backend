Page 50129 "Meeting ListPart"
{
    PageType = ListPart;
    SourceTable = "Meeting Participant";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Participant; Rec.Participant)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Participant field.';
                }
                field("Participant Name"; Rec."Participant Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Participant Name field.';
                }
                field("Type of Participant"; Rec."Type of Participant")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Participant field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Phone Number"; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field("Invite Sent"; Rec."Invite Sent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invite Sent field.';
                }
                field("Is Moderator"; Rec."Is Moderator")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Is Moderator field.';
                }
            }
        }
    }

    actions { }
}

