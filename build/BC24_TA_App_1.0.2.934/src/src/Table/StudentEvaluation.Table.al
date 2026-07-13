table 50308 "Student Evaluation"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Student Evaluation";
    fields
    {
        field(1; "Student No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Course objectives were met"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Personal expectation met"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Course organization"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Content of training"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Relevance of training"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Quality of training"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Appropriateness of duration"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Appropriateness of venue"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "additional comments"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Suggusted Additional Area"; text[1000])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Other Intrested Training"; text[1000])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Student No")
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