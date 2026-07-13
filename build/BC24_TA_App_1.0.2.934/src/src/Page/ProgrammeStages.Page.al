Page 50100 "Programme Stages"
{
    PageType = List;
    SourceTable = "Programme Stages";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(MinimumPassCoreUnits; Rec."Minimum Pass Core")
                {
                    ApplicationArea = Basic;
                    Caption = 'Minimum Pass Core Units';
                    ToolTip = 'Specifies the value of the Minimum Pass Core Units field.';
                }
                field(MinimumPassYearUnits; Rec."Minimum Pass All")
                {
                    ApplicationArea = Basic;
                    Caption = 'Minimum Pass Year Units';
                    ToolTip = 'Specifies the value of the Minimum Pass Year Units field.';
                }
                field(MinimumYearCourse; Rec."Maximum Allowed CF")
                {
                    ApplicationArea = Basic;
                    Caption = 'Minimum Year Course';
                    ToolTip = 'Specifies the value of the Minimum Year Course field.';
                }
                field(NextStage; Rec."Next Stage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Stage field.';
                }
                field(FinalStage; Rec."Final Stage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Stage field.';
                }
                field(IncludeinTimeTable; Rec."Include in Time Table")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Include in Time Table field.';
                }
                field(ContributiontoFinalScore; Rec."Contribution to Final Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contribution to Final Score field.';
                }
                field(NextStageAttachment; Rec."Next Stage Attachment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Stage Attachment field.';
                }
                field(AllowProgrammeOptions; Rec."Allow Programme Options")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Programme Options field.';
                }
                field(TotalCoreCourse; Rec."Total Core Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Core Course field.';
                }
                field(TotalRequiredCourse; Rec."Total Required Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Required Course field.';
                }
                field(TotalElectiveCourse; Rec."Total Elective Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Elective Course field.';
                }
                field(BlockOnlineResultsRelease; Rec."Block Online Results Release")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Block Online Results Release field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(ProgrammeCode; Rec."Programme Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Code field.';
                }
                field(StudentCount; Rec."Student Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Count field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {

            action(Courses)
            {
                ApplicationArea = Basic;
                Caption = 'Courses';
                Image = Timesheet;
                Promoted = true;
                RunObject = Page "Units/Subjects";
                RunPageLink = "Programme Code" = field("Programme Code"),
                                  "Stage Code" = field(Code);
                ToolTip = 'Executes the Courses action.';
            }
            separator(Action1102760013) { }
            action(FeesStructure)
            {
                ApplicationArea = Basic;
                Caption = 'Fees Structure';
                Image = Forecast;
                Promoted = true;
                RunObject = Page "Fee By Stage";
                RunPageLink = "Programme Code" = field("Programme Code"),
                                  "Stage Code" = field(Code);
                ToolTip = 'Executes the Fees Structure action.';
            }
            action(ChargeItems)
            {
                ApplicationArea = Basic;
                Caption = 'Charge Items';
                Image = Forecast;
                Promoted = true;
                RunObject = Page "Stage Charges";
                RunPageLink = "Programme Code" = field("Programme Code"),
                                  "Stage Code" = field(Code);
                ToolTip = 'Executes the Charge Items action.';
            }

            action(Prerequisite)
            {
                ApplicationArea = Basic;
                Caption = 'Prerequisite';
                Image = Planning;
                Promoted = true;
                RunObject = Page "Course Prerequisite";
                RunPageLink = Programme = field("Programme Code"),
                                  Stage = field(Code);
                ToolTip = 'Executes the Prerequisite action.';
            }
            action(AdditionalInfo)
            {
                ApplicationArea = Basic;
                Caption = 'Additional Info';
                Image = Comment;
                Promoted = true;
                RunObject = Page "Comment Sheet";
                RunPageLink = "Table Name" = const(14),
                                  "No." = field(Code);
                ToolTip = 'Executes the Additional Info action.';
            }

            separator(Action13) { }
            action("Exam Courses")
            {
                ApplicationArea = Basic;
                Image = Answers;
                RunObject = Page "Units/Subjects";
                RunPageLink = "Programme Code" = field("Programme Code"),
                                  "Stage Code" = field(Code),
                                  "Exam Only" = filter(true);
                ToolTip = 'Executes the Exam Courses action.';
            }

        }
    }
}

