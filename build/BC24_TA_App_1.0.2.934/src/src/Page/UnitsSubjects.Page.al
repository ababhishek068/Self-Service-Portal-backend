Page 51132 "Units/Subjects"
{
    PageType = List;
    SourceTable = "Units/Subjects";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(ProgrammeCode; Rec."Programme Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Programme Code field.';
                }

                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Caption = 'Course Code';
                    ToolTip = 'Specifies the value of the Course Code field.';
                }
                field(Desription; Rec.Desription)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Desription field.';
                }
                field(NoUnits; Rec."No. Units")
                {
                    caption = 'No. of Units/Credits';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. of Units/Credits field.';
                }
                field(PredefinedUnits; Rec."Predefined Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Predefined Units field.';
                }
                field(UnitType; Rec."Unit Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Type field.';
                }
                field("Unit Category"; Rec."Unit Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Category field.';
                }
                field("Teaching Type"; Rec."Teaching Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Teaching Type field.';
                }
                field(ProgrammeOption; Rec."Programme Option")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Option field.';
                }
                field(Concentration; Rec.Concentration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Concentration field.';
                }
                field(OldUnit; Rec."Old Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Old Unit field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(StageCode; Rec."Stage Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field(ExamCode; Rec."Exam Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Code field.';
                }
                field("Max. Class Capacity"; Rec."Max. Class Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max. Class Capacity field.';
                }
                field("Charge Credit Hours"; Rec."Charge Credit Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Charge Credit Hours field.';
                }
                field(TimeTableCode; Rec."Time Table Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Table Code field.';
                }
                field(DefaultExamCategory; Rec."Default Exam Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Exam Category field.';
                }
                field(Attachment; Rec.Attachment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attachment field.';
                }
                field(RelatedCourse; Rec."Related Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Related Course field.';
                }
                field(ReservedRoom; Rec."Reserved Room")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reserved Room field.';
                }


                field(ExamOnly; Rec."Exam Only")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Only field.';
                }
                field(TimeTable; Rec."Time Table")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Table field.';
                }
                field(EstimateReg; Rec."Estimate Reg")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Estimate Reg field.';
                }
                field(NotAllocated; Rec."Not Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Not Allocated field.';
                }
                field("Ignore in Final Average"; Rec."Ignore in Final Average")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ignore in Final Average field.';
                }
                field(CommonUnit; Rec."Common Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Common Unit field.';
                }
                field("Required Credit Hours"; Rec."Required Credit Hours")
                {
                    ApplicationArea = Basic;
                    Caption = 'Credit Hours Per Week';
                    ToolTip = 'Specifies the value of the Credit Hours Per Week field.';
                }
                field(Prerequisite; Rec.Prerequisite)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prerequisite field.';
                }
                field(GLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }

                field(Research; Rec.Research)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Research field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("WithdrawUnit")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel In Current Timetable';
                Image = AdjustEntries;
                Promoted = true;
                ToolTip = 'Executes the Cancel In Current Timetable action.';
                trigger OnAction()
                var
                    StudUnit: Record "Student Units";
                    SemRec: record semesters;
                    Sem: code[20];
                    Cust: Record Customer;
                    EmailSender: Record "Email Sender";
                // WebPortal: Codeunit Webportal;
                begin
                    if confirm('Do you really want to remove the selected unit from current time table?') then begin
                        Rec.TestField("Time Table", true);
                        semRec.reset;
                        semRec.setrange("Current Semester", true);
                        if SemRec.find('-') then Sem := SemRec.code;

                        StudUnit.reset;
                        StudUnit.setrange(Unit, Rec.Code);
                        StudUnit.setrange(Programme, Rec."Programme Code");
                        StudUnit.setrange(Semester, Sem);
                        if StudUnit.find('-') then begin
                            repeat
                                cust.get(StudUnit."Student No.");
                                //   WebPortal.DropStudentUnits(StudUnit."Student No.", Sem, Studunit.stage, "Programme Code", code, true);
                                if Cust."E-Mail" <> '' then begin
                                    EmailSender.init;
                                    //  EmailSender.Category := EmailSender.Category::"Student Notification";
                                    EmailSender.code := 'Unit Withdrawal';
                                    EmailSender."Receiver Email" := cust."E-Mail";
                                    EmailSender.Subject := 'Unit ' + Rec.code + ' Withdrawal from Time table';
                                    EmailSender."Message Desc 1" := 'Dear ' + Cust.Name;
                                    EmailSender."Message Desc 1" := 'This is to inform you that Unit ' + Rec.code + ' ' + Rec.Desription + ' has been removed from the time table';
                                    EmailSender."Message Desc 3" := 'You are therefore advised to proceed and register for another unit';
                                    //EmailSender."Date Created" := today;
                                    EmailSender.insert;
                                end;
                            until StudUnit.next = 0;
                        end;
                        Message('Completed Successfully');
                    end;
                end;
            }


        }
    }
}

