Page 50823 "HMS Treatment List"
{
    CardPageID = "HMS Treatment Form Header";
    PageType = List;
    SourceTable = "HMS Treatment Form Header";
    SourceTableView = where(Status = filter(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(TreatmentNo; Rec."Treatment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment No. field.';
                }
                field(DoctorID; Rec."Doctor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor ID field.';
                }
                field(TreatmentType; Rec."Treatment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment Type field.';
                }
                field(TreatmentDate; Rec."Treatment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment Date field.';
                }
                field(TreatmentTime; Rec."Treatment Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment Time field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(Names; Rec.Surname + ' ' + Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(RelativeNo; Rec."Relative No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(LinkNo; Rec."Link No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }

                field(AdmNo; Rec."Adm No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Adm No. field.';
                }
                field(PatientName; Rec."Patient Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Surname);
        Rec.CalcFields("Last Name");
    end;

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

