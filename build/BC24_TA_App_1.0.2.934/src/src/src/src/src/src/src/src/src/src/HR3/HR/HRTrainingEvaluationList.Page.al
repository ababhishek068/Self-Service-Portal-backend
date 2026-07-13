Page 50297 "HR Training Evaluation List"
{
    Caption = 'Back to Office List';
    CardPageID = "HR Training Evaluation Form";
    Editable = false;
    PageType = List;
    SourceTable = "HRBack To Office Form";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No field.';
                }
                field(CourseTitle; Rec."Course Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Course Title field.';
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
                field(DurationUnits; Rec."Duration Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration Units field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field(CostOfTraining; Rec."Cost Of Training")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cost Of Training field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(TrainingEvaluationResults; Rec."Training Evaluation Results")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Evaluation Results field.';
                }
                field(Trainer; Rec.Trainer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Trainer field.';
                }
                field(PurposeofTraining; Rec."Purpose of Training")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose of Training field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(TrainingInstitution; Rec."Training Institution")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Institution field.';
                }
                field(Trainingcategory; Rec."Training category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training category field.';
                }
                field(Supervisor; Rec.Supervisor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor field.';
                }
                field(SupervisorName; Rec."Supervisor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor Name field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(TrainingStatus; Rec."Training Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Status field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                ToolTip = 'Executes the &Print action.';
                trigger OnAction()
                var
                    BackToOffice: Record "HRBack To Office Form";
                    BackOffice: Report "Back to Office List";
                begin
                    BackToOffice.Reset();
                    if BackToOffice.Find('-') then begin
                        BackOffice.SetTableView(BackToOffice);
                        BackOffice.Run();
                    end;
                end;
            }
        }
    }
}

