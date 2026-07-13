Page 50113 "Students Transfer"
{
    PageType = List;
    SourceTable = "Students Transfer";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Student No"; Rec."Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No field.';
                }
                field(NewProgramme; Rec."New Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the New Programme field.';
                }
                field(NewStudentNo; Rec."New Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the New Student No field.';
                }
                field("Current Programme"; Rec."Current Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Programme field.';
                }

                field(SettlementType; Rec."Settlement Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(AcademicYear; Rec."Academic Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Academic Year field.';
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
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Image = Save;
                Promoted = true;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                var
                    StudentUnits: Record "Student Units";
                    StudentUnitBasket: Record "Student Unit Basket";
                begin
                    Rec.TestField(Posted, false);
                    Rec.TestField("New Student No");
                    Rec.TestField("New Programme");
                    Rec.TestField(Semester);
                    Rec.TestField("Settlement Type");

                    if Cust2.Get(Rec."Student No") then begin
                        Cust2.CalcFields("Balance (LCY)");
                        Cust2.CalcFields(Cust2."Credit Amount");


                        GenJnl.Reset;
                        GenJnl.SetRange("Journal Template Name", 'SALES');
                        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                        GenJnl.DeleteAll;

                        // Register new Course
                        Creg2.Reset;
                        Creg2.SetRange(Creg2."Student No.", Cust2."No.");
                        //IF Creg2.COUNT>1 THEN ERROR('Please note that you can only transfer student with one registration');
                        if Creg2.Find('+') then begin
                            Creg2.Reversed := true;
                            Creg.Posted := true;
                            Creg2.Modify;
                            Creg.Init;
                            Creg."Student No." := Rec."New Student No";
                            Creg.Programme := Rec."New Programme";
                            Creg.Semester := Rec.Semester;
                            Creg."Academic Year" := Rec."Academic Year";
                            Creg.Status := Creg.Status::Current;
                            Creg.Stage := Creg2.Stage;
                            //Creg.Stage := 'Y1S1';
                            Creg."Settlement Type" := Creg2."Settlement Type";
                            Creg."Registration Date" := Creg2."Registration Date";
                            //Creg.Posted :=TRUE;
                            Creg."User ID" := UserId;
                            Creg."Intake Code" := Creg2."Intake Code";

                            Creg."Reg. Transacton ID" := Creg2."Reg. Transacton ID";
                            //Creg.VALIDATE(Creg."Settlement Type");
                            Creg.Insert;
                        end;

                        Creg.Reset;
                        Creg.SetCurrentkey(Creg."Reg. Transacton ID");
                        Creg.SetRange(Creg."Reg. Transacton ID", Creg2."Reg. Transacton ID");
                        Creg.SetRange(Creg."Student No.", Rec."New Student No");
                        Creg.SetRange(Creg.Posted, false);
                        if Creg.Find('+') then begin
                            Creg.Validate(Creg."Settlement Type");
                        end;

                        Cust2.Rename(Rec."New Student No");
                        // Reverse Old Charges
                        StudentCharges.Reset;
                        StudentCharges.SetRange(StudentCharges."Student No.", Rec."New Student No");
                        StudentCharges.SetRange(StudentCharges.Recognized, true);
                        StudentCharges.setfilter("Posted Amount", '>%1', 0);
                        if StudentCharges.Find('-') then begin
                            repeat
                                StudentCharges.CalcFields(StudentCharges.Hostel);
                                if StudentCharges.Hostel = false then begin
                                    Ln := Ln + 1000;
                                    GenJnl.Init;
                                    GenJnl."Line No." := Ln;
                                    GenJnl."Posting Date" := Today;
                                    GenJnl."Document No." := StudentCharges."Transacton ID";
                                    GenJnl.Validate(GenJnl."Document No.");
                                    GenJnl."Journal Template Name" := 'SALES';
                                    GenJnl."Journal Batch Name" := 'STUD PAY';
                                    GenJnl."Account Type" := GenJnl."account type"::Customer;
                                    GenJnl."Account No." := Rec."New Student No";

                                    GenJnl.Amount := StudentCharges.Amount * -1;
                                    GenJnl.Validate(GenJnl."Account No.");
                                    GenJnl.Validate(GenJnl.Amount);
                                    GenJnl.Description := StudentCharges.Description + '-Reversal';
                                    GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";
                                    StudentCharges.CalcFields(StudentCharges."Charge G/L Account");
                                    StudentCharges.CalcFields(StudentCharges."Tuition G/L Account");
                                    if StudentCharges."Charge G/L Account" <> '' then
                                        GenJnl."Bal. Account No." := StudentCharges."Charge G/L Account"
                                    else
                                        GenJnl."Bal. Account No." := StudentCharges."Tuition G/L Account";


                                    GenJnl.Validate(GenJnl."Bal. Account No.");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    if Prog.Get(StudentCharges.Programme) then begin
                                        Prog.TestField(Prog."Department Code");
                                        GenJnl."Shortcut Dimension 2 Code" := Prog."Department Code";
                                    end;



                                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                                    //GenJnl."Due Date":=DueDate;
                                    GenJnl.Validate(GenJnl."Due Date");
                                    if GenJnl.Amount <> 0 then
                                        GenJnl.Insert;
                                end;
                            until StudentCharges.Next = 0;
                        end;

                        // Post New course charges
                        StudentCharges.Reset;
                        StudentCharges.SetRange(StudentCharges."Student No.", Rec."New Student No");
                        StudentCharges.SetRange(StudentCharges.Recognized, false);
                        StudentCharges.SetRange(StudentCharges.Posted, false);
                        if StudentCharges.Find('-') then begin
                            repeat
                                Ln := Ln + 1000;
                                GenJnl.Init;
                                GenJnl."Line No." := Ln;
                                GenJnl."Posting Date" := Today;
                                GenJnl."Document No." := StudentCharges."Transacton ID";
                                GenJnl.Validate(GenJnl."Document No.");
                                GenJnl."Journal Template Name" := 'SALES';
                                GenJnl."Journal Batch Name" := 'STUD PAY';
                                GenJnl."Account Type" := GenJnl."account type"::Customer;
                                GenJnl."Account No." := Rec."New Student No";
                                GenJnl.Amount := StudentCharges.Amount;
                                GenJnl.Validate(GenJnl."Account No.");
                                GenJnl.Validate(GenJnl.Amount);
                                GenJnl.Description := StudentCharges.Description;
                                GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";

                                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                                   (StudentCharges.Charge = false) then begin
                                    if "Settlement TypeRec".Get(Rec."Settlement Type") then
                                        GenJnl."Bal. Account No." := "Settlement TypeRec"."Tuition G/L Account";

                                    Creg.Reset;
                                    Creg.SetCurrentkey(Creg."Reg. Transacton ID");
                                    Creg.SetRange(Creg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                                    Creg.SetRange(Creg."Student No.", StudentCharges."Student No.");
                                    if Creg.Find('-') then begin
                                        if Creg."Register for" = Creg."register for"::Stage then begin
                                            Stages.Reset;
                                            Stages.SetRange(Stages."Programme Code", Creg.Programme);
                                            Stages.SetRange(Stages.Code, Creg.Stage);
                                            if Stages.Find('-') then begin
                                                if (Stages."Modules Registration" = true) and (Stages."Ignore No. Of Units" = false) then begin
                                                    Creg.CalcFields(Creg."Units Taken");
                                                    if Creg."Exempted Units" <> Creg."Units Taken" then
                                                        Error('Units Taken must be equal to the no of modules registered for.');

                                                end;
                                            end;
                                        end;
                                        ///////////////////////////////////////////////////////////////////////
                                        Creg.Posted := true;
                                        Creg.Modify;
                                    end;


                                end else
                                    if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                                       (StudentCharges.Charge = false) then begin
                                        //GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";
                                        StudentCharges.CalcFields(StudentCharges."Settlement Type");
                                        GenJnl."Bal. Account No." := "Settlement TypeRec"."Tuition G/L Account";


                                        Creg.Reset;
                                        Creg.SetCurrentkey(Creg."Reg. Transacton ID");
                                        //Creg.SETRANGE(Creg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
                                        Creg.SetRange(Creg.Posted, false);
                                        Creg.SetRange(Creg."Student No.", Rec."New Student No");
                                        if Creg.Find('-') then begin
                                            Creg.Posted := true;
                                            Creg.Modify;
                                        end;
                                    end;

                                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or (StudentCharges.Charge = true) then begin
                                    if Charges.Get(StudentCharges.Code) then
                                        GenJnl."Bal. Account No." := Charges."G/L Account";
                                end;

                                GenJnl.Validate(GenJnl."Bal. Account No.");
                                GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                if Prog.Get(StudentCharges.Programme) then begin
                                    Prog.TestField(Prog."Department Code");
                                    GenJnl."Shortcut Dimension 2 Code" := Prog."Department Code";
                                end;

                                GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                                GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                                //GenJnl."Due Date":=DueDate;
                                GenJnl.Validate(GenJnl."Due Date");

                                if GenJnl.Amount <> 0 then
                                    GenJnl.Insert;
                            //end;
                            until StudentCharges.Next = 0;
                        end;
                        /////////////////////////////////////////////////////////////////////////////NEW CHARGES
                        //Post
                        GenJnl.Reset;
                        GenJnl.SetRange("Journal Template Name", 'SALES');
                        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                        if GenJnl.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnl);
                        end;
                        /*
                       Cust2.Status:=Cust2.Status::Transferred;
                       Cust2.Blocked:=Cust2.Blocked::All;
                       Cust2.MODIFY;
                       */
                    end;

                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", Rec."New Student No");
                    //StudentCharges.SETRANGE(StudentCharges.Recognized,TRUE);
                    if StudentCharges.Find('-') then begin
                        repeat
                            StudentCharges.Recognized := true;
                            StudentCharges.Modify;
                        until StudentCharges.Next = 0;
                    end;

                    Creg.Reset;
                    Creg.SetCurrentkey(Creg."Reg. Transacton ID");
                    //Creg.SETRANGE(Creg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
                    Creg.SetRange(Creg.Posted, false);
                    Creg.SetRange(Creg."Student No.", Rec."New Student No");
                    if Creg.Find('-') then begin
                        Creg.Posted := true;
                        Creg.Modify;
                    end;

                    StudTrans.Reset;
                    StudTrans.SetRange(StudTrans."Student No", Rec."New Student No");
                    if StudTrans.Find('-') then begin
                        StudTrans.Posted := true;
                        StudTrans."Posted By" := UserId;
                        StudTrans.Modify;
                        if Cust.get(Rec."New Student No") then begin
                            Cust."Current Programme" := Rec."New Programme";
                            Cust.validate("Current Programme");
                            Cust.modify;
                        end;
                    end;
                    //delete registered units
                    StudentUnits.RESET;
                    StudentUnits.SETFILTER("Student No.", '%1|%2', Rec."Student No", Rec."New Student No");
                    IF StudentUnits.FIND('-') THEN BEGIN
                        StudentUnits.DELETEALL;
                    END;

                    StudentUnitBasket.RESET;
                    StudentUnitBasket.SETFILTER("Student No.", '%1|%2', Rec."Student No", Rec."New Student No");
                    IF StudentUnitBasket.FIND('-') THEN BEGIN
                        StudentUnitBasket.DELETEALL;
                    END;
                    Message('%1', 'Student transferred successfully.');
                end;
            }
            action("Print Transfer Letter")
            {
                ApplicationArea = Basic;
                Image = Save;
                Promoted = true;
                ToolTip = 'Executes the Print Transfer Letter action.';

                trigger OnAction()
                var
                    StudentsTransfer: Record "Students Transfer";
                begin
                    if Rec.Posted = false then Error('This record has not been posted');

                    StudentsTransfer.Reset;
                    StudentsTransfer.SetRange(StudentsTransfer."New Student No", Rec."Student No");
                    if StudentsTransfer.Find('-') then begin
                        REPORT.Run(51360, true, true, StudentsTransfer);
                    end;
                end;
            }
        }
    }

    var
        Cust: Record Customer;
        Cust2: Record Customer;
        GenJnl: Record "Gen. Journal Line";
        Creg: Record "Course Registration";
        Creg2: Record "Course Registration";
        StudentCharges: Record "Student Charges";
        Ln: Integer;
        StudTrans: Record "Students Transfer";
        Prog: Record Programme;
        "Settlement TypeRec": Record "Settlement Type";
        Stages: Record "Programme Stages";
        Charges: Record Charge;
}

