Table 50298 "Confirmation of Work"
{
    DrillDownPageID = "Confirmation of Work";
    LookupPageID = "Confirmation of Work";

    fields
    {
        field(1; "Gate Pass No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Date Of Confirmation"; Date) { }
        field(3; "Time Out"; Time) { }
        field(5; "Asset No."; Code[20])
        {
            Editable = false;
        }
        field(6; "Name of Asset"; Text[100])
        {
            Editable = false;
        }
        field(7; "Asset From Location"; Code[30])
        {
            Editable = false;
        }
        field(8; "Asset To Location"; Code[30])
        {
            Editable = false;
        }
        field(10; "Date Created"; Date)
        {
            Editable = true;
        }
        field(11; "Created By"; Code[80])
        {
            Editable = false;
        }
        field(50002; "Type of Work Done"; Text[250]) { }
        field(50003; "To Be Returned"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50004; "Employee No"; Code[20])
        {
            Editable = true;
            TableRelation = "HR-Employee";
        }
        field(50005; "Employee Name"; Text[100]) { }
        field(50010; "Service Provider"; Text[250]) { }
        field(50011; Amount; Decimal) { }
        field(50012; "Admin Comment"; Text[250]) { }
        field(50013; "Service Provider Comments"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Gate Pass No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

