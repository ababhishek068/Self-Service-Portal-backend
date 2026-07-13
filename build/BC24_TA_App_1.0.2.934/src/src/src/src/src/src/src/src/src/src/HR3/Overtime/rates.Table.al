
Table 51135 "Allowances Rates Setup"
{

    fields
    {
        field(1;EntryNo;Integer)
        {
        }
        field(2;"Allowance Code";Code[30])
        {
            TableRelation ="PR Transaction Codes"."Transaction Code";

            trigger OnValidate()
            begin
                if AllowancesN.Get("Allowance Code") then begin
                  "Allowance Name":=AllowancesN."Transaction Name";

                end else begin

                  "Allowance Name":='';
                end;
            end;
        }
        field(3;"6AM-6PM";Decimal)
        {
        }
        field(4;"6PM-10PM";Decimal)
        {
        }
        field(5;"Allowance Name";Text[100])
        {
        }
        field(6;"Job Title";Code[50])
        {
            TableRelation = "HR Jobs"."Job ID";
            

            trigger OnValidate()
            begin
                if jobs.Get("Job Title") then begin

                  "Job Description":=jobs."Job Description";
                end else begin
                  "Job Description":='';
                  end;
            end;
        }
        field(7;"Job Description";Text[100])
        {
        }
        field(8;"Public Holiday Rate";Decimal){}
        field(9;"Weekend";Decimal){}
        field(10;"HQ Branch";Code[20]){}
        field(11;"Sunday Rate";Decimal){}
        field(12;"Formula Based On";Decimal){}
        field(13;"10PM-6AM";Decimal){}
    }

    keys
    {
        key(Key1;"Allowance Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AllowancesN: Record "PR Transaction Codes";
        jobs: Record "HR Jobs";
}

