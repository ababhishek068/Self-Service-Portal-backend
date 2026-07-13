page 50402 "Student Evaluation Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Student Evaluation";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Student No"; Rec."Student No")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Student No field.';

                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Course objectives were met"; Rec."Course objectives were met")
                {
                    ApplicationArea = basic;
                    Caption = 'Overall, do you think the course objectives were met? ';
                    ToolTip = 'Specifies the value of the Overall, do you think the course objectives were met?  field.';
                }
                field("Personal expectation met"; Rec."Personal expectation met")
                {
                    ApplicationArea = basic;
                    Caption = 'Overall, to what extent were your personal expectation met? ';
                    ToolTip = 'Specifies the value of the Overall, to what extent were your personal expectation met?  field.';

                }
                group(Programme)
                {
                    Caption = 'Please rate the following aspects of training programme';
                    field("Course organization"; Rec."Course organization")
                    {
                        ApplicationArea = basic;
                        Caption = 'Course organization and coordination';
                        ToolTip = 'Specifies the value of the Course organization and coordination field.';

                    }
                    field("Content of training"; Rec."Content of training")
                    {
                        ApplicationArea = basic;
                        Caption = 'Content of training';
                        ToolTip = 'Specifies the value of the Content of training field.';

                    }
                    field("Relevance of training"; Rec."Relevance of training")
                    {
                        ApplicationArea = basic;
                        Caption = 'Relevance of training Course to ones job';
                        ToolTip = 'Specifies the value of the Relevance of training Course to ones job field.';

                    }
                    field("Quality of training"; Rec."Quality of training")
                    {
                        ApplicationArea = basic;
                        Caption = 'Quality of training and learning material';
                        ToolTip = 'Specifies the value of the Quality of training and learning material field.';

                    }
                    field("Appropriateness of duration"; Rec."Appropriateness of duration")
                    {
                        ApplicationArea = basic;
                        Caption = 'Appropriateness of duration of programs (length of course)';
                        ToolTip = 'Specifies the value of the Appropriateness of duration of programs (length of course) field.';

                    }
                    field("Appropriateness of venue"; Rec."Appropriateness of venue")
                    {
                        ApplicationArea = basic;
                        Caption = 'Appropriateness of training venue ';
                        ToolTip = 'Specifies the value of the Appropriateness of training venue  field.';

                    }
                    field("additional comments"; Rec."additional comments")
                    {
                        ApplicationArea = basic;
                        Caption = 'Please give any other additional comments or suggestions that you may have with regard to the entire training programme?';
                        ToolTip = 'Specifies the value of the Please give any other additional comments or suggestions that you may have with regard to the entire training programme? field.';

                    }
                    field("Suggusted Additional Area"; Rec."Suggusted Additional Area")
                    {
                        ApplicationArea = basic;
                        Caption = 'What other area or topic would you like added to the training programme you have just gone through?';
                        ToolTip = 'Specifies the value of the What other area or topic would you like added to the training programme you have just gone through? field.';

                    }
                    field("Other Intrested Training"; Rec."Other Intrested Training")
                    {
                        ApplicationArea = basic;
                        Caption = 'What other training areas would you be interested in?';
                        ToolTip = 'Specifies the value of the What other training areas would you be interested in? field.';

                    }
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}