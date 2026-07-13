page 50401 "Student Evaluation"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Student Evaluation";
    CardPageId = "Student Evaluation Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
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
                    ToolTip = 'Specifies the value of the Course objectives were met field.';

                }
                field("Personal expectation met"; Rec."Personal expectation met")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Personal expectation met field.';

                }
                field("Course organization"; Rec."Course organization")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course organization field.';

                }
                field("Content of training"; Rec."Content of training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Content of training field.';

                }
                field("Relevance of training"; Rec."Relevance of training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Relevance of training field.';

                }
                field("Quality of training"; Rec."Quality of training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Quality of training field.';

                }
                field("Appropriateness of duration"; Rec."Appropriateness of duration")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appropriateness of duration field.';

                }
                field("Appropriateness of venue"; Rec."Appropriateness of venue")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appropriateness of venue field.';

                }
                field("additional comments"; Rec."additional comments")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the additional comments field.';

                }
                field("Suggusted Additional Area"; Rec."Suggusted Additional Area")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Suggusted Additional Area field.';

                }
                field("Other Intrested Training"; Rec."Other Intrested Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Other Intrested Training field.';

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