Page 51049 "HMS Observation List"
{
    CardPageID = "HMS Observation Form Header";
    PageType = List;
    SourceTable = "HMS Observation Form Header";
    SourceTableView = where(Closed = filter(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(ObservationNo; Rec."Observation No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation No. field.';
                }
                field(ObservationType; Rec."Observation Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Type field.';
                }
                field(ObservationDate; Rec."Observation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Date field.';
                }
                field(ObservationTime; Rec."Observation Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Time field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Patient Name"; PatientName)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PatientName field.';
                }
                field(ObservationUserID; Rec."Observation User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation User ID field.';
                }
                field(ObservationRemarks; Rec."Observation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Remarks field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        GetPatientName(Rec."Patient No.", PatientName);
    end;

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        Patient: Record "HMS Patient";
        PatientName: Text[100];

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        Patient.Reset;
        //PatientName:='';
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;
    end;
}

