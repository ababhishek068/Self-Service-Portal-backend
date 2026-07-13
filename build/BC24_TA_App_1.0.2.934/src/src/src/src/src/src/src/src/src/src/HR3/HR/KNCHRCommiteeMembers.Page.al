Page 50847 "KNCHR Commitee Members"
{
    PageType = List;
    SourceTable = "KNCHR Commitee Members";
    caption = 'Committee Members';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Membertype; Rec."Member type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Member type field.';
                }
                field(MemberNo; Rec."Member No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field(MemberName; Rec."Member Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Member Name field.';
                }
                field(Role; Rec.Role)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Role field.';
                }
                field(DateAppointed; Rec."Date Appointed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Appointed field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Active field.';
                }
            }
        }
    }

    actions { }
}

