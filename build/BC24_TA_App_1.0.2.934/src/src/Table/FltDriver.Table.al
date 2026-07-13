Table 50860 "Flt Driver"
{
    DrillDownPageID = "Flt Driver List";
    LookupPageID = "Flt Driver List";

    fields
    {
        field(1; Driver; Code[10])
        {
            TableRelation = "HR-Employee"."No." where(Driver = const(true));

            trigger OnValidate()
            begin
                Emp.Reset;
                Emp.Get(Driver);
                "Driver Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                Grade := emp."Job Group";
            end;
        }
        field(2; "Driver Name"; Text[100]) { }
        field(3; "Driver License Number"; Code[20]) { }
        field(4; "Last License Renewal"; Date) { }
        field(5; "Renewal Interval"; Option)
        {
            OptionMembers = " ",Days,Weeks,Months,Quarterly,Years;
        }
        field(6; "Renewal Interval Value"; Integer)
        {

            trigger OnValidate()
            begin
                StrValue := 'D';

                if "Renewal Interval" = "renewal interval"::Days then begin
                    StrValue := 'D';
                end
                else
                    if "Renewal Interval" = "renewal interval"::Weeks then begin
                        StrValue := 'W';
                    end
                    else
                        if "Renewal Interval" = "renewal interval"::Months then begin
                            StrValue := 'M';
                        end
                        else
                            if "Renewal Interval" = "renewal interval"::Quarterly then begin
                                StrValue := 'Q';
                            end
                            else
                                if "Renewal Interval" = "renewal interval"::Years then begin
                                    StrValue := 'Y';
                                end;

                "Next License Renewal" := CalcDate(Format("Renewal Interval Value") + StrValue, "Last License Renewal");
            end;
        }
        field(7; "Next License Renewal"; Date) { }
        field(8; "Year Of Experience"; Decimal) { }
        field(9; Grade; Code[20]) { }
        field(10; Active; Boolean) { }
        field(11; "License Class"; Code[20]) { }
        field(12; "Fuel Card No"; Code[20])
        {
            TableRelation = "Fuel Card Setup"."Card No";
        }
        field(112; "Fuel Card Max. Value"; Decimal) { }
        field(13; "Vehicle Assigned"; Code[20])
        {
            TableRelation = "FLT-Vehicle Header"."No.";
        }
        field(14; "Drivers Status"; Option)
        {
            OptionMembers = " ",Available,Engaged,Unavailable;
        }
        field(15; "Driver Type"; Option)
        {
            OptionMembers = Driver,Coxswain;
            OptionCaption = 'Driver,Coxswain';
        }


    }
    keys
    {
        key(Key1; Driver)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Emp: Record "HR-Employee";
        StrValue: Text[1];
}

