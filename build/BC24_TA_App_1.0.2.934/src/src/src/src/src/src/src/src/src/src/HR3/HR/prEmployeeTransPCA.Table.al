Table 50765 "prEmployee Trans PCA"
{

    fields
    {
        field(1; "Employee Code"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Transaction Code"; Code[30])
        {
            TableRelation = "pr Transaction Codes"."Transaction Code";

            trigger OnValidate()
            begin
                objPeriod.Reset;
                objPeriod.SetRange(objPeriod.Closed, false);
                if objPeriod.Find('-') then begin
                    CurrentYr := objPeriod."Period Year";
                end;


                if Transcode.Get("Transaction Code") then begin
                    if Transcode."Transaction Code" = 'LEAVE' then begin
                        EmployeeTrans.Reset;
                        EmployeeTrans.SetRange(EmployeeTrans."Employee Code", "Employee Code");
                        EmployeeTrans.SetRange(EmployeeTrans."Transaction Code", "Transaction Code");
                        if EmployeeTrans.Find('-') then begin
                            repeat
                                if EmployeeTrans."Period Year" = CurrentYr then begin
                                    MonthName := Format(EmployeeTrans."Payroll Period", 0, '<Month Text>');
                                    //ERROR(MonthName);
                                    Error('Employee has already been paid leave allowance in the period of %1.- %2', EmployeeTrans."Payroll Period",
                                           EmployeeTrans."Employee Code");
                                end;
                            until EmployeeTrans.Next = 0;
                        end;
                    end;
                end;

                if "Transaction Code" = 'D0047' then begin
                    if PCACard.Get("Change Advice Serial No.") then begin
                        Amount := PCACard."Basic Pay" * 0.05;
                        Balance := PCACard."Basic Pay" * 0.05;
                    end;
                end;
            end;
        }
        field(3; "Transaction Name"; Text[100]) { }
        field(4; Amount; Decimal) { }
        field(5; Balance; Decimal) { }
        field(6; "Period Month"; Integer) { }
        field(7; "Period Year"; Integer) { }
        field(8; "Payroll Period"; Date)
        {
            TableRelation = "pr Payroll Periods"."Date Opened";
        }
        field(9; Comments; Text[250]) { }
        field(10; "Change Advice Serial No."; Code[50])
        {
            TableRelation = "prBasic pay PCA"."Change Advice Serial No.";
        }
        field(11; "Employer Amount"; Decimal) { }
        field(12; "Start Date"; Date) { }
        field(13; "End Date"; Date) { }
        field(39003900; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(39003901; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(39003902; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(39003903; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
    }

    keys
    {
        key(Key1; "Change Advice Serial No.", "Employee Code", "Transaction Code", "Payroll Period")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Transcode: Record "pr Transaction Codes";
        EmployeeTrans: Record "pr Employee Transactions";
        MonthName: Text[100];
        CurrentYr: Integer;
        objPeriod: Record "pr Payroll Periods";
        PCACard: Record "prBasic pay PCA";
}

