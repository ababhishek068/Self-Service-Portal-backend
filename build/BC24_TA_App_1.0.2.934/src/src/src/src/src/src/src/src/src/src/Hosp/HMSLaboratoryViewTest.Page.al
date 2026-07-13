page 50414 "HMS Laboratory View Test"
{
    PageType = Document;
    SourceTable = "HMS Laboratory Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Laboratory No."; Rec."Laboratory No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
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
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group("Laboratory Test Findings")
            {
                Caption = 'Laboratory Test Findings';
                part(Control1102760017; "HMS Labaratory Test Line")
                {
                    Editable = false;
                    SubPageLink = "Laboratory No." = FIELD("Laboratory No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
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
        User: Record User;
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
        User.Reset;
        SupervisorName := '';
        if User.Get("User ID") then begin
            SupervisorName := User."User Name";
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
        GetSupervisorName(Rec."Supervisor ID", SupervisorName);
    end;
}

