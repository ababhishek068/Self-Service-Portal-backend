page 51292 "PR Payroll Buffer List"
{

    ApplicationArea = All;
    Caption = 'PR Payroll Buffer List';
    PageType = List;
    SourceTable = "PR Payroll Buffer";
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Reports,Functions,Import Data';

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }


                field("Payroll-Num"; Rec."Payroll-Num")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll-Num field.';
                }

                field("BRS Staff No."; Rec."BRS Staff No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BRS Staff No. field.';
                }

                field("ED-Code"; Rec."ED-Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ED-Code field.';
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }

                field("Ref-Account"; Rec."Ref-Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ref-Account field.';
                }


                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }

                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
            }

        }
    }

    actions
    {
        area(Navigation)
        {


            action(UpdateTransCodeGroup)
            {
                ApplicationArea = Basic;
                Caption = 'Update Group Description';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Update Group Description action.';
                trigger OnAction()
                var
                    PRTransCodes: Record "PR Transaction Codes";

                begin
                    PRTransCodes.reset();
                    PRTransCodes.FindSet(false, false);
                    repeat
                        PRTransCodes.Validate(PRTransCodes."Group Code");
                        PRTransCodes.Modify();
                    until PRTransCodes.Next() = 0;

                    Message('Group Description Update Complete');
                end;
            }

            action(UpdateTransactionNameNEW)
            {
                ApplicationArea = Basic;
                Caption = 'Update Transaction Names 2';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Update Transaction Names 2 action.';
                trigger OnAction()
                var
                    PRTransCodes: Record "PR Transaction Codes";
                    PREmpTrans: Record "PR Employee Transactions";
                begin
                    PRTransCodes.reset();
                    PRTransCodes.FindSet(false, false);
                    repeat
                        PREmpTrans.Reset();
                        PREmpTrans.SetRange("Transaction Code", PRTransCodes."Transaction Code");
                        if PREmpTrans.FindSet(true, true) then
                            PREmpTrans.ModifyAll("Transaction Name", PRTransCodes."Transaction Name");

                    until PRTransCodes.Next() = 0;

                    Message('Transaction Name Update Complete');
                end;
            }
            action(UpdatePreviousPaymentSystem)
            {
                ApplicationArea = Basic;
                Caption = 'Update Previous Payment System';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Update Previous Payment System action.';
                trigger OnAction()
                begin
                end;
            }
            action(PRPeriodUpdate)
            {
                ApplicationArea = Basic;
                Caption = 'Update Period Closed Field';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Update Period Closed Field action.';
                trigger OnAction()
                var
                    PRPeriodTrans: Record "PR Period Transactions";
                    PRPayrollPeriod: Record "PR Payroll Periods";
                    PREmployerDeductions: Record "PR Employer Deductions";
                begin
                    PRPayrollPeriod.Reset();
                    if PRPayrollPeriod.FindSet(false, false) then begin
                        repeat
                            PRPeriodTrans.Reset();
                            PRPeriodTrans.SetRange("Payroll Period", PRPayrollPeriod."Date Opened");
                            if PRPeriodTrans.FindSet(true, false) then begin
                                PRPeriodTrans.ModifyAll("Period Closed", PRPayrollPeriod.Closed);
                            end;

                            PREmployerDeductions.Reset();
                            PREmployerDeductions.SetRange("Payroll Period", PRPayrollPeriod."Date Opened");
                            if PREmployerDeductions.FindSet(true, false) then begin
                                PREmployerDeductions.ModifyAll("Period Closed", PRPayrollPeriod.Closed);
                            end;
                        until PRPayrollPeriod.Next() = 0;
                        Message('Update period closed complete');
                    end;
                end;
            }

            action(BRSGoLive)
            {
                ApplicationArea = Basic;
                Caption = 'Get Transaction Codes and BRS Staff No.';
                Image = GetActionMessages;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Executes the Get Transaction Codes and BRS Staff No. action.';
                trigger OnAction()
                var
                    PRPayrollBuffer: Record "PR Payroll Buffer";
                    HREmployee: Record "HR-Employee";
                    PRTransCode: Record "PR Transaction Codes";
                begin
                    //Update Transaction Code to ERP Codes
                    PRTransCode.Reset();
                    if PRTransCode.FindSet(false, false) then begin
                        repeat
                            PRPayrollBuffer.Reset();
                            PRPayrollBuffer.SetRange("ED-Code", PRTransCode."IPPD Transaction Code");
                            if PRPayrollBuffer.FindSet(true, false) then begin
                                PRPayrollBuffer.ModifyAll("Transaction Code", PRTransCode."Transaction Code");
                            end;
                        until PRTransCode.next() = 0;

                        HREmployee.Reset();
                        if HREmployee.FindSet(false, false) then begin
                            repeat
                                PRPayrollBuffer.Reset();
                                PRPayrollBuffer.SetRange("Payroll-Num", HREmployee."Old Staff No.");
                                if PRPayrollBuffer.FindSet(true, false) then begin
                                    PRPayrollBuffer.ModifyAll("BRS Staff No.", HREmployee."No.");
                                end;
                            until HREmployee.next() = 0;
                            Message('Update Complete 2');
                        end;

                    end;
                end;
            }
            action(CreateBasicPay)
            {
                ApplicationArea = Basic;
                Caption = 'Create Basic Pay';
                Image = GetActionMessages;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Executes the Create Basic Pay action.';
                trigger OnAction()
                var
                    PRPayrollBuffer: Record "PR Payroll Buffer";
                    PRSalaryCard: Record "PR Salary Card";
                begin
                    PRSalaryCard.Reset();
                    PRSalaryCard.DeleteAll();

                    PRPayrollBuffer.Reset();
                    PRPayrollBuffer.SetRange("ED-Code", '801');
                    PRPayrollBuffer.SetRange("Ref-Account", '');
                    PRPayrollBuffer.SetRange("Transaction Code", '');
                    if PRPayrollBuffer.FindSet(false, false) then begin
                        repeat
                            PRSalaryCard.Init();

                            PRSalaryCard."Employee Code" := PRPayrollBuffer."BRS Staff No.";
                            PRSalaryCard."Pays NHIF" := true;
                            PRSalaryCard."Pays Pension" := true;
                            PRSalaryCard."Pays PAYE" := true;

                            PRSalaryCard."Basic Pay" := PRPayrollBuffer.Amount;
                            PRSalaryCard.Insert();
                        until PRPayrollBuffer.Next() = 0;
                        Message('Basic Pay Updated');
                    end;
                end;
            }

            action(RouteEmpTrans)
            {
                ApplicationArea = Basic;
                Caption = 'RouteEmpTrans';
                Image = GetActionMessages;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Executes the RouteEmpTrans action.';
                trigger OnAction()
                var
                    PRPayrollBuffer: Record "PR Payroll Buffer";
                    PREmployeeTrans: Record "PR Employee Transactions";
                    PRPayrollPeriod: Record "PR Payroll Periods";
                begin
                    PRPayrollPeriod.Reset();
                    PRPayrollPeriod.SetRange(Closed, false);
                    PRPayrollPeriod.FindFirst();

                    PREmployeeTrans.Reset();
                    PREmployeeTrans.DeleteAll();

                    PRPayrollBuffer.Reset();
                    PRPayrollBuffer.SetFilter("ED-Code", '<>%1', '801');
                    IF PRPayrollBuffer.FindSet(false, false) then begin
                        repeat
                            PREmployeeTrans.Init();

                            PREmployeeTrans."Employee Code" := PRPayrollBuffer."BRS Staff No.";

                            PREmployeeTrans."Transaction Code" := PRPayrollBuffer."Transaction Code";
                            PREmployeeTrans.Validate("Transaction Code");

                            PREmployeeTrans."Payroll Period" := PRPayrollPeriod."Date Opened";
                            PREmployeeTrans."Period Month" := PRPayrollPeriod."Period Month";
                            PREmployeeTrans."Period Year" := PRPayrollPeriod."Period Year";

                            PREmployeeTrans."Reference No" := PRPayrollBuffer."Ref-Account";

                            PREmployeeTrans.Amount := PRPayrollBuffer.Amount;
                            PREmployeeTrans.Balance := PRPayrollBuffer.Balance;

                            PREmployeeTrans.Insert();
                        until PRPayrollBuffer.Next() = 0;
                        Message('Insert into Employee Transactions Complete');
                    end;
                end;
            }


            action(ClearSalaryCard)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Salary Card';
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Clear Salary Card action.';



                trigger OnAction()
                var
                    PRSalaryCard: Record "PR Salary Card";

                begin
                    PRSalaryCard.Reset();
                    PRSalaryCard.DeleteAll();

                    Message('Process complete');
                end;
            }
            action(ClearEmployeeTransactions)
            {
                ApplicationArea = Basic;
                Caption = 'Clear PR Employee Transactions';
                Image = DeleteExpiredComponents;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Clear PR Employee Transactions action.';



                trigger OnAction()
                var
                    PREmpTrans: Record "PR Employee Transactions";

                begin
                    PREmpTrans.Reset();
                    PREmpTrans.DeleteAll();

                    Message('Process complete');
                end;
            }
            action(UpdateTransactionName)
            {
                ApplicationArea = Basic;
                Caption = 'Get Transaction Name';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Get Transaction Name action.';



                trigger OnAction()
                var
                    PRTransCodes: Record "PR Transaction Codes";
                    PREmpTrans: Record "PR Employee Transactions";

                begin

                    PRTransCodes.reset();
                    PRTransCodes.FindSet(false, false);
                    repeat
                        PREmpTrans.Reset();
                        PREmpTrans.SetRange("Transaction Code", PRTransCodes."Transaction Code");
                        if PREmpTrans.FindSet(true, true) then
                            PREmpTrans.ModifyAll("Transaction Name", PRTransCodes."Transaction Name");

                    until PRTransCodes.Next() = 0;

                    Message('Transaction name update complete');
                end;
            }

            action(ClearTransCodes)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Transaction Codes';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Clear Transaction Codes action.';



                trigger OnAction()
                var
                    PRTransCodes: Record "PR Transaction Codes";

                begin

                    PRTransCodes.reset();
                    PRTransCodes.DeleteAll();

                    Message('Transaction codes deleted');
                end;
            }


            action(RoutePayrollBuffer)
            {
                ToolTip = 'Executes the RoutePayrollBuffer action.';
            }
            action(AssignLeaveAllowance)
            {
                ApplicationArea = Basic;
                Caption = 'Assign Leave Allowance';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Assign Leave Allowance action.';

                trigger OnAction()
                var
                    PRSalaryCard: Record "PR Salary Card";
                    PREmpTrans: Record "PR Employee Transactions";
                    PRPayrollPeriod: Record "PR Payroll Periods";
                begin
                    PRPayrollPeriod.Reset();
                    PRPayrollPeriod.SetRange(Closed, false);
                    PRPayrollPeriod.FindFirst();

                    PRSalaryCard.Reset();
                    if PRSalaryCard.FindSet(false, false) then begin
                        repeat
                            PREmpTrans.Reset();
                            PREmpTrans.init();

                            PREmpTrans."Employee Code" := PRSalaryCard."Employee Code";
                            PREmpTrans."Transaction Code" := '799';
                            PREmpTrans.Validate("Transaction Code");

                            PREmpTrans."Payroll Period" := PRPayrollPeriod."Date Opened";
                            PREmpTrans."Period Month" := Date2DMY(PRPayrollPeriod."Date Opened", 2);
                            PREmpTrans."Period Year" := Date2DMY(PRPayrollPeriod."Date Opened", 3);
                            PREmpTrans.Amount := PRSalaryCard."Basic Pay";
                            PREmpTrans."Reference No" := '';

                            PREmpTrans.Insert();
                        until PRSalaryCard.next() = 0;
                    end;
                    Message('Leave Allowance updated successfully');
                end;
            }

            action(UpdateDateOfAppointment)
            {
                ApplicationArea = Basic;
                Caption = 'Update Date of Appointment';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Update Date of Appointment action.';

                trigger OnAction()
                var
                    HREmp: Record "HR-Employee";
                begin
                    if HREmp.FindSet(true, true) then begin
                        HREmp.ModifyAll(HREmp."Date of First Appointment", 20201001D);
                        HREmp.ModifyAll(HREmp."Date of First Appointment", 20201001D);
                        HREmp.ModifyAll("Payroll Posting Group", 'PAYROLL');
                        HREmp.ModifyAll("Main Bank", '01000');
                        HREmp.ModifyAll("Branch Bank", '1092');
                        HREmp.ModifyAll("Bank Account Number", '1234567890');
                    end;
                    Message('Date of Appointment updated successfully');
                end;
            }
            action(UpdateTransCodeWithGLAccount)
            {
                ApplicationArea = Basic;
                Caption = 'Update TransCodes with Default GL';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Update TransCodes with Default GL action.';

                trigger OnAction()
                var
                    PRTransCode: Record "PR Transaction Codes";
                begin
                    PRTransCode.Reset();
                    PRTransCode.ModifyAll("GL Account", '61405');
                    Message('Update complete');
                end;
            }

            action(RenameAction)
            {
                ApplicationArea = Basic;
                Caption = 'Rename Employee';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Rename Employee action.';

                trigger OnAction()
                var
                    HREmp: Record "HR-Employee";
                begin
                    HREmp.Reset();
                    HREmp.SetRange("No.", '1985067689'); //Failed to import with configuration package
                    if HREmp.FindFirst() then begin
                        HREmp."BRS Staff No." := 'BRS-108';
                        HREmp.Modify();
                        Commit();
                    end;

                    HREmp.Reset();
                    if HREmp.FindSet(true, true) then begin
                        repeat
                            HREmp."BRS Staff No." := HREmp."Contract Type";
                            HREmp.Modify();
                        until hremp.Next() = 0;

                        Message('Complete (');
                    end;
                end;
            }


            action(TransferOldStaffNo)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer to Old Staff No.';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Transfer to Old Staff No. action.';

                trigger OnAction()
                var
                    HREmp: Record "HR-Employee";
                begin
                    HREmp.Reset();
                    //hremp.SetRange("No.", '2011235380'); //Testing
                    if HREmp.FindSet(true, true) then begin
                        repeat
                            HREmp.TestField("BRS Staff No.");
                            HREmp.TestField("No.");

                            HREmp."Old Staff No." := HREmp."No.";

                            HREmp.Modify();
                        until HREmp.Next() = 0;
                    end;

                    Message('Transfer Complete');
                end;


            }


            action(RenameOldStaffNo)
            {
                ApplicationArea = Basic;
                Caption = 'Rename No. to BRS Staff No.';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Rename No. to BRS Staff No. action.';

                trigger OnAction()
                var
                    HREmp: Record "HR-Employee";
                begin
                    HREmp.Reset();
                    //hremp.SetRange("No.", '2011235380'); //Testing
                    if HREmp.FindSet(true, true) then begin
                        repeat
                            HREmp.TestField("BRS Staff No.");
                            HREmp.TestField("No.");
                            if HREmp.Rename(HREmp."BRS Staff No.") = false then begin
                                Error('Rename failed for staff no. %1', HREmp."No.");
                            end;

                        until HREmp.Next() = 0;

                        Message('Rename Complete');
                    end;
                end;

            }

            action(ChangeJobsToApproved)
            {
                ApplicationArea = Basic;
                Caption = 'ChangeJobsToApproved';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the ChangeJobsToApproved action.';

                trigger OnAction()
                var
                    HRJobs: Record "HR Jobs";
                begin
                    HRJobs.Reset();
                    if HRJobs.FindSet(true, false) then begin
                        repeat
                            HRJobs.Status := HRJobs.Status::Approved;
                            HRJobs.Modify();
                        until HRJobs.Next() = 0;

                        Message('Jobs update Complete');
                    end;
                end;

            }

            action(ChangeAllStaftoPermanent)
            {
                ApplicationArea = Basic;
                Caption = 'ChangeAllStaftoPermanent';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the ChangeAllStaftoPermanent action.';

                trigger OnAction()
                var
                    HREmp: Record "HR-Employee";
                begin
                    HREmp.Reset();
                    if HREmp.FindSet(true, false) then begin
                        repeat
                            HREmp."Employee Contract Type" := HREmp."Employee Contract Type"::"Permanent and Pensionable";
                            HREmp.Modify();
                        until HREmp.Next() = 0;

                        Message('Update Complete');
                    end;
                end;

            }

            action(CreateJanuaryTrans)
            {
                ApplicationArea = Basic;
                Caption = 'CreateJanuaryTrans';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the CreateJanuaryTrans action.';

                trigger OnAction()
                var
                    PREmpTrans: Record "PR Employee Transactions";
                    PREmpTransJan: Record "PR Employee Transactions";
                begin
                    PREmpTrans.SetRange("Period Month", 12);
                    PREmpTrans.SetRange("Period Year", 2020);
                    PREmpTrans.SetFilter("Transaction Code", '<>%1', '799');
                    if PREmpTrans.FindSet(false, false) then
                        repeat
                            PREmpTransJan.TransferFields(PREmpTrans);
                            PREmpTransJan."Period Month" := 01;
                            PREmpTransJan."Period Year" := 2021;
                            PREmpTransJan."Payroll Period" := 20210101D;
                            PREmpTransJan.Insert();
                        until PREmpTrans.Next() = 0;
                    Message('Complete');
                end;
            }

            action(SearchForMissingCommuterHouse)
            {
                ApplicationArea = Basic;
                Caption = 'SearchForMissingCommuterHouse';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the SearchForMissingCommuterHouse action.';

                trigger OnAction()
                var
                    HREmp: Record "HR-Employee";
                    HREmpTrans: Record "PR Employee Transactions";
                begin

                    HREmp.Reset();
                    HREmp.FindSet(false, false);
                    repeat
                        HREmpTrans.Reset();
                        HREmpTrans.SetRange("Transaction Code", '802');
                        HREmpTrans.SetRange("Employee Code", HREmp."No.");
                        HREmpTrans.SetRange("Payroll Period", 20200101D);
                        HREmpTrans.FindFirst();
                    until HREmp.next() = 0;

                    HREmp.Reset();
                    HREmp.FindSet(false, false);
                    repeat
                        HREmpTrans.Reset();
                        HREmpTrans.SetRange("Transaction Code", '813');
                        HREmpTrans.SetRange("Employee Code", HREmp."No.");
                        HREmpTrans.SetRange("Payroll Period", 20200101D);
                        HREmpTrans.FindFirst();
                    until HREmp.next() = 0;
                    Message('Search Complete');
                end;

            }

            action(UpdateTransactionCodeName)
            {
                ApplicationArea = Basic;
                Caption = 'UpdateTransactionCodeName';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the UpdateTransactionCodeName action.';

                trigger OnAction()
                begin


                    Message('Complete');
                end;
            }
        }

    }
}
