page 50426 "HMS Appointment Form History L"
{
    Editable = false;
    PageType = List;
    SourceTable = "HMS Appointment Form Header";
    SourceTableView = WHERE(Status = FILTER(<> New),
                            "Pharmacy Count" = FILTER(> 0));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Appointment No."; Rec."Appointment No.")
                {
                    ToolTip = 'Specifies the value of the Appointment No. field.';
                }
                field("Appointment Date"; Rec."Appointment Date")
                {
                    ToolTip = 'Specifies the value of the Appointment Date field.';
                }
                field("Appointment Time"; Rec."Appointment Time")
                {
                    ToolTip = 'Specifies the value of the Appointment Time field.';
                }
                field("Appointment Type"; Rec."Appointment Type")
                {
                    ToolTip = 'Specifies the value of the Appointment Type field.';

                    trigger OnValidate()
                    begin
                        GetAppointmentTypeName(AppointmentTypeName, Rec."Appointment Type");
                    end;
                }
                field(AppointmentTypeName; AppointmentTypeName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Patient Type"; Rec."Patient Type")
                {
                    ToolTip = 'Specifies the value of the Patient Type field.';

                    trigger OnValidate()
                    begin
                        CheckPatientType();
                    end;
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the value of the Patient No. field.';

                    trigger OnValidate()
                    begin
                        Rec."Patient Names" := Rec.GetPatientName(Rec."Patient No.");

                        Rec.GetPatientNo(Rec."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
                        GetAppointmentStats(Rec."Patient No.");
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Caption = 'Employee/Relative No.';
                    Enabled = "Employee No.Enable";
                    Visible = "Employee No.Visible";
                    ToolTip = 'Specifies the value of the Employee/Relative No. field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    Enabled = "Relative No.Enable";
                    Visible = "Relative No.Visible";
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Enabled = "Student No.Enable";
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(PatientName; PatientName)
                {
                    Caption = 'Patient';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient field.';
                }
                field(Doctor; Rec.Doctor)
                {
                    ToolTip = 'Specifies the value of the Doctor field.';

                    trigger OnValidate()
                    begin
                        DoctorName := Rec.GetDoctorName(Rec.Doctor);

                    end;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
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
        area(creation)
        {
            action(Print_Presc)
            {
                Caption = 'Print Prescription';
                Image = PaymentHistory;
                ToolTip = 'Executes the Print Prescription action.';

                trigger OnAction()
                begin
                    HMSPharm.Reset;
                    HMSPharm.SetRange(HMSPharm."Link No.", Rec."Appointment No.");
                    if HMSPharm.Find('-') then
                        REPORT.Run(70135231, true, true, HMSPharm);
                end;
            }
            separator(Separator7) { }
            action("Appointment Charges")
            {
                Image = CompareCost;
                RunObject = Page "HMS Patient Charges List";
                RunPageLink = "Patient No." = FIELD("Patient No."),
                              "Appointment No Lk" = FIELD("Appointment No.");
                ToolTip = 'Executes the Appointment Charges action.';
            }
        }
    }



    trigger OnInit()
    begin
        "Relative No.Enable" := true;
        "Employee No.Enable" := true;
        "Student No.Enable" := true;
        "Relative No.Visible" := true;
        "Employee No.Visible" := true;
    end;



    var
        AppointmentTypeName: Text[100];
        PatientName: Text[100];
        DoctorName: Text[100];
        IntScheduled: Integer;
        IntCompleted: Integer;
        IntRescheduled: Integer;
        IntCancelled: Integer;
        Age: Text[100];
        [InDataSet]
        "Employee No.Visible": Boolean;
        [InDataSet]
        "Relative No.Visible": Boolean;
        [InDataSet]
        "Student No.Enable": Boolean;
        [InDataSet]
        "Employee No.Enable": Boolean;
        [InDataSet]
        "Relative No.Enable": Boolean;
        HMSPharm: Record "HMS Pharmacy Header";

    procedure CheckPatientType()
    begin
        if Rec."Patient Type" = Rec."Patient Type"::Private then begin
            "Student No.Enable" := false;
            "Employee No.Enable" := false;
            "Relative No.Enable" := false;
            "Employee No.Visible" := false;
            "Relative No.Visible" := false;
        end
        else begin
            "Student No.Enable" := false;
            "Employee No.Enable" := false;
            "Relative No.Enable" := false;
            "Employee No.Visible" := true;
            "Relative No.Visible" := true;

        end;
    end;

    procedure GetAppointmentTypeName(var AppointmentTypeName: Text[100]; var AppointmentTypeCode: Code[20])
    var
        AppType: Record "HMS Setup Appointment Type";
    begin
        AppType.Reset;
        if AppType.Get(AppointmentTypeCode) then begin AppointmentTypeName := AppType.Description end;
    end;

    procedure GetPatientNo(var PatientNo: Code[20]; var StudentNo: Code[20]; var EmployeeNo: Code[20]; var RelativeNo: Integer)
    var
        Patient: Record "HMS Patient";
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then begin
            StudentNo := Patient."Student No.";
            EmployeeNo := Patient."Employee No.";
            RelativeNo := Patient."Relative No.";
        end;
    end;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    var
        Patient: Record "HMS Patient";
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + Patient."Last Name";
        end;
    end;

    procedure GetPatientAge(var PatientNo: Code[20]; var Age: Text[100])
    var
        HRDates: Codeunit "HR Dates";
        Patient: Record "HMS Patient";
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then begin
            if Patient."Date Of Birth" = 0D then begin
                Age := '';
            end
            else begin
                Age := HRDates.DetermineAge(Patient."Date Of Birth", Today);
            end;
        end;
    end;

    procedure GetDoctorName(var DoctorCode: Code[20]; var DoctorName: Text[100])
    var
        Doctor: Record "HMS Setup Doctor";
    begin
        Doctor.Reset;
        if Doctor.Get(DoctorCode) then begin
            //  Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DoctorName := Doctor."Doctors Name";
        end;
    end;

    procedure GetAppointmentStats(var PatientNo: Code[20])
    var
        Patient: Record "HMS Patient";
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then begin
            Patient.CalcFields(Patient."Appointments Scheduled", Patient."Appointments Completed", Patient."Appointments Rescheduled");
            IntScheduled := Patient."Appointments Scheduled";
            IntCompleted := Patient."Appointments Completed";
            IntRescheduled := Patient."Appointments Rescheduled";
            Patient.CalcFields(Patient."Appointments Cancelled");
            IntCancelled := Patient."Appointments Cancelled";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CheckPatientType();
        GetAppointmentTypeName(AppointmentTypeName, Rec."Appointment Type");
        DoctorName := Rec.GetDoctorName(Rec.Doctor);
        Rec.GetPatientNo(Rec."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
        PatientName := Rec.GetPatientName(Rec."Patient No.");
        Rec.GetPatientAge(Rec."Patient No.", Age);
        GetAppointmentStats(Rec."Patient No.");
    end;
}

