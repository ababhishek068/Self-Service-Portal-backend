Table 50528 "HR Employee Bank Accounts"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Employee Code"; Code[20])
        {
            Editable = false;
            TableRelation = "HR-Employee"."No.";
        }
        field(3; "Bank  Code"; Code[20])
        {
            TableRelation = "PR Bank Accounts"."Bank Code";

            trigger OnValidate()
            begin
                "Bank Name" := '';
                "Branch Code" := '';
                "Branch Name" := '';

                PRBankAccount.Reset;
                PRBankAccount.SetRange(PRBankAccount."Bank Code", "Bank  Code");
                if PRBankAccount.FindFirst() then begin
                    "Bank Name" := PRBankAccount."Bank Name";
                end;
            end;
        }
        field(4; "Bank Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Branch Code"; Code[10])
        {
            TableRelation = "PR Bank Branches"."Branch Code" where("Bank Code" = field("Bank  Code"));

            trigger OnValidate()
            begin

                PRBankBranch.Reset;
                PRBankBranch.SetRange(PRBankBranch."Bank Code", "Bank  Code");
                PRBankBranch.SetRange(PRBankBranch."Branch Code", "Branch Code");
                if PRBankBranch.FindFirst() then begin
                    "Branch Name" := PRBankBranch."Branch Name";
                end;
            end;
        }
        field(6; "Branch Name"; Text[100])
        {
            Editable = false;
        }
        field(7; "A/C  Number"; Code[30]) { }
        field(8; "Percentage to Transfer"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                HREmployeeBankAcc.reset;
                HREmployeeBankAcc.setrange(HREmployeeBankAcc."Employee Code","Employee Code");
                if HREmployeeBankAcc.findFirst() then
                begin
                    Total:=0;
                    currAmount:=HREmployeeBankAcc."Amount to Transfer (%)";
                    repeat
                        Total += HREmployeeBankAcc."Amount to Transfer (%)";
                    until HREmployeeBankAcc.next = 0;
                    if total + curramount > 100 then error('Percentage of amount to tranfer exceed 100%');
                end;
                */

            end;
        }
        field(9; "Staff Bank Name"; Text[150]) { }
        field(10; "Bank Type"; Option)
        {
            OptionMembers = Bank,Sacco;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Percentage to Transfer" := 100;
    end;

    var
        PRBankAccount: Record "PR Bank Accounts";
        PRBankBranch: Record "PR Bank Branches";
}

