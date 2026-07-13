table 50940 "Tender Required Documents"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Tender Required Documnets";
    DrillDownPageId = "Tender Required Documnets";
    fields
    {
        field(1; "Tender No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Code; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tender Requirement Codes".code;
            trigger OnValidate()
            var
                RequiredDocs: record "Tender Requirement Codes";
            begin
                if RequiredDocs.get(Code) then
                    Description := RequiredDocs.Description;
            end;
        }
        field(3; Description; Text[120])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Mandatory; Boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; Code, "Tender No")
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