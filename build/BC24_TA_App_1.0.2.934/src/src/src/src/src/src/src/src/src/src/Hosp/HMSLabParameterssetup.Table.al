Table 50440 "HMS Lab Parameters setup"
{
    // DrillDownPageID = UnknownPage70135178;
    // LookupPageID = UnknownPage70135178;

    fields
    {
        field(1; "Laboratory Test Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Lab Test".Code;

            trigger OnValidate()
            begin
                LabTest.Get("Laboratory Test Code");
                "Laboratory Test Name" := LabTest.Description;
            end;
        }
        field(2; "Laboratory Test Name"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Lab Test".Description where(Code = field("Laboratory Test Code")));
            FieldClass = FlowField;
        }
        field(3; "Specimen Code"; Code[20])
        {
            TableRelation = "HMS Setup Specimen".Code;

            trigger OnValidate()
            begin
                if HmsSpecimen.Get("Specimen Code") then begin
                    "Specimen Name" := HmsSpecimen.Description;
                    "Measuring Unit Code" := HmsSpecimen.Units;
                    "Measuring Unit Name" := HmsSpecimen.Units;
                    "Test Normal Ranges" := Format(HmsSpecimen."Min Range") + ' - ' + Format(HmsSpecimen."Max Range");
                    "Test Normal Ranges2" := Format(HmsSpecimen."Min Range") + ' - ' + Format(HmsSpecimen."Max Range");
                    "Min Range" := HmsSpecimen."Min Range";
                    "Max Range" := HmsSpecimen."Max Range";
                end;
            end;
        }
        field(4; "Specimen Name"; Text[100])
        {
            FieldClass = Normal;
        }
        field(5; "Measuring Unit Code"; Code[20])
        {
            FieldClass = Normal;
        }
        field(6; "Measuring Unit Name"; Text[30])
        {
            FieldClass = Normal;
        }
        field(7; "Test Normal Ranges"; Text[100])
        {
            FieldClass = Normal;
        }
        field(8; "Min Range"; Decimal)
        {
            DecimalPlaces = 3 : 3;
        }
        field(9; "Max Range"; Decimal)
        {
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                "Test Normal Ranges" := Format("Min Range") + ' - ' + Format("Max Range");
                "Test Normal Ranges2" := Format("Min Range") + ' - ' + Format("Max Range");
            end;
        }
        field(10; "Test Normal Ranges2"; Text[100])
        {
            FieldClass = Normal;
        }
        field(11; Arrangement; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
    }

    keys
    {
        key(Key1; "Laboratory Test Code", "Specimen Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        LabTest: Record "HMS Setup Lab Test";
        HmsSpecimen: Record "HMS Setup Specimen";
}

