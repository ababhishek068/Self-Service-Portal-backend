Page 50367 "Marksheet Header1"
{
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Login)
            {
                Caption = 'Login';
                field(StaffFilter; StaffFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff No.';
                    TableRelation = "HR-Employee"."No.";
                    LookupPageId = "Lecturer List";
                    ToolTip = 'Specifies the value of the Staff No. field.';
                }
                field(LecPass; LecPass)
                {
                    ApplicationArea = Basic;
                    Caption = 'Password';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the value of the Password field.';

                    trigger OnValidate()
                    begin

                        PassOk := false;
                        //error(LecCode);
                        if Employee.Get(StaffFilter) then begin
                            if LecPass <> Employee.Password then begin
                                //CurrPage.Filters:=FALSE;
                                Error('Incorrect password. Please ensure the caps lock is not on by mistake.');
                            end else begin
                                PassOk := true;
                                //CurrPage.Filters:=TRUE;
                            end;
                        end;
                    end;
                }
            }
            group(Filters)
            {
                Caption = 'Students Filters';
                field(ProgrammeFilter; ProgrammeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme Filter';
                    TableRelation = Programme.Code;
                    ToolTip = 'Specifies the value of the Programme Filter field.';

                    trigger OnValidate()
                    begin
                        if Prog.Get(ProgrammeFilter) then
                            ExamCategory := Prog."Exam Category";

                        CurrPage.Marksheet.Page.GetExamCaption(ExamCategory);
                        CurrPage.Update;

                        SetMatrixFilter;
                    end;
                }
                field(StageFilter; StageFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stage Filter';
                    TableRelation = "Programme Stages".Code;
                    ToolTip = 'Specifies the value of the Stage Filter field.';
                }
                field(SemesterFilter; SemesterFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    TableRelation = "Programme Semesters".Semester;
                    ToolTip = 'Specifies the value of the Semester Filter field.';

                    trigger OnValidate()
                    begin
                        if PassOk = false then
                            Error('Incorrect password. Please ensure the caps lock is not on by mistake.');
                        SetMatrixFilter;
                    end;
                }
                field(UnitFilter; UnitFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Filter';
                    TableRelation = "Units/Subjects".Code;
                    ToolTip = 'Specifies the value of the Unit Filter field.';

                    trigger OnValidate()
                    begin
                        if PassOk = false then
                            Error('Incorrect password. Please ensure the caps lock is not on by mistake.');
                        UnitsR.Reset;
                        UnitsR.SetRange(UnitsR."Programme Code", ProgrammeFilter);
                        UnitsR.SetRange(UnitsR.Code, UnitFilter);
                        if UnitsR.Find('-') then
                            if UnitsR."Default Exam Category" <> '' then ExamCategory := UnitsR."Default Exam Category";

                        SetMatrixFilter;
                    end;
                }
                field("Register For"; RegisterFor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the RegisterFor field.';

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(ExamCategory; ExamCategory)
                {
                    ApplicationArea = Basic;
                    TableRelation = "Exam Category".Code;
                    ToolTip = 'Specifies the value of the ExamCategory field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Marksheet.Page.GetExamCaption(ExamCategory);
                        CurrPage.Update;
                    end;

                }
                field(CampusFilter; BranchFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Campus Filter';
                    TableRelation = "Dimension Value".Code;
                    ToolTip = 'Specifies the value of the Campus Filter field.';

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(ModeFilter; ModeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Mode Filter';
                    TableRelation = "Student Types".Code;
                    ToolTip = 'Specifies the value of the Mode Filter field.';
                }
                field(ClassFilter; ClassFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Class Filter';
                    TableRelation = "Course Classes".Code;
                    ToolTip = 'Specifies the value of the Class Filter field.';
                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field("Student No. Filter"; "Student No. Filter")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student No. Filter';
                    TableRelation = Customer."No." where("Customer Type" = const(Student));
                    ToolTip = 'Specifies the value of the Student No. Filter field.';
                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
            }
            group(Marks)
            {
                Caption = 'Marks Entry';
                field(EStudent; EStudent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Number';
                    ToolTip = 'Specifies the value of the Student Number field.';

                    trigger OnValidate()
                    begin

                        EStudName := '';
                        if not (Students.Get(EStudent)) and (EStudent <> '') then
                            Error('Invalid Student Number')
                        else
                            EStudName := Students.Name;
                        EStudentBranch := Students."Global Dimension 2 Code";
                        EScore := 0;
                        EScore2 := 0;

                        StudUnits.Reset;
                        StudUnits.SetRange(StudUnits."Student No.", EStudent);
                        StudUnits.SetFilter(StudUnits.Programme, ProgrammeFilter);
                        StudUnits.SetFilter(StudUnits.Stage, StageFilter);
                        StudUnits.SetFilter(StudUnits.Semester, SemesterFilter);
                        StudUnits.SetFilter(StudUnits.Unit, UnitFilter);
                        if not StudUnits.Find('-') then Error('Student ' + EStudent + ' is not registered to unit ' + UnitFilter);

                        ExamPeriod.Reset;
                        //ExamPeriod.SETRANGE(ExamPeriod.Current,TRUE);
                        if ExamPeriod.Find('-') then
                            ExamSeriesFilter := ExamPeriod.Code;

                        SelUnit := UnitFilter;
                        ExamResults.Reset;
                        ExamResults.SetRange(ExamResults."Student No.", EStudent);
                        ExamResults.SetRange(ExamResults.Submitted, false);
                        //ExamResults.SETRANGE(ExamResults.Programme,Programme);
                        ExamResults.SetRange(ExamResults.Unit, SelUnit);
                        ExamResults.SetFilter(ExamResults.ExamType, 'EXAM');
                        if ExamResults.Find('-') then begin
                            EScore := ExamResults.Score;
                            //CatsEXist:=TRUE;
                        end;

                        // SelUnit:=UnitFilter;
                        // ExamResults.RESET;
                        // ExamResults.SETRANGE(ExamResults."Student No.",EStudent);
                        // //ExamResults.SETRANGE(ExamResults.Programme,Programme);
                        // ExamResults.SETRANGE(ExamResults.Unit,SelUnit);
                        // ExamResults.SETFILTER(ExamResults.ExamType,'WBA');
                        // IF ExamResults.FIND('-') THEN BEGIN
                        // EScore2:=ExamResults.Score;
                        // WbaExists:=TRUE;
                        // END;
                    end;
                }
                field(EStudName; EStudName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student Name field.';
                }

                field(EScore; EScore)
                {
                    ApplicationArea = Basic;
                    Caption = 'EXAM';
                    ToolTip = 'Specifies the value of the EXAM field.';

                    trigger OnValidate()
                    begin
                        ExamsSetup.Reset;
                        ExamsSetup.SetFilter(ExamsSetup.Category, 'NORMAL');
                        ExamsSetup.SetRange(ExamsSetup.Code, 'EXAM');
                        if ExamsSetup.Find('-') then
                            if EScore > ExamsSetup."Max. Score" then
                                Error('You Cant Enter Score Above The Maximum Score. The Maximum Score is ' + Format(ExamsSetup."Max. Score"));

                        //TTable.SETRANGE(TTable.Semester,GETFILTER("Semester Filter"));
                        UnitsR.Reset;
                        UnitsR.SetRange(UnitsR."Programme Code", ProgrammeFilter);
                        UnitsR.SetRange(UnitsR."Stage Code", StageFilter);
                        UnitsR.SetRange(UnitsR.Code, UnitFilter);
                        UnitsR.SetFilter(UnitsR."Semester Filter", SemesterFilter);
                        if UnitsR.Find('-') then begin
                            UnitsR.CalcFields(UnitsR."Students Registered");
                            NoStud := UnitsR."Students Registered";
                        end;

                        Lect := '';

                        LecUnits.Reset;
                        LecUnits.SetRange(LecUnits.Programme, ProgrammeFilter);
                        LecUnits.SetRange(LecUnits.Stage, StageFilter);
                        LecUnits.SetRange(LecUnits.Unit, UnitFilter);
                        LecUnits.SetRange(LecUnits.Semester, SemesterFilter);
                        if LecUnits.Find('-') then begin
                            if Employee.Get(LecUnits.Lecturer) then
                                Lect := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                        end;
                    end;
                }
            }
            group(Students)
            {
                part(Marksheet; "Marksheet Lines")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Submit)
            {
                ApplicationArea = Basic;
                Gesture = RightSwipe;
                Image = Approve;
                InFooterBar = true;
                Promoted = true;
                PromotedIsBig = true;
                ShortCutKey = 'F11';
                ToolTip = 'Executes the Submit action.';

                trigger OnAction()
                begin
                    //ERROR('Test');
                    SubmitMarks;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        SetMatrixFilter;
        if UserSetup.Get(UserId) then begin
            if UserSetup."Can Edit Marks" = false then Error('Please note that this window is only for Authorised users');
        end else begin
            Error('Please note that this window is only for Authorised users');
        end;
    end;

    var
        ProgrammeFilter: Code[20];
        StageFilter: Code[20];
        SemesterFilter: Code[20];
        BranchFilter: Code[20];
        UnitFilter: Code[20];
        StudUnits: Record "Student Units";
        ExamSeriesFilter: Code[20];
        ExamCategory: Code[20];
        Prog: Record Programme;
        RegisterFor: Option Stage,"Unit/Subject",Supplementary;
        UserSetup: Record "User Setup";
        "Student No. Filter": Code[20];
        ModeFilter: Code[20];
        ClassFilter: Code[20];
        EScore: Decimal;
        EScore2: Decimal;
        EStudent: Code[20];
        EStudName: Text[100];
        Students: Record Customer;
        ExamPeriod: Record "Exam Periods";
        SelUnit: Code[20];
        ExamResults: Record "Exam Results";
        ExamsSetup: Record "Exams Setup";
        UnitsR: Record "Units/Subjects";
        Lect: Text[100];
        NoStud: Integer;
        LecUnits: Record "Lecturers Units";
        Employee: Record "HR-Employee";
        StaffFilter: Code[20];
        LecPass: Text;
        PassOk: Boolean;
        EScore3: Decimal;
        EStudentBranch: Code[20];

    procedure SetMatrixFilter()
    begin
        CurrPage.Marksheet.Page.Load(ProgrammeFilter, StageFilter, SemesterFilter, UnitFilter, ExamCategory, RegisterFor, "Student No. Filter", BranchFilter, ModeFilter, ClassFilter);
        CurrPage.Update;
    end;

    local procedure SubmitMarks()
    var
        CurrProg: Code[20];
        CurrStage: Code[20];
        CurrRegID: Code[20];
        Creg: Record "Course Registration";
        ExamTypeW: Option Assignment,CAT,"Final Exam",Supplementary,Special;
        MaxScoreW: Decimal;
        ExamContribW: Decimal;
        OriginalUser: Code[50];
        XxScoreW: Decimal;
        xxContribW: Decimal;
        Ln: Integer;
    begin

        if ExamCategory = '' then Error('Please enter the Category');
        // if StageFilter = '' then Error('Please enter the Stage');
        if EScore < 1 then
            Error('Marks Can Not be Less than One');

        //IF CatsEXist=TRUE THEN ERROR('The CAT Marks Already Exists');
        //IF WbaExists=TRUE THEN ERROR('The WBA Marks Already Exists');

        ExamsSetup.Reset;
        ExamsSetup.SetFilter(ExamsSetup.Category, ExamCategory);
        ExamsSetup.SetRange(ExamsSetup.Code, 'EXAM');
        if ExamsSetup.Find('-') then begin
            if EScore > ExamsSetup."Max. Score" then
                Error('You Cant Enter Score Above The Maximum Score. The Maximum Score is ' + Format(ExamsSetup."Max. Score"));
            if ExamsSetup.Type = ExamsSetup.Type::Supplementary then begin
                //IF "Allow Supplementary" = FALSE THEN
                //ERROR('Student not allowed to sit supplementary.');
            end;
        end;

        CurrProg := '';
        CurrRegID := '';
        CurrStage := '';
        Creg.Reset;
        Creg.SetRange(Creg."Student No.", EStudent);
        Creg.SetRange(Creg.Reversed, false);
        Creg.SetFilter(Creg.Semester, SemesterFilter);
        Creg."Register for" := RegisterFor;
        Creg.SetFilter(Creg.Stage, StageFilter);
        if Creg.Find('-') then begin
            CurrProg := Creg.Programme;
            CurrRegID := Creg."Reg. Transacton ID";
            CurrStage := Creg.Stage;
        end;

        if (UnitFilter = '') then Error('Please enter the Unit Filter');
        //IF (GETFILTER("Programme Filter") ='') THEN ERROR('Please enter the Programme Filter');
        if (SemesterFilter = '') then Error('Please enter the Semester Filter');
        /*
        IF (GETFILTER("Exam Type") ='SPECIAL') OR (GETFILTER("Exam Type") ='SUPPLEMENTARY') THEN
        IF GETFILTER("Exam Type")<> 'EXAM' THEN
        ERROR('Please note that CAT is not allowed for SPECIAL and SUPPLEMENTARY Exams ');
        
        IF EScore=0 THEN
        IF CONFIRM('CAT is missing do want proceed?')THEN;
        
        IF EScore2=0 THEN
        IF CONFIRM('WBA is missing do want proceed?') THEN;
        */
        // ExamsSetup.RESET;
        // ExamsSetup.SETRANGE(ExamsSetup.Code,'EXAM');
        // ExamsSetup.SETFILTER(ExamsSetup.Category,ExamCategory);

        SelUnit := UnitFilter;
        ExamResults.Reset;
        ExamResults.SetRange(ExamResults."Student No.", EStudent);
        ExamResults.SetRange(ExamResults.Submitted, false);
        //ExamResults.SETRANGE(ExamResults.Programme,Programme);
        ExamResults.SetRange(ExamResults.Unit, SelUnit);
        ExamResults.SetFilter(ExamResults.ExamType, 'EXAM');

        if ExamsSetup.Find('-') then begin
            ExamTypeW := ExamsSetup.Type;
            MaxScoreW := ExamsSetup."Max. Score";
            ExamContribW := ExamsSetup."% Contrib. Final Score";
        end;
        /*
        ExamsSetup.RESET;
        ExamsSetup.SETFILTER(ExamsSetup.Category,ExamCategory);
        ExamsSetup.SETRANGE(ExamsSetup.Code,'CAT');
        IF ExamsSetup.FIND('-') THEN BEGIN
        ExamTypeC:=ExamsSetup.Type;
        MaxScoreC:=ExamsSetup."Max. Score";
        ExamContribC:=ExamsSetup."% Contrib. Final Score";
        END;
        */
        OriginalUser := UserId;
        ExamResults.Reset;
        //ExamResults.SETRANGE(ExamResults."Reg. Transaction ID","Reg. Transacton ID");
        ExamResults.SetRange(ExamResults."Student No.", EStudent);
        // ExamResults.SetRange(ExamResults.Programme, ProgrammeFilter);
        //  ExamResults.SetRange(ExamResults.Stage, StageFilter);
        ExamResults.SetRange(ExamResults.Unit, UnitFilter);
        ExamResults.SetRange(ExamResults.Submitted, false);
        ExamResults.SetFilter(ExamResults.Semester, SemesterFilter);
        ExamResults.SetFilter(ExamResults.ExamType, 'EXAM');
        if ExamResults.Find('-') then begin
            repeat
                if ExamResults.ExamType = 'EXAM' then begin
                    XxScoreW := ExamResults.Score;
                    xxContribW := ExamResults.Contribution;
                end;
                OriginalUser := ExamResults.UserID;
                ExamResults.Cancelled := true;
                ExamResults."Cancelled By" := UserId;
                ExamResults."Last Edited On" := Today;
                ExamResults.Modify;
            //ExamResults.DELETE;
            until ExamResults.Next = 0;
        end;
        ExamResults.Reset;
        //IF ExamResults.FINDLAST() THEN
        Ln := ExamResults.Count + 1;


        if EScore <> 0 then begin
            Ln := Ln + 1;
            ExamResults.Init;
            ExamResults."Entry No" := Ln;
            ExamResults."Reg. Transaction ID" := CurrRegID;
            ExamResults."Student No." := EStudent;
            ExamResults.Programme := CurrProg;
            ExamResults.Stage := CurrStage;
            ExamResults.Unit := UnitFilter;
            ExamResults.Semester := SemesterFilter;
            ExamResults.Score := EScore;
            ExamResults.Exam := Format(ExamTypeW);
            ExamResults.ExamType := 'EXAM';
            ExamResults.Category := ExamCategory;
            //ExamResults.VALIDATE(ExamResults.Score);
            ExamResults.Contribution := (EScore * ExamContribW) / MaxScoreW;
            ExamResults.UserID := OriginalUser;
            ExamResults."Last Edited By" := UserId;
            ExamResults."Last Edited On" := Today;
            ExamResults."Original Score" := XxScoreW;
            ExamResults."Original Contribution" := xxContribW;
            //ExamResults."Exam Period":=ExamSeriesFilter;
            ExamResults.Submitted := true;
            ExamResults.Validate(Score);
            ExamResults.Insert;
        end;

        EStudent := '';
        EScore := 0;
        EScore2 := 0;
        EScore3 := 0;
        EStudName := '';
        EStudentBranch := '';

    end;
}

