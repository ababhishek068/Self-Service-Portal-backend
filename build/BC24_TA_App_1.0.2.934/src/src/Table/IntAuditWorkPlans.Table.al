Table 50217 "Int. Audit Work Plans"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Date Created"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Last Edited"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Last Editor"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Approved,Rejected';
            OptionMembers = New,Approved,Rejected;
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

    trigger OnModify()
    begin
        if Status = Status::Approved then
            Error('Edit not allowed because the work plan is already approved');
    end;
}

