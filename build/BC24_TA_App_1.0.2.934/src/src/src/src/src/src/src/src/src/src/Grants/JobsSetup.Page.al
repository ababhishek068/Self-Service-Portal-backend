page 51038 "Jobs-Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Jobs-Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Job Nos."; Rec."Job Nos.")
                {
                    Caption = 'Grant Nos';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grant Nos field.';

                }
                field("Grant Task Nos"; Rec."Grant Task Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grant Task Nos field.';

                }
                field("Proposal Nos"; Rec."Proposal Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Proposal Nos field.';

                }
                field("Closeout Nos"; Rec."Closeout Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closeout Nos field.';

                }
                field("Concept Nos"; Rec."Concept Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Concept Nos field.';

                }
                field("Donor Contact Nos"; Rec."Proposal Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Proposal Nos field.';

                }
                field("System Contract Nos"; Rec."System Contract Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the System Contract Nos field.';

                }
                field("QA Nos"; Rec."QA Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QA Nos field.';

                }
                field("Research Nos"; Rec."Research Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Research Nos field.';

                }
                field("Marketting Nos"; Rec."Marketting Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Marketting Nos field.';

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