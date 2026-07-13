page 50334 Committees
{
    PageType = List;
    SourceTable = "HR Committees";
    CardPageId = "Committee Card";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Roles; Rec.Roles)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Roles field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Committee)
            {
                Caption = 'Committee';
                action(Members)
                {
                    Caption = 'Members';
                    RunObject = Page "KNCHR Commitee Members";
                    RunPageLink = Committee = field(Code);
                    ToolTip = 'Executes the Members action.';
                }
                action("Committee Workplan")
                {
                    Caption = 'Committee Workplan';
                    RunObject = Page "HR Committee WorkPlan";
                    RunPageLink = Code = field(Code);
                    ToolTip = 'Executes the Committee Workplan action.';
                }

            }
        }
    }
}

