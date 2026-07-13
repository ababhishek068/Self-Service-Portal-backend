Table 50843 "HR Human Resource Comments"
{

    fields
    {
        field(1; "Table Name"; Option)
        {
            OptionMembers = Employee,Relative,"Relation Management","Correspondence History",Images,"Absence and Holiday","Cost to Company","Pay History","Bank Details",Maternity,"SAQA Training History","Absence Information","Incident Report","Emp History","Medical History","Career History",Appraisal,Disciplinary,"Exit Interviews",Grievances,"Existing Qualifications","Proffesional Membership","Education Assistance","Learning Intervention","NOSA or other Training","Company Skills Plan","Development Plan","Skills Plan","Emp Salary",Unions;
        }
        field(2; "No."; Code[20]) { }
        field(3; "Table Line No."; Code[10]) { }
        field(4; "Key Date"; Date) { }
        field(5; Tear; Integer) { }
        field(6; "Line No."; Integer) { }
        field(7; Date; Date) { }
        field(8; "Code"; Code[10]) { }
        field(9; Comment; Text[80]) { }
        field(10; User; Text[30]) { }
    }

    keys
    {
        key(Key1; "No.", "Table Name", "Table Line No.")
        {
            Clustered = true;
        }

    }

    fieldgroups { }

    trigger OnInsert()
    var
        lRec_UserTable: Record User;
    begin

        lRec_UserTable.Get(UserId);
        User := lRec_UserTable."Full Name";
        Date := WorkDate;
    end;

    trigger OnModify()
    var
        lRec_UserTable: Record User;
    begin

        lRec_UserTable.Get(UserId);
        User := lRec_UserTable."Full Name";
        Date := WorkDate;
    end;

    procedure SetUpNewLine()
    var
        HumanResCommentLine: Record "HR Human Resource Comments";
    begin
        HumanResCommentLine := Rec;
        HumanResCommentLine.SetRecfilter;
        HumanResCommentLine.SetRange("Line No.");
        if not HumanResCommentLine.Find('-') then
            Date := WorkDate;
    end;
}

