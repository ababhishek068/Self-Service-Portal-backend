Table 50080 "Stage Charges"
{
    DrillDownPageID = "Stage Charges";
    LookupPageID = "Stage Charges";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(2; "Stage Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Code"));
        }
        field(3; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Charge.Code;

            trigger OnValidate()
            begin
                Charges.Reset;
                Charges.SetRange(Charges.Code, Code);
                if Charges.Find('-') then begin
                    Description := Charges.Description;
                    Amount := Charges.Amount;
                end
                else begin
                    Description := '';
                    Amount := 0;
                end;
            end;
        }
        field(4; Description; Text[200]) { }
        field(5; Amount; Decimal)
        {
            NotBlank = true;
        }
        field(7; Remarks; Text[150]) { }
        field(9; "Recovered First"; Boolean) { }
        field(10; Semester; Code[20])
        {
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Code"));
        }
        field(11; "Student Type"; Option)
        {
            OptionCaption = ' ,Full Time,Part Time,Distance Learning';
            OptionMembers = " ","Full Time","Part Time","Distance Learning";
        }
        field(12; "Recovery Priority"; Integer) { }
        field(13; "Distribution (%)"; Decimal) { }
        field(14; "Distribution Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(15; "Settlement Type"; Code[20])
        {
            TableRelation = "Settlement Type".Code;
        }
        field(50000; "Programme Description"; Text[150]) { }
        field(50001; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50002; "Stage2 Amount"; Decimal)
        {
            CalcFormula = lookup("Stage Charges".Amount where("Programme Code" = field("Programme Code"),
                                                               "Stage Code" = field("Stage2 Filter"),
                                                               "Settlement Type" = field("Settlement Type"),
                                                               Code = field(Code)));
            FieldClass = FlowField;
        }
        field(50003; "Stage2 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50004; "Per Unit Billing"; Boolean) { }
        field(50005; "Audit Unit"; Boolean) { }
        field(50006; "First Time Only"; Boolean) { }
    }

    keys
    {
        key(Key1; "Programme Code", "Stage Code", "Code", "Settlement Type", Semester, "Campus Code", "Audit Unit")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Charges: Record Charge;
}

