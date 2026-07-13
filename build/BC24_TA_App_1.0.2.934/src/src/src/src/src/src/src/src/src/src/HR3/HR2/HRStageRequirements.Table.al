Table 50856 "HR Stage Requirements"
{

    fields
    {
        field(1; "Job Id"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Jobs"."Job ID";
        }
        field(2; "Qualification Type"; Code[200])
        {
            //  Caption = 'Qualification Description';
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification Type"));

            trigger OnValidate()
            begin
                /*
                Qualifications.RESET;
                Qualifications.SETRANGE(Qualifications.Code,"Qualification Description");
                IF Qualifications.FIND('-') THEN
                "Qualification Code":=Qualifications.Description;
                */

            end;
        }
        field(3; "Qualification Code"; Code[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = filter(Course), Category = field("Qualification Type"), "Sub Category" = field("Qualification Category"));
            trigger OnValidate()
            var
                HRLookup: record "HR Lookup Values";
            begin
                HRLookup.reset;
                HRLookup.setrange(Code, "Qualification Code");
                HRLookup.setrange(Type, HRLookup.type::Course);
                if HRLookup.find('-') then begin
                    "Desired Score" := HRLookup.Score;
                    "Qualification Description" := HRLookup.Description;
                end;
            end;
        }
        field(6; Priority; Option)
        {
            OptionMembers = " ",High,Medium,Low;
        }
        field(8; Score; Decimal) { }
        field(9; "Need code"; Code[10])
        {

            trigger OnValidate()
            begin
                HREmployeeRequisitions.Reset;
                HREmployeeRequisitions.SetRange("Requisition No.", "Need code");
                if HREmployeeRequisitions.Find('-') then begin
                    "Job Id" := HREmployeeRequisitions."Job ID";
                end;
            end;
        }
        field(10; "Stage Code"; Code[20])
        {
            // TableRelation = "HR Lookup Values".Code where(Type = const(Scores));
        }
        field(11; Mandatory; Boolean) { }
        field(12; "Desired Score"; Decimal) { }
        field(13; "Total (Stage)Desired Score"; Decimal) { }
        field(14; "Qualification Description"; Text[100]) { }
        field(15; "Grade Attained"; Code[30])
        {
            TableRelation = "Academic Classification".Classification where(Qualification = field("Qualification Type"));


            trigger OnValidate()
            begin
                if "Qualification Category" = 'ACADEMIC' then begin
                    AcademicClassification.Reset;
                    AcademicClassification.SetRange(Qualification, "Qualification Type");
                    AcademicClassification.SetRange(Classification, "Grade Attained");
                    if AcademicClassification.Find('-') then begin
                        "Desired Score" := AcademicClassification.Score;
                    end;
                end;
            end;
        }
        field(16; "Qualification Category"; Code[30])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification category"), Category = field("Qualification Type"));

            trigger OnValidate()
            begin
                if "Qualification Category" = 'EXPERIENCE' then begin
                    "Qualification Code" := 'EXPERIENCE';
                    "Qualification Type" := 'EXPERIENCE';
                end;
            end;
        }
        field(17; "Field of Reasearch"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "No. Of Authors"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; Complete; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Interview; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Stage Code", "Qualification Type", "Qualification Code", "Qualification Category")
        {
            Clustered = true;
            SumIndexFields = Score;
        }
    }

    fieldgroups { }

    var
        AcademicClassification: Record "Academic Classification";
        HREmployeeRequisitions: Record "HR Employee Requisitions";
}

