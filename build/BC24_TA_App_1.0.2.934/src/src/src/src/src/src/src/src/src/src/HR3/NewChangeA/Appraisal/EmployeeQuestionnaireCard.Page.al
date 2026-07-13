page 51278 "Employee Questionnaire Card"
{

    Caption = 'Employee Questionnaires Card';
    PageType = Card;
    SourceTable = "Employee Questionnaire";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Question ID"; Rec."Question ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Question ID field.';
                }
                field(Question; Rec.Question)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Question field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field(Anonymous; Rec.Anonymous)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Anonymous field.';
                }
                field("Target Group"; Rec."Target Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Group field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }

            }

            part(Responses; "Employee Questionnaire Part")
            {
                Caption = 'Responses';
                ApplicationArea = All;
                SubPageLink = "Question ID" = field("Question ID");

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Approvals")
            {
                ToolTip = 'Executes the Approvals action.';

            }
        }
    }

}