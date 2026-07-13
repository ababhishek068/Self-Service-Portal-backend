Table 50082 "Student Charges"
{
    DrillDownPageID = "Student Charges List";
    LookupPageID = "Student Charges List";

    fields
    {
        field(1; "Student No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(2; "Reg. Transacton ID"; Code[20])
        {
            TableRelation = "Course Registration"."Reg. Transacton ID" where("Student No." = field("Student No."));

            trigger OnValidate()
            begin
                StudReg.Reset;
                StudReg.SetRange(StudReg."Reg. Transacton ID", "Reg. Transacton ID");
                if StudReg.Find('-') then begin
                    Programme := StudReg.Programme;
                    Stage := StudReg.Stage;
                    //Unit:=StudReg.Unit;
                    Semester := StudReg.Semester;
                end;
            end;
        }
        field(3; "Transaction Type"; Option)
        {
            Editable = true;
            OptionCaption = 'Charges,Stage Fees,Unit Fees,Stage Exam Fees,Unit Exam Fees';
            OptionMembers = Charges,"Stage Fees","Unit Fees","Stage Exam Fees","Unit Exam Fees";
        }
        field(4; "Code"; Code[20])
        {
            Editable = true;
            TableRelation = if ("Transaction Type" = const(Charges)) Charge.Code;

            trigger OnValidate()
            begin
                TestField(Date);

                //  TESTFIELD("Reg. Transacton ID");
                if "Reg. Transacton ID" = '' then begin
                    StudReg.Reset;
                    StudReg.SetRange(StudReg."Student No.", "Student No.");
                    StudReg.SetRange(StudReg.Reversed, false);
                    if StudReg.Find('+') then begin
                        "Reg. Transacton ID" := StudReg."Reg. Transacton ID";
                        Semester := StudReg.Semester;
                        Programme := StudReg.Programme;
                        Stage := StudReg.Stage;
                        Date := Today;
                        StudReg.TestField(StudReg."Registration Date");
                        StudReg.Validate("Reg. Transacton ID");
                    end else begin
                        Error('Registration does not exist.');
                    end;

                end;



                if "Transaction Type" = "transaction type"::Charges then begin
                    if Charges.Get(Code) then begin
                        if Charges.Hostel = true then
                            if Cust.Get("Student No.") then
                                Cust.TestField(Cust."Hostel Black Listed", false);
                        Description := Charges.Description;
                        Amount := Charges.Amount;
                        /*
                        Charges.SETFILTER(Charges."Semester Filter",Semester);
                        Charges.CALCFIELDS(Charges."Charged Rooms Count");
                        Charges.CALCFIELDS(Charges."Issued Rooms");
                        Charges.CALCFIELDS(Charges."Vacant Rooms Count");
                        IF Charges."Vacant Rooms Count"<=0 THEN
                        IF CONFIRM('The Vacant Rooms has been fully occupied do you wish to proceed? ')=FALSE THEN
                        ERROR('Transaction Aborted');
                         */
                    end;
                    Charge := true;
                end else
                    Charge := false;

            end;
        }
        field(5; Description; Text[150]) { }
        field(6; Amount; Decimal) { }
        field(7; Remarks; Text[200]) { }
        field(8; Date; Date)
        {
            NotBlank = true;
        }
        field(9; "Amount Paid"; Decimal) { }
        field(11; "Applied Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                TotalApplied:=0;
                
                StudentCharges.RESET;
                StudentCharges.SETRANGE(StudentCharges."Student No.","Student No.");
                IF StudentCharges.FIND('-') THEN BEGIN
                REPEAT
                TotalApplied:=TotalApplied+StudentCharges."Applied Amount";
                UNTIL StudentCharges.NEXT = 0;
                END;
                
                
                IF "Applied Amount" <> xRec."Applied Amount" THEN
                TotalApplied := TotalApplied + ("Applied Amount" - xRec."Applied Amount")
                ELSE
                TotalApplied := TotalApplied + "Applied Amount";
                
                
                StudentPayments.RESET;
                StudentPayments.SETRANGE(StudentPayments."Student No.","Student No.");
                IF StudentPayments.FIND('-') THEN BEGIN
                StudentPayments."Unapplied Amount":=StudentPayments."Amount to pay"-TotalApplied;
                StudentPayments.MODIFY;
                END;
                */

            end;
        }
        field(12; "Apply too"; Boolean) { }
        field(16; "Apply to"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Recovered First" = false then begin
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                    StudentCharges.SetRange(StudentCharges."Apply to", false);
                    StudentCharges.SetRange(StudentCharges."Fully Paid", false);
                    StudentCharges.SetRange(StudentCharges."Recovered First", true);
                    if StudentCharges.Find('-') then
                        Error('Apply payment to the charges which should be recorvered first');

                end;


                TotalApplied := 0;
                "Applied Amount" := 0;

                if "Apply to" = true then begin
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                    if StudentCharges.Find('-') then begin
                        repeat
                            TotalApplied := TotalApplied + StudentCharges."Applied Amount";
                        until StudentCharges.Next = 0;

                    end;


                    StudentPayments.Reset;
                    StudentPayments.SetRange(StudentPayments."Student No.", "Student No.");
                    if StudentPayments.Find('-') then begin
                        if (StudentPayments."Amount to pay" - TotalApplied) > (Amount - "Amount Paid") then
                            "Applied Amount" := (Amount - "Amount Paid")
                        else begin
                            if (StudentPayments."Amount to pay" - TotalApplied) > 0 then
                                "Applied Amount" := (StudentPayments."Amount to pay" - TotalApplied)
                            else begin
                                if xRec."Apply to" = false and "Apply to" = true then
                                    Error('Total amount has been applied.');
                            end;

                        end;
                    end;
                end;
            end;
        }
        field(17; Recognized; Boolean) { }
        field(18; Posted; Boolean) { }
        field(19; Programme; Code[20]) { }
        field(20; Stage; Code[20]) { }
        field(21; Unit; Code[20])
        {
            TableRelation = "Courses Master".Code;
        }
        field(22; Semester; Code[20])
        {
            TableRelation = Semesters.Code;
        }
        field(23; "Recovered First"; Boolean) { }
        field(24; Transfer; Boolean) { }
        field(25; "Transfer Amount"; Decimal) { }

        field(27; Transfered; Boolean) { }
        field(28; "Transacton ID"; Code[50])
        {

            trigger OnValidate()
            begin
                if "Transacton ID" <> xRec."Transacton ID" then begin
                    GenSetup.Get;
                    NoSeriesMgt.TestManual(GenSetup."Transaction Nos.");
                    "No. Series" := '';
                end;

                if "Transacton ID" = '' then begin
                    GenSetup.Get;
                    GenSetup.TestField(GenSetup."Transaction Nos.");
                    "Transacton ID":=NoSeriesMgt.GetNextNo(GenSetup."Transaction Nos.", 0D, true);
                end;
            end;
        }
        field(29; "No. Series"; Code[20]) { }
        field(30; "Fully Paid"; Boolean) { }
        field(31; "Tuition Fee"; Boolean) { }
        field(32; "Room Allocation"; Code[20])
        {
            Editable = true;
            Enabled = true;
            // TableRelation = "Hostel Rooms".Code;


        }
        field(33; Charge; Boolean) { }
        field(34; Reversed; Boolean)
        {

            trigger OnValidate()
            begin
                if Confirm('Are you sure you want to mark the transaction as reversed?', true) = false then
                    Reversed := false;
            end;
        }
        field(35; Distribution; Decimal) { }
        field(36; Quantity; Integer)
        {

            trigger OnValidate()
            begin
                TestField(Quantity);
                if "Transaction Type" = "transaction type"::Charges then begin
                    if Charges.Get(Code) then
                        Amount := Charges.Amount * Quantity;
                end;
            end;
        }
        field(37; Course; Code[20])
        {
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('COURSE'));
        }
        field(38; "Total Paid"; Decimal)
        {
            CalcFormula = sum("Receipt Items".Amount where("Transaction ID" = field("Transacton ID"),
                                                            "Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(438; "Posted Amount"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Document No." = field("Transacton ID"),
                                                            "Entry Type" = filter("Initial Entry")));
            FieldClass = FlowField;
        }
        field(39; "Applied Payment"; Decimal) { }
        field(40; "Recovery Priority"; Integer) { }
        field(41; "Full Tuition Fee"; Decimal) { }
        field(42; "Distribution Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(43; Currency; Code[20])
        {
            TableRelation = Currency.Code;
        }
        field(44; "Over Charged"; Boolean) { }
        field(45; "Over Charged Amount"; Decimal) { }
        field(46; "System Created"; Boolean) { }
        field(47; "Settlement Type"; Code[20])
        {
            CalcFormula = lookup("Course Registration"."Settlement Type" where("Reg. Transacton ID" = field("Reg. Transacton ID")));
            FieldClass = FlowField;
        }
        field(147; "Bill Settlement Type"; Code[20]) { }
        field(48; "Charge Gender"; Option)
        {
            CalcFormula = lookup(Charge.Gender where(Code = field(Code)));
            FieldClass = FlowField;
            OptionMembers = " ",Male,Female;
        }
        field(49; accommodation; Boolean) { }
        field(50; "Student Name"; Text[200])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(51; "Reversed LK"; Boolean)
        {
            CalcFormula = lookup("Cust. Ledger Entry".Reversed where("Customer No." = field("Student No."),
                                                                      "Document No." = field("Transacton ID")));
            FieldClass = FlowField;
        }
        field(52; "Tuition G/L Account"; Code[20])
        {
            CalcFormula = lookup("G/L Entry"."G/L Account No." where("Document No." = field("Transacton ID"),
                                                                      "Bal. Account Type" = const(Customer)));
            FieldClass = FlowField;
        }
        field(53; Stopped; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(54; Hostel; Boolean)
        {
            CalcFormula = lookup(Charge.Hostel where(Code = field(Code)));
            FieldClass = FlowField;
        }
        field(55; "Charge G/L Account"; Code[20])
        {
            CalcFormula = lookup(Charge."G/L Account" where(Code = field(Code)));
            FieldClass = FlowField;
            TableRelation = "G/L Account"."No.";
        }
        field(56; "School Code"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(57; "Campus Code"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(58; "Paid Amount"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Entry Type" = const(Application),
                                                                         "Cust. Ledger Entry No." = field("Cust Entry No")));
            FieldClass = FlowField;
        }
        field(59; "Cust Entry No"; Integer)
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Entry No." where("Customer No." = field("Student No."),
                                                                         "Document No." = field("Transacton ID")));
            FieldClass = FlowField;
        }
        field(60; "Reversed By"; code[20]) { }
        field(61; "Reversed Date"; Date) { }
        field(62; "Unit Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Student Units" where("Student No." = field("Student No."), Unit = field(Unit)));


        }
        field(63; Imported; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Transacton ID", "Student No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; Programme, Stage, Unit, Semester, Date)
        {
            SumIndexFields = "Amount Paid", Amount;
        }
        key(Key3; "Room Allocation") { }
        key(Key4; "Reg. Transacton ID", "Tuition Fee")
        {
            SumIndexFields = "Amount Paid", Amount;
        }
        key(Key5; "Student No.", "Code", "Tuition Fee", Date)
        {
            SumIndexFields = Amount;
        }
        key(Key6; "Student No.", "Code", Recognized) { }
        key(Key7; "Reg. Transacton ID") { }
        key(Key8; "Student No.", Recognized, "Recovery Priority") { }
        key(Key9; "Student No.") { }
        key(Key10; "Student No.", "Reg. Transacton ID", Date)
        {
            SumIndexFields = Amount;
        }
        key(Key11; "Student No.", "Reg. Transacton ID", "Code", Recognized)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        /*
        IF Recognized = TRUE THEN
        ERROR('You can not delete recognized/billed transactions.');
        GenSetup.GET;
        
        IF Date <> 0D THEN BEGIN
        IF (Date > GenSetup."Allow Posting To") OR (Date < GenSetup."Allow Posting From") THEN
        ERROR('Modification or deletion out of the allowed range not allowed.')
        END;
        */

    end;

    trigger OnInsert()
    begin
        /*
       StudReg.RESET;
       StudReg.SETRANGE(StudReg."Student No.","Student No.");
       IF StudReg.FIND('+') THEN BEGIN
       "Reg. Transacton ID":=StudReg."Reg. Transacton ID";
       Semester:=StudReg.Semester;
       Date:=TODAY;
       StudReg.TESTFIELD(StudReg."Registration Date");
       StudReg.VALIDATE("Reg. Transacton ID");
       END ELSE BEGIN
       ERROR('Registration does not exist.');
       END;
        */

    end;

    trigger OnModify()
    begin
        /*
        IF Recognized = TRUE THEN
        ERROR('You can not modify recognized/billed transactions.');
        GenSetup.GET;
        IF Date <> 0D THEN BEGIN
        IF (Date > GenSetup."Allow Posting To") OR (Date < GenSetup."Allow Posting From") THEN
        ERROR('Modification or deletion out of the allowed range not allowed.')
        END;
        */

    end;

    var
        Charges: Record Charge;
        StudentPayments: Record "Student Payments";
        TotalApplied: Decimal;
        StudentCharges: Record "Student Charges";
        NoSeriesMgt: Codeunit "No. Series";
        GenSetup: Record "General Set-Up";
        StudReg: Record "Course Registration";
        //  HRooms: Record "Hostel Rooms";
        Cust: Record Customer;
}

