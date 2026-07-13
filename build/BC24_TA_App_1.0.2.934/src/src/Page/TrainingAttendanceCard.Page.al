page 50362 "Training Attendance Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Training Attendance Header";
    Caption = 'Training Staff wing Attendance';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field("Training Code"; Rec."Training Code")
                {
                    Caption = 'Course Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Course Code field.';

                }
                field("Course Description"; Rec."Course Description")
                {
                    Caption = 'Course Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Course Name field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Training College"; Rec."Training College")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Training College field.';
                }
                // field("Trainer Leader"; "Trainer Leader")
                // {
                //     ApplicationArea = All;

                // }
                field(Barrack; Rec.Barrack)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Barrack field.';
                }
            }
            group(Lines)
            {
                caption = 'Lines';
                part(TrainingAttendanceLines; "Training Attendance Lines")
                {
                    Caption = 'Training Attendance List';
                    SubPageLink = No = field(No);
                    ApplicationArea = basic;
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