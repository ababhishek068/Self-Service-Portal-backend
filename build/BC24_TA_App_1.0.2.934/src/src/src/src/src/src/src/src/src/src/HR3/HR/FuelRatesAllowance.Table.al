table 51018 "Fuel Rates Allowance"
{
    Caption = 'Fuel Rates Allowance';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Payroll Period"; date)
        {
            Caption = 'Payroll Period';
            TableRelation="PR Payroll Periods"."Date Opened" where(Closed=filter(false));
           

            trigger OnValidate()
             var
             prperiods: Record "PR Payroll Periods";
            begin
                prperiods.Reset();
                prperiods.SetRange(prperiods."Date Opened",rec."Payroll Period");
                prperiods.SetRange(prperiods.closed,false);
                if prperiods.FindFirst() then begin
                    "Payroll Open Date":=prperiods."Date Opened";
                end;

            end;
        }
        field(2; "Payroll Open Date"; Date)
        {
            Caption = 'Payroll Open Date';
        }
        field(3; "Rate(ETB) per Litre"; decimal)
        {
            Caption = 'Rate(ETB) per Litre';
        }
    }
    keys
    {
        key(PK; "Payroll Period")
        {
            Clustered = true;
        }
    }
}
