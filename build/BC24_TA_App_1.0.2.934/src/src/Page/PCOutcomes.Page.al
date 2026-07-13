page 51228 "PC Outcomes"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Outcomes";
    Caption = 'Outcomes';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Strategic Plan"; Rec."Strategic Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
                field("Key Result Area"; Rec."Key Result Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Key Result Area field.';
                }
                field("Strategic Objective"; Rec."Strategic Objective")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Strategic Objective field.';
                }
                field("Annual Plan"; Rec."Annual Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Annual Plan field.';
                }
                field(Impact; Rec.Impact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Impact field.';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Outputs)
            {
                ApplicationArea = All;
                Caption = 'Outputs';
                Image = OutboundEntry;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "PC Outputs";
                RunPageLink = "Strategic Plan" = field("Strategic Plan"), "Key Result Area" = field("Key Result Area"), "Strategic Objective" = field("Strategic Objective"), "Annual Plan" = field("Annual Plan"), Outcome = field(Code), Impact = field(Impact);
                ToolTip = 'Executes the Outputs action.';


                trigger OnAction()
                begin

                end;
            }

            action(Verifications)
            {
                ApplicationArea = All;
                Caption = 'Outcome Verifications';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "PC Verifications";
                RunPageLink = "Strategic Plan" = field("Strategic Plan"), "Key Result Areas" = field("Key Result Area"), Impact = field(Impact), Objective = field("Strategic Objective"), "Annual Plan" = field("Annual Plan"), Outcome = field(Code);
                ToolTip = 'Executes the Outcome Verifications action.';
                trigger OnAction()
                begin

                end;
            }
        }
    }
}