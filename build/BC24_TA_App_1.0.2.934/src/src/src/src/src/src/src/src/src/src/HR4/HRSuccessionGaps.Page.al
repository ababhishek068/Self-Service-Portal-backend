Page 51348 "HR Succession Gaps"
{
    PageType = List;
    SourceTable = "HR Employee Qualification Gaps";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(QualificationCode; Rec."Qualification Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                }
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(InstitutionCompany; Rec."Institution/Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution/Company field.';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cost field.';
                }
                field(CourseGrade; Rec."Course Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Course Grade field.';
                }
                field(EmployeeStatus; Rec."Employee Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Status field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field(ExpirationDate; Rec."Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field(QualificationType; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field(Qualification; Rec.Qualification)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification field.';
                }
                field(ScoreID; Rec."Score ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score ID field.';
                }
                field(GradDate; Rec."Grad. Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grad. Date field.';
                }
                field(Gap; Rec.Gap)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gap field.';
                }
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Plan No. field.';
                }
            }
        }
    }

    actions { }
}

