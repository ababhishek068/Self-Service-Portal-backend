Table 50808 "HR Appraisal indicators"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Criteria; Code[20])
        {

            trigger OnValidate()
            begin
                /* Performsummary.SETRANGE(Performsummary.Criteria,Criteria);
                  IF Performsummary.FIND('-') THEN BEGIN
                     "Performance Indicator":=Performsummary.Description;
                      END;
                   */

            end;
        }
        field(3; "Performance Indicator"; Text[250]) { }
        field(4; "Appraisal Year"; Code[50]) { }
        field(5; "Code"; Code[10]) { }
        field(6; Remarks; Text[100]) { }
        field(8; Test1; Text[30]) { }
        field(9; Test; Text[30]) { }
        field(10; Test2; Text[30]) { }
    }

    keys
    {
        key(Key1; "Entry No", Criteria, "Code", "Appraisal Year")
        {
            Clustered = true;
        }
        key(Key2; "Code") { }
    }

    fieldgroups
    {
        fieldgroup(PerformanceIndicator; "Performance Indicator") { }
    }
}

