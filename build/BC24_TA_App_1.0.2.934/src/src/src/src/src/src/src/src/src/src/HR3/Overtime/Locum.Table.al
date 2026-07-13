#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 52522 Locum
{
    DataCaptionFields = "Employee Code";

    fields
    {
        field(1;"Employee Code";Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2;"Transaction Code";Code[30])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where ("Transaction Code"=filter('E008'));

            trigger OnValidate()
            var
                ErrAssignedTrans: label 'Transaction Code [ %1 ] has already been assigned to Staff No. [ %2 ] Payroll Period [ %3 ]';
            begin
                PRTransCode.Reset;
                PRTransCode.SetRange(PRTransCode."Transaction Code","Transaction Code");
                if PRTransCode.Find('-') then
                begin
                    "Transaction Name":=PRTransCode."Transaction Name";
                  end;
            end;
        }
        field(3;"Transaction Name";Text[100])
        {
        }
        field(4;Amount;Decimal)
        {
        }
        field(5;Balance;Decimal)
        {
        }
        field(6;"Original Amount";Decimal)
        {
        }
        field(7;"Period Month";Integer)
        {
        }
        field(8;"Period Year";Integer)
        {
        }
        field(9;"Payroll Period";Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(10;Days;Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                    PRSalCard.Reset;
                    PRSalCard.SetRange(PRSalCard."Employee Code","Employee Code");
                    if PRSalCard.Find('-') then
                    begin
                        Amount:=(PRSalCard."Basic Pay")*(1.25*Days);
                      Amount:=Amount/30.5;
                      end;
            end;
        }
        field(11;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12;Hours;Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Days:=(Hours/8);
                //
                PRSalCard.Reset;
                    PRSalCard.SetRange(PRSalCard."Employee Code","Employee Code");
                    if PRSalCard.Find('-') then
                    begin
                        Amount:=(PRSalCard."Basic Pay")*(1.25*Days);
                      Amount:=ROUND(Amount/30.5,1,'=');
                      end;
            end;
        }
        field(13;"Employee Name";Text[250])
        {
            CalcFormula = lookup("HR-Employee"."Full Name" where ("No."=field("Employee Code")));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1;"Employee Code","Transaction Code","Period Month","Period Year","Payroll Period")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }
    var
        PRTransCode: Record "PR Period Transactions";
        PREmpTrans: Record "PR Employee Transactions";
        PRSalCard: Record "PR Salary Card";
        HRSetup: Record "HR Applicant Employment";
}

