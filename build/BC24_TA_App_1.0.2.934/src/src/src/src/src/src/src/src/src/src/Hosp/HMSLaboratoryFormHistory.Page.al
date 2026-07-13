page 50419 "HMS Laboratory Form History"
{
    PageType = Document;
    SourceTable = "HMS Laboratory Form Header";
    SourceTableView = WHERE(Status = CONST(Completed));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control19)
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
                part(Control3; "HMS Labaratory Test Line")
                {
                    Editable = false;
                    SubPageLink = "Laboratory No." = FIELD("Laboratory No.");
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        PatientName: Text[100];
        SupervisorName: Text[100];

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        /*Patient.RESET;
        PatientName:='';
        IF Patient.GET(PatientNo) THEN
          BEGIN
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
          END;  */

    end;

    procedure GetSupervisorName(var "User ID": Code[20]; var SupervisorName: Text[100])
    begin
        /*User.RESET;
        SupervisorName:='';
        IF User.GET("User ID") THEN
          BEGIN
           // SupervisorName:=User.Name;
          END;*/

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        /*xRec := Rec;
        GetPatientName("Patient No.",PatientName);
        GetSupervisorName("Supervisor ID",SupervisorName);*/

    end;
}

