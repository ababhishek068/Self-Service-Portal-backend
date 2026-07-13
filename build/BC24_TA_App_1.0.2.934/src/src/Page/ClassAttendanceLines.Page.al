Page 50013 "Class Attendance Lines"
{
    PageType = List;
    SourceTable = "Class Attendance Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StudentNo; Rec."Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No field.';
                }
                field(Attendance; Rec.Attendance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendance field.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(AttendanceType; Rec."Attendance Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendance Type field.';
                }

            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Mark All As Present")
            {
                ApplicationArea = Basic;
                Image = Lock;
                Promoted = true;
                ToolTip = 'Executes the Mark All As Present action.';

                trigger OnAction()
                begin

                    if Confirm('Do you really want to mark all the records as Present?', false) then begin
                        AttLines.Reset;
                        AttLines.SetRange(AttLines.Code, Rec.Code);
                        if AttLines.Find('-') then begin
                            repeat
                                AttLines."Attendance Type" := 1;
                                AttLines.Validate("Attendance Type");
                                AttLines.Modify
                            until AttLines.Next = 0;
                        end;
                    end;
                end;
            }
            action("Mark All As Absent")
            {
                ApplicationArea = Basic;
                Image = Absence;
                Promoted = true;
                ToolTip = 'Executes the Mark All As Absent action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to mark all the records as Absent?', false) then begin
                        AttLines.Reset;
                        AttLines.SetRange(AttLines.Code, Rec.Code);
                        if AttLines.Find('-') then begin
                            repeat
                                AttLines."Attendance Type" := 0;
                                AttLines.Validate("Attendance Type");
                                AttLines.Modify
                            until AttLines.Next = 0;
                        end;
                    end;
                end;
            }
            separator(Action16) { }
            action("Mark Lecturer As Present")
            {

                Image = Lock;
                Promoted = true;
                ToolTip = 'Executes the Mark Lecturer As Present action.';

                trigger OnAction()
                begin

                    if Confirm('Do you really want to mark Lecturer as Present?', false) then begin
                        AttLines.Reset;
                        AttLines.SetRange(AttLines.Code, Rec.Code);
                        if AttLines.Find('-') then begin
                            repeat
                                AttLines."Lecturer Present" := true;
                                AttLines.Validate("Attendance Type");
                                AttLines.Modify
                            until AttLines.Next = 0;
                        end;
                    end;
                end;
            }
            action("Mark Lecturer As Absent")
            {

                Image = Absence;
                Promoted = true;
                ToolTip = 'Executes the Mark Lecturer As Absent action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to mark Lecturer as Absent?', false) then begin
                        AttLines.Reset;
                        AttLines.SetRange(AttLines.Code, Rec.Code);
                        if AttLines.Find('-') then begin
                            repeat
                                AttLines."Lecturer Absent" := true;
                                AttLines.Validate("Attendance Type");
                                AttLines.Modify
                            until AttLines.Next = 0;
                        end;
                    end;
                end;
            }
            separator(Action10) { }
            action("Get Biometric Attendance")
            {
                ApplicationArea = Basic;
                Image = DataEntry;
                RunObject = Report "Biometric Entries";
                ToolTip = 'Executes the Get Biometric Attendance action.';
            }
        }
    }

    var
        AttLines: Record "Class Attendance Lines";
}

