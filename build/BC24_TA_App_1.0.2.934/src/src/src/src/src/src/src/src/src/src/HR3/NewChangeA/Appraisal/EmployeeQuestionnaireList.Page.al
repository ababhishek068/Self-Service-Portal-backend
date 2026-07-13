page 51106 "Employee Questionnaire List"
{

    Caption = 'Employee Questionnaires';
    PageType = List;
    SourceTable = "Employee Questionnaire";
    CardPageId = "Employee Questionnaire Card";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                field("Target Group"; Rec."Target Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Group field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }


            }
        }
    }

}
