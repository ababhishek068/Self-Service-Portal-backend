Table 50335 "HR Appraisal Pespectives"
{
    DrillDownPageID = "HR Appraisal Perspectives";
    LookupPageID = "HR Appraisal Perspectives";

    fields
    {
        field(1; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin

                Clear("Department Name");

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Department Code");
                if DimensionValue.FindFirst() then "Department Name" := DimensionValue.Name;
            end;
        }
        field(4; "Department Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Perspective Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = const("Appraisal Perspective"));

            trigger OnValidate()
            begin
                HRLookupValues.Reset();
                HRLookupValues.SetRange(Type, HRLookupValues.Type::"Appraisal Perspective");
                HRLookupValues.SetRange(Code, "Perspective Type");
                HRLookupValues.FindFirst();

                "Perspective Description" := HRLookupValues.Description;
            end;
        }
        field(6; "Perspective Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if Code = '' then begin
            TheTable.Reset;
            if TheTable.FindLast then begin
                Code := IncStr(TheTable.Code)
            end else begin
                Code := 'PCPT-00001';
            end;
        end;
    end;

    var
        TheTable: Record "HR Appraisal Pespectives";
        HRLookupValues: Record "HR Lookup Values";
}

