Page 50383 MarkSheetHeader
{
    PageType = Document;
    SourceTable = "Marksheet Header1";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
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
                        if Prog.Get(Rec."Programme Filter") then
                            ExamCategory := Prog."Exam Category";

                        CurrPage.Marksheet.Page.GetExamCaption(ExamCategory);
                        CurrPage.Update;

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
                field("Class Filter"; Rec."Class Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Filter field.';
                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field("Student Filter"; Rec."Student Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Filter field.';
                    trigger OnValidate()
                    begin
                        SetMatrixFilter;
                    end;
                }
                field(ExamCategory; ExamCategory)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the ExamCategory field.';
                }
            }

            part(Marksheet; "Marksheet Lines")
            {
                ApplicationArea = all;
                SubPageLink = Semester = field("Semester Filter"), Unit = field("Unit Filter");
                //  Programme = field("Programme Filter"),
                //  Stage = field("Stage Filter"),
                //  "Unit Class Code" = field("Class Filter"),

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
            action("Verify Selected Marks")
            {
                ApplicationArea = Basic;
                Image = Approval;
                ToolTip = 'Executes the Verify Selected Marks action.';

                trigger OnAction()
                begin
                    FinalMarks := 0;
                    Rec.iCounter := 0;
                    if Confirm('Do you really want to Verify the selected Marks?', false) then begin
                        StudUnits.Reset;
                        StudUnits.SetFilter(StudUnits.Programme, Rec."Programme Filter");
                        StudUnits.SetFilter(StudUnits.Semester, Rec."Semester Filter");
                        StudUnits.SetFilter(StudUnits.Unit, Rec."Unit Filter");
                        //StudUnits.SETFILTER(StudUnits."Term Filter",'%1',"Term Filter");
                        StudUnits.SetFilter(StudUnits.Stage, Rec."Stage Filter");
                        StudUnits.SetFilter(StudUnits."Campus Code", Rec."Campus Filter");
                        if StudUnits.Find('-') then begin
                            repeat
                                StudUnits.CalcFields("CAT-1");
                                StudUnits.CalcFields("CAT-2");
                                StudUnits.CalcFields("CAT Total Marks");
                                StudUnits.CalcFields("Exam Marks");


                                FinalMarks := FinalMarks + StudUnits."Final Score";
                            /*
                            IF StudUnits."Final Score">0 THEN
                            BEGIN
                            iCounter:=iCounter+1;
                            StudUnits."Verification Count" := iCounter;
                            END;
                            */
                            until StudUnits.Next = 0;
                        end;

                        //IF FlMainarks=0 THEN ERROR('Please check the marks before verifying');



                        Rec."Verified Date" := Today;
                        Rec.Verified := true;
                        Rec."Verified By" := UserId;
                        Rec.Modify;
                        Message('Verification Completed Successfully');
                        CurrPage.Close;
                    end;

                end;
            }
            separator(Action6) { }
            action(Refresh)
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Refresh action.';

                trigger OnAction()
                begin
                    SetMatrixFilter;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetMatrixFilter;
    end;

    trigger OnOpenPage()
    begin


        if UserSetup.Get(UserId) then begin
            if UserSetup."Can Edit Marks" = false then Error('Please note that this window is only for Authorised users');
        end else begin
            Error('Please note that this window is only for Authorised users');
        end;
        // SETFILTER(Code,USERID);
        SetMatrixFilter;
    end;

    var
        FinalMarks: Decimal;
        ExamCategory: Code[20];
        Prog: Record Programme;
        UserSetup: Record "User Setup";
        StudUnits: Record "Student Units";

    procedure SetMatrixFilter()
    begin
        CurrPage.Marksheet.Page.Load(Rec."Programme Filter", Rec."Stage Filter", Rec."Semester Filter", Rec."Unit Filter", ExamCategory, 0, Rec.GetFilter("Student Filter"), Rec."Campus Filter", 'ModeFilter', Rec."Class Filter");
        CurrPage.Update;
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

