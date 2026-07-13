Table 50249 "Audit Findings Actions"
{

    fields
    {
        field(1; "Code"; Code[80])
        {
            DataClassification = ToBeClassified;
        }

        field(2; "Finding Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Action Classification"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Preventive Action,Corrective Action';
            OptionMembers = ,"Preventive Action","Corrective Action";
        }
        field(4; "Review Area"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Requirement Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Requirement Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Evidence Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Evidence Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Evidence Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Root Cause"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Correction Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Correction Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Correction Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Correction Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Recurrence action 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Recurrence action 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Completion Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Action Appropriate?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Follow Up Action"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Follow Up Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Open,Closed';
            OptionMembers = ,Open,Closed;
        }
        field(26; "Action Effective?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Effectiveness Desc"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Effectiveness Status"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Finding Classification"; Option)
        {
            OptionMembers = ,New;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Finding Code")
        {
            Clustered = true;
        }
        key(Key2; "Finding Code") { }
    }

    fieldgroups { }
}

