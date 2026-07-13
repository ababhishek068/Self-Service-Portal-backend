Page 51221 "HR Appraisal Objectives"
{
    PageType = ListPart;
    SourceTable = "Appraisal Objective";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AppraisalCode; Rec."Appraisal Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                }
                field(CriteriaCode; Rec."Criteria Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Criteria Code field.';
                }
                field(CriteriaDescription; Rec."Criteria Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Criteria Description field.';
                }
                field(IndicatorCode; Rec."Performance Indicator Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Indicator Code';
                    ToolTip = 'Specifies the value of the Indicator Code field.';
                }
                field(PerformanceIndicatorDescript; Rec."Performance Indicator Descript")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performance Indicator Descript field.';
                }
                field(Ratings; Rec.Ratings)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ratings field.';
                }
                field(RatingDescription; Rec."Rating Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rating Description field.';
                }
                field(HODAsssementSummary; Rec."HOD Asssement Summary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HOD Asssement Summary field.';
                }
                field(WeakAreasdiscussedwithemployeeHODGeneralComments; Rec."Weak Areas Discussed")
                {
                    ApplicationArea = Basic;
                    Caption = 'Weak Areas discussed with employee(HOD General Comments)';
                    ToolTip = 'Specifies the value of the Weak Areas discussed with employee(HOD General Comments) field.';
                }
                field(EmployeeComments; Rec."Appraisee Comments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Comments';
                    ToolTip = 'Specifies the value of the Employee Comments field.';
                }
            }
        }
    }

    actions { }
}

