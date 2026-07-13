Page 50185 "Online Results Release"
{
    PageType = Card;
    SourceTable = "Online Results Release";
    SourceTableView = where(Posted = const(false));
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
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(AcademicYear; Rec."Academic Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(ProgrammeCode; Rec."Programme Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Code field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(ProgrammeOption; Rec."Programme Option")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Option field.';
                }
                field(UnitCode; Rec."Unit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Code field.';
                }
                field(StudentNo; Rec."Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No field.';
                }
                field("Include Units Without Marks"; Rec."Include Units Without Marks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Include Units Without Marks field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("ProcessMarks")
            {
                ApplicationArea = Basic;
                Image = ReleaseShipment;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Process Marks';
                ToolTip = 'Executes the Process Marks action.';
                trigger OnAction()
                var
                    UserRec: record "User Setup";
                begin
                    UserRec.get(Database.UserId);
                    // UserRec.TestField("Can Release Results", true);

                    if Confirm('Do you really want to process the results?', false) = false then Error('Aborted by User');

                    Ln := ExamBLog.Count;
                    StudUnit.Reset;
                    StudUnit.SetRange(StudUnit.Released, false);
                    if Rec.Semester <> '' then
                        StudUnit.SETRANGE(StudUnit.Semester, Rec.Semester);
                    if Rec."Programme Code" <> '' then
                        StudUnit.SETRANGE(StudUnit.Programme, Rec."Programme Code");
                    if Rec.Stage <> '' then
                        StudUnit.SETRANGE(StudUnit.Stage, Rec.Stage);
                    if Rec."Programme Option" <> '' then
                        StudUnit.SETFILTER("Reg Option", Rec."Programme Option");
                    if Rec."Student No" <> '' then
                        StudUnit.SETFILTER("Student No.", Rec."Student No");
                    if Rec."Include Units Without Marks" = false then
                        StudUnit.SetFilter(StudUnit."Total Score", '>%1', 0);
                    if StudUnit.Find('-') then begin
                        repeat
                            StudUnit.CalcFields("CF Lk");
                            StudUnit.CalcFields(StudUnit."Unit Description");
                            StudUnit.CalcFields(StudUnit."Stage Unit LK");
                            StudUnit.CalcFields(StudUnit."Total Score");
                            ProcM.UpdateStudentUnits(StudUnit."Student No.", StudUnit.Programme, StudUnit.Semester, StudUnit.Stage, StudUnit.Unit);
                        until StudUnit.next = 0;
                        message('Completed Successfully');
                    end;
                end;
            }
            action("Release Online Results ")
            {
                ApplicationArea = Basic;
                Image = ReleaseShipment;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Release Online Results  action.';
                trigger OnAction()
                var
                    UserRec: record "User Setup";
                begin
                    UserRec.get(Database.UserId);
                    // UserRec.TestField("Can Release Results", true);
                    Rec.TestField(Semester);
                    /*
                     TESTFIELD(Semester);
                     TESTFIELD("Academic Year");
                     SemRec.GET(Semester);
                     SemRec.TESTFIELD(SemRec."Allow Online Results",TRUE);
                     */
                    if Confirm('Do you really want to upload the online results?', false) = false then Error('Aborted by User');

                    Ln := ExamBLog.Count;
                    StudUnit.Reset;
                    StudUnit.SetRange(StudUnit.Released, false);
                    if Rec.Semester <> '' then
                        StudUnit.SETRANGE(StudUnit.Semester, Rec.Semester);
                    if Rec."Programme Code" <> '' then
                        StudUnit.SETRANGE(StudUnit.Programme, Rec."Programme Code");
                    if Rec.Stage <> '' then
                        StudUnit.SETRANGE(StudUnit.Stage, Rec.Stage);
                    if Rec."Programme Option" <> '' then
                        StudUnit.SETFILTER("Reg Option", Rec."Programme Option");
                    if Rec."Student No" <> '' then
                        StudUnit.SETFILTER("Student No.", Rec."Student No");
                    if Rec."Include Units Without Marks" = false then
                        StudUnit.SetFilter(StudUnit."Total Score", '>%1', 0);

                    // StudUnit.SETFILTER(StudUnit.Grade,'<>%1','');
                    if StudUnit.Find('-') then begin
                        repeat
                            StudUnit.CalcFields("CF Lk");
                            StudUnit.CalcFields(StudUnit."Unit Description");
                            StudUnit.CalcFields(StudUnit."Stage Unit LK");
                            StudUnit.CalcFields(StudUnit."Total Score");

                            //   ProcM.UpdateStudentUnits(StudUnit."Student No.", StudUnit.Programme, StudUnit.Semester, StudUnit.Stage, StudUnit.Unit);

                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", StudUnit."Student No.");
                            CReg.SetRange(CReg.Semester, StudUnit.Semester);
                            // CReg.SETFILTER(CReg."Settlement Type",'%1|%2|%3|%4|%5','SSP','KUCCPS','ONLINE');  //TRS
                            CReg.SetFilter(CReg.Programme, StudUnit.Programme);
                            CReg.SetFilter(CReg."Campus Code", Rec."Campus Code");
                            //CReg.SETRANGE(CReg.Reversed,FALSE);
                            if CReg.Find('-') then begin

                                ExamBLog.Reset;
                                ExamBLog.SetRange(ExamBLog."Reg No", CReg."Student No.");
                                ExamBLog.SetRange(ExamBLog."Unit Code", StudUnit.Unit);
                                ExamBLog.SetFilter(ExamBLog.Grade, '%1|%2|%3|%4', 'A', 'B', 'C', 'D');
                                if not ExamBLog.Find('-') then begin     // Prevent update for existing marks if not Incomplete and not failed

                                    ExamBLog3.Reset;
                                    ExamBLog3.SetRange(ExamBLog3."Reg No", CReg."Student No.");
                                    ExamBLog3.SetRange(ExamBLog3."Unit Code", StudUnit.Unit);
                                    if ExamBLog3.Find('-') then begin //Update if Existing
                                        ExamBLog3.Grade := StudUnit.Grade;
                                        ExamBLog3.Description := StudUnit."Unit Description";
                                        ExamBLog3.CF := StudUnit."No. Of Units";
                                        if Prog.Get(ProgStage."Programme Code") then
                                            Prog.CalcFields("Dept Name");
                                        ExamBLog3.Department := Prog."Dept Name";
                                        ExamBLog3.Remark := UpperCase(CopyStr(ProgStage.Remarks, 6, 100) + ' OF STUDY');
                                        ExamBLog3.Group := StudUnit."Academic Year";
                                        ExamBLog3.Programme := CReg.Programme;
                                        ExamBLog3."Unit Score" := StudUnit."Total Score";
                                        ExamBLog3.Semester := StudUnit.Semester;
                                        ExamBLog3."CF Score" := StudUnit."Total Score" * StudUnit."No. Of Units";
                                        ExamBLog3.Modify;

                                    end else begin

                                        CumAv := 0;
                                        ExamBLog.Reset;
                                        ExamBLog.SetRange(ExamBLog."Reg No", CReg."Student No.");
                                        if ExamBLog.Find('+') then
                                            CumAv := ExamBLog."Cum AVerage";

                                        ProgStage.Reset;
                                        ProgStage.SetRange(ProgStage."Programme Code", CReg.Programme);
                                        ProgStage.SetRange(ProgStage.Code, CReg.Stage);
                                        if ProgStage.Find('-') then begin
                                            Ln := Ln + 1;
                                            ExamBLog.Init;
                                            ExamBLog."Reg No" := StudUnit."Student No.";
                                            ExamBLog."Unit Code" := StudUnit.Unit;
                                            ExamBLog."Ac Year" := CopyStr(StudUnit."Stage Unit LK", 2, 1);
                                            // ExamBLog."Ac Year":=StudUnit."Unit Stage";

                                            ExamBLog.Entry := Ln;
                                            ExamBLog.Grade := StudUnit.Grade;
                                            ExamBLog.Description := StudUnit."Unit Description";
                                            ExamBLog.CF := StudUnit."No. Of Units";
                                            //  ExamBLog."Year Score":=CReg."Cumm Score";
                                            if Prog.Get(ProgStage."Programme Code") then
                                                Prog.CalcFields("Dept Name");
                                            ExamBLog.Department := Prog."Dept Name";
                                            // ExamBLog."Cum AVerage":=(CReg."Cumm Score"+CumAv)/2;
                                            ExamBLog.Remark := UpperCase(CopyStr(ProgStage.Remarks, 6, 100) + ' OF STUDY');
                                            ExamBLog.Group := StudUnit."Academic Year";
                                            ExamBLog.Programme := CReg.Programme;
                                            ExamBLog."Unit Score" := StudUnit."Final Score";
                                            ExamBLog.Semester := StudUnit.Semester;
                                            ExamBLog."CF Score" := StudUnit."Final Score" * StudUnit."CF Lk";
                                            ExamBLog."Academic Year" := StudUnit."Academic Year";
                                            ExamBLog.Insert;
                                        end;
                                    end;
                                end;
                            end;
                            StudUnit."Release Code" := Rec.Code;
                            StudUnit.Released := true;

                            StudUnit.Modify;
                        until StudUnit.Next = 0;
                    end;
                    // Update Year and Cummulative Scores
                    ExamBLog.Reset;
                    // ExamBLog.SETRANGE(ExamBLog.Semester,'SEM3 2015');
                    if ExamBLog.Find('-') then begin
                        repeat
                            ExamBLog."CF Score" := ExamBLog."Unit Score" * ExamBLog.CF;
                            ExamBLog.Modify;
                        until ExamBLog.Next = 0;
                    end;

                    ExamBLog.Reset;
                    ExamBLog.SetRange(ExamBLog.Semester, StudUnit.Semester);
                    ExamBLog.SetCurrentkey(ExamBLog."Ac Year");
                    if ExamBLog.Find('-') then begin
                        repeat
                            ExamBLog.SetFilter(ExamBLog."Cumm Ac Year Filter", '%1..%2', '0', ExamBLog."Ac Year");
                            ExamBLog.CalcFields("Total CF");
                            ExamBLog.CalcFields("Total CF Score");
                            ExamBLog.CalcFields("Sem Total CF");
                            ExamBLog.CalcFields("Sem Total CF Score");
                            ExamBLog.CalcFields(ExamBLog."Unit Count");
                            ExamBLog.CalcFields(ExamBLog."Results Count");
                            ExamBLog.CalcFields(ExamBLog."Student Unit Count");
                            if (ExamBLog."Sem Total CF Score" <> 0) and (ExamBLog."Sem Total CF" <> 0) then
                                ExamBLog."Year Score" := ExamBLog."Sem Total CF Score" / ExamBLog."Sem Total CF";
                            if (ExamBLog."Total CF Score" <> 0) and (ExamBLog."Total CF" <> 0) then
                                ExamBLog."Cum AVerage" := ExamBLog."Total CF Score" / ExamBLog."Total CF";
                            if (ExamBLog."Unit Count" > 1) and ((ExamBLog.Grade = 'I') or (ExamBLog.Grade = 'F')) then   // Update the old unit to retaken for Incomplete and Failed
                                ExamBLog.Retaken := true;
                            // IF (ExamBLog."Results Count"=4) AND ((ExamBLog.Grade<>'I') AND (ExamBLog.Grade<>'F'))  THEN   // Update the gradet with  *  if retake
                            if (ExamBLog."Results Count" = 4) then
                                ExamBLog."Grade Prefix" := '*';

                            ExamBLog.Modify;
                        until ExamBLog.Next = 0;
                    end;
                    Rec.Posted := true;
                    Rec.UserID := Database.UserId;
                    Rec.Date := today;
                    Rec."Release Type" := Rec."release type"::Normal;
                    Rec.Modify;

                    Message('Process completed successfully');

                end;
            }
            separator(Action9) { }
            action("Release Online Results - School Based")
            {
                ApplicationArea = Basic;
                Caption = 'Release Online Results - School Based';
                Image = ReleaseShipment;
                Visible = false;
                ToolTip = 'Executes the Release Online Results - School Based action.';

                trigger OnAction()
                begin
                    /*
                    TESTFIELD(Semester);
                    TESTFIELD("Academic Year");
                    SemRec.GET(Semester);
                    SemRec.TESTFIELD(SemRec."Allow Online Results",TRUE);


                    IF CONFIRM('Do you really want upload the online results?',FALSE)=FALSE THEN ERROR('Aborted by User');
                    {
                     ExamBLog.RESET;
                    ExamBLog.SETRANGE(ExamBLog.Semester,Semester);
                    ExamBLog.SETFILTER(ExamBLog.Grade,'<>%1','CT');
                    IF ExamBLog.FIND('-') THEN BEGIN
                    REPEAT
                    ExamBLog.DELETE;
                    UNTIL ExamBLog.NEXT=0;
                    END;
                     }
                    Ln:=ExamBLog.COUNT;
                    StudUnit.RESET;
                    StudUnit.SETRANGE(StudUnit.Semester,Semester);
                    StudUnit.SETFILTER(StudUnit."Final Score",'>%1',0);
                    StudUnit.SETFILTER(StudUnit.Grade,'<>%1','');

                  //  StudUnit.SETRANGE(StudUnit."Student No.",'BMIT/M/0005/01/15');
                    IF StudUnit.FIND('-') THEN BEGIN
                    REPEAT
                    StudUnit.CALCFIELDS("CF Lk");
                    StudUnit.CALCFIELDS(StudUnit."Unit Description");
                    StudUnit.CALCFIELDS(StudUnit."Stage Unit LK");
                    CReg.RESET;
                    CReg.SETRANGE(CReg."Student No.",StudUnit."Student No.");
                    CReg.SETRANGE(CReg.Semester,Semester);
                    CReg.SETRANGE(CReg."Settlement Type",'SCH_BASED');
                    CReg.SETFILTER(CReg."Prog Online Released",'%1',TRUE);
                   // CReg.SETRANGE(CReg.Reversed,FALSE);
                    IF CReg.FIND('-') THEN BEGIN
                    CumAv:=0;
                    ExamBLog.RESET;
                    ExamBLog.SETRANGE(ExamBLog."Reg No",CReg."Student No.");
                    IF ExamBLog.FIND('+') THEN
                    CumAv:=ExamBLog."Cum AVerage";

                    ProgStage.RESET;
                    ProgStage.SETRANGE(ProgStage."Programme Code",CReg.Programme);
                    ProgStage.SETRANGE(ProgStage.Code,CReg.Stage);
                    IF ProgStage.FIND('-') THEN BEGIN
                    Ln:=Ln+1;
                    BankL.INIT;
                    ExamBLog."Reg No":=StudUnit."Student No.";
                    ExamBLog."Unit Code":=StudUnit.Unit;
                    ExamBLog."Ac Year":=COPYSTR(StudUnit."Stage Unit LK",2,1);
                   // ExamBLog."Ac Year":=StudUnit."Unit Stage";

                    ExamBLog.Entry:=Ln;
                    ExamBLog.Grade:= StudUnit.Grade;
                    ExamBLog.Description:=StudUnit."Unit Description";
                    ExamBLog.CF:= StudUnit."No. Of Units";
                  //  ExamBLog."Year Score":=CReg."Cumm Score";
                    Prog.GET(ProgStage."Programme Code");
                    Prog.CALCFIELDS("Dept Name");
                    ExamBLog.Department:=Prog."Dept Name";
                   // ExamBLog."Cum AVerage":=(CReg."Cumm Score"+CumAv)/2;
                    ExamBLog.Remark:=UPPERCASE(COPYSTR(ProgStage.Remarks,6,100)+' OF STUDY');
                    ExamBLog.Group:="Academic Year";
                    ExamBLog.Programme:=CReg.Programme;
                    ExamBLog."Unit Score":=StudUnit."Final Score";
                    ExamBLog.Semester:=Semester;
                    ExamBLog."CF Score":=StudUnit."Final Score"*StudUnit."No. Of Units";
                    ExamBLog."Academic Year":="Academic Year";
                    ExamBLog.INSERT;
                    END;
                    END;
                    UNTIL StudUnit.NEXT=0;
                    END;
                    // Update Year and Cummulative Scores
                    ExamBLog.RESET;
                   // ExamBLog.SETRANGE(ExamBLog.Semester,'SEM3 2015');
                    IF ExamBLog.FIND('-') THEN BEGIN
                    REPEAT
                    ExamBLog."CF Score":=ExamBLog."Unit Score"*ExamBLog.CF;
                    ExamBLog.MODIFY;
                    UNTIL ExamBLog.NEXT=0;
                    END;

                    ExamBLog.RESET;
                    ExamBLog.SETRANGE(ExamBLog.Semester,Semester);
                    ExamBLog.SETCURRENTKEY(ExamBLog."Ac Year");
                    IF ExamBLog.FIND('-') THEN BEGIN
                    REPEAT
                    ExamBLog.SETFILTER(ExamBLog."Cumm Ac Year Filter",'%1..%2','0',ExamBLog."Ac Year");
                    ExamBLog.CALCFIELDS("Total CF");
                    ExamBLog.CALCFIELDS("Total CF Score");
                    ExamBLog.CALCFIELDS("Sem Total CF");
                    ExamBLog.CALCFIELDS("Sem Total CF Score");
                    ExamBLog.CALCFIELDS("Sem Total CF Score");
                    ExamBLog.CALCFIELDS(ExamBLog."Results Count");
                    IF (ExamBLog."Sem Total CF Score"<>0) AND (ExamBLog."Sem Total CF"<>0) THEN
                    ExamBLog."Year Score":=ExamBLog."Sem Total CF Score"/ExamBLog."Sem Total CF";
                    IF (ExamBLog."Total CF Score"<>0) AND (ExamBLog."Total CF"<>0) THEN
                    ExamBLog."Cum AVerage":=ExamBLog."Total CF Score"/ExamBLog."Total CF";

                     IF (ExamBLog."Results Count"=4) then
                     ExamBLog."Grade Prefix":='*';

                    ExamBLog.MODIFY;
                    UNTIL ExamBLog.NEXT=0;
                    END;
                    Posted:=TRUE;
                    Rec.UserID:=UserID;
                    "Release Type":="Release Type"::"School Based";
                    MODIFY;

                    MESSAGE('Process completed successfully');
                    */

                    Rec.TestField(Semester);
                    Rec.TestField("Academic Year");
                    SemRec.Get(Rec.Semester);
                    SemRec.TestField(SemRec."Allow Online Results", true);
                    if Confirm('Do you really want upload the online results?', false) = false then Error('Aborted by User');
                    Ln := ExamBLog.Count;
                    StudUnit.Reset;
                    StudUnit.SetRange(StudUnit.Semester, Rec.Semester);
                    StudUnit.SetFilter(StudUnit."Final Score", '>%1', 0);
                    StudUnit.SetFilter(StudUnit.Grade, '<>%1', '');

                    //  StudUnit.SETRANGE(StudUnit."Student No.",'BMIT/M/0005/01/15');
                    if StudUnit.Find('-') then begin
                        repeat
                            StudUnit.CalcFields("CF Lk");
                            StudUnit.CalcFields(StudUnit."Unit Description");
                            StudUnit.CalcFields(StudUnit."Stage Unit LK");
                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", StudUnit."Student No.");
                            CReg.SetRange(CReg.Semester, Rec.Semester);
                            CReg.SetFilter(CReg."Settlement Type", 'SCH_BASED');  //TRS
                            CReg.SetFilter(CReg."Prog Online Released", '%1', true);

                            //CReg.SETRANGE(CReg.Reversed,FALSE);
                            if CReg.Find('-') then begin

                                ExamBLog.Reset;
                                ExamBLog.SetRange(ExamBLog."Reg No", CReg."Student No.");
                                ExamBLog.SetRange(ExamBLog."Unit Code", StudUnit.Unit);
                                ExamBLog.SetFilter(ExamBLog.Grade, '%1|%2|%3|%4', 'A', 'B', 'C', 'D');
                                if not ExamBLog.Find('-') then begin     // Prevent update for existing marks if not Incomplete and not failed

                                    ExamBLog3.Reset;
                                    ExamBLog3.SetRange(ExamBLog3."Reg No", CReg."Student No.");
                                    ExamBLog3.SetRange(ExamBLog3."Unit Code", StudUnit.Unit);
                                    if ExamBLog3.Find('-') then begin //Update if Existing
                                        ExamBLog3.Grade := StudUnit.Grade;
                                        ExamBLog3.Description := StudUnit."Unit Description";
                                        ExamBLog3.CF := StudUnit."CF Lk";
                                        if Prog.Get(ProgStage."Programme Code") then
                                            Prog.CalcFields("Dept Name");
                                        ExamBLog3.Department := Prog."Dept Name";
                                        ExamBLog3.Remark := UpperCase(CopyStr(ProgStage.Remarks, 6, 100) + ' OF STUDY');
                                        ExamBLog3.Group := Rec."Academic Year";
                                        ExamBLog3.Programme := CReg.Programme;
                                        ExamBLog3."Unit Score" := StudUnit."Final Score";
                                        ExamBLog3.Semester := Rec.Semester;
                                        ExamBLog3."CF Score" := StudUnit."Final Score" * StudUnit."CF Lk";
                                        ExamBLog3.Modify;

                                    end else begin

                                        CumAv := 0;
                                        ExamBLog.Reset;
                                        ExamBLog.SetRange(ExamBLog."Reg No", CReg."Student No.");
                                        if ExamBLog.Find('+') then
                                            CumAv := ExamBLog."Cum AVerage";

                                        ProgStage.Reset;
                                        ProgStage.SetRange(ProgStage."Programme Code", CReg.Programme);
                                        ProgStage.SetRange(ProgStage.Code, CReg.Stage);
                                        if ProgStage.Find('-') then begin
                                            Ln := Ln + 1;
                                            ExamBLog.Init;
                                            ExamBLog."Reg No" := StudUnit."Student No.";
                                            ExamBLog."Unit Code" := StudUnit.Unit;
                                            ExamBLog."Ac Year" := CopyStr(StudUnit."Stage Unit LK", 2, 1);
                                            // ExamBLog."Ac Year":=StudUnit."Unit Stage";

                                            ExamBLog.Entry := Ln;
                                            ExamBLog.Grade := StudUnit.Grade;
                                            ExamBLog.Description := StudUnit."Unit Description";
                                            ExamBLog.CF := StudUnit."CF Lk";
                                            //  ExamBLog."Year Score":=CReg."Cumm Score";
                                            if Prog.Get(ProgStage."Programme Code") then
                                                Prog.CalcFields("Dept Name");
                                            ExamBLog.Department := Prog."Dept Name";
                                            // ExamBLog."Cum AVerage":=(CReg."Cumm Score"+CumAv)/2;
                                            ExamBLog.Remark := UpperCase(CopyStr(ProgStage.Remarks, 6, 100) + ' OF STUDY');
                                            ExamBLog.Group := Rec."Academic Year";
                                            ExamBLog.Programme := CReg.Programme;
                                            ExamBLog."Unit Score" := StudUnit."Final Score";
                                            ExamBLog.Semester := Rec.Semester;
                                            ExamBLog."CF Score" := StudUnit."Final Score" * StudUnit."CF Lk";
                                            ExamBLog."Academic Year" := Rec."Academic Year";
                                            ExamBLog.Insert;
                                        end;
                                    end;
                                end;
                            end;
                        until StudUnit.Next = 0;
                    end;
                    // Update Year and Cummulative Scores
                    ExamBLog.Reset;
                    // ExamBLog.SETRANGE(ExamBLog.Semester,'SEM3 2015');
                    if ExamBLog.Find('-') then begin
                        repeat
                            ExamBLog."CF Score" := ExamBLog."Unit Score" * ExamBLog.CF;
                            ExamBLog.Modify;
                        until ExamBLog.Next = 0;
                    end;

                    ExamBLog.Reset;
                    ExamBLog.SetRange(ExamBLog.Semester, Rec.Semester);
                    ExamBLog.SetCurrentkey(ExamBLog."Ac Year");
                    if ExamBLog.Find('-') then begin
                        repeat
                            ExamBLog.SetFilter(ExamBLog."Cumm Ac Year Filter", '%1..%2', '0', ExamBLog."Ac Year");
                            ExamBLog.CalcFields("Total CF");
                            ExamBLog.CalcFields("Total CF Score");
                            ExamBLog.CalcFields("Sem Total CF");
                            ExamBLog.CalcFields("Sem Total CF Score");
                            ExamBLog.CalcFields(ExamBLog."Unit Count");
                            ExamBLog.CalcFields(ExamBLog."Student Unit Count");
                            if (ExamBLog."Sem Total CF Score" <> 0) and (ExamBLog."Sem Total CF" <> 0) then
                                ExamBLog."Year Score" := ExamBLog."Sem Total CF Score" / ExamBLog."Sem Total CF";
                            if (ExamBLog."Total CF Score" <> 0) and (ExamBLog."Total CF" <> 0) then
                                ExamBLog."Cum AVerage" := ExamBLog."Total CF Score" / ExamBLog."Total CF";
                            if (ExamBLog."Unit Count" > 1) and ((ExamBLog.Grade = 'I') or (ExamBLog.Grade = 'F')) then   // Update the old unit to retaken for Incomplete and Failed
                                ExamBLog.Retaken := true;
                            if (ExamBLog."Unit Count" > 1) and ((ExamBLog.Grade <> 'I') and (ExamBLog.Grade <> 'F')) then   // Update the gradet with  *  if retake
                                ExamBLog.Grade := CopyStr(ExamBLog.Grade, 1, 1) + '*';

                            ExamBLog.Modify;
                        until ExamBLog.Next = 0;
                    end;
                    Rec.Posted := true;
                    Rec.UserID := Rec.UserID;
                    Rec."Release Type" := Rec."release type"::"School Based";
                    Rec.Modify;

                    Message('Process completed successfully');

                end;
            }
            separator(Action11) { }
            action("Release Online Results - Exemptions")
            {
                ApplicationArea = Basic;
                Caption = 'Release Online Results - Exemptions';
                Image = ReleaseShipment;
                Visible = false;
                ToolTip = 'Executes the Release Online Results - Exemptions action.';

                trigger OnAction()
                begin
                    Rec.TestField(Semester);
                    Rec.TestField("Academic Year");

                    if Confirm('Do you really want upload the online results?', false) = false then Error('Aborted by User');
                    /*
                    ExamBLog.RESET;
                    ExamBLog.SETRANGE(ExamBLog.Semester,Semester);
                    ExamBLog.SETRANGE(ExamBLog.Grade,'CT');
                    IF ExamBLog.FIND('-') THEN BEGIN
                    REPEAT
                    ExamBLog.DELETE;
                    UNTIL ExamBLog.NEXT=0;
                    END;
                    */
                    ExamBLog.Reset;
                    Ln := ExamBLog.Count;
                    StudUnitExempt.Reset;
                    StudUnitExempt.SetRange(StudUnitExempt.Semester, Rec.Semester);
                    StudUnitExempt.SetRange(StudUnitExempt.Status, StudUnitExempt.Status::Approved);
                    //  StudUnit.SETRANGE(StudUnit."Student No.",'BMIT/M/0005/01/15');
                    if StudUnitExempt.Find('-') then begin
                        repeat
                            StudUnitExempt.CalcFields(Description);
                            ExamBLog3.Reset;
                            ExamBLog3.SetRange(ExamBLog3."Reg No", StudUnitExempt."Student No.");
                            ExamBLog3.SetRange(ExamBLog3."Unit Code", StudUnitExempt.Unit);
                            if ExamBLog3.Find('-') then begin //Update if Existing
                                                              /*
                                                              ExamBLog3.Grade:= 'CT';
                                                              ExamBLog3.Description:=StudUnitExempt.Description;
                                                              ExamBLog3.CF:= StudUnitExempt.CF;
                                                              IF Prog.GET(ProgStage."Programme Code") THEN
                                                              Prog.CALCFIELDS("Dept Name");
                                                              ExamBLog3.Department:=Prog."Dept Name";
                                                              ExamBLog3.Remark:=UPPERCASE(COPYSTR(ProgStage.Remarks,6,100)+' OF STUDY');
                                                              ExamBLog3.Group:="Academic Year";
                                                              ExamBLog3.Programme:=StudUnitExempt.Programme;
                                                             // ExamBLog3."Unit Score":=StudUnit."Final Score";
                                                              ExamBLog3.Semester:=StudUnitExempt.Semester;
                                                            //  ExamBLog3."CF Score":=StudUnit."Final Score"*StudUnit."CF Lk";
                                                              ExamBLog3.MODIFY;
                                                              */
                            end else begin
                                Ln := Ln + 1;
                                BankL.Init;
                                ExamBLog."Reg No" := StudUnitExempt."Student No.";
                                ExamBLog."Unit Code" := StudUnitExempt.Unit;
                                ExamBLog."Ac Year" := CopyStr(StudUnitExempt.Stage, 2, 1);
                                // ExamBLog."Ac Year":=StudUnit."Unit Stage";

                                ExamBLog.Entry := Ln;
                                ExamBLog.Grade := 'CT';
                                ExamBLog.Description := StudUnitExempt.Description;
                                ExamBLog.CF := StudUnitExempt.CF;
                                //  ExamBLog."Year Score":=CReg."Cumm Score";
                                Prog.Get(StudUnitExempt.Programme);
                                Prog.CalcFields("Dept Name");
                                ExamBLog.Department := Prog."Dept Name";
                                // ExamBLog."Cum AVerage":=(CReg."Cumm Score"+CumAv)/2;
                                ProgStage.Reset;
                                ProgStage.SetRange(ProgStage."Programme Code", StudUnitExempt.Programme);
                                ProgStage.SetRange(ProgStage.Code, StudUnitExempt.Stage);
                                if ProgStage.Find('-') then
                                    ExamBLog.Remark := UpperCase(CopyStr(ProgStage.Remarks, 6, 100) + ' OF STUDY');

                                ExamBLog.Group := Rec."Academic Year";
                                ExamBLog.Programme := StudUnitExempt.Programme;
                                ExamBLog."Unit Score" := 0;
                                ExamBLog.Semester := Rec.Semester;
                                ExamBLog."CF Score" := 0;

                                ExamBLog2.Reset;
                                ExamBLog2.SetRange(ExamBLog2.Semester, Rec.Semester);
                                ExamBLog2.SetRange(ExamBLog2.Group, Rec."Academic Year");
                                ExamBLog2.SetRange(ExamBLog2."Reg No", StudUnitExempt."Student No.");
                                ExamBLog2.SetFilter(ExamBLog2.Grade, '<>%1', 'CT');
                                if ExamBLog2.Find('-') then begin
                                    ExamBLog."Year Score" := ExamBLog2."Year Score";
                                    ExamBLog."Cum AVerage" := ExamBLog2."Cum AVerage";
                                end;
                                ExamBLog."Academic Year" := Rec."Academic Year";
                                ExamBLog.Insert;
                            end;
                        until StudUnitExempt.Next = 0;
                    end;
                    ExamBLog.Reset;
                    ExamBLog.SetRange(ExamBLog.Semester, Rec.Semester);
                    ExamBLog.SetCurrentkey(ExamBLog."Ac Year");
                    if ExamBLog.Find('-') then begin
                        repeat
                            ExamBLog.SetFilter(ExamBLog."Cumm Ac Year Filter", '%1..%2', '0', ExamBLog."Ac Year");
                            ExamBLog.CalcFields("Total CF");
                            ExamBLog.CalcFields("Total CF Score");
                            ExamBLog.CalcFields("Sem Total CF");
                            ExamBLog.CalcFields("Sem Total CF Score");
                            ExamBLog.CalcFields(ExamBLog."Student Unit Count");
                            if (ExamBLog."Sem Total CF Score" <> 0) and (ExamBLog."Sem Total CF" <> 0) then
                                ExamBLog."Year Score" := ExamBLog."Sem Total CF Score" / ExamBLog."Sem Total CF";
                            if (ExamBLog."Total CF Score" <> 0) and (ExamBLog."Total CF" <> 0) then
                                ExamBLog."Cum AVerage" := ExamBLog."Total CF Score" / ExamBLog."Total CF";
                            // IF ExamBLog."Student Unit Count">1 THEN
                            // ExamBLog.Grade:=ExamBLog.Grade+'*';
                            ExamBLog.Modify;
                        until ExamBLog.Next = 0;
                    end;

                    Rec.Posted := true;
                    Rec.UserID := Rec.UserID;
                    Rec."Release Type" := Rec."release type"::Exemption;
                    Rec.Modify;
                    Message('Process completed successfully');

                end;
            }
        }
    }

    var
        BankL: Record "Bank Account Ledger Entry";
        ExamBLog: Record "BackLog Exam Results";
        Ln: Integer;
        CumAv: Decimal;
        CReg: Record "Course Registration";
        StudUnit: Record "Student Units";
        Prog: Record Programme;
        ProgStage: Record "Programme Stages";
        StudUnitExempt: Record "Student Units Exemptions";
        ExamBLog2: Record "BackLog Exam Results";
        ExamBLog3: Record "BackLog Exam Results";
        SemRec: Record Semesters;
        ProcM: Codeunit "Exams Processing";
}

