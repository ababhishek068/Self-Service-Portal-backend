Table 50065 "Lecturers Units Claim"
{

    fields
    {
        field(1; Lecturer; Code[30])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
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
        field(4; Unit; Code[20])
        {
            NotBlank = true;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme));

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


                UnitSubj.Reset;
                UnitSubj.SetRange(UnitSubj.Code, Unit);
                UnitSubj.SetRange(UnitSubj."Programme Code", Programme);
                if UnitSubj.Find('-') then
                    Description := UnitSubj.Desription;
                "Unit Name" := UnitSubj.Desription;
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
            TableRelation = "Course Classes".Code where(Programme = field(Programme),
                                                         Stage = field(Stage));
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
                                                       "Mode of Study" = field("Student Type"),
                                                       "Campus Code" = field("Campus Code"),
                                                       Semester = field(Semester)));
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                Error(NoAccess);
            end;

            trigger OnValidate()
            begin
                Error(NoAccess);
            end;
        }
        field(25; "Unit Results Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Semester = field(Semester),
                                                       Programme = field(Programme),
                                                       Stage = field(Stage),
                                                       Unit = field(Unit),
                                                       "Final Score" = filter(> 0)));
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
        field(39003907; "Claim Batch No"; Code[20]) { }
        field(39003908; "Line No"; Integer) { }
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
        UnitSubj: Record "Units/Subjects";
        DimVal: Record "Dimension Value";
        NoAccess: label 'You have no Access. Contact your System Administrator';
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
        ClaimRate.SetFilter(ClaimRate."Students NUmbers", '%1', "Unit Students Count");
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
}

