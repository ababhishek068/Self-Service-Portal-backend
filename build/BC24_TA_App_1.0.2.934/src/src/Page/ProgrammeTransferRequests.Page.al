Page 50316 "Programme Transfer Requests"
{
    CardPageID = "Transfer Request Card";
    PageType = List;
    SourceTable = "Student Requisitions";
    SourceTableView = where("Requisition Type" = filter("Programme Transfer"));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(StudentNo; Rec."Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No field.';
                }
                field(RequisitionType; Rec."Requisition Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
                }
                field(CurrentProgramme; Rec."Current Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Programme field.';
                }
                field("Programme To"; Rec.Programme_To)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme_To field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup13)
            {
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Approve action.';

                    trigger OnAction()
                    var
                        StudTransfer: Record "Students Transfer";
                        CourseRegistration: Record "Course Registration";
                        Sem: Record Semesters;
                        AcademicYear: Record "Academic Year";
                    begin
                        if Confirm('Are you sure you want to Confirm and approve this requisition?', true) = true then begin

                            CourseRegistration.Reset;
                            CourseRegistration.SetRange("Student No.", Rec."Student No");
                            CourseRegistration.SetFilter("Settlement Type", '<>%1', '');
                            if CourseRegistration.Find('-') then begin
                                Sem.Reset;
                                Sem.SetRange("Current Semester", true);
                                if Sem.Find('-') then begin
                                    AcademicYear.Reset;
                                    AcademicYear.SetRange(Current, true);
                                    if AcademicYear.Find('-') then begin
                                        StudTransfer.Init;
                                        StudTransfer."Student No" := Rec."Student No";
                                        StudTransfer.Validate("Student No");
                                        StudTransfer."Settlement Type" := CourseRegistration."Settlement Type";
                                        StudTransfer."Current Programme" := Rec."Current Programme";
                                        StudTransfer.Semester := Sem.Code;
                                        StudTransfer."New Programme" := Rec.Programme_To;
                                        StudTransfer.Validate("New Programme");
                                        StudTransfer.Date := Today;
                                        StudTransfer."Academic Year" := AcademicYear.Code;
                                        StudTransfer."Posted By" := Database.UserId;
                                        StudTransfer.Insert(true);

                                        Rec.Status := Rec.Status::Approved;
                                        Rec.Modify;
                                    end else
                                        Error('Current academic year not set');
                                end else
                                    Error('Current semester not set');
                            end;
                        end;
                    end;
                }
                separator(Action15) { }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Reject action.';

                    trigger OnAction()
                    begin
                        if Confirm('Do you reall want to reject the requisition?', false) then begin
                            Rec.TestField(Remarks);
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end;
                    end;
                }
            }
        }
    }
}

