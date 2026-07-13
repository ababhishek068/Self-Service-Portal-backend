page 50035 "Class Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Class Setups";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Class Code"; Rec."Class Code")
                {
                    caption = 'Section';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Section field.';

                }
                field("Class Size"; Rec."Class Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class Size field.';

                }
                field(Lecturer; Rec.Lecturer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lecturer field.';
                }

            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateLecture)
            {
                ApplicationArea = All;
                Caption = 'Update Lecturer Units';
                Image = UpdateDescription;
                ToolTip = 'Executes the Update Lecturer Units action.';
                trigger OnAction();
                var
                    Sem: Record Semesters;
                    Lect: Record "Lecturers Units";
                    ClassRec: record "Class Setups";
                begin
                    sem.reset;
                    sem.setrange("Current Semester", true);
                    if sem.find('-') then;

                    ClassRec.reset;
                    ClassRec.setrange("Unit Code", Rec."Unit Code");
                    if ClassRec.find('-') then begin
                        repeat
                            if ClassRec.Lecturer <> '' then begin
                                Lect.reset;
                                lect.setrange(lect.Lecturer, Rec.Lecturer);
                                lect.setrange(lect.Unit, Rec."Unit Code");
                                lect.setrange(lect.Semester, Sem.code);
                                if not lect.find('-') then begin
                                    Lect.init;
                                    lect.Lecturer := Rec.Lecturer;
                                    lect.Unit := Rec."Unit Code";
                                    lect.Semester := sem.code;
                                    lect.Class := Rec."Class Code";
                                    Lect.Programme := Rec."Programme Code";
                                    lect.insert;
                                end;
                            end;
                        until ClassRec.next = 0;
                    end;
                    message('Lecturers updated succesfully');
                end;



            }
        }
    }
}