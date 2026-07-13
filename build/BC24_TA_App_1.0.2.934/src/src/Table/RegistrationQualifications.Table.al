Table 50276 "Registration Qualifications"
{
    LookupPageId = "Registration Qualifications";
    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Description = 'Stores the line no in the database';
        }
        field(2; "Service No."; Code[20])
        {
            Description = 'Stores the admission number in the database';
            TableRelation = "Registration Form"."Service Number";
        }
        field(3; "Subject Code"; Code[20])
        {
            Description = 'Stores the code of the subject in the database';
            TableRelation = "Application Setup Subjects".Code;
            trigger OnValidate()
            var
                SubJectsRec: Record "Application Setup Subjects";
            begin
                if SubJectsRec.get("Subject Code") then
                    Subject := SubJectsRec.Description;
            end;
        }
        field(4; Subject; Text[50])
        {

            Description = 'Stores the name of the subject in the database';

        }
        field(5; Grade; Code[20])
        {
            Description = 'Stores the code of the grade in the database';
            TableRelation = "Application Setup Grade".Code;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Service No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

