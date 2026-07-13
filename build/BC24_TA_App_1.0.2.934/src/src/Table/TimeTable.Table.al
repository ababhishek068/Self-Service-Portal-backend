Table 50096 "Time Table"
{
    fields
    {
        field(1; Programme; Code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = Programme.Code;
        }
        field(2; Stage; Code[30])
        {
            DataClassification = ToBeClassified;

            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(3; Unit; Code[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Courses Master".Code where("Code" = field(Unit));
            trigger OnValidate()
            var
                Cmaster: record "Courses Master";
            begin
                if Cmaster.get() then begin
                    "Unit Type" := cmaster."Unit Type";
                    "No of Units" := cmaster.Units;
                end;

                CalcFields("Students Count");
                if "Students Count" > 0 then begin
                    Error('This entry has registerd students cannot be modified.');
                    exit;
                end;
            end;
        }
        field(4; Semester; Code[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Semesters.Code;
        }
        field(5; Period; Code[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Lessons.Code;
        }
        field(6; "Day of Week"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Day Of Week".Day;
        }
        field(7; "Day Filter"; Code[50])
        {
            FieldClass = FlowFilter;
            TableRelation = "Day Of Week".Day;
        }
        field(8; "Lecture Room"; Code[50])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Lecture Rooms".Code;
            // TestTableRelation = false;
            trigger OnValidate()
            var
                TT: record "Time Table";
            begin
                TT.reset;
                // TT.setrange(Unit, Unit);
                TT.setrange(Semester, Semester);
                TT.setrange("Campus Code", "Campus Code");
                // TT.setrange("Unit Class", "Unit Class");
                TT.setrange("Day of Week", "Day of Week");
                TT.setrange(Period, Period);
                TT.setrange("Lecture Room", "Lecture Room");
                if TT.find('-') then begin
                    if (TT."Lecture Room" <> 'ONLINE') and (TT."Lecture Room" <> 'AUD') then
                        if Confirm('Allocations already exists for Room No. ' + "Lecture Room" + ',Unit ' + Unit + ' on ' + "Day of Week" + ' at ' + Period) = false then
                            exit;
                end;
            end;
        }
        field(9; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(10; Class; Code[50])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = "Course Classes".Code;
            trigger OnValidate()
            begin
                CalcFields("Students Count");
                if "Students Count" > 0 then begin
                    Error('This entry has registerd students cannot be modified.');
                    exit;
                end;
            end;
        }
        field(11; "No. Of Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Lecturer; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee" where(Lecturer = filter(true));
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
                // webPortal: Codeunit Webportal;
                TT: record "Time Table";
            begin
                TT.reset;
                // TT.setrange(Unit, Unit);
                TT.setrange(Semester, Semester);
                TT.setrange("Campus Code", "Campus Code");
                // TT.setrange("Unit Class", "Unit Class");
                TT.setrange("Day of Week", "Day of Week");
                TT.setrange(Period, Period);
                TT.setrange(Lecturer, Lecturer);
                if TT.find('-') then begin
                    if Confirm('Allocations already exists for Lecturer No. ' + Lecturer + ',Unit ' + Unit + ' on ' + "Day of Week" + ' at ' + Period) = false then
                        exit;
                end;

                IF HREmp.Get(Lecturer) then begin
                    "Lecturer Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    //   webPortal.AssignLecturerUnit(Lecturer, Programme, Stage, Semester, Unit, "Campus Code", "Mode of Study", "Unit Class","Class Size");
                end
            end;
        }
        field(13; "Unit Class"; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = "Course Classes".Code;
            trigger OnValidate()
            begin
                CalcFields("Students Count");
                if "Students Count" > 0 then begin
                    Error('This entry has registerd students cannot be modified.');
                    exit;
                end;
            end;
        }
        field(14; Exam; Code[30])
        {
            DataClassification = ToBeClassified;

        }
        field(15; "Exam Date"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Released; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(160; Cancelled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(162; "Cancelled By"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(163; "Cancelled Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; Session; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Full Time,Part Time';
            OptionMembers = "Full Time","Part Time";
        }
        field(18; Department; Code[30])
        {
            CalcFormula = lookup(Programme."Department Code" where(Code = field(Programme)));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(19; "Programme Option"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Room Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Room,Labs';
            OptionMembers = Room,Labs;
        }
        field(21; "Campus Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                CalcFields("Students Count");
                if "Students Count" > 0 then begin
                    Error('This entry has registerd students cannot be modified.');
                    exit;
                end;
            end;
        }
        field(50050; "Unit Count"; Integer)
        {
            CalcFormula = count("Time Table" where(Programme = field(Programme),
                                                    Stage = field(Stage),
                                                    "Day of Week" = field("Day of Week"),
                                                    Period = field(Period),
                                                    Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(50051; "Programme Filter"; Code[30])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(50052; "Stage Filter"; Code[30])
        {
            FieldClass = FlowFilter;
        }
        field(50053; "Semester Filter"; Code[30])
        {
            FieldClass = FlowFilter;
        }
        field(50055; "Lesson Filter"; Code[30])
        {
            FieldClass = FlowFilter;
            TableRelation = Lessons.Code;
        }
        field(50056; "Unit Filter"; Code[30])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme),
                                                         "Stage Code" = field(Stage));
        }

        field(50058; "Room Filter"; Code[30])
        {
            FieldClass = FlowFilter;
        }
        field(50059; "Lecturer Filter"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(50060; "Lecturer Count"; Integer)
        {
            CalcFormula = count("Time Table" where("Day of Week" = field("Day Filter"),
                                                    Period = field("Lesson Filter"),
                                                    Lecturer = field("Lecturer Filter")));
            FieldClass = FlowField;
        }
        field(50061; Auto; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50062; "Unit Week Count"; Integer)
        {
            CalcFormula = count("Time Table" where(Programme = field(Programme),
                                                    Stage = field(Stage),
                                                    Unit = field(Unit),
                                                    Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(50063; "Programme Lk"; Code[50])
        {
            CalcFormula = lookup("Units/Subjects"."Programme Code" where(Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50064; "Stage Lk"; Code[50])
        {
            CalcFormula = lookup("Units/Subjects"."Stage Code" where(Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50065; LecturerNM; Text[80])
        {
            CalcFormula = lookup("HR-Employee"."First Name" where("No." = field(Lecturer)));
            FieldClass = FlowField;
        }
        field(50066; progname; Text[250])
        {
            CalcFormula = lookup(Programme.Description where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(50067; unitNm; Text[250])
        {
            CalcFormula = lookup("Units/Subjects".Desription where(Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50068; DPTNM; Text[250])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field(Department)));
            FieldClass = FlowField;
        }
        field(50069; "Day Code"; Integer)
        {
            CalcFormula = lookup("Day Of Week"."No." where(Day = field("Day of Week")));
            FieldClass = FlowField;
        }
        field(50070; semNM; Text[150])
        {
            CalcFormula = lookup(Semesters.Description where(Code = field(Semester)));
            FieldClass = FlowField;
        }
        field(50270; "Unit Description"; Text[250])
        {
            CalcFormula = lookup("Courses Master".Description where(Code = field(unit)));
            FieldClass = FlowField;
        }
        field(50071; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Teaching,Exam';
            OptionMembers = Teaching,Exam;
        }
        field(50072; "Room Capacity"; Decimal)
        {
            CalcFormula = lookup("Lecture Rooms"."Maximum Capacity" where(Code = field("Lecture Room")));
            FieldClass = FlowField;
        }
        field(50073; "Room Used Count"; Integer)
        {
            CalcFormula = count("Time Table" where("Lecture Room" = field("Lecture Room"),
                                                    Semester = field(Semester),
                                                    Period = field(Period),
                                                    "Campus Code" = field("Campus Code"),
                                                    Type = field(Type)));
            FieldClass = FlowField;
        }

        field(50074; "Mode of Study"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
        }
        field(50075; "Unit Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50076; "Lecturer Email"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50077; "Lecturer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50078; "Start Time"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50079; "End Time"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50080; "Student Filter"; Code[30])
        {
            FieldClass = FlowFilter;
        }
        field(50003; "No of Units"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 3;

        }
        field(50004; "Unit Type"; Option)
        {
            OptionCaption = 'Core,Elective,Required,Free Elective,General Education';
            OptionMembers = Core,Elective,Required,"Free Elective","General Education";
            DataClassification = ToBeClassified;

        }
        field(50005; "Class Size"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Current Semester"; boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist(Semesters where("Current Semester" = filter(true)));
        }
        field(50008; "Multi Campus"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Students Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Student Units" where(Unit = field(Unit), Semester = field(Semester), "Unit Class Code" = field("Unit Class"), Campus = field("Campus Code")));
        }
        field(50010; "Unit Department"; Code[20])
        {
            CalcFormula = lookup("Courses Master"."Department Code" where(Code = field(Unit)));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(Key1; Programme, Stage, Unit, Semester, Period, "Day of Week", Class, "Unit Class", Exam, "Campus Code")
        {
            Clustered = true;
            SumIndexFields = "No. Of Hours";
        }
        key(Key2; Type, "Day of Week", Period) { }
    }

    fieldgroups { }
    trigger OnDelete()
    begin
        //Counter := 1;
        CalcFields("Students Count");
        if ("Students Count") > 0 then Error('There are already registered students in this section. You cannot delete');
        // if Confirm('There are students registered to this unit. Are you sure you want to delete this unit from the Timetable?', true) = true then begin
        //     studentUnits.Reset();
        //     studentUnits.SetRange(Unit, Unit);
        //     studentUnits.SetRange(Semester, Semester);
        //     studentUnits.SetRange("Unit Class Code", "Unit Class");
        //     studentUnits.SetRange("Campus", "Campus Code");
        //     if studentUnits.Find('-') then begin
        //         repeat
        //             webportal.DropStudentUnits(studentUnits."Student No.", studentUnits.Semester, studentUnits.Stage, studentUnits.Programme, studentUnits.Unit);
        //             Counter := Counter + 1;
        //         until studentUnits.Next() = 0;
        //     end;
        //     Message(format(Counter) + ' student affected');
        // end;
    end;
    // webportal: Codeunit Webportal;
}

