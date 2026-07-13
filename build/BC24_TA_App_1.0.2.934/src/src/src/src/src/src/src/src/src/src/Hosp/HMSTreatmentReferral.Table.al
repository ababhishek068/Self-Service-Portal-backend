Table 50590 "HMS Treatment Referral"
{

    fields
    {
        field(1; "Treatment No."; Code[20]) { }
        field(2; "Hospital No."; Code[50]) { }
        field(3; "Hospital Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Hospital No.")));
            FieldClass = FlowField;
        }
        field(4; "Date Referred"; Date) { }
        field(5; "Contact person"; Text[30])
        {
            CalcFormula = lookup(Vendor.Contact where("No." = field("Hospital No.")));
            FieldClass = FlowField;
        }
        field(6; "Referral Reason"; Code[20]) { }
        field(7; "Referral Remarks"; Text[100]) { }
        field(8; Status; Option)
        {
            CalcFormula = lookup("HMS Referral Header".Status where("Treatment no." = field("Treatment No."),
                                                                     "Hospital No." = field("Hospital No.")));
            FieldClass = FlowField;
            OptionMembers = New,Referred,Released;
        }
        field(9; "Clinical History & Treatment"; Text[250]) { }
        field(10; "Findings on Exam & Investigtn"; Text[250]) { }
        field(11; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Treatment No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

