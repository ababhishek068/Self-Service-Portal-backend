Table 50236 "Course Registration"
{
    DrillDownPageID = "Course Registration List";
    LookupPageID = "Course Registration List";

    fields
    {
        field(1; "Student No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if Posted = true then
                    Error('Transaction once posted cannot be modified.');
            end;
        }
        field(2; Semester; Code[20])
        {
            NotBlank = true;
            // TableRelation = "Programme Semesters".Semester where("Programme Code" = field(Programme));
            TableRelation = Semesters.Code;
            trigger OnValidate()
            begin
                //"Settlement Type":='';
                coReg2.Reset;
                coReg2.SetRange(coReg2.Semester, Semester);
                coReg2.SetRange(coReg2."Student No.", "Student No.");
                coReg2.SetRange(coReg2.Programme, Programme);
                coReg2.SetRange(coReg2.Reversed, false);
                if coReg2.Find('-') then begin
                    if coReg2.Count > 1 then Error('Multiple Registration in the same semester is not allowed....');
                end;
            end;
        }
        field(3; Programme; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;

            trigger OnValidate()
            begin
                //"Settlement Type":='';
                if Posted = true then
                    Error('Transaction once posted cannot be modified.');

                if Posted = true then exit;
                acadYears.Reset;
                acadYears.SetRange(acadYears.Current, true);
                if acadYears.Find('-') then begin
                    "Academic Year" := acadYears.Code;
                end;



                Found := false;

                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.", Rec."Student No.");
                CourseReg.SetRange(CourseReg.Reversed, false);
                if CourseReg.Find('-') then begin
                    repeat
                        Programmes.Reset;
                        Programmes.SetRange(Programmes.Code, CourseReg.Programme);
                        if Programmes.Find('-') then begin
                            if Programmes.Priority = 1 then begin
                                Found := true;
                                LibCode := Programmes.Code;
                            end;


                            //Don't allow multiple programme registration
                            /*IF Programme <> '' THEN BEGIN
                            IF Programme <> CourseReg.Programme THEN BEGIN
                            IF Prog.GET(Programme) THEN BEGIN
                            IF Prog2.GET(CourseReg.Programme) THEN BEGIN
                            IF Prog.Category = Prog2.Category THEN
                            ERROR('You can only register a student for one programme.');
                            END;
                            END;
                            END;
                            END;*/


                        end;
                    until CourseReg.Next = 0;
                end;


                //VALIDATE(Programme);


                //Default Stage and semeter

                //Defaulting of semester
                Sems.Reset;
                Sems.SetRange(Sems."Current Semester", true);
                if Sems.Find('-') then
                    Semester := Sems.Code
                else
                    Error('Please specify the Curent Semester in the Semesters Setup!');
                Validate(Semester);
                // Get Default Year
                GenSetup.GET;
                //IF GenSetup."Default Year"<>'' THEN BEGIN
                // Stage:=GenSetup."Default Year";
                if GenSetup."Allow AutoProgression Stage" = true then begin
                    coReg1.Reset;
                    coReg1.SetRange(coReg1."Student No.", "Student No.");
                    coReg1.SetFilter(coReg1.Stage, '<>%1', '');
                    if coReg1.Find('-') then begin
                        if coReg1.Count = 0 then
                            Stage := 'Y1S1' else
                            if coReg1.Count = 1 then
                                Stage := 'Y1S2' else
                                if coReg1.Count = 2 then
                                    Stage := 'Y2S1' else
                                    if coReg1.Count = 3 then
                                        Stage := 'Y2S2' else
                                        if coReg1.Count = 4 then
                                            Stage := 'Y3S1' else
                                            if coReg1.Count = 5 then
                                                Stage := 'Y3S2' else
                                                if coReg1.Count = 6 then
                                                    Stage := 'Y4S1' else
                                                    if coReg1.Count = 7 then Stage := 'Y4S2';

                        //END;
                        Validate(Stage);
                    end;
                end;
                // Get Default Intake
                IntakeRec.Reset;
                IntakeRec.SetRange(IntakeRec.Current, true);
                if IntakeRec.Find('-') then
                    "Intake Code" := IntakeRec.Code;
                Validate("Reg. Transacton ID");

                //IF "Registration Date"=0D THEN
                "Registration Date" := Today;
                Validate("Registration Date");



            end;
        }
        field(4; "Register for"; Option)
        {
            NotBlank = false;
            OptionCaption = 'Stage,Unit/Subject,Supplementary,Retake';
            OptionMembers = Stage,"Unit/Subject",Supplementary,Retake;

            trigger OnValidate()
            begin
                //"Settlement Type":='';
                if "Register for" = "register for"::Stage then
                    Unit := '';
            end;
        }
        field(5; Stage; Code[20])
        {
            Caption = 'Year';
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));

            trigger OnValidate()
            begin

                //"Settlement Type":='';
                // Check duplicates
                /*
                CReg.RESET;
                CReg.SETRANGE(CReg."Student No.","Student No.");
                CReg.SETRANGE(CReg.Stage,Stage);
                CReg.SETRANGE(CReg."Register for","Register for");
                IF CReg.FIND('-') THEN BEGIN
                REPEAT
                IF CReg."Reg. Transacton ID"<>"Reg. Transacton ID" THEN
                IF CReg.Reversed=FALSE THEN ERROR(
                'Please note that you can not register to same year twice without stopping the older registration')
                UNTIL CReg.NEXT=0;
                END;
                */
                SPrereq.Reset;
                SPrereq.SetRange(SPrereq."Reg. Transaction ID", "Reg. Transacton ID");
                if SPrereq.Find('-') then
                    SPrereq.DeleteAll;

                CoursePrerequisite.Reset;
                CoursePrerequisite.SetRange(CoursePrerequisite.Programme, Programme);
                CoursePrerequisite.SetRange(CoursePrerequisite.Stage, Stage);
                if CoursePrerequisite.Find('-') then begin
                    repeat
                        SPrereq.Init;
                        SPrereq."Reg. Transaction ID" := "Reg. Transacton ID";
                        SPrereq."Student No." := "Student No.";
                        SPrereq.Programme := Programme;
                        SPrereq.Stage := Stage;
                        SPrereq.Prerequisite := CoursePrerequisite.Requirement;
                        SPrereq.Mandatory := CoursePrerequisite.Mandatory;
                        SPrereq.Approved := false;
                        SPrereq.Insert;

                    until CoursePrerequisite.Next = 0;

                end;



            end;
        }
        field(6; Unit; Code[20])
        {
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme),
                                                         "Stage Code" = field(Stage));

            trigger OnValidate()
            begin
                //"Settlement Type":='';
            end;
        }
        field(7; "Settlement Type"; Code[20])
        {
            NotBlank = false;
            TableRelation = "Settlement Type".Code;

            trigger OnValidate()
            begin

                CalcFields("Campus Code");

                GenSetup.get;
                if GenSetup."Fee Control Type" = GenSetup."Fee Control Type"::"Prev Balance" then begin
                    CalcFields(Balance);
                    if balance > 0 then error('Please note that you must clear the previous semester balance');

                end;
                //"Allow Adjustment":=FALSE;
                TestField("Reg. Transacton ID");
                TestField("Registration Date");
                "User ID" := UserId;
                //MODIFY;

                CReg2.Reset;
                CReg2.SetRange(CReg2."Student No.", "Student No.");
                CReg2.SetRange(CReg2.Programme, Programme);
                CReg2.SetRange(CReg2.Stage, Stage);
                CReg2.SetRange(CReg2.Unit, Unit);
                CReg2.SetRange(CReg2."Student Type", "Student Type");
                CReg2.SetRange(CReg2.Semester, Semester);
                CReg2.SetRange(CReg2.Reversed, false);
                CReg2.SetRange(CReg2."Register for", "Register for");
                if CReg2.Find('-') then begin
                    repeat
                        if "Reg. Transacton ID" <> CReg2."Reg. Transacton ID" then begin
                            Error('Student already registered for this course.');
                            //"Audit Issue":=TRUE;
                            //MODIFY;
                            //
                        end;
                    until CReg2.Next = 0;


                end;

                SPrereq.Reset;
                SPrereq.SetRange(SPrereq."Reg. Transaction ID", "Reg. Transacton ID");
                SPrereq.SetRange(SPrereq.Mandatory, true);
                SPrereq.SetRange(SPrereq.Approved, false);
                if SPrereq.Find('-') then
                    Error('Student has not meet the requirements of this course.');

                StudentCharges.Reset;
                StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                //StudentCharges.SETRANGE(StudentCharges."Reg. Transacton ID","Reg. Transacton ID");
                StudentCharges.SetRange(StudentCharges.Semester, Semester);
                StudentCharges.SetRange(StudentCharges.Recognized, false);
                if StudentCharges.Find('-') then
                    StudentCharges.DeleteAll;

                //PKK - Old student
                OldStud := false;
                if Stage <> 'Y1S1' then
                    OldStud := true;
                //PKK

                if Posted = false then begin

                    if "First Time Student" = true then begin
                        /*
                        StudentCharges.RESET;
                        StudentCharges.SETRANGE(StudentCharges."Student No.","Student No.");
                        IF NOT StudentCharges.FIND('-') THEN BEGIN
                        */
                        NewStudentCharges.Reset;
                        NewStudentCharges.SetRange(NewStudentCharges."Programme Code", Programme);
                        NewStudentCharges.SetRange(NewStudentCharges."First Time Students", true);

                        if NewStudentCharges.Find('-') then begin
                            repeat
                                StudentCharges.Init;
                                StudentCharges.Programme := Programme;
                                StudentCharges.Stage := Stage;
                                StudentCharges.Semester := Semester;
                                StudentCharges."Student No." := "Student No.";
                                StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentCharges."Transaction Type" := StudentCharges."transaction type"::"Stage Fees";
                                StudentCharges.Date := "Registration Date";
                                StudentCharges.Code := NewStudentCharges.Code;
                                StudentCharges.Description := NewStudentCharges.Description;
                                StudentCharges.Amount := NewStudentCharges.Amount;
                                StudentCharges."Recovered First" := NewStudentCharges."Recovered First";
                                StudentCharges."Recovery Priority" := NewStudentCharges."Recovery Priority";
                                StudentCharges.Distribution := NewStudentCharges."Distribution (%)";
                                StudentCharges."Distribution Account" := NewStudentCharges."Distribution Account";
                                StudentCharges.Charge := true;
                                StudentCharges."Transacton ID" := '';
                                StudentCharges.Validate(StudentCharges."Transacton ID");
                                StudentCharges.Insert;

                            until NewStudentCharges.Next = 0
                            //END;
                        end;
                    end;


                    NewStudentCharges.Reset;
                    NewStudentCharges.SetRange(NewStudentCharges."Programme Code", Programme);
                    NewStudentCharges.SetRange(NewStudentCharges."First Time Students", false);
                    if NewStudentCharges.Find('-') then begin
                        repeat
                            StudentCharges.Init;
                            StudentCharges.Programme := Programme;
                            StudentCharges.Stage := Stage;
                            StudentCharges.Semester := Semester;
                            StudentCharges."Student No." := "Student No.";
                            StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                            StudentCharges."Transaction Type" := StudentCharges."transaction type"::"Stage Fees";
                            StudentCharges.Date := "Registration Date";
                            StudentCharges.Code := NewStudentCharges.Code;
                            StudentCharges.Description := NewStudentCharges.Description;
                            StudentCharges.Amount := NewStudentCharges.Amount;
                            StudentCharges."Recovered First" := NewStudentCharges."Recovered First";
                            StudentCharges."Recovery Priority" := NewStudentCharges."Recovery Priority";
                            StudentCharges.Distribution := NewStudentCharges."Distribution (%)";
                            StudentCharges."Distribution Account" := NewStudentCharges."Distribution Account";
                            StudentCharges.Charge := true;
                            StudentCharges."Transacton ID" := '';
                            StudentCharges.Validate(StudentCharges."Transacton ID");
                        //StudentCharges.INSERT;

                        until NewStudentCharges.Next = 0
                    end;




                    TotalUnits := 0;

                    if "Settlement Type" <> '' then begin
                        if "Register for" = "register for"::Stage then begin
                            FeeByStage.Reset;
                            FeeByStage.SetRange(FeeByStage."Programme Code", Programme);
                            FeeByStage.SetRange(FeeByStage."Stage Code", Stage);
                            FeeByStage.SetRange(FeeByStage."Settlemet Type", "Settlement Type");
                            //FeeByStage.SETRANGE(FeeByStage.Semester,Semester);
                            //FeeByStage.SETRANGE(FeeByStage."Student Type","Student Type");
                            //FeeByStage.SETRANGE(FeeByStage."Campus Code","Campus Code");
                            if not FeeByStage.Find('-') then begin
                                if (CopyStr(Stage, 3, 2) <> 'S2') and (Prog.Category <> Prog.Category::Undergraduate) then
                                    Error('No fees structure defined for the settlement type!.' + "Settlement Type" + ' - ' + Programme + ' - ' + Stage);

                            end
                            else begin
                                repeat
                                    TotalCost := 0;
                                    TotalCost := TotalCost + FeeByStage."Break Down";
                                    if "Exempted Units" > 0 then
                                        TotalCost := TotalCost * "Exempted Units";

                                    StudentCharges.Init;
                                    StudentCharges.Programme := Programme;
                                    StudentCharges.Stage := Stage;
                                    StudentCharges.Semester := Semester;
                                    StudentCharges."Student No." := "Student No.";
                                    StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                                    StudentCharges."Transaction Type" := StudentCharges."transaction type"::"Stage Fees";
                                    StudentCharges.Date := "Registration Date";
                                    StudentCharges.Code := Stage;
                                    if SettlementType.Get("Settlement Type") then begin
                                        if SettlementType.Installments = true then begin
                                            if FeeByStage."Seq." = 0 then
                                                StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 0'
                                            else
                                                if FeeByStage."Seq." = 1 then
                                                    StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 1'
                                                else
                                                    if FeeByStage."Seq." = 2 then
                                                        StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 2'
                                                    else
                                                        if FeeByStage."Seq." = 3 then
                                                            StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 3'
                                                        else
                                                            if FeeByStage."Seq." = 4 then
                                                                StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 4'
                                                            else
                                                                StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + 'Inst';

                                            StudentCharges.Distribution := Stages."Distribution Part Time (%)";
                                        end else begin
                                            StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + format("Student Type");
                                            StudentCharges.Distribution := Stages."Distribution Full Time (%)";
                                        end;
                                    end else begin
                                        StudentCharges.Description := 'Tuition for' + ' ' + Programme + '-' + Stage + '-' + format("Student Type");
                                    end;

                                    CalcFields("Total Exempted");

                                    //Exemptions
                                    if "Total Exempted" > 0 then begin
                                        if TotalUnits > 0 then begin
                                            TotalCost := (TotalUnits - "Total Exempted") * (TotalCost / TotalUnits);
                                        end;
                                    end;

                                    ///////////////////////
                                    //Recalculate fee based on units
                                    if "Exempted Units" > 0 then begin
                                        TotalCost := 0;

                                        PStage.Reset;
                                        PStage.SetRange(PStage."Programme Code", Programme);
                                        PStage.SetFilter(PStage."Student No.", "Student No.");
                                        PStage.SetFilter(PStage."Reg. ID", "Reg. Transacton ID");
                                        if PStage.Find('-') then begin
                                            repeat
                                                PStage.CalcFields(PStage."Units Taken");

                                                if PStage."Units Taken" > 0 then begin
                                                    SFee.Reset;
                                                    SFee.SetRange(SFee."Programme Code", Programme);
                                                    SFee.SetRange(SFee."Stage Code", PStage.Code);
                                                    SFee.SetRange(SFee."Settlemet Type", "Settlement Type");
                                                    SFee.SetRange(SFee.Semester, Semester);
                                                    SFee.SetRange(SFee."Student Type", "Student Type");
                                                    if SFee.Find('-') then begin
                                                        TotalCost := TotalCost + (SFee."Break Down" * PStage."Units Taken");
                                                    end;// ELSE
                                                        //ERROR('No fee structure defined for %1.',PStage.Code)

                                                end;

                                            until PStage.Next = 0;
                                        end;
                                    end;
                                    ///////////////////////


                                    StudentCharges.Amount := TotalCost;
                                    StudentCharges."Tuition Fee" := true;
                                    StudentCharges."Full Tuition Fee" := TotalCost;
                                    StudentCharges."Transacton ID" := '';
                                    StudentCharges."Recovery Priority" := 20;
                                    StudentCharges.Validate(StudentCharges."Transacton ID");
                                    StudentCharges.Insert;

                                until FeeByStage.Next = 0;


                                StageCharges.Reset;
                                StageCharges.SetRange(StageCharges."Programme Code", Programme);
                                StageCharges.SetRange(StageCharges."Stage Code", Stage);
                                //   StageCharges.SetRange(StageCharges."Student Type", StageCharges."student type"::" ");
                                StageCharges.SetRange(StageCharges."Settlement Type", "Settlement Type");
                                //StageCharges.SETRANGE(StageCharges."Campus Code","Campus Code");
                                if StageCharges.Find('-') then begin
                                    repeat

                                        StudentCharges.Init;
                                        StudentCharges.Programme := Programme;
                                        StudentCharges.Stage := Stage;
                                        StudentCharges.Semester := Semester;
                                        StudentCharges."Student No." := "Student No.";
                                        StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                                        StudentCharges."Transaction Type" := StudentCharges."transaction type"::"Stage Fees";
                                        StudentCharges.Date := "Registration Date";
                                        StudentCharges.Code := StageCharges.Code;
                                        StudentCharges.Description := StageCharges.Description;
                                        StudentCharges.Amount := StageCharges.Amount;
                                        StudentCharges."Recovered First" := StageCharges."Recovered First";
                                        StudentCharges."Recovery Priority" := StageCharges."Recovery Priority";
                                        StudentCharges.Distribution := StageCharges."Distribution (%)";
                                        StudentCharges."Distribution Account" := StageCharges."Distribution Account";
                                        StudentCharges."Transacton ID" := '';
                                        StudentCharges.Charge := true;
                                        StudentCharges.Validate(StudentCharges."Transacton ID");
                                        StudentCharges.Insert;



                                    until StageCharges.Next = 0;

                                end;

                            end;

                        end
                        else begin
                            FeeByUnit.Reset;
                            FeeByUnit.SetRange(FeeByUnit."Programme Code", Programme);
                            FeeByUnit.SetRange(FeeByUnit."Stage Code", Stage);
                            FeeByUnit.SetRange(FeeByUnit."Unit Code", Unit);
                            FeeByUnit.SetRange(FeeByUnit.Semester, Semester);
                            FeeByUnit.SetRange(FeeByUnit."Settlemet Type", "Settlement Type");
                            //  FeeByUnit.SetRange(FeeByUnit."Student Type", "Student Type");
                            if not FeeByUnit.Find('-') then begin
                                //ERROR('No fees structure defined for the settlement type. !'+Stage);
                                //"Settlement Type":='';
                            end
                            else begin
                                //Insert Units
                                StudentUnits.Init;
                                StudentUnits."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentUnits."Student No." := "Student No.";
                                StudentUnits.Programme := Programme;
                                StudentUnits.Stage := Stage;
                                StudentUnits.Unit := Unit;
                                StudentUnits.Semester := Semester;
                                StudentUnits."Register for" := "Register for";
                                //IF Stages."Modules Registration" = FALSE THEN
                                StudentUnits.Taken := true;
                                StudentUnits.Insert;

                                TotalCost := 0;
                                repeat
                                    TotalCost := TotalCost + FeeByUnit."Unit Fees";
                                until FeeByUnit.Next = 0;

                                StudentCharges.Init;
                                StudentCharges.Programme := Programme;
                                StudentCharges.Stage := Stage;
                                StudentCharges.Unit := Unit;
                                StudentCharges.Semester := Semester;
                                StudentCharges."Student No." := "Student No.";
                                StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentCharges."Transaction Type" := StudentCharges."transaction type"::"Unit Fees";
                                StudentCharges.Date := "Registration Date";
                                StudentCharges.Code := Unit;
                                StudentCharges.Description := 'Fees for' + ' ' + Programme + '-' + Stage + '-' + Unit;
                                StudentCharges.Amount := TotalCost;
                                StudentCharges."Tuition Fee" := true;
                                StudentCharges."Full Tuition Fee" := TotalCost;
                                StudentCharges."Transacton ID" := '';
                                StudentCharges."Recovery Priority" := 20;
                                StudentCharges.Validate(StudentCharges."Transacton ID");
                                StudentCharges.Insert;


                            end;
                        end;
                    end;
                end;


                IF "Register for" = "Register for"::"Unit/Subject" THEN BEGIN
                    TESTFIELD(Programme);
                    Cust.GET("Student No.");
                    GenSetup.get;
                    if GenSetup."Unit Billing Type" = 0 then error('Please specify the Unit Billing Type in the General Setup');
                    //TESTFIELD("Student Type");
                    CALCFIELDS("Units Taken");
                    CALCFIELDS("Campus Code");
                    SettlementType.GET("Settlement Type");
                    SettlementType.TESTFIELD("Tuition G/L Account");


                    if GenSetup."Unit Billing Type" = GenSetup."Unit Billing Type"::"Programme Unit Fee" then begin
                        IF "Units Taken" = 0 THEN ERROR('Please select the units to be billed');
                        UnitFees := 0;
                        Prog.get(Programme);
                        Prog.TestField("Unit Fee");
                        UnitFees := prog."Unit Fee";
                        StudentCharges.INIT;
                        StudentCharges.Programme := Programme;
                        StudentCharges.Stage := Stage;
                        StudentCharges.Unit := Unit;
                        StudentCharges.Semester := Semester;
                        StudentCharges."Student No." := "Student No.";
                        StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                        StudentCharges."Transaction Type" := StudentCharges."Transaction Type"::"Unit Fees";
                        StudentCharges.Date := "Registration Date";
                        StudentCharges.Code := SettlementType."Tuition G/L Account";
                        StudentCharges.Description := 'Fees for' + ' ' + Programme + ' ' + Stage + '-' + format("Units Taken") + ' Units';
                        StudentCharges.Amount := UnitFees * "Units Taken";
                        StudentCharges."Tuition Fee" := TRUE;
                        StudentCharges."Transacton ID" := '';
                        StudentCharges."Recovery Priority" := 20;
                        StudentCharges.VALIDATE(StudentCharges."Transacton ID");
                        StudentCharges.INSERT;
                    end else begin



                        StudentUnits.RESET;
                        StudentUnits.SETRANGE(StudentUnits."Student No.", "Student No.");
                        StudentUnits.SETRANGE(StudentUnits.Semester, Semester);
                        StudentUnits.SETRANGE(StudentUnits.Billed, FALSE);
                        IF StudentUnits.FIND('-') THEN BEGIN
                            REPEAT
                                StudentUnits.CALCFIELDS(StudentUnits."Dissertation Unit");


                                FeeByUnit.RESET; // Check if the fees has exists for the specific unit
                                FeeByUnit.SETRANGE(FeeByUnit."Programme Code", Programme);
                                //FeeByUnit.SETRANGE(FeeByUnit."Student Type",'DISTANCE LEARNING');

                                FeeByUnit.SETRANGE(FeeByUnit."Campus Code", Cust."Global Dimension 1 Code");
                                FeeByUnit.SETRANGE(FeeByUnit."Unit Code", StudentUnits.Unit);
                                FeeByUnit.SETRANGE(FeeByUnit."Settlemet Type", "Settlement Type");
                                IF FeeByUnit.FIND('-') THEN BEGIN
                                    UnitFees := FeeByUnit."Unit Fees";
                                    ExamsFees := FeeByUnit."Exam Fees";
                                END;

                                IF UnitFees = 0 THEN BEGIN
                                    FeeByUnit.RESET; // Check if the fees has exists for the general units
                                    FeeByUnit.SETRANGE(FeeByUnit."Programme Code", Programme);

                                    FeeByUnit.SETRANGE(FeeByUnit."Campus Code", Cust."Global Dimension 1 Code");
                                    FeeByUnit.SETRANGE(FeeByUnit."Settlemet Type", "Settlement Type");
                                    IF Stage = 'Y1S1' THEN
                                        FeeByUnit.SETRANGE(FeeByUnit."Applicable Group", FeeByUnit."Applicable Group"::"New Students")
                                    ELSE
                                        FeeByUnit.SETRANGE(FeeByUnit."Applicable Group", FeeByUnit."Applicable Group"::"Continuing Students");

                                    IF FeeByUnit.FIND('-') THEN
                                        UnitFees := FeeByUnit."Unit Fees";
                                    ExamsFees := FeeByUnit."Exam Fees";
                                END;
                                IF StudentUnits."No. Of Units" = 6 THEN
                                    UnitFees := UnitFees * 2;

                                IF StudentUnits."Dissertation Unit" = TRUE THEN BEGIN // Thesis Units
                                    Prog.GET(Programme);
                                    Prog.TESTFIELD(Prog."Thesis Charge Code");
                                    Charges.GET(Prog."Thesis Charge Code");
                                    UnitFees := Charges.Amount;
                                END;
                                // Tuition
                                StudentCharges.INIT;
                                StudentCharges.Programme := Programme;
                                StudentCharges.Stage := Stage;
                                StudentCharges.Unit := Unit;
                                StudentCharges.Semester := Semester;
                                StudentCharges."Student No." := "Student No.";
                                StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentCharges."Transaction Type" := StudentCharges."Transaction Type"::"Unit Fees";
                                StudentCharges.Date := "Registration Date";
                                StudentCharges.Code := SettlementType."Tuition G/L Account";
                                StudentCharges.Description := 'Fees for' + ' ' + Programme + '-' + StudentUnits.Unit;
                                StudentCharges.Amount := UnitFees;
                                StudentCharges."Tuition Fee" := TRUE;
                                StudentCharges."Transacton ID" := '';
                                StudentCharges."Recovery Priority" := 20;
                                StudentCharges.VALIDATE(StudentCharges."Transacton ID");
                                StudentCharges.INSERT;
                                //Exams
                                IF (StudentUnits."Dissertation Unit" = TRUE) OR (StudentUnits."Attachment Unit" = TRUE) THEN BEGIN
                                    // Skip Charges
                                END ELSE BEGIN
                                    StudentCharges.INIT;
                                    StudentCharges.Programme := Programme;
                                    StudentCharges.Stage := Stage;
                                    StudentCharges.Unit := Unit;
                                    StudentCharges.Semester := Semester;
                                    StudentCharges."Student No." := "Student No.";
                                    StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                                    StudentCharges."Transaction Type" := StudentCharges."Transaction Type"::"Unit Fees";
                                    StudentCharges.Date := "Registration Date";
                                    StudentCharges.Code := SettlementType."Exams G/L Account";
                                    StudentCharges.Description := 'Exams for' + ' ' + Programme + '-' + StudentUnits.Unit;
                                    StudentCharges.Amount := ExamsFees;
                                    StudentCharges."Tuition Fee" := FALSE;
                                    StudentCharges."Transacton ID" := '';
                                    StudentCharges."Recovery Priority" := 20;
                                    StudentCharges.VALIDATE(StudentCharges."Transacton ID");
                                    StudentCharges.INSERT;
                                END;
                            UNTIL StudentUnits.NEXT = 0;
                        END;

                        CALCFIELDS("Billed Units");
                        //Insert unit standard charges
                        IF "Billed Units" = 0 THEN BEGIN
                            FeeByUnitCharges.RESET;
                            FeeByUnitCharges.SETRANGE(FeeByUnitCharges."Programme Code", Programme);

                            FeeByUnitCharges.SETRANGE(FeeByUnitCharges."Campus Code", Cust."Global Dimension 1 Code");
                            FeeByUnitCharges.SETRANGE(FeeByUnitCharges."Settlement Type", "Settlement Type");
                            IF Stage = 'Y1S1' THEN
                                FeeByUnitCharges.SETRANGE(FeeByUnitCharges."Applicable Group", FeeByUnitCharges."Applicable Group"::"New Students")
                            ELSE
                                FeeByUnitCharges.SETRANGE(FeeByUnitCharges."Applicable Group", FeeByUnitCharges."Applicable Group"::"Continuing Students");

                            IF FeeByUnitCharges.FIND('-') THEN BEGIN
                                REPEAT
                                    ExitCharge := FALSE;
                                    IF (FeeByUnitCharges."First Time Only" = TRUE) AND (Stage <> 'Y1S1') THEN // check if charges is applicable to first time only
                                        ExitCharge := TRUE;

                                    //IF ExitCharge =FALSE THEN BEGIN
                                    IF (StudentUnits."Dissertation Unit" = TRUE) OR (StudentUnits."Attachment Unit" = TRUE) THEN BEGIN
                                        //Skip
                                    END ELSE BEGIN
                                        StudentCharges.INIT;
                                        StudentCharges.Programme := Programme;
                                        StudentCharges.Stage := Stage;
                                        StudentCharges.Unit := Unit;
                                        StudentCharges.Semester := Semester;
                                        StudentCharges."Student No." := "Student No.";
                                        StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                                        StudentCharges."Transaction Type" := StudentCharges."Transaction Type"::Charges;
                                        StudentCharges.Date := "Registration Date";
                                        StudentCharges.Code := FeeByUnitCharges.Code;
                                        StudentCharges.Description := FeeByUnitCharges.Description + ' - ' + Semester;
                                        StudentCharges.Amount := FeeByUnitCharges.Amount;
                                        StudentCharges."Tuition Fee" := TRUE;
                                        StudentCharges."Transacton ID" := '';
                                        StudentCharges."Recovery Priority" := 20;
                                        StudentCharges.VALIDATE(StudentCharges."Transacton ID");
                                        StudentCharges.INSERT;
                                    END;
                                UNTIL FeeByUnitCharges.NEXT = 0;
                            end;
                        END;
                    END;


                end;
                if "Register for" = "register for"::Retake then begin
                    Prog.Get(Programme);
                    //Prog.TESTFIELD(Prog."Unit Fee");
                    TestField("Retake Units");
                    if "Retake Units" = 0 then Error('Please select the number of retake units ');
                    StudentCharges.Init;
                    StudentCharges.Programme := Programme;
                    StudentCharges.Stage := Stage;
                    StudentCharges.Unit := Unit;
                    StudentCharges.Semester := Semester;
                    StudentCharges."Student No." := "Student No.";
                    StudentCharges."Reg. Transacton ID" := "Reg. Transacton ID";
                    StudentCharges."Transaction Type" := StudentCharges."transaction type"::"Unit Fees";
                    StudentCharges.Date := "Registration Date";
                    StudentCharges.Code := Unit;
                    StudentCharges.Description := 'Retake Fees for' + ' ' + Programme + '-' + Stage + '-' + Format("Units Taken") + 'Units';
                    StudentCharges.Amount := 10000 * "Retake Units";
                    StudentCharges."Tuition Fee" := true;
                    //StudentCharges."Full Tuition Fee":=TotalCost;
                    StudentCharges."Transacton ID" := '';
                    StudentCharges."Recovery Priority" := 20;
                    StudentCharges.Validate(StudentCharges."Transacton ID");
                    StudentCharges.Insert;

                end;

            end;
        }
        field(8; "Registration Date"; Date)
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                // First Years Only
                GenSetup.get;
                if GenSetup."Allow Units Validation" = true then begin
                    TotalUnits := 0;
                    // IF Stage = 'Y1S1' THEN BEGIN
                    StudentUnits.RESET;
                    StudentUnits.SETRANGE(StudentUnits."Student No.", "Student No.");
                    StudentUnits.SETRANGE(Semester, Semester);
                    StudentUnits.SETRANGE(Stage, Stage);
                    StudentUnits.SETRANGE(StudentUnits."Reg. Transacton ID", "Reg. Transacton ID");
                    IF StudentUnits.FIND('-') THEN
                        StudentUnits.DELETEALL;

                    Stages.Reset;
                    Stages.SetRange(Stages."Programme Code", Programme);
                    Stages.SetRange(Stages.Code, Stage);
                    if Stages.Find('-') then begin
                        StageUnits.Reset;
                        StageUnits.SetRange(StageUnits."Programme Code", Programme);
                        StageUnits.SetRange(StageUnits."Stage Code", Stage);
                        StageUnits.SetRange(StageUnits."Programme Option", Options);
                        //StageUnits.SETRANGE(StageUnits."Unit Type",StageUnits."Unit Type"::Core);
                        StageUnits.SetRange(StageUnits."Old Unit", false);
                        if StageUnits.Find('-') then begin
                            repeat
                                TotalUnits := TotalUnits + 1;
                                StudentUnits.Init;
                                StudentUnits."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentUnits."Student No." := "Student No.";
                                StudentUnits.Programme := Programme;
                                StudentUnits.Stage := Stage;
                                StudentUnits."Unit Stage" := Stage;
                                StudentUnits.Unit := StageUnits.Code;
                                StudentUnits.Semester := Semester;
                                StudentUnits."Register for" := "Register for";
                                StudentUnits."Unit Type" := StageUnits."Unit Type";
                                StudentUnits."No. Of Units" := StageUnits."No. Units";
                                StudentUnits.Description := StageUnits.Desription;
                                StudentUnits."Academic Year" := "Academic Year";
                                StudentUnits.Taken := true;
                                //IF (Check_Units_Exist("Student No.",Programme,Stage,StageUnits.Code)=FALSE)  THEN
                                StudentUnits.INSERT;

                            //END;

                            until StageUnits.Next = 0
                            // end;
                        END;
                    end;
                end;
                /*
                IF "Registration Date" <> 0D THEN BEGIN
                //"Settlement Type":='FULL PAYMENT';
                //VALIDATE("Settlement Type");
                END;
                
                //Insert units
                Cust.GET("Student No.");
                // CALCFIELDS(Status);
                // IF (Cust.Status<>0) OR (Cust.Status<>1) THEN ERROR('Please note that you can only register students with current and registration status!');
                
                StudentUnits.RESET;
                StudentUnits.SETRANGE(StudentUnits."Student No.","Student No.");
                StudentUnits.SETRANGE(StudentUnits."Reg. Transacton ID","Reg. Transacton ID");
                IF StudentUnits.FIND('-') THEN
                StudentUnits.DELETEALL;
                
                
                
                //Insert Students Units Single Options
                Stages.RESET;
                Stages.SETRANGE(Stages."Programme Code",Programme);
                Stages.SETRANGE(Stages.Code,Stage);
                IF Stages.FIND('-') THEN BEGIN
                StageUnits.RESET;
                StageUnits.SETRANGE(StageUnits."Programme Code",Programme);
                StageUnits.SETRANGE(StageUnits."Stage Code",Stage);
                StageUnits.SETRANGE(StageUnits."Programme Option",Options);
                StageUnits.SETRANGE(StageUnits."Old Unit",FALSE);
                IF StageUnits.FIND('-') THEN BEGIN
                REPEAT
                IF ("Register for"="Register for"::Stage) THEN BEGIN
                StageUnits.CALCFIELDS(StageUnits."Combination Count");
                
                StudentUnits.INIT;
                StudentUnits."Reg. Transacton ID":="Reg. Transacton ID";
                StudentUnits."Student No.":="Student No.";
                StudentUnits.Programme:=Programme;
                StudentUnits.Stage:=Stage;
                StudentUnits."Unit Stage":=Stage;
                StudentUnits.Unit:=StageUnits.Code;
                StudentUnits.Semester:=Semester;
                StudentUnits."Register for":="Register for";
                StudentUnits."Unit Type":=StageUnits."Unit Type";
                StudentUnits."No. Of Units":=StageUnits."No. Units";
                StudentUnits.Description:=StageUnits.Desription;
                IF Stages."Modules Registration" = FALSE THEN BEGIN
                IF (StageUnits."Unit Type" = StageUnits."Unit Type"::Core) OR (StageUnits."Unit Type" = StageUnits."Unit Type"::Required) THEN
                StudentUnits.Taken:=TRUE;
                END;
                
                IF (StageUnits."Programme Option" = '') AND (StageUnits."Combination Count"=0) THEN
                StudentUnits.INSERT
                ELSE BEGIN
                IF (StageUnits."Unit Type" = StageUnits."Unit Type"::Core) THEN
                StudentUnits.INSERT;
                END;
                
                
                TotalUnits:=TotalUnits+1;
                //END;
                END;
                UNTIL StageUnits.NEXT = 0
                END;
                
                //Insert Students Units Multiple Options
                Stages.RESET;
                Stages.SETRANGE(Stages."Programme Code",Programme);
                Stages.SETRANGE(Stages.Code,Stage);
                IF Stages.FIND('-') THEN BEGIN
                
                StageUnits.RESET;
                StageUnits.SETRANGE(StageUnits."Programme Code",Programme);
                StageUnits.SETRANGE(StageUnits."Stage Code",Stage);
                //StageUnits.SETRANGE(StageUnits."Programme Option",Options);
                StageUnits.SETFILTER(StageUnits."Combination Count",'>%1',0);
                IF StageUnits.FIND('-') THEN BEGIN
                REPEAT
                
                MultipleCombination.RESET;
                MultipleCombination.SETRANGE(MultipleCombination.Programme,Programme);
                MultipleCombination.SETRANGE(MultipleCombination.Stage,Stage);
                MultipleCombination.SETRANGE(MultipleCombination.Option,Options);
                MultipleCombination.SETRANGE(MultipleCombination.Unit,StageUnits.Code);
                IF MultipleCombination.FIND('-') AND ("Register for"="Register for"::Stage) THEN BEGIN
                StudentUnits.INIT;
                StudentUnits."Reg. Transacton ID":="Reg. Transacton ID";
                StudentUnits."Student No.":="Student No.";
                StudentUnits.Programme:=Programme;
                StudentUnits.Stage:=Stage;
                StudentUnits."Unit Stage":=Stage;
                StudentUnits.Unit:=StageUnits.Code;
                StudentUnits.Semester:=Semester;
                StudentUnits."Register for":="Register for";
                StudentUnits."Unit Type":=StageUnits."Unit Type";
                StudentUnits."No. Of Units":=StageUnits."No. Units";
                StudentUnits.Description:=StageUnits.Desription;
                IF (StageUnits."Unit Type" <> StageUnits."Unit Type"::Core) OR (StageUnits."Unit Type" = StageUnits."Unit Type"::Required) THEN
                StudentUnits.Taken:=TRUE;
                IF Check_Units_Exist("Student No.",Programme,Stage,StageUnits.Code)=FALSE THEN
                StudentUnits.INSERT;
                TotalUnits:=TotalUnits+1;
                END;
                
                UNTIL StageUnits.NEXT = 0
                END;
                END;
                END;
                //Insert Core Units
                IF (Options<>'') AND ("Register for"="Register for"::Stage) THEN BEGIN
                Stages.RESET;
                Stages.SETRANGE(Stages."Programme Code",Programme);
                Stages.SETRANGE(Stages.Code,Stage);
                IF Stages.FIND('-') THEN BEGIN
                StageUnits.RESET;
                StageUnits.SETRANGE(StageUnits."Programme Code",Programme);
                StageUnits.SETRANGE(StageUnits."Stage Code",Stage);
                StageUnits.SETRANGE(StageUnits."Unit Type",StageUnits."Unit Type"::Core);
                StageUnits.SETRANGE(StageUnits."Old Unit",FALSE);
                IF StageUnits.FIND('-') THEN BEGIN
                REPEAT
                StudentUnits.INIT;
                StudentUnits."Reg. Transacton ID":="Reg. Transacton ID";
                StudentUnits."Student No.":="Student No.";
                StudentUnits.Programme:=Programme;
                StudentUnits.Stage:=Stage;
                StudentUnits."Unit Stage":=Stage;
                StudentUnits.Unit:=StageUnits.Code;
                StudentUnits.Semester:=Semester;
                StudentUnits."Register for":="Register for";
                StudentUnits."Unit Type":=StageUnits."Unit Type";
                StudentUnits."No. Of Units":=StageUnits."No. Units";
                StudentUnits.Description:=StageUnits.Desription;
                StudentUnits.Taken:=TRUE;
                IF Check_Units_Exist("Student No.",Programme,Stage,StageUnits.Code)=FALSE THEN
                StudentUnits.INSERT;
                TotalUnits:=TotalUnits+1;
                //END;
                
                UNTIL StageUnits.NEXT = 0
                END;
                END;
                END;
                
                
                
                IF "Register for"="Register for"::Supplementary THEN BEGIN
                StudUnits.RESET;
                StudUnits.SETRANGE(StudUnits."Student No.","Student No.");
                StudUnits.SETRANGE(StudUnits.Stage,Stage);
                //StudUnits.SETRANGE(StudUnits.Semester,Semester);
                StudUnits.SETRANGE(StudUnits.Failed,TRUE);
                IF StudUnits.FIND('-') THEN BEGIN
                REPEAT
                StudentUnits.INIT;
                StudentUnits."Reg. Transacton ID":="Reg. Transacton ID";
                StudentUnits."Student No.":="Student No.";
                StudentUnits.Programme:=Programme;
                StudentUnits.Stage:=Stage;
                StudentUnits."Unit Stage":=StudUnits."Unit Stage";
                StudentUnits.Unit:=StudUnits.Unit;
                StudentUnits.Semester:=Semester;
                StudentUnits."Register for":="Register for";
                StudentUnits."Unit Type":=StudUnits."Unit Type";
                StudentUnits."No. Of Units":=StudUnits."No. Of Units";
                StudentUnits."Attachment Unit":=StudUnits."Attachment Unit";
                StudentUnits.Taken:=TRUE;
                StudentUnits."Re-Take":=TRUE;
                StudentUnits.INSERT;
                UNTIL StudUnits.NEXT=0;
                END ELSE BEGIN
                ERROR('No Unit has been Marked as Failed in Selected Period');
                END;
                // Charge Supplimentary Fees if Enabled.
                GenSetup.GET;
                IF GenSetup."Bill Supplimentary Fee"=TRUE THEN BEGIN
                GenSetup.TESTFIELD(GenSetup."Supplimentary Fee Code");
                Charges.GET(GenSetup."Supplimentary Fee Code");
                CALCFIELDS("Units Taken");
                StudentCharges.INIT;
                StudentCharges.Programme:=Programme;
                StudentCharges.Stage:=Stage;
                StudentCharges.Semester:=Semester;
                StudentCharges."Student No.":="Student No.";
                StudentCharges."Reg. Transacton ID":="Reg. Transacton ID";
                StudentCharges."Transaction Type":=StudentCharges."Transaction Type"::"Stage Fees";
                StudentCharges.Date:="Registration Date";
                StudentCharges.Code:=GenSetup."Supplimentary Fee Code";
                StudentCharges.Description:=Charges.Description;
                StudentCharges.Amount:=Charges.Amount*"Units Taken";
                StudentCharges."Transacton ID":='';
                StudentCharges.Charge:=TRUE;
                StudentCharges.VALIDATE(StudentCharges."Transacton ID");
                StudentCharges.INSERT;
                
                END;
                END;
                 */

            end;
        }
        field(9; Remarks; Text[150]) { }
        field(10; "Reg. Transacton ID"; Code[20])
        {

            trigger OnValidate()
            begin

                if "Reg. Transacton ID" = '' then begin
                    GenSetup.Get;
                    GenSetup.TestField(GenSetup."Registration Nos.");
                    "Reg. Transacton ID" := NoSeriesMgt.GetNextNo(GenSetup."Registration Nos.", 0D, true);
                end;
            end;
        }
        field(11; "No. Series"; Code[20])
        {

            trigger OnValidate()
            begin
                if "Reg. Transacton ID" <> xRec."Reg. Transacton ID" then begin
                    GenSetup.Get;
                    NoSeriesMgt.TestManual(GenSetup."Registration Nos.");
                    "No. Series" := '';
                end;

                if "Reg. Transacton ID" = '' then begin
                    GenSetup.Get;
                    GenSetup.TestField(GenSetup."Registration Nos.");
                    "Reg. Transacton ID" := NoSeriesMgt.GetNextNo(GenSetup."Registration Nos.", 0D, true);
                end;
            end;
        }
        field(12; "Exempted Units"; Integer)
        {

            trigger OnValidate()
            begin
                "Settlement Type" := '';
            end;
        }
        field(13; "Programme Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(14; "Stage Filter"; Code[20])
        {
            Caption = 'Year Filter';
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(15; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme),
                                                         "Stage Code" = field("Stage Filter"));
        }
        field(16; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }
        field(17; "Lecture Room Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Lecture Room".Code;
        }
        field(18; "Attending Classes"; Boolean)
        {

            trigger OnValidate()
            begin
                "Allow Adjustment" := true;
                Modify;

                exit;

                TestField("Settlement Type");

                if xRec."Attending Classes" = true then
                    Error('Entries have already been posted. Please reverse posted entries.');





                /*
                IF CONFIRM('Do you want to post the transaction?',TRUE) = FALSE THEN BEGIN
                "Attending Classes":=FALSE;
                MODIFY;
                EXIT;
                END;
                */

                GenSetup.Get();

                if "Attending Classes" = true then begin
                    //BILLING

                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                    StudentCharges.SetRange(StudentCharges.Recognized, false);
                    if StudentCharges.Find('-') then begin
                        if Confirm('Un-billed charges will be posted. Do you wish to continue?', true) = false then begin
                            "Attending Classes" := false;
                            Modify;
                            exit;
                        end;
                    end;


                    if Cust.Get("Student No.") then begin
                        //Cust.Status:=Cust.Status::Current;
                        //Cust.MODIFY;
                    end;


                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    GenJnl.DeleteAll;

                    GenSetup.Get();

                    //Charge Student if not charged
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                    StudentCharges.SetRange(StudentCharges.Recognized, false);
                    if StudentCharges.Find('-') then begin

                        repeat

                            DueDate := StudentCharges.Date;
                            if Sems.Get(StudentCharges.Semester) then begin
                                if Sems.From <> 0D then begin
                                    if Sems.From > DueDate then
                                        DueDate := Sems.From;
                                end;
                            end;


                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document No." := StudentCharges."Transacton ID";
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::Customer;
                            //
                            if Cust.Get("Student No.") then begin
                                if Cust."Bill-to Customer No." <> '' then
                                    GenJnl."Account No." := Cust."Bill-to Customer No."
                                else
                                    GenJnl."Account No." := "Student No.";
                            end;

                            GenJnl.Amount := StudentCharges.Amount;
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := StudentCharges.Description;
                            GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";

                            if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                               (StudentCharges.Charge = false) then begin
                                GenJnl."Bal. Account No." := GenSetup."Pre-Payment Account";

                                CReg.Reset;
                                CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                                CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                                CReg.SetRange(CReg."Student No.", StudentCharges."Student No.");
                                if CReg.Find('-') then begin


                                    CReg.Posted := true;
                                    CReg.Modify;
                                end;


                            end else
                                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                                   (StudentCharges.Charge = false) then begin
                                    GenJnl."Bal. Account No." := GenSetup."Pre-Payment Account";

                                    CReg.Reset;
                                    CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                                    CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                                    if CReg.Find('-') then begin
                                        CReg.Posted := true;
                                        CReg.Modify;
                                    end;



                                end else

                                    if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or
                                       (StudentCharges.Charge = true) then begin
                                        if Charges.Get(StudentCharges.Code) then
                                            GenJnl."Bal. Account No." := Charges."G/L Account";
                                    end;


                            GenJnl.Validate(GenJnl."Bal. Account No.");
                            if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                                if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                    GenJnl."Shortcut Dimension 2 Code" := Stages.Department;
                                end;

                            end else
                                if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                                    if Units.Get(StudentCharges.Programme, StudentCharges.Stage, StudentCharges.Unit) then begin
                                        GenJnl."Shortcut Dimension 2 Code" := Units.Department;
                                    end;
                                end;

                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            GenJnl."Due Date" := DueDate;
                            GenJnl.Validate(GenJnl."Due Date");
                            GenJnl.Insert;

                            //Distribute Money
                            if StudentCharges."Tuition Fee" = true then begin
                                if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                    if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
                                        Stages.TestField(Stages."Distribution Account");
                                        StudentCharges.TestField(StudentCharges.Distribution);
                                        if Cust.Get("Student No.") then begin
                                            CustPostGroup.Get(Cust."Customer Posting Group");

                                            GenJnl.Init;
                                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                                            GenJnl."Posting Date" := Today;
                                            GenJnl."Document No." := StudentCharges."Transacton ID";
                                            //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                                            GenJnl.Validate(GenJnl."Document No.");
                                            GenJnl."Journal Template Name" := 'SALES';
                                            GenJnl."Journal Batch Name" := 'STUD PAY';
                                            GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                                            GenJnl."Account No." := GenSetup."Pre-Payment Account";
                                            GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);
                                            GenJnl.Validate(GenJnl."Account No.");
                                            GenJnl.Validate(GenJnl.Amount);
                                            GenJnl.Description := 'Fee Distribution';
                                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                            GenJnl."Bal. Account No." := Stages."Distribution Account";
                                            GenJnl.Validate(GenJnl."Bal. Account No.");
                                            if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                                                if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                                    GenJnl."Shortcut Dimension 2 Code" := Stages.Department;
                                                end;

                                            end else
                                                if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                                                    if Units.Get(StudentCharges.Programme, StudentCharges.Stage, StudentCharges.Unit) then begin
                                                        GenJnl."Shortcut Dimension 2 Code" := Units.Department;
                                                    end;
                                                end;
                                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");

                                            GenJnl.Insert;

                                        end;
                                    end;
                                end;
                            end;
                            //End Distribution


                            StudentCharges.Recognized := true;
                            StudentCharges.Modify;

                        until StudentCharges.Next = 0;



                        /*
                        //Post
                        GenJnl.RESET;
                        GenJnl.SETRANGE("Journal Template Name",'SALES');
                        GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
                        IF GenJnl.FIND('-') THEN BEGIN
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnl);
                        MODIFY;
                        END;
                        */


                        GenJnl.SetRange("Journal Template Name", 'SALES');
                        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                        if GenJnl.Find('-') then begin
                            repeat
                                //window.OPEN('Posting:,#1######################');
                                //window.UPDATE(1,GenJnl."Line No.");
                                GLPosting.Run(GenJnl);
                            until GenJnl.Next = 0;
                            //window.CLOSE;
                        end;




                        GenJnl.Reset;
                        GenJnl.SetRange("Journal Template Name", 'SALES');
                        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                        GenJnl.DeleteAll;


                        if COMPANYNAME <> 'KABU Enterprise' then begin
                            Cust.Status := Cust.Status::Current;
                            Cust.Modify;
                        end;
                    end;





                    Posted := true;
                    Modify;



                end;

            end;
        }
        field(19; "Student Type"; Option)
        {
            OptionCaption = 'Full Time,Part Time,Online,Early Morning,Evening,Late Evening';
            OptionMembers = "Full Time","Part Time","Online","Early Morning",Evening,"Late Evening";
        }
        field(20; Posted; Boolean) { }
        field(21; "Units Taken"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       "Register for" = field("Register for"),
                                                       Semester = field(Semester)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51021; "Basket Units"; Integer)
        {
            CalcFormula = count("Student Unit Basket" where("Student No." = field("Student No."), Semester = field(Semester)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51022; "Basket Units Attachment"; Integer)
        {
            CalcFormula = count("Student Unit Basket" where("Student No." = field("Student No."), Semester = field(Semester), Attachment = filter(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "User ID"; Code[50]) { }
        field(23; "Total Paid"; Decimal)
        {
            CalcFormula = sum(Receipt.Amount where("Student No." = field("Student No."),
                                                    "Reg ID" = field("Reg. Transacton ID")));
            FieldClass = FlowField;
        }
        field(24; Status; Option)
        {
            CalcFormula = lookup(Customer.Status where("No." = field("Student No.")));
            FieldClass = FlowField;
            OptionCaption = 'Registration,Current,Alluminae,Dropped Out,Deffered,Suspended,Expelled,Discontinued,Withdrawn,Deceased,Transferred,Academic Leave,Completed';
            OptionMembers = Registration,Current,Alluminae,"Dropped Out",Deffered,Suspended,Expelled,Discontinued,Withdrawn,Deceased,Transferred,"Academic Leave",Completed;
        }
        field(25; "Status Change Date"; Date) { }
        field(26; "Fees Billed"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                              "Tuition Fee" = const(true), Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(27; "Total Billed"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                              "Student No." = field("Student No."), Reversed = filter(false), "Posted Amount" = filter(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; Reversed; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                IF UserSetup.GET(USERID) THEN
                IF UserSetup."Can Stop Reg."=FALSE THEN ERROR('Please note that you do not have the rights to stop the registration!');
                "Allow Adjustment" := TRUE;
                MODIFY;
                
                
                StudentUnits.RESET;
                StudentUnits.SETRANGE(StudentUnits."Student No.","Student No.");
                StudentUnits.SETRANGE(StudentUnits."Reg. Transacton ID","Reg. Transacton ID");
                IF StudentUnits.FIND('-') THEN
                StudentUnits.DELETEALL;
                 */

            end;
        }
        field(29; "Total Units"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       "Reg. Transacton ID" = field("Reg. Transacton ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Total Exempted"; Integer)
        {
            CalcFormula = count("Student Units Exemptions" where("Student No." = field("Student No."),
                                                                  Programme = field(Programme),
                                                                  Stage = field(Stage),
                                                                  Semester = field(Semester),
                                                                  Status = const(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "OLD No."; Code[20]) { }
        field(32; "Unbilled Charges"; Integer)
        {
            CalcFormula = count("Student Charges" where("Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                         "Student No." = field("Student No."),
                                                         Recognized = const(false)));
            FieldClass = FlowField;
        }
        field(33; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(35; "Student Card"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Student No." = field("Student No."),
                                                              "Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                              Code = const('CARD'),
                                                              Recognized = const(true)));
            FieldClass = FlowField;
        }
        field(36; "Admission No."; Code[30]) { }
        field(37; "Academic Year"; Code[20])
        {
            Description = 'Stores the reference to the academic year in the database';
            TableRelation = "Academic Year".Code;
        }
        field(38; "Admission Type"; Option)
        {
            OptionMembers = "JAB/Direct";
        }
        field(39; Options; Code[50])
        {
            TableRelation = "Programme Options".Code where("Programme Code" = field(Programme));

            trigger OnValidate()
            begin
                Stages.Reset;
                Stages.SetRange(Stages."Programme Code", Programme);
                Stages.SetRange(Stages.Code, Stage);
                if Stages.Find('-') then
                    if Stages."Allow Programme Options" = false then Error('Please note that Programme Option is not enabled at ' + Stage);
                CReg.Reset;
                CReg.SetRange("Student No.", "Student No.");
                if CReg.Find('-') then begin
                    repeat
                        CReg.Options := Options;
                        CReg.Modify;
                    until CReg.Next = 0;
                end;
            end;
        }
        field(47; "Registration Status"; Option)
        {
            OptionCaption = ' ,Specials,Academic Leave,WithHold,Deregister,Discontinue,Nullification';
            OptionMembers = " ",Specials,"Academic Leave",WithHold,Deregister,Discontinue,Nullification;
        }
        field(52; "General Remark"; Code[50]) { }
        field(53; "Allow Adjustment"; Boolean) { }
        field(54; Transfered; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                "Allow Adjustment" := true;
                Reversed := true;
                Modify;

                StudentUnits.Reset;
                StudentUnits.SetRange(StudentUnits."Student No.", "Student No.");
                StudentUnits.SetRange(StudentUnits."Reg. Transacton ID", "Reg. Transacton ID");
                if StudentUnits.Find('-') then
                    StudentUnits.DeleteAll;
            end;
        }
        field(55; Registered; Boolean)
        {

            trigger OnValidate()
            begin

                if Registered = false then Error('De-Registration is not Allowed');
                Sems.Reset;
                if Sems.Get(Semester) then
                    if Sems."Current Semester" = false then Error('Please note that you can only Register to the Current Semester');

                if Posted = false then Error('The Selected Registration has not been Posted');
                CalcFields("Total Billed");
                if "Total Billed" = 0 then Error('Please note that the Billed Amount can not be Zero');

                GenSetup.Get;
                if GenSetup."Allowed Reg. Fees Perc." = 0 then
                    Error('Please not that you must specify the Required Fees Percentage in the General setup');

                Custs.Reset;
                Custs.SetRange(Custs."No.", "Student No.");
                if Custs.Find('-') then begin
                    Custs.CalcFields(Custs."Balance (LCY)");
                    if ((("Total Billed" - Custs."Balance (LCY)") / "Total Billed") * 100) < GenSetup."Allowed Reg. Fees Perc." then begin
                        Error('You cannot register a student with a fee balance.');
                    end;
                end;


                if Registered = true then begin
                    CalcFields("Units Taken");

                    if Programmes.Get(Programme) then begin
                        if Programmes."Min No. of Courses" > 0 then begin
                            if "Units Taken" < Programmes."Min No. of Courses" then
                                Error('Student must register for a minimum of %1 course.', Programmes."Min No. of Courses")
                        end;

                        /*
                        IF Programmes."Max No. of Courses" > 0 THEN BEGIN
                        IF "Units Taken" > Programmes."Max No. of Courses" THEN
                        ERROR('Student must register for a maximum of %1 course.',Programmes."Max No. of Courses")
                        END;
                        */

                    end;
                end;


                "Date Registered" := Today;
                "Allow Adjustment" := true;
                Modify;

            end;
        }
        field(56; "Re-sits"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       "Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                       Taken = const(true),
                                                       "Repeat Unit" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; "Cummulative Score"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where("Student No." = field("Student No."),
                                                                 Programme = field(Programme),
                                                                 Stage = field("Cummulative Year Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Cummulative Units Taken"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       Stage = field("Cummulative Year Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Options Filter"; Code[50])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Options".Code where("Programme Code" = field("Programme Filter"));
        }
        field(60; "System Created"; Boolean) { }
        field(61; Gender; Option)
        {
            CalcFormula = lookup(Customer.Gender where("No." = field("Student No.")));
            Description = 'to be used in summary by gender report';
            FieldClass = FlowField;
            OptionMembers = " ",Male,Female;
        }
        field(62; Faculty; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field(Programme)));
            Description = 'to be used in exam labels';
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SCHOOL'));
        }
        field(63; "Intake Code"; Code[20])
        {
            Editable = false;
            TableRelation = Intake.Code;

            trigger OnValidate()
            begin
                /*
                StudentCharges.RESET;
                StudentCharges.SETRANGE(StudentCharges."Student No.","Student No.");
                StudentCharges.SETRANGE(StudentCharges."Reg. Transacton ID","Reg. Transacton ID");
                StudentCharges.SETRANGE(StudentCharges.Recognized,FALSE);
                IF StudentCharges.FIND('-') THEN
                StudentCharges.DELETEALL;
                
                
                StageCharges.RESET;
                StageCharges.SETRANGE(StageCharges."Programme Code",Programme);
                StageCharges.SETRANGE(StageCharges."Stage Code",Stage);
                //StageCharges.SETRANGE(StageCharges."Student Type",StageCharges."Student Type"::" ");
                StageCharges.SETRANGE(StageCharges."Settlement Type","Settlement Type");
                IF StageCharges.FIND('-') THEN BEGIN
                REPEAT
                //IF StageCharges.Semester = '' THEN BEGIN
                StudentCharges.INIT;
                StudentCharges.Programme:=Programme;
                StudentCharges.Stage:=Stage;
                StudentCharges.Semester:=Semester;
                StudentCharges."Student No.":="Student No.";
                StudentCharges."Reg. Transacton ID":="Reg. Transacton ID";
                StudentCharges."Transaction Type":=StudentCharges."Transaction Type"::"Stage Fees";
                StudentCharges.Date:="Registration Date";
                StudentCharges.Code:=StageCharges.Code;
                StudentCharges.Description:=StageCharges.Description;
                StudentCharges.Amount:=StageCharges.Amount;
                StudentCharges."Recovered First":=StageCharges."Recovered First";
                StudentCharges."Recovery Priority":=StageCharges."Recovery Priority";
                StudentCharges.Distribution:=StageCharges."Distribution (%)";
                StudentCharges."Distribution Account":=StageCharges."Distribution Account";
                StudentCharges."Transacton ID":='';
                StudentCharges.Charge:=TRUE;
                StudentCharges.VALIDATE(StudentCharges."Transacton ID");
                StudentCharges.INSERT;
                UNTIL StageCharges.NEXT=0;
                END;
                */

            end;
        }
        field(64; "Cummulative Year Filter"; Code[20])
        {
            Caption = 'Cummulative Year Filter';
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(65; "Result Status"; Option)
        {
            OptionCaption = ',Pass,Fail';
            OptionMembers = ,Pass,Fail;
        }
        field(66; "Entry No."; Integer) { }
        field(67; "Audit Issue"; Boolean) { }
        field(68; "Date Registered"; Date) { }
        field(968; "Date Graduated"; Date) { }
        field(69; "Programme Exam Category"; Code[20])
        {
            CalcFormula = lookup(Programme."Exam Category" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(70; "Not Billed"; Boolean) { }
        field(71; "Cust Billed"; Boolean)
        {
            FieldClass = FlowFilter;
        }
        field(72; Marks; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Programme = field(Programme),
                                                                 Stage = field(Stage),
                                                                 Semester = field(Semester),
                                                                 "Student No." = field("Student No.")));
            FieldClass = FlowField;
        }

        field(74; "Sem Reg Counter"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(75; "Check Reg"; Boolean) { }
        field(76; "Helb Beneficiary"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Customer No." = field("Student No."),
                                                            "Document No." = filter('*HELB*')));
            FieldClass = FlowField;
        }
        field(77; Blocked; Option)
        {
            CalcFormula = lookup(Customer.Blocked where("No." = field("Student No.")));
            FieldClass = FlowField;
            OptionCaption = ',Ship,Invoice,All';
            OptionMembers = ,Ship,Invoice,All;
        }
        field(78; "Prog Exist"; Integer)
        {
            CalcFormula = count(Programme where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(79; "Fee Exist"; Integer)
        {
            CalcFormula = count("Fee By Stage" where("Programme Code" = field(Programme),
                                                      "Settlemet Type" = field("Settlement Type"),
                                                      "Stage Code" = field(Stage)));
            FieldClass = FlowField;
        }
        field(80; Session; Code[20])
        {
            TableRelation = Intake.Code;
        }
        field(81; "Sem Repeated"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field("Student No."),
                                                             Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(82; "Student Status"; Option)
        {
            CalcFormula = lookup(Customer.Status where("No." = field("Student No.")));
            FieldClass = FlowField;
            OptionCaption = 'Registration,Current,Alluminae,Dropped Out,Differed,Suspended,Expulsion,Discontinued,Deferred,Deceased,Transferred';
            OptionMembers = Registration,Current,Alluminae,"Dropped Out",Differed,Suspended,Expulsion,Discontinued,Deferred,Deceased,Transferred;
        }
        field(83; "Account Count"; Integer)
        {
            CalcFormula = count(Customer where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(84; "Exam Status"; Code[50])
        {
            TableRelation = "Results Status".Code;
        }
        field(85; "Units Passed"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Semester = field(Semester),
                                                       Programme = field(Programme),
                                                       Stage = field(Stage),
                                                       "Result Status" = filter('PASS')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(86; "Units Failed"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Semester = field(Semester),
                                                       Programme = field(Programme),
                                                       Stage = field(Stage),
                                                       "Result Status" = const('FAIL')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(87; "Units Repeat"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Semester = field(Semester),
                                                       Programme = field(Programme),
                                                       Stage = field(Stage),
                                                       "Result Status" = filter('REPEAT')));
            FieldClass = FlowField;
        }
        field(89; "Exam Grade"; Code[50]) { }
        field(50000; "Cum Average"; Decimal)
        {
            CalcFormula = sum("Student Units"."Final Score" where("Student No." = field("Student No."),
                                                                   Semester = field("Semester Filter"),
                                                                   Programme = field("Programme Filter"),
                                                                   Stage = field("Stage Filter"),
                                                                   Reversed = const(false),
                                                                   "Attachment Unit" = const(false),
                                                                   "Ignore in Cumm  Average" = const(false),
                                                                   "Supp Taken" = const(false)));
            FieldClass = FlowField;
        }
        field(50001; "Cum Units Done"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Stage = field("Stage Filter"),
                                                       Programme = field(Programme),
                                                       Reversed = const(false),
                                                       "Attachment Unit" = const(false),
                                                      "Ignore in Cumm  Average" = const(false),
                                                       // "Total Score" = filter(> 0)
                                                       "Supp Taken" = const(false)));

            FieldClass = FlowField;
        }
        field(50002; "Cum Units Passed"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       "Result Status" = filter('PASS'),
                                                       Stage = field("Stage Filter"),
                                                       Reversed = const(false),
                                                       "Supp Taken" = const(false),
                                                       "Total Score" = filter(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Cum Units Failed"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       "Result Status" = filter('FAIL'),
                                                       Stage = field("Stage Filter"),
                                                       Reversed = const(false),
                                                        "Total Score" = filter(> 0),
                                                       "Supp Taken" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52002; "Cum Units Deffered"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                     Stage = field("Stage Filter"),
                                                       Programme = field(Programme),
                                                       Reversed = const(false),
                                                       "Attachment Unit" = const(false),
                                                      "Ignore in Cumm  Average" = const(false),
                                                        "Total Score" = filter(0),
                                                       "Supp Taken" = const(false)));
            Editable = false;

        }
        field(52003; "Cum Units Deffered CAT"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                     Stage = field("Stage Filter"),
                                                       Programme = field(Programme),
                                                       Reversed = const(false),
                                                       "Attachment Unit" = const(false),
                                                      "Ignore in Cumm  Average" = const(false),
                                                        "CAT Total Marks" = filter(0),
                                                       "Supp Taken" = const(false)));
            Editable = false;

        }
        field(52004; "Cum Units Deffered EXAM"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                     Stage = field("Stage Filter"),
                                                       Programme = field(Programme),
                                                       Reversed = const(false),
                                                       "Attachment Unit" = const(false),
                                                      "Ignore in Cumm  Average" = const(false),
                                                        "Exam Marks" = filter(0),
                                                       "Supp Taken" = const(false)));
            Editable = false;

        }
        field(50004; "Programme Average"; Decimal)
        {
            CalcFormula = sum("Student Units"."Final Score" where("Student No." = field("Student No."),
                                                                   Programme = field(Programme),
                                                                   "Attachment Unit" = const(false),
                                                                   "Ignore in Cumm  Average" = const(false),
                                                                   "Supp Taken" = const(false)));
            FieldClass = FlowField;
        }
        field(50005; "Programme Units Done"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field("Programme Filter"),
                                                       "Attachment Unit" = const(false),
                                                       "Reg Reversed" = const(false),
                                                       "Ignore in Final Average" = const(false),
                                                       "Supp Taken" = const(false)));
            FieldClass = FlowField;
        }

        field(50007; "Current Sem"; Boolean)
        {
            CalcFormula = lookup(Semesters."Current Semester" where(Code = field(Semester)));
            FieldClass = FlowField;
        }
        field(50008; "Registered Reason"; Text[100]) { }
        field(50009; "Registered By"; Code[20]) { }
        field(50010; "Study Year"; Code[20]) { }
        field(50011; "Cust Exist"; Integer)
        {
            CalcFormula = count(Customer where("No." = field("Student No.")));
            FieldClass = FlowField;
        }

        field(50012; "Cumm Score"; Decimal) { }
        field(50512; "Cumm Absent Days"; Decimal) { }
        field(50812; "Cumm Units"; Decimal) { }
        field(51012; "Billed Units"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Student Units" WHERE("Student No." = FIELD("Student No."), Semester = FIELD(Semester), Billed = CONST(true)));
        }
        field(50013; "Marks Status"; Option)
        {
            OptionCaption = ' ,R,RP1,RD,RPC,RPD,RPE,RA,RAS,M,TF,TFS,R2,RP12,RD2,RPC2,RPD2,RPE2,RA2,RAS2,M2,TF2,TFS2,R3,RP13,RD3,RPC3,RPD3,RPE3,RA3,RAS3,M3,TF3,TFS3,R4,RP14,RD4,RPC4,RPD4,RPE4,RA4,RAS4,M4,TF4,TFS4,R5,RP15,RD5,RPC5,RPD5,RPE5,RA5,RAS5,M5,TF5,TFS5';
            OptionMembers = " ",R,RP1,RD,RPC,RPD,RPE,RA,RAS,M,TF,TFS,R2,RP12,RD2,RPC2,RPD2,RPE2,RA2,RAS2,M2,TF2,TFS2,R3,RP13,RD3,RPC3,RPD3,RPE3,RA3,RAS3,M3,TF3,TFS3,R4,RP14,RD4,RPC4,RPD4,RPE4,RA4,RAS4,M4,TF4,TFS4,R5,RP15,RD5,RPC5,RPD5,RPE5,RA5,RAS5,M5,TF5,TFS5;
        }
        field(50014; "Units Status Count"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       "Result Status" = filter('FAIL')));
            FieldClass = FlowField;
        }
        field(50015; "Sem Pass Count"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field("Student No."),
                                                             Programme = field(Programme),
                                                             "Exam Status" = filter('PASS'),
                                                             Stage = field("Stage Filter"),
                                                             Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(50016; "Cum Units Count"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Semester = field("Semester Filter"),
                                                       Programme = field("Programme Filter"),
                                                       Stage = field("Stage Filter"),
                                                       Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(50017; "Cum Units Passed Cores"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       "Result Status" = filter('PASS'),
                                                       Stage = field("Stage Filter"),
                                                       Reversed = const(false),
                                                       "Supp Taken" = const(false),
                                                       "Unit Type LK" = filter(Core | Required)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50046; "CF Taken"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where(Programme = field(Programme),
                                                                    "Student No." = field("Student No."),
                                                                    Stage = field(Stage),
                                                                    Semester = field(Semester),
                                                                    "Register for" = field("Register for")));
            FieldClass = FlowField;
        }
        field(50146; "Semester CF"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("Student No."), Semester = field(Semester)));

            FieldClass = FlowField;
        }
        field(50151; "Student CF"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("Student No."),
            Grade = filter(<> ''), "Grade Exists" = filter(true), Failed = const(false), Programme = field("Programme")));

            FieldClass = FlowField;
        }
        field(50153; "Student Semester CF"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("Student No."),
            Grade = filter(<> ''), "Grade Exists" = filter(true), Failed = const(false), Programme = field(Programme), Semester = field(Semester)));

            FieldClass = FlowField;
        }
        field(59151; "Global Settlement Type"; Option)
        {
            OptionMembers = PSSP,KUCCPS;
            CalcFormula = lookup("Settlement Type"."Global Type" where(Code = field("Settlement Type")));

            FieldClass = FlowField;
        }
        field(50147; "Semester Units"; Integer)
        {
            CalcFormula = Count("Student Units" where("Student No." = field("Student No."), Semester = field(Semester)));

            FieldClass = FlowField;
        }
        field(50150; "Student Units"; Integer)
        {
            CalcFormula = Count("Student Units" where("Student No." = field("Student No.")));

            FieldClass = FlowField;
        }
        field(50148; "Semester GPA"; Decimal)
        {
            CalcFormula = sum("Student Units".GPA where("Student No." = field("Student No."), Semester = field(Semester)));

            FieldClass = FlowField;
        }
        field(50149; "Student GPA"; Decimal)
        {
            CalcFormula = sum("Student Units".GPA where("Student No." = field("Student No.")));

            FieldClass = FlowField;
        }
        field(50233; "Programme GPA Points"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Student Units"."CF GPA" where("Student No." = field("Student No."),
                                                              GPA = filter(> 0), Failed = const(false), Programme = field("Programme")));

        }
        field(50234; "Semester GPA Points"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Student Units"."CF GPA" where("Student No." = field("Student No."),
                                                              GPA = filter(> 0), Failed = const(false), Programme = field(Programme), Semester = field(Semester)));

        }
        field(50051; "Current Cumm Score"; Decimal) { }
        field(50052; "CF Count"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where(Programme = field(Programme),
                                                                    "Student No." = field("Student No."),
                                                                    Stage = field("Stage Filter"),
                                                                    "Supp Taken" = filter(false),
                                                                    "Attachment Unit" = filter(false),
                                                                    "Total Score" = filter(> 0),
                                                                    "Ignore in Cumm  Average" = filter(false)));
            FieldClass = FlowField;
        }
        field(50053; "CF Total Score"; Decimal)
        {
            CalcFormula = sum("Student Units"."CF Score" where(Programme = field(Programme),
                                                                "Student No." = field("Student No."),
                                                                Stage = field("Stage Filter"),
                                                                "Supp Taken" = filter(false),
                                                                "Total Score" = filter(> 0),
                                                                "Ignore in Cumm  Average" = filter(false)));
            FieldClass = FlowField;
        }
        field(50054; "Current Cumm Grade"; Code[20]) { }
        field(50055; "Cumm Grade"; Code[20]) { }
        field(50056; Names; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(50057; "Programme Campus"; Code[20])
        {
            CalcFormula = lookup("Programme Stages"."Campus Code" where("Programme Code" = field(Programme),
                                                                         Code = field(Stage)));
            FieldClass = FlowField;
        }
        field(50059; "Manual Exam Status"; Boolean)
        {
            CalcFormula = lookup("Results Status"."Manual Status Processing" where(Code = field("Exam Status")));
            FieldClass = FlowField;
        }
        field(50060; Award; Text[200]) { }
        field(50061; "Campus Filter"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No.")));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50062; "Registered Units"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Semester = field("Semester Filter"),
                                                       Stage = field("Stage Filter"),
                                                       "Total Score" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(50088; "Hostel Charges"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Entry Type" = filter("Initial Entry"),
                                                                         "Customer No." = field("Student No."),
                                                                         "Posting Date" = field("Date Filter")
                                                                         ));
            FieldClass = FlowField;
        }
        field(50089; Balance1; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(50090; "Hostel Charges 1"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Student No." = field("Student No."),
                                                              Semester = field(Semester),
                                                              "Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                              Code = filter('ACCOMODATION')));
            FieldClass = FlowField;
        }
        field(50091; "Debit Amount"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount" where("Entry Type" = const("Initial Entry"),
                                                                                 "Customer No." = field("Student No."),
                                                                                 "Posting Date" = field("Date Filter")
                                                                                 ));
            FieldClass = FlowField;
        }
        field(50092; "Credit Amount"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount" where("Customer No." = field("Student No."),
                                                                                  "Posting Date" = field("Date Filter"),

                                                                                  "Entry Type" = filter("Initial Entry")));
            FieldClass = FlowField;
        }
        field(50093; "Total Debit 1"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Student No." = field("Student No."),
                                                              Semester = field(Semester),
                                                              "Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                              Code = filter(<> 'ACCOMODATION'),
                                                              "Tuition Fee" = filter(true)));
            FieldClass = FlowField;
        }
        field(60000; "Average Semester GPA"; Decimal)
        {
            CalcFormula = average("Student Units"."Final Score" where(Grade = filter(<> ''),
                                                                       "Student No." = field("Student No."),
                                                                       Semester = field(Semester),
                                                                       "Academic Year" = field("Academic Year")));
            DecimalPlaces = 1 : 1;
            FieldClass = FlowField;
        }
        field(60001; "Average Cummulative GPA"; Decimal)
        {
            CalcFormula = average("Student Units"."Final Score" where("Student No." = field("Student No."),
                                                                       Grade = filter(<> '')));
            DecimalPlaces = 1 : 1;
            FieldClass = FlowField;
        }

        field(60003; "Repeat"; Boolean)
        {
            CalcFormula = exist("Student Units" where(Failed = const(true),
                                                       "Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                       "Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60004; "Semester Points"; Decimal)
        {
            CalcFormula = sum("Student Units"."Unit Points" where(Grade = filter(<> ''),
                                                                   Grade = filter('A' | 'A+' | 'B' | 'B+' | 'C' | 'C+' | 'D' | 'D+' | 'E'),
                                                                   "Student No." = field("Student No."),
                                                                   Semester = field(Semester),
                                                                   "Academic Year" = field("Academic Year")));
            FieldClass = FlowField;
        }
        field(60005; "Semester Hours"; Decimal)
        {
            CalcFormula = sum("Student Units"."Credit Hours" where(Grade = filter(<> ''),
                                                                    Grade = filter('A' | 'A+' | 'B' | 'B+' | 'C' | 'C+' | 'D' | 'D+' | 'E' | '!'),
                                                                    "Student No." = field("Student No."),
                                                                    Semester = field(Semester),
                                                                    "Academic Year" = field("Academic Year")));
            FieldClass = FlowField;
        }
        field(60006; "Cummulative Hours"; Decimal)
        {
            CalcFormula = sum("Student Units"."Credit Hours" where(Grade = filter(<> ''),
                                                                    Grade = filter('A' | 'A+' | 'B' | 'B+' | 'C' | 'C+' | 'D' | 'D+' | 'E' | '!'),
                                                                    "Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60007; "Cummulative Points"; Decimal)
        {
            CalcFormula = sum("Student Units"."Unit Points" where(Grade = filter(<> ''),
                                                                   Grade = filter('A' | 'A+' | 'B' | 'B+' | 'C' | 'C+' | 'D' | 'D+' | 'E'),
                                                                   "Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60008; "Cumm GPA"; Decimal) { }
        field(61008; "Cumm GPA Ponts"; Decimal) { }
        field(60009; "Sem GPA"; Decimal) { }

        field(60011; "Semester Average"; Decimal)
        {
            CalcFormula = average("Student Units"."Final Score" where(Grade = filter('A' | 'A+' | 'B' | 'B+' | 'C' | 'C+' | 'D' | 'D+' | 'E' | 'F'),
                                                                       "Student No." = field("Student No."),
                                                                       Semester = field(Semester),
                                                                       "Academic Year" = field("Academic Year")));
            FieldClass = FlowField;
        }
        field(60012; "Cummulative Average"; Decimal)
        {
            CalcFormula = average("Student Units"."Final Score" where(Grade = filter('A' | 'A+' | 'B' | 'B+' | 'C' | 'C+' | 'D' | 'D+' | 'E' | 'F'),
                                                                       "Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60013; "Semester Grade"; Code[20]) { }
        field(60014; "Cummulative Grade"; Code[20]) { }
        field(60015; "Campus Code"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60016; "Student Name"; Text[250])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Student No.")));
            FieldClass = FlowField;
        }

        field(60018; "Cumm Status"; Code[20]) { }
        field(60019; "Sem FAIL Count"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field("Student No."),
                                                             Programme = field(Programme),
                                                             "Exam Status" = filter(<> 'PASS'),
                                                             Stage = field("Stage Filter"),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(60020; "School Filter"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field(Programme)));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(60920; "Department Filter"; Code[20])
        {
            CalcFormula = lookup(Programme."Department Code" where(Code = field(Programme)));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }

        field(60022; Balance; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("Student No."),
                                                                         "Entry Type" = const("Initial Entry")));
            FieldClass = FlowField;
        }
        field(60023; "First Time Student"; Boolean) { }
        field(60024; "Fee Structure Exists"; Integer)
        {
            CalcFormula = count("Fee By Stage" where("Programme Code" = field(Programme),
                                                      "Stage Code" = field(Stage),
                                                      "Settlemet Type" = field("Settlement Type"),
                                                      Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(60025; "Reg Count"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field("Student No."),
                                                             Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(60026; "Old Prog Code"; Code[20])
        {
            CalcFormula = lookup(Programme."Old Code" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(60027; "Class Code"; Code[30])
        {
            TableRelation = "Course Classes";
        }
        field(60028; "Mass Stop"; Boolean) { }
        field(60029; "Mass Stopped By"; Code[20]) { }
        field(60030; "Mass Stooped Date"; Date) { }
        field(60031; "Room No"; Code[20])
        {
            CalcFormula = lookup("Students Hostel Rooms"."Space No" where(Student = field("Student No."),
                                                                           Cleared = const(false)));
            FieldClass = FlowField;
        }
        field(60032; "Hostel No"; Code[20])
        {
            CalcFormula = lookup("Students Hostel Rooms"."Hostel No" where(Student = field("Student No."),
                                                                            Cleared = const(false)));
            FieldClass = FlowField;
        }
        field(60033; "ID Number"; Code[20])
        {
            CalcFormula = lookup(Customer."ID No" where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60034; "Total Billed Accomodation"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Reg. Transacton ID" = field("Reg. Transacton ID"),
                                                              "Student No." = field("Student No."),
                                                              accommodation = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60035; "Programme Category"; Option)
        {
            CalcFormula = lookup(Programme.Category where(Code = field(Programme)));
            FieldClass = FlowField;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,PHD,Professional,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List";
        }

        field(60037; "Allow Exam Attendance"; Boolean)
        {

            trigger OnValidate()
            begin
                if UserSetup.Get(UserId) then begin
                    if UserSetup."Can Allow Exam Attendance" = false then Error('Please note that you dont have the rights to Allow Exam Attendance');
                end else begin
                    Error('Please note that you dont have the rights to Allow Exam Attendance');
                end;
            end;
        }
        field(60038; "Exam Allowed By"; Code[20]) { }
        field(60039; "Exam Allowed On"; Date) { }
        field(60040; "Retake Units"; Integer) { }
        field(60041; "Failed Perc"; Decimal) { }
        field(60042; "Cum Units Special"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("Student No."),
                                                                    Programme = field(Programme),
                                                                    Stage = field("Stage Filter"),
                                                                    Semester = field("Semester Filter"),
                                                                    Reversed = const(false),
                                                                    "Supp Taken" = const(false),
                                                                    "Result Status" = const('SPECIAL')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60043; "Prog Online Released"; Boolean)
        {
            CalcFormula = lookup(Programme."Release Online Results" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(60044; "Dean Passed Units"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       Stage = field("Stage Filter"),
                                                       "Result Status" = filter('PASS'),
                                                       Semester = field("Semester Filter"),
                                                       Reversed = const(false),
                                                       "Supp Taken" = const(false),
                                                       Grade = filter('A' | 'B' | 'C')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60045; "VC Passed Units"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       Stage = field("Stage Filter"),
                                                       "Result Status" = filter('PASS'),
                                                       Semester = field("Semester Filter"),
                                                       Reversed = const(false),
                                                       "Supp Taken" = const(false),
                                                       Grade = filter('A' | 'B')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60046; "Registration Type Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'Normal,Supplementary,Special';
            OptionMembers = Normal,Supplementary,Special;
        }
        field(60047; "Exemption Code"; Code[20])
        {
            TableRelation = "Exemption Codes".Code;

            trigger OnValidate()
            begin
                ExempLine.Reset;
                ExempLine.SetRange(ExempLine.Code, "Exemption Code");
                if ExempLine.Find('-') then begin
                    repeat
                        StudExemp.Init;
                        StudExemp.Programme := Programme;
                        StudExemp.Stage := Stage;
                        StudExemp.Unit := ExempLine.Unit;
                        StudExemp.Semester := Semester;
                        StudExemp."Student No." := "Student No.";
                        StudExemp."Register for" := "Register for";
                        StudExemp.Description := ExempLine."Unit Name";
                        StudExemp.CF := ExempLine.CF;
                        StudExemp."Unit Name" := ExempLine."Unit Name";
                        StudExemp.Insert;
                    until ExempLine.Next = 0;
                end;
            end;
        }
        field(60048; "Graduated List Count"; Integer)
        {
            CalcFormula = count("Graduated Students" where("Student No" = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60049; "Allow Late Registration"; Boolean)
        {

            trigger OnValidate()
            begin
                if UserSetup.Get(UserId) then begin
                    if UserSetup."Allow Late Registration" = false then Error('Please note that you dont have the rights to Allow Late Registration');
                end else begin
                    Error('Please note that you dont have the rights to Allow Late Registration');
                end;
                if "Allow Late Registration" = true then
                    "Late Registration Deadline" := Today + 3
                else
                    "Late Registration Deadline" := 0D;
            end;
        }
        field(60050; "Late Registration Deadline"; Date) { }
        field(60051; "Additional CF"; Decimal)
        {

            trigger OnValidate()
            begin
                if UserSetup.Get(UserId) then begin
                    if UserSetup."Allow Late Registration" = false then Error('Please note that you dont have the rights to Allow additional CF');
                end else begin
                    Error('Please note that you dont have the rights to Allow additional CF');
                end;
            end;
        }
        field(60052; "Nationality Code"; Code[20])
        {
            CalcFormula = lookup(Customer.Nationality where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60053; "Entry Intake"; Code[20])
        {
            CalcFormula = lookup(Customer."Entry Intake" where("No." = field("Student No.")));
            FieldClass = FlowField;
            TableRelation = Intake.Code;
        }
        field(60054; "Stage Online Released"; Boolean)
        {
            CalcFormula = lookup("Programme Stages"."Block Online Results Release" where("Programme Code" = field(Programme),
                                                                                          Code = field(Stage)));
            FieldClass = FlowField;
        }
        field(60055; "Application No"; Code[20])
        {
            CalcFormula = lookup(Customer."Application No." where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60056; "Study Year Filter"; Code[20])
        {
            FieldClass = FlowFilter;

        }
        field(60057; "Fine Pay Exist"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Customer No." = field("Student No."),
                                                            Description = const('FINES-Bank Deposit')));
            FieldClass = FlowField;
        }
        field(60058; "Stage Filter Count"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field("Student No."),
                                                             Stage = field("Stage Filter")));
            FieldClass = FlowField;
        }
        field(60059; "Option Lk"; Code[20])
        {
            CalcFormula = lookup("Course Registration".Options where("Student No." = field("Student No."),
                                                                      Stage = filter('Y4S2')));
            FieldClass = FlowField;
        }

        field(60061; "CF Count Fail"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where(Programme = field(Programme),
                                                                    "Student No." = field("Student No."),
                                                                    Stage = field("Stage Filter"),
                                                                    "Supp Taken" = filter(false),
                                                                    "Attachment Unit" = filter(false),
                                                                    "Result Status" = filter('FAIL')));
            FieldClass = FlowField;
        }
        field(60062; "Cum Units Failed Specials"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Programme = field(Programme),
                                                       "Result Status" = filter('FAIL'),
                                                       Stage = field("Stage Filter"),
                                                       Reversed = const(false),
                                                       "Supp Taken" = const(false),
                                                       "Grade Prefix" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60063; "CF Count Cores"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where(Programme = field(Programme),
                                                                    "Student No." = field("Student No."),
                                                                    Stage = field("Stage Filter"),
                                                                    "Supp Taken" = filter(false),
                                                                    "Attachment Unit" = filter(false),
                                                                    "Total Score" = filter(> 0),
                                                                    "Unit Type" = filter(Core | Required)));
            FieldClass = FlowField;
        }
        field(60064; "CF Total Score Cores"; Decimal)
        {
            CalcFormula = sum("Student Units"."CF Score" where(Programme = field(Programme),
                                                                "Student No." = field("Student No."),
                                                                Stage = field("Stage Filter"),
                                                                "Supp Taken" = filter(false),
                                                                "Total Score" = filter(> 0),
                                                                "Unit Type" = filter(Core | Required)));
            FieldClass = FlowField;
        }
        field(60065; "Programme Cores"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field(Programme),
                                                        "Stage Code" = field("Stage Filter")));
            FieldClass = FlowField;
        }
        field(60066; "Option Group"; Code[20])
        {
            CalcFormula = lookup("Programme Options"."Option Group" where("Programme Code" = field(Programme),
                                                                           Code = field(Options)));
            FieldClass = FlowField;
        }
        field(60068; "InCurrent Sem"; Integer)
        {
            CalcFormula = count("Course Registration" where("Current Sem" = filter(true),
                                                             "Student No." = field("Student No.")));
            FieldClass = FlowField;
        }

        field(60070; Region; Code[20])
        {
            CalcFormula = lookup(Customer.county where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(60071; Defered; Boolean) { }

        field(60073; Residency; Option)
        {
            OptionMembers = ,Resident,"Non Resident";
        }
        field(60074; "Allow Class Attendance"; Boolean)
        {
            trigger OnValidate()
            var
                UserRec: Record "User Setup";
            begin
                if UserRec.get(Database.UserId) then
                    UserRec.TestField("Can Allow Exam Attendance", true)
                else
                    error('Please note that you dont have the rights to allow class attendance');
            end;
        }
        field(51700; "Validate Proforma Charges"; boolean)
        {
            trigger OnValidate()
            var
                progCat: code[20];
                HostelT: Record "Hostel Card";
                IsFirstTime: Boolean;
            begin
                IF Cust.GET("Student No.") THEN;
                Cust.TESTFIELD("Global Dimension 1 Code");
                //Cust.TESTFIELD(Cust."Current Settlement Type");

                Cust.CalcFields("Attempted Units");
                CalcFields("Programme Category");
                if Cust."Attempted Units" = 0 then
                    IsFirstTime := true
                else
                    IsFirstTime := false;

                StudentChargesTemp.RESET;
                StudentChargesTemp.SETRANGE(StudentChargesTemp."Student No.", "Student No.");
                IF StudentChargesTemp.FIND('-') THEN
                    StudentChargesTemp.DELETEALL;

                TESTFIELD(Programme);
                //TESTFIELD("Student Type");
                CALCFIELDS("Basket Units");
                CALCFIELDS("Basket Units Attachment");
                CALCFIELDS("Campus Code");
                Prog.get(Programme);

                ProgCategory.reset;
                ProgCategory.setrange(Category, prog.Category);
                if ProgCategory.find('-') then
                    progCat := ProgCategory.Code;

                IF "Register for" = "Register for"::"Unit/Subject" THEN BEGIN
                    //TESTFIELD("Settlement Type");
                    SettlementType.GET("Settlement Type");
                    SettlementType.TESTFIELD("Tuition G/L Account");
                    IF "Basket Units" = 0 THEN ERROR('Please select the units to be billed');
                    UnitFees := 0;

                    StudUnitBasket.RESET;
                    StudUnitBasket.SETRANGE(StudUnitBasket."Student No.", "Student No.");
                    StudUnitBasket.SETRANGE(StudUnitBasket.Semester, Semester);
                    StudUnitBasket.SETRANGE(StudUnitBasket.Submitted, false);
                    IF StudUnitBasket.FIND('-') THEN BEGIN
                        REPEAT
                            UnitFees := 0;
                            StudUnitBasket.testfield(Campus);
                            StudUnitBasket.CALCFIELDS(StudUnitBasket.Attachment);
                            StudUnitBasket.CALCFIELDS("Dissertation Unit");
                            StudUnitBasket.CALCFIELDS("CF Count");
                            StudUnitBasket.CALCFIELDS("Charge CF");
                            FeeByUnit.RESET; // Check if the fees has exists for the specific unit
                                             // FeeByUnit.SETRANGE(FeeByUnit."Programme Code", Programme);
                                             //FeeByUnit.SETRANGE(FeeByUnit."Student Type", StudUnitBasket."Mode of Study");
                            FeeByUnit.SETRANGE(FeeByUnit."Unit Code", StudUnitBasket.Unit);
                            FeeByUnit.SETRANGE(FeeByUnit."Settlemet Type", "Settlement Type");
                            IF FeeByUnit.FIND('-') THEN BEGIN
                                if StudUnitBasket."CF Count" > StudUnitBasket."Charge CF" then
                                    UnitFees := FeeByUnit."Unit Fees" * StudUnitBasket."CF Count"
                                else
                                    UnitFees := FeeByUnit."Unit Fees" * StudUnitBasket."Charge CF";
                                ExamsFees := FeeByUnit."Exam Fees";
                            END;

                            /*         IF UnitFees = 0 THEN BEGIN
                                        FeeByUnit.RESET; // Check if the fees has exists for the Programme units
                                        FeeByUnit.SETRANGE(FeeByUnit."Programme Code", Programme);
                                        FeeByUnit.SETRANGE(FeeByUnit."Student Type", StudUnitBasket."Mode of Study");
                                        FeeByUnit.SETRANGE(FeeByUnit."Campus Code", Cust."Global Dimension 1 Code");
                                        FeeByUnit.SETRANGE(FeeByUnit."Settlemet Type", "Settlement Type");
                                        IF "First Time Student" = true THEN
                                            FeeByUnit.SETRANGE(FeeByUnit."Applicable Group", FeeByUnit."Applicable Group"::"New Students")
                                        ELSE
                                            FeeByUnit.SETRANGE(FeeByUnit."Applicable Group", FeeByUnit."Applicable Group"::"Continuing Students");
                                        IF FeeByUnit.FIND('-') THEN begin
                                            if StudUnitBasket."CF Count" > 0 then
                                                UnitFees := FeeByUnit."Unit Fees" * StudUnitBasket."CF Count"
                                            else
                                                UnitFees := FeeByUnit."Unit Fees" * StudUnitBasket."Charge CF";
                                            ExamsFees := FeeByUnit."Exam Fees";
                                        end;
                                    END;
                                    IF UnitFees = 0 THEN BEGIN
                                        FeeByUnit.RESET; // Check if the fees has exists for the Programme Category
                                        FeeByUnit.SETRANGE(FeeByUnit."Programme Category", ProgCat);
                                        FeeByUnit.SETRANGE(FeeByUnit."Student Type", StudUnitBasket."Mode of Study");
                                        FeeByUnit.SETRANGE(FeeByUnit."Campus Code", Cust."Global Dimension 1 Code");
                                        FeeByUnit.SETRANGE(FeeByUnit."Settlemet Type", "Settlement Type");
                                        FeeByUnit.SETRANGE("Programme Code", '');
                                        IF "First Time Student" = true THEN
                                            FeeByUnit.SETRANGE(FeeByUnit."Applicable Group", FeeByUnit."Applicable Group"::"New Students")
                                        ELSE
                                            FeeByUnit.SETRANGE(FeeByUnit."Applicable Group", FeeByUnit."Applicable Group"::"Continuing Students");
                                        IF FeeByUnit.FIND('-') THEN begin
                                            if StudUnitBasket."CF Count" > 0 then
                                                UnitFees := FeeByUnit."Unit Fees" * StudUnitBasket."CF Count"
                                            else
                                                UnitFees := FeeByUnit."Unit Fees" * StudUnitBasket."Charge CF";
                                            ExamsFees := FeeByUnit."Exam Fees";
                                        end;
                                    END; */
                            IF UnitFees = 0 THEN BEGIN
                                StageCharges.RESET; // Check if the fees has exists for Settlement Charges
                                StageCharges.SETRANGE(StageCharges."Per Unit Billing", true);
                                StageCharges.SETRANGE(StageCharges."Audit Unit", StudUnitBasket.audit);
                                if "Programme Category" = "Programme Category"::Undergraduate then
                                    StageCharges.SETRANGE(StageCharges."Campus Code", StudUnitBasket.Campus)
                                else
                                    StageCharges.SETRANGE(StageCharges."Campus Code", Cust."Global Dimension 1 Code");
                                StageCharges.SETRANGE(StageCharges."Settlement Type", "Settlement Type");
                                IF StageCharges.FIND('-') THEN begin
                                    if StudUnitBasket."CF Count" > 0 then
                                        UnitFees := StageCharges.Amount * StudUnitBasket."CF Count"
                                    else
                                        UnitFees := StageCharges.Amount * StudUnitBasket."Charge CF";
                                    // ExamsFees := FeeByUnit."Exam Fees";
                                end;
                            END;

                            /* IF StudUnitBasket.Attachment = TRUE THEN BEGIN
                                IF "Basket Units Attachment" = 1 THEN //Double the tuition if attachment is one unit
                                    UnitFees := UnitFees * 2;
                                ExamsFees := 0;
                            END; */

                            IF StudUnitBasket."Dissertation Unit" = TRUE THEN BEGIN // Thesis Units
                                Prog.GET(Programme);
                                Prog.TESTFIELD(Prog."Thesis Charge Code");
                                Charges.GET(Prog."Thesis Charge Code");
                                UnitFees := Charges.Amount;
                            END;

                            // Tuition
                            StudentChargesTemp.INIT;
                            StudentChargesTemp.Programme := Programme;
                            StudentChargesTemp.Stage := Stage;
                            StudentChargesTemp.Unit := StudUnitBasket.Unit;
                            StudentChargesTemp.Semester := Semester;
                            StudentChargesTemp."Student No." := "Student No.";
                            StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                            StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::"Unit Fees";
                            StudentChargesTemp.Date := "Registration Date";
                            StudentChargesTemp.Code := SettlementType."Tuition G/L Account";
                            StudentChargesTemp.Description := 'Fees for' + ' ' + Programme + '-' + StudUnitBasket."Mode of Study" + '-' + StudUnitBasket.Unit;
                            StudentChargesTemp.Amount := UnitFees;
                            StudentChargesTemp."Tuition Fee" := TRUE;
                            StudentChargesTemp."Transacton ID" := '';
                            StudentChargesTemp."Recovery Priority" := 20;
                            StudentChargesTemp."Bill Settlement Type" := "Settlement Type";
                            StudentChargesTemp.Quantity := StudUnitBasket."CF Count";
                            StudentChargesTemp."Full Tuition Fee" := StageCharges.Amount;
                            StudentChargesTemp."Campus Code" := StudUnitBasket.Campus;
                            StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                            if UnitFees <> 0 then
                                StudentChargesTemp.INSERT;
                            //Exams
                            IF ("Basket Units" = "Basket Units Attachment") OR (StudUnitBasket."Dissertation Unit" = TRUE) THEN BEGIN
                                // Dont charge exams for attachment
                            END ELSE BEGIN
                                StudentChargesTemp.INIT;
                                StudentChargesTemp.Programme := Programme;
                                StudentChargesTemp.Stage := Stage;
                                StudentChargesTemp.Unit := Unit;
                                StudentChargesTemp.Semester := Semester;
                                StudentChargesTemp."Student No." := "Student No.";
                                StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::"Unit Fees";
                                StudentChargesTemp.Date := "Registration Date";
                                StudentChargesTemp.Code := SettlementType."Exams G/L Account";
                                StudentChargesTemp.Description := 'Exams for' + ' ' + Programme + '-' + StudUnitBasket."Mode of Study" + '-' + StudUnitBasket.Unit;
                                StudentChargesTemp.Amount := ExamsFees;
                                StudentChargesTemp."Tuition Fee" := FALSE;
                                StudentChargesTemp."Transacton ID" := '';
                                StudentChargesTemp."Recovery Priority" := 20;
                                StudentChargesTemp."Campus Code" := StudUnitBasket.Campus;
                                StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                if ExamsFees <> 0 then
                                    StudentChargesTemp.INSERT;
                            END;
                        UNTIL StudUnitBasket.NEXT = 0;
                    END;
                    ///Check Hostel Charges//////////////
                    if "Booked Hostel No" <> '' then begin
                        HostelT.Reset();
                        HostelT.SetRange("Asset No", "Booked Hostel No");
                        if HostelT.Find('-') then begin
                            StudentChargesTemp.INIT;
                            StudentChargesTemp.Hostel := true;
                            StudentChargesTemp."Hostel Charge" := true;
                            StudentChargesTemp.Programme := Programme;
                            StudentChargesTemp.Stage := Stage;
                            StudentChargesTemp.Unit := Unit;
                            StudentChargesTemp.Semester := Semester;
                            StudentChargesTemp."Student No." := "Student No.";
                            StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                            StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::Charges;
                            StudentChargesTemp.Date := "Registration Date";
                            StudentChargesTemp.Code := 'HOSTEL CHARGE';
                            StudentChargesTemp.Description := 'Hostel Charges -' + Semester;
                            StudentChargesTemp.Amount := HostelT."Cost Per Occupant";
                            StudentChargesTemp."Tuition Fee" := FALSE;
                            StudentChargesTemp."Transacton ID" := '';
                            StudentChargesTemp."Recovery Priority" := 20;
                            StudentChargesTemp."Campus Code" := StudUnitBasket.Campus;
                            StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                            if HostelT."Cost Per Occupant" > 0 then
                                StudentChargesTemp.INSERT;

                            if HostelT."Meals Inclusive" = true then begin
                                StudentChargesTemp.INIT;
                                StudentChargesTemp.Hostel := true;
                                StudentChargesTemp."Hostel Charge" := true;
                                StudentChargesTemp.Programme := Programme;
                                StudentChargesTemp.Stage := Stage;
                                StudentChargesTemp.Unit := Unit;
                                StudentChargesTemp.Semester := Semester;
                                StudentChargesTemp."Student No." := "Student No.";
                                StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::Charges;
                                StudentChargesTemp.Date := "Registration Date";
                                StudentChargesTemp.Code := 'MEAL CHARGE';
                                StudentChargesTemp.Description := 'Meal Charges -' + Semester;
                                StudentChargesTemp.Amount := HostelT."Catering Charge Amount";
                                StudentChargesTemp."Tuition Fee" := FALSE;
                                StudentChargesTemp."Transacton ID" := '';
                                StudentChargesTemp."Recovery Priority" := 20;
                                StudentChargesTemp."Campus Code" := StudUnitBasket.Campus;
                                StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                if HostelT."Catering Charge Amount" > 0 then
                                    StudentChargesTemp.INSERT;
                            end;
                        end;
                    end;
                    ////////////////////////////////////////////////////////////////

                    //Insert unit standard charges from Programme
                    if Posted = false then begin
                        StageCharges.RESET; // Check if the fees has exists for Settlement Charges
                        StageCharges.SETRANGE(StageCharges."Per Unit Billing", false);
                        StageCharges.SETRANGE(StageCharges."Audit Unit", StudUnitBasket.audit);
                        if "Programme Category" = "Programme Category"::Undergraduate then
                            StageCharges.SETRANGE(StageCharges."Campus Code", StudUnitBasket.Campus)
                        else
                            StageCharges.SETRANGE(StageCharges."Campus Code", Cust."Global Dimension 1 Code");
                        StageCharges.SETRANGE(StageCharges."Settlement Type", "Settlement Type");
                        StageCharges.SETRANGE(StageCharges."First Time Only", false);
                        IF StageCharges.FIND('-') THEN begin
                            REPEAT
                                StudentChargesTemp.reset;
                                StudentChargesTemp.setrange("Student No.", "Student No.");
                                StudentChargesTemp.setrange(Code, StageCharges.code);
                                StudentChargesTemp.setrange(Semester, Semester);
                                if not StudentChargesTemp.find('-') then begin
                                    StudentChargesTemp.INIT;
                                    StudentChargesTemp.Programme := Programme;
                                    StudentChargesTemp.Stage := Stage;
                                    StudentChargesTemp.Unit := Unit;
                                    StudentChargesTemp.Semester := Semester;
                                    StudentChargesTemp."Student No." := "Student No.";
                                    StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                    StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::Charges;
                                    StudentChargesTemp.Date := "Registration Date";
                                    StudentChargesTemp.Code := StageCharges.code;
                                    StudentChargesTemp.Description := StageCharges.Description + ' - ' + Semester;
                                    StudentChargesTemp.Amount := StageCharges.Amount;
                                    StudentChargesTemp."Tuition Fee" := false;
                                    StudentChargesTemp."Transacton ID" := '';
                                    StudentChargesTemp."Recovery Priority" := 20;
                                    StudentChargesTemp."Campus Code" := StudUnitBasket.Campus;
                                    StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                    StudentChargesTemp.INSERT;
                                end;
                            UNTIL StageCharges.NEXT = 0;
                        END;
                        IF (IsFirstTime = true) THEN begin
                            StageCharges.RESET; // First Time
                            StageCharges.SETRANGE(StageCharges."Per Unit Billing", false);
                            StageCharges.SETRANGE(StageCharges."Audit Unit", StudUnitBasket.audit);
                            if "Programme Category" = "Programme Category"::Undergraduate then
                                StageCharges.SETRANGE(StageCharges."Campus Code", StudUnitBasket.Campus)
                            else
                                StageCharges.SETRANGE(StageCharges."Campus Code", Cust."Global Dimension 1 Code");
                            StageCharges.SETRANGE(StageCharges."Settlement Type", "Settlement Type");
                            StageCharges.SETRANGE(StageCharges."First Time Only", true);
                            IF StageCharges.FIND('-') THEN begin
                                REPEAT
                                    StudentChargesTemp.reset;
                                    StudentChargesTemp.setrange("Student No.", "Student No.");
                                    StudentChargesTemp.setrange(Code, StageCharges.code);
                                    StudentChargesTemp.setrange(Semester, Semester);
                                    if not StudentChargesTemp.find('-') then begin
                                        StudentChargesTemp.INIT;
                                        StudentChargesTemp.Programme := Programme;
                                        StudentChargesTemp.Stage := Stage;
                                        StudentChargesTemp.Unit := Unit;
                                        StudentChargesTemp.Semester := Semester;
                                        StudentChargesTemp."Student No." := "Student No.";
                                        StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                        StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::Charges;
                                        StudentChargesTemp.Date := "Registration Date";
                                        StudentChargesTemp.Code := StageCharges.code;
                                        StudentChargesTemp.Description := StageCharges.Description + ' - ' + Semester;
                                        StudentChargesTemp.Amount := StageCharges.Amount;
                                        StudentChargesTemp."Tuition Fee" := false;
                                        StudentChargesTemp."Transacton ID" := '';
                                        StudentChargesTemp."Recovery Priority" := 20;
                                        StudentChargesTemp."Campus Code" := StudUnitBasket.Campus;
                                        StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                        StudentChargesTemp.INSERT;
                                    end;
                                UNTIL StageCharges.NEXT = 0;
                            END;
                        end;
                        /* //Insert Standard Charges from Programme Category
                        FeeByUnitCharges.RESET;
                        FeeByUnitCharges.SETRANGE(FeeByUnitCharges."Programme Category", ProgCat);
                        FeeByUnitCharges.SETRANGE(FeeByUnitCharges."Programme Code", '');
                        IF FeeByUnitCharges.FIND('-') THEN BEGIN
                            REPEAT
                                StudentChargesTemp.INIT;
                                StudentChargesTemp.Programme := Programme;
                                StudentChargesTemp.Stage := Stage;
                                StudentChargesTemp.Unit := Unit;
                                StudentChargesTemp.Semester := Semester;
                                StudentChargesTemp."Student No." := "Student No.";
                                StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::Charges;
                                StudentChargesTemp.Date := "Registration Date";
                                StudentChargesTemp.Code := FeeByUnitCharges.Code;
                                StudentChargesTemp.Description := FeeByUnitCharges.Description + ' - ' + Semester;
                                StudentChargesTemp.Amount := FeeByUnitCharges.Amount;
                                StudentChargesTemp."Tuition Fee" := false;
                                StudentChargesTemp."Transacton ID" := '';
                                StudentChargesTemp."Recovery Priority" := 20;
                                StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                StudentChargesTemp.INSERT;
                            UNTIL FeeByUnitCharges.NEXT = 0;
                        END;

                    END;
                    if "First Time Student" = true then begin // First time Student charges
                        NewStudentCharges.RESET;
                        NewStudentCharges.SETRANGE(NewStudentCharges."Programme Category", ProgCat);
                        IF NewStudentCharges.FIND('-') THEN BEGIN
                            REPEAT

                                StudentChargesTemp.INIT;
                                StudentChargesTemp.Programme := Programme;
                                StudentChargesTemp.Stage := Stage;
                                StudentChargesTemp.Unit := Unit;
                                StudentChargesTemp.Semester := Semester;
                                StudentChargesTemp."Student No." := "Student No.";
                                StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::Charges;
                                StudentChargesTemp.Date := "Registration Date";
                                StudentChargesTemp.Code := FeeByUnitCharges.Code;
                                StudentChargesTemp.Description := NewStudentCharges.Description;
                                StudentChargesTemp.Amount := NewStudentCharges.Amount;
                                StudentChargesTemp."Tuition Fee" := false;
                                StudentChargesTemp."Transacton ID" := '';
                                StudentChargesTemp."Recovery Priority" := 20;
                                StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                if NewStudentCharges.Amount <> 0 then
                                    StudentChargesTemp.INSERT;
                            UNTIL NewStudentCharges.NEXT = 0;
                        END;
                         */
                    end;
                END;
                IF "Register for" = "Register for"::Stage THEN BEGIN

                    TESTFIELD(Programme);
                    //TESTFIELD("Student Type");
                    Cust.TESTFIELD(Cust."Global Dimension 1 Code");
                    Testfield("Settlement Type");
                    SettlementType.GET("Settlement Type");
                    SettlementType.TESTFIELD("Tuition G/L Account");

                    UnitFees := 0;

                    StageCharges.RESET; // Check if the fees has exists for Settlement Charges
                    StageCharges.SETRANGE(StageCharges."Per Unit Billing", false);
                    StageCharges.SETRANGE(StageCharges."Campus Code", Cust."Global Dimension 1 Code");
                    StageCharges.SETRANGE(StageCharges."Settlement Type", "Settlement Type");
                    // IF "First Time Student" = false THEN
                    StageCharges.SETRANGE(StageCharges."First Time Only", false);
                    IF StageCharges.FIND('-') THEN begin
                        repeat
                            StudentChargesTemp.reset;
                            StudentChargesTemp.setrange("Student No.", "Student No.");
                            StudentChargesTemp.setrange(Code, StageCharges.code);
                            StudentChargesTemp.setrange(Semester, Semester);
                            if not StudentChargesTemp.find('-') then begin
                                StudentChargesTemp.INIT;
                                StudentChargesTemp.Programme := Programme;
                                StudentChargesTemp.Stage := Stage;
                                StudentChargesTemp.Unit := Unit;
                                StudentChargesTemp.Semester := Semester;
                                StudentChargesTemp."Student No." := "Student No.";
                                StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::"Unit Fees";
                                StudentChargesTemp.Date := "Registration Date";
                                StudentChargesTemp.Code := StageCharges.Code;
                                StudentChargesTemp.Description := StageCharges.Description + ' ' + StudentUnits.Semester;
                                StudentChargesTemp.Amount := StageCharges.Amount;
                                StudentChargesTemp."Transacton ID" := '';
                                StudentChargesTemp."Recovery Priority" := 20;
                                StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                if StageCharges.Amount > 0 then
                                    StudentChargesTemp.INSERT;
                            end;
                        until StudentCharges.next = 0;

                    end;
                    IF "First Time Student" = true THEN begin
                        UnitFees := 0;

                        StageCharges.RESET; // Fisrt Time Student
                        StageCharges.SETRANGE(StageCharges."Per Unit Billing", false);
                        StageCharges.SETRANGE(StageCharges."Campus Code", Cust."Global Dimension 1 Code");
                        StageCharges.SETRANGE(StageCharges."Settlement Type", "Settlement Type");
                        StageCharges.SETRANGE(StageCharges."First Time Only", true);
                        IF StageCharges.FIND('-') THEN begin
                            repeat
                                StudentChargesTemp.reset;
                                StudentChargesTemp.setrange("Student No.", "Student No.");
                                StudentChargesTemp.setrange(Code, StageCharges.code);
                                StudentChargesTemp.setrange(Semester, Semester);
                                if not StudentChargesTemp.find('-') then begin
                                    StudentChargesTemp.INIT;
                                    StudentChargesTemp.Programme := Programme;
                                    StudentChargesTemp.Stage := Stage;
                                    StudentChargesTemp.Unit := Unit;
                                    StudentChargesTemp.Semester := Semester;
                                    StudentChargesTemp."Student No." := "Student No.";
                                    StudentChargesTemp."Reg. Transacton ID" := "Reg. Transacton ID";
                                    StudentChargesTemp."Transaction Type" := StudentChargesTemp."Transaction Type"::"Unit Fees";
                                    StudentChargesTemp.Date := "Registration Date";
                                    StudentChargesTemp.Code := StageCharges.Code;
                                    StudentChargesTemp.Description := StageCharges.Description + ' ' + StudentUnits.Semester;
                                    StudentChargesTemp.Amount := StageCharges.Amount;
                                    StudentChargesTemp."Transacton ID" := '';
                                    StudentChargesTemp."Recovery Priority" := 20;
                                    StudentChargesTemp.VALIDATE(StudentChargesTemp."Transacton ID");
                                    if StageCharges.Amount > 0 then
                                        StudentChargesTemp.INSERT;
                                end;
                            until StudentCharges.next = 0;

                        END;
                    end;
                END;
                SettlementType.Get("Settlement Type");
                if SettlementType."Billing By" = SettlementType."Billing By"::"Credit Hours" then begin
                    StudentChargesTemp.RESET;
                    StudentChargesTemp.SETRANGE(StudentChargesTemp."Student No.", "Student No.");
                    IF not StudentChargesTemp.FIND('-') THEN error('Fees structure not found ' + "Student No.");
                end;
            end;
        }
        field(51800; "Total Billed Profoma"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Student Charges Buffer".Amount WHERE(Semester = FIELD(Semester), "Student No." = FIELD("Student No.")));
        }
        field(51801; "Installment Billed"; Boolean) { }
        field(51802; "Payment Plan Required"; Boolean) { }
        field(51803; "Printed Admission Letter"; Boolean)
        {
            Editable = false;
        }
        field(51806; "Concentration Type"; code[20])
        {
            // TableRelation = "Programme Concentration Type";
        }
        field(51804; "Programme Concentration"; code[20])
        {
            //   TableRelation = if ("Concentration Type" = filter('MINOR')) "Programme Majors Conc"."Concentration Code" where("Programme Code" = field(Programme))
            //else
            // "Programme Majors Conc"."Concentration Code" where("Main Programme" = field("Main Programme"));
            // TableRelation = "Programme Majors Conc"."Concentration Code" where("Programme Code" = field(Programme));
        }

        field(51886; "Meals Booked"; Boolean) { }
        field(51887; "Hostel Booked"; Boolean) { }
        field(51888; "Booked Hostel No"; code[20])
        {
            TableRelation = "Hostel Card"."Asset No";
        }
        field(51889; "Semester Booked CF"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("Student No."), Semester = field(Semester)));
        }
        field(51890; Email; Text[150])
        {
            CalcFormula = lookup(Customer."E-Mail" where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(51891; "New Stage"; code[20]) { }
        field(51892; "Deferral Remarks"; text[200]) { }
    }
    keys
    {
        key(Key1; "Reg. Transacton ID", "Student No.", Programme, Semester, "Register for", Stage, "Student Type", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Student Type") { }
        key(Key3; "Student No.") { }
        key(Key4; "General Remark") { }
        key(Key5; "Registration Date", Programme, Stage) { }
        key(Key6; Stage) { }
        key(Key7; "Student No.", Programme, Semester, "Register for", Stage, Unit, "Student Type") { }
        key(Key8; Stage, "Student No.") { }
        key(Key9; "Reg. Transacton ID", "Student No.", Programme, Semester, "Register for", Unit, "Student Type") { }
        key(Key10; Programme, "Student No.", "Entry No.") { }
        key(Key11; "Reg. Transacton ID", "Student No.", Programme, Semester, "Register for", Stage, Unit, "Student Type") { }
        key(Key12; "Cumm Score") { }
        key(Key13; "Settlement Type", "Student No.") { }
        key(Key14; "Exam Grade") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

        //IF "Attending Classes" = TRUE THEN
        //ERROR('Transaction once posted cannot be delete.');

        //IF Posted = TRUE THEN
        //ERROR('Transaction once posted cannot be delete.');

        CalcFields("Units Taken");
        if "Units Taken" > 0 then
            Error('Transaction with Registered units cannot be deleted.');
        /*
        
        GenSetup.GET;
        IF ("Registration Date" > GenSetup."Allow Posting To") OR ("Registration Date" < GenSetup."Allow Posting From") THEN
        ERROR('Modification or deletion out of the allowed range not allowed.');
         */

        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
        StudentCharges.SetRange(StudentCharges."Reg. Transacton ID", "Reg. Transacton ID");
        StudentCharges.SetRange(Recognized, false);
        if StudentCharges.Find('-') then
            StudentCharges.DeleteAll;



    end;

    trigger OnInsert()
    begin

        if "Reg. Transacton ID" = '' then begin
            GenSetup.Get;
            GenSetup.TestField(GenSetup."Registration Nos.");
            "Reg. Transacton ID" := NoSeriesMgt.GetNextNo(GenSetup."Registration Nos.", 0D, true);


            //BKK Insert Academic year
            /* AcademicYear.RESET;
             AcademicYear.SETRANGE(AcademicYear.Current,TRUE);
             IF AcademicYear.FIND('-') THEN
             "Academic Year":=AcademicYear.Code
             ELSE ERROR('Please specify the current academic year in the academic year setup!');

             IntakeRec.RESET;
             IntakeRec.SETRANGE(IntakeRec.Current,TRUE);
             IF IntakeRec.FIND('-') THEN
             Session:=IntakeRec.Code;  */

        end;

    end;

    trigger OnModify()
    begin
        /*
        IF Posted = TRUE THEN
        ERROR('Transaction once posted cannot be modified.');
        
        IF Programme<>xRec.Programme THEN BEGIN
        
        IF "Attending Classes" = TRUE THEN
        ERROR('Transaction once posted cannot be modified.');
        
        IF Posted = TRUE THEN
        ERROR('Transaction once posted cannot be modified.');
        {
        GenSetup.GET;
        IF ("Registration Date" > GenSetup."Allow Posting To") OR ("Registration Date" < GenSetup."Allow Posting From") THEN
        ERROR('Modification or deletion out of the allowed range not allowed.');
        }
        
        IF "Allow Adjustment" = FALSE THEN BEGIN
        IF Posted = TRUE THEN
        ERROR('You can not modify an already posted registration.');
        END ELSE BEGIN
        "Allow Adjustment":=FALSE;
        //MODIFY;
        END;
        
        END;
        */

    end;

    var
        UserSetup: Record "User Setup";
        coReg2: Record "Course Registration";
        coReg1: Record "Course Registration";
        acadYears: Record "Academic Year";
        FeeByStage: Record "Fee By Stage";
        FeeByUnit: Record "Fee By Unit";
        StudUnitBasket: Record "Student Unit Basket";
        StudentChargesTemp: Record "Student Charges Buffer";
        UnitFees: Decimal;
        ExamsFees: Decimal;
        NoSeriesMgt: Codeunit "No. Series";
        GenSetup: Record "General Set-Up";
        StudentCharges: Record "Student Charges";
        TotalCost: Decimal;
        StageCharges: Record "Stage Charges";
        NewStudentCharges: Record "New Student Charges";
        CoursePrerequisite: Record "Course Prerequisite";
        SPrereq: Record "Student Prerequisite Approval";
        Stages: Record "Programme Stages";
        ProgCategory: Record "Programme Categories";
        StudentUnits: Record "Student Units";
        StageUnits: Record "Units/Subjects";
        // EStageUnits: Record "External Units/Subjects";
        GenJnl: Record "Gen. Journal Line";
        Units: Record "Units/Subjects";
        Charges: Record Charge;
        Sems: Record Semesters;
        DueDate: Date;
        Cust: Record Customer;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        SettlementType: Record "Settlement Type";
        CReg: Record "Course Registration";
        CustPostGroup: Record "Customer Posting Group";
        Programmes: Record Programme;
        CourseReg: Record "Course Registration";
        Found: Boolean;
        LibCode: Text[30];
        //  LibRefCodes: Record "Students Receipts Batch";
        Custs: Record Customer;
        TotalUnits: Integer;
        OldStud: Boolean;
        CReg2: Record "Course Registration";
        PStage: Record "Programme Stages";
        SFee: Record "Fee By Stage";
        Prog: Record Programme;
        IntakeRec: Record Intake;
        StudExemp: Record "Student Units Exemptions";
        ExempLine: Record "Units Exemption Lines";
        FeeByUnitCharges: Record "Fee By Unit Charges";
        ExitCharge: Boolean;

    procedure Check_Units_Exist(StudentNo: Code[20]; StudProg: Code[20]; Stag: Code[20]; Unt: Code[20]) Exists: Boolean
    var
        StudUnits: Record "Student Units";
    begin
        Exists := false;
        StudUnits.Reset;
        StudUnits.SetRange(StudUnits.Programme, StudProg);
        StudUnits.SetRange(StudUnits.Stage, Stag);
        StudUnits.SetRange(StudUnits.Unit, Unt);
        StudUnits.SetRange(StudUnits."Student No.", StudentNo);
        if StudUnits.Find('-') then
            Exists := true;
    end;
}

