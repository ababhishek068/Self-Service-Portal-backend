page 50028 "Risk Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Risks;

    layout
    {
        area(Content)
        {
            group(GroupName)
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

                field("Risk Desc 1"; Rec."Risk Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Desc 1 field.';

                }
                field("Risk Desc 2"; Rec."Risk Desc 2")
                {
                    caption = 'Risk Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Description field.';

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
            group(Incidents)
            {
                part(Incident; "Risk Incidents")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Risk Code" = field(Code);
                }
            }
            group(Mitigation)
            {
                part(Mitigat; "Risk Mitigation")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Risk Code" = field(Code);
                }
            }
            group(Controls)
            {
                part(Control; "Risk Controls")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Risk Code" = field(Code);
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}