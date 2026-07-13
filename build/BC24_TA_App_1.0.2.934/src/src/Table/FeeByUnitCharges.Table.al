Table 50018 "Fee By Unit Charges"
{
    // DrillDownPageID = "Fee By Unit Charges";
    // LookupPageID = "Fee By Unit Charges";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {

            TableRelation = Programme.Code;
        }
        field(2; "Stage Code"; Code[20])
        {

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
        field(11; "Student Type"; Code[20])
        {
            TableRelation = "Student Types".Code;
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
        field(50002; "First Time Only"; Boolean) { }
        field(50003; "Applicable Group"; Option)
        {
            OptionCaption = ' ,New Students,Continuing Students';
            OptionMembers = " ","New Students","Continuing Students";
        }
        field(50004; Exams; Boolean) { }
        field(50005; "Once Per Year"; Boolean) { }
        field(50006; "Programme Category"; code[20])
        {
            TableRelation = "Programme Categories".code;
        }
    }

    keys
    {
        key(Key1; "Programme Code", "Code", "Student Type", "Campus Code", "Settlement Type", "Applicable Group", "Programme Category")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Charges: Record Charge;
}

