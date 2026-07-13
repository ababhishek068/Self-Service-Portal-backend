Table 50584 "HMS Treatment Form Process"
{

    fields
    {
        field(1; "Treatment No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; Type; Option)
        {
            OptionCaption = 'Triage,Signs,Symptoms,History,Laboratory Requests,Radiology Requests,Theatre Requests,ICU Requests,Diagnosis,Injections,Prescriptions,Admission Requests,Referrals,Physiotherapy Requests,Sick off';
            OptionMembers = Triage,Signs,Symptoms,History,"Laboratory Requests","Radiology Requests","Theatre Requests","ICU Requests",Diagnosis,Injections,Prescriptions,"Admission Requests",Referrals,"Physiotherapy Requests","Sick off";
        }
        field(3; "No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Process".Code;
        }
        field(4; Description; Text[200]) { }
        field(5; Mandatory; Boolean) { }
        field(6; Remarks; Text[100]) { }
        field(7; Performed; Boolean) { }
        field(8; Results; Code[50]) { }
        field(9; "Date Created"; DateTime) { }
        field(10; "Date Taken"; Date) { }
    }

    keys
    {
        key(Key1; "Treatment No.", Type, "No.", "Date Created")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

