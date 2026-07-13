table 50169 "Deployment Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Serial No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Registration Form"."Serial No" where(Status = filter(Confirmed), Barrack = field(Barrack));
            trigger OnValidate()
            var
                RegForm: Record "Registration Form";
            begin
                if RegForm.get("Serial No") then begin
                    Names := RegForm."Full Names";
                    Gender := RegForm.Gender;
                    Tribe := RegForm.Tribe;
                    Region := RegForm.Region;
                end;
            end;
        }
        field(3; "Deployment No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Names"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Academy Confirmed"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Gender"; option)
        {
            OptionMembers = ,Male,Female;
            DataClassification = ToBeClassified;
        }
        field(7; "Tribe"; code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = sub.Code;--felix
        }
        field(8; "Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Region.code;

        }
        field(9; "Barrack"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Barracks".Code;
        }
        field(10; "Document Verified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Remarks; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Deployment No", "Serial No")
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