page 50027 Risk
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Risks;
    //  CardPageId = "Risk Card";
    layout
    {
        area(Content)
        {
            Repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department field.';

                }
                field("Risk Description"; Rec."Risk Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Desc 1 field.';

                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Level field.';

                }
                field(Impact; Rec.Impact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Impact field.';

                }

                field("Risk Desc 2"; Rec."Risk Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Desc 2 field.';

                }
                field("Risk Desc 3"; Rec."Risk Desc 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Desc 3 field.';

                }
                field("Risk Desc 4"; Rec."Risk Desc 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Desc 4 field.';

                }
                field("Indicator Desc 1"; Rec."Indicator Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Indicator Desc 1 field.';

                }
                field("Indicator Desc 2"; Rec."Indicator Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Indicator Desc 2 field.';

                }
                field(Likelihood; Rec.Likelihood)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Likelihood field.';

                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Incidents)
            {
                ApplicationArea = basic;
                RunObject = page "Risk Incidents";
                RunPageLink = "Risk Code" = field(Code);
                ToolTip = 'Executes the Incidents action.';

            }
            Action(Mitigation)
            {
                ApplicationArea = basic;
                RunObject = page "Risk Mitigation";
                RunPageLink = "Risk Code" = field(Code);
                ToolTip = 'Executes the Mitigation action.';

            }
            Action("Risk Controls")
            {
                ApplicationArea = basic;
                RunObject = page "Risk Controls";
                RunPageLink = "Risk Code" = field(Code);
                ToolTip = 'Executes the Risk Controls action.';

            }
            action("Risk Card")
            {
                ApplicationArea = basic;
                RunObject = page "Risk Card";
                RunPageLink = "Code" = field(Code);
                ToolTip = 'Executes the Risk Card action.';
            }

        }
    }
}