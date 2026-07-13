table 50441 "Equipment Maint Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Asset No."; code[20])
        {
            TableRelation = "Fixed Asset"."No.";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                FA: Record "Fixed Asset";
            begin
                if fa.get("Asset No.") then "Description." := fa.Description;
            end;
        }
        field(2; "Description."; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Serial No."; code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Date of Calibration"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Date due for Calibration"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Remarks"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Type; Option)
        {
            OptionMembers = ,Calibration,Maintainance;
            OptionCaption = ',Calibration,Maintainance';
            DataClassification = ToBeClassified;
        }
        field(8; "Correction Measure"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Time Frame"; text[200])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Asset No.")
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