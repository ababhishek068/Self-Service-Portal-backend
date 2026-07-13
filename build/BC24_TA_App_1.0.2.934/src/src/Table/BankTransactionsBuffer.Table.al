Table 50691 "Bank Transactions Buffer"
{

    fields
    {
        field(1; "Transaction Code"; Code[50])
        {
            NotBlank = true;
        }
        field(2; Date; DateTime)
        {
            NotBlank = true;
        }
        field(3; Description; Text[150]) { }
        field(4; Amount; Decimal)
        {
            NotBlank = true;
        }
        field(5; Posted; Boolean) { }
        field(6; "Receipt No"; Code[50]) { }
        field(7; "Student No."; Code[50])
        {
            TableRelation = Customer;
            ValidateTableRelation = false;
        }
        field(8; Unallocated; Boolean) { }
        field(9; "Cheque No"; Code[50]) { }
        field(10; "Stud Exist"; Integer)
        {
            CalcFormula = count(Customer where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(39; "Bank Exist"; Integer)
        {
            CalcFormula = count("Bank Account" where("No." = field("Bank Code")));
            FieldClass = FlowField;
        }
        field(11; Stage; Code[50])
        {
            CalcFormula = lookup("Course Registration".Stage where("Student No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(12; Name; Text[100]) { }
        field(13; IDNo; Code[30]) { }
        field(14; "Transcation Date"; DateTime) { }
        field(15; "Bank Code"; Code[30])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(19; Type; Code[20]) { }
        field(20; "Batch Receipt No"; Code[20])
        {
            TableRelation = "Receipts Header"."No.";
        }
        field(21; "Unidentified Type"; Option)
        {
            OptionCaption = ' ,Student,Application,Miscilenous';
            OptionMembers = " ",Student,"Application",Miscilenous;
        }
        field(22; "Misc G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(23; UserID; Code[50]) { }
        field(24; "Receipted Bank"; Code[20])
        {
            CalcFormula = lookup("Bank Account Ledger Entry"."Bank Account No." where("Document No." = field("Receipt No")));
            FieldClass = FlowField;
        }
        field(25; "Admission No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Admitted Exist"; Integer)
        {
            CalcFormula = count(Customer where("Application No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(27; Names; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
        field(28; "Posted Count"; Integer)
        {
            CalcFormula = count("Bank Account Ledger Entry" where("External Document No." = field("Transaction Code")));
            FieldClass = FlowField;
        }
        field(29; "Posted Receipt No"; Code[20])
        {
            CalcFormula = lookup("Bank Account Ledger Entry"."Document No." where("External Document No." = field("Transaction Code")));
            FieldClass = FlowField;
        }
        field(30; "Posted To Student"; Boolean)
        {
            CalcFormula = Exist("Cust. Ledger Entry" WHERE("External Document No." = FIELD("Transaction Code")));
            FieldClass = FlowField;
        }
        field(31; "Sales Person"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
            trigger OnValidate()
            var
                PumpAttendant: record "Salesperson/Purchaser";
                DimRec: record "Dimension Value";
            begin
                if PumpAttendant.get("Sales Person") then begin
                    PumpAttendant.TestField("Global Dimension 1 Code");

                    "Global Dimension1 Code" := PumpAttendant."Global Dimension 1 Code";
                    DimRec.reset;
                    DimRec.setrange("Dimension Code", PumpAttendant."Global Dimension 1 Code");
                    if DimRec.find('-') then begin
                        Dimrec.TestField("Mpesa Account");
                        "Bank Code" := Dimrec."Mpesa Account";
                    end;
                end;
            end;
        }
        field(32; "Global Dimension1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));
        }
        field(33; "Printed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "External Document No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "External Document No 2"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Transaction Code") { }
        key(Key2; Posted, Date, "Student No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }

    fieldgroups { }
}

