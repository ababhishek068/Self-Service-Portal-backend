Page 50314 "Student Requisition Card"
{
    PageType = Card;
    SourceTable = "Student Requisitions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
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
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(RequisitionType; Rec."Requisition Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
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
                field(CurrentProgramme; Rec."Current Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Programme field.';
                }
                field(CurrntProgDescr; CurrntProgDescr)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Programme Description';
                    ToolTip = 'Specifies the value of the Current Programme Description field.';
                }
                field("Programme To"; Rec.Programme_To)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme_To field.';
                }
                field(ProgToDescr; ProgToDescr)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme To Description';
                    ToolTip = 'Specifies the value of the Programme To Description field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(EffectiveDate; Rec."Effective Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Effective Date field.';
                }
                field(LastDateAttended; Rec."Last Date Attended")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Date Attended field.';
                }
                field(ReturnSemester; Rec."Return Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Return Semester field.';
                }
                field(CampusTo; Rec.Campus_To)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus_To field.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason field.';
                }
                field(WeightedMean; Rec."Weighted Mean")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Weighted Mean field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Concentration; Rec.Concentration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Concentration field.';
                }
                field("Concentration Name"; Rec."Concentration Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Concentration Name field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup20)
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
                separator(Action22) { }
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

    trigger OnAfterGetRecord()
    var
        Prog: Record Programme;
        Cust: Record Customer;
    begin
        Cust.Get(Rec."Student No");
        Name := Cust.Name;

        Prog.Get(Rec."Current Programme");
        CurrntProgDescr := Prog.Description;

        Prog.Get(Rec.Programme_To);
        ProgToDescr := Prog.Description;
    end;

    var
        StudTransfer: Record "Students Transfer";
        CurrntProgDescr: Text;
        ProgToDescr: Text;
        Name: Text;
}

