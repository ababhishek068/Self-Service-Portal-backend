Table 50207 "Residual Risks"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Risk Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Risk Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Risk Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Risk Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Risk Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Indicator Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Indicator Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Environment; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Economic';
            OptionMembers = ,Economic;
        }
        field(10; Impact; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Likelihood; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Level; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Created By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Department; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Mitigation Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Mitigation Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Mitigation Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Mitigation Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

