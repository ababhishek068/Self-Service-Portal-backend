Table 50748 "Destination Rate Entry"
{
    DrillDownPageID = "Active Files List";
    LookupPageID = "Active Files List";

    fields
    {
        field(1; "Advance Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Receipts and Payment Types".Code where(Type = const(Imprest));
        }
        field(2; "Destination Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Travel Destination"."Destination Code";

            trigger OnValidate()
            begin
                "objTravel Destination".Reset;
                "objTravel Destination".SetRange("objTravel Destination"."Destination Code", "Destination Code");
                if "objTravel Destination".Find('-') then begin
                    "Destination Name" := "objTravel Destination"."Destination Name";
                    "Destination Type" := "objTravel Destination"."Destination Type";
                end;
            end;
        }
        field(3; Currency; Code[10])
        {
            NotBlank = false;
            TableRelation = Currency;
        }
        field(4; "Destination Type"; Option)
        {
            Editable = false;
            OptionMembers = "local",Foreign;
        }
        field(5; "Daily Rate (Amount)"; Decimal) { }
        field(6; "Employee Job Group"; Code[10])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Sal Grades"."Salary Grade";
        }
        field(7; "Destination Name"; Text[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Destination Code", "Employee Job Group", Currency, "Advance Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        "objTravel Destination": Record "Travel Destination";
}

