table 50178 "Service Transfer Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Serial No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Registration Form"."Serial No" where(Status = filter(Service), "Current Station" = field("Service Unit"));
            trigger OnValidate()
            var
                RegForm: Record "Registration Form";
            begin
                if RegForm.get("Serial No") then begin
                    Names := Regform."Full Names";
                    Gender := RegForm.Gender;
                    Tribe := RegForm.Tribe;
                    Region := RegForm.Region;
                end;
            end;
        }
        field(2; "Allocation No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Names"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Service Unit"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Main Duty"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Sub Duty"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Gender"; option)
        {
            OptionMembers = ,Male,Female;
            DataClassification = ToBeClassified;
        }
        field(8; "Tribe"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Tribe"."Sub Tribe Code";
        }
        field(9; "Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Region.code;

        }
    }

    keys
    {
        key(Key1; "Serial No", "Allocation No", "Service Unit", "Main Duty", "Sub Duty")
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