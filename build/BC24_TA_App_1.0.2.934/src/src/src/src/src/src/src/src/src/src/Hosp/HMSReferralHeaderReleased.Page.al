Page 51373 "HMS Referral Header Released"
{
    PageType = Document;
    SourceTable = "HMS Referral Header";
    SourceTableView = where(Status = const(Released));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(Treatmentno; Rec."Treatment no.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Treatment no. field.';
                }
                field(DateReferred; Rec."Date Referred")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Referred field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(PatientName; PatientName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the PatientName field.';
                }
                field(HospitalNo; Rec."Hospital No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Hospital No. field.';
                }
                field(HospitalName; HospitalName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the HospitalName field.';
                }
                field(ReferralReason; Rec."Referral Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Referral Reason field.';
                }
                field(ReferralRemarks; Rec."Referral Remarks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Referral Remarks field.';
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
        HospitalName: Text[100];
        Patient: Record "HMS Patient";
        Hospital: Record Vendor;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        PatientName := '';
        HospitalName := '';

        Patient.Reset;
        if Patient.Get(Rec."Patient No.") then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;

        Hospital.Reset;
        if Hospital.Get(Rec."Hospital No.") then begin
            HospitalName := Hospital.Name;
        end;
    end;
}

