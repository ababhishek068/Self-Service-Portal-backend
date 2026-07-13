table 50966 "TrainingEvaluation lines"
{
    Caption = 'TrainingEvaluation lines';
    DataClassification = ToBeClassified;
    // DrillDownPageId="Probation lines";


    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
        }
        field(2; "Rate Code"; Integer)
        {
            Caption = 'Rate Code';
        }
        field(3; "Rate Factor"; Text[100])
        {
            Caption = 'Rate Factor';
        }
        field(4; "Value"; Integer)
        {
            Caption = 'Value';
        }
        field(5; "Provider"; Code[20])
        {
            Caption = 'Provider';
        }
        field(6; Rate; Option)

        {
            OptionMembers = Excellent,"Very Good",Good,Fair,"Below Expectation";
            //TableRelation="Probation Rating Scale"."Rating Name";
            trigger OnValidate()
            begin
                ratescales.Reset();
                ratescales.SetRange(ratescales."Rating Name", Rate);
                if ratescales.FindFirst() then begin
                    Value := ratescales.Value;
                end;

            end;
        }
        field(30; "Course code"; code[20]) { }
        field(31; "Training Need"; code[20]) { }
    }
    keys
    {
        key(PK; "Employee Code", "Course code", "Rate Code", "Training Need")
        {
            Clustered = true;
        }
    }
    var
        ratescales: Record "Probation Rating Scale";
}
