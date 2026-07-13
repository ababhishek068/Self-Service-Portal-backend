Table 50646 "FLT-Daily Work Ticket Lines"
{


    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Ticket No."; Code[20]) { }
        field(3; "Work Date"; Date)
        {

            trigger OnValidate()
            begin
                months := 0;
                if "Work Date" <> 0D then begin
                    Year := Date2dmy("Work Date", 3);
                    months := Date2dmy("Work Date", 2);


                    if months = 1 then
                        Month := Month::JANUARY else
                        if months = 2 then
                            Month := Month::FEBRUARY else
                            if months = 3 then
                                Month := Month::MARCH else
                                if months = 4 then
                                    Month := Month::APRIL else
                                    if months = 5 then
                                        Month := Month::MAY else
                                        if months = 6 then
                                            Month := Month::JUNE else
                                            if months = 7 then
                                                Month := Month::JULY else
                                                if months = 8 then
                                                    Month := Month::AUGUST else
                                                    if months = 9 then
                                                        Month := Month::SEPTEMBER else
                                                        if months = 10 then
                                                            Month := Month::OCTOBER else
                                                            if months = 11 then
                                                                Month := Month::NOVEMBER else
                                                                if months = 12 then Month := Month::DECEMBER;
                end;
                Modify;
            end;
        }
        field(4; "Reg. No."; Code[20]) { }
        field(5; Make; Text[30]) { }
        field(6; Type; Text[30]) { }
        field(7; "Driver No."; Code[20])
        {
            TableRelation = "Flt Driver".Driver;
        }
        field(8; "Driver Name"; Text[50])
        {
            CalcFormula = lookup("HR-Employee"."First Name" where("No." = field("Driver No.")));
            FieldClass = FlowField;
        }
        field(9; "Departure From"; Text[100]) { }
        field(10; "Start Milleage"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Start Milleage" > 0.0 then
                    if "End Milleage" > 0.0 then
                        "Kilometers Covered" := "End Milleage" - "Start Milleage" else
                        "Kilometers Covered" := 0.0;
                Modify;
            end;
        }
        field(11; "End Milleage"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Start Milleage" > 0.0 then
                    "Kilometers Covered" := "End Milleage" - "Start Milleage" else
                    "Kilometers Covered" := 0.0;
                Modify;
            end;
        }
        field(12; "Time Out"; Time) { }
        field(13; "Time In"; Time) { }
        field(14; "Fuel Consumed (Litres)"; Decimal) { }
        field(15; "Fuel Cost (Total)"; Decimal) { }
        field(16; "Kilometers Covered"; Decimal)
        {

            trigger OnValidate()
            begin
                /*ticketHeader.RESET;
                ticketHeader.SETRANGE(ticketHeader."Ticket No.","Ticket No.");
                IF ticketHeader.FIND('-') THEN
                  BEGIN
                    vehicle.RESET;
                    vehicle.SETRANGE(vehicle."Registration No.",ticketHeader."G.K. No.");
                    IF vehicle.FIND('-') THEN
                      BEGIN
                        "Fuel Consumed (Litres)":=vehicle."Fuel Consumption (Litres/KM)"*"Kilometers Covered";
                        "Total Oil Consumed":=vehicle."Oil Consuption (Litres/KM)"*"Kilometers Covered";
                      END;
                  END;*/

            end;
        }
        field(17; Posted; Boolean) { }
        field(18; "Total Oil Consumed"; Decimal) { }
        field(20; Month; Option)
        {
            OptionMembers = " ",JANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER;
        }
        field(21; Year; Option)
        {
            OptionMembers = " ","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040","2041","2042","2043","2044","2045","2046","2047","2048","2049","2050","2051","2052","2053","2054","2055","2056","2057","2058","2059","2060";
        }
        field(22; Status; Option)
        {
            OptionMembers = Open,Closed;
        }
        field(23; "Authorizing Officer No"; Code[10])
        {
            TableRelation = "FLT-Ticket Authorizing Off."."Officer No." where("Ticket No." = field("Ticket No."));
        }
        field(24; "Authorizing Officer Name"; Text[30])
        {
            CalcFormula = lookup("HR-Employee"."First Name" where("No." = field("Authorizing Officer No")));
            FieldClass = FlowField;
        }
        field(25; Destination; Text[100]) { }
        field(26; "Voucher No."; Code[20]) { }
    }

    keys
    {
        key(Key1; "Line No.", "Ticket No.")
        {
            Clustered = true;
            SumIndexFields = "Total Oil Consumed", "Fuel Consumed (Litres)", "Fuel Cost (Total)", "Kilometers Covered";
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Work Date" := Today;
    end;

    var
        months: Integer;
}

