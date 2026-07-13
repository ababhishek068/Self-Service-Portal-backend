table 50014 "Programme Categories"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Category; Option)
        {
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,PHD,Professional,Course List,Post Graduate Diploma';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List","Post Graduate Diploma";

            DataClassification = ToBeClassified;


        }
        field(3; "Application Fee Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Charge.Code;

        }
        field(4; "Application Fee Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Claim Per Unit"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Claim Per Additional Unit"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Maximum Students"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Fee Per Credit Hour"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Dean List Min. GPA"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Dean List Min. Credit"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Probation List Max. GPA"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

        field(13; "Admissions Letter Report ID"; Integer)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; Code)
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