table 50185 "Region"
{
    DataClassification = ToBeClassified;
    LookupPageId = "List of Regions";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Target; decimal)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            DecimalPlaces = 0;
        }
        field(4; Achieved; integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Registration Form" where(Region = field(Code)));
            BlankZero = true;


        }
        field(5;"Taxed";Boolean){}
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}