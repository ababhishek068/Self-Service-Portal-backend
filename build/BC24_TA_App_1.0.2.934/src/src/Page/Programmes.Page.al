Page 50099 Programmes
{
    PageType = Card;
    SourceTable = Programme;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Main Programme Code"; Rec."Main Programme Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Main Programme Code field.';
                }
                field("Programme Cluster"; Rec."Programme Cluster")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Cluster field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(School; Rec."School Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'School Code';
                    ToolTip = 'Specifies the value of the School Code field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(MinimumCapacity; Rec."Minimum Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Capacity field.';
                }
                field(MaximumCapacity; Rec."Maximum Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maximum Capacity field.';
                }
                field(MinNoofCourses; Rec."Min No. of Courses")
                {
                    Caption = 'Min.Credits Per Semester';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Min.Credits Per Semester field.';
                }
                field(MaxNoofCourses; Rec."Max No. of Courses")
                {
                    Caption = 'Max. Credits Per Semester';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max. Credits Per Semester field.';
                }
                field(MinimumUnitsPerYear; Rec."Minimum Units Per Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Units Per Year field.';
                }

                field(MinimumGrade; Rec."Minimum Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Grade field.';
                }
                field(MinimumPoints; Rec."Minimum Points")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Points field.';
                }
                field(ExamCategory; Rec."Exam Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Category field.';
                }
                field(TimeTable; Rec."Time Table")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Table field.';
                }
                field(StudentRegistered; Rec."Student Registered")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Registered field.';
                }
                field(ProgrammeUnits; Rec."Programme Units")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Programme Units field.';
                }
                field(GraduationUnits; Rec."Graduation Units")
                {
                    Caption = 'Min. Graduation Credits';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Min. Graduation Credits field.';
                }
                field(MinPassUnits; Rec."Min Pass Units")
                {
                    Caption = 'Min. Core Units';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Min. Core Units field.';
                }
                field("Minimum Free Electives"; Rec."Minimum Free Electives")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Free Electives field.';
                }
                field("Minimum Gen. Education Electives"; Rec."Minimum Gen. Education Electives")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Gen. Education Electives field.';
                }

                field("Minimum Class Attendance %"; Rec."Minimum Class Attendance %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Class Attendance % field.';
                }

                field("Billing By"; Rec."Billing By")
                {
                    Caption = 'Billing Method';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Billing Method field.';
                }
                field(RetakeChargeCode; Rec."Retake Charge Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retake Charge Code field.';
                }
                field(UnitFee; Rec."Unit Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Fee field.';
                }
                field(EntryTutionFees; Rec."Entry Tution Fees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry Tution Fees field.';
                }
                field(EntryCharges; Rec."Entry Charges")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry Charges field.';
                }
                field(ReleaseOnlineResults; Rec."Release Online Results")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Release Online Results field.';
                }
                field("Programme Duration"; Rec."Programme Duration(Y)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Duration(Y) field.';
                }
                field("Programme Duration Code"; Rec."Programme Duration Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Duration Code field.';
                }
                field("Short Course"; Rec."Short Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Short Course field.';
                }
                field("Application Fee Charge Code"; Rec."Application Fee Charge Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Application Fee Charge Code field.';
                }
                field(OldCarriculum; Rec."Old Carriculum")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Old Carriculum field.';
                }
                field(OldCode; Rec."Old Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Old Code field.';
                }
                field(FinalRemark; Rec."Final Remark")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Remark field.';
                }
                field("Career Prospect"; Rec."Career Prospect")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Career Prospect field.';
                }
                field("Admissions Letter Report ID"; Rec."Admissions Letter Report ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admissions Letter Report ID field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {

            action(Semesters)
            {
                ApplicationArea = Basic;
                Caption = 'Semesters';
                Ellipsis = true;
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Programme Semesters";
                RunPageLink = "Programme Code" = field(Code);
                ToolTip = 'Executes the Semesters action.';
            }
            action(Stages)
            {
                ApplicationArea = Basic;
                Caption = 'Stages';
                Ellipsis = false;
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Programme Stages";
                RunPageLink = "Programme Code" = field(Code);
                ToolTip = 'Executes the Stages action.';
            }
            action(Courses)
            {
                ApplicationArea = Basic;
                Caption = 'Courses';
                Ellipsis = false;
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Units/Subjects";
                RunPageLink = "Programme Code" = field(code);
                ToolTip = 'Executes the Courses action.';
            }
            action(Courses1)
            {
                ApplicationArea = Basic;
                Caption = 'Core Units';
                Ellipsis = false;
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Units/Subjects";
                RunPageLink = "Programme Code" = field(code), "Unit Type" = filter(Core);
                ToolTip = 'Executes the Core Units action.';
            }
            action(CoreElective)
            {
                ApplicationArea = Basic;
                Caption = 'Core Elective Units';
                Ellipsis = false;
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Units/Subjects";
                RunPageLink = "Programme Code" = field(code), "Unit Type" = filter(Required);
                ;
                ToolTip = 'Executes the Core Elective Units action.';
            }
            action(GeneralElective)
            {
                ApplicationArea = Basic;
                Caption = 'General Education';
                Ellipsis = false;
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Units/Subjects";
                RunPageLink = "Programme Code" = field(code), "Unit Type" = filter("General Education");
                ToolTip = 'Executes the General Education action.';
            }




            action("Programme Campus")
            {
                ApplicationArea = Basic;
                Image = Loaner;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Programme Campus";
                RunPageLink = "Programme Code" = field(Code);
                ToolTip = 'Executes the Programme Campus action.';
            }

            action(UpdateDimension)
            {
                ApplicationArea = Basic;
                Caption = 'Update Programme Dimensions';
                Image = CheckJournal;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Update Programme Dimensions action.';
                trigger OnAction()
                var
                    DimRec: record "Dimension Value";
                    Dim: Record Dimension;
                    Prog: Record programme;
                begin
                    dim.reset;
                    dim.setrange(Code, 'PROGRAMME');
                    if not dim.find('-') then error('Please note that you must create a dimension with a code PROGRAMME');
                    prog.reset;
                    if prog.find('-') then begin
                        repeat
                            DimRec.reset;
                            dimrec.setrange(DimRec."Dimension Code", 'PROGRAMME');
                            dimrec.setrange(code, Prog.Code);
                            if not DimRec.find('-') then begin
                                DimRec.init;
                                dimrec.Code := prog.Code;
                                dimrec."Dimension Code" := 'PROGRAMME';
                                dimrec.Name := copystr(prog.Description, 1, 50);
                                DimRec.Insert;
                            end;
                        until prog.next = 0;
                    end;
                    message('Completed succesfully');
                end;
            }
            separator(Action1102760002) { }
            action(ReleaseAllocation)
            {
                ApplicationArea = Basic;
                Caption = 'Release Allocation';
                Image = Worksheet;
                ToolTip = 'Executes the Release Allocation action.';

                trigger OnAction()
                begin
                    TimeTable.Reset;
                    TimeTable.SetRange(TimeTable.Programme, Rec.Code);
                    if TimeTable.Find('-') then begin
                        repeat
                            TimeTable.Released := true;
                            TimeTable.Modify;
                        until TimeTable.Next = 0;

                    end;

                    Message('Release completed successfully.');
                end;
            }
            action(UndoReleaseAllocation)
            {
                ApplicationArea = Basic;
                Caption = 'Undo Release Allocation';
                Image = Worksheet;
                Visible = false;
                ToolTip = 'Executes the Undo Release Allocation action.';

                trigger OnAction()
                begin
                    TimeTable.Reset;
                    TimeTable.SetRange(TimeTable.Programme, Rec.Code);
                    if TimeTable.Find('-') then begin
                        repeat
                            TimeTable.Released := false;
                            TimeTable.Modify;
                        until TimeTable.Next = 0;

                    end;

                    Message('Process completed successfully.');
                end;
            }
            separator(Action1102756000) { }
            action(EntrySubjects)
            {
                ApplicationArea = Basic;
                Caption = 'Entry Subjects';
                Image = Entries;
                Promoted = true;
                RunObject = Page "Programme Entry Subjects";
                RunPageLink = Programme = field(Code);
                ToolTip = 'Executes the Entry Subjects action.';
            }

            separator(Action1102755006) { }
            action(ProgrammeOptions)
            {
                ApplicationArea = Basic;
                Caption = 'Programme Options';
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Programme Option";
                RunPageLink = "Programme Code" = field(Code);
                ToolTip = 'Executes the Programme Options action.';
            }

            separator(Action13) { }

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Category := Rec.Category::Diploma;
    end;

    var
        TimeTable: Record "Time Table";

}

