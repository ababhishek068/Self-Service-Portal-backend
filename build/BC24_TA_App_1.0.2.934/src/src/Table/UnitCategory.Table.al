table 50097 "Unit Category"
{
    DataClassification = ToBeClassified;
    // LookupPageId = "Unit Category";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Unit Type"; Option)
        {
            OptionCaption = 'Core,Elective,Required,Free Elective,General Education';
            OptionMembers = Core,Elective,Required,"Free Elective","General Education";
        }
        field(4; "Report Order"; integer)
        {
            DataClassification = ToBeClassified;


        }
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