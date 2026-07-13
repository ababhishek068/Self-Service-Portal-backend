page 50311 "Committee Card"
{
    PageType = Card;
    SourceTable = "HR Committees";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1000000000)
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
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70135058),
                              "No." = FIELD("Code");
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
                action(Meetings)
                {
                    Caption = 'Meetings';
                    RunObject = Page "Meetings List";
                    RunPageLink = Meeting = field(Code);
                    ToolTip = 'Executes the Meetings action.';
                }
                action(Objectives)
                {
                    Caption = 'Commitee Objectives';
                    RunObject = Page "Committee Objective";
                    RunPageLink = Code = field(Code);
                    ToolTip = 'Executes the Commitee Objectives action.';
                }
            }
        }
    }
}

