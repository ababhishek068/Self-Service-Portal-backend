Table 50351 "Int. Audit Meeting Attendance"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Meeting Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Meetings".Code where(Code = field("Meeting Code"));
        }
        field(3; Attendee; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            var
                TbUserSetup: record "User Setup";
            begin
                TbUserSetup.Reset();
                TbUserSetup.SetRange("User ID", Attendee);
                if TbUserSetup.FindFirst() then begin
                    Name := TbUserSetup.UserName;
                end;
            end;
        }
        field(6; Name; text[150])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("User Setup".UserName where("User ID" = field(Attendee)));
        }
        field(4; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Meeting Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

