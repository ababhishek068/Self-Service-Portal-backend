Page 50014 "Class Attendance Card"
{
    PageType = Card;
    SourceTable = "Class Attendance Header.";
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
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(ProgrameCode; Rec."Programe Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programe Code field.';
                }
                field(StageCode; Rec."Stage Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field(SemesterCode; Rec."Semester Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester Code field.';
                }
                field(UnitCode; Rec."Unit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Code field.';
                }
                field(WeekCode; Rec."Week Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Week Code field.';
                }
                field("Lesson Hours"; Rec."Lesson Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lesson Hours field.';
                }
                field(LecturerCode; Rec."Lecturer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer Code field.';
                    // LookupPageID = "Lecturer List";
                }
                field("Present Count"; Rec."Present Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Present Count field.';
                }
                field("Absent Count"; Rec."Absent Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Absent Count field.';
                }
                field(Section; Rec.Section)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Section field.';
                }
                field("Day Code"; Rec."Day Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Day Code field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Suggest Lines")
            {
                ApplicationArea = Basic;
                Image = SuggestCapacity;
                ToolTip = 'Executes the Suggest Lines action.';

                trigger OnAction()
                begin
                    ClassAt.Reset;
                    if Rec."Programe Code" <> '' then
                        ClassAt.SetRange(ClassAt."Programe Code", Rec."Programe Code");
                    //ClassAt.SETRANGE(ClassAt."Stage Code","Stage Code");
                    ClassAt.SetRange("Semester Code", ClassAt."Semester Code");
                    ClassAt.SetRange(ClassAt."Week Code", Rec."Week Code");
                    ClassAt.SetRange(ClassAt."Unit Code", Rec."Unit Code");
                    ClassAt.SetRange(ClassAt."Lecturer Code", Rec."Lecturer Code");
                    ClassAt.SetRange(ClassAt."Campus Code", Rec."Campus Code");
                    ClassAt.SetRange(ClassAt.Section, Rec.Section);
                    if ClassAt.Count > 1 then Error('Please note that the selected class attendance already exists');


                    ClassLines.Reset;
                    ClassLines.SetRange(ClassLines.Code, Rec.Code);

                    if ClassLines.Find('-') then
                        if Confirm('Do you want to replace the existing lines?') = false then
                            Error('Aborted')
                        else
                            ClassLines.DeleteAll;


                    StudUnits.Reset;
                    if Rec."Programe Code" <> '' then
                        StudUnits.SetRange(StudUnits.Programme, Rec."Programe Code");
                    // StudUnits.SETRANGE(StudUnits.Stage,"Stage Code");
                    StudUnits.SetRange(StudUnits.Unit, Rec."Unit Code");
                    StudUnits.SetRange(StudUnits.Semester, Rec."Semester Code");
                    StudUnits.SetRange(StudUnits."Campus Code", Rec."Campus Code");
                    StudUnits.SETRANGE(StudUnits."Unit Class Code", Rec.Section);
                    StudUnits.SetFilter("Cust Exist", '>%1', 0);
                    if StudUnits.Find('-') then begin
                        repeat
                            ClassLines.Init;
                            ClassLines.Code := Rec.Code;
                            ClassLines."Student No" := StudUnits."Student No.";
                            ClassLines."Lecturer Code" := Rec."Lecturer Code";
                            ClassLines.Validate(ClassLines."Student No");
                            ClassLines.Insert(true);
                        until StudUnits.Next = 0;
                    end;
                    Message('Lines Created Successfully');
                end;
            }
            action(Lines)
            {
                ApplicationArea = Basic;
                Image = Line;
                Promoted = true;
                RunObject = Page "Class Attendance Lines";
                RunPageLink = Code = field(Code);
                ToolTip = 'Executes the Lines action.';
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post Attendance';
                Image = PostDocument;
                Promoted = true;
                ToolTip = 'Executes the Post Attendance action.';
                trigger OnAction()
                begin
                    if Confirm('Do you really want to post the attendance?') then begin
                        Rec.posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Posting Date" := today;
                        Rec.modify;
                    end;
                end;
            }
        }
    }

    var
        ClassLines: Record "Class Attendance Lines";
        StudUnits: Record "Student Units";
        ClassAt: Record "Class Attendance Header.";
}

