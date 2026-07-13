Table 50062 "Lecturer Evaluation"
{

    fields
    {
        field(1; "Student No"; Code[20]) { }
        field(2; "Unit Code"; Code[20]) { }
        field(3; Semester; Code[20])
        {
            TableRelation = Semesters.Code;
        }
        field(4; Stage; Code[20]) { }
        field(5; "Staff No"; Code[20])
        {
            TableRelation = "Lecturers Units".Lecturer;
        }
        field(6; Programme; Code[20])
        {
            TableRelation = Programme.Code;
        }
        field(7; "Staff Name"; Text[100]) { }
        field(8; "Evaluation Question"; Text[250]) { }
        field(9; "Evaluation Category"; Text[30]) { }
        field(10; "Question Score"; Decimal) { }
        field(11; "What you Liked"; Text[100]) { }
        field(12; "What you never Like"; Text[100]) { }
        field(13; Suggestions; Text[100]) { }
        field(14; "Line No"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(15; Category; Option)
        {
            OptionMembers = ,General,Lecturer;
        }
        field(16; Section; Option)
        {
            OptionMembers = ,Objective,"Course Content and methodology","Materials and Physical Facilities",Assignments,"Availability of lecturer","Course Delivery";
        }
        field(17; "Sub Section"; Option)
        {
            OptionCaption = ' ,ADMINISTRATION,COURSE EVALUATION,ICT ,LIBRARY,WEBSITE,Course Objectives,Course Content and Teaching methodology,Materials and Physical Facilities,Availability of lecturer,Lecturer Preparedness and Delivery,Overall Rating';
            OptionMembers = " ",ADMINISTRATION,"COURSE EVALUATION","ICT ",LIBRARY,WEBSITE,"Course Objectives","Course Content and Teaching methodology","Materials and Physical Facilities","Availability of lecturer","Lecturer Preparedness and Delivery","Overall Rating";
        }
        field(18; "Sub Section Lk"; Option)
        {
            CalcFormula = lookup("Evaluation Categories"."Sub Section" where(Section = field(Section),
                                                                              "Evaluation Question" = field("Evaluation Question")));
            FieldClass = FlowField;
            OptionCaption = ' ,ADMINISTRATION,COURSE EVALUATION,ICT ,PRESENTATION OF THE SUBJECT,LIBRARY,OVERALL EVALUATION OF THE LECTURER,TEACHING METHODS,WEBSITE';
            OptionMembers = " ",ADMINISTRATION,"COURSE EVALUATION","ICT ","PRESENTATION OF THE SUBJECT",LIBRARY,"OVERALL EVALUATION OF THE LECTURER","TEACHING METHODS",WEBSITE;
        }
        field(19; "Stud Sub Sect Count"; Integer)
        {
            CalcFormula = count("Lecturer Evaluation" where("Unit Code" = field("Unit Code"),
                                                             Semester = field(Semester),
                                                             Programme = field(Programme),
                                                             "Staff No" = field("Staff No"),
                                                             Section = field(Section),
                                                             "Sub Section" = field("Sub Section"),
                                                             "Student No" = field("Student No")));
            FieldClass = FlowField;
        }
        field(20; "Stud Sub Sect Total"; Decimal)
        {
            CalcFormula = sum("Lecturer Evaluation"."Question Score" where("Unit Code" = field("Unit Code"),
                                                                            Semester = field(Semester),
                                                                            Programme = field(Programme),
                                                                            "Staff No" = field("Staff No"),
                                                                            Section = field(Section),
                                                                            "Sub Section" = field("Sub Section"),
                                                                            "Student No" = field("Student No")));
            FieldClass = FlowField;
        }

        field(22; "Campus Code"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No")));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(23; "Stud Unit Count"; Integer)
        {
            CalcFormula = count("Lecturer Evaluation" where("Unit Code" = field("Unit Code"),
                                                             Semester = field(Semester),
                                                             "Staff No" = field("Staff No"),
                                                             "Sub Section" = field("Sub Section"),
                                                             "Campus Code" = field("Campus Code"),
                                                             // "Mode of Study" = field("Mode of Study"),
                                                             "Evaluation Question" = field("Evaluation Question")));
            FieldClass = FlowField;
        }
        field(24; "Stud Unit Score"; Decimal)
        {
            CalcFormula = sum("Lecturer Evaluation"."Question Score" where("Unit Code" = field("Unit Code"),
                                                                            Semester = field(Semester),
                                                                            "Staff No" = field("Staff No"),
                                                                            "Sub Section" = field("Sub Section")));
            FieldClass = FlowField;
        }
        field(25; "Lec Unit Count"; Integer)
        {
            CalcFormula = count("Lecturer Evaluation" where("Unit Code" = field("Unit Code"),
                                                             Semester = field(Semester),
                                                             "Staff No" = field("Staff No")));
            FieldClass = FlowField;
        }
        field(26; "Lec Unit Score"; Decimal)
        {
            CalcFormula = sum("Lecturer Evaluation"."Question Score" where("Unit Code" = field("Unit Code"),
                                                                            Semester = field(Semester),
                                                                            "Staff No" = field("Staff No")));
            FieldClass = FlowField;
        }
        field(27; "Lec Count"; Integer)
        {
            CalcFormula = count("Lecturer Evaluation" where(Semester = field(Semester),
                                                             "Staff No" = field("Staff No")));
            FieldClass = FlowField;
        }
        field(28; "Lec Score"; Decimal)
        {
            CalcFormula = sum("Lecturer Evaluation"."Question Score" where(Semester = field(Semester),
                                                                            "Staff No" = field("Staff No")));
            FieldClass = FlowField;
        }
        field(29; "Department Code"; Code[20])
        {
            CalcFormula = lookup(Programme."Department Code" where(Code = field(Programme)));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(30; "Quiz Code"; Code[20])
        {
            CalcFormula = lookup("Evaluation Categories".Code where("Evaluation Question" = field("Evaluation Question")));
            FieldClass = FlowField;
        }
        field(31; "School Code"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(32; "Sub Section Item"; code[50])
        {
            TableRelation = "Lecturer Evaluation Items";
        }

    }

    keys
    {
        key(Key1; "Unit Code", "Student No", Programme, Semester, "Evaluation Question", "Staff No", Category, Section)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

