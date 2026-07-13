page 51029 "Risk Register"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Risk Register";

    layout
    {
        area(Content)
        {
            group("Step 1: Risk Identification")
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Campus Code"; Rec."Campus Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Opportunity/Threat"; Rec."Opportunity/Threat")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Opportunity/Threat field.';
                }
                field("Project Name"; Rec."Project Name")
                {
                    Caption = 'Risk Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Name field.';

                }
                field("Summary Description"; Rec."Summary Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Brief, generally unique description of the risk specific to the Project';
                }
                field("Detailed Description"; Rec."Detailed Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Detailed description of the risk, generally including a "cause", possible "risk event", and "effects".';
                }
            }
            group("Step 2: Risk Assessment")
            {

                group(Rank)
                {
                    field("Rank Probability"; Rec."Rank Probability")
                    {
                        Caption = 'Propability';
                        ApplicationArea = All;
                        ToolTip = 'The estimated likelihood in percent (%) of the risk occurring based on current state of the risk.  For the initial risk assessment, this value should generally correlate with the pre-response assessment.  For subsequent risk assessments as response plans are implemented, the value should reflect the estimated probability at the time of assessment.';
                    }
                    field(Consequence; Rec.Consequence)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Consequence field.';
                    }
                    field("Severity (Priority)"; Rec."Severity (Priority)")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Severity (Priority) field.';
                    }
                }
                group("Cost Impact")
                {
                    field("Cost Probability"; Rec."Cost Probability")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The estimated most likely cost impact of the risk if it were to occur (in millions of dollars).  For the initial risk assessment, this value should generally correlate with the pre-response assessment.  For subsequent risk assements as response plans are implemented, the value should reflect the estimated impact at the time of assessment.';
                    }
                    field("Most Likely (Cost)"; Rec."Most Likely (Cost)")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Most Likely (Cost) field.';
                    }
                }
                group("Schedule Impact (Weeks)")
                {
                    field("Most Likely (Schedule)"; Rec."Most Likely (Schedule)")
                    {
                        Caption = 'Most Likely (no. of weeks)';
                        ToolTip = 'The estimated most likely schedule impact of the risk if it were to occur (in months).  For the initial risk assessment, this value should generally correlate with the pre-response assessment.  For subsequent risk assessments as response plans are implemented, the value should reflect the estimated impact at the time of assessment.';
                        ApplicationArea = All;
                    }
                }
            }
            group("Step 3: Risk Response")
            {
                field("Response Category"; Rec."Response Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Response Category field.';
                }
                field(Response; Rec.Response)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Response field.';
                }
                field("Risk Owner"; Rec."Risk Owner")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Owner field.';
                }
                field("Contingency Plan"; Rec."Contingency Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contingency Plan field.';
                }
            }
            group("Step 4: Monitor & Control")
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field("Tracking Comments"; Rec."Tracking Comments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tracking Comments field.';
                }
            }
            group("Risk Indicators")
            {
                part(Indicators; "Risk Indicators")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Risk Code" = field(No);
                }
            }
            group("Risk Escallation")
            {
                part(Escallation; "Risk Escallation")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Risk Code" = field(No);
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