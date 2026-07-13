Table 50357 "Int. Audit Notifications"
{

    fields
    {
        field(1; Quarter; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Quarters".Code where(Code = field(Quarter));
        }
        field(2; Auditor; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(3; Auditee; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Audit Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Messages; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Date Sent"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Viewed?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Sent';
            OptionMembers = New,Sent;
        }
        field(15; "Auditee Response"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Quarter, Auditor, Auditee)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

