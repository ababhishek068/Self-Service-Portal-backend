table 50958 "Probation Rating Scale"
{
    Caption = 'Probation Rating Scale';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Integer)
        {
            Caption = 'Code';
            Editable = false;
        }
        field(2; "Rating Name"; Option)
        {
            Caption = 'Rating Name';
            OptionMembers ="",Excellent,"Very Good",Good,Fair,"Below Expectation";
            trigger OnValidate()
            begin
                if "Rating Name" = "Rating Name"::Excellent then begin
                    Value := 5;

                end else if "Rating Name" = "Rating Name"::"Very Good" then begin
                    Value := 4;

                end else if "Rating Name" = "Rating Name"::Good then begin
                    Value := 3;

                end else if "Rating Name" = "Rating Name"::Fair then begin
                    Value := 2;

                end else if "Rating Name" = "Rating Name"::"Below Expectation" then begin
                    Value := 1;

                end;

            end;
        }
        field(3; "Value"; Integer)
        {
            Caption = 'Value';
        }
    }
    keys
    {
        key(PK; "Rating Name")
        {
            Clustered = true;
        }
    }
}
