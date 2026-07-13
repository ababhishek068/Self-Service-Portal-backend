Table 50498 "Tender Header Specification"
{

    fields
    {
        field(1; "Code"; Code[20])
        {

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Dimension Code", 'TENDERHEADER');
                DimVal.SetRange(DimVal.Code, Code);

                if (DimVal.Find('-')) then begin
                    Specification := DimVal.Name;

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
    }

    keys
    {
        key(Key1; "Code", "Tender No.", "TIN No.", "Receipt No.")
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
        DimVal: Record "Dimension Value";
}

