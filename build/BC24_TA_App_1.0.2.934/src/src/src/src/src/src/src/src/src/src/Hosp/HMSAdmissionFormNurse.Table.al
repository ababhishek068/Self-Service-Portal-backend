Table 50602 "HMS Admission Form Nurse"
{
    // DrillDownPageID = "WF Student Discipline Card";
    //  LookupPageID = "WF Student Discipline Card";

    fields
    {
        field(1; "Admission No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Nurse ID"; Code[30]) { }
        field(3; "Notes Date"; Date) { }
        field(4; "Notes Time"; Time) { }
        field(5; Notes; Text[250]) { }
        field(6; Type; Option)
        {
            OptionCaption = ' ,Drug Given';
            OptionMembers = " ","Drug Given";
        }
        field(7; Drugs; Code[30])
        {
            TableRelation = "HMS Treatment Form Drug"."Drug No.";
        }
        field(8; Dose; Code[30]) { }
        field(9; Routine; Code[30]) { }
        field(10; "Prescription Dose"; Option)
        {
            OptionCaption = ' ,STAT,PRN,PD,TDS,OD,QID,NOCTE,HOURLY';
            OptionMembers = " ",STAT,PRN,PD,TDS,OD,QID,NOCTE,HOURLY;
        }
        field(11; "Drug Name"; Text[150])
        {
            FieldClass = FlowField;
        }
        field(12; "Patient No"; Code[20])
        {
            CalcFormula = lookup("HMS Admission Form Header"."Patient No." where("Patient No." = field("Admission No.")));
            FieldClass = FlowField;
        }
        field(13; LineNo; Integer)
        {
            AutoIncrement = true;
        }
        field(14; "Nurse Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Triage,Inpatient,Theatre,Maternity,ICU,Physiotherapist,Nutritionist';
            OptionMembers = ,Triage,Inpatient,Theatre,Maternity,ICU,Physiotherapist,Nutritionist;
        }
    }

    keys
    {
        key(Key1; "Admission No.", "Nurse ID", "Notes Date", "Notes Time", LineNo)
        {
            Clustered = true;
        }
        key(Key2; "Notes Date", "Notes Time", LineNo) { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Nurse ID" := UserId;
        "Notes Date" := Today;
        "Notes Time" := "Notes Time";
    end;
}

