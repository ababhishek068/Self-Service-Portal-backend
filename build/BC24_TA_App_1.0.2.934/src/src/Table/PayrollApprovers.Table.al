table 50212 "Payroll Approvers"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; UserID; code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            var
                UserRec: record "User Setup";
            begin
                if UserRec.get(UserID) then
                    Names := UserRec.UserName;
            end;

        }
        field(2; "Approval Title"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Sequence No"; integer)
        {
            DataClassification = ToBeClassified;


        }
        field(4; "Names"; text[100])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; UserID)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}