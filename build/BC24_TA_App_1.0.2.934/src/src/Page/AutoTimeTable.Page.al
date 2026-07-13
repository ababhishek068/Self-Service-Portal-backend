Page 50953 "Auto Time Table"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Time Table Header";
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
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field(ModeofStudy; Rec."Mode of Study")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mode of Study field.';
                }
                field(MaxHoursContiniously; Rec."Max Hours Continiously")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Hours Continiously field.';
                }
                field(MaxHoursWeekly; Rec."Max Hours Weekly")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Hours Weekly field.';
                }
                field(MaxDaysPerWeek; Rec."Max Days Per Week")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Days Per Week field.';
                }
                field(MaxLecturerHoursDaily; Rec."Max Lecturer Hours Daily")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Lecturer Hours Daily field.';
                }
                field(MaxLecturerDaysPerWeek; Rec."Max Lecturer Days Per Week")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Lecturer Days Per Week field.';
                }
                field(MaxClassCapacity; Rec."Max Class Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Class Capacity field.';
                }
                field(MaxClassWeekly; Rec."Max Class Weekly")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Class Weekly field.';
                }

                field(Released; Rec.Released)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released field.';
                }
                field(ReleasedBy; Rec."Released By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released By field.';
                }
                field(ReleasedOn; Rec."Released On")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released On field.';
                }
                field(LastOpenedBy; Rec."Last Opened By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Opened By field.';
                }
                field(LastOpenedOn; Rec."Last Opened On")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Opened On field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Generate Teaching Time Table")
            {
                ApplicationArea = Basic;
                Image = "Action";
                Promoted = true;
                ToolTip = 'Executes the Generate Teaching Time Table action.';

                trigger OnAction()
                begin
                    GenSetup.get;
                    Rec.TestField(Released, false);
                    // if GenSetup."Manual Class Generation" = false then
                    TTRandom.GenerateClass(Rec.Semester, Rec."Max Class Capacity", Rec.Campus, Type::Teaching, Rec."Mode of Study");
                    TTRandom.GenerateTT_Reserved(Rec."Max Class Weekly", Rec.Semester, Rec.Campus, Type::Teaching, Rec."Mode of Study");
                    TTRandom.GenerateTT_Others(Rec."Max Class Weekly", Rec.Semester, Rec.Campus, Type::Teaching, Rec."Mode of Study");
                    Message('Processing Completed. ');
                end;
            }
            separator(Action32) { }
            action("Generate Exams Time Table")
            {
                ApplicationArea = Basic;
                Image = TestFile;
                ToolTip = 'Executes the Generate Exams Time Table action.';

                trigger OnAction()
                begin

                    Rec.TestField(Released, false);
                    TTRandom.GenerateClass(Rec.Semester, Rec."Max Class Capacity", Rec.Campus, Type::Exam, Rec."Mode of Study");
                    TTRandom.GenerateTT_Reserved(Rec."Max Class Weekly", Rec.Semester, Rec.Campus, Type::Exam, Rec."Mode of Study");
                    TTRandom.GenerateTT_Others(Rec."Max Class Weekly", Rec.Semester, Rec.Campus, Type::Exam, Rec."Mode of Study");
                    Message('Done');
                end;
            }
            separator(Action30) { }
            action("Clear Teaching Time Table")
            {
                ApplicationArea = Basic;
                Image = ClearLog;
                ToolTip = 'Executes the Clear Teaching Time Table action.';

                trigger OnAction()
                begin

                    Rec.TestField(Released, false);
                    TTRandom.ClearCurrentTimeTable(Rec.Semester, Rec.Campus, Type::Teaching);
                end;
            }
            separator(Action27) { }
            action("Clear Exams Time Table")
            {
                ApplicationArea = Basic;
                Image = CancelAllLines;
                ToolTip = 'Executes the Clear Exams Time Table action.';

                trigger OnAction()
                begin
                    Rec.TestField(Released, false);
                    TTRandom.ClearCurrentTimeTable(Rec.Semester, Rec.Campus, Type::Exam);
                end;
            }
            separator(Action25) { }
            action(Release)
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Release action.';

                trigger OnAction()
                begin
                    Rec.TestField(Released, false);
                    if Confirm('Do you really want to release the time table?') = true then begin
                        TT.Reset;
                        TT.SetRange(TT.Semester, Rec.Semester);
                        TT.SetRange(TT."Campus Code", Rec.Campus);
                        if TT.Find('-') then begin
                            repeat
                                TT.Released := true;
                                TT.Modify;
                            until TT.Next = 0;
                        end;
                        Rec.Released := true;
                        Rec."Last Opened By" := UserId;
                        Rec."Last Opened On" := Today;
                        Rec.Modify;

                    end;
                end;
            }
            separator(Action23) { }
            action("Re Open")
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Re Open action.';

                trigger OnAction()
                begin

                    Rec.TestField(Released, true);
                    if Confirm('Do you really want to re-open the time table?') = true then begin
                        TT.Reset;
                        TT.SetRange(TT.Semester, Rec.Semester);
                        TT.SetRange(TT."Campus Code", Rec.Campus);
                        if TT.Find('-') then begin
                            repeat
                                TT.Released := false;
                                TT.Modify;
                            until TT.Next = 0;
                        end;
                        Rec.Released := false;
                        Rec."Last Opened By" := UserId;
                        Rec."Last Opened On" := Today;
                        Rec.Modify;

                    end;
                end;
            }
            separator(Action21) { }

            separator(Action19) { }
            action("Allocate Combined Units")
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Allocate Combined Units action.';

                trigger OnAction()
                begin
                    UpdateCommonUnits;
                end;
            }
            separator(Action17) { }
            action("Update Reserved Rooms")
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Update Reserved Rooms action.';

                trigger OnAction()
                begin
                    ClassRec.Reset;
                    ClassRec.SetFilter(ClassRec."Reserved Room", '<>%1', '');
                    if ClassRec.Find('-') then begin
                        repeat
                            TT.Reset;
                            TT.SetRange(TT."Unit Class", ClassRec."Class Code");
                            if TT.Find('-') then begin
                                repeat
                                    TT."Lecture Room" := ClassRec."Reserved Room";
                                    TT.Modify;
                                until TT.Next = 0;
                            end;
                        until ClassRec.Next = 0;
                    end;
                    Message('Done');
                end;
            }
        }
    }

    var
        TTRandom: Codeunit "Time Table";
        TT: Record "Time Table";
        Type: Option Teaching,Exam;
        ClassRec: Record "Class Setups";
        GenSetup: Record "General Set-Up";

    procedure UpdateCommonUnits()
    var
        UnitsRec: Record "Units/Subjects";
        TT: Record "Time Table";
        TT2: Record "Time Table";
    begin
        UnitsRec.Reset;
        UnitsRec.SetFilter(UnitsRec."Time Table Code", '<>%1', '');
        //UnitsRec.SETRANGE(UnitsRec.Code,'SPM 1171');
        UnitsRec.SetFilter(UnitsRec."Semester Filter", Rec.Semester);
        // UnitsRec.SETFILTER(UnitsRec."Time Tabled Us Count",'%1',0);
        UnitsRec.SetRange(UnitsRec."Time Table", true);
        if UnitsRec.Find('-') then begin
            repeat
                UnitsRec.CalcFields(UnitsRec."TT Used Count");
                if UnitsRec."TT Used Count" = 0 then begin
                    //  if UnitsRec.Code='SPM 1171' then begin
                    TT.Reset;
                    // TT.setrange(TT.Programme,UnitsRec."Programme Code");
                    TT.SetRange(TT.Stage, UnitsRec."Stage Code");
                    TT.SetRange(TT.Unit, UnitsRec."Time Table Code");
                    TT.SetRange(TT.Semester, Rec.Semester);
                    TT.SetRange(TT."Campus Code", Rec.Campus);
                    if TT.Find('-') then begin
                        TT2.Init;
                        TT2.Programme := UnitsRec."Programme Code";
                        TT2.Stage := UnitsRec."Stage Code";
                        TT2.Unit := UnitsRec."Time Table Code";
                        TT2.Semester := Rec.Semester;
                        TT2.Period := TT.Period;
                        TT2."Day of Week" := TT."Day of Week";
                        TT2."Lecture Room" := TT."Lecture Room";
                        TT2.Class := TT.Class + '-' + UnitsRec."Programme Code";
                        TT2.Lecturer := TT.Lecturer;
                        TT2."Unit Class" := TT."Unit Class";
                        TT2."Campus Code" := TT."Campus Code";
                        TT2.Auto := true;
                        TT2."Programme Option" := 'A2';
                        TT2.Insert;
                    end;
                end;
            until UnitsRec.Next = 0;
        end;
        Message('Done');
    end;
}

