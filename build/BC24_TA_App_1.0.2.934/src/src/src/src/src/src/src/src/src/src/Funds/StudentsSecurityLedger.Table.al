Table 50750 "Students Security Ledger"
{

    fields
    {
        field(1; No; Code[20]) { }
        field(2; "Student No"; Code[20])
        {
            TableRelation = Customer."No." where("Customer Type" = const(Student));

            trigger OnValidate()
            begin
                if Cust.Get("Student No") then
                    Name := Cust.Name;
            end;
        }
        field(3; Name; Text[50]) { }
        field(4; Date; Date) { }
        field(5; "Entry Type"; Option)
        {
            OptionCaption = ' ,Entry,Exit';
            OptionMembers = " ",Entry,"Exit";
        }
        field(6; Remarks; Text[100]) { }
        field(7; "No. Series"; Code[20]) { }
        field(8; Posted; Boolean) { }
        field(9; "Posted By"; Code[50]) { }
        field(10; "Curr Time"; Time) { }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        //IF No = '' THEN BEGIN
        SecSetup.Get;
        SecSetup.TestField(SecSetup."Visitors Nos");
        No:=NoSeriesMgt.GetNextNo(SecSetup."Visitors Nos",  0D,true);
        //  END;
        Date := Today;
    end;

    var
        Cust: Record Customer;
        SecSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
}

