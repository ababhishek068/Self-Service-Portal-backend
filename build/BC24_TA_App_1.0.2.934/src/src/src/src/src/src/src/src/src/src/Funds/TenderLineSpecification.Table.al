Table 50499 "Tender Line Specification"
{

    fields
    {
        field(1; "Code"; Code[20])
        {

            trigger OnValidate()
            begin
                dimval.Reset;
                dimval.SetRange(dimval."Dimension Code", 'TENDERLINE');
                dimval.SetRange(dimval.Code, Code);

                if (dimval.Find('-')) then begin
                    Specification := dimval.Name;

                    //MODIFY;
                end;
            end;
        }
        field(2; Specification; Text[100])
        {
            Editable = true;
        }
        field(3; Value; Decimal) { }
        field(4; "Tender No."; Code[20]) { }
        field(5; "TIN No."; Code[20])
        {
            Editable = false;
        }
        field(6; "Receipt No."; Code[20])
        {
            Editable = false;
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;

    var
        dimval: Record "Dimension Value";
}

