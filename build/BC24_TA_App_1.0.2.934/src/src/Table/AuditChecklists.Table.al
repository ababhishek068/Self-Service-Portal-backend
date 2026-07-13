Table 50189 "Audit Checklists"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Audit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Audits.Code;
        }
        field(3; "Checkpoint Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Checkpoint Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Clause of Criteria Document"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Checkpoint Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Checkpoint Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Created By"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Finding Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Finding Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Finding Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Finding Citation 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Finding Citation 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Finding Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Finding Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Not Created,Pending submission,Pending Acceptance,Accepted,Rejected';
            OptionMembers = "Not Created","Pending submission","Pending Acceptance",Accepted,Rejected;
        }
        field(18; "Rejected Count"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; Department; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
        }
        field(20; Classification; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Compliance,Observation,Minor Non-conformity,Major Non-conformity';
            OptionMembers = ,"Compliance/Positive",Observation,"Minor Non-conformity","Major Non-conformity";
        }
        field(22; "Approval Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Audit Programme"; Code[20])
        {
            CalcFormula = lookup(Audits."Audit Programme" where(Code = field("Audit Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Audit No"; Option)
        {
            CalcFormula = lookup(Audits."Audit No." where(Code = field("Audit Code")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ',1st Internal Audit,1st Surveillance Audit,6th Internal Audit,3rd Surveillance Audit,7th Internal Audit,4th Surveillance Audit';
            OptionMembers = ,"1st Internal Audit","1st Surveillance Audit","6th Internal Audit","3rd Surveillance Audit","7th Internal Audit","4th Surveillance Audit";
        }
    }

    keys
    {
        key(Key1; "Code", "Audit Code")
        {
            Clustered = true;
        }
        key(Key2; "Audit Code") { }
    }

    fieldgroups { }
}

