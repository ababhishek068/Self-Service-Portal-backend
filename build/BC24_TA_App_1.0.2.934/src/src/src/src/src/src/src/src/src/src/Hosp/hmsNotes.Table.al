Table 50675 "hms Notes"
{

    fields
    {
        field(1; LineNo; Integer)
        {
            AutoIncrement = true;
        }
        field(2; TreatmentNo; Code[20]) { }
        field(3; PatientNo; Code[20]) { }
        field(4; "Treatment Date"; Date) { }
        field(5; "Treatment Time"; Time) { }
        field(6; Notes; Text[250]) { }
        field(7; "Notes Type"; Option)
        {
            OptionCaption = ' ,DoctorsNotes,MedicalReport,history,Treatment Plan,Chief Complaints,Past Medical History,Past Surgical History,Social History,Investigations,Assessment and plan,Reviews of Systems,Impression,Visual Acuity,Past Ocular History,Treatment Done,Past Dental History,Past Family History';
            OptionMembers = " ",DoctorsNotes,MedicalReport,history,"Treatment Plan","Chief Complaints","Past Medical History","Past Surgical History","Social History",Investigations,"Assessment and plan","Reviews of Systems",Impression,"Visual Acuity","Past Ocular History","Treatment Done","Past Dental History","Past Family History";
        }
        field(8; "User ID"; Code[30]) { }
        field(9; "Created Date"; Date) { }
        field(10; Clinic; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Medical,Dental,Optical';
            OptionMembers = ,Medical,Dental,Optical;
        }
    }

    keys
    {
        key(Key1; LineNo)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

