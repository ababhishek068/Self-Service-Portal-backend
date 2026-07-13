Table 50785 "Appraisal Objective"
{

    fields
    {
        field(1; "No Series"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal Code"; Code[50]) { }
        field(3; "HOD  Comments"; Text[250]) { }
        field(4; "Appraisee Comments"; Text[250]) { }
        field(5; Ratings; Decimal)
        {
            TableRelation = "Appraisal Ratings".Rating;

            trigger OnValidate()
            begin
                AppRating.SetRange(AppRating.Rating, Ratings);
                if AppRating.Find('-') then begin
                    "Rating Description" := AppRating.Description;
                end;
            end;
        }
        field(6; Objectives; Text[250]) { }
        field(7; "Performance Indicator Code"; Code[10])
        {
            TableRelation = "HR Appraisal indicators".Code where(Criteria = field("Criteria Code"));

            trigger OnValidate()
            begin
                Indctrs.SetRange(Indctrs."Performance Indicator", "Performance Indicator Code");
                if Indctrs.Find('-') then begin
                    "Performance Indicator Descript" := Indctrs."Performance Indicator";
                end;
            end;
        }
        field(11; "Criteria Code"; Code[10])
        {
            TableRelation = "Appraisal Criteria".Criteria;

            trigger OnValidate()
            begin

                Crteria.SetRange(Crteria.Criteria, "Criteria Code");
                if Crteria.Find('-') then begin
                    "Criteria Description" := Crteria.Description;
                end;
            end;
        }
        field(12; "Performance Indicator Descript"; Text[250]) { }
        field(50006; "Agreed Rating Point"; Decimal) { }
        field(50007; "Employee Rating Percentage"; Decimal) { }
        field(50008; "Agreed rating Percentage"; Decimal) { }
        field(50009; "Staff No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                //HrEmp.SETRANGE(HrEmp."No.","Staff No");
                //IF HrEmp.FIND('-') THEN
                //"Staff Name":=HrEmp."First Name"+'  ' +HrEmp."Middle Name"+'  '+ HrEmp."Last Name";
            end;
        }
        field(50010; "Criteria Description"; Text[250]) { }
        field(50011; "Weak Areas Discussed"; Text[250]) { }
        field(50012; "Rating Description"; Text[100]) { }
        field(50013; "HOD Asssement Summary"; Text[250]) { }
    }

    keys
    {
        key(Key1; "No Series", "Appraisal Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Crteria: Record "Appraisal Criteria";
        Indctrs: Record "HR Appraisal indicators";
        AppRating: Record "Appraisal Ratings";
}

