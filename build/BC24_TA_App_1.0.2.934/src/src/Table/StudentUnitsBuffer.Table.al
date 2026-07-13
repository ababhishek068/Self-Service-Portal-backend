Table 50684 "Student Units Buffer"
{
    DrillDownPageID = "Student Units - List";
    LookupPageID = "Student Units - List";

    fields
    {
        field(1; "Reg. Transacton ID"; Code[20])
        {
            Editable = true;
        }
        field(2; "Student No."; Code[30])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = Customer."No.";
        }
        field(3; Semester; Code[20])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = Semesters.Code;
        }
        field(4; Programme; Code[20])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = Programme.Code;

            trigger OnValidate()
            begin
                CReg.Reset;
                CReg.SetRange(CReg."Student No.", "Student No.");
                if CReg.Find('+') then begin
                    "Reg. Transacton ID" := CReg."Reg. Transacton ID";
                    //Programme:=CReg.Programme;
                    //Stage:=CReg.Stage;
                    //Semester:=CReg.Semester;


                end;
            end;
        }
        field(5; "Register for"; Option)
        {
            Editable = false;
            NotBlank = false;
            OptionCaption = 'Stage,Unit/Subject,Supplementary,Retake';
            OptionMembers = Stage,"Unit/Subject",Supplementary,Retake;
        }
        field(6; Stage; Code[20])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(7; Unit; Code[20])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme),
                                                         "Stage Code" = field(Stage));

            trigger OnValidate()
            begin
                AdditionalCF := 0;
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.", "Student No.");
                CourseReg.SetRange(CourseReg.Semester, Semester);
                CourseReg.SetRange(CourseReg.Reversed, false);
                if CourseReg.Find('-') then begin
                    AdditionalCF := CourseReg."Additional CF";
                end;


                UnitsS.Reset;
                UnitsS.SetRange(UnitsS."Programme Code", Programme);
                UnitsS.SetRange(UnitsS.Code, Unit);
                if UnitsS.Find('-') then begin
                    "No. Of Units" := UnitsS."No. Units";
                    Description := UnitsS.Desription;
                    "No. Of Units" := UnitsS."No. Units";
                    "Unit Stage" := UnitsS."Stage Code";
                end;

                "Edited By" := UserId;
                "Date Edited" := Today;
                // Check double registration
                StudUnits.Reset;
                StudUnits.SetRange(StudUnits."Student No.", "Student No.");
                StudUnits.SetRange(StudUnits.Unit, Unit);
                StudUnits.SetRange(StudUnits.Semester, Semester);
                StudUnits.SetRange(StudUnits."Register for", "Register for");
                if StudUnits.Find('-') then begin
                    //IF StudUnits.COUNT>0 THEN ERROR('Please note that have already registered for the '+Unit +' Unit in '+Semester);
                end;

                // Check Maximum semester CF
                StudUnits.CalcFields("Creg Stage");
                UnitsCF := 0;
                Stages.Reset;
                Stages.SetRange(Stages."Programme Code", Programme);
                Stages.SetRange(Stages.Code, Stage);
                Stages.Find('-');
                StudUnits.Reset;
                StudUnits.SetRange(StudUnits."Student No.", "Student No.");
                StudUnits.SetRange(StudUnits.Programme, Programme);
                StudUnits.SetRange(StudUnits.Semester, Semester);
                StudUnits.SetRange(StudUnits."Register for", "Register for");
                StudUnits.SetFilter(StudUnits.Stage, "Creg Stage");
                if StudUnits.Find('-') then begin
                    repeat
                        UnitsCF := UnitsCF + StudUnits."No. Of Units";
                    until StudUnits.Next = 0;

                    //IF (UnitsCF+AdditionalCF)>Stages."Maximum Allowed CF" THEN ERROR('Please note that you can not register for more than '+FORMAT(Stages."Maximum Allowed CF")+' CF in a semester, You have registered for '+FORMAT(UnitsCF));
                end;
            end;
        }
        field(8; "Programme Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(9; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(10; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Filter"),
                                                         "Stage Code" = field("Stage Filter"));
            ValidateTableRelation = false;
        }
        field(11; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Filter"));
        }
        field(12; "Unit Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Core,Elective,Required';
            OptionMembers = Core,Elective,Required;
        }
        field(13; Taken; Boolean)
        {

            trigger OnValidate()
            begin
                UTaken := 0;
                UFound := false;
                if Taken = false then
                    exit;

                // Check if external unit
                UnitsS.Reset;
                UnitsS.SetRange(UnitsS.Code, Unit);
                if UnitsS.Find('-') then begin
                    if UnitsS."Programme Code" = '' then
                        UnitsS."Programme Code" := Programme;
                    if UnitsS."Stage Code" = '' then
                        UnitsS."Stage Code" := Stage;
                    //UnitsS.MODIFY;
                end;

                //Check no of units
                //Check no of units
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Reg. Transacton ID", "Reg. Transacton ID");
                if CourseReg.Find('-') then begin
                    CourseReg.CalcFields(CourseReg."Units Taken");
                    if Prog.Get(CourseReg.Programme) then begin
                        if Prog."Max No. of Courses" > 0 then begin
                            if CourseReg."Units Taken" > (Prog."Max No. of Courses" - 1) then
                                Error('You cannot register for more than %1 units', Prog."Max No. of Courses");

                        end;
                    end;
                end;



                UnitsS.Reset;
                //UnitsS.SETRANGE(UnitsS."Programme Code",Programme);
                UnitsS.SetRange(UnitsS.Code, Unit);
                if UnitsS.Find('-') then begin
                    if UnitsS.Prerequisite <> '' then begin
                        StudUnits.Reset;
                        StudUnits.SetRange(StudUnits."Student No.", "Student No.");
                        StudUnits.SetRange(StudUnits.Unit, UnitsS.Prerequisite);
                        StudUnits.SetRange(StudUnits.Taken, true);
                        //IF StudUnits.FIND('-') = FALSE THEN
                        //ERROR('Student must do the prerequisite unit %1.',UnitsS.Prerequisite);

                    end;
                end;

                //Check if timetabled.
                exit;
                /////////////////////
                UTaken := 0;
                UFound := false;
                TTable.Reset;
                TTable.SetRange(TTable.Programme, Programme);
                //TTable.SETRANGE(TTable.Stage,Stage);
                TTable.SetRange(TTable.Unit, Unit);
                TTable.SetRange(TTable.Semester, Semester);
                if TTable.Find('-') then begin
                    //Check TT Conflict

                    Days.Reset;
                    if Days.Find('-') then begin
                        repeat

                            Lessons.Reset;
                            if Lessons.Find('-') then begin
                                repeat

                                    TTable2.Reset;
                                    TTable2.SetRange(TTable2.Released, false);
                                    TTable2.SetRange(TTable2.Programme, Programme);
                                    //TTable2.SETRANGE(TTable2.Stage,Stage);
                                    TTable2.SetRange(TTable2.Semester, Semester);
                                    TTable2.SetRange(TTable2."Day of Week", Days.Day);
                                    TTable2.SetRange(TTable2.Period, Lessons.Code);
                                    if TTable2.Find('-') then begin
                                        //MESSAGE('%1',TTable2.COUNT);
                                        if TTable2.Count > 1 then begin
                                            repeat
                                                StudUnits.Reset;
                                                StudUnits.SetRange(StudUnits."Student No.", "Student No.");
                                                StudUnits.SetRange(StudUnits.Taken, true);
                                                StudUnits.SetRange(StudUnits."Reg. Transacton ID", "Reg. Transacton ID");
                                                StudUnits.SetRange(StudUnits.Unit, TTable2.Unit);
                                                if StudUnits.Find('-') then begin
                                                    UTaken := UTaken + 1;

                                                end;


                                                if TTable2.Unit = Unit then
                                                    UFound := true;

                                            until TTable2.Next = 0;

                                            if (UFound = true) and (UTaken > 0) then
                                                Error('This will cause a student time table conflict on %1 - %2', Days.Day, Lessons.Code);

                                        end;
                                    end;
                                until Lessons.Next = 0;
                            end;


                        until Days.Next = 0;
                    end;

                    Remarks := '';
                end else
                    Remarks := 'Not timetabled.';
            end;
        }
        field(14; "Student Type Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'FULL TIME,PART TIME';
            OptionMembers = "FULL TIME","PART TIME";
            TableRelation = "Course Registration"."Student Type";
        }
        field(15; "Category Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Exam Category".Code;
        }
        field(16; UnitCount; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field(Programme),
                                                       Stage = field(Stage),
                                                       Semester = field(Semester),
                                                       Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(17; "Total Score"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where("Student No." = field("Student No."),
                                                                 Programme = field(Programme),
                                                                 Unit = field(Unit),
                                                                 "Re-Sited" = const(false),
                                                                 Cancelled = const(false),
                                                                 Stage = field(Stage)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CalcFields("Total Score");
                Grade := GetGrade("Total Score", Unit, Programme, Stage);
                if (GetGradeStatus("Total Score", Programme, Unit, Stage) = true) then begin
                    "Result Status" := 'FAIL';
                    Failed := true;
                end else begin
                    Failed := false;
                    "Result Status" := 'PASS';
                end;
                if "Total Score" = 0 then begin
                    "Result Status" := 'FAIL';
                    Failed := true;
                end;
                Modify;
            end;
        }
        field(18; Exempted; Boolean)
        {

            trigger OnValidate()
            begin
                Taken := false;
            end;
        }
        field(19; Attendance; Decimal) { }
        field(20; "Allow Supplementary"; Boolean) { }
        field(21; "Sat Supplementary"; Boolean) { }
        field(22; "Repeat Unit"; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                IF "Repeat Unit" = TRUE THEN BEGIN
                //CALCFIELDS("Total Score");
                Taken:=TRUE;
                END ELSE BEGIN
                Taken:=FALSE;
                END;
                */

            end;
        }
        field(50; Remarks; Text[200]) { }
        field(51; "Unit Stage"; Code[20])
        {
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(52; Failed; Boolean) { }
        field(55; "Course Type"; Option)
        {
            OptionCaption = 'Core,Elective,Required';
            OptionMembers = Core,Elective,Required;
        }
        field(56; Audit; Boolean) { }
        field(57; Status; Option)
        {
            OptionCaption = ' ,Intent,Submitted,Dispatch B.O.E,B.O.E Report,Schedule Defence,Defence,Cert. of Corr.,Binding,SGS Board Approval,Senate Approval';
            OptionMembers = " ",Intent,Submitted,"Dispatch B.O.E","B.O.E Report","Schedule Defence",Defence,"Cert. of Corr.",Binding,"SGS Board Approval","Senate Approval";

            trigger OnValidate()
            begin
                if xRec.Status <> Status then begin
                    StatusC.Init;
                    StatusC."Student No" := "Student No.";
                    StatusC."Programme Code" := Programme;
                    StatusC."Stage Code" := Stage;
                    StatusC.Code := Unit;
                    StatusC.Status := Format(Status);
                    StatusC.Date := Today;
                    StatusC."User ID" := UserId;
                    StatusC.Semester := GetFilter("Semester Filter");
                    StatusC.Remarks := Remarks;
                    StatusC."Status Type" := 'Thesis';
                    StatusC.Insert;

                end;

                if Status = Status::Intent then
                    "Proposal Date" := Today;

                if Status = Status::Submitted then
                    "Senate-Proposal" := Today;

                if Status = Status::"Dispatch B.O.E" then
                    Research := Today;

                if Status = Status::Submitted then
                    "Senate-Proposal" := Today;

                if Status = Status::"Schedule Defence" then
                    Examiners := Today;

                if Status = Status::Defence then
                    Defense := Today;
            end;
        }
        field(58; "Details Count"; Integer)
        {
            CalcFormula = count("Post Grad Change History" where("Student No" = field("Student No."),
                                                                  "Programme Code" = field(Programme),
                                                                  "Stage Code" = field(Stage),
                                                                  Code = field(Unit)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "No. Of Units"; Decimal) { }
        field(60; "Project Status"; Option)
        {
            OptionCaption = '  ,Proposal,Faculty/School Approval,Research,Exam';
            OptionMembers = "  ",Proposal,"Faculty/School Approval",Research,Exam;

            trigger OnValidate()
            begin

                if xRec."Project Status" <> "Project Status" then begin
                    StatusC.Init;
                    StatusC."Student No" := "Student No.";
                    StatusC."Programme Code" := Programme;
                    StatusC."Stage Code" := Stage;
                    StatusC.Code := Unit;
                    StatusC.Status := Format("Project Status");
                    StatusC.Date := Today;
                    StatusC."User ID" := UserId;
                    StatusC.Semester := GetFilter("Semester Filter");
                    StatusC.Remarks := Remarks;
                    StatusC."Status Type" := 'Project';
                    StatusC.Insert;

                end;
            end;
        }
        field(61; "Final Score"; Decimal)
        {
            FieldClass = Normal;
        }
        field(62; "Created by"; Code[50]) { }
        field(63; "Edited By"; Code[50]) { }
        field(64; "Date created"; Date) { }
        field(65; "Date Edited"; Date) { }
        field(66; "Cummulative Year Filter"; Code[20])
        {
            Caption = 'Cummulative Year Filter';
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(67; "Total Marks"; Decimal) { }
        field(68; "External Unit"; Boolean)
        {
            FieldClass = FlowFilter;
        }
        field(69; "External Units"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = ' ,External';
            OptionMembers = " ",External;
        }
        field(70; "System Created"; Boolean) { }
        field(71; Multiple; Boolean) { }
        field(72; "Entry No."; Integer) { }
        field(73; "Student Class"; Code[20])
        {
            TableRelation = "Units Classes".Code where(Programme = field(Programme),
                                                        Stage = field(Stage),
                                                        Code = field(Unit));
        }
        field(74; ENo; Integer) { }
        field(75; "System Taken"; Boolean) { }
        field(76; "Repeat Marks"; Decimal) { }
        field(77; "Re-Take"; Boolean) { }
        field(78; "Proposal Status"; Option)
        {
            OptionCaption = ' ,SGS Board Approval,Senate Approval,SGS Research Refund';
            OptionMembers = " ","SGS Board Approval","Senate Approval","SGS Research Refund";

            trigger OnValidate()
            begin

                if xRec."Proposal Status" <> "Proposal Status" then begin
                    StatusC.Init;
                    StatusC."Student No" := "Student No.";
                    StatusC."Programme Code" := Programme;
                    StatusC."Stage Code" := Stage;
                    StatusC.Code := Unit;
                    StatusC.Status := Format("Proposal Status");
                    StatusC.Date := Today;
                    StatusC."User ID" := UserId;
                    StatusC.Semester := GetFilter("Semester Filter");
                    StatusC.Remarks := Remarks;
                    StatusC."Status Type" := 'Proposal';
                    StatusC.Insert;

                end;
            end;
        }
        field(79; "Proposal Date"; Date) { }
        field(80; "Senate-Proposal"; Date) { }
        field(81; Research; Date) { }
        field(82; "Senate-Research"; Date) { }
        field(83; Examiners; Date) { }
        field(84; Defense; Date) { }
        field(85; "Category Code"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Exam Category".Code;
        }
        field(86; "Progress Report"; Option)
        {
            OptionCaption = ' ,1st Progress,2nd Progress,3rd Progress,4th Progress';
            OptionMembers = " ","1st Progress","2nd Progress","3rd Progress","4th Progress";

            trigger OnValidate()
            begin
                if xRec."Progress Report" <> "Progress Report" then begin
                    StatusC.Init;
                    StatusC."Student No" := "Student No.";
                    StatusC."Programme Code" := Programme;
                    StatusC."Stage Code" := Stage;
                    StatusC.Code := Unit;
                    StatusC.Status := Format("Progress Report");
                    StatusC.Date := Today;
                    StatusC."User ID" := UserId;
                    StatusC.Semester := GetFilter("Semester Filter");
                    StatusC.Remarks := Remarks;
                    StatusC."Status Type" := 'Progress Report';
                    StatusC.Insert;

                end;
            end;
        }
        field(87; "Progress Date"; Date) { }
        field(88; "Defence OutCome"; Option)
        {
            OptionCaption = ' ,Pass,Fail';
            OptionMembers = " ",Pass,Fail;
        }
        field(89; Description; Text[250]) { }
        field(90; "Student Type"; Option)
        {
            OptionCaption = 'Full Time,Part Time,Distance Learning';
            OptionMembers = "Full Time","Part Time","Distance Learning";
        }
        field(94; "Main Programme"; Code[20])
        {
            CalcFormula = lookup("Course Registration".Programme where("Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(95; "Registered Programe"; Code[20])
        {
            CalcFormula = lookup("Course Registration".Programme where("Student No." = field("Student No."),
                                                                        Semester = field(Semester),
                                                                        Programme = filter(<> '')));
            FieldClass = FlowField;
        }
        field(96; "Semester Registered"; Boolean)
        {
            CalcFormula = lookup("Course Registration".Registered where("Student No." = field("Student No."),
                                                                         Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(20015; "Marks Status"; Option)
        {
            OptionCaption = ' ,Y,S,I,F,NDP';
            OptionMembers = " ",Y,S,I,F,NDP;
        }
        field(20016; "Student Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(20023; "CAT-1"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Exam = const('CAT'),
                                                                 Programme = field(Programme),
                                                                 "Student No." = field("Student No."),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 ExamType = const('CAT1')));
            FieldClass = FlowField;
        }
        field(20024; "CAT-2"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Exam = const('CAT'),
                                                                 Programme = field(Programme),
                                                                 "Student No." = field("Student No."),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 ExamType = const('CAT2')));
            FieldClass = FlowField;
        }
        field(20025; "Result Status"; Code[50]) { }
        field(20026; "Registration Status"; Option)
        {
            CalcFormula = lookup("Course Registration"."Registration Status" where("Student No." = field("Student No."),
                                                                                    Programme = field(Programme),
                                                                                    Stage = field(Stage),
                                                                                    Semester = field(Semester)));
            FieldClass = FlowField;
            OptionCaption = ' ,Specials,Academic Leave,WithHold,Deregister,Discontinue,Nullification';
            OptionMembers = " ",Specials,"Academic Leave",WithHold,Deregister,Discontinue,Nullification;
        }
        field(20027; "Ass Total Marks"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Exam = const('ASSIGNMENT'),
                                                                 Programme = field(Programme),
                                                                 "Student No." = field("Student No."),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 Stage = field(Stage)));
            FieldClass = FlowField;
        }
        field(20028; "CAT Total Marks"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Exam = const('CAT'),
                                                                 Programme = field(Programme),
                                                                 "Student No." = field("Student No."),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 Cancelled = const(false),
                                                                 Stage = field(Stage)));
            FieldClass = FlowField;
        }
        field(20029; "Exam Marks"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Exam = filter('FINAL EXAM' | 'EXAM'),
                                                                 Programme = field(Programme),
                                                                 "Student No." = field("Student No."),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 Cancelled = const(false),
                                                                 Stage = field(Stage)));
            FieldClass = FlowField;
        }
        field(20030; Category; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Exams Setup".Category;
        }
        field(20031; "Exam Type"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Exams Setup".Code;
        }
        field(20032; "Exam Period"; Code[20])
        {
            TableRelation = "Exam Periods".Code;

            trigger OnValidate()
            begin
                // IF ExamPeriod.GET("Exam Period") THEN
                //    IF ExamPeriod.DeadLine<TODAY THEN ERROR('Please Note That you can Not Enter Marks for Expired Exams');
                // MESSAGE("Exam Period") ;
            end;
        }
        field(20033; "Exam Status"; Option)
        {
            OptionCaption = 'Lecturer,Faculty,Moderators';
            OptionMembers = Lecturer,Faculty,Moderators;
        }
        field(20034; "Staff Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR-Employee"."No." where(Lecturer = const(true));
        }
        field(20035; Lecturer; Code[20])
        {
            CalcFormula = lookup("Lecturers Units".Lecturer where(Programme = field(Programme),
                                                                   Stage = field(Stage),
                                                                   Unit = field(Unit),
                                                                   Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(20036; Grade; Code[50]) { }
        field(20037; "Supp Taken"; Boolean) { }
        field(20038; "Failed Units Count"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Unit = field(Unit),
                                                       Failed = const(true)));
            FieldClass = FlowField;
        }
        field(20039; "Unit Reg Count"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(20040; "Exam Period Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Exam Periods".Code;

            trigger OnValidate()
            begin
                // IF ExamPeriod.GET("Exam Period") THEN
                //    IF ExamPeriod.DeadLine<TODAY THEN ERROR('Please Note That you can Not Enter Marks for Expired Exams');
                // MESSAGE("Exam Period") ;
            end;
        }
        field(20041; "Unit Fees"; Decimal)
        {
            CalcFormula = lookup("Fee By Stage"."Break Down" where("Programme Code" = field(Programme),
                                                                    "Stage Code" = field(Stage),
                                                                    Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(20042; "Actual Fees"; Decimal) { }
        field(20043; "Reg Reversed"; Boolean)
        {
            CalcFormula = lookup("Course Registration".Reversed where("Student No." = field("Student No."),
                                                                       "Reg. Transacton ID" = field("Reg. Transacton ID")));
            FieldClass = FlowField;
        }
        field(20044; "Units Reg. Status"; Option)
        {
            OptionCaption = ' ,Specials,Academic Leave,WithHold,Deregister,Discontinue,Nullification,Deffer';
            OptionMembers = " ",Specials,"Academic Leave",WithHold,Deregister,Discontinue,Nullification,Deffer;
        }
        field(20045; "ASS-1"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Exam = filter('ASS1' | 'ASS 1'),
                                                                 "Student No." = field("Student No."),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 "Academic Year" = field("Academic Year")));
            FieldClass = FlowField;
        }
        field(20046; "ASS-2"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Exam = filter('ASS2' | 'ASS 2'),
                                                                 "Student No." = field("Student No."),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 "Academic Year" = field("Academic Year")));
            FieldClass = FlowField;
        }
        field(50000; Reversed; Boolean) { }
        field(50001; "Unit Name"; Text[100]) { }
        field(50002; "Session Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Student Types".Code;
        }
        field(50003; "Lecturer Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR-Employee"."No." where(Lecturer = const(true));
        }
        field(50004; "Intake Code"; Code[20])
        {
            CalcFormula = lookup("Course Registration".Session where("Student No." = field("Student No."),
                                                                      "Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                                      Programme = field(Programme),
                                                                      Stage = field(Stage)));
            FieldClass = FlowField;
        }
        field(50005; "Unit Description"; Text[100])
        {
            CalcFormula = lookup("Units/Subjects".Desription where("Programme Code" = field(Programme),
                                                                    Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50006; Blocked; Option)
        {
            CalcFormula = lookup(Customer.Blocked where("No." = field("Student No.")));
            Caption = 'Blocked';
            FieldClass = FlowField;
            OptionCaption = ' ,Ship,Invoice,All';
            OptionMembers = " ",Ship,Invoice,All;
        }
        field(50007; "Session Code"; Code[20])
        {
            CalcFormula = lookup("Course Registration"."Intake Code" where("Student No." = field("Student No."),
                                                                            "Reg. Transacton ID" = field("Reg. Transacton ID")));
            FieldClass = FlowField;
            TableRelation = Intake.Code;
        }
        field(50008; "Cust Exist"; Integer)
        {
            CalcFormula = count(Customer where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(50009; Registered; Boolean)
        {
            CalcFormula = lookup("Course Registration".Registered where("Student No." = field("Student No."),
                                                                         Programme = field(Programme),
                                                                         Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(50010; "CF Score"; Decimal)
        {
            Description = 'Stores CF * Score';
        }
        field(50011; "Ignore in Final Average"; Boolean)
        {
            CalcFormula = lookup("Units/Subjects"."Ignore in Final Average" where("Programme Code" = field(Programme),
                                                                                   Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50012; "Ignore in Cumm  Average"; Boolean) { }
        field(50013; "Attachment Unit"; Boolean) { }
        field(50014; "Reg. Results Status"; Code[20])
        {
            CalcFormula = lookup("Course Registration"."Exam Status" where("Student No." = field("Student No."),
                                                                            Programme = field(Programme),
                                                                            Semester = field(Semester),
                                                                            Stage = field(Stage)));
            FieldClass = FlowField;
        }
        field(50015; "Academic Year"; Code[20]) { }
        field(50017; "Student Code"; Code[20]) { }
        field(50018; "Campus Code"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No.")));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50019; "Campus Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50020; "Reg Option"; Code[50])
        {
            CalcFormula = lookup("Course Registration".Options where("Student No." = field("Student No."),
                                                                      Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(50021; Examiner1; Text[30]) { }
        field(50022; Examiner2; Text[30]) { }
        field(50023; Examiner3; Text[30]) { }
        field(50024; Examiner4; Text[30]) { }
        field(50025; Show; Boolean) { }
        field(50026; "Settlement Type"; Code[20])
        {
            CalcFormula = lookup("Course Registration"."Settlement Type" where("Student No." = field("Student No."),
                                                                                Reversed = const(false),
                                                                                "Settlement Type" = filter(<> '')));
            FieldClass = FlowField;
        }
        field(50067; "Credited Hours"; Decimal)
        {
            CalcFormula = lookup("Units/Subjects"."Credit Hours" where("Programme Code" = field(Programme),
                                                                        "Stage Code" = field(Stage),
                                                                        Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50068; "Unit Points"; Decimal) { }
        field(50069; "Credit Hours"; Decimal) { }
        field(50070; "Cancelled Score"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where("Student No." = field("Student No."),
                                                                 Programme = field(Programme),
                                                                 Semester = field(Semester),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 Cancelled = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50071; Supervisor; Code[20])
        {
            // TableRelation = "Lecturers/Examiners"."No.";
        }
        field(50072; "Released Results"; Boolean) { }
        field(50073; "Grade Acquired"; Code[10]) { }
        field(50076; "CATs Marks"; Decimal)
        {
            CalcFormula = sum("Exam Results".Score where("Reg. Transaction ID" = field("Reg. Transacton ID"),
                                                          "Student No." = field("Student No."),
                                                          Unit = field(Unit),
                                                          "Re-Sited" = const(false),
                                                          Exam = filter('CATS' | 'CAT' | 'CAT1' | 'CAT2' | 'CAT 1' | 'CAT 2')));
            FieldClass = FlowField;
        }
        field(50077; "EXAMs Marks"; Decimal)
        {
            CalcFormula = lookup("Exam Results".Score where("Reg. Transaction ID" = field("Reg. Transacton ID"),
                                                             "Student No." = field("Student No."),
                                                             Unit = field(Unit),
                                                             Exam = filter('EXAM' | 'EXAMS')));
            FieldClass = FlowField;
        }
        field(50079; "Grade Fin"; Code[10])
        {
            CalcFormula = lookup("Exam Results".Grade where("Student No." = field("Student No."),
                                                             "Reg. Transaction ID" = field("Reg. Transacton ID"),
                                                             Semester = field(Semester),
                                                             "Academic Year" = field("Academic Year"),
                                                             Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(50080; "Old Unit"; Boolean) { }
        field(50081; "Old Unit Lk"; Boolean)
        {
            CalcFormula = lookup("Units/Subjects"."Old Unit" where("Programme Code" = field(Programme),
                                                                    "Stage Code" = field(Stage),
                                                                    Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50082; "Creg Register for"; Option)
        {
            CalcFormula = lookup("Course Registration"."Register for" where("Student No." = field("Student No."),
                                                                             Semester = field(Semester),
                                                                             Programme = field(Programme),
                                                                             Reversed = const(false)));
            FieldClass = FlowField;
            NotBlank = false;
            OptionCaption = 'Stage,Unit/Subject,Supplementary,Retake';
            OptionMembers = Stage,"Unit/Subject",Supplementary,Retake;

            trigger OnValidate()
            begin
                //"Settlement Type":='';
                if "Register for" = "register for"::Stage then
                    Unit := '';
            end;
        }
        field(50083; "Creg Exists"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field("Student No."),
                                                             Semester = field(Semester),
                                                             Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(50084; "Prog Online Released"; Boolean)
        {
            CalcFormula = lookup(Programme."Release Online Results" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(50085; "CF Lk"; Decimal)
        {
            CalcFormula = lookup("Units/Subjects"."No. Units" where("Programme Code" = field(Programme),
                                                                     Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50086; "Stage Unit LK"; Code[20])
        {
            CalcFormula = lookup("Units/Subjects"."Stage Code" where("Programme Code" = field(Programme),
                                                                      Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50087; "Settlement Type Code"; Code[20]) { }
        field(50088; "Registration Type"; Option)
        {
            OptionCaption = 'Normal,Supplementary,Special,Retake';
            OptionMembers = Normal,Supplementary,Special,Retake;
        }
        field(50089; "Unit Exam Category"; Code[20])
        {
            CalcFormula = lookup("Units/Subjects"."Default Exam Category" where("Programme Code" = field(Programme),
                                                                                 Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50090; "Programme Exam Category"; Code[20])
        {
            CalcFormula = lookup(Programme."Exam Category" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(50091; "Creg Stage"; Code[20])
        {
            CalcFormula = lookup("Course Registration".Stage where("Student No." = field("Student No."),
                                                                    Semester = field(Semester),
                                                                    Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(50092; "Creg Stage1"; Code[20]) { }
        field(50093; Balance; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("Student No."),
                                                                         "Entry Type" = const("Initial Entry")));
            FieldClass = FlowField;
        }
        field(50094; "Allow Exam Attendance"; Boolean)
        {
            CalcFormula = lookup("Course Registration"."Allow Exam Attendance" where("Student No." = field("Student No."),
                                                                                      Semester = field(Semester),
                                                                                      Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(50095; "Project Unit"; Boolean)
        {
            CalcFormula = lookup("Units/Subjects".Project where("Programme Code" = field(Programme),
                                                                 Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50096; "Grade Prefix"; Code[20]) { }
        field(50097; "Unit Results Count"; Integer)
        {
            CalcFormula = count("Exam Results" where("Student No." = field("Student No."),
                                                      Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(50098; "Moderation Temp Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50099; "Moderation Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50100; Moderated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Moderation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Moderated By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; Released; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Mode of Study"; Code[20])
        {
            TableRelation = "Student Types".Code;
        }
        field(50105; Evaluated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Unit Option"; Code[50])
        {
            CalcFormula = lookup("Units/Subjects"."Programme Option" where("Programme Code" = field(Programme),
                                                                            Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50107; "Unit Type LK"; Option)
        {
            CalcFormula = lookup("Units/Subjects"."Unit Type" where("Programme Code" = field(Programme),
                                                                     Code = field(Unit)));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Core,Elective,Required';
            OptionMembers = Core,Elective,Required;
        }
        field(50108; "School Code"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(60035; "Programme Category"; Option)
        {
            CalcFormula = lookup(Programme.Category where(Code = field(Programme)));
            FieldClass = FlowField;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,PHD,Professional,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List";
        }
        field(60036; "Reg Prog"; Code[20])
        {
            CalcFormula = lookup("Course Registration".Programme where("Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Programme, Stage, Unit, Semester, "Reg. Transacton ID", "Student No.", ENo)
        {
            Clustered = true;
        }
        key(Key2; "Student No.", Unit) { }
        key(Key3; ENo, "Student No.", Programme, Stage, Unit, Semester, "Reg. Transacton ID") { }
        key(Key4; "Reg. Transacton ID", "Student No.", Programme, Stage, Unit, Semester, Reversed, "Result Status", "Ignore in Cumm  Average", "Supp Taken", "Attachment Unit")
        {
            SumIndexFields = "Final Score", "No. Of Units", "CF Score";
        }
        key(Key5; "Student No.", "Final Score") { }
        key(Key6; Stage) { }
        key(Key7; Unit, Stage, "Unit Type") { }
        key(Key8; Unit) { }
        key(Key9; "Final Score") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        ExamR.Reset;
        ExamR.SetRange(ExamR."Student No.", "Student No.");
        ExamR.SetRange(ExamR.Unit, Unit);
        ExamR.SetRange(ExamR."Reg. Transaction ID", "Reg. Transacton ID");
        ExamR.SetRange(ExamR.Cancelled, false);
        if ExamR.Find('-') then
            //ExamR.DELETEALL;
            Error('Please note that you can not delete a unit with valid results');
    end;

    trigger OnInsert()
    begin
        "Created by" := UserId;
        "Date created" := Today;

        //IF Taken=FALSE THEN
        //ERROR('The Course must be marked Taken!');
    end;

    trigger OnModify()
    begin
        if Prog.Get(Programme) then begin
            if Prog."Base Date" <> 0D then begin
                if Today > CalcDate(Prog."Grace Period", Prog."Base Date") then begin
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                    StudentCharges.SetRange(StudentCharges.Code, 'CHANGE');
                    StudentCharges.SetRange(StudentCharges.Recognized, false);
                    if StudentCharges.Find('-') = false then
                        Error('Changing of units after grace period not allowed.');


                end;
            end;
        end;
    end;

    var
        StudentCharges: Record "Student Charges";
        Stages: Record "Programme Stages";
        CReg: Record "Course Registration";
        UnitsS: Record "Units/Subjects";
        StudUnits: Record "Student Units";
        TTable2: Record "Time Table";
        Days: Record Days;
        Lessons: Record Lessons;
        TTable: Record "Time Table";
        UTaken: Integer;
        UFound: Boolean;
        CourseReg: Record "Course Registration";
        Prog: Record Programme;
        ExamR: Record "Exam Results";
        StatusC: Record "Post Grad Change History";
        UnitsCF: Decimal;
        AdditionalCF: Decimal;

    procedure GetGrade(Marks: Decimal; UnitG: Code[20]; Studprog: Code[20]; StudStage: Code[20]) xGrade: Text[100]
    var
        UnitsRR: Record "Units/Subjects";
        ProgrammeRec: Record Programme;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        GradeCategory: Code[20];
        Grade: Code[20];
    begin

        GradeCategory := '';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code", Studprog);
        UnitsRR.SetRange(UnitsRR.Code, UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code", StudStage);
        if UnitsRR.Find('-') then begin
            if UnitsRR."Default Exam Category" <> '' then begin
                GradeCategory := UnitsRR."Default Exam Category";
            end;
        end;
        if GradeCategory = '' then begin
            ProgrammeRec.Reset;
            if ProgrammeRec.Get(Studprog) then
                GradeCategory := ProgrammeRec."Exam Category";
            if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;
        xGrade := '';
        if Marks > 0 then begin
            Gradings.Reset;
            Gradings.SetRange(Gradings.Category, GradeCategory);
            LastGrade := '';
            LastRemark := '';
            LastScore := 0;
            if Gradings.Find('-') then begin
                ExitDo := false;
                repeat
                    LastScore := Gradings."Up to";
                    if Marks < LastScore then begin
                        if ExitDo = false then begin
                            xGrade := Gradings.Grade;
                            if Gradings.Failed = false then
                                LastRemark := 'PASS'
                            else
                                LastRemark := 'FAIL';
                            ExitDo := true;
                        end;
                    end;

                until Gradings.Next = 0;


            end;

        end else begin
            Grade := '';
            //Remarks:='Not Done';
        end;
    end;

    procedure GetGradeStatus(AvMarks: Decimal; ProgCode: Code[20]; Unit: Code[20]; StudStage: Code[20]) F: Boolean
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        ProgrammeRec: Record Programme;
        Grd: Code[80];
        GradeCategory: Code[20];
        UnitsRR: Record "Units/Subjects";
    begin
        F := false;

        GradeCategory := '';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code", ProgCode);
        UnitsRR.SetRange(UnitsRR.Code, Unit);
        UnitsRR.SetRange(UnitsRR."Stage Code", StudStage);
        if UnitsRR.Find('-') then begin
            if UnitsRR."Default Exam Category" <> '' then begin
                GradeCategory := UnitsRR."Default Exam Category";
            end else begin
                ProgrammeRec.Reset;
                if ProgrammeRec.Get(ProgCode) then
                    GradeCategory := ProgrammeRec."Exam Category";
                if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
            end;
        end;

        if AvMarks > 0 then begin
            Gradings.Reset;
            Gradings.SetRange(Gradings.Category, GradeCategory);
            LastGrade := '';
            LastRemark := '';
            LastScore := 0;
            if Gradings.Find('-') then begin
                ExitDo := false;
                repeat
                    LastScore := Gradings."Up to";
                    if AvMarks < LastScore then begin
                        if ExitDo = false then begin
                            Grd := Gradings.Grade;
                            F := Gradings.Failed;
                            ExitDo := true;
                        end;
                    end;

                until Gradings.Next = 0;


            end;

        end else begin


        end;
    end;
}

