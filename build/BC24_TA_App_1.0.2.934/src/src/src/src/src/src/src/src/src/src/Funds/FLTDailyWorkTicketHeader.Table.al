Table 50866 "FLT-Daily Work Ticket Header"
{
    DrillDownPageID = "FLT Closed Work Ticket List";
    LookupPageID = "FLT Closed Work Ticket List";

    fields
    {
        field(1; "Ticket No."; Code[20]) { }
        field(2; "Previous W.T. No."; Code[20]) { }
        field(3; "G.K. No."; Code[20])
        {
            TableRelation = "FLT-Vehicle Header"."Registration No.";
        }
        field(4; Make; Code[10])
        {
            CalcFormula = lookup("FLT-Vehicle Header".Make where("Registration No." = field("G.K. No.")));
            FieldClass = FlowField;
        }
        field(5; Unit; Code[20]) { }
        field(6; Type; Code[10])
        {
            CalcFormula = lookup("FLT-Vehicle Header".Model where("Registration No." = field("G.K. No.")));
            FieldClass = FlowField;
        }
        field(7; Station; Text[50]) { }
        field(8; "Total Milleage"; Decimal)
        {
            CalcFormula = sum("FLT-Daily Work Ticket Lines"."Kilometers Covered" where("Ticket No." = field("Ticket No.")));
            FieldClass = FlowField;
        }
        field(9; "Total Fuel Cost"; Decimal)
        {
            CalcFormula = sum("FLT-Daily Work Ticket Lines"."Fuel Cost (Total)" where("Ticket No." = field("Ticket No.")));
            FieldClass = FlowField;
        }
        field(10; Ministry; Code[50]) { }
        field(11; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(12; "Department Name"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field(Department)));
            FieldClass = FlowField;
        }
        field(110; "Global Dimension1"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(112; "Global Dimension1 Name"; Text[150])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Global Dimension1")));
            FieldClass = FlowField;
        }
        field(13; "Total Fuel Consumed"; Decimal)
        {
            CalcFormula = sum("FLT-Daily Work Ticket Lines"."Fuel Consumed (Litres)" where("Ticket No." = field("Ticket No.")));
            FieldClass = FlowField;
        }
        field(14; "Oil Consumed"; Decimal)
        {
            CalcFormula = sum("FLT-Daily Work Ticket Lines"."Total Oil Consumed" where("Ticket No." = field("Ticket No.")));
            FieldClass = FlowField;
        }
        field(15; Status; Option)
        {
            OptionMembers = Open,Closed;
        }
        field(16; Month; Option)
        {
            OptionMembers = " ",JANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER;
        }
        field(17; Year; Option)
        {
            OptionMembers = " ","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040","2041","2042","2043","2044","2045","2046","2047","2048","2049","2050","2051","2052","2053","2054","2055","2056","2057","2058","2059","2060";
        }
        field(18; "No. Series"; Code[10]) { }
    }

    keys
    {
        key(Key1; "Ticket No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        LastNoUsed := '';
        if NoSeries.Get then begin
            if NoSeries."Work Ticket No." <> '' then begin
                Nosetup.Reset;
                Nosetup.SetRange(Nosetup."Series Code", NoSeries."Work Ticket No.");
                if Nosetup.Find('-') then LastNoUsed := Nosetup."Last No. Used";
            end;
        end;


        if "Ticket No." = '' then begin
            NoSeries.Get;
            NoSeries.TestField(NoSeries."Work Ticket No.");
            "Ticket No.":=NoSeriesMgt.GetNextNo(NoSeries."Work Ticket No.",  0D, true);
            "Previous W.T. No." := LastNoUsed;
        end;

        if xRec."Ticket No." <> '' then "Previous W.T. No." := xRec."Ticket No.";
    end;

    var
        NoSeries: Record "FLT-Fleet Mgt Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Nosetup: Record "No. Series Line";
        LastNoUsed: Code[10];
}

