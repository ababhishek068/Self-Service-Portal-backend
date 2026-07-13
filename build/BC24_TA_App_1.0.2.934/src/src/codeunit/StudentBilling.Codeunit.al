Codeunit 50038 "Student Billing"
{

    trigger OnRun()
    begin
    end;

    procedure BillStudent(StudentNo: Code[20])
    var
        Charges: Record Charge;
        GenSetUp: Record "General Set-Up";
        CReg: Record "Course Registration";
        Cust: Record Customer;
        DueDate: Date;
        Sems: Record Semesters;
        Prog: Record Programme;
        "SettlementTypeRec": Record "Settlement Type";
        AccPayment: Boolean;
        SettlementType: Code[20];
        StudentCharges: Record "Student Charges";
        GenJnl: Record "Gen. Journal Line";
        UnitsMaster: Record "Courses Master";
    begin
        //BILLING
        Cust.Get(StudentNo);
        AccPayment := false;
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", StudentNo);
        StudentCharges.SetRange(StudentCharges.Recognized, false);
        StudentCharges.SetFilter(StudentCharges.Code, '<>%1', '');
        if StudentCharges.Find('-') then begin
            //IF NOT CONFIRM('Un-billed charges will be posted. Do you wish to continue?',FALSE) = TRUE THEN
            // ERROR('You have selected to Abort Student Billing');


            SettlementType := '';
            CReg.Reset;
            CReg.SetFilter(CReg."Settlement Type", '<>%1', '');
            CReg.SetRange(CReg."Student No.", StudentNo);
            CReg.SetRange(Reversed, false);
            if CReg.Find('+') then
                SettlementType := CReg."Settlement Type";
            //ELSE
            //ERROR('The Settlement Type Does not Exists in the Course Registration');

            "SettlementTypeRec".Get(SettlementType);
            "SettlementTypeRec".TestField("SettlementTypeRec"."Tuition G/L Account");

            // MANUAL APPLICATION OF ACCOMODATION FOR PREPAYED STUDENTS BY BKK...//
            if StudentCharges.Count = 1 then begin
                Cust.CalcFields(Balance);
                if Cust.Balance < 0 then begin
                    if Abs(Cust.Balance) > StudentCharges.Amount then begin
                        Cust."Application Method" := Cust."application method"::Manual;
                        //Cust.AccPayment:=TRUE;
                        Cust.Modify;
                    end;
                end;
            end;

        end;


        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", 'SALES');
        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();
        //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");

        //Charge Student if not charged
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", StudentNo);
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
                // GenJnl."Posting Date" := StudentCharges.Date;
                GenJnl."Posting Date" := today;
                GenJnl."Document No." := StudentCharges."Transacton ID";
                GenJnl.Validate(GenJnl."Document No.");
                GenJnl."Journal Template Name" := 'SALES';
                GenJnl."Journal Batch Name" := 'STUD PAY';
                GenJnl."Account Type" := GenJnl."account type"::Customer;
                //

                if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Account No." := Cust."Bill-to Customer No."
                else
                    GenJnl."Account No." := StudentNo;


                GenJnl.Amount := StudentCharges.Amount;
                GenJnl.Validate(GenJnl."Account No.");
                GenJnl.Validate(GenJnl.Amount);
                GenJnl.Description := StudentCharges.Description + ' ' + StudentCharges.Semester;
                //  GenJnl.Description := StudentCharges.Description;
                GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";

                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                   (StudentCharges.Charge = false) then begin
                    GenJnl."Bal. Account No." := "SettlementTypeRec"."Tuition G/L Account";

                end else
                    if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                       (StudentCharges.Charge = false) then begin
                        //GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";
                        StudentCharges.CalcFields(StudentCharges."Settlement Type");
                        GenJnl."Bal. Account No." := "SettlementTypeRec"."Tuition G/L Account";


                    end else
                        if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Exam Fees" then begin


                        end else
                            if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or
                               (StudentCharges.Charge = true) then begin
                                if Charges.Get(StudentCharges.Code) then
                                    GenJnl."Bal. Account No." := Charges."G/L Account";
                            end;


                GenJnl.Validate(GenJnl."Bal. Account No.");
                GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";

                UnitsMaster.reset;
                UnitsMaster.setrange(UnitsMaster.Code, StudentCharges.Unit);
                UnitsMaster.SetFilter(UnitsMaster."Department Code", '<>%1', '');
                if UnitsMaster.find('-') then begin
                    GenJnl."Shortcut Dimension 2 Code" := UnitsMaster."Department Code";
                end else begin
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.", StudentNo);
                    CReg.SetRange(CReg.Reversed, false);
                    if creg.find('-') then begin
                        if Prog.Get(creg.Programme) then begin
                            Prog.TestField(Prog."Department Code");
                            GenJnl."Shortcut Dimension 2 Code" := Prog."Department Code";
                        end;
                    end;
                end;
                UnitsMaster.reset;
                UnitsMaster.setrange(UnitsMaster.Code, StudentCharges.Unit);
                UnitsMaster.SetFilter(UnitsMaster."School Code", '<>%1', '');
                if UnitsMaster.find('-') then begin
                    GenJnl.ValidateShortcutDimCode(3, UnitsMaster."School Code");
                end else begin
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.", StudentNo);
                    CReg.SetRange(CReg.Reversed, false);
                    if creg.find('-') then begin
                        if Prog.Get(creg.Programme) then begin
                            //  Prog.TestField(Prog."School Code");
                            //  GenJnl.ValidateShortcutDimCode(3, Prog."School Code");
                            // if GeneralSetup."Shortcut Dimension 4 Code" = 'PROGRAMME' then
                            //  if Charges.Get(StudentCharges.Code) then
                            //     GenJnl.ValidateShortcutDimCode(4, Charges."Default Dimension");
                            // if GeneralSetup."Shortcut Dimension 5 Code" = 'PROGRAMME' then
                            //     GenJnl.ValidateShortcutDimCode(5, creg.Programme);

                        end;
                    end;
                end;


                GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                GenJnl."Due Date" := DueDate;
                GenJnl.Validate(GenJnl."Due Date");

                if GenJnl.Amount <> 0 then
                    GenJnl.Insert;



                StudentCharges.Recognized := true;
                StudentCharges.Modify;
                //.......BY BKK
                StudentCharges.Posted := true;
                StudentCharges.Modify;

                CReg.Reset;
                CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                CReg.SetRange(CReg."Student No.", StudentCharges."Student No.");
                if CReg.Find('-') then begin
                    if CReg."Settlement Type" <> '' then begin
                        CReg.Posted := true;
                        CReg.Modify;
                    end;
                end;

            //.....END BKK

            until StudentCharges.Next = 0;



            //Post New
            GenJnl.Reset;
            GenJnl.SetRange("Journal Template Name", 'SALES');
            GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
            if GenJnl.Find('-') then begin
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnl);
            end;

            //Post New


            Cust."Application Method" := Cust."application method"::"Apply to Oldest";
            Cust.Status := Cust.Status::Current;
            // if Cust."Audit Units Posted" = false then GenerateStudentAuditUnits(Cust."No.");
            // Cust."Audit Units Posted" := true;
            Cust.Modify;
            GenSetUp.get;
            if GenSetUp."Notify Student on Invoice" = true then
                EmailStudentInvoice(cust."No.");
        end;


        //BILLING
    end;

    procedure GenerateStudentAuditUnits(StudNo: code[20])
    var
        StageUnits: record "Units/Subjects";
        StudentUnits: record "Student Units Audit";
        Cust: record customer;
        GenSetup: Record "General Set-Up";
        // AdmRemedial: Record "Admission Remedials";
        StudUnits: Record "Student Units";
        // StudCon: Record "Student Concentration";
        UnitsSubj: Record "Units/Subjects";
        UnitsCategory: Record "Unit Category";
    begin
        GenSetup.get;
        StudentUnits.reset;
        StudentUnits.setrange("Student No.", StudNo);
        StudentUnits.setrange(Substituted, false);
        StudentUnits.setrange("Waived Credits", 0);
        if StudentUnits.find('-') then
            StudentUnits.DeleteAll();

        Cust.get(StudNo);
        cust.TestField("Current Programme");

        StudUnits.reset;
        StudUnits.setrange("Student No.", StudNo);
        // StudUnits.setrange(Failed, false);
        // StudUnits.SetFilter(Grade, '<>%1', '');
        if StudUnits.find('-') then begin
            repeat
                StudentUnits.reset;
                StudentUnits.setrange("Student No.", StudNo);
                StudentUnits.setrange(Unit, StudUnits.Unit);
                if not StudentUnits.find('-') then begin
                    Studunits.CalcFields("Grade Exists");
                    StudUnits.CalcFields("InCurrent Sem");
                    StudentUnits.Init;
                    StudentUnits."Student No." := StudNo;
                    StudentUnits.Programme := Studunits.Programme;
                    StudentUnits.Unit := Studunits.Unit;
                    StudentUnits."Unit Type" := StudUnits."Unit Type";
                    StudentUnits."No. Of Units" := StudUnits."No. Of Units";
                    StudUnits.calcfields("Grade Exists");
                    if StudUnits."Grade Exists" = true then
                        StudentUnits."Earned Credits" := StudUnits."No. Of Units";

                    StudentUnits.Description := StudUnits.Description;
                    StudentUnits."Progress Status" := StudentUnits."Progress Status"::Completed;
                    if (StudUnits.Grade = '') and (StudUnits."InCurrent Sem" = false) then
                        StudentUnits."Progress Status" := StudentUnits."Progress Status"::Future;
                    if (StudUnits.Grade = '') and (StudUnits."InCurrent Sem" = true) then
                        StudentUnits."Progress Status" := StudentUnits."Progress Status"::Registered;
                    if (Studunits."Grade Exists" = false) and (Studunits.Grade <> '') then
                        StudentUnits."Progress Status" := StudentUnits."Progress Status"::Unfulfilled;
                    StudentUnits."Date created" := today;
                    StudentUnits.Grade := StudUnits.Grade;
                    StudentUnits."Final Score" := StudUnits."Final Score";
                    StudentUnits.Failed := StudUnits.Failed;
                    StudentUnits.type := StudentUnits.type::MAJOR;
                    UnitsSubj.reset;
                    UnitsSubj.setrange("Programme Code", Cust."Current Programme");
                    UnitsSubj.setrange(Code, Studunits.Unit);
                    if UnitsSubj.find('-') then begin
                        StudentUnits."Unit Type" := UnitsSubj."Unit Type";
                        StudentUnits."Unit Category Code" := UnitsSubj."Unit Category";
                        if UnitsCategory.get(UnitsSubj."Unit Category") then
                            StudentUnits."Unit Category Name" := UnitsCategory.Description;
                    end;
                    StudentUnits.INSERT;
                end;
            until StudUnits.Next = 0
        end;



        StageUnits.Reset; // Insert for main programme
        StageUnits.SetRange(StageUnits."Programme Code", Cust."Current Programme");
        StageUnits.SetRange(StageUnits."Old Unit", false);
        if StageUnits.Find('-') then begin
            repeat
                StudentUnits.reset;
                StudentUnits.setrange("Student No.", StudNo);
                StudentUnits.setrange(Unit, StageUnits.Code);
                if not StudentUnits.find('-') then begin
                    StudentUnits.Init;
                    StudentUnits."Student No." := StudNo;
                    StudentUnits.Programme := Cust."Current Programme";
                    StudentUnits.Unit := StageUnits.Code;
                    StudentUnits."Unit Type" := StageUnits."Unit Type";
                    StudentUnits."No. Of Units" := StageUnits."No. Units";
                    StudentUnits."Unit Category Code" := StageUnits."Unit Category";
                    StudUnits.calcfields("Grade Exists");
                    if StudUnits."Grade Exists" = true then
                        StudentUnits."Earned Credits" := StudUnits."No. Of Units";
                    StudentUnits.Description := StageUnits.Desription;
                    StudentUnits."Progress Status" := StudentUnits."Progress Status"::Future;
                    StudentUnits."Date created" := today;
                    StudentUnits.type := StudentUnits.type::MAJOR;
                    if UnitsCategory.get(StageUnits."Unit Category") then
                        StudentUnits."Unit Category Name" := UnitsCategory.Description;

                    StudentUnits.INSERT;
                end;
            until StageUnits.Next = 0
        end;
        /*
        AdmRemedial.Reset; // Insert for Remedials
        AdmRemedial.SetRange(AdmRemedial."Admission No", Cust."Application No.");
        if AdmRemedial.Find('-') then begin
            repeat
                StudentUnits.reset;
                StudentUnits.setrange("Student No.", StudNo);
                StudentUnits.setrange(Unit, AdmRemedial."Course Code");
                if not StudentUnits.find('-') then begin
                    StudentUnits.Init;
                    StudentUnits."Student No." := StudNo;
                    StudentUnits.Programme := Cust."Current Programme";
                    StudentUnits.Unit := AdmRemedial."Course Code";
                    //  StudentUnits."Unit Type" := StageUnits."Unit Type";
                    StudentUnits."No. Of Units" := AdmRemedial."No of Credits";
                    StudUnits.calcfields("Grade Exists");
                    if StudUnits."Grade Exists" = true then
                        StudentUnits."Earned Credits" := AdmRemedial."No of Credits";
                    StudentUnits.Description := AdmRemedial.Description;
                    StudentUnits."Progress Status" := StudentUnits."Progress Status"::Future;
                    StudentUnits."Date created" := today;
                    StudentUnits.type := StudentUnits.type::MAJOR;
                    UnitsSubj.reset;
                    UnitsSubj.setrange("Programme Code", Cust."Current Programme");
                    UnitsSubj.setrange(Code, Studunits.Unit);
                    if UnitsSubj.find('-') then begin
                        StudentUnits."Unit Type" := UnitsSubj."Unit Type";
                        StudentUnits."Unit Category Code" := UnitsSubj."Unit Category";
                        if UnitsCategory.get(UnitsSubj."Unit Category") then
                            StudentUnits."Unit Category Name" := UnitsCategory.Description;
                    end;
                    StudentUnits.INSERT;
                end;
            until AdmRemedial.Next = 0
        end;
*/

        /*
        if Cust."Minor Concentration" <> '' then begin
            ConcUnits.Reset; // Insert for other programme major Concentrations
            ConcUnits.SetRange(ConcUnits."Concentration Code", Cust."Minor Concentration");
            if ConcUnits.find('-') then begin
                repeat
                    StudentUnits.reset;
                    StudentUnits.setrange("Student No.", StudNo);
                    StudentUnits.setrange(Unit, ConcUnits."Unit Code");
                    if not StudentUnits.find('-') then begin
                        if cMaster.get(ConcUnits."Unit Code") then begin
                            StudentUnits.Init;
                            StudentUnits."Student No." := StudNo;
                            StudentUnits.Programme := Cust."Current Programme";
                            StudentUnits.Unit := ConcUnits."Unit Code";
                            StudentUnits."Unit Type" := cMaster."Unit Type";
                            StudentUnits."No. Of Units" := cmaster.Units;
                            StudUnits.calcfields("Grade Exists");
                            if StudUnits."Grade Exists" = true then
                                StudentUnits."Earned Credits" := cmaster.Units;
                            StudentUnits.Description := cmaster.Description;
                            StudentUnits."Unit Description" := cmaster.Description;
                            StudentUnits."Progress Status" := StudentUnits."Progress Status"::Future;
                            StudentUnits."Date created" := today;
                            StudentUnits.type := StudentUnits.type::MINOR;
                            StudentUnits.Concentration := Cust."Minor Concentration";
                            UnitsSubj.reset;
                            UnitsSubj.setrange("Programme Code", Cust."Current Programme");
                            UnitsSubj.setrange(Code, Studunits.Unit);
                            if UnitsSubj.find('-') then begin
                                StudentUnits."Unit Type" := UnitsSubj."Unit Type";
                                StudentUnits."Unit Category Code" := UnitsSubj."Unit Category";
                                if UnitsCategory.get(UnitsSubj."Unit Category") then
                                    StudentUnits."Unit Category Name" := UnitsCategory.Description;
                            end;
                            StudentUnits.INSERT;
                        end;
                    end;
                until ConcUnits.Next = 0
            end;
        end;
       
        StudCon.reset;
        StudCon.setrange("Student No", StudNo);
        StudCon.setrange(Programme, Cust."Current Programme");
        if StudCon.find('-') then begin
            repeat
                ConcUnits.Reset;
                ConcUnits.SetRange(ConcUnits."Concentration Code", StudCon."Concentration No");
                if ConcUnits.find('-') then begin
                    repeat
                        StudentUnits.reset;
                        StudentUnits.setrange("Student No.", StudNo);
                        StudentUnits.setrange(Unit, ConcUnits."Unit Code");
                        if not StudentUnits.find('-') then begin
                            if cMaster.get(ConcUnits."Unit Code") then;
                            StudentUnits.Init;
                            StudentUnits."Student No." := StudNo;
                            StudentUnits.Programme := Cust."Current Programme";
                            StudentUnits.Unit := ConcUnits."Unit Code";
                            StudentUnits."Unit Type" := StudentUnits."Unit Type"::Required;
                            StudentUnits."No. Of Units" := cmaster.Units;
                            StudUnits.calcfields("Grade Exists");
                            if StudUnits."Grade Exists" = true then
                                StudentUnits."Earned Credits" := cmaster.Units;
                            StudentUnits.Description := cmaster.Description;
                            StudentUnits."Unit Description" := cmaster.Description;
                            StudentUnits."Progress Status" := StudentUnits."Progress Status"::Future;
                            StudentUnits."Date created" := today;
                            StudentUnits.type := StudentUnits.type::CONCEN;
                            StudentUnits.Concentration := StudCon."Concentration No";
                            StudentUnits."Unit Category Name" := 'Required';
                            StudentUnits."Unit Category Code" := 'CORE';
                            StudentUnits."Unit Type" := StudentUnits."Unit Type"::Required;
                            UnitsSubj.reset;
                            UnitsSubj.setrange("Programme Code", Cust."Current Programme");
                            UnitsSubj.setrange(Code, Studunits.Unit);
                            if UnitsSubj.find('-') then begin
                                StudentUnits."No. Of Units" := UnitsSubj."No. Units";
                                StudUnits.calcfields("Grade Exists");
                                if StudUnits."Grade Exists" = true then
                                    StudentUnits."Earned Credits" := UnitsSubj."No. Units";
                                // if UnitsCategory.get(UnitsSubj."Unit Category") then
                                //     StudentUnits."Unit Category Name" := UnitsCategory.Description;
                            end;

                            StudentUnits.INSERT;
                            // end;
                        end else begin
                            StudentUnits."Unit Type" := StudentUnits."Unit Type"::Required;
                            StudentUnits.Concentration := StudCon."Concentration No";
                            StudentUnits."Unit Category Name" := 'Required';
                            StudentUnits."Unit Category Code" := 'CORE';
                            StudentUnits.modify;
                        end;
                    until ConcUnits.next = 0;
                end;

            until StudCon.next = 0;
        end;
        /*
        if Cust.Concentration1 <> '' then begin
            ConcUnits.Reset; // Insert for other programme major Concentrations
            ConcUnits.SetRange(ConcUnits."Concentration Code", Cust.Concentration1);
            if ConcUnits.find('-') then begin
                repeat
                    StudentUnits.reset;
                    StudentUnits.setrange("Student No.", StudNo);
                    StudentUnits.setrange(Unit, ConcUnits."Unit Code");
                    if not StudentUnits.find('-') then begin
                        if cMaster.get(ConcUnits."Unit Code") then begin
                            StudentUnits.Init;
                            StudentUnits."Student No." := StudNo;
                            StudentUnits.Programme := Cust."Current Programme";
                            StudentUnits.Unit := ConcUnits."Unit Code";
                            StudentUnits."Unit Type" := cMaster."Unit Type";
                            StudentUnits."No. Of Units" := cmaster.Units;
                            StudentUnits.Description := cmaster.Description;
                            StudentUnits."Unit Description" := cmaster.Description;
                            StudentUnits."Progress Status" := StudentUnits."Progress Status"::Future;
                            StudentUnits."Date created" := today;
                            StudentUnits.type := StudentUnits.type::CONCEN;
                            StudentUnits.Concentration := Cust.Concentration1;
                            StudentUnits.INSERT;
                        end;
                    end;
                until ConcUnits.Next = 0
            end;
        end;
        if Cust.Concentration2 <> '' then begin
            ConcUnits.Reset; // Insert for other programme major Concentrations
            ConcUnits.SetRange(ConcUnits."Concentration Code", Cust.Concentration2);
            if ConcUnits.find('-') then begin
                repeat
                    StudentUnits.reset;
                    StudentUnits.setrange("Student No.", StudNo);
                    StudentUnits.setrange(Unit, ConcUnits."Unit Code");
                    if not StudentUnits.find('-') then begin
                        if cMaster.get(ConcUnits."Unit Code") then begin
                            StudentUnits.Init;
                            StudentUnits."Student No." := StudNo;
                            StudentUnits.Programme := Cust."Current Programme";
                            StudentUnits.Unit := ConcUnits."Unit Code";
                            StudentUnits."Unit Type" := cMaster."Unit Type";
                            StudentUnits."No. Of Units" := cmaster.Units;
                            StudentUnits.Description := cmaster.Description;
                            StudentUnits."Unit Description" := cmaster.Description;
                            StudentUnits."Progress Status" := StudentUnits."Progress Status"::Future;
                            StudentUnits."Date created" := today;
                            StudentUnits.type := StudentUnits.type::CONCEN;
                            StudentUnits.Concentration := Cust.Concentration2;
                            StudentUnits.INSERT;
                        end;
                    end;
                until ConcUnits.Next = 0
            end;


        end;
        */
    end;

    procedure InsertStudentCharges(StdNo: Code[20]; Sem: Code[20]; ChargeCode: Code[20])
    var
        Creg: Record "Course Registration";
        ChargeRec: Record charge;
        StudCharge: Record "Student Charges";
    begin
        Creg.reset;
        creg.setrange("Student No.", StdNo);
        creg.setrange(Semester, Sem);
        if creg.find('-') then begin
            ChargeRec.get(ChargeCode);
            ChargeRec.TestField(Amount);
            StudCharge.init;
            StudCharge."Student No." := StdNo;
            StudCharge.Semester := sem;
            StudCharge.Date := today;
            StudCharge.Code := ChargeCode;
            StudCharge.Description := ChargeRec.Description;
            StudCharge."Reg. Transacton ID" := creg."Reg. Transacton ID";
            StudCharge.Amount := ChargeRec.Amount;
            StudCharge."Transaction Type" := StudCharge."Transaction Type"::Charges;
            StudCharge.Programme := creg.Programme;
            StudCharge.Validate("Transacton ID");
            StudCharge.insert;
        end
    end;

    procedure EmailStudentReceipt(StdNo: Code[20]; ReceiptNo: Code[20])
    var
        Receipt: Record Receipt;
        Cust: Record Customer;
        GeneralSetup: Record "General Set-Up";

        FILESPATH: text[200];
        filename: text[200];

    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";

        filename := FILESPATH + 'Receipt';
        if Exists(filename) then
            Erase(filename);

        Receipt.reset;
        Receipt.setrange(Receipt."Receipt No.", ReceiptNo);
        Receipt.setrange(Receipt."Student No.", StdNo);
        if Receipt.find('-') then begin
            Report.SaveAsPdf(70134858, filename, Receipt);
            if Cust.get(StdNo) then begin
                if cust."E-Mail" <> '' then
                    if SendEmail(Cust."E-Mail", 'Receipt -' + ReceiptNo, 'Payment acknowledgment Receipt', 'Receipt') then;

            end;
        end;
    end;

    procedure EmailStudentInvoice(StdNo: Code[20])
    var
        Creg: Record "Course Registration";
        Cust: Record Customer;
        GeneralSetup: Record "General Set-Up";
        SemRec: Record semesters;
        Sem: code[20];
        FILESPATH: text[200];
        filename: text[200];

    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";

        filename := FILESPATH + 'Invoice';
        if Exists(filename) then
            Erase(filename);

        SemRec.reset;
        SemRec.setrange("Current Semester", true);
        if SemRec.find('-') then
            sem := SemRec.Code;

        creg.reset;
        creg.setrange(creg."Student No.", StdNo);
        creg.setrange(creg.Semester, Sem);
        if creg.find('-') then begin
            Report.SaveAsPdf(70135669, filename, creg);
            if Cust.get(StdNo) then begin
                if cust."E-Mail" <> '' then
                    if SendEmail(Cust."E-Mail", 'Invoice -' + Sem, 'Semester Registration Invoice', 'Invoice') then;

            end;
        end;
    end;


    procedure SendEmail(VAR receiver: Text[130]; subject: Text[50]; message: Text[1000]; MailType: Text[30]) returnValue: Boolean
    var
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        GeneralSetup: Record "General Set-Up";
        FILESPATH: text[200];
        filename: text[200];
        ListOfRecipients: List of [Text];
    begin
        ListOfRecipients.Add(receiver);
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";

        filename := FILESPATH + mailtype;
        returnValue := FALSE;
        //SMTPMailSetup.GET;

        // // CashOfficeSetup.TestField("Email Attachment Path");

        // SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", ListOfRecipients, subject, message, true);
        // SMTPMail.AddAttachment(filename, subject);
        // SMTPMail.Send;

        SMTPMail.Create(ListOfRecipients, COMPANYNAME, 'TEST', true);
        // SMTPMail.Create(COMPANYNAME, CompanyInfo."E-Mail", ReceipAdd,
        //'This is to inform you that: ' + DocNo, 'Employee Number ' + ' ' + DocNo + ' has  ' + Description + ' Effective from. ' + FORMAT("Date Of Leaving")
        //, TRUE);
        //  SMTPMail.AppendBody('<br>');
        SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);

        returnValue := TRUE;
    end;

    procedure PostGLReversal(DocNo: code[20]; PDate: Date)
    var
        GL: record "G/L Entry";
    begin
        gl.reset;
        gl.setrange(GL."Document No.", DocNo);
        gl.setrange(gl."Posting Date", pdate);
        if gl.find('-') then
            gl.DeleteAll();
    end;

    procedure PostForcedReversal(DocNo: code[20])
    var
        GL: record "G/L Entry";
        CustL: Record "Cust. Ledger Entry";
        CustD: Record "Detailed Cust. Ledg. Entry";
        Cust: Record customer;
    begin
        gl.reset;
        gl.setrange(GL."Document No.", DocNo);
        //gl.setrange(gl."Posting Date", pdate);
        if gl.find('-') then begin

            gl.DeleteAll();
        end;

        CustL.reset;
        CustL.setrange(CustL."Document No.", DocNo);
        // CustL.setrange(CustL."Posting Date", pdate);
        if CustL.find('-') then begin
            if Cust.get(CustL."Customer No.") then
                if Cust."Departure Date" <> CustL."Posting Date" then begin
                    Cust."Departure Date" := CustL."Posting Date";
                    // Cust."Date Returned" := today;
                    Cust.modify;
                end;
            CustL.DeleteAll();
        end;

        CustD.reset;
        CustD.setrange(CustD."Document No.", DocNo);
        // CustD.setrange(CustD."Posting Date", pdate);
        if CustD.find('-') then
            CustD.DeleteAll();
    end;

    procedure PostForcedUnApply(DocNo: code[20])
    var
        CustD: Record "Detailed Cust. Ledg. Entry";
    begin

        CustD.reset;
        CustD.setrange(CustD."Document No.", DocNo);
        CustD.setrange(CustD."Entry Type", CustD."Entry Type"::Application);
        if CustD.find('-') then
            CustD.DeleteAll();
    end;
}

