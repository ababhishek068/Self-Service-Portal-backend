Table 50098 "Units Classes"
{


    fields
    {
        field(1; Programme; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(2; Stage; Code[20])
        {
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(3; "Code"; Code[20]) { }
        field(4; Description; Text[150])
        {
            NotBlank = true;
        }
        field(5; Unit; Code[20])
        {
            NotBlank = true;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme),
                                                         "Stage Code" = field(Stage));
        }
    }

    keys
    {
        key(Key1; Programme, Stage, Unit, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

