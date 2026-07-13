Report 50092 "Generate Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GenerateRegistration.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = where("Customer Type" = const(Student), Blocked = const(" "));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Programme Filter", "Semester Filter", "Programme Category Filter", "Intake Filter", "Stage Filter";
            column(ReportForNavId_6836; 6836) { }
            column(Customer__No__; "No.") { }
            column(Customer_Name; Name) { }
            column(Customer_NameCaption; FieldCaption(Name)) { }
            column(Customer__No__Caption; FieldCaption("No.")) { }
            dataitem("Course Registration"; "Course Registration")
            {
                DataItemLink = "Student No." = field("No."), Semester = field("Semester Filter"), Stage = field("Stage Filter");
                DataItemTableView = where(Reversed = const(false), Posted = const(true));
                RequestFilterFields = "Fee Exist";
                column(ReportForNavId_2901; 2901) { }
            }

            trigger OnAfterGetRecord()
            begin
                RStage := '';
                StageStop := false;
                StageFound := false;

                CourseReg.Reset;
                CourseReg.SetCurrentkey(CourseReg."Reg. Transacton ID", CourseReg."Student No.");
                CourseReg.SetRange(CourseReg."Student No.", Customer."No.");
                CourseReg.SetRange(Posted, true);
                CourseReg.SetRange(Reversed, false);
                CourseReg.SetFilter(CourseReg.Semester, Customer.GetFilter(Customer."Semester Filter"));
                CourseReg.SetFilter(CourseReg.Programme, Customer.GetFilter(Customer."Programme Filter"));
                CourseReg.SetFilter(CourseReg.Stage, Customer.GetFilter(Customer."Stage Filter"));
                CourseReg.SetFilter(CourseReg."Intake Code", Customer.GetFilter(Customer."Intake Filter"));
                // CourseReg.SetFilter(CourseReg."Programme Exam Category", GetFilter(Customer."Programme Category Filter"));
                //CourseReg.SETFILTER(CourseReg.Semester,'<>%1',NewSem);
                if CourseReg.Find('+') then begin
                    if CourseReg.Stage <> 'Y4S2' then begin
                        ProgStages.Reset;
                        ProgStages.SetCurrentkey(ProgStages."Programme Code", ProgStages.Code);
                        ProgStages.SetRange(ProgStages."Programme Code", CourseReg.Programme);
                        if ProgStages.Find('-') then begin
                            repeat
                                if StageFound = false then begin
                                    if StageStop = false then begin
                                        if ProgStages.Code = CourseReg.Stage then
                                            StageStop := true;
                                    end else begin
                                        RStage := ProgStages.Code;
                                        StageFound := true
                                    end;
                                end;

                            until ProgStages.Next = 0;
                        end;

                        if StageFound = true then begin
                            if CourseReg."Settlement Type" <> '' then begin

                                CourseReg3.Reset;
                                CourseReg3.SetRange(CourseReg3."Student No.", CourseReg."Student No.");
                                CourseReg3.SetRange(CourseReg3.Programme, CourseReg.Programme);
                                CourseReg3.SetRange(CourseReg3.Semester, NewSem);
                                CourseReg3.SetRange(CourseReg3.Stage, RStage);
                                if CourseReg3.Find('-') then begin
                                    CurrReport.Skip;
                                end else begin
                                    CourseReg2.Init;
                                    CourseReg2."Reg. Transacton ID" := '';
                                    CourseReg2.Validate(CourseReg2."Reg. Transacton ID");
                                    CourseReg2."Student No." := CourseReg."Student No.";
                                    CourseReg2.Programme := CourseReg.Programme;
                                    CourseReg2.Stage := RStage;
                                    CourseReg2."Student Type" := CourseReg."Student Type";
                                    CourseReg2.Semester := NewSem;
                                    CourseReg2."Settlement Type" := CourseReg."Settlement Type";
                                    CourseReg2."Registration Date" := Today;
                                    CourseReg2."Academic Year" := SemRec."Academic Year";
                                    CourseReg2."System Created" := true;
                                    CourseReg2."No. Series" := 'REG';
                                    CourseReg2.Insert(true);


                                    CourseReg2.Reset;
                                    CourseReg2.SetCurrentkey(CourseReg2."Reg. Transacton ID", CourseReg2."Student No.");
                                    CourseReg2.SetRange(CourseReg2."Student No.", Customer."No.");
                                    CourseReg2.SetRange(CourseReg2.Semester, NewSem);
                                    CourseReg2.SetRange(CourseReg2.Posted, false);
                                    if CourseReg2.Find('+') then begin
                                        CourseReg2.CalcFields(CourseReg2."Fee Exist");
                                        if CourseReg2."Fee Exist" > 0 then begin
                                            CourseReg2.Validate(CourseReg2."Registration Date");
                                            CourseReg2.Validate(CourseReg2."Settlement Type");
                                            CourseReg2.Modify;
                                        end;
                                    end;
                                end;
                            end;


                        end;
                    end;
                end else begin
                    CurrReport.Skip;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if NewSem = '' then
                    Error('Please specify the new semester.');
                SemRec.Get(NewSem);
                SemRec.TestField("Academic Year");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(NewSem; NewSem)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select the New Semester';
                    TableRelation = Semesters.Code;
                    ToolTip = 'Specifies the value of the Select the New Semester field.';
                }
            }
        }

        actions { }
    }

    labels { }

    var
        CourseReg: Record "Course Registration";
        CourseReg2: Record "Course Registration";
        ProgStages: Record "Programme Stages";
        RStage: Code[20];
        StageStop: Boolean;
        StageFound: Boolean;
        NewSem: Code[20];
        CourseReg3: Record "Course Registration";
        SemRec: Record Semesters;
}

