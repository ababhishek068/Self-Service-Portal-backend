Table 50589 "HMS Treatment Admission"
{

    fields
    {
        field(1; "Treatment No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Ward No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Ward Setup"."Ward Code";
        }
        field(3; "Bed No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Beds"."Bed No" where("Ward No" = field("Ward No."));
        }
        field(4; "Date Of Admission"; Date) { }
        field(5; "Admission Reason"; Code[250]) { }
        field(6; "Admission Remarks"; Text[250]) { }
        field(7; Status; Option)
        {
            CalcFormula = lookup("HMS Admission Form Header".Status where("Link Type" = const('DOCTOR'),
                                                                           "Link No." = field("Treatment No.")));
            FieldClass = FlowField;
            OptionMembers = New,Admitted,Discharged,Cancelled,"Discharge Pending";
        }
        field(8; "Past Medical History"; Text[250]) { }
        field(10; "Past Surgical History"; Text[250]) { }
        field(11; "Social History"; Text[250]) { }
        field(12; "Reviews of systems"; Text[250]) { }
        field(13; Investigations; Text[250]) { }
        field(14; "Assessment and plan"; Text[250]) { }
        field(15; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Treatment No.", "Ward No.", "Bed No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

