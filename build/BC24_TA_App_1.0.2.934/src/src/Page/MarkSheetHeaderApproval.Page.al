Page 50369 "MarkSheet Header Approval"
{
    PageType = Card;
    SourceTable = "Marksheet Header1";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(CampusFilter; Rec."Campus Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Filter field.';

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(ProgrammeFilter; Rec."Programme Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Filter field.';

                    trigger OnValidate()
                    begin
                        if Prog.Get(Rec.GetFilter("Programme Filter")) then
                            ExamCategory := Prog."Exam Category";

                        //  CurrPage.Marksheet.PAGE.GetExamCaption(ExamCategory);
                        //  CurrPage.UPDATE;

                        SetMatrixFilter;
                    end;
                }
                field(SemesterFilter; Rec."Semester Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester Filter field.';

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(StageFilter; Rec."Stage Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Filter field.';

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(ModeofStudyFilter; Rec."Mode of Study Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mode of Study Filter field.';
                }
                field(UnitFilter; Rec."Unit Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Filter field.';

                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(LecturerNo; Rec."Lecturer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer No field.';
                }
                field(iCounter; Rec.iCounter)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the iCounter field.';
                }
            }
            group(Moderation)
            {
                Caption = 'Moderation';
                field(ModerationFactor; Rec."Moderation Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Moderation Factor field.';
                }
            }
            group(Control9)
            {
                Caption = 'Students';
                part(Control14; "Student Units Marks")
                {
                    SubPageLink = Semester = field("Semester Filter"),
                                  Programme = field("Programme Filter"),
                                  Stage = field("Stage Filter"),
                                  Unit = field("Unit Filter");
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Students)
            {
                ApplicationArea = Basic;
                Image = AllLines;
                RunObject = Page "Student Units Marks";
                RunPageLink = Semester = field("Semester Filter"),
                              Stage = field("Stage Filter"),
                              Programme = field("Programme Filter"),
                              Unit = field("Unit Filter");
                ToolTip = 'Executes the Students action.';
            }
            separator(Action15) { }
            action("Post Moderation")
            {
                ApplicationArea = Basic;
                Image = Apply;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Post Moderation action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to Moderate the selected Marks?', false) then begin
                        if (Rec."Moderation Factor" = 0) or (Rec."Moderation Factor" > 1.5) then Error('Invalid Moderation factor!, Please note that the Moderation factor must be greater than zero and less than 1.5');
                        StudUnits.Reset;
                        StudUnits.SetFilter(StudUnits.Programme, Rec."Programme Filter");
                        StudUnits.SetFilter(StudUnits.Semester, Rec."Semester Filter");
                        StudUnits.SetFilter(StudUnits.Unit, Rec."Unit Filter");
                        //StudUnits.SETFILTER(StudUnits."Term Filter",'%1',"Term Filter");
                        StudUnits.SetFilter(StudUnits.Stage, Rec."Stage Filter");
                        StudUnits.SetFilter(StudUnits."Campus Code", Rec."Campus Filter");
                        if StudUnits.Find('-') then begin
                            repeat
                                StudUnits.CalcFields("Total Score");
                                if (StudUnits."Total Score" * Rec."Moderation Factor") > 99.9 then Error('Invalid Moderation factor!, The selected factor will create invalid marks');
                                StudUnits."Moderation Temp Score" := StudUnits."Total Score" * Rec."Moderation Factor";
                                StudUnits."Final Score" := (StudUnits."Total Score" * Rec."Moderation Factor");
                                StudUnits.Grade := GetGrade((StudUnits."Total Score" * Rec."Moderation Factor"), StudUnits.Programme, StudUnits.Unit);
                                //  StudUnits.GPA:=GetGPA((StudUnits."Total Score"*"Moderation Factor"),StudUnits.Programme,StudUnits.Unit);
                                StudUnits."Moderation Factor" := Rec."Moderation Factor";
                                StudUnits.Moderated := true;
                                StudUnits."Moderation Date" := Today;
                                StudUnits."Moderated By" := UserId;
                                StudUnits.Modify;
                            until StudUnits.Next = 0;
                        end;
                        Rec."Moderated On" := Today;
                        //Mode:=TRUE;
                        Rec."Moderated By" := UserId;
                        Rec.Modify;
                        Message('Moderation Completed Successfully');
                    end;
                end;
            }
            separator(Action20) { }
            action("Approve Selected Marks")
            {
                ApplicationArea = Basic;
                Image = Approval;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approve Selected Marks action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to approve the selected Marks?', false) then begin
                        if (Rec."Moderation Factor" = 0) or (Rec."Moderation Factor" > 1.5) then Error('Invalid Moderation factor!, Please note that the Moderation factor must be greater than zero and less than 1.5');
                        StudUnits.Reset;
                        StudUnits.SetFilter(StudUnits.Programme, Rec."Programme Filter");
                        StudUnits.SetFilter(StudUnits.Semester, Rec."Semester Filter");
                        StudUnits.SetFilter(StudUnits.Unit, Rec."Unit Filter");
                        //StudUnits.SETFILTER(StudUnits."Term Filter",'%1',"Term Filter");
                        StudUnits.SetFilter(StudUnits.Stage, Rec."Stage Filter");
                        StudUnits.SetFilter(StudUnits."Campus Code", Rec."Campus Filter");
                        if StudUnits.Find('-') then begin
                            repeat
                                StudUnits.CalcFields("Total Score");
                                StudUnits.CalcFields("Total Score");
                                StudUnits.CalcFields("CAT Total Marks");
                                StudUnits.CalcFields("Exam Marks");
                                if (StudUnits."Total Score" * Rec."Moderation Factor") > 99.9 then Error('Invalid Moderation factor!, The selected factor will create invalid marks');
                                StudUnits."Moderation Temp Score" := ROUND(StudUnits."Total Score" * Rec."Moderation Factor", 1, '=');
                                StudUnits."Final Score" := ROUND((StudUnits."Total Score" * Rec."Moderation Factor"), 1, '=');
                                StudUnits.Grade := GetGrade(ROUND((StudUnits."Total Score" * Rec."Moderation Factor"), 1, '='), StudUnits.Programme, StudUnits.Unit);
                                //StudUnits.GPA:=GetGPA(ROUND((StudUnits."Total Score"*"Moderation Factor"),1,'='),StudUnits.Programme,StudUnits.Unit);
                                StudUnits."Result Status" := GetGradeDesc(ROUND((StudUnits."Total Score" * Rec."Moderation Factor"), 1, '='), StudUnits.Programme, StudUnits.Unit);
                                StudUnits.Failed := GetGradeStatus1(ROUND((StudUnits."Total Score" * Rec."Moderation Factor"), 1, '='), StudUnits.Programme, StudUnits.Unit);
                                if (StudUnits."CAT Total Marks" = 0) or (StudUnits."Exam Marks" = 0) then begin
                                    StudUnits."Result Status" := 'INCOMPLETE';
                                    StudUnits.Grade := 'I';
                                end;
                                // StudUnits."Moderation Factor":="Moderation Factor";
                                StudUnits.Released := true;
                                StudUnits.Moderated := true;
                                StudUnits."Moderation Date" := Today;
                                StudUnits."Moderated By" := UserId;
                                StudUnits.Modify;
                            until StudUnits.Next = 0;
                        end;
                        Rec."Approval Date" := Today;
                        Rec.Approved := true;
                        Rec."Approved By" := UserId;
                        Rec.Modify;
                        Message('Approval Completed Successfully');
                    end;
                end;
            }
            separator(Action19) { }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Moderation Factor" = 0 then Rec."Moderation Factor" := 1;
    end;

    trigger OnOpenPage()
    begin
        //  SetMatrixFilter;
        if UserSetup.Get(UserId) then begin
            if UserSetup."Can Edit Marks" = false then Error('Please note that this window is only for Authorised users');
        end else begin
            Error('Please note that this window is only for Authorised users');
        end;
        // SETFILTER(Code,USERID);
    end;

    var
        ExamCategory: Code[20];
        Prog: Record Programme;
        UserSetup: Record "User Setup";
        StudUnits: Record "Student Units";

    procedure SetMatrixFilter()
    begin
        //   CurrPage.Marksheet.PAGE.Load(GETFILTER("Programme Filter"),GETFILTER("Stage Filter"),GETFILTER("Semester Filter"),GETFILTER("Unit Filter"),'ExamCategory',0,GETFILTER("Student Filter"),GETFILTER("Campus Filter"),'ModeFilter');
        //  CurrPage.UPDATE;
    end;

    procedure GetGrade(Marks: Decimal; Prog: Code[20]; Unit: Code[20]) xGrade: Text[100]
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
                            //xGPA:=Gradings."GPA Points";
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

    procedure GetGradeStatus(Marks: Decimal; Prog: Code[20]; Unit: Code[20]) xStatus: Boolean
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
        xStatus := false;
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
                            xStatus := Gradings.Failed;
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

    procedure GetGradeDesc(Marks: Decimal; Prog: Code[20]; Unit: Code[20]) xGrade: Text[100]
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
                            xGrade := Gradings.Description;
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

    procedure GetGradeStatus1(Marks: Decimal; Prog: Code[20]; Unit: Code[20]) xGrade: Boolean
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
        xGrade := false;
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
                            xGrade := Gradings.Failed;
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
}

