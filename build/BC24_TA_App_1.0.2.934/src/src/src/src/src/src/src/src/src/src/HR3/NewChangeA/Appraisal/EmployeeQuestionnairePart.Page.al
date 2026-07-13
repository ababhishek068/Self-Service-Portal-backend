page 51279 "Employee Questionnaire Part"
{

    Caption = 'Employee Questionnaires - Responses';
    PageType = ListPart;
    SourceTable = "Employee Questionnaire Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(LineNo; Rec.LineNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LineNo field.';
                }
                field(Scale; Rec.Scale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Scale field.';
                }
                field("Date of Response"; Rec."Date of Response")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Response field.';
                }
                field("Responded By"; Rec."Responded By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responded By field.';
                }


            }
        }
    }

}
