Page 51446 "HR Jobs to Succeed list"
{
    CardPageID = "HR Succession Planning";
    PageType = List;
    SourceTable = "HR Succession Employee";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StaffNo; Rec."Staff No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No. field.';
                }
                field(PositiontoSucceed; Rec."Position to Succeed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position to Succeed field.';
                }
                field(PositionDescription; Rec."Position Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position Description field.';
                }
                field(JobTitle; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field(StaffNames; Rec."Staff Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff Names field.';
                }
                field(IDNo; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID No. field.';
                }
                field(Dimension1Code; Rec."Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field(DateofJoin; Rec."Date of Join")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Join field.';
                }
                field(SuccessionDate; Rec."Succession Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Succession Date field.';
                }
                field(Readiness; Rec.Readiness)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Readiness field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(DateMarked; Rec."Date Marked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Marked field.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(EmployeeQualifications; Rec."Employee Qualifications")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Qualifications field.';
                }
                field(LineNo2; Rec."Line No.2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No.2 field.';
                }
                field(Dimension2Code; Rec."Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field(Dimension1Description; Rec."Dimension 1 Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Description field.';
                }
                field(Dimension2Description; Rec."Dimension 2 Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Description field.';
                }
                field(JobID; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Plan No. field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Howlongifnotready; Rec."How long if not ready?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the How long if not ready? field.';
                }
                field(Mentor; Rec.Mentor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mentor field.';
                }
                field(MentorName; Rec."Mentor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mentor Name field.';
                }
            }
        }
    }

    actions { }
}

