Table 50763 "prBasic pay PCA"
{
    DrillDownPageId = "prPCA list";
    LookupPageId = "prPCA list";
    fields
    {
        field(1; "Employee Code"; Code[50])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.", "Employee Code");
                if objEmp.Find('-') then begin
                    "Employee Name" := objEmp."First Name" + ' ' + objEmp."Middle Name" + ' ' + objEmp."Last Name";

                    if objEmp.Status <> objEmp.Status::Active then Error('This employee is not an ACTIVE employee contact HR');


                    objSalCard.Reset;
                    objSalCard.SetRange(objSalCard."Employee Code", objEmp."No.");
                    if objSalCard.Find('-') then begin
                        "Basic Pay" := objSalCard."Basic Pay";
                        "Pays Pension" := objSalCard."Pays Pension";
                        "Pays NHIF" := objSalCard."Pays NHIF";
                        "Pays PAYE" := objSalCard."Pays PAYE";


                        /*-------------
                          //----Insert from employee transactions----------------------------------------------
                          objPayrollPeriod.RESET;
                          objPayrollPeriod.SETRANGE(objPayrollPeriod.Closed,FALSE);
                          IF objPayrollPeriod.FIND('-') THEN BEGIN
                            empTransPCA.RESET;
                            empTransPCA.SETRANGE(empTransPCA."Change Advice Serial No.","Change Advice Serial No.");
                            IF empTransPCA.FIND('-') THEN empTransPCA.DELETEALL;

                           empTrans.RESET;
                           empTrans.SETRANGE(empTrans."Employee Code",objEmp."No.");
                           empTrans.SETRANGE(empTrans."Payroll Period",objPayrollPeriod."Date Opened");
                           IF empTrans.FIND('-') THEN REPEAT
                            empTransPCA.INIT;
                            empTransPCA."Change Advice Serial No.":="Change Advice Serial No.";
                            empTransPCA."Employee Code":=empTrans."Employee Code";
                            empTransPCA."Transaction Code":=empTrans."Transaction Code";
                            empTransPCA."Payroll Period":=empTrans."Payroll Period";
                            empTransPCA."Transaction Name":=empTrans."Transaction Name";
                            empTransPCA.Amount:=empTrans.Amount;
                            empTransPCA.Balance:=empTrans.Balance;
                            empTransPCA.INSERT;
                           UNTIL empTrans.NEXT=0;
                          //-----------------------------------------------------------------------------------
                          END;
                        ------------------*/

                    end;
                end;

            end;
        }
        field(2; "Employee Name"; Text[100]) { }
        field(3; "Basic Pay"; Decimal) { }
        field(4; Comments; Text[200]) { }
        field(5; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
        field(6; "Period Month"; Integer) { }
        field(7; "Period Year"; Integer) { }
        field(8; "Payroll Period"; Date)
        {
            TableRelation = "pr Payroll Periods"."Date Opened" where(Closed = const(false));
        }
        field(9; "Change Advice Serial No."; Code[50])
        {

            trigger OnValidate()
            begin
                if "Change Advice Serial No." <> xRec."Change Advice Serial No." then begin
                    HrSetup.Get;
                    NoSeriesMgt.TestManual(HrSetup."Pay-change No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(10; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(11; Effected; Boolean) { }
        field(20; "Currency Code"; Code[10]) { }
        field(21; "User ID"; Code[50]) { }
        field(22; "Pays Pension"; Boolean) { }
        field(23; "Pays NHIF"; Boolean) { }
        field(24; "Pays PAYE"; Boolean) { }
        field(25; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(26; PAyrollCode; Code[50])
        {
            TableRelation = "PR Employee Posting Groups";
        }
        field(27; "Campus Code"; Code[50])
        {
            CalcFormula = lookup("HR-Employee".Campus where("No." = field("Employee Code")));
            FieldClass = FlowField;
        }
        field(28; "Department Code"; Code[50])
        {
            CalcFormula = lookup("HR-Employee"."Department Code" where("No." = field("Employee Code")));
            FieldClass = FlowField;
        }

        field(31; Multipay; Boolean) { }
        field(32; "Transfer/Appointment No"; Code[50]) { }
        field(33; "Campus Name"; Text[250])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Campus Code")));
            FieldClass = FlowField;
        }
        field(34; "Department Name"; Text[250])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Department Code")));
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(Key1; "Change Advice Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Change Advice Serial No." = '' then begin
            HrSetup.Get;
            // HrSetup.TestField("Pay-change No.");
            "Change Advice Serial No.":=NoSeriesMgt.GetNextNo(HrSetup."Pay-change No.",  0D, true);
        end;
        "User ID" := UserId;

        Usetup.Reset;
        Usetup.SetRange(Usetup."User ID", UserId);
        if Usetup.Find('-') then begin
            // PAyrollCode:=Usetup."Payroll Code";
        end else
            Error('Please contact your admin to be setup to raise PCAs');

        fnCheckEmployeeStatus;
    end;

    var
        HrSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        objEmp: Record "HR-Employee";
        objSalCard: Record "pr Salary Card";
        Usetup: Record "User Setup";

    procedure fnCheckEmployeeStatus()
    var
        objEmp: Record "HR-Employee";
    begin
        objEmp.Reset;
        objEmp.SetRange(objEmp."No.", "Employee Code");
        objEmp.SetFilter(objEmp.Status, '<>%1', objEmp.Status::InActive);
        if objEmp.Find('-') then begin
            Error('You cannot raise a PCA for someone who is not Active');
            "Employee Code" := '';
            Modify;
        end;
    end;
}

