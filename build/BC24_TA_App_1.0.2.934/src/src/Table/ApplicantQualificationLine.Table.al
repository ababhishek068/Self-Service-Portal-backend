Table 50782 "Applicant Qualification Line"
{
    //  Job ID,Requirements


    fields
    {
        field(1; "Entry No"; Integer) { }
        field(2; "Applicant ID"; Code[20]) { }
        field(3; "Qualification code"; Code[20])
        {
            TableRelation = "HR Qualifications".Code where("Qualification Type" = field("Qualification Type"));

            trigger OnValidate()
            begin
                /*JobRq.SETRANGE(JobRq."Job Specification","Qualification code");
                JobRq.SETRANGE(JobRq."Qualification Type","Job ID");
                IF JobRq.FIND('-') THEN
                "Qualification Description":=JobRq."Qualification Code";
                Creteria.SETCURRENTKEY("Job ID",Requirements);
                Creteria.SETRANGE("Job ID","Job ID");
                Creteria.SETRANGE(Creteria.Requirements,"Qualification code");
                IF Creteria.FIND('-') THEN
                 IF Desiredscore.GET(Creteria.Score) THEN
                 "Desired Score" :=Desiredscore.Score;
               */
                if HRQualifications.Get("Qualification Type", "Qualification code") then
                    "Qualification Description" := HRQualifications.Description;

            end;
        }
        field(4; "Qualification Description"; Text[250]) { }
        field(5; "Job ID"; Code[20])
        {
            TableRelation = "Company Jobs";

            trigger OnValidate()
            begin
                if Qualification.Get("Qualification code") then
                    "Qualification Description" := Qualification.Description;
            end;
        }
        field(6; Qualified; Boolean) { }
        field(7; "From Date"; Date) { }
        field(8; "To Date"; Date) { }
        field(9; Institution; Text[200]) { }
        field(10; "Qualification Type"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification Type"));
        }
        field(11; "No of Years"; Decimal) { }
        field(12; "Actual Score"; Code[20])
        {
            // TableRelation = "Score Setup"."Score ID";

            trigger OnValidate()
            begin
                if Desiredscore.Get("Actual Score") then
                    ;
            end;
        }
        field(13; "Desired Score"; Integer) { }
        field(14; ActualScore; Decimal) { }
        field(15; "Recruitment Stage"; Integer)
        {
            TableRelation = "Recruitment Stages";
        }
        field(16; "User ID"; Code[20]) { }

        field(17; "Membership No"; Text[30]) { }
        field(18; "Membership Status"; Option)
        {
            OptionMembers = ,Active,Inactive;
        }
        field(19; "Publication/Research Descripti"; Text[250]) { }
        field(20; Grade; Code[20])
        {
            TableRelation = "Academic Qua Grades"."Grade Code";
        }
    }

    keys
    {
        key(Key1; "Applicant ID", "Entry No", "Qualification Type", "Qualification code")
        {
            Clustered = true;
            SumIndexFields = ActualScore;
        }
        key(Key2; "User ID")
        {
            SumIndexFields = ActualScore;
        }
    }

    fieldgroups { }

    var
        Qualification: Record Qualification;
        Desiredscore: Record "Score Setup";
        HRQualifications: Record "HR Qualifications";
}

