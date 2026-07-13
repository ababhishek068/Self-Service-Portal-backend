Table 50084 "Student Prerequisite Approval"
{

    fields
    {
        field(1; "Reg. Transaction ID"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Course Registration"."Reg. Transacton ID";
        }
        field(2; "Student No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(3; Programme; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(4; Stage; Code[20])
        {
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(5; Prerequisite; Text[150]) { }
        field(6; Mandatory; Boolean) { }
        field(7; Approved; Boolean) { }
    }

    keys
    {
        key(Key1; "Reg. Transaction ID", Prerequisite)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

