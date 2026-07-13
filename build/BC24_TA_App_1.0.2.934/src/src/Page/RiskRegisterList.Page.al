page 51030 "Risk Register List"
{
    PageType = List;
    CardPageId = "Risk Register";
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Risk Register";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater("Risk")
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

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



                field("Rank Probability"; Rec."Rank Probability")
                {
                    Caption = 'Propability (1-5)';
                    ApplicationArea = All;
                    ToolTip = 'The estimated likelihood in percent (%) of the risk occurring based on current state of the risk.  For the initial risk assessment, this value should generally correlate with the pre-response assessment.  For subsequent risk assessments as response plans are implemented, the value should reflect the estimated probability at the time of assessment.';
                }
                field(Consequence; Rec.Consequence)
                {
                    Caption = 'Consequence (1-5)';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consequence (1-5) field.';
                }
                field("Severity (Priority)"; Rec."Severity (Priority)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Severity (Priority) field.';
                }


                field("Cost Probability"; Rec."Cost Probability")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Probability %';
                    ToolTip = 'The estimated most likely cost impact of the risk if it were to occur (in millions of dollars).  For the initial risk assessment, this value should generally correlate with the pre-response assessment.  For subsequent risk assements as response plans are implemented, the value should reflect the estimated impact at the time of assessment.';
                }
                field("Most Likely (Cost)"; Rec."Most Likely (Cost)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Most Likely (Cost) field.';
                }


                field("Most Likely (Schedule)"; Rec."Most Likely (Schedule)")
                {
                    Caption = 'Most Likely (no. of weeks)';
                    ToolTip = 'The estimated most likely schedule impact of the risk if it were to occur (in months).  For the initial risk assessment, this value should generally correlate with the pre-response assessment.  For subsequent risk assessments as response plans are implemented, the value should reflect the estimated impact at the time of assessment.';
                    ApplicationArea = All;
                }



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

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Tracking Comments"; Rec."Tracking Comments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tracking Comments field.';
                }


            }
        }

    }
}