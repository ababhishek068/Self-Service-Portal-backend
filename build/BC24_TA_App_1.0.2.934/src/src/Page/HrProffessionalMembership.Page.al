Page 50328 "Hr Proffessional Membership"
{
    PageType = List;
    Caption = 'Proffessional Membership';
    SourceTable = "Hr Proffessional Membership";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MembershipNo; Rec."Membership No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Membership No field.';
                }
                field(NameofBody; Rec."Name of Body")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name of Body field.';
                }
                field(DateofMembership; Rec."Date of Membership")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Membership field.';
                }
                field(MembershipStatus; Rec."Membership Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Membership Status field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(SubscriptionCommenceDate; Rec."Subscription Commence Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Subscription Commence Date field.';
                }
                field(SubscriptionRenewalDate; Rec."Subscription Renewal Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Subscription Renewal Date field.';
                }
            }
        }
    }

    actions { }
}

