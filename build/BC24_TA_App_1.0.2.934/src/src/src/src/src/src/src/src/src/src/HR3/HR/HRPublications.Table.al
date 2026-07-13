Table 50470 "HR Publications"
{

    fields
    {
        field(1; username; Code[30]) { }
        field(2; "Email Address"; Code[30]) { }
        field(3; Author; Text[100]) { }
        field(4; "Title Of Publication"; Text[200]) { }
        field(5; Publisher; Text[150]) { }
        field(6; "Year Of Publication"; Code[30]) { }
        field(7; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(8; "Field"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Number of Authors"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Position of Author"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("Number of Authors" <> 0) and ("Position of Author" <> 0) then begin
                    //Score:=16*(("Number of Authors"+1-"Position of Author")/("Number of Authors"*("Number of Authors"+1)));
                    Score := ROUND(16 * (("Number of Authors" + 1 - "Position of Author") / ("Number of Authors" * ("Number of Authors" + 1))), 0.01, '=');
                end;
            end;
        }
        field(11; "Field of Research"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Score; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Score Per Field"; Decimal)
        {
            CalcFormula = sum("HR Publications".Score where("Email Address" = field("Email Address"),
                                                             Field = field(Field)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; username, "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

