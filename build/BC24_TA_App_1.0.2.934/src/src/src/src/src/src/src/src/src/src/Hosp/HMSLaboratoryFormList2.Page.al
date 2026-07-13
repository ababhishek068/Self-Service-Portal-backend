page 50425 "HMS Laboratory Form List 2"
{
    CardPageID = "HMS Laboratory Form Test";
    PageType = List;
    SourceTable = "HMS Laboratory Form Header";
    SourceTableView = WHERE(Status = CONST(Forwarded));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Laboratory No."; Rec."Laboratory No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Lab. Reference No."; Rec."Lab. Reference No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lab. Reference No. field.';
                }
                field("Laboratory Date"; Rec."Laboratory Date")
                {
                    Caption = 'Laboratory Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Laboratory Date field.';
                }
                field("Laboratory Time"; Rec."Laboratory Time")
                {
                    Caption = 'Laboratory Time';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Laboratory Time field.';
                }
                field("Request Area"; Rec."Request Area")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Request Area field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    Caption = 'Link No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("Student No.2"; Rec."Student No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("Scheduled Date"; Rec."Scheduled Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheduled Date field.';
                }
                field("Scheduled Time"; Rec."Scheduled Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheduled Time field.';
                }
                field("Supervisor ID"; Rec."Supervisor ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Supervisor ID field.';

                    trigger OnValidate()
                    begin
                        GetSupervisorName(Rec."Supervisor ID", SupervisorName);
                    end;
                }
                field(SupervisorName; SupervisorName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(PatientName; PatientName)
                {
                    Caption = 'Patient Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
                field("Employee No.1"; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Relative No.1"; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field("Employee No.2"; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Register Item Usage")
            {
                Caption = 'Register Item Usage';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Laboratory Item Header";
                RunPageLink = "Laboratory No." = FIELD("Laboratory No.");
                ToolTip = 'Executes the Register Item Usage action.';
            }
            action("&Mark as Completed")
            {
                Caption = '&Mark as Completed';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Mark as Completed action.';

                trigger OnAction()
                begin
                    if Confirm('Mark the Laboratory Test as Completed?', false) = false then exit;
                    blnCompleted := true;
                    LabLine.Reset;
                    LabLine.SetRange(LabLine."Laboratory No.", Rec."Laboratory No.");
                    if LabLine.Find('-') then begin
                        repeat
                            if LabLine.Completed = false then blnCompleted := false;
                        until LabLine.Next = 0;
                    end;

                    if blnCompleted = false then begin
                        Error('Please ensure that all the tests are marked as completed');
                    end
                    else begin
                        Rec.Status := Rec.Status::Completed;
                        Rec.Modify;
                        Message('Laboratory Test Marked as Completed');
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        Patient: Record "HMS Patient";
        PatientName: Text[100];
        SupervisorName: Text[100];
        LabLine: Record "HMS Laboratory Test Line";
        blnCompleted: Boolean;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName := '';
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;
    end;

    procedure GetSupervisorName(var "User ID": Code[20]; var SupervisorName: Text[100])
    begin
        /*
        User.RESET;
        SupervisorName:='';
        IF User.GET("User ID") THEN
          BEGIN
            SupervisorName:=User."User Name";
          END;
         */

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
        GetSupervisorName(Rec."Supervisor ID", SupervisorName);
    end;
}

