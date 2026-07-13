table 50535 "Supply Chain Activities Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[30]) { }

        field(2; "Orders - Open"; Integer)
        {
            Caption = 'Orders - Open';
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = filter(Open), "Document Type" = const(Order)));
            Editable = false;
        }

        field(3; "Orders - Pending App"; Integer)
        {
            Caption = 'Orders - Pending Approval';
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = filter("Pending Approval"), "Document Type" = const(Order)));
            Editable = false;
        }


        field(4; "Orders - Released"; Integer)
        {
            Caption = 'Orders - Released';
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = filter(Released), "Document Type" = const(Order)));
            Editable = false;
        }

        field(5; "Assigned"; Integer)
        {
            Caption = 'Assigned Purchase Requisistion';
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = filter(Released), "Document Type" = const(Quote), "Procurement Officer UserID" = filter(<> '')));
            Editable = false;
        }
        field(6; "UnAssigned"; Integer)
        {
            Caption = 'UnAssigned Purchase Requisistion';
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = filter(Released), "Document Type" = const(Quote), "Assigned Procurement Officer" = filter('')));
            Editable = false;
        }
        field(7; UserIDNo; Code[30])
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key") { }
    }

    fieldgroups { }
}

