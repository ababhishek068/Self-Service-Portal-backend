Table 50025 "PR Transaction Codes Formula"
{

    fields
    {
        field(1; "Transaction Code"; Code[10])
        {
            Editable = false;
            TableRelation = "PR Transaction Codes"."Transaction Code";
        }
        field(2; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                "Global Dimension 1 Name" := '';

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.FindFirst() then begin
                    "Global Dimension 1 Name" := DimVal.Name;
                end;
            end;
        }
        field(3; "Employer Formulae"; Text[200])
        {

            trigger OnValidate()
            begin
                "Employer Formulae" := UpperCase("Employer Formulae");
            end;
        }
        field(4; "Employee Formulae"; Text[200])
        {

            trigger OnValidate()
            begin
                "Employee Formulae" := UpperCase("Employee Formulae");
            end;
        }
        field(5; "Include In Employer Deductions"; Boolean) { }
        field(6; "Global Dimension 1 Name"; Text[80])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(7; "Transaction Name"; Text[80])
        {
            CalcFormula = lookup("PR Transaction Codes"."Transaction Name" where("Transaction Code" = field("Transaction Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Transaction Code", "Global Dimension 1 Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        DimVal: Record "Dimension Value";
}

