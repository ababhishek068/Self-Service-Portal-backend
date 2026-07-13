Table 50525 "PR Transaction Codes"
{
    DrillDownPageID = "PR Transaction Codes List";
    LookupPageID = "PR Transaction Codes List";

    fields
    {
        field(1; "Transaction Code"; Code[20]) { }
        field(3; "Transaction Name"; Text[100]) { }
        field(4; "Balance Type"; Option)
        {
            OptionMembers = "None",Increasing,Reducing;
        }
        field(5; "Transaction Type"; Option)
        {
            OptionMembers = Income,Deduction,Benefit;
        }
        field(6; Frequency; Option)
        {
            OptionMembers = "Fixed",Varied;
        }
        field(7; "Is Cash"; Boolean) { }
        field(8; Taxable; Boolean)
        {

            trigger OnValidate()
            begin

                TestField("Transaction Type", "transaction type"::Income);
            end;
        }
        field(9; "Is Formula"; Boolean) { }
        field(10; Formula; Text[200]) { }
        field(16; "Amount Preference"; Option)
        {
            OptionMembers = "Posted Amount","Take Higher","Take Lower ";
        }
        field(18; "Special Trans Deductions"; Option)
        {
            OptionMembers = "None","Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan (Interest Varies)","Value of Quarters",Mortgage,"Voluntary Pension","Mortgage Relief","Sacco Loan";
        }
        field(21; "Deduct Premium"; Boolean) { }
        field(26; "Interest Rate"; Decimal) { }


        field(28; "Repayment Method"; Option)
        {
            OptionMembers = Reducing,"Straight line",Amortized;
        }
        field(29; "Fringe Benefit"; Boolean) { }
        field(30; "Employer Deduction"; Boolean) { }
        field(31; isHouseAllowance; Boolean) { }
        field(32; "Include Employer Deduction"; Boolean) { }
        field(33; "Is Formula for employer"; Text[200]) { }
        field(34; "Transaction Code old"; Code[50]) { }
        field(35; "GL Account"; Code[50])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(36; "GL Employee Account"; Code[50]) { }
        field(37; "coop parameters"; Option)
        {
            Caption = 'Other Categorization';
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,Overtime,"Voluntary Pension";
        }
        field(38; "IsCoop/LnRep"; Boolean) { }
        field(39; "Deduct Mortgage"; Boolean) { }
        field(40; Subledger; Option)
        {
            OptionMembers = " ",Customer,Vendor;
        }
        field(41; Welfare; Boolean) { }
        field(42; CustomerPostingGroup; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(210; "Previous Month Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(211; "Current Month Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(212; "Prev. Amount"; Decimal) { }
        field(213; "Curr. Amount"; Decimal) { }
        field(219; "Transaction Category"; Option)
        {
            OptionMembers = " ",Housing,Transport,"Other Allowances",NHF,Pension,"Company Loan","Housing Deduction","Personal Loan",Inconvinience,"Bonus Special","Other Deductions",Overtime,Entertainment,Leave,Utility,"Other Co-deductions","Car Loan","Call Duty","Co-op",Lunch,"Compassionate Loan";
        }
        field(220; "Employee Code"; Code[50])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR-Employee"."No.";
        }
        field(221; Suspended; Boolean) { }
        field(222; "Include in Net"; Boolean) { }
        field(223; "Taxable Percentage"; Decimal) { }
        field(224; "No. Series"; Code[20]) { }
        field(225; "Is Formula Per Directorate"; Boolean) { }
        field(226; "Special Trans Incomes"; Option)
        {
            OptionMembers = "None","Salary Arrears","Leave Allowance","Transfer Allowance";
        }
        field(227; "G/L Account Name"; Text[150])
        {
            CalcFormula = lookup("G/L Account".Name where("No." = field("GL Account")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(228; "Group Code"; Code[20])
        {
            TableRelation = "PR Trans Codes Groups";

            trigger OnValidate()
            begin
                "Group Description" := '';

                PRTransCodesGroups.Reset;
                if PRTransCodesGroups.Get("Group Code") then begin
                    "Group Description" := UpperCase(PRTransCodesGroups."Group Description");
                end;
            end;
        }
        field(229; "Group Description"; Text[100])
        {
            Editable = false;
        }

        field(230; "Mandatory"; Boolean)
        {
            Editable = true;
        }
        field(39003932; "Group Order"; Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12";
        }
        field(39003936; "Disable Proration"; Boolean) { }

        field(39003937; "Skip Transfer in Next Period"; Boolean) { }

        field(39003938; "IPPD Transaction Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(39003939; "Transaction Charge Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            tablerelation = "PR Third Party Charges".Code;
        }
        field(50014; "Imprest Surrender"; Boolean) { }
        field(50015; "Intrest Transaction Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PR Transaction Codes"."Transaction Code";
        }
        field(50016; "Formula %"; Decimal)
        {
            DecimalPlaces = 3;
        }
        field(50017; "Is Leave Allowance"; Boolean) { }
        field(50018; "Transportallowancecalculation"; Boolean) {

            trigger OnValidate()
            var
            transcodes: Record "PR Transaction Codes";
            checknumber: Integer;
            begin
                checknumber:=0;
                transcodes.Reset();
                transcodes.SetRange(transcodes.Transportallowancecalculation,true);
                if transcodes.Find('-') then begin
                    repeat
                    checknumber:=checknumber+1;

                    until transcodes.Next=0;
                    if checknumber>1 then
                    Error('You cannot have 2 accounts for statutory transport/fuel allowance calculation');
                end;


            end;
         }
    }

    keys
    {
        key(Key1; "Transaction Code")
        {
            Clustered = true;
        }
        key(Key2; "Transaction Name") { }
        key(Key3; "Transaction Type") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Transaction Code", "Transaction Name") { }
    }

    trigger OnDelete()
    begin
        //Disable Deletion if Used
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", "Transaction Code");
        if PRPeriodTrans.FindFirst() then begin
            Error('Cannot delete Transaction Code because it was posted in [ %1 - %2 ]', PRPeriodTrans."Payroll Period", PRPeriodTrans."Employee Code");
        end;

        PREmpTrans.Reset;
        PREmpTrans.SetRange(PREmpTrans."Transaction Code", "Transaction Code");
        if PREmpTrans.FindFirst() then begin
            Error('Cannot delete Transaction Code because it was assigned to [ %1 - %2 ]', PREmpTrans."Employee Code", PREmpTrans."Payroll Period");
        end;
    end;

    trigger OnInsert()
    begin

        if "Transaction Type" = "transaction type"::Deduction then begin
            if "Transaction Code" = '' then begin
                HRSetup.Get;
                HRSetup.TestField(HRSetup."PR Deduction Nos.");
                "Transaction Code":=NoSeriesMgt.GetNextNo(HRSetup."PR Deduction Nos.",  0D, true);
            end;
        end;

        if "Transaction Type" = "transaction type"::Income then begin
            if "Transaction Code" = '' then begin
                HRSetup.Get;
                HRSetup.TestField(HRSetup."PR Allowance Nos.");
                "Transaction Code":=NoSeriesMgt.GetNextNo(HRSetup."PR Allowance Nos.",  0D, true);
            end;
        end;
    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        PRPeriodTrans: Record "PR Period Transactions";
        PREmpTrans: Record "PR Employee Transactions";
        PRTransCodesGroups: Record "PR Trans Codes Groups";
}

