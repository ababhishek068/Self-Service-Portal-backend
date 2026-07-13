table 50270 "ICT Requisition Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "ICT Requisition Category";
    DrillDownPageId = "ICT Requisition Category";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Assigned Staff"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.Get("Assigned Staff") then "Staff Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(4; "Staff Name"; Text[100])
        {
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