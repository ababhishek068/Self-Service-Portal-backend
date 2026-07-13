Page 50368 "Marksheet Lines"
{

    //DeleteAllowed = false;
    //InsertAllowed = false;
    //ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Student Units";
    SourceTableView = sorting("Student No.", Unit);
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(StudentName; Rec."Student Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Name field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(CAT; Rec."CAT Total Marks")
                {
                    ApplicationArea = Basic;
                    Caption = 'CAT';
                    ToolTip = 'Specifies the value of the CAT field.';
                }
                field(ExamMarks; Rec."Exam Marks")
                {
                    ApplicationArea = Basic;
                    Caption = 'EXAM';
                    ToolTip = 'Specifies the value of the EXAM field.';
                }
                field(TotalScore; Rec."Total Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Score field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field("Grade Prefix"; Rec."Grade Prefix")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade Prefix field.';

                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(EXAM; Sc[1])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Caption = 'Exam';
                    Visible = FieldVisible1;
                    ToolTip = 'Specifies the value of the Exam field.';

                    trigger OnValidate()
                    begin
                        UpdateMarks(Sc[1], MATRIX_CaptionSet[1], ExamCategory);
                    end;
                }
                field(CAT1; Sc[2])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Caption = 'CAT1';
                    Visible = FieldVisible2;
                    ToolTip = 'Specifies the value of the CAT1 field.';

                    trigger OnValidate()
                    begin
                        UpdateMarks(Sc[2], MATRIX_CaptionSet[2], ExamCategory);
                    end;
                }
                field(CAT2; Sc[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Caption = 'CAT2';
                    Visible = FieldVisible3;
                    ToolTip = 'Specifies the value of the CAT2 field.';

                    trigger OnValidate()
                    begin
                        UpdateMarks(Sc[3], MATRIX_CaptionSet[3], ExamCategory);
                    end;
                }
                field(CAT3; Sc[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Caption = 'CAT3';
                    Visible = FieldVisible4;
                    ToolTip = 'Specifies the value of the CAT3 field.';

                    trigger OnValidate()
                    begin
                        UpdateMarks(Sc[4], MATRIX_CaptionSet[4], ExamCategory);
                    end;
                }
                field(CAT4; Sc[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Caption = 'CAT4';
                    Visible = FieldVisible5;
                    ToolTip = 'Specifies the value of the CAT4 field.';

                    trigger OnValidate()
                    begin
                        UpdateMarks(Sc[5], MATRIX_CaptionSet[5], ExamCategory);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Students Units")
            {
                ApplicationArea = Basic;
                Image = RefreshPlanningLine;
                RunObject = Page "Student Units - List";
                RunPageLink = "Student No." = field("Student No.");
                ToolTip = 'Executes the Students Units action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetExamCaption(ExamCategory);


        Rec.Reset;
        //  SetFilter(Programme, ProgrammeFilter);
        //  SetFilter(Stage, StageFilter);
        Rec.SetFilter(Semester, SemesterFilter);
        Rec.SetFilter(Unit, UnitFilter);
        Rec.SetFilter("Student No.", "Student No Filter");
        Rec.SetFilter("Campus Code", CampusFilter);
        Rec.SetFilter("Unit Class Code", ClassFilter);
        Rec.CalcFields("Exam Marks");
        Rec.CalcFields("CAT Total Marks");

        for i := 1 to 5 do begin
            if MATRIX_CaptionSet[i] = 'EXAM' then
                Sc[i] := Rec."Exam Marks";
            if MATRIX_CaptionSet[i] = 'CAT' then
                Sc[i] := Rec."CAT Total Marks";
            //  IF MATRIX_CaptionSet[i]='WBA' THEN
            //  Sc[i]:="Ass Total Marks";
        end;
        i := 0;
    end;

    var
        Sc: array[5] of Decimal;
        ProgrammeFilter: Code[20];
        StageFilter: Code[20];
        SemesterFilter: Code[20];
        UnitFilter: Code[20];
        CampusFilter: Code[20];
        ModeFilter: Code[20];
        ExamCategory: Code[20];
        "Student No Filter": Code[20];
        "ClassFilter": Code[20];
        UnitsR: Record "Units/Subjects";
        ExamResults: Record "Exam Results";
        ProgRec: Record Programme;
        ExamsSetup: Record "Exams Setup";
        ExamType: Option Assignment,CAT,"Final Exam",Supplementary,Special;
        XxScore: Decimal;
        OriginalUser: Code[50];
        ExamContrib: Decimal;
        MaxScore: Decimal;
        xxContrib: Decimal;
        MATRIX_CaptionSet: array[5] of Code[20];
        i: Integer;
        FieldVisible1: Boolean;
        FieldVisible2: Boolean;
        FieldVisible3: Boolean;
        FieldVisible4: Boolean;
        FieldVisible5: Boolean;
        SemRec: Record Semesters;
        LastEntry: Integer;
        RegisterForFilter: Option Stage,"Unit/Subject",Supplementary;
        ExamProc: codeunit "Exams Processing";
        ExamTypeCode: code[20];

    procedure Load(_ProgrammeFilter: Code[20]; _StageFilter: Code[20]; _SemesterFilter: Code[20]; _UnitFilter: Code[20]; _ExamCategory: Code[20]; _RegisterFor: Option Stage,"Unit/Subject",Supplementary; "_Student No": Code[20]; _CampusFilter: Code[20]; _ModeFilter: Code[20]; _ClassFilter: Code[20])
    begin
        ProgrammeFilter := _ProgrammeFilter;
        StageFilter := _StageFilter;
        SemesterFilter := _SemesterFilter;
        UnitFilter := _UnitFilter;
        ExamCategory := _ExamCategory;
        RegisterForFilter := _RegisterFor;
        CampusFilter := _CampusFilter;
        ModeFilter := _ModeFilter;
        "Student No Filter" := "_Student No";
        ClassFilter := _ClassFilter;
    end;

    procedure GetExamCaption(_ExamCategory: Code[20])
    begin
        if ExamCategory = '' then ExamCategory := 'UNDERGRADUATE';
        ExamsSetup.Reset;
        ExamsSetup.SetRange(ExamsSetup.Category, ExamCategory);
        if ExamsSetup.Find('-') then begin
            repeat
                i := i + 1;
                if i < 6 then
                    MATRIX_CaptionSet[i] := ExamsSetup.Code;
                if i = 1 then
                    FieldVisible1 := true;
                if i = 2 then
                    FieldVisible2 := true;
                if i = 3 then
                    FieldVisible3 := true;
                if i = 4 then
                    FieldVisible4 := true;
                if i = 5 then
                    FieldVisible5 := true;

            until ExamsSetup.Next = 0;
        end;
    end;

    procedure UpdateMarks(Score: Decimal; MarksType: Code[20]; ExamCategory: Code[20])
    begin
        //if ProgrammeFilter = '' then
        //    Error('You must specify the Programme filter.');
        //if StageFilter = '' then
        //    Error('You must specify the Stage filter');

        if UnitFilter = '' then
            Error('You must specify the Unit filter.');


        if SemesterFilter = '' then
            Error('You must specify the semester filter.');

        SemRec.Get(SemesterFilter);
        // IF MarksType='EXAM' THEN
        // IF SemRec."Allow Online Results"=TRUE THEN ERROR('Please note that editting of Exam Marks for the selected period has been locked')
        // ELSE
        // IF SemRec."Allow Online Registration"=TRUE THEN ERROR('Please note that editting of CAT Marks for the selected period has been locked');

        //IF PeriodCode='' THEN
        //ERROR('You must specify the Exam Period.');

        UnitsR.Reset;
        UnitsR.SetRange(UnitsR."Programme Code", ProgrammeFilter);
        UnitsR.SetRange(UnitsR.Code, UnitFilter);
        if UnitsR.Find('-') then begin
            if UnitsR.Submited = true then
                Error('The marks have already been submited.');
        end;

        //MESSAGE('Test-'+FORMAT(ExamCategory));
        if Score < 0 then Error('Marks Can Not be Less than Zero');

        ExamsSetup.Reset;
        ExamsSetup.SetFilter(ExamsSetup.Category, ExamCategory);
        ExamsSetup.SetRange(ExamsSetup.Code, MarksType);
        if ExamsSetup.Find('-') then begin
            if Score > ExamsSetup."Max. Score" then
                Error('You Cant Enter Score Above The Maximum Score. The Maximum Score is ' + Format(ExamsSetup."Max. Score"));
            if ExamsSetup.Type = ExamsSetup.Type::Supplementary then begin
                if Rec."Allow Supplementary" = false then
                    Error('Student not allowed to sit supplementary.');
            end;
        end;






        /*/////////////Comment checks
        
        ExamsSetup.RESET;
        ExamsSetup.SETRANGE(ExamsSetup.Category,GETFILTER(Category));
        ExamsSetup.SETRANGE(ExamsSetup.Code,CurrForm.Matrix.MatrixRec.Code);
        IF ExamsSetup.FIND('-') THEN BEGIN
        IF ExamsSetup.Type = ExamsSetup.Type::"Final Exam" THEN BEGIN
        //Check Fee Bal
        IF Cust.GET("Student No.") THEN BEGIN
        Cust.CALCFIELDS(Cust."Balance (LCY)");
        IF Cust."Balance (LCY)" > 0 THEN
        ERROR('Student has a fee balance.');
        
        //Check if CAT done
        Exams.RESET;
        Exams.SETRANGE(Exams.Category,ExamCategory);
        Exams.SETRANGE(Exams.Type,Exams.Type::CAT);
        IF Exams.FIND('-') THEN BEGIN
        REPEAT
        EResults.RESET;
        EResults.SETRANGE(EResults."Student No.","Student No.");
        EResults.SETRANGE(EResults.Programme,Programme);
        EResults.SETRANGE(EResults.Unit,Unit);
        EResults.SETRANGE(EResults.Semester,GETFILTER("Semester Filter"));
        EResults.SETRANGE(EResults.Exam,Exams.Code);
        EResults.SETFILTER(EResults.Score,'>0');
        IF EResults.FIND('-') = FALSE THEN
        ERROR('%1 not done.',Exams.Desription);
        
        
        UNTIL Exams.NEXT = 0;
        END;
        
        
        END;
        
        UnitsR.RESET;
        UnitsR.SETRANGE(UnitsR."Programme Code",Programme);
        UnitsR.SETRANGE(UnitsR.Code,Unit);
        IF UnitsR.FIND('-') THEN BEGIN
        IF UnitsR."Credit Hours" > 0 THEN BEGIN
        IF Attendance < (0.75*UnitsR."Credit Hours") THEN
        ERROR('Student attendance less than the minimum required (75 Percent).');
        END;
        END;
        END;
        
        IF Score > ExamsSetup."Max. Score" THEN
        ERROR('You cant enter score above the maximum score.');
        IF ExamsSetup.Type = ExamsSetup.Type::Supplementary THEN BEGIN
        IF "Allow Supplementary" = FALSE THEN
        ERROR('Student not allowed to sit supplementary.');
        END;
        END;
        
        
        
        IF (GETFILTER("Exam Type") ='SPECIAL') OR (GETFILTER("Exam Type") ='SUPPLEMENTARY') THEN
        IF CurrForm.Matrix.MatrixRec.Code<> 'EXAM' THEN
        ERROR('Please note that CAT is not allowed for SPECIAL and SUPPLEMENTARY Exams ');
        */
        ProgRec.Get(Rec.Programme);
        ProgRec.TestField(ProgRec."Exam Category");
        ExamsSetup.Reset;
        ExamsSetup.SetFilter(ExamsSetup.Category, ProgRec."Exam Category");
        ExamsSetup.SetRange(ExamsSetup.Code, MarksType);
        if ExamsSetup.Find('-') then begin
            ExamType := ExamsSetup.Type;
            ExamTypeCode := ExamsSetup.Code;
            MaxScore := ExamsSetup."Max. Score";
            ExamContrib := ExamsSetup."% Contrib. Final Score";
        end;


        OriginalUser := UserId;
        ExamResults.Reset;
        //ExamResults.SETRANGE(ExamResults."Reg. Transaction ID","Reg. Transacton ID");
        ExamResults.SetRange(ExamResults."Student No.", Rec."Student No.");
        ExamResults.SetRange(ExamResults.Programme, Rec.Programme);
        //ExamResults.SETRANGE(ExamResults.Stage,Stage);
        ExamResults.SetRange(ExamResults.Unit, Rec.Unit);
        ExamResults.SetRange(ExamResults.Semester, SemesterFilter);
        ExamResults.SetRange(ExamResults.ExamType, ExamTypeCode);
        if ExamResults.Find('-') then begin
            repeat
                XxScore := ExamResults.Score;
                xxContrib := (XxScore * ExamContrib) / MaxScore;
                OriginalUser := ExamResults.UserID;
                ExamResults.Cancelled := true;
                ExamResults."Cancelled By" := UserId;
                ExamResults."Cancelled Date" := Today;
                ExamResults.Modify;
            until ExamResults.Next = 0;
        end;

        ExamResults.Reset;
        if ExamResults.Find('-') then
            LastEntry := ExamResults.Count;

        ExamResults.Init;
        ExamResults."Reg. Transaction ID" := Rec."Reg. Transacton ID";
        ExamResults."Student No." := Rec."Student No.";
        ExamResults.Programme := Rec.Programme;
        ExamResults.Stage := Rec.Stage;
        ExamResults.Unit := Rec.Unit;
        ExamResults.Semester := SemesterFilter;
        ExamResults.Score := Score;
        ExamResults.Exam := format(ExamType);
        ExamResults.ExamType := ExamTypeCode;
        ExamResults.Category := ExamCategory;
        //ExamResults.VALIDATE(ExamResults.Score);
        //ExamResults.Contribution:=(Score*ExamContrib)/MaxScore
        ExamResults.Contribution := Score;
        ExamResults.UserID := OriginalUser;
        ExamResults."Last Edited By" := UserId;
        ExamResults."Last Edited On" := Today;
        ExamResults."Original Score" := XxScore;
        ExamResults."Original Contribution" := xxContrib;
        ExamResults."Entry No" := LastEntry + 1;
        //ExamResults.VALIDATE(Score);
        ExamResults.Insert;

        ExamResults.Reset;
        ExamResults.SetRange("Student No.", Rec."Student No.");
        ExamResults.SetRange(Unit, Rec.Unit);
        ExamResults.SetRange("Entry No", LastEntry + 1);
        if ExamResults.Find('-') then ExamResults.Validate(Score);

        ExamProc.UpdateStudentUnits(Rec."Student No.", Rec.Programme, SemesterFilter, Rec.Stage, Rec.Unit);

    end;
}

