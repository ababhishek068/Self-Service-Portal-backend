Table 50101 "Units/Subjects"
{
    DrillDownPageID = "Units/Subjects";
    LookupPageID = "Units/Subjects";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = false;
            TableRelation = Programme.Code;
        }
        field(2; "Stage Code"; Code[20])
        {
            Description = '"Programme Stages".Code WHERE (Programme Code=FIELD(Programme Code))';
            NotBlank = false;
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Unit Code';
            NotBlank = true;
            TableRelation = "Courses Master".Code;
            trigger OnValidate()
            var
                CMaster: Record "Courses Master";
            begin
                if Cmaster.get(Code) then begin
                    Desription := Cmaster.Description;
                    "No. Units" := cmaster.Units;
                    //"Unit Type" := cmaster."Unit Type";
                end;
            end;
        }
        field(4; Desription; Text[150])
        {
            Editable = false;

        }
        field(5; "Credit Hours"; Decimal) { }
        field(6; Amount; Decimal) { }
        field(7; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(9; Remarks; Text[150]) { }
        field(10; "Programme Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(11; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(12; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Filter"),
                                                         "Stage Code" = field("Stage Filter"));
        }
        field(13; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Filter"));
        }
        field(14; "Lecture Room Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Lecture Room".Code;
        }
        field(15; "Total Income"; Decimal)
        {
            CalcFormula = sum("Student Charges"."Amount Paid" where(Programme = field("Programme Code"),
                                                                     Stage = field("Stage Code"),
                                                                     Unit = field(Code),
                                                                     Semester = field("Semester Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Students Registered"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field("Programme Code"),
                                                       Unit = field(Code),
                                                       Semester = field("Semester Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Unit Type"; Option)
        {
            OptionCaption = 'Core,Elective,Required,Free Elective,General Education';
            OptionMembers = Core,Elective,Required,"Free Elective","General Education";
        }
        field(18; "Class Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Course Classes".Code where(Programme = field("Programme Filter"),
                                                         Stage = field("Stage Filter"));
        }
        field(19; "Student Type"; Option)
        {
            OptionCaption = ' ,Full Time,Part Time,Distance Learning';
            OptionMembers = " ","Full Time","Part Time","Distance Learning";
        }
        field(20; "Day Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Day Of Week".Day;
        }
        field(21; "Unit Class Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units Classes".Code where(Programme = field("Programme Code"),
                                                        Stage = field("Stage Code"));
        }
        field(22; Allocation; Decimal)
        {
            CalcFormula = sum("Time Table"."No. Of Hours" where(Programme = field("Programme Code"),
                                                                 Stage = field("Stage Code"),
                                                                 Unit = field(Code),
                                                                 "Day of Week" = field("Day Filter"),
                                                                 Period = field("Lesson Filter")));
            FieldClass = FlowField;
        }
        field(23; "Exam Filter"; Code[20])
        {
            FieldClass = FlowFilter;

        }
        field(24; "Exam Date"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(25; Tested; Boolean) { }
        field(50; Prerequisite; Code[20])
        {
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Code"));
        }
        field(51; "Lesson Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Lessons.Code;
        }
        field(52; "Common Unit"; Boolean) { }
        field(53; "No. Units"; Decimal)
        {
            InitValue = 3;
        }
        field(54; "Programme Option"; Code[50])
        {
            TableRelation = "Programme Options".Code where("Programme Code" = field("Programme Code"));
        }
        field(55; "Reg. ID Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Course Registration"."Reg. Transacton ID" where("Student No." = field("Student No. Filter"));
        }
        field(56; "Student No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Customer."No.";
        }
        field(57; "Total Score"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where("Student No." = field("Student No. Filter"),
                                                                 Programme = field("Programme Code"),
                                                                 Unit = field(Code),
                                                                 Cancelled = const(false),
                                                                 Semester = field("Semester Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Unit Registered"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No. Filter"),
                                                       Unit = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Re-Sit"; Integer)
        {
            CalcFormula = count("Student Units" where("Reg. Transacton ID" = field("Reg. ID Filter"),
                                                       "Student No." = field("Student No. Filter"),
                                                       Programme = field("Programme Code"),
                                                       Stage = field("Stage Code"),
                                                       Unit = field(Code),
                                                       Taken = const(true),
                                                       "Repeat Unit" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; Audit; Integer)
        {
            CalcFormula = count("Student Units" where("Reg. Transacton ID" = field("Reg. ID Filter"),
                                                       "Student No." = field("Student No. Filter"),
                                                       Programme = field("Programme Code"),
                                                       Stage = field("Stage Code"),
                                                       Unit = field(Code),
                                                       Taken = const(true),
                                                       Audit = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; Submited; Boolean) { }
        field(62; "Exam Status"; Option)
        {
            OptionCaption = ' ,Setting,Moderated,Submision,Typing,Proofreading,Printing,Ready,Collected,Returns (Incidence Form/Checklist/Invigilator Report)';
            OptionMembers = " ",Setting,Moderated,Submision,Typing,Proofreading,Printing,Ready,Collected,"Returns (Incidence Form/Checklist/Invigilator Report)";

            trigger OnValidate()
            begin
                /*
                IF GETFILTER("Semester Filter") = '' THEN
                ERROR('You must specify the semester.');
                
                IF xRec."Exam Status" <> "Exam Status" THEN BEGIN
                StatusC.INIT;
                StatusC."No.":="Programme Code";
                StatusC.Date:="Stage Code";
                StatusC."Currency Factor":=Code;
                StatusC."Currency Code":="Exam Status";
                StatusC.Date:=TODAY;
                StatusC."User ID":=USERID;
                StatusC."Programme Option":="Programme Option";
                StatusC.Semester:=GETFILTER("Semester Filter");
                StatusC.Payee:="Exam Remarks";
                StatusC.INSERT;
                
                END;
                */

            end;
        }
        field(63; "Printed Copies"; Integer)
        {

            trigger OnValidate()
            begin
                if GetFilter("Semester Filter") = '' then
                    Error('You must specify the semester.');
                /*
                
                IF xRec."Printed Copies" <> "Printed Copies" THEN BEGIN
                StatusC.INIT;
                StatusC."No.":="Programme Code";
                StatusC.Date:="Stage Code";
                StatusC."Currency Factor":=Code;
                StatusC."Currency Code":="Exam Status";
                StatusC.Date:=TODAY;
                StatusC."User ID":=USERID;
                StatusC."Programme Option":="Programme Option";
                StatusC.Semester:=GETFILTER("Semester Filter");
                StatusC.Payee:='Printed Copies: ' + FORMAT("Printed Copies");
                StatusC.INSERT;
                
                END;
                */

            end;
        }
        field(64; "Issued Copies"; Integer)
        {

            trigger OnValidate()
            begin
                if GetFilter("Semester Filter") = '' then
                    Error('You must specify the semester.');

                if "Issued Copies" > "Printed Copies" then
                    Error('You can not issues more than the printed copies.');
                /*
                IF xRec."Issued Copies" <> "Issued Copies" THEN BEGIN
                StatusC.INIT;
                StatusC."No.":="Programme Code";
                StatusC.Date:="Stage Code";
                StatusC."Currency Factor":=Code;
                StatusC."Currency Code":="Exam Status";
                StatusC.Date:=TODAY;
                StatusC."User ID":=USERID;
                StatusC."Programme Option":="Programme Option";
                StatusC.Semester:=GETFILTER("Semester Filter");
                StatusC.Payee:='Issued Copies: ' + FORMAT("Issued Copies");
                StatusC.INSERT;
                
                END;
                */

            end;
        }
        field(65; "Returned Copies"; Integer)
        {

            trigger OnValidate()
            begin
                if GetFilter("Semester Filter") = '' then
                    Error('You must specify the semester.');

                if "Returned Copies" > "Issued Copies" then
                    Error('You can not return more than the issued copies.');
                /*
                IF xRec."Returned Copies" <> "Returned Copies" THEN BEGIN
                StatusC.INIT;
                StatusC."No.":="Programme Code";
                StatusC.Date:="Stage Code";
                StatusC."Currency Factor":=Code;
                StatusC."Currency Code":="Exam Status";
                StatusC.Date:=TODAY;
                StatusC."User ID":=USERID;
                StatusC."Programme Option":="Programme Option";
                StatusC.Semester:=GETFILTER("Semester Filter");
                StatusC.Payee:='Returned Copies: ' + FORMAT("Returned Copies");
                StatusC.INSERT;
                
                END;
                 */

            end;
        }
        field(66; "Exam Remarks"; Text[100]) { }
        field(67; "Details Count"; Integer)
        {
            Editable = false;
        }
        field(68; "Not Allocated"; Boolean) { }
        field(69; "Timetable Priority"; Integer) { }
        field(70; "Normal Slots"; Integer) { }
        field(71; "Lab Slots"; Integer) { }
        field(72; "Slots Varience"; Integer) { }
        field(73; "Time Table"; Boolean) { }
        field(74; "Exam Not Allocated"; Boolean) { }
        field(75; "Exam Slots Varience"; Integer) { }
        field(80; Show; Boolean) { }
        field(81; "Estimate Reg"; Integer) { }
        field(82; "Exams Done"; Integer)
        {
            CalcFormula = count("Exam Results" where("Reg. Transaction ID" = field("Reg. ID Filter"),
                                                      "Student No." = field("Student No. Filter"),
                                                      Programme = field("Programme Code"),
                                                      Stage = field("Stage Code"),
                                                      Unit = field(Code)));
            FieldClass = FlowField;
        }
        field(83; "Default Exam Category"; Code[20])
        {
            TableRelation = "Exam Category".Code;
        }
        field(84; "Programme Name"; Text[100])
        {
            CalcFormula = lookup(Programme.Description where(Code = field("Programme Code")));
            FieldClass = FlowField;
        }
        field(85; "Lecturer Code"; Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Lecturer = const(true));
        }
        field(86; "New Unit"; Boolean)
        {
            InitValue = true;
        }
        field(87; "Programme Code lkup"; Code[20])
        {
            CalcFormula = lookup("Student Units".Programme where(Unit = field(Code)));
            FieldClass = FlowField;
        }
        field(88; "Lecturer Lkup"; Code[20])
        {
            CalcFormula = lookup("Lecturers Units".Lecturer where(Unit = field(Code),
                                                                   Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(89; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(90; "Session Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Student Types".Code;
        }
        field(91; "Lecturer Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR-Employee"."No." where(Lecturer = const(true));
        }
        field(92; Attachment; Boolean) { }
        field(93; Research; Boolean) { }

        field(50000; "Used Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field("Programme Code"),
                                                       Unit = field(Code)));
            FieldClass = FlowField;
        }
        field(50001; "Score Buffer"; Decimal) { }
        field(50003; Project; Boolean) { }
        field(50004; "Ignore in Final Average"; Boolean) { }
        field(50005; "Failed Total Score"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where("Reg. Transaction ID" = field("Reg. ID Filter"),
                                                                 "Student No." = field("Student No. Filter"),
                                                                 Programme = field("Programme Code"),
                                                                 Stage = field("Stage Code"),
                                                                 Unit = field(Code),
                                                                 Semester = field("Semester Filter"),
                                                                 "Re-Sited" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Time Tabled Count"; Integer) { }
        field(50007; "Old Unit"; Boolean) { }
        field(50012; "Unit Class Size"; Decimal)
        {
            CalcFormula = sum("Lecturers Units"."Class Size" where(Unit = field(Code),
                                                                    Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(50013; "U Code"; Code[10]) { }
        field(50014; "Time Table Code"; Code[20])
        {

            trigger OnValidate()
            begin
                UnitsSubj.Reset;
                UnitsSubj.SetRange(UnitsSubj.Code, Code);
                if UnitsSubj.Find('-') then begin
                    repeat
                        UnitsSubj."Time Table Code" := "Time Table Code";
                        UnitsSubj.Modify;
                    until UnitsSubj.Next = 0;
                end;
            end;
        }
        field(50015; "Campus Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50017; "Week Filter"; Code[20])
        {
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Weeks Codes".Code;
        }
        field(50018; "Reserved Room"; Code[50])
        {
            CalcFormula = lookup("Lecture Rooms".Code where("Reserve For" = field("Programme Code")));
            FieldClass = FlowField;
        }

        field(50020; "TT Used Count"; Integer)
        {
            CalcFormula = count("Time Table" where(Programme = field("Programme Code"),
                                                    Stage = field("Stage Code"),
                                                    Unit = field(Code),
                                                    Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(50021; "Current Semester"; Code[20])
        {
            CalcFormula = lookup(Semesters.Code where("Current Semester" = const(true)));
            FieldClass = FlowField;
            TableRelation = Semesters.Code where("Current Semester" = const(true));
        }
        field(50022; "Student Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Semester = field("Current Semester"),
                                                       Stage = field("Stage Code"),
                                                       Programme = field("Programme Code"),
                                                       Unit = field(Code)));
            FieldClass = FlowField;
        }
        field(50024; "Students Failed"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field("Programme Code"),
                                                       Unit = field(Code),
                                                       Semester = field("Semester Filter"),
                                                       "Campus Code" = field("Campus Filter"),

                                                       Grade = filter('' | 'F' | 'E')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "Mode of Study Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Student Types".Code;
        }
        field(50026; "Category Filter"; Option)
        {
            CalcFormula = lookup(Programme.Category where(Code = field("Programme Code")));
            FieldClass = FlowField;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,Post Graduate Diploma,PHD,Professional,Pre-University,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,"Post Graduate Diploma",PHD,Professional,"Pre-University","Course List";
        }
        field(50027; "Students Registered Moderated"; Integer)
        {
            CalcFormula = count("Student Units" where(Unit = field(Code),
                                                       Semester = field("Semester Filter"),
                                                       "Campus Code" = field("Campus Filter"),
                                                       "Mode of Study" = field("Mode of Study Filter"),
                                                       "Final Score" = filter(> 0),
                                                       Programme = filter(<> ''),
                                                       "Exam Marks" = filter(<> 0),
                                                       "Total Score" = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Department Filter"; Code[20])
        {
            CalcFormula = lookup(Programme."Department Code" where(Code = field("Programme Code")));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50029; "Disable Online Release"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; Description2; Text[100])
        {
            CalcFormula = lookup("Units/Subjects".Desription where(Code = field(Code),
                                                                    Desription = filter(<> '')));
            FieldClass = FlowField;
        }
        field(50031; Dissertation; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Dissertation Weight Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50034; "Students Registered Released"; Integer)
        {
            CalcFormula = count("Student Units" where(Unit = field(Code),
                                                       Semester = field("Semester Filter"),
                                                       "Campus Code" = field("Campus Filter"),
                                                       "Mode of Study" = field("Mode of Study Filter"),
                                                       Released = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50035; "Students Registered Marks"; Integer)
        {
            CalcFormula = count("Student Units" where(Unit = field(Code),
                                                       Semester = field("Semester Filter"),
                                                       "Campus Code" = field("Campus Filter"),
                                                       "Final Score" = filter(> 0),
                                                       Stage = field("Stage Filter"),
                                                       "Unit Type LK" = field("Unit Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50036; "Students Registered Moderated2"; Integer)
        {
            CalcFormula = count("Student Units" where(Unit = field(Code),
                                                       Semester = field("Semester Filter"),
                                                       "Campus Code" = field("Campus Filter"),
                                                       "Mode of Study" = field("Mode of Study Filter"),
                                                       Moderated = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }

        field(50038; "Teaching Practice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Related Course"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Code"));
        }
        field(50040; "Unit Type Filter"; Option)
        {
            Editable = false;
            FieldClass = FlowFilter;
            OptionCaption = 'Core,Elective,Required';
            OptionMembers = Core,Elective,Required;
        }
        field(50041; "Exam Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Code"),
                                                         "Exam Only" = const(true));
        }
        field(50042; "Exam Only"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Predefined Units"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Department Filter Name"; Text[250])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Department Filter")));
            FieldClass = FlowField;
        }
        field(50045; "Old Unit Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Required Credit Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50047; "Charge Credit Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "Course Type"; Option)
        {
            OptionCaption = ',Major,Minor';
            OptionMembers = ,Major,Minor;
        }
        field(50049; "Max. Class Capacity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Teaching Type"; Option)
        {
            OptionCaption = 'Lab,Lecture,Project,Practicum,Clinical,Dissertation,Thesis,Seminar';
            OptionMembers = Lab,Lecture,Project,Practicum,Clinical,Dissertation,Thesis,Seminar;
        }
        field(50051; "Unit Category"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Category".code;
            trigger OnValidate()
            var
                UnitsRec: Record "Unit Category";
            begin
                UnitsRec.reset;
                UnitsRec.setrange(Code, "Unit Category");
                if UnitsRec.find('-') then begin
                    "Unit Type" := UnitsRec."Unit Type";
                end;
            end;
        }
        field(50052; "Concentration"; code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation="Unit Category".code;
        }
    }

    keys
    {
        key(Key1; "Code", "Programme Code", "Stage Code", "Entry No", "Unit Type")
        {
            Clustered = true;
        }
        key(Key2; "Stage Code") { }
        key(Key3; "Programme Code", "Stage Code", "Code", "Programme Option") { }
        key(Key4; "Code", "Time Tabled Count") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

        //StudUnits.RESET;
        //StudUnits.SETRANGE(StudUnits.Unit,Code);
        //StudUnits.SETRANGE(StudUnits.Programme,"Programme Code");
        // IF StudUnits.FIND('-') THEN ERROR('The selected unit is already used in Students Units');

        ExamR.Reset;
        ExamR.SetRange(ExamR.Unit, Code);
        ExamR.SetRange(ExamR.Programme, "Programme Code");
        ExamR.SetRange(ExamR.Stage, "Stage Code");
        ExamR.SetRange(ExamR.Cancelled, false);
        if ExamR.Find('-') then
            if Confirm('Please note that selected unit contains valid results!, Do you really want to delete', false) = false then
                Error('Aborted');
    end;

    trigger OnRename()
    begin
        /*
          IF xRec.Code<>Code THEN BEGIN
         StudUnits.RESET;
         StudUnits.SETRANGE(StudUnits.Unit,xRec.Code);
         StudUnits.SETRANGE(StudUnits.Programme,"Programme Code");
         IF StudUnits.FIND('-') THEN ERROR('The selected unit is already used in Students Units');
         END;
        */

    end;

    var

        UnitsSubj: Record "Units/Subjects";
        ExamR: Record "Exam Results";
}

