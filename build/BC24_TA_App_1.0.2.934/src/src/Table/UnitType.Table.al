table 50148 "Unit Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Unit Type";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Unit Type"; option)
        {
            OptionCaption = 'Core,Elective,Required';
            OptionMembers = Core,Elective,Required;
            DataClassification = ToBeClassified;
        }
        field(3; Description; text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; code, "Unit Type")
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