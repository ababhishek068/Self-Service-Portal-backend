table 50197 "HR Shortlisting Entry"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(2; "Applicant No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Requisition No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Stage Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Stage Code Filter"; code[20])
        {
            FieldClass = FlowFilter;

        }
    }

    keys
    {
        key(Key1; "Applicant No", "Stage Code")
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