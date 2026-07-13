Page 50393 "Marks Moderations"
{
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
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

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(SemesterFilter; SemesterFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    TableRelation = Semesters.Code;
                    ToolTip = 'Specifies the value of the Semester Filter field.';

                    trigger OnValidate()
                    begin
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
                field(CampusFilter; CampusFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Campus Filter';
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

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
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
                    TableRelation = Customer;
                    ToolTip = 'Specifies the value of the Student No. Filter field.';

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
            }
            group(Moderation)
            {
                Caption = 'Moderation';
                field(TotalStudent; TotalStudent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Students';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Students field.';
                }
                field(AverageScore; AverageScore)
                {
                    ApplicationArea = Basic;
                    Caption = 'Average Score';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Average Score field.';
                }
                field(ModerationFactor; "Moderation Factor")
                {
                    ApplicationArea = Basic;
                    Caption = 'Moderation Factor';
                    ToolTip = 'Specifies the value of the Moderation Factor field.';
                }
                field(ModAverage; ModAverage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Moderated Average';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Moderated Average field.';
                }
            }
            part(Marksheet; "Marksheet Lines") { }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test Moderation")
            {
                ApplicationArea = Basic;
                Image = TestFile;
                ToolTip = 'Executes the Test Moderation action.';

                trigger OnAction()
                begin
                    StudUnits.Reset;
                    StudUnits.SetFilter(StudUnits.Programme, ProgrammeFilter);
                    StudUnits.SetFilter(StudUnits.Semester, SemesterFilter);
                    StudUnits.SetFilter(StudUnits.Unit, UnitFilter);
                    StudUnits.SetFilter(StudUnits."Campus Code", CampusFilter);
                    StudUnits.SetFilter(StudUnits."Mode of Study", ModeFilter);
                    if StudUnits.Find('-') then begin
                        repeat
                            StudUnits."Moderation Temp Score" := StudUnits."Final Score" + "Moderation Factor";
                            StudUnits.Modify;
                        until StudUnits.Next = 0;
                    end;
                    Message('Moderations Completed Successfully');
                end;
            }
            separator(Action15) { }
            action("Post Moderation")
            {
                ApplicationArea = Basic;
                Image = Post;
                ToolTip = 'Executes the Post Moderation action.';

                trigger OnAction()
                begin
                    StudUnits.Reset;
                    StudUnits.SetFilter(StudUnits.Programme, ProgrammeFilter);
                    StudUnits.SetFilter(StudUnits.Semester, SemesterFilter);
                    StudUnits.SetFilter(StudUnits.Unit, UnitFilter);
                    StudUnits.SetFilter(StudUnits."Campus Code", CampusFilter);
                    StudUnits.SetFilter(StudUnits."Mode of Study", ModeFilter);
                    StudUnits.SetFilter(StudUnits."Student No.", "Student No. Filter");
                    if StudUnits.Find('-') then begin
                        repeat
                            StudUnits.CalcFields("Total Score");
                            StudUnits.CalcFields(StudUnits."CAT Total Marks");
                            StudUnits.CalcFields(StudUnits."Exam Marks");
                            StudUnits.CalcFields(StudUnits."Unit Re-Taken Count");
                            if (StudUnits."Total Score" + "Moderation Factor" > 100) then Error('The Moderated score will be over 100 for student ' + StudUnits."Student No.");
                            if (StudUnits."Exam Marks" > 0) then begin
                                if (ExamCategory = '0100') then begin
                                    if StudUnits."Total Score" > 0 then
                                        StudUnits."Final Score" := StudUnits."Total Score";
                                    StudUnits."Moderation Temp Score" := StudUnits."Final Score" + "Moderation Factor";
                                    StudUnits."Final Score" := StudUnits."Final Score" + "Moderation Factor";
                                    // Adjust to 40 if 39
                                    if (StudUnits."Final Score" > 38.99) and (StudUnits."Final Score" < 39.99) then begin
                                        StudUnits."Final Score" := 40;
                                        StudUnits."Pastoral Moderated" := true;
                                    end;
                                    if (StudUnits."Re-Taken" = false) and (StudUnits."Unit Re-Taken Count" > 0) then StudUnits."Grade Prefix" := '(R)';
                                    if StudUnits.Audit = true then StudUnits."Grade Prefix" := '(N)';
                                    StudUnits.Grade := GetGrade((StudUnits."Final Score" + "Moderation Factor"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits.GPA := GetGPA((StudUnits."Final Score" + "Moderation Factor"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits.Failed := GetGradeStatus((StudUnits."Final Score" + "Moderation Factor"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits."CF Score" := StudUnits."Final Score" * StudUnits."No. Of Units";
                                    StudUnits."CF GPA" := StudUnits.GPA * StudUnits."No. Of Units";
                                    StudUnits."Moderation Factor" := "Moderation Factor";
                                    StudUnits.Moderated := true;
                                    StudUnits."Moderation Date" := Today;
                                    StudUnits."Moderated By" := UserId;
                                    StudUnits.Modify;
                                end;
                                if (StudUnits."CAT Total Marks" > 0) and (ExamCategory <> '0100') then begin
                                    if StudUnits."Total Score" > 0 then
                                        StudUnits."Final Score" := StudUnits."Total Score";
                                    StudUnits."Moderation Temp Score" := StudUnits."Final Score" + "Moderation Factor";
                                    StudUnits."Final Score" := StudUnits."Final Score" + "Moderation Factor";
                                    if (StudUnits."Final Score" > 38.99) and (StudUnits."Final Score" < 39.99) then begin
                                        StudUnits."Final Score" := 40;
                                        StudUnits."Pastoral Moderated" := true;
                                    end;
                                    if (StudUnits."Re-Taken" = false) and (StudUnits."Unit Re-Taken Count" > 0) then StudUnits."Grade Prefix" := '(R)';
                                    if StudUnits.Audit = true then StudUnits."Grade Prefix" := '(N)';
                                    StudUnits.Grade := GetGrade((StudUnits."Final Score" + "Moderation Factor"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits.GPA := GetGPA((StudUnits."Final Score" + "Moderation Factor"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits.Failed := GetGradeStatus((StudUnits."Final Score" + "Moderation Factor"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits."CF Score" := StudUnits."Final Score" * StudUnits."No. Of Units";
                                    StudUnits."CF GPA" := StudUnits.GPA * StudUnits."No. Of Units";
                                    StudUnits."Moderation Factor" := "Moderation Factor";
                                    StudUnits."Moderation Factor" := "Moderation Factor";
                                    StudUnits.Moderated := true;
                                    StudUnits."Moderation Date" := Today;
                                    StudUnits."Moderated By" := UserId;
                                    StudUnits.Modify;
                                end;
                            end;
                        until StudUnits.Next = 0;
                    end;
                    Message('Moderations Completed Successfully');
                end;
            }
            separator(Action17) { }
            separator(Action18) { }
            action("Refresh Average")
            {
                ApplicationArea = Basic;
                Image = Refresh;
                ToolTip = 'Executes the Refresh Average action.';

                trigger OnAction()
                begin

                    TotalStudent := 0;
                    TotalMarks := 0;
                    TotalModMarks := 0;
                    StudUnits.Reset;
                    //StudUnits.SETFILTER(StudUnits.Programme,ProgrammeFilter);
                    StudUnits.SetFilter(StudUnits.Semester, SemesterFilter);
                    StudUnits.SetFilter(StudUnits.Unit, UnitFilter);
                    StudUnits.SetFilter(StudUnits."Campus Code", CampusFilter);
                    StudUnits.SetFilter(StudUnits."Mode of Study", ModeFilter);
                    if StudUnits.Find('-') then begin
                        StudUnits.CalcFields(StudUnits."Moderation Unit Total Marks");
                        repeat
                            StudUnits.CalcFields(StudUnits."Total Score");
                            StudUnits.CalcFields(StudUnits."CAT Total Marks");
                            StudUnits.CalcFields(StudUnits."Exam Marks");
                            /*
                            StudUnits.CALCFIELDS("Unit Student Count");
                            StudUnits.CALCFIELDS(StudUnits."Unit Total Marks");
                            StudUnits.CALCFIELDS(StudUnits."Moderation Unit Total Marks");
                            */
                            if (ExamCategory = '0100') and (StudUnits."Exam Marks" > 0) then begin
                                TotalStudent := TotalStudent + 1;
                                TotalMarks := TotalMarks + StudUnits."Total Score";
                                TotalModMarks := TotalModMarks + StudUnits."Moderation Temp Score";
                            end;
                            if (ExamCategory <> '0100') and (StudUnits."CAT Total Marks" > 0) and (StudUnits."Exam Marks" > 0) then begin
                                TotalStudent := TotalStudent + 1;
                                TotalMarks := TotalMarks + StudUnits."Total Score";
                                TotalModMarks := TotalModMarks + StudUnits."Moderation Temp Score";
                            end;

                        until StudUnits.Next = 0;
                        if (TotalMarks > 0) and (TotalStudent > 0) then
                            AverageScore := TotalMarks / TotalStudent;
                        if (StudUnits."Moderation Unit Total Marks" > 0) and (TotalStudent > 0) then
                            ModAverage := TotalModMarks / TotalStudent;
                    end;
                    ModAverage := AverageScore + "Moderation Factor";

                end;
            }
            separator(Action24) { }
            action("Reverse Moderation")
            {
                ApplicationArea = Basic;
                Image = ReopenCancelled;
                ToolTip = 'Executes the Reverse Moderation action.';

                trigger OnAction()
                begin
                    StudUnits.Reset;
                    StudUnits.SetFilter(StudUnits.Programme, ProgrammeFilter);
                    StudUnits.SetFilter(StudUnits.Semester, SemesterFilter);
                    StudUnits.SetFilter(StudUnits.Unit, UnitFilter);
                    StudUnits.SetFilter(StudUnits."Campus Code", CampusFilter);
                    StudUnits.SetFilter(StudUnits."Mode of Study", ModeFilter);
                    if StudUnits.Find('-') then begin
                        repeat
                            StudUnits.CalcFields("Total Score");
                            StudUnits.CalcFields(StudUnits."CAT Total Marks");
                            StudUnits.CalcFields(StudUnits."Exam Marks");

                            if (StudUnits."Exam Marks" > 0) then begin
                                if (ExamCategory = '0100') then begin
                                    if StudUnits."Total Score" > 0 then
                                        StudUnits."Final Score" := StudUnits."Total Score";
                                    StudUnits.Grade := GetGrade((StudUnits."Final Score"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits.GPA := GetGPA((StudUnits."Final Score"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits."Moderation Factor" := "Moderation Factor";
                                    StudUnits.Moderated := true;
                                    StudUnits."Moderation Date" := Today;
                                    StudUnits."Moderated By" := UserId;
                                    StudUnits.Modify;
                                end;
                                if (StudUnits."CAT Total Marks" > 0) and (ExamCategory <> '0100') then begin
                                    if StudUnits."Total Score" > 0 then
                                        StudUnits."Final Score" := StudUnits."Total Score";
                                    StudUnits.Grade := GetGrade((StudUnits."Final Score"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits.GPA := GetGPA((StudUnits."Final Score"), StudUnits.Programme, StudUnits.Unit);
                                    StudUnits."Moderation Factor" := "Moderation Factor";
                                    StudUnits.Moderated := true;
                                    StudUnits."Moderation Date" := Today;
                                    StudUnits."Moderated By" := UserId;
                                    StudUnits.Modify;
                                end;
                            end;
                        until StudUnits.Next = 0;
                    end;
                    Message('Moderations Reversed Successfully');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        SetMatrixFilter;
        if UserSetup.Get(UserId) then begin
            if UserSetup."Can Edit Marks" = false then Error('Please note that this window is only active for lecturers');
        end else begin
            Error('Please note that this window is only active for lecturers');
        end;
    end;

    var
        ProgrammeFilter: Code[50];
        StageFilter: Code[50];
        SemesterFilter: Code[50];
        UnitFilter: Code[50];
        StudUnits: Record "Student Units";
        ExamCategory: Code[50];
        Prog: Record Programme;
        RegisterFor: Option Stage,"Unit/Subject",Supplementary;
        UserSetup: Record "User Setup";
        "Student No. Filter": Code[50];
        "Moderation Factor": Decimal;
        TotalStudent: Integer;
        AverageScore: Decimal;
        ModAverage: Decimal;
        CampusFilter: Code[50];
        ModeFilter: Code[50];
        ClassFilter: Code[50];
        TotalMarks: Decimal;
        TotalModMarks: Decimal;

    procedure SetMatrixFilter()
    begin
        CurrPage.Marksheet.Page.Load(ProgrammeFilter, StageFilter, SemesterFilter, UnitFilter, ExamCategory, RegisterFor, "Student No. Filter", CampusFilter, ModeFilter, ClassFilter);
        CurrPage.Update;
    end;

    procedure GetGrade(Marks: Decimal; Prog: Code[50]; Unit: Code[20]) xGrade: Text[100]
    var
        ExamRemark: Text[50];
        RecUnits: Record "Units/Subjects";
        UnitDesc: Text[200];
        Grade: Code[20];
        LastGrade: Code[50];
        LastRemark: Code[50];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        GradeCategory: Code[50];
        PassRemark: Text[200];
        ProgrammeRec: Record Programme;
        "Units/Subj": Record "Units/Subjects";
    begin
        GradeCategory := '';
        "Units/Subj".Reset;
        "Units/Subj".SetRange("Units/Subj"."Programme Code", Prog);
        "Units/Subj".SetRange("Units/Subj".Code, Unit);
        if "Units/Subj".Find('-') then
            GradeCategory := "Units/Subj"."Default Exam Category";

        if GradeCategory = '' then begin
            ProgrammeRec.Reset;
            if ProgrammeRec.Get(Prog) then
                GradeCategory := ProgrammeRec."Exam Category";
        end;

        if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
        ExamRemark := '';
        PassRemark := '';
        xGrade := '';
        RecUnits.Reset;
        RecUnits.SetFilter(RecUnits.Code, Unit);
        if RecUnits.Find('-') then UnitDesc := RecUnits.Desription;
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
                            PassRemark := Gradings.Remarks;
                            ExamRemark := Gradings.Description;
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

    procedure GetGPA(Marks: Decimal; Prog: Code[20]; Unit: Code[20]) xGPA: Decimal
    var
        ExamRemark: Text[50];
        RecUnits: Record "Units/Subjects";
        UnitDesc: Text[200];
        Grade: Code[20];
        LastGrade: Code[50];
        LastRemark: Code[50];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        GradeCategory: Code[50];
        PassRemark: Text[200];
    begin
        GradeCategory := 'GPA';
        /*
        "Units/Subj".RESET;
        "Units/Subj".SETRANGE("Units/Subj"."Programme Code",Prog);
        "Units/Subj".SETRANGE("Units/Subj".Code,Unit);
        IF "Units/Subj".FIND('-') THEN
        GradeCategory:="Units/Subj"."Default Exam Category";
        
        IF GradeCategory='' THEN BEGIN
        ProgrammeRec.RESET;
        IF ProgrammeRec.GET(Prog) THEN
        GradeCategory:=ProgrammeRec."Exam Category";
        END;
        
        IF GradeCategory='' THEN ERROR('Please note that you must specify Exam Category in Programme Setup');
        */
        ExamRemark := '';
        PassRemark := '';
        xGPA := 0;
        RecUnits.Reset;
        RecUnits.SetFilter(RecUnits.Code, Unit);
        if RecUnits.Find('-') then UnitDesc := RecUnits.Desription;
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
                            xGPA := Gradings."GPA Points";
                            PassRemark := Gradings.Remarks;
                            ExamRemark := Gradings.Description;
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

    procedure GetGradeStatus(Marks: Decimal; Prog: Code[50]; Unit: Code[20]) xFail: Boolean
    var
        ExamRemark: Text[50];
        RecUnits: Record "Units/Subjects";
        UnitDesc: Text[200];
        LastGrade: Code[50];
        LastRemark: Code[50];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        GradeCategory: Code[50];
        PassRemark: Text[200];
        ProgrammeRec: Record Programme;
        "Units/Subj": Record "Units/Subjects";
    begin
        GradeCategory := '';
        "Units/Subj".Reset;
        "Units/Subj".SetRange("Units/Subj"."Programme Code", Prog);
        "Units/Subj".SetRange("Units/Subj".Code, Unit);
        if "Units/Subj".Find('-') then
            GradeCategory := "Units/Subj"."Default Exam Category";

        if GradeCategory = '' then begin
            ProgrammeRec.Reset;
            if ProgrammeRec.Get(Prog) then
                GradeCategory := ProgrammeRec."Exam Category";
        end;

        if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
        ExamRemark := '';
        PassRemark := '';
        xFail := false;
        RecUnits.Reset;
        RecUnits.SetFilter(RecUnits.Code, Unit);
        if RecUnits.Find('-') then UnitDesc := RecUnits.Desription;
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
                            xFail := Gradings.Failed;
                            PassRemark := Gradings.Remarks;
                            ExamRemark := Gradings.Description;
                            ExitDo := true;
                        end;
                    end;

                until Gradings.Next = 0;


            end;

        end else begin

            //Remarks:='Not Done';
        end;
    end;
}

