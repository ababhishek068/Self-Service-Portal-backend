Page 50843 "HMS Labo Form History Li"
{
    CardPageID = "HMS Laboratory Form History";
    PageType = List;
    SourceTable = "HMS Laboratory Form Header";
    SourceTableView = where(Status = const(Completed));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control19)
            {
                field(LaboratoryNo; Rec."Laboratory No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(LabReferenceNo; Rec."Lab. Reference No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lab. Reference No. field.';
                }
                field(LaboratoryDate; Rec."Laboratory Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Laboratory Date field.';
                }
                field(LaboratoryTime; Rec."Laboratory Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Time';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Laboratory Time field.';
                }
                field(RequestArea; Rec."Request Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Request Area field.';
                }
                field(LinkNo; Rec."Link No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Link No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(ScheduledDate; Rec."Scheduled Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheduled Date field.';
                }
                field(ScheduledTime; Rec."Scheduled Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheduled Time field.';
                }
                field(SupervisorID; Rec."Supervisor ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Supervisor ID field.';

                    trigger OnValidate()
                    begin
                        GetSupervisorName(Rec."Supervisor ID", SupervisorName);
                    end;
                }
                field(SupervisorName; SupervisorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the SupervisorName field.';
                }
                field(PatientName; PatientName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(RelativeNo; Rec."Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }





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

    trigger OnAfterGetCurrRecord()
    begin
        /*xRec := Rec;
        GetPatientName("Patient No.",PatientName);
        GetSupervisorName("Supervisor ID",SupervisorName);*/

    end;
}

