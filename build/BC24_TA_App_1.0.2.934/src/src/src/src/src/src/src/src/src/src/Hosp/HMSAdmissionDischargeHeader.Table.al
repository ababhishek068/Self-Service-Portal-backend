Table 50605 "HMS Admission Discharge Header"
{
    //  LookupPageID = "WF Society List";

    fields
    {
        field(1; "Admission No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Patient No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Patient"."Patient No.";
        }
        field(3; "Discharge Date"; Date) { }
        field(4; "Discharge Time"; Time) { }
        field(5; "Doctor ID"; Code[20])
        {
            TableRelation = "HMS Setup Doctor"."Doctor ID";
        }
        field(6; "Nurse ID"; Code[20]) { }
        field(7; Remarks; Text[200]) { }
        field(8; Status; Option)
        {
            OptionMembers = New,Completed;
        }
        field(9; "Ward No."; Code[20]) { }
        field(10; "Bed No."; Code[20]) { }
        field(11; "Date of Admission"; Date) { }
        field(12; "Time Of Admission"; Time) { }
        field(27; Surname; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Surname where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(28; "Middle Name"; Text[30])
        {
            CalcFormula = lookup("HMS Patient"."Middle Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(29; "Last Name"; Text[50])
        {
            CalcFormula = lookup("HMS Patient"."Last Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(30; "ID Number"; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."ID Number" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(31; "Correspondence Address 1"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Correspondence Address 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(32; "Telephone No. 1"; Code[100])
        {
            CalcFormula = lookup("HMS Patient"."Telephone No. 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(33; Email; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Email where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(34; "Patient Ref. No."; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Patient Ref. No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(35; "Doctor Notes"; Text[200]) { }
        field(36; "Nurse Notes"; Text[200]) { }
        field(37; Invoiced; Boolean) { }
        field(38; "Discharged By"; Code[20]) { }
        field(39; "Discharge Type"; Option)
        {
            OptionCaption = ' ,Normal,Transfered,Deceased';
            OptionMembers = " ",Normal,Transfered,Deceased;
        }
        field(40; "Patient Type"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Corporate,Cash';
            OptionMembers = " ",Corporate,Cash;
        }
        field(41; "Bill Balance"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Patient No." = field("Patient No."),
                                                                          Closed = const(false)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Admission No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /*Insert the processes to the database*/
        Process.Reset;
        if Process.Find('-') then begin
            repeat
                Line.Init;
                Line."Admission No." := "Admission No.";
                Line."Process Code" := Process.Code;
                Line.Insert();
            until Process.Next = 0;
        end;

    end;

    var
        Process: Record "HMS Setup Discharge Processes";
        Line: Record "HMS Admission Discharge Line";
}

