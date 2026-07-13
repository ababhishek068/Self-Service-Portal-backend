Codeunit 50043 "Time Table"
{

    trigger OnRun()
    begin
    end;

    var
        ClassRec: Record "Class Setups";
        TRec: Record "Time Table";
        TRec2: Record "Time Table";
        TRec3: Record "Time Table";
        TRec4: Record "Time Table";
        TRec5: Record "Time Table";
        TRec6: Record "Time Table";
        theLecturer: Text;
        UnitCode: Code[20];

    procedure InsertTimeTable(Unit: Code[20]; Lesson: Code[20])
    begin
        // GenSetup.GET();
        // IF TimeTable.GET(GenSetup."Current TT Code") THEN BEGIN
        // //CheckConflict(Unit,Lesson);
        // TT.INIT;
        // TT.Programme:=TimeTable.Programme;
        // TT.Stage:=TimeTable.Stage;
        // TT.Unit:=Unit;
        // TT.Semester:=TimeTable.Semester;
        // TT.Period:=Lesson;
        // TT."Day of Week":=TimeTable.Day;
        // TT."Lecture Room":=TimeTable."Lecturer Room";
        // TT.Lecturer:=TimeTable.Lecturer;
        // TT."Campus Code":=TimeTable.Campus;
        // TT."Mode of Study":=TimeTable."Mode of Study";
        // TT.INSERT;
        // END;
    end;

    procedure ClearCurrentTimeTable(SemCode: Code[20]; CompusCode: Code[20]; Type: Option Teaching,Exam)
    var
        TT: Record "Time Table";
        RoomRec: Record "Lecture Rooms";
        UnitsRec: Record "Units/Subjects";
        LessonRec: Record Lessons;
        DayRec: Record "Day Of Week";
    begin
        TT.Reset;
        TT.SetRange(TT.Semester, SemCode);
        TT.SetRange(TT."Campus Code", CompusCode);
        TT.SetRange(TT.Type, Type);
        TT.SetRange(TT.Auto, true);
        if TT.Find('-') then begin
            repeat
                TT.Delete;
            until TT.Next = 0;
        end;

        UnitsRec.Reset;
        if UnitsRec.Find('-') then begin
            repeat
                UnitsRec."Time Tabled Count" := 0;
                UnitsRec.Modify;
            until UnitsRec.Next = 0;
        end;

        RoomRec.Reset;
        if RoomRec.Find('-') then begin
            repeat
                RoomRec."Time Table Count" := 0;
                RoomRec.Modify;
            until RoomRec.Next = 0;
        end;

        LessonRec.Reset;
        if LessonRec.Find('-') then begin
            repeat
                LessonRec."Used Count" := 0;
                LessonRec.Modify;
            until LessonRec.Next = 0;
        end;

        DayRec.Reset;
        if DayRec.Find('-') then begin
            repeat
                DayRec."Used Count" := 0;
                DayRec.Modify;
            until DayRec.Next = 0;
        end;


        Message('The Time Table has been cleared Successfuly');
    end;

    procedure GenerateClass(CapSem: Code[20]; ClassMax: Integer; CampusCode: Code[20]; Type: Option Teaching,Exam; ModeOfStudy: Code[20])
    var
        UnitsRec: Record "Units/Subjects";
        Classes: Decimal;
        i: Integer;
        HrEmp: Record "HR-Employee";
        ClassCode: Code[100];
        GenSetup: record "General Set-Up";
    begin
        GenSetup.get;
        GenSetup.TestField("Default Class");
        ClassRec.Reset;
        ClassRec.SetRange(ClassRec.Campus, CampusCode);
        ClassRec.SetRange(ClassRec."Mode of Study", ModeOfStudy);
        ClassRec.SetRange("Class Code", GenSetup."Default Class");
        ClassRec.DeleteAll;

        //ProgStages.RESET;
        // ProgStages.SETRANGE(ProgStages."Include in Time Table",TRUE);
        //  ProgStages.SETRANGE(ProgStages."Programme Code",'CT 051');
        // IF ProgStages.FIND('-') THEN BEGIN
        // REPEAT
        UnitsRec.Reset;
        // UnitsRec.SETRANGE(UnitsRec."Programme Code",ProgStages."Programme Code");
        // UnitsRec.SETRANGE(UnitsRec."Stage Code",ProgStages.Code);
        UnitsRec.SetRange(UnitsRec."Old Unit", false);
        UnitsRec.SetRange(UnitsRec."Time Table", true);
        UnitsRec.SetFilter(UnitsRec."Semester Filter", CapSem);
        UnitsRec.SetFilter(UnitsRec."Campus Filter", CampusCode);
        UnitsRec.SetFilter(UnitsRec."Mode of Study Filter", ModeOfStudy);
        if UnitsRec.Find('-') then begin
            repeat
                //Checklecturerunit
                // IF Checklecturerunit(ProgStages."Programme Code",UnitsRec.Code,CapSem,ProgStages.Code) THEN BEGIN

                UnitCode := '';
                ClassCode := '';
                UnitCode := CheckTTUnitCode(UnitsRec.Code, UnitsRec."Programme Code");    // Get the Time table Code
                ClassCode := UnitCode;
                if UnitCode = '' then begin
                    UnitCode := UnitsRec.Code;
                    ClassCode := UnitCode + '-' + UnitsRec."Programme Code";  // Use programme if timetable code is empty
                end;
                UnitsRec.CalcFields(UnitsRec."Unit Class Size");
                UnitsRec.CalcFields(UnitsRec."Lecturer Lkup");
                if UnitsRec."Unit Class Size" > ClassMax then
                    Classes := Abs(UnitsRec."Unit Class Size" / ClassMax);
                Classes := ROUND(UnitsRec."Unit Class Size" / 300, 1, '>');
                if Classes < 1 then Classes := 1;
                //ClassRec.Get(ClassCode + '=' + Format(Type) + '$' + Format(i), UnitsRec."Stage Code", CampusCode, ModeOfStudy)
                for i := 1 to 1 do begin
                    if not ClassRec.Get(GenSetup."Default Class", UnitsRec."Stage Code", CampusCode, ModeOfStudy, UnitsRec.Code) then begin
                        ClassRec.Init;
                        //    ClassRec."Class Code":=UnitsRec.Code+'$'+FORMAT(i);
                        ClassRec."Class Code" := GenSetup."Default Class";
                        ClassRec."Unit Code" := UnitCode;

                        ClassRec.Campus := CampusCode;
                        ClassRec."Mode of Study" := ModeOfStudy;
                        ClassRec.LecturerCode := UnitsRec."Lecturer Lkup";
                        theLecturer := '';
                        if HrEmp.Get(UnitsRec."Lecturer Lkup") then theLecturer := HrEmp."First Name";

                        if ClassRec.LecturerCode <> '' then ClassRec.Lecturer := theLecturer;

                        if UnitsRec."Unit Class Size" >= ClassMax then
                            ClassRec."Class Size" := ClassMax
                        else
                            ClassRec."Class Size" := UnitsRec."Unit Class Size";
                        ClassRec."Actual Unit Code" := UnitsRec.Code;
                        ClassRec."Reserved Room" := UnitsRec."Reserved Room";
                        ClassRec."Programme Code" := UnitsRec."Programme Code";
                        ClassRec."Stage Code" := UnitsRec."Stage Code";
                        ClassRec.Insert;
                    end;
                end;
            //  END;
            until UnitsRec.Next = 0;
        end;
        //UNTIL ProgStages.NEXT=0;
        //END;
    end;

    procedure GenerateTT_Reserved(MaxClassWk: Integer; SemCode: Code[20]; Campus: Code[50]; Type: Option Teaching,Exam; ModeOfStudy: Code[20])
    var
        DayRec: Record "Day Of Week";
        LessonRec: Record Lessons;
        LecRooms: Record "Lecture Rooms";
    begin

        LessonRec.Reset;
        LessonRec.SetRange(LessonRec.Active, true);
        if Type = Type::Teaching then
            LessonRec.SetRange(LessonRec.Type, LessonRec.Type::Teaching)
        else
            LessonRec.SetRange(LessonRec.Type, LessonRec.Type::Exam);
        if LessonRec.Find('-') then begin
            repeat
                DayRec.Reset;
                DayRec.SetRange(Active, true);
                if Type = Type::Teaching then
                    DayRec.SetRange(DayRec.Exams, false)
                else
                    DayRec.SetRange(DayRec.Exams, true);
                if DayRec.Find('-') then begin
                    repeat

                        LecRooms.Reset;
                        LecRooms.SetFilter(LecRooms."Day Filter", DayRec.Day);
                        LecRooms.SetFilter(LecRooms."Lesson Filter", LessonRec.Code);
                        LecRooms.SetFilter(LecRooms."Global Dimension 1", Campus);
                        LecRooms.SetFilter(LecRooms."Mode of Study Filter", ModeOfStudy);
                        //LecRooms.SETFILTER(LecRooms.Code,'MAINHALL');//
                        //LecRooms.SETFILTER(LecRooms.Reserved,'=%1',FALSE);

                        //LecRooms.SETVIEW('SORTING(LecRooms."Maximum Capacity") ORDER(Descending)');
                        if LecRooms.Find('-') then begin
                            repeat
                                LecRooms.CalcFields(LecRooms."Reseverd Count");
                                LecRooms.CalcFields(LecRooms."Used Count");
                                if (LecRooms."Used Count" < 2) and (LecRooms."Reseverd Count" > 1) then begin
                                    //BEGIN
                                    ClassRec.Reset;
                                    ClassRec.SetRange(ClassRec.Campus, Campus);
                                    ClassRec.SetRange(ClassRec."Mode of Study", ModeOfStudy);
                                    ClassRec.SetFilter(ClassRec."Day Filter", DayRec.Day);
                                    ClassRec.SetFilter(ClassRec."Lesson Filter", LessonRec.Code);
                                    ClassRec.SetFilter(ClassRec."Reserved Room", '<>%1', '');
                                    //ClassRec.SETVIEW('SORTING(ClassRec."ClassSize") ORDER(Descending)');
                                    if ClassRec.Find('-') then begin
                                        repeat
                                            ClassRec.CalcFields(ClassRec."Day Count");
                                            ClassRec.CalcFields(ClassRec."Lesson Count");
                                            ClassRec.CalcFields(ClassRec."Used Count");
                                            ClassRec.CalcFields(ClassRec."Unit Programme");
                                            ClassRec.CalcFields(ClassRec."Unit Stage");
                                            ClassRec.CalcFields(ClassRec."Unit Class Count");
                                            ClassRec.CalcFields(ClassRec."Class Count");
                                            //if ClassRec."Unit Code"='SMA 2100' then error('Test2');
                                            if ClassRec."Class Count" = 0 then begin

                                                //IF ClassRec."Class Size"<=LecRooms."Maximum Capacity" THEN BEGIN begin
                                                begin
                                                    TRec.Reset;
                                                    TRec.SetRange(TRec."Unit Class", ClassRec."Class Code");
                                                    TRec.SetRange(TRec."Day of Week", DayRec.Day);
                                                    TRec.SetRange(TRec."Campus Code", Campus);
                                                    TRec.SetRange(TRec."Mode of Study", ModeOfStudy);
                                                    if TRec.Count < ClassRec."Unit Class Count" then begin    // Check Unit per day
                                                                                                              //BEGIN
                                                        TRec2.Reset;
                                                        TRec2.SetRange(TRec2."Day of Week", DayRec.Day);
                                                        TRec2.SetRange(TRec2."Lecture Room", LecRooms.Code);
                                                        TRec2.SetRange(TRec2.Period, LessonRec.Code);
                                                        TRec2.SetRange(TRec2."Campus Code", Campus);
                                                        TRec2.SetRange(TRec2."Mode of Study", ModeOfStudy);
                                                        if TRec2.Count < 1 then begin   // Check room confict
                                                                                        //begin

                                                            TRec3.Reset;
                                                            TRec3.SetRange(TRec3."Unit Class", ClassRec."Class Code");
                                                            TRec3.SetRange(TRec3."Campus Code", Campus);
                                                            TRec3.SetRange(TRec3."Mode of Study", ModeOfStudy);
                                                            if TRec3.Count < MaxClassWk then begin  // Check max Unit weekly
                                                                                                    //BEGIN

                                                                TRec6.Reset;
                                                                TRec6.SetRange(TRec6.Stage, ClassRec."Unit Stage");
                                                                TRec6.SetRange(TRec6.Programme, ClassRec."Unit Programme");
                                                                TRec6.SetRange(TRec6."Campus Code", Campus);
                                                                TRec6.SetRange(TRec6."Mode of Study", ModeOfStudy);
                                                                //IF TRec6.COUNT<10 THEN BEGIN  // Check max Class Daily

                                                                begin
                                                                    TRec4.Reset;
                                                                    TRec4.SetRange(TRec4.Lecturer, ClassRec.LecturerCode);
                                                                    TRec4.SetRange(TRec4.Period, LessonRec.Code);
                                                                    TRec4.SetRange(TRec4."Day of Week", DayRec.Day);
                                                                    TRec4.SetRange(TRec4."Campus Code", Campus);
                                                                    TRec4.SetRange(TRec4."Mode of Study", ModeOfStudy);
                                                                    //TRec4.SETRANGE(TRec4."Campus Code",Campus);
                                                                    //IF TRec4.COUNT<1 THEN BEGIN  // Check the lecturer conflict
                                                                    begin
                                                                        TRec5.Reset;
                                                                        TRec5.SetRange(TRec5.Programme, ClassRec."Unit Programme");
                                                                        TRec5.SetRange(TRec5.Stage, ClassRec."Unit Stage");
                                                                        TRec5.SetRange(TRec5.Period, LessonRec.Code);
                                                                        TRec5.SetRange(TRec5."Day of Week", DayRec.Day);
                                                                        TRec5.SetRange(TRec5."Campus Code", Campus);
                                                                        TRec5.SetRange(TRec5."Mode of Study", ModeOfStudy);
                                                                        //IF TRec5.COUNT<1 THEN BEGIN  // Check the class conflict

                                                                        begin
                                                                            //IF ClassRec."Unit Code"='SMA 2100' THEN ERROR('Test2');
                                                                            // IF LecRooms."Reserve For Unit"<>ClassRec."Unit Code" THEN BEGIN
                                                                            // IF CheckClassSize(ClassRec."Unit Code",LecRooms.Code,SemCode,Campus)=TRUE THEN BEGIN
                                                                            // IF ClassRec."Unit Code"='BBB 1108' THEN ERROR('XFGH');

                                                                            InsertRandom(ClassRec."Unit Code", SemCode, DayRec.Day, LessonRec.Code, LecRooms.Code, ClassRec.LecturerCode, ClassRec."Unit Code"
                                                                           + '[' + Format(ClassRec."Class Size") + '] ' + ClassRec.Lecturer + ' ' + LecRooms.Code, ClassRec."Programme Code", ClassRec."Stage Code",
                                                                           ClassRec."Class Code", Campus, Type, ModeOfStudy);
                                                                            //  END;
                                                                            // END;
                                                                        end;
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        until ClassRec.Next = 0;
                                    end;
                                end;
                            until LecRooms.Next = 0;
                        end;
                    until DayRec.Next = 0;
                end;

            until LessonRec.Next = 0;
        end;
    end;

    procedure GenerateTT_Others(MaxClassWk: Integer; SemCode: Code[20]; Campus: Code[50]; Type: Option Teaching,Exam; ModeOfStudy: Code[20])
    var
        DayRec: Record "Day Of Week";
        LessonRec: Record Lessons;
        LecRooms: Record "Lecture Rooms";
    begin

        LecRooms.Reset;
        //LecRooms.SETFILTER(LecRooms."Day Filter",DayRec.Day);
        //LecRooms.SETFILTER(LecRooms."Lesson Filter",LessonRec.Code);
        LecRooms.SetFilter(LecRooms."Global Dimension 1", Campus);
        LecRooms.SetFilter(LecRooms."Mode of Study Filter", ModeOfStudy);
        LecRooms.SetFilter(LecRooms.Reserved, '%1', false);
        if LecRooms.Find('-') then begin
            repeat
                LecRooms.CalcFields(LecRooms."Reseverd Count");
                LecRooms.CalcFields(LecRooms."Used Count");
                if (LecRooms."Used Count" < 40) and (LecRooms."Reseverd Count" = 0) then begin

                    //BEGIN
                    ClassRec.Reset;
                    ClassRec.SetRange(ClassRec.Campus, Campus);
                    ClassRec.SetRange(ClassRec."Mode of Study", ModeOfStudy);
                    ClassRec.SetFilter(ClassRec."Day Filter", DayRec.Day);
                    ClassRec.SetFilter(ClassRec."Lesson Filter", LessonRec.Code);
                    ClassRec.SetFilter(ClassRec."Reserved Room", '%1', '');

                    //ClassRec.SETVIEW('SORTING(ClassRec."ClassSize") ORDER(Descending)');
                    if ClassRec.Find('-') then begin
                        repeat

                            LessonRec.Reset;
                            LessonRec.SetRange(Active, true);
                            if Type = Type::Teaching then
                                LessonRec.SetRange(LessonRec.Type, LessonRec.Type::Teaching)
                            else
                                LessonRec.SetRange(LessonRec.Type, LessonRec.Type::Exam);
                            if LessonRec.Find('-') then begin
                                repeat
                                    DayRec.Reset;
                                    DayRec.SetRange(Active, true);
                                    if Type = Type::Teaching then
                                        DayRec.SetRange(DayRec.Exams, false)
                                    else
                                        DayRec.SetRange(DayRec.Exams, true);

                                    if DayRec.Find('-') then begin
                                        repeat

                                            ClassRec.CalcFields(ClassRec."Day Count");
                                            ClassRec.CalcFields(ClassRec."Lesson Count");
                                            ClassRec.CalcFields(ClassRec."Used Count");
                                            ClassRec.CalcFields(ClassRec."Unit Programme");
                                            ClassRec.CalcFields(ClassRec."Unit Stage");
                                            ClassRec.CalcFields(ClassRec."Unit Class Count");
                                            ClassRec.CalcFields(ClassRec."Class Count");
                                            //IF (ClassRec."Unit Code"='BBB 1102') AND (ClassRec."Programme Code"='CT 051') THEN ERROR('Test3-'+format(ClassRec."Used Count"));
                                            if ClassRec."Class Count" = 0 then begin

                                                //IF ClassRec."Class Size"<=LecRooms."Maximum Capacity" THEN BEGIN begin
                                                begin
                                                    TRec.Reset;
                                                    TRec.SetRange(TRec."Unit Class", ClassRec."Class Code");
                                                    TRec.SetRange(TRec."Day of Week", DayRec.Day);
                                                    TRec.SetRange(TRec."Campus Code", Campus);
                                                    TRec.SetRange(TRec."Mode of Study", ModeOfStudy);
                                                    if TRec.Count < ClassRec."Unit Class Count" then begin    // Check Unit per day  ...
                                                                                                              //BEGIN
                                                        TRec2.Reset;
                                                        TRec2.SetRange(TRec2."Day of Week", DayRec.Day);
                                                        TRec2.SetRange(TRec2."Lecture Room", LecRooms.Code);
                                                        TRec2.SetRange(TRec2.Period, LessonRec.Code);
                                                        TRec2.SetRange(TRec2."Campus Code", Campus);
                                                        TRec2.SetRange(TRec2."Mode of Study", ModeOfStudy);
                                                        if TRec2.Count < 1 then begin   // Check room confict ...
                                                                                        //BEGIN

                                                            TRec3.Reset;
                                                            TRec3.SetRange(TRec3."Unit Class", ClassRec."Class Code");
                                                            TRec3.SetRange(TRec3."Campus Code", Campus);
                                                            TRec3.SetRange(TRec3."Mode of Study", ModeOfStudy);
                                                            //IF TRec3.COUNT<MaxClassWk THEN BEGIN  // Check max Unit weekly   .......
                                                            begin

                                                                TRec6.Reset;
                                                                TRec6.SetRange(TRec6.Stage, ClassRec."Unit Stage");
                                                                TRec6.SetRange(TRec6.Programme, ClassRec."Unit Programme");
                                                                TRec6.SetRange(TRec6."Campus Code", Campus);
                                                                TRec6.SetRange(TRec6."Mode of Study", ModeOfStudy);
                                                                //IF TRec6.COUNT<10 THEN BEGIN  // Check max Class Daily

                                                                begin
                                                                    TRec4.Reset;
                                                                    TRec4.SetRange(TRec4.Lecturer, ClassRec.LecturerCode);
                                                                    TRec4.SetRange(TRec4.Period, LessonRec.Code);
                                                                    TRec4.SetRange(TRec4."Day of Week", DayRec.Day);
                                                                    TRec4.SetRange(TRec4."Campus Code", Campus);
                                                                    TRec4.SetRange(TRec4."Mode of Study", ModeOfStudy);
                                                                    //TRec4.SETRANGE(TRec4."Campus Code",Campus);
                                                                    //IF TRec4.COUNT<1 THEN BEGIN  // Check the lecturer conflict
                                                                    begin
                                                                        TRec5.Reset;
                                                                        TRec5.SetRange(TRec5.Programme, ClassRec."Programme Code");
                                                                        TRec5.SetRange(TRec5.Stage, ClassRec."Stage Code");
                                                                        TRec5.SetRange(TRec5.Period, LessonRec.Code);
                                                                        TRec5.SetRange(TRec5."Day of Week", DayRec.Day);
                                                                        TRec5.SetRange(TRec5."Campus Code", Campus);
                                                                        TRec5.SetRange(TRec5."Mode of Study", ModeOfStudy);
                                                                        if TRec5.Count < 1 then begin  // Check the class conflict   ......

                                                                            //BEGIN
                                                                            //IF ClassRec."Unit Code"='SMA 2100' THEN ERROR('Test2');
                                                                            // IF LecRooms."Reserve For Unit"<>ClassRec."Unit Code" THEN BEGIN
                                                                            // IF CheckClassSize(ClassRec."Unit Code",LecRooms.Code,SemCode,Campus)=TRUE THEN BEGIN


                                                                            InsertRandom(ClassRec."Unit Code", SemCode, DayRec.Day, LessonRec.Code, LecRooms.Code, ClassRec.LecturerCode, ClassRec."Unit Code"
                                                                           + '[' + Format(ClassRec."Class Size") + '] ' + ClassRec.Lecturer + ' ' + LecRooms.Code, ClassRec."Programme Code", ClassRec."Stage Code",
                                                                           ClassRec."Class Code", Campus, Type, ModeOfStudy);
                                                                            //  END;
                                                                            // END;
                                                                        end;
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        until DayRec.Next = 0;
                                    end;

                                until LessonRec.Next = 0;
                            end;

                        until ClassRec.Next = 0;
                    end;
                end;

            until LecRooms.Next = 0;
        end;
    end;

    procedure CheckClassSize(Unit: Code[20]; Room: Code[20]; Sem: Code[20]; Campus: Code[20]) Allowed: Boolean
    var
        LectUnits: Record "Lecturers Units";
        LecRoom: Record "Lecture Room";
        ClassSize: Integer;
        RoomSize: Integer;
    begin
        ClassSize := 0;
        RoomSize := 0;
        Allowed := true;
        LectUnits.Reset;
        LectUnits.SetRange(LectUnits.Unit, Unit);
        LectUnits.SetRange(LectUnits.Semester, Sem);
        LectUnits.SetRange(LectUnits."Campus Code", Campus);
        if LectUnits.Find('-') then begin
            ClassSize := LectUnits."Class Size";
        end;
        LecRoom.Reset;
        LecRoom.SetRange(LecRoom.Code, Room);
        if LecRoom.Find('-') then begin
            RoomSize := LecRoom."Maximum Capacity"
        end;
        if ClassSize > RoomSize then
            Allowed := false;
    end;

    procedure CheckTTUnitCode(UnitCode: Code[20]; ProgCode: Code[20]) TTUnitCode: Code[20]
    var
        UnitRec: Record "Units/Subjects";
    begin
        UnitRec.Reset;
        UnitRec.SetRange(UnitRec.Code, UnitCode);
        UnitRec.SetRange(UnitRec."Programme Code", ProgCode);
        UnitRec.SetFilter(UnitRec."Time Table Code", '<>%1', '');
        if UnitRec.Find('-') then
            TTUnitCode := UnitRec."Time Table Code";
    end;

    procedure InsertRandom(UnitCode: Code[20]; SemCode: Code[20]; DayCode: Code[20]; LessonCode: Code[20]; RoomCode: Code[20]; LecturerCode: Code[50]; ClassName: Code[50]; ProgCode: Code[20]; StageCode: Code[20]; UnitClass: Code[100]; CampusCode: Code[20]; Type: Option Teaching,Exam; ModeOfStudy: Code[20])
    var
        TT: Record "Time Table";
        CMaster: Record "Courses Master";
    begin
        TT.Init;
        TT.Programme := ProgCode;
        TT.Stage := StageCode;
        TT.Unit := UnitCode;
        TT.Semester := SemCode;
        TT.Period := LessonCode;
        TT."Day of Week" := DayCode;
        TT."Lecture Room" := RoomCode;
        TT.Lecturer := LecturerCode;
        TT.Class := ClassName;
        TT."Unit Class" := UnitClass;
        TT."Campus Code" := CampusCode;
        TT.Auto := true;
        TT.Type := Type;
        TT."Mode of Study" := ModeOfStudy;
        if Cmaster.get(UnitCode) then begin
            TT."No of Units" := Cmaster.Units;
            TT."Unit Type" := Cmaster."Unit Type";
        end;
        TT.Insert;
    end;
}

