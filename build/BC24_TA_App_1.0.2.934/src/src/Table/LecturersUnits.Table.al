Table 50061 "Lecturers Units"
{

    fields
    {
        field(1; Lecturer; Code[30])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            begin
                if HREmp.get(Lecturer) then begin
                    if HREmp."Part Time" = true then "Parttime Allocation" := true;
                end;
            end;
        }
        field(2; Programme; Code[20])
        {
            TableRelation = Programme.Code;
        }
        field(3; Stage; Code[20])
        {
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(80; "Units Section Type"; Option)
        {
            OptionMembers = Programme,"Course Master";
        }
        field(4; Unit; Code[20])
        {
            NotBlank = true;
            //TableRelation = if ("Units Section Type" = const(Programme)) "Units/Subjects".Code where("Programme Code" = field(Programme))
            // else
            TableRelation = "Courses Master".Code;

            trigger OnValidate()
            begin
                if HREmp.Get(Lecturer) then begin
                    HREmp.TestField(HREmp."Lecturer Category");
                    LectCat.Get(HREmp."Lecturer Category");
                    LecUnits.Reset;
                    LecUnits.SetRange(LecUnits.Lecturer, Lecturer);
                    LecUnits.SetRange(LecUnits.Semester, Semester);
                    if LecUnits.Count > LectCat."Max. Units" then Error('Lecturer No. ' + Lecturer + ' has been allocated more than maximum units: ' + Format(LecUnits.Count) + ' / ' + Format(LectCat."Max. Units"));

                    LecUnits.Reset;
                    LecUnits.SetRange(LecUnits.Lecturer, Lecturer);
                    LecUnits.SetRange(LecUnits.Semester, Semester);
                    LecUnits.SetRange(LecUnits."Lecturer Type", LecUnits."lecturer type"::"Full Time");
                    if LecUnits.Count > LectCat."Max. Fulltime Units" then Error('Lecturer No. ' + Lecturer + ' has been allocated more than maximum Full Time units: ' + Format(LecUnits.Count) + ' / ' + Format(LectCat."Max. Fulltime Units"));

                    LecUnits.Reset;
                    LecUnits.SetRange(LecUnits.Lecturer, Lecturer);
                    LecUnits.SetRange(LecUnits.Semester, Semester);
                    LecUnits.SetRange(LecUnits."Lecturer Type", LecUnits."lecturer type"::"Part Time");
                    if LecUnits.Count > LectCat."Max. Parttime Units" then Error('Lecturer No. ' + Lecturer + ' has been allocated more than maximum Part Time units: ' + Format(LecUnits.Count) + ' / ' + Format(LectCat."Max. Parttime Units"));

                    LecUnits.Reset;
                    LecUnits.SetRange(LecUnits.Lecturer, Lecturer);
                    LecUnits.SetRange(LecUnits.Semester, Semester);
                    if LecUnits.Count > LectCat."Max. Units" then Error('Lecturer No. ' + Lecturer + ' has been allocated more than maximum Total Units: ' + Format(LecUnits.Count) + ' / ' + Format(LectCat."Max. Units"));

                end;

                if UnitSubj.get(Unit) then begin
                    Description := UnitSubj.Description;
                    "Unit Name" := UnitSubj.Description;
                end;
            end;
        }
        field(5; Semester; Code[20])
        {
            NotBlank = true;
            TableRelation = Semesters.Code;
        }
        field(6; Remarks; Text[200]) { }
        field(7; "No. Of Hours"; Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                CalculateClaim;
            end;
        }
        field(8; "No. Of Hours Contracted"; Decimal) { }
        field(9; "Available From"; Time) { }
        field(10; "Available To"; Time) { }
        field(11; "Time Table Hours"; Decimal)
        {
            CalcFormula = sum("Time Table"."No. Of Hours" where(Programme = field(Programme),
                                                                 Stage = field(Stage),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Minimum Contracted"; Decimal) { }
        field(13; Class; Code[50])
        {
            TableRelation = "Course Classes".Code;
        }
        field(14; "Unit Class"; Code[30])
        {
            TableRelation = "Units Classes".Code where(Programme = field(Programme),
                                                        Stage = field(Stage),
                                                        Unit = field(Unit));
        }
        field(15; "Student Type"; Code[20])
        {
            TableRelation = "Student Types".Code;
        }
        field(16; Allocation; Decimal)
        {
            CalcFormula = sum("Time Table"."No. Of Hours" where(Programme = field(Programme),
                                                                 Stage = field(Stage),
                                                                 Unit = field(Unit),
                                                                 Semester = field(Semester),
                                                                 "Unit Class" = field("Unit Class")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; Description; Text[200]) { }
        field(18; Rate; Decimal) { }
        field(19; "Credit hours"; Decimal)
        {
            CalcFormula = lookup("Units/Subjects"."No. Units");
            FieldClass = FlowField;
        }
        field(20; "Lect. Hrs"; Decimal) { }
        field(21; "Pract. Hrs"; Decimal) { }
        field(22; "Tut. Hrs"; Decimal) { }
        field(23; "Class Type"; Option)
        {
            OptionCaption = 'SSP,JAB,SSP & JAB';
            OptionMembers = SSP,JAB,"SSP & JAB";
        }
        field(24; "Unit Students Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Unit = field(Unit),
                                                       "Settlement Type" = field("Settlement Type Filter"),
                                                       "Campus Code" = field("Campus Code"),
                                                       Semester = field(Semester)));
            FieldClass = FlowField;


        }
        field(25; "Unit Results Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Semester = field(Semester),
                                                      Stage = field(Stage),
                                                       Unit = field(Unit),
                                                       "Total Score" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(26; Claimed; Boolean) { }
        field(27; Amount; Decimal) { }
        field(28; "Claimed Date"; Date) { }
        field(29; "Campus Code"; Code[20])
        {
            Caption = 'Campus Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(30; "Class Size"; Decimal) { }
        field(33; Category; Option)
        {
            CalcFormula = lookup(Programme.Category where(Code = field(Programme)));
            FieldClass = FlowField;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,Post Graduate Diploma,PHD,Professional,Pre-University,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,"Post Graduate Diploma",PHD,Professional,"Pre-University","Course List";
        }
        field(51000; "Parttime Lecturer"; Boolean)
        {
            CalcFormula = lookup("HR-Employee"."Part Time" where("No." = field(Lecturer)));
            FieldClass = FlowField;
        }
        field(51101; "School Based Students"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field(Programme),
                                                       Semester = field(Semester),
                                                       Unit = field(Unit),
                                                       "Settlement Type" = filter('SCH_BASED')));
            FieldClass = FlowField;
        }
        field(51102; "Students Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field(Programme),
                                                       Semester = field(Semester),
                                                       Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(51103; "Programme Category"; Option)
        {
            CalcFormula = lookup(Programme.Category where(Code = field(Programme)));
            FieldClass = FlowField;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,PHD,Professional,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List";
        }
        field(51104; "Unit CF"; Decimal)
        {
            CalcFormula = lookup("Units/Subjects"."No. Units" where("Programme Code" = field(Programme),
                                                                     Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(51105; "Parttime Allocation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51106; "GSSP Students"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field(Programme),
                                                       Semester = field(Semester),
                                                       Unit = field(Unit),
                                                       "Settlement Type" = filter('GSSP')));
            FieldClass = FlowField;
        }
        field(51107; "PSSP Students"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field(Programme),
                                                       Semester = field(Semester),
                                                       Unit = field(Unit),
                                                       "Settlement Type" = filter('PSSP')));
            FieldClass = FlowField;
        }
        field(51108; "Claim Count"; Integer)
        {
            CalcFormula = count("Staff Claim Lines" where("Semester Code" = field(Semester),
                                                       "Unit Code" = field(Unit), "Lecturer No" = field(Lecturer),
                                                       "Settlement Type" = field("Settlement Type Filter")));
            FieldClass = FlowField;
        }
        field(51109; "Settlement Type Filter"; code[20])
        {
            TableRelation = "Settlement Type";
            FieldClass = FlowFilter;
        }
        field(39003900; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    Dim1 := DimVal.Name
            end;
        }
        field(39003901; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    Dim2 := DimVal.Name
            end;
        }
        field(39003902; Dim1; Text[80]) { }
        field(39003903; Dim2; Text[80]) { }
        field(39003904; "Mode Of Study"; Code[20])
        {
            TableRelation = "Settlement Type".Code;
        }
        field(39003905; "UnClaimed Hours"; Decimal)
        {
            CalcFormula = sum("Class Attendance Header."."Lesson Hours" where("Lecturer Code" = field(Lecturer),
                                                                               "Semester Code" = field(Semester),
                                                                               "Unit Code" = field(Unit)));
            FieldClass = FlowField;
        }
        field(39003906; "UnClaimed Students"; Integer)
        {
            CalcFormula = count("Class Attendance Lines" where("Lecturer Code" = field(Lecturer),
                                                                Semester = field(Semester),
                                                                "Unit Code" = field(Unit)));
            FieldClass = FlowField;
        }
        field(39003907; "Claim Batch No"; Code[20])
        {

            trigger OnValidate()
            begin
                CalculateClaim_Att;
            end;
        }
        field(39003908; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(39003909; "Unit Name"; Text[200]) { }
        field(39003910; "Lect Name"; Text[100]) { }
        field(39003911; "Academic Year"; Code[20]) { }
        field(39003912; "Current Sem Count"; Integer)
        {
            CalcFormula = count("Student Types" where("Current Semester" = field(Semester)));
            FieldClass = FlowField;
        }
        field(39003913; "Claims Sem Count"; Integer)
        {
            CalcFormula = count("Student Types" where("Exam Semester" = field(Semester)));
            FieldClass = FlowField;
        }
        field(39003914; "Lecturer Type"; Option)
        {
            OptionCaption = ' ,Full Time,Part Time,CSR';
            OptionMembers = " ","Full Time","Part Time",CSR;
        }
        field(39003915; "Is PartTimer"; Boolean)
        {
            CalcFormula = lookup("HR-Employee"."Part Time" where("No." = field(Lecturer)));
            FieldClass = FlowField;
        }
        field(39003916; Installment; Option)
        {
            OptionCaption = '1st Installment,2nd Installment';
            OptionMembers = "1st Installment","2nd Installment";
        }
        field(39003917; "Claimed Count"; Integer)
        {
            CalcFormula = count("Lecturers Units Claim" where(Lecturer = field(Lecturer),
                                                               Programme = field(Programme),
                                                               Stage = field(Stage),
                                                               Unit = field(Unit),
                                                               Semester = field(Semester),
                                                               Installment = field(Installment)));
            FieldClass = FlowField;
        }
        field(39003918; "Attendance Hrs"; Decimal)
        {
            CalcFormula = sum("Class Attendance Header."."Lesson Hours" where("Lecturer Code" = field(Lecturer),
                                                                               "Unit Code" = field(Unit),
                                                                               "Semester Code" = field(Semester),
                                                                               "Week Code" = filter('WK1' .. 'WK17'),
                                                                               "Campus Code" = field("Campus Code")));
            FieldClass = FlowField;
        }
        field(39003919; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(39003920; "Student Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Student Units" where(Unit = field(Unit),
                                                       Semester = field(Semester),

                                                       "Campus Code" = field("Campus Code")
                                                       , "Unit Class Code" = field(Class)));

        }
        field(39003921; "CAT Count"; Integer)
        {
            CalcFormula = count("Exam Results" where(Unit = field(Unit),
                                                      Programme = field(Programme),
                                                      Semester = field(Semester),
                                                      ExamType = filter('CAT*'),
                                                      "Campus Code" = field("Campus Code")));
            FieldClass = FlowField;
        }
        field(39003922; "EXAM Count"; Integer)
        {
            CalcFormula = count("Exam Results" where(Unit = field(Unit),
                                                      Programme = field(Programme),
                                                      Semester = field(Semester),
                                                      ExamType = filter('*EXAM*'),
                                                      "Campus Code" = field("Campus Code")));
            FieldClass = FlowField;
        }
        field(39003923; "Evaluation Count"; Integer)
        {
            CalcFormula = count("Lecturer Evaluation" where("Unit Code" = field(Unit),
                                                             "Staff No" = field(Lecturer),
                                                             Semester = field(Semester),
                                                             "Quiz Code" = field("Evaluation Quiz Filter")));
            FieldClass = FlowField;
        }
        field(39003924; "Evaluation Quiz Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(39003925; "Unit Department"; Code[20])
        {
            CalcFormula = lookup(Programme."Department Code" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(50145; "Unit School"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(39003926; "Evaluation Score"; Decimal)
        {
            CalcFormula = sum("Lecturer Evaluation"."Question Score" where("Unit Code" = field(Unit),
                                                                            "Staff No" = field(Lecturer),
                                                                            Semester = field(Semester),
                                                                            "Quiz Code" = field("Evaluation Quiz Filter")));
            FieldClass = FlowField;
        }
        field(39003927; "Evaluation Score2"; Decimal)
        {
            CalcFormula = sum("Lecturer Evaluation"."Question Score" where("Staff No" = field(Lecturer),
                                                                            Semester = field(Semester),
                                                                            "Evaluation Question" = filter('Achievement of course objective')));
            FieldClass = FlowField;
        }
        field(39003928; "Evaluation Count2"; Integer)
        {
            CalcFormula = count("Lecturer Evaluation" where("Staff No" = field(Lecturer),
                                                             Semester = field(Semester),
                                                             "Evaluation Question" = filter('Achievement of course objective')));
            FieldClass = FlowField;
        }
        field(51204; "Marks Entry Setup Done"; Boolean) { }
        field(51205; "PSSP Class Students"; Integer) { }
        field(51206; "GSSP Class Students"; Integer) { }
        field(51207; "TT Class"; code[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Time Table"."Unit Class" where(Unit = field(Unit), Semester = field(Semester), Lecturer = field("Lecturer"), "Campus Code" = field("Campus Code")));
        }
        field(51208; "TT Class Size"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Time Table"."Class Size" where(Unit = field(Unit), Semester = field(Semester), Lecturer = field("Lecturer"), "Campus Code" = field("Campus Code")));
        }

    }

    keys
    {
        key(Key1; Programme, Stage, Unit, Semester, Lecturer, "Campus Code", "Student Type", "Line No")
        {
            Clustered = true;
        }
        key(Key2; Lecturer) { }
        key(Key3; Unit) { }
        key(Key4; Semester) { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Claimed = true then
            Error('This Unit Cannot Be Deleted As It has Already Been Claimed');
    end;

    var
        UnitSubj: Record "Courses Master";
        DimVal: Record "Dimension Value";
        LectCat: Record "Lecturers Category";
        HREmp: Record "HR-Employee";
        LecUnits: Record "Lecturers Units";

    local procedure CalculateClaim()
    var
        UnitAmount: Decimal;
        TotalAmount: Decimal;
        ClaimRate: Record "Lecturers Claim Rates";
    begin
        CalcFields(Category);
        CalcFields("UnClaimed Students");
        CalcFields("Unit Students Count");
        TotalAmount := 0;
        UnitAmount := 0;
        ClaimRate.Reset;
        ClaimRate.SetFilter(ClaimRate."Programme Category", '%1', Category);
        ClaimRate.SetFilter(ClaimRate."Students NUmbers", '%1..%2', 0, "Unit Students Count");
        if ClaimRate.Find('-') then
            UnitAmount := ClaimRate.Rate;

        if UnitAmount = 0 then begin
            ClaimRate.Reset;
            ClaimRate.SetFilter(ClaimRate."Programme Category", '%1', Category);
            if ClaimRate.Find('+') then
                UnitAmount := ClaimRate.Rate;
        end;
        TotalAmount := UnitAmount * "No. Of Hours";
        Rate := UnitAmount;
        Amount := TotalAmount;
        "Class Size" := "Unit Students Count";
    end;

    local procedure CalculateClaim_Att()
    var
        UnitAmount: Decimal;
        TotalAmount: Decimal;
        ClaimRate: Record "Lecturers Claim Rates";
    begin
        CalcFields(Category);
        CalcFields("UnClaimed Students");
        CalcFields("Unit Students Count");
        CalcFields("Attendance Hrs");
        TotalAmount := 0;
        UnitAmount := 0;
        ClaimRate.Reset;
        ClaimRate.SetFilter(ClaimRate."Programme Category", '%1', Category);
        ClaimRate.SetFilter(ClaimRate."Students NUmbers", '%1..%2', 0, "Unit Students Count");
        if ClaimRate.Find('-') then
            UnitAmount := ClaimRate.Rate;

        if UnitAmount = 0 then begin
            ClaimRate.Reset;
            ClaimRate.SetFilter(ClaimRate."Programme Category", '%1', Category);
            if ClaimRate.Find('+') then
                UnitAmount := ClaimRate.Rate;
        end;
        "No. Of Hours" := "Attendance Hrs";
        TotalAmount := UnitAmount * "Attendance Hrs";
        Rate := UnitAmount;
        Amount := TotalAmount;
        "Class Size" := "Unit Students Count";
    end;
}

