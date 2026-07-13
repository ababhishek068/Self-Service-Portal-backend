table 50731 "RFQ Required Documents"
{
    DataClassification = ToBeClassified;
    LookupPageId = "RFQ Required Documents";
    DrillDownPageId = "RFQ Required Documents";
    fields
    {
        field(1; "FRQ No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Code; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "RFQ Required Docs Codes".code;
            trigger OnValidate()
            var
                RequiredDocs: record "RFQ Required Docs Codes";
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
        key(PK; Code, "FRQ No")
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