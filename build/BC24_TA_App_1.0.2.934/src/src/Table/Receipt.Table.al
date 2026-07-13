Table 50070 Receipt
{

    fields
    {
        field(1; "Student No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(2; "Receipt No."; Code[20])
        {

            trigger OnValidate()
            begin
                if "Receipt No." <> xRec."Receipt No." then begin
                    GenSetup.Get;
                    NoSeriesMgt.TestManual(GenSetup."Receipt Nos.");
                    "No. Series" := '';
                end;

                if "Receipt No." = '' then begin
                    GenSetup.Get;
                    GenSetup.TestField(GenSetup."Receipt Nos.");
                    "Receipt No.":=NoSeriesMgt.GetNextNo(GenSetup."Receipt Nos.", 0D, true);
                end;
            end;
        }
        field(3; Date; Date) { }
        field(4; "Payment Mode"; Option)
        {
            OptionCaption = ' ,Bank Slip,Cheque,Banker''s Cheque,Cash,Mpesa,PDQ,Unreferenced,Money Order,Direct Bank Deposit,Staff Invoice,Weiver,HELB,CDF';
            OptionMembers = " ","Bank Slip",Cheque,"Banker's Cheque",Cash,Mpesa,PDQ,Unreferenced,"Money Order","Direct Bank Deposit","Staff Invoice",Weiver,HELB,CDF;
        }
        field(5; Amount; Decimal) { }
        field(6; "No. Series"; Code[20]) { }
        field(7; "Payment By"; Text[150]) { }
        field(8; "User ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(9; "Transaction Date"; Date) { }
        field(10; "Transaction Time"; Time) { }
        field(11; "Student Name"; Text[150]) { }
        field(12; "Source Rcpt No"; Code[30])
        {

            trigger OnValidate()
            begin
                // Rcpt.RESET;
                // Rcpt.SETCURRENTKEY(Rcpt."KCA Rcpt No");
                // Rcpt.SETRANGE(Rcpt."KCA Rcpt No","KCA Rcpt No");
                // IF Rcpt.FIND('-') THEN BEGIN
                // REPEAT
                // IF "Receipt No." <> Rcpt."Receipt No." THEN
                // ERROR('KCA Receipt No. already exists.');
                //
                // UNTIL Rcpt.NEXT = 0;
                // END;
            end;
        }
        field(13; "Amount Applied"; Decimal)
        {
            CalcFormula = sum("Receipt Items".Amount where("Receipt No" = field("Receipt No.")));
            FieldClass = FlowField;
        }
        field(14; "Un Posted"; Boolean) { }
        field(15; Posted; Boolean) { }
        field(16; Reversed; Boolean) { }
        field(17; "Auto Receipt"; Boolean) { }
        field(18; "Auto  Receipt Date"; Date) { }
        field(19; "Auto  Receipted"; Boolean) { }
        field(20; Unallocated; Boolean) { }
        field(21; "Bank Slip Date"; Date) { }
        field(22; "Bank Code"; Code[20]) { }
        field(23; Unreff; Boolean) { }
        field(24; "Unreff Transaction No"; Code[20]) { }
        field(25; "Auto Reversed"; Boolean)
        {
            CalcFormula = exist("Bank Account Ledger Entry" where("Document No." = field("Receipt No."),
                                                                   "Posting Date" = field(Date),
                                                                   Reversed = const(true)));
            FieldClass = FlowField;
        }
        field(26; "Bank Slip/Cheque No"; Code[50]) { }
        field(27; "Settlement Type"; Code[20])
        {
            CalcFormula = lookup("Course Registration"."Settlement Type" where("Student No." = field("Student No.")));
            FieldClass = FlowField;
            TableRelation = "Settlement Type";
        }
        field(28; "Reg ID"; Code[20]) { }
        field(29; "Bank Account"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Bank Account"."No.";
        }
        field(50000; "Room No"; Code[20]) { }
        field(50001; "Entry Count"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Document No." = field("Receipt No.")));
            FieldClass = FlowField;
        }
        field(50002; Stage; Code[20])
        {
            CalcFormula = lookup(Customer."No." where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(50003; "Unreff G/L Account"; Code[20]) { }
        field(50004; "Unreff Entry No"; Integer) { }
        field(50005; "Posted Bank"; Code[20])
        {
            CalcFormula = lookup("Bank Account Ledger Entry"."Bank Account No." where("External Document No." = field("Bank Slip/Cheque No")));
            FieldClass = FlowField;
            TableRelation = "Bank Account"."No.";
        }
        field(50006; Names; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(50007; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Receipt No.")
        {
            Clustered = true;
        }
        key(Key2; "User ID") { }
        key(Key3; "Student Name") { }
        key(Key4; "Student No.")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "Payment Mode") { }
        key(Key6; "Student No.", Date)
        {
            SumIndexFields = Amount;
        }
        key(Key7; "Student No.", "Reg ID")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        //GenSetup.GET;
        //IF (Date > GenSetup."Allow Posting To") OR (Date < GenSetup."Allow Posting From") THEN
        //ERROR('Modification or deletion out of the allowed range not allowed.')
    end;

    trigger OnModify()
    begin
        GenSetup.Get;
        if (Date > GenSetup."Allow Posting To") or (Date < GenSetup."Allow Posting From") then
            ;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        GenSetup: Record "General Set-Up";
}

