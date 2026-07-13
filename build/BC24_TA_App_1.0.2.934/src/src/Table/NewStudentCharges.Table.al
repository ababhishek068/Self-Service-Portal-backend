Table 50066 "New Student Charges"
{
    DrillDownPageID = "Fee By Stage";
    LookupPageID = "Fee By Stage";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
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
        field(10; "First Time Students"; Boolean) { }
        field(11; "Student Type"; Option)
        {
            OptionCaption = ' ,Part Time,Full Time';
            OptionMembers = " ","Part Time","Full Time";
        }
        field(12; "Recovery Priority"; Integer) { }
        field(13; "Distribution (%)"; Decimal) { }
        field(14; "Distribution Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(15; Optional; Boolean) { }
        field(16; "Settlement Type"; Code[20])
        {
            TableRelation = "Settlement Type".Code;
        }
        field(17; "Stage Code"; Code[20]) { }
        field(18; "Sort Order"; Integer) { }
        field(19; "Programme Category"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Programme Categories".Code;
        }
    }

    keys
    {
        key(Key1; "Programme Code", "Code", "Settlement Type", "Stage Code", "Programme Category")
        {
            Clustered = true;
        }
        key(Key2; "Programme Code", "Recovery Priority") { }
        key(Key3; "Sort Order") { }
    }

    fieldgroups { }

    var
        Charges: Record Charge;
}

