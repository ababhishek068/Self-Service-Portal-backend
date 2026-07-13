Report 50091 "Examination Cards2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ExaminationCards2.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Course Registration"; "Course Registration")
        {
            RequestFilterFields = "Student No.", Programme, Semester, Stage, "Register for", "Registration Type Filter";
            column(ReportForNavId_2901; 2901) { }
            column(col1StudNo; col1StudNo) { }
            column(col2StudNo; col2StudNo) { }
            column(col1Faculty; col1Faculty) { }
            column(col1Programme; col1Programme) { }
            column(RegTransactonID_CourseRegistration; "Course Registration"."Reg. Transacton ID") { }
            column(col2Faculty; col2Faculty) { }
            column(col2Programme; col2Programme) { }
            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }
            column(col1Names; col1Names) { }
            column(col2Names; col2Names) { }
            column(col1Bal; col1Bal) { }
            column(col2Bal; col2Bal) { }
            column(i; i) { }
            column(j; j) { }
            column(i_Control1102760013; i) { }
            column(j_Control1102760014; j) { }
            column(studStageSem; studStageSem) { }
            column(studStageSem2; studStageSem2) { }
            column(u1_1_; u1[1]) { }
            column(u1_2_; u1[2]) { }
            column(u1_3_; u1[3]) { }
            column(u1_4_; u1[4]) { }
            column(u1_5_; u1[5]) { }
            column(u1_6_; u1[6]) { }
            column(u1_7_; u1[7]) { }
            column(u1_8_; u1[8]) { }
            column(u1_9_; u1[9]) { }
            column(u1_10_; u1[10]) { }
            column(u1_11_; u1[11]) { }
            column(u1_12_; u1[12]) { }
            column(u1_13_; u1[13]) { }
            column(u1_14_; u1[14]) { }
            column(u1_15_; u1[15]) { }
            column(u2_1_; u2[1]) { }
            column(u2_2_; u2[2]) { }
            column(u2_3_; u2[3]) { }
            column(u2_4_; u2[4]) { }
            column(u2_5_; u2[5]) { }
            column(u2_6_; u2[6]) { }
            column(u2_7_; u2[7]) { }
            column(u2_8_; u2[8]) { }
            column(u2_9_; u2[9]) { }
            column(u2_10_; u2[10]) { }
            column(u2_11_; u2[11]) { }
            column(u2_12_; u2[12]) { }
            column(u2_13_; u2[13]) { }
            column(u2_14_; u2[14]) { }
            column(u2_15_; u2[15]) { }
            column(Units_RegisteredCaption; Units_RegisteredCaptionLbl) { }
            column(Units_RegisteredCaption_Control1102755023; Units_RegisteredCaption_Control1102755023Lbl) { }
            column(Course_Registration_Reg__Transacton_ID; "Reg. Transacton ID") { }
            column(Course_Registration_Student_No_; "Student No.") { }
            column(Course_Registration_Programme; Programme) { }
            column(Course_Registration_Semester; Semester) { }
            column(Course_Registration_Register_for; "Register for") { }
            column(Course_Registration_Type; StudUnits."Registration Type")
            {
                OptionCaption = '<Registration Type>';
                OptionMembers = "<Registration Type>";
            }
            column(Course_Registration_Stage; Stage) { }
            column(Course_Registration_Unit; Unit) { }
            column(Course_Registration_Student_Type; "Student Type") { }
            column(Course_Registration_Entry_No_; "Entry No.") { }
            column(Supervisor_Signature; SUPsIGNATURE) { }
            column(Comp_Name; compName) { }
            column(coursecode_title; coursecode) { }
            column(CourseNameCaption; CourseDesc) { }
            column(U1Code_1; U1Code[1]) { }
            column(creditHrs_1; creditHrs) { }
            column(U1Desc_1; U1Desc[1]) { }
            column(U2Code_1; U2Code[1]) { }
            column(U2Desc_1; U2Desc[1]) { }
            column(U1Units_1; U1Units[1]) { }
            column(U2Units_1; U2Units[1]) { }
            column(instrtitle; instrtitle) { }
            column(rule1; rule1) { }
            column(rule2; rule2) { }
            column(rule3; rule3) { }
            column(rule4; rule4) { }
            column(rule5; rule5) { }
            column(rule6; rule6) { }
            column(desclaimer; desclaimer) { }
            column(desclaimersigns; desclaimersigns) { }
            column(U1Code_2; U1Code[2]) { }
            column(U1Desc_2; U1Desc[2]) { }
            column(U2Code_2; U2Code[2]) { }
            column(U2Desc_2; U2Desc[2]) { }
            column(U1Units_2; U1Units[2]) { }
            column(U2Units_2; U2Units[2]) { }
            column(U1Code_3; U1Code[3]) { }
            column(U1Desc_3; U1Desc[3]) { }
            column(U2Code_3; U2Code[3]) { }
            column(U2Desc_3; U2Desc[3]) { }
            column(U1Units_3; U1Units[3]) { }
            column(U2Units_3; U2Units[3]) { }
            column(U1Code_4; U1Code[4]) { }
            column(U1Desc_4; U1Desc[4]) { }
            column(U2Code_4; U2Code[4]) { }
            column(U2Desc_4; U2Desc[4]) { }
            column(U1Units_4; U1Units[4]) { }
            column(U2Units_4; U2Units[4]) { }
            column(U1Code_5; U1Code[5]) { }
            column(U1Desc_5; U1Desc[5]) { }
            column(U2Code_5; U2Code[5]) { }
            column(U2Desc_5; U2Desc[5]) { }
            column(U1Units_5; U1Units[5]) { }
            column(U2Units_5; U2Units[5]) { }
            column(U1Code_6; U1Code[6]) { }
            column(U1Desc_6; U1Desc[6]) { }
            column(U2Code_6; U2Code[6]) { }
            column(U2Desc_6; U2Desc[6]) { }
            column(U1Units_6; U1Units[6]) { }
            column(U2Units_6; U2Units[6]) { }
            column(U1Code_7; U1Code[7]) { }
            column(U1Desc_7; U1Desc[7]) { }
            column(U2Code_7; U2Code[7]) { }
            column(U2Desc_7; U2Desc[7]) { }
            column(U1Units_7; U1Units[7]) { }
            column(U2Units_7; U2Units[7]) { }
            column(U1Code_8; U1Code[8]) { }
            column(U1Desc_8; U1Desc[8]) { }
            column(U2Code_8; U2Code[8]) { }
            column(U2Desc_8; U2Desc[8]) { }
            column(U1Units_8; U1Units[8]) { }
            column(U2Units_8; U2Units[8]) { }
            column(U1Code_9; U1Code[9]) { }
            column(U1Desc_9; U1Desc[9]) { }
            column(U2Code_9; U2Code[9]) { }
            column(U2Desc_9; U2Desc[9]) { }
            column(U1Units_9; U1Units[9]) { }
            column(U2Units_9; U2Units[9]) { }
            column(U1Code_10; U1Code[10]) { }
            column(U1Desc_10; U1Desc[10]) { }
            column(U2Code_10; U2Code[10]) { }
            column(U2Desc_10; U2Desc[10]) { }
            column(U1Units_10; U1Units[10]) { }
            column(U2Units_10; U2Units[10]) { }
            column(ExamPeriod; ExamPeriod) { }
            column(U1Code_11; U1Code[11]) { }
            column(U1Desc_11; U1Desc[11]) { }
            column(U1Code_12; U1Code[12]) { }
            column(U1Desc_12; U1Desc[12]) { }
            column(U1Code_13; U1Code[13]) { }
            column(U1Desc_13; U1Desc[13]) { }
            column(U1Code_14; U1Code[14]) { }
            column(U1Desc_14; U1Desc[14]) { }
            column(U1Code_15; U1Code[15]) { }
            column(U1Desc_15; U1Desc[15]) { }

            trigger OnAfterGetRecord()
            begin
                if SemRec.Get(Semester) then
                    if SemRec."Registration Closed" = false then SemRec.TestField(SemRec."Registration Closed", false);

                "Course Registration".CalcFields(Balance);
                if "Course Registration"."Allow Exam Attendance" = false then
                    if "Course Registration".Balance > 1 then //CurrReport.SKIP;
                        Error('Please note that you have an outstanding fee balance of ' + Format("Course Registration".Balance));

                j := j + 1;

                if recCustomer.Get("Course Registration"."Student No.") then begin
                    txtNames := UpperCase(recCustomer.Name);
                    recCustomer.CalcFields(recCustomer."Balance (LCY)");
                    bal := recCustomer."Balance (LCY)";
                    bal := 0;
                end;

                if (bal > 0) then begin
                    //CurrReport.SKIP;
                end;

                if (bal > 0) and (j < studCount) then begin
                    // CurrReport.SKIP;
                end
                else begin

                    i := i + 1;

                    col2StudNo := '';
                    col2Programme := '';
                    col2Faculty := '';
                    col2Names := '';
                    col2Bal := 0;
                    studStageSem2 := '';

                    recProgramme.SetRange(recProgramme.Code, "Course Registration".Programme);
                    if recProgramme.Find('-') then begin
                        txtProgramme := recProgramme.Description;
                        FacultyCode := recProgramme."School Code";
                    end;

                    recFaculty.SetRange(recFaculty.Code, FacultyCode);
                    if recFaculty.Find('-') then
                        txtFaculty := recFaculty.Name;

                    if i MOD 2 = 1 then begin
                        if j = studCount then begin
                            col1StudNo := "Course Registration"."Student No.";
                            col1Programme := txtProgramme;
                            col1Faculty := txtFaculty;
                            col1Names := txtNames;
                            col1Bal := bal;
                            studStageSem := 'Stage: ' + "Course Registration".Stage + '  Semester: ' + "Course Registration".Semester;
                            //studStageSem:='Semester: '+"Course Registration".Semester;
                            for k := 1 to 10 do begin
                                u1[k] := '';
                                Clear(U1Code);
                                Clear(U1Desc);
                                Clear(U1Units);

                            end;

                            k := 1;
                            StudUnits.Reset;
                            //StudUnits.SetRange(StudUnits.Programme, "Course Registration".Programme);
                            //StudUnits.SETRANGE(StudUnits.Stage,"Course Registration".Stage);
                            StudUnits.SetRange(StudUnits.Semester, "Course Registration".Semester);
                            StudUnits.SetRange(StudUnits."Student No.", col1StudNo);
                            StudUnits.SetFilter(StudUnits."Registration Type", "Course Registration".GetFilter("Registration Type Filter"));
                            if StudUnits.Find('-') then begin
                                repeat
                                    subjz.Reset;

                                    //subjz.SETRANGE(subjz."Stage Code",StudUnits.Stage);

                                    if k < 16 then begin
                                        if subjz.get(StudUnits.Unit) then begin
                                            U1Code[k] := subjz.Code;
                                            U1Desc[k] := subjz.Description;
                                            U1Units[k] := subjz.Units;
                                        end;
                                        StudUnits.CalcFields(StudUnits."Unit Description");
                                        u1[k] := Format(k) + ' - ' + StudUnits.Unit + ' - ' + Format(StudUnits."Unit Description");
                                        k := k + 1;
                                    end;
                                until StudUnits.Next = 0;
                            end;

                        end
                        else begin
                            col1StudNo := "Course Registration"."Student No.";
                            col1Programme := txtProgramme;
                            col1Faculty := txtFaculty;
                            col1Names := txtNames;
                            col1Bal := bal;
                            studStageSem := 'Stage: ' + "Course Registration".Stage + '  Semester: ' + "Course Registration".Semester;
                            //studStageSem:='Semester: '+"Course Registration".Semester;
                            for k := 1 to 10 do begin
                                u1[k] := '';
                                Clear(U1Code);
                                Clear(U1Desc);
                                Clear(U1Units);

                            end;

                            k := 1;
                            StudUnits.Reset;
                            // StudUnits.SetRange(StudUnits.Programme, "Course Registration".Programme);
                            //StudUnits.SETRANGE(StudUnits.Stage,"Course Registration".Stage);
                            StudUnits.SetRange(StudUnits.Semester, "Course Registration".Semester);
                            StudUnits.SetFilter(StudUnits."Registration Type", "Course Registration".GetFilter("Registration Type Filter"));
                            StudUnits.SetRange(StudUnits."Student No.", col1StudNo);
                            if StudUnits.Find('-') then begin
                                repeat
                                    subjz.Reset;
                                    // subjz.SetRange(subjz."Programme Code", StudUnits.Programme);
                                    //subjz.SETRANGE(subjz."Stage Code",StudUnits.Stage);
                                    //subjz.SetRange(subjz.Code, StudUnits.Unit);
                                    if k < 16 then begin
                                        if subjz.get(StudUnits.Unit) then begin
                                            U1Code[k] := subjz.Code;
                                            U1Desc[k] := subjz.Description;
                                            U1Units[k] := subjz.Units;
                                        end;

                                        StudUnits.CalcFields(StudUnits."Unit Description");
                                        u1[k] := Format(k) + ' - ' + StudUnits.Unit + ' - ' + Format(StudUnits."Unit Description");
                                        k := k + 1;
                                    end;
                                until StudUnits.Next = 0;
                            end;

                            CurrReport.Skip;
                        end;
                    end
                    else begin
                        if bal <= 0 then begin

                            col2StudNo := "Course Registration"."Student No.";
                            col2Programme := txtProgramme;
                            col2Faculty := txtFaculty;
                            col2Names := txtNames;
                            col2Bal := bal;
                            studStageSem2 := 'Stage: ' + "Course Registration".Stage + '  Semester: ' + "Course Registration".Semester;
                            for k := 1 to 10 do begin
                                u2[k] := '';
                                Clear(U2Code);
                                Clear(U2Desc);
                                Clear(U2Units);
                            end;

                            k := 1;
                            StudUnits.Reset;
                            //StudUnits.SetRange(StudUnits.Programme, "Course Registration".Programme);
                            //StudUnits.SetRange(StudUnits.Stage, "Course Registration".Stage);
                            StudUnits.SETRANGE(StudUnits.Semester, "Course Registration".Semester);
                            StudUnits.SetFilter(StudUnits."Registration Type", "Course Registration".GetFilter("Registration Type Filter"));
                            StudUnits.SetRange(StudUnits."Student No.", col2StudNo);
                            if StudUnits.Find('-') then begin
                                repeat
                                    subjz.Reset;
                                    // subjz.SetRange(subjz."Programme Code", StudUnits.Programme);
                                    //subjz.SETRANGE(subjz."Stage Code",StudUnits.Stage);
                                    // subjz.SetRange(subjz.Code, StudUnits.Unit);
                                    if k < 16 then begin
                                        if subjz.get(StudUnits.Unit) then begin
                                            U1Code[k] := subjz.Code;
                                            U1Desc[k] := subjz.Description;
                                            U1Units[k] := subjz.Units;
                                        end;

                                        StudUnits.CalcFields(StudUnits."Unit Description");
                                        u2[k] := Format(k) + ' - ' + StudUnits.Unit + ' - ' + Format(StudUnits."Unit Description");
                                        k := k + 1;
                                    end;
                                until StudUnits.Next = 0;
                            end;

                        end;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);

                studCount := "Course Registration".Count;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content) { }
        }

        actions { }
    }

    labels { }

    var
        col1StudNo: Code[20];
        col1Programme: Text[100];
        col1Faculty: Text[100];
        col1Names: Text[50];
        col1Bal: Decimal;
        col2StudNo: Code[20];
        col2Programme: Text[100];
        col2Faculty: Text[100];
        col2Names: Text[50];
        col2Bal: Decimal;
        i: Integer;
        j: Integer;
        studCount: Integer;
        recProgramme: Record Programme;
        txtProgramme: Text[100];
        recFaculty: Record "Dimension Value";
        txtFaculty: Text[100];
        FacultyCode: Code[20];
        txtNames: Text[50];
        recCustomer: Record Customer;
        bal: Decimal;
        studStageSem: Code[50];
        studStageSem2: Code[50];
        u1: array[20] of Text[100];
        StudUnits: Record "Student Units";
        k: Integer;
        u2: array[20] of Text[100];
        Units_RegisteredCaptionLbl: label 'Units Registered';
        Units_RegisteredCaption_Control1102755023Lbl: label 'Units Registered';
        SUPsIGNATURE: label 'Signature of the Invigilator on Collection of the Scripts';
        compName: label 'KABARAK UNIVERSITY';
        coursecode: label 'COURSE CODE';
        CourseDesc: label 'COURSE TITLE';
        creditHrs: label 'UNITS';
        U1Code: array[20] of Code[20];
        U1Desc: array[20] of Text[100];
        U2Code: array[20] of Code[20];
        U2Desc: array[20] of Text[100];
        U1Units: array[20] of Decimal;
        U2Units: array[20] of Decimal;
        instrtitle: label 'IMPORTANT';
        rule1: label 'This card is NOT Transferable nor is it Replaceable';
        rule2: label 'it MUST be presented together with the student identity card to the invigilator when required';
        rule3: label 'The invigilator MUST sign on the card as he/she collects the scripts';
        rule4: label 'The names which appear on the card are the same names which will appear on the certificate';
        rule5: label 'The candidate must ensure that the order of the names are consistently written at all times i.e. surname, first Name and middle Name';
        rule6: label 'Any error on the names must be corrected at the office of the Dean of the School in which the Candidate is registered.';
        desclaimer: label 'This is to confirm that the information above is correct';
        desclaimersigns: label 'Dean of the School ..................................... Stamp... ................';
        subjz: Record "Courses Master";
        CompInf: Record "Company Information";
        ExamPeriod: Code[20];
        SemRec: Record Semesters;
}

