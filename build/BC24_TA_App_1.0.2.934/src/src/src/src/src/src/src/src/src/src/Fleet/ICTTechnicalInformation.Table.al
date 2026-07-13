table 50272 "ICT Technical Information"
{
    DataClassification = ToBeClassified;
    LookupPageId = "ICT Technical Info";
    DrillDownPageId = "ICT Technical Info";
    fields
    {
        field(1; Code; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            OptionMembers = ,Hardware,Software;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; code)
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