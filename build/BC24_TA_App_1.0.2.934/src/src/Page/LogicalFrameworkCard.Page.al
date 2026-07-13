page 51078 "Logical Framework Card"
{
    PageType = Card;
    SourceTable = "Logical Framework";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Strategic Plan"; Rec."Strategic Plan")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
                field("Strategic Plan Description"; Rec."Strategic Plan Description")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Strategic Plan Description field.';
                }
                field("KRA Code"; Rec."KRA Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the KRA Code field.';
                }
                field("KRA Description"; Rec."KRA Description")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the KRA Description field.';
                }

                field("Strategic Objective"; Rec."Strategic Objective")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Strategic Objective field.';
                }
                field("Str Objective Description"; Rec."Str Objective Description")
                {
                    ApplicationArea = basic;
                    Caption = 'Strategic Objective Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Strategic Objective Description field.';
                }
                field("Annual Plan"; Rec."Annual Plan")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Annual Plan field.';
                }
                field("Annual Plan Description"; Rec."Annual Plan Description")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Annual Plan Description field.';
                }
                field(Branch; Rec.Branch)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Branch field.';
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Project field.';
                }

            }
            part(ImpactLines; "Logical Framework Impact Lines")
            {
                ApplicationArea = basic;
                Caption = 'Impact';
                SubPageLink = "Strategic Plan" = field("Strategic Plan"), "KRA Code" = field("KRA Code"), "Strategic Objective" = field("Strategic Objective"), "Annual Plan" = field("Annual Plan");
            }

            part(OutcomeLines; "Logical Framework Outcome")
            {
                ApplicationArea = basic;
                Caption = 'Outcome';
                SubPageLink = "Strategic Plan" = field("Strategic Plan"), "KRA Code" = field("KRA Code"), "Strategic Objective" = field("Strategic Objective"), "Annual Plan" = field("Annual Plan");
            }

            part(OutputLines; "Logical Framework Output")
            {
                ApplicationArea = basic;
                Caption = 'Output';
                SubPageLink = "Strategic Plan" = field("Strategic Plan"), "KRA Code" = field("KRA Code"), "Strategic Objective" = field("Strategic Objective"), "Annual Plan" = field("Annual Plan");
            }

            part(Activities; "Logical Framework Activity")
            {
                ApplicationArea = basic;
                Caption = 'Activities';
                SubPageLink = "Strategic Plan" = field("Strategic Plan"), "KRA Code" = field("KRA Code"), "Strategic Objective" = field("Strategic Objective"), "Annual Plan" = field("Annual Plan");
            }
        }
    }
}