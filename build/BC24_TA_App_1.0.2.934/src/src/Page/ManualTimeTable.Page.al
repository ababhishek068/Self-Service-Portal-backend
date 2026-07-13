Page 50365 "Manual Time Table"
{
    PageType = List;
    SourceTable = "Time Table";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Unit; Rec.Unit)
                {
                    caption = 'Course Code';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Course Code field.';
                }
                field(DayofWeek; Rec."Day of Week")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day of Week field.';
                }
                field("Campus Code"; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }

                field("Unit Description"; Rec."Unit Description")
                {
                    caption = 'Course Description';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Course Description field.';
                }
                field("Unit Class"; Rec."Unit Class")
                {
                    caption = 'Section';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Section field.';
                }

                field("Lecture Room"; Rec."Lecture Room")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecture Room field.';
                }

                field(Lecturer; Rec.Lecturer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer field.';
                    trigger OnValidate()
                    begin
                        //Check lecturer conflict
                        LecUnitsTaken.Reset;
                        LecUnitsTaken.SetRange(LecUnitsTaken.Semester, Rec.Semester);
                        LecUnitsTaken.SetRange(LecUnitsTaken.Lecturer, LecUnits.Lecturer);
                        if LecUnitsTaken.Find('-') then begin
                            repeat
                                TTable2.Reset;
                                TTable2.SetRange(TTable2.Released, false);
                                TTable2.SetRange(TTable2.Programme, LecUnitsTaken.Programme);
                                TTable2.SetRange(TTable2.Stage, LecUnitsTaken.Stage);
                                TTable2.SetRange(TTable2.Unit, LecUnitsTaken.Unit);
                                TTable2.SetRange(TTable2.Semester, Rec.Semester);
                                TTable2.SetRange(TTable2.Period, Rec.Period);
                                TTable2.SetRange(TTable2."Day of Week", Rec."Day of Week");
                                TTable2.SetRange(TTable2.Class, Rec.Class);
                                TTable2.SetRange(TTable2."Unit Class", Rec."Unit Class");
                                if TTable2.Find('-') then begin
                                    if Confirm('Lecturer occupied at the specified period/lesson. Do you wish to create a combined lesson?') = false then
                                        exit;
                                end;
                            until LecUnitsTaken.Next = 0

                        end;
                    end;
                }
                field("Lecturer Name"; Rec."Lecturer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lecturer Name field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period field.';
                }

                field(RoomType; Rec."Room Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Type field.';
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Type field.';
                }
                field("No of Units"; Rec."No of Units")
                {
                    caption = 'Credit Hours';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Credit Hours field.';
                }

                field(LectureRoom; Rec."Lecture Room")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecture Room field.';

                    trigger OnValidate()
                    begin

                        //Check room reservation
                        LecRooms.Reset;
                        LecRooms.SetRange(LecRooms.Code, Rec."Lecture Room");
                        if LecRooms.Find('-') then begin
                            if LecRooms."Reserve For" <> '' then begin
                                Prog.Reset;
                                Prog.SetRange(Prog.Code, Rec.Programme);


                            end;


                            //Check student availability
                            /*
                            TTable2.RESET;
                            TTable2.SETRANGE(TTable2.Released,FALSE);
                            TTable2.SETRANGE(TTable2.Programme,"Programme Code");
                            TTable2.SETRANGE(TTable2.Stage,"Stage Code");
                            TTable2.SETRANGE(TTable2.Semester,GETFILTER("Semester Filter"));
                            TTable2.SETRANGE(TTable2."Day of Week",GETFILTER("Day Filter"));
                            TTable2.SETRANGE(TTable2.Period,CurrForm.Matrix.MatrixRec.Code);
                            TTable2.SETRANGE(TTable2.Class,GETFILTER("Class Filter"));
                            IF TTable2.FIND('-') THEN
                            ERROR('Class already allocated a class at this time.');
                            */


                            TTable2.Reset;
                            TTable2.SetRange(TTable2.Released, false);
                            TTable2.SetRange(TTable2.Semester, Rec.Semester);
                            TTable2.SetRange(TTable2.Period, Rec.Period);
                            TTable2.SetRange(TTable2."Day of Week", Rec."Day of Week");
                            TTable2.SetRange(TTable2."Lecture Room", Rec."Lecture Room");
                            if TTable2.Find('-') then begin
                                if Confirm('Lecture room occupied at the specified period/lesson. Do you wish to create a combined lesson?') = false then
                                    exit;
                            end;


                            LecUnits.Reset;
                            LecUnits.SetRange(LecUnits.Programme, Rec.Programme);
                            LecUnits.SetRange(LecUnits.Stage, Rec.Stage);
                            LecUnits.SetRange(LecUnits.Unit, Rec.Unit);
                            LecUnits.SetRange(LecUnits.Semester, Rec.Semester);
                            //LecUnits.SETRANGE(LecUnits.Class,Class);
                            //LecUnits.SETRANGE(LecUnits."Unit Class","Unit Class");
                            if LecUnits.Find('-') then begin
                                //Check contract hours
                                LecUnits.CalcFields(LecUnits."Time Table Hours");
                                if LecUnits."No. Of Hours Contracted" < (LecUnits."Time Table Hours" + Lessons."No Of Hours") then begin
                                    if Confirm('Lecturers contracted hours will be exceded. Do you wish to continue?') = false then
                                        exit;
                                end;

                                //Check availability
                                if (Lessons."Start Time" < LecUnits."Available From") or (Lessons."End Time" > LecUnits."Available To") then begin
                                    if Confirm('Lecturer not available at this time as per the contract. Do you wish to continue?') = false then
                                        exit;
                                end;


                            end;


                            TTable2.Reset;
                            TTable2.SetRange(TTable2.Released, false);
                            TTable2.SetRange(TTable2.Programme, Rec.Programme);
                            TTable2.SetRange(TTable2.Stage, Rec.Stage);
                            TTable2.SetRange(TTable2.Unit, Rec.Unit);
                            TTable2.SetRange(TTable2.Semester, Rec.Semester);
                            TTable2.SetRange(TTable2."Day of Week", Rec.Period);
                            TTable2.SetRange(TTable2.Class, Rec.Class);
                            TTable2.SetRange(TTable2."Unit Class", Rec."Unit Class");
                            TTable2.SetRange(TTable2.Exam, Rec.Exam);
                            if TTable2.Count > 3 then
                                Error('You can not have more than 3 lessons in a day');


                            /*
                            IF "Students Registered" < Capacity THEN
                            MESSAGE('Student registered less than the Minimum capacity for this room.');

                            IF "Students Registered" > Capacity2 THEN
                            MESSAGE('Student registered more than the Maximum capacity for this room.');
                            */

                        end;

                    end;
                }
                field("Students Count"; Rec."Students Count")
                {
                    Caption = 'Registered Students';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registered Students field.';
                }
                field("Class Size"; Rec."Class Size")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Size field.';
                }
                field("Multi Campus"; Rec."Multi Campus")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Multi Campus field.';
                }
                field("Unit Department"; Rec."Unit Department")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit Department field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {


            action(Reschedule)
            {
                Caption = 'Reschedule class';
                ApplicationArea = basic;
                Promoted = true;
                Image = RefreshExcise;
                ToolTip = 'Executes the Reschedule class action.';
                trigger OnAction()
                var
                    TimeTable: Record "Time Table";
                begin
                    //REPORT.Run(50004, true, true, xRec);
                    Rec.TestField(Cancelled, false);
                    TimeTable.Reset();
                    TimeTable.SetRange(Unit, Rec.Unit);
                    TimeTable.SetRange(Semester, Rec.Semester);
                    TimeTable.SetRange("Unit Class", Rec."Unit Class");
                    TimeTable.SetRange("Campus Code", Rec."Campus Code");
                    if TimeTable.Find('-') then begin
                        REPORT.Run(50004, true, true, TimeTable);
                    end;
                end;
            }
            action(CancelClass)
            {
                caption = 'Cancel Class';
                ApplicationArea = basic;
                image = Cancel;
                ToolTip = 'Executes the Cancel Class action.';
                trigger OnAction()
                var
                    Counter: Integer;
                    studentUnits: record "Student Units";
                //  webportal: Codeunit Webportal;
                begin
                    Counter := 1;
                    Rec.TestField(Cancelled, false);
                    Rec.CalcFields("Students Count");

                    if Confirm('There are students registered to this unit. Are you sure you want to delete this unit from the Timetable?', true) = true then begin
                        studentUnits.Reset();
                        studentUnits.SetRange(Unit, Rec.Unit);
                        studentUnits.SetRange(Semester, Rec.Semester);
                        studentUnits.SetRange("Unit Class Code", Rec."Unit Class");
                        studentUnits.SetRange("Campus", Rec."Campus Code");
                        if studentUnits.Find('-') then begin
                            repeat
                                //webportal.DropStudentUnits(studentUnits."Student No.", studentUnits.Semester, studentUnits.Stage, studentUnits.Programme, studentUnits.Unit, true);
                                Counter := Counter + 1;
                            until studentUnits.Next() = 0;
                        end;
                        Rec.Cancelled := true;
                        Rec."Cancelled By" := UserId;
                        Rec."Cancelled Date" := today;
                        Rec.modify;

                        Message(format(Counter) + ' student affected');
                        // end;
                    end;
                end;

            }

        }
    }

    var
        LecUnits: Record "Lecturers Units";
        LecUnitsTaken: Record "Lecturers Units";
        TTable2: Record "Time Table";
        LecRooms: Record "Lecture Room";
        Lessons: Record Lessons;
        Prog: Record Programme;
}

