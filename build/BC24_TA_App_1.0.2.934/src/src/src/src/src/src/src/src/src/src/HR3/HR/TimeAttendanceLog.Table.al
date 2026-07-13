table 50183 "Time Attendance Log"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; serialNo; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; employeeID; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(3; authDateTime; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; authDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; authTime; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(6; direction; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; deviceName; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; deviceSerialNo; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; personName; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; cardNo; Code[50])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; serialNo)
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