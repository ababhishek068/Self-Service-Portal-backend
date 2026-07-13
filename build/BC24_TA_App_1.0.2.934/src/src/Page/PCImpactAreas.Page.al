page 51144 "PC Impact Areas"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Impact";

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
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = All;
                    Caption = 'Strategic Objective';
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
            action(Outcomes)
            {
                ApplicationArea = All;
                Caption = 'Outcomes';
                Image = OpportunitiesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "PC Outcomes";
                RunPageLink = "Strategic Plan" = field("Strategic Plan"), "Key Result Area" = field("Key Result Area"), "Strategic Objective" = field(Objective), "Annual Plan" = field("Annual Plan"), Impact = field(Code);
                ToolTip = 'Executes the Outcomes action.';


                trigger OnAction()
                begin

                end;
            }
            action(Verifications)
            {
                ApplicationArea = All;
                Caption = 'Impact Verifications';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "PC Verifications";
                RunPageLink = "Strategic Plan" = field("Strategic Plan"), "Key Result Areas" = field("Key Result Area"), Impact = field(Code), Objective = field(Objective), "Annual Plan" = field("Annual Plan");
                ToolTip = 'Executes the Impact Verifications action.';
                trigger OnAction()
                begin

                end;
            }
        }
    }
}