Page 50098 "Programme Option"
{
    PageType = List;
    SourceTable = "Programme Options";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Desription; Rec.Desription)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Desription field.';
                }
                field(GraduationUnits; Rec."Graduation Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Graduation Units field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(StageCode; Rec."Stage Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field(MinimumPassCores; Rec."Minimum Pass Cores")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Pass Cores field.';
                }
                field("Minimum Gen. Elective"; Rec."Minimum Gen. Elective")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Gen. Elective field.';
                }
                field("Minimum Pass Free Elective"; Rec."Minimum Pass Free Elective")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Pass Free Elective field.';
                }
                field(MinmumPassAll; Rec."Minmum Pass All")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minmum Pass All field.';
                }
                field(RequiredUnit1; Rec."Required Unit1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Unit1 field.';
                }
                field(RequiredUnit2; Rec."Required Unit2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Unit2 field.';
                }
                field(RegisteredStudents; Rec."Registered Students")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registered Students field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Update Student Options")
            {
                ApplicationArea = Basic;
                Image = Allocations;
                ToolTip = 'Executes the Update Student Options action.';

                trigger OnAction()
                begin
                    Rec.TestField("Required Unit1");
                    Rec.TestField("Required Unit2");
                    StudUnits.Reset;
                    StudUnits.SetRange(Programme, Rec."Programme Code");
                    StudUnits.SetRange(Unit, Rec."Required Unit1");
                    if StudUnits.Find('-') then begin
                        repeat
                            StudUnits2.Reset;
                            StudUnits2.SetRange(Programme, Rec."Programme Code");
                            StudUnits2.SetRange("Student No.", StudUnits."Student No.");
                            StudUnits2.SetRange(Unit, Rec."Required Unit2");
                            if StudUnits2.Find('-') then begin
                                Creg.Reset;
                                Creg.SetRange("Student No.", StudUnits2."Student No.");
                                // Creg.SetFilter("Current Sem", '%1', false);
                                if Creg.Find('-') then begin
                                    repeat
                                        Creg.Options := Rec.Code;
                                        Creg.Modify;
                                    until Creg.Next = 0;
                                end;
                            end;
                        until StudUnits.Next = 0;
                    end;
                    Message('Completed Successfully');
                end;
            }
        }
    }

    var
        Creg: Record "Course Registration";
        StudUnits: Record "Student Units";
        StudUnits2: Record "Student Units";
}

