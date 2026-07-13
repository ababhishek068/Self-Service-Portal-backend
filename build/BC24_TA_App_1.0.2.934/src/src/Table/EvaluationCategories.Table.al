Table 50161 "Evaluation Categories"
{

    fields
    {
        field(1; Category; Option)
        {
            OptionMembers = ,General,Lecturer;
        }
        field(2; Section; Option)
        {
            OptionMembers = ,Administration,ICT,Library,Website,"Lecturer Evaluation";
        }
        field(3; "Sub Section"; Option)
        {
            OptionCaption = ' ,ADMINISTRATION,COURSE EVALUATION,ICT ,LIBRARY,WEBSITE,Course Objectives,Course Content and Teaching methodology,Materials and Physical Facilities,Availability of lecturer,Lecturer Preparedness and Delivery,Overall Rating';
            OptionMembers = " ",ADMINISTRATION,"COURSE EVALUATION","ICT ",LIBRARY,WEBSITE,"Course Objectives","Course Content and Teaching methodology","Materials and Physical Facilities","Availability of lecturer","Lecturer Preparedness and Delivery","Overall Rating";
        }
        field(4; "Evaluation Question"; Text[200]) { }
        field(5; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Lecturer Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(7; "Campus Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(8; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(9; "Quiz Count"; Integer)
        {
            CalcFormula = count("Lecturer Evaluation" where("Evaluation Question" = field("Evaluation Question"),
                                                             Category = field(Category),
                                                             Semester = field("Semester Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Staff No" = field("Lecturer Filter"),
                                                             "Unit Code" = field("Unit Filter")));
            FieldClass = FlowField;
        }
        field(10; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(11; "Quiz Score"; Decimal)
        {
            CalcFormula = sum("Lecturer Evaluation"."Question Score" where("Evaluation Question" = field("Evaluation Question"),
                                                                            Category = field(Category),
                                                                            Semester = field("Semester Filter"),
                                                                            "Campus Code" = field("Campus Filter"),
                                                                            "Staff No" = field("Lecturer Filter"),
                                                                            "Unit Code" = field("Unit Filter")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Category, Section, "Sub Section", "Evaluation Question")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

