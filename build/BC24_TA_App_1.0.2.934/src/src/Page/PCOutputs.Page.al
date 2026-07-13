page 51275 "PC Outputs"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Outputs";
    Caption = 'Outputs';

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
            action(Activities)
            {
                ApplicationArea = All;
                Caption = 'Activities';
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "PC Strategic Activities";
                RunPageLink = "Strategic Plan" = field("Strategic Plan"), "Key Result Area" = field("Key Result Area"), "Strategic Objective" = field("Strategic Objective"), "Annual Plan" = field("Annual Plan"), Outcome = field(Code), Impact = field(Impact);
                ToolTip = 'Executes the Activities action.';


                trigger OnAction()
                begin

                end;
            }

            action(Verifications)
            {
                ApplicationArea = All;
                Caption = 'Output Verifications';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "PC Verifications";
                RunPageLink = "Strategic Plan" = field("Strategic Plan"), "Key Result Areas" = field("Key Result Area"), Impact = field(Impact), Objective = field("Strategic Objective"), "Annual Plan" = field("Annual Plan"), Outcome = field(Outcome), Output = field(Code);
                ToolTip = 'Executes the Output Verifications action.';
                trigger OnAction()
                begin

                end;
            }
        }
    }
}