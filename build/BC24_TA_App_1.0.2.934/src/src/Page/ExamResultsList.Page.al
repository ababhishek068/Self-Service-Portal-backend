Page 50008 "Exam Results List"
{
    DeleteAllowed = false;
    InsertAllowed = false;

    PageType = List;
    SourceTable = "Exam Results";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("'Cancelled Remarks'"; Rec.Remarks)
            {
                ApplicationArea = Basic;
                Caption = 'Cancelled Remarks';
                ToolTip = 'Specifies the value of the Cancelled Remarks field.';
            }
            repeater(Group)
            {
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                    //  Editable = false;
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                    // Editable = false;
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                    // Editable = false;
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Score field.';
                }
                field(Exam; Rec.Exam)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Exam field.';
                }
                field(RegTransactionID; Rec."Reg. Transaction ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reg. Transaction ID field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Percentage field.';
                }
                field(Contribution; Rec.Contribution)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contribution field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(NoRegistration; Rec."No Registration")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No Registration field.';
                }
                field(SystemCreated; Rec."System Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the System Created field.';
                }
                field(ReSit; Rec."Re-Sit")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Re-Sit field.';
                }
                field(ReSited; Rec."Re-Sited")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Re-Sited field.';
                }
                field(RepeatedScore; Rec."Repeated Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Repeated Score field.';
                }
                field(ExamCategory; Rec."Exam Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Exam Category field.';
                }
                field(ExamType; Rec.ExamType)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ExamType field.';
                }
                field(AdmissionNo; Rec."Admission No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission No field.';
                }
                field(SN; Rec.SN)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the SN field.';
                }
                field(Reported; Rec.Reported)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reported field.';
                }
                field(LecturerNames; Rec."Lecturer Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lecturer Names field.';
                }
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field(OriginalScore; Rec."Original Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Original Score field.';
                }
                field(LastEditedBy; Rec."Last Edited By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Edited By field.';
                }
                field(LastEditedOn; Rec."Last Edited On")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Edited On field.';
                }
                field(Submitted; Rec.Submitted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Submitted field.';
                }
                field(SubmittedOn; Rec."Submitted On")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Submitted On field.';
                }
                field(SubmittedBy; Rec."Submitted By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Submitted By field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(OriginalContribution; Rec."Original Contribution")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Original Contribution field.';
                }
                field(SemesterTotal; Rec."Semester Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Semester Total field.';
                }
                field(AttachmentUnit; Rec."Attachment Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attachment Unit field.';
                }
                field(ReTake; Rec."Re-Take")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Re-Take field.';
                }
                field(CancelledRemarks; Rec."Cancelled Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled Remarks field.';
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cancelled field.';
                }
                field(CancelledBy; Rec."Cancelled By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cancelled By field.';
                }
                field(CancelledDate; Rec."Cancelled Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cancelled Date field.';
                }
                field(AcademicYear; Rec."Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field(StudentNames; Rec."Student Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student Names field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Cancel Marks")
            {
                ApplicationArea = Basic;
                Image = Cancel;
                ToolTip = 'Executes the Cancel Marks action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to Cancel the Selected Marks?') then begin
                        Rec."Cancelled Remarks" := Rec.Remarks;
                        Rec.TestField("Cancelled Remarks");
                        Rec.Cancelled := true;
                        Rec."Cancelled By" := Rec.UserID;
                        Rec."Cancelled Date" := Today;
                        Rec.Modify;
                        Rec.Remarks := '';
                    end;
                end;
            }
            separator(Action44) { }
            action("Undo Cancel Marks")
            {
                ApplicationArea = Basic;
                Image = Undo;
                ToolTip = 'Executes the Undo Cancel Marks action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to Undo  the Selected Cancelled Marks?') then begin
                        Rec."Cancelled Remarks" := Rec.Remarks;
                        Rec.TestField("Cancelled Remarks");
                        Rec.Cancelled := false;
                        Rec."Cancelled By" := Rec.UserID;
                        Rec."Cancelled Date" := Today;
                        Rec.Modify;
                        Rec.Remarks := '';
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*
       IF UserSetup.GET(UserID) THEN BEGIN
       IF UserSetup."Can Edit Marks"=FALSE THEN ERROR('Please note that this window is only active for lecturers');
       END ELSE BEGIN
       ERROR('Please note that this window is only active for lecturers');
       END;
         */

    end;
}

