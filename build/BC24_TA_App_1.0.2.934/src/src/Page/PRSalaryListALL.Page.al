Page 50202 "PR Salary List (ALL)"
{
    CardPageID = "PR Header Salary Card - ALL";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    Editable = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "HR-Employee";
    SourceTableView = where(Status = filter(Active));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Process Advance"; "Process Advance") { }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTextExp;
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field("Old Staff No."; Rec."Old Staff No.")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Old Staff No. field.';

                }
                field(FullName; Rec."Full Name")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTextExp;
                    ToolTip = 'Specifies the value of the Full Name field.';
                }

                field(Grade; Rec.Grade)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Grade field.';
                }

                // field("Date of First Appointment"; "Date of First Appointment")
                // {
                //     ApplicationArea = ALL;
                // }
                field("Salary Incremental Month"; Rec."Salary Incremental Month")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Salary Incremental Month field.';
                }
                field("From IPPD"; Rec."From IPPD")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the From IPPD field.';
                }


                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(PostingGroup; Rec."Payroll Posting Group")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTextExp;
                    ToolTip = 'Specifies the value of the Payroll Posting Group field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTextExp;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }

    }

    actions
    {
        area(navigation)
        {
            group(Transactions)
            {
                action(AssignEarningDeductions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign Earning/Deductions';
                    Image = AssessFinanceCharges;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "PR Employee Transactions";
                    RunPageLink = "Employee Code" = field("No.");
                    ToolTip = 'Executes the Assign Earning/Deductions action.';
                }
                action(UpdateStaffAdvance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Salary Advance';
                    Image = AssessFinanceCharges;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Report "Update Salary Advance";
                    ToolTip = 'Executes the Update Salary Advance action.';

                }
            }
        }
        area(processing)
        {
            action(ViewPayslip)
            {
                ApplicationArea = Basic;
                Caption = 'View Payslip';
                Image = Report;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the View Payslip action.';

                trigger OnAction()
                var
                    PRSalaryCard: Record "PR Salary Card";
                begin
                    PRPeriod.Reset;
                    PRPeriod.SetRange(PRPeriod.Closed, false);
                    if PRPeriod.FindFirst() then begin
                        SelectedPeriod := PRPeriod."Date Opened";
                    end else begin
                        Error('No Payroll period found');
                    end;

                    //Display payslip report
                    PRSalaryCard.SetRange("Employee Code", Rec."No.");
                    PRSalaryCard.SetRange(PRSalaryCard."Period Filter", SelectedPeriod);
                    Report.Run(Report::"PR Individual Payslip - NEW", true, false, PRSalaryCard);


                    // //Display payslip report
                    // PRPeriodTrans.SetRange("Employee Code", "No.");
                    // PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", SelectedPeriod);
                    // Report.Run(Report::"PR Employee Payslip", true, false, PRPeriodTrans);
                end;
            }
            action(PREmployeePayslip)
            {
                Caption = 'PR Employee Payslip';
                Image = Accounts;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Executes the PR Employee Payslip action.';
                trigger OnAction()
                var
                    PRPeriodTrans: Record "PR Period Transactions";
                begin
                    PRPeriod.Reset;
                    PRPeriod.SetRange(PRPeriod.Closed, false);
                    if PRPeriod.FindFirst() then begin
                        SelectedPeriod := PRPeriod."Date Opened";
                    end else begin
                        Error('No Payroll period found');
                    end;

                    PRPeriodTrans.Reset();
                    PRPeriodTrans.SetRange("Employee Code", Rec."No.");
                    PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", SelectedPeriod);
                    Report.Run(Report::"Individual Payslips mst", true, false, PRPeriodTrans);
                end;
            }
            action(ProcessPayroll)
            {
                ApplicationArea = Basic;
                Caption = 'Process Payroll';
                Image = PayrollStatistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Process Payroll action.';
                trigger OnAction()
                var
                    checkforsuspension: Record "PR Salary Card";
                    calculatelist: Integer;
                    advancelist: Record "Staff Advance Header";

                begin
                    PRPeriod.Reset;
                    PRPeriod.SetRange(PRPeriod.Closed, false);
                    if PRPeriod.FindFirst() then begin
                        SelectedPeriod := PRPeriod."Date Opened";
                        calculatelist := 0;
                        advancelist.Reset();
                        advancelist.SetRange(advancelist."Payroll Period", SelectedPeriod);
                        advancelist.SetRange(advancelist.Status, advancelist.Status::Approved);
                        advancelist.SetRange(advancelist."Send to payroll", true);
                        advancelist.SetRange(advancelist."Payroll processed", false);
                        advancelist.SetRange(advancelist.Posted, false);
                        advancelist.SetRange("Advance Closed", false);
                        if advancelist.Find('-') then begin
                            repeat
                                calculatelist := calculatelist + 1;

                            until advancelist.next = 0;
                        end;
                        if calculatelist < 1 then begin
                            //Error('There is no advance request to process');
                        end else begin
                            error('There are ' + Format(calculatelist) + ' advance request to process.' + ' Process or close advance first');
                        end;
                    end else begin
                        Error('No Payroll period found');
                    end;

                    //Mark Employee as in In Active if Curr Period Opened is > than Date of Separtion
                    //fn_AutoDeactivateStaff;

                    //Ensure all the Transaction Codes marked as Mandatory have been assigned to All Employees

                    fn_EnsureMandatoryTransCodesAssignedToAllStaff(SelectedPeriod);

                    ProcessPayroll.fnClearCurrentPeriod(SelectedPeriod, SelectedPeriod, '');
                    if PRSalaryCard.Get(Rec."No.") then begin
                        if PRSalaryCard."Suspend Pay" = false then
                        
                        fnupdatearrears(Rec."No.", SelectedPeriod);
                        fnupdateacting(Rec."No.", SelectedPeriod);
                        fnupdatemedical(Rec."No.", SelectedPeriod);


                        Clear("HR-Employee");

                        "HR-Employee".reset;
                        "HR-Employee".setrange(Status, Rec.Status::Active);
                        if "HR-Employee".Find('-') then begin
                            ProgressWindow.Open('Processing Salary #1#################################################################');
                            repeat
                                "HR-Employee".TestField("HR-Employee"."Payroll Posting Group");
                                fngetsocialscheme(Rec."No.", SelectedPeriod);

                                ProgressWindow.Update(1, "HR-Employee"."No." + ':' + "HR-Employee"."Full Name");
                                if PRSalaryCard.Get("HR-Employee"."No.") then begin
                                    if PRSalaryCard."Suspend Pay" = false then begin
                                        ProcessPayroll.fnProcesspayroll("HR-Employee"."No.", "HR-Employee"."Date of First Appointment"
                                        , PRSalaryCard."Basic Pay", PRSalaryCard."Pays PAYE", PRSalaryCard."Pays pension", PRSalaryCard."Pays NHIF"
                                        , SelectedPeriod, SelectedPeriod, '', '', "HR-Employee"."Date Of Leaving the Company", true,
                                        "HR-Employee"."Global Dimension 2 Code", PRSalaryCard."Insurance Certificate?", "HR-Employee"."Cost Share?", "HR-Employee"."Process Advance", "HR-Employee"."Loan Guarantee?", "HR-Employee"."Arrears Days", "HR-Employee"."Acting job Expiry Date", "HR-Employee"."Acting job Start Date", "HR-Employee"."Joined Social Club?", "HR-Employee"."Date of Joining Social Club", "HR-Employee"."Left social Club?");

                                    end;

                                end else begin
                                    //ERROR('Employee not found in PR Salary Card table, please capture Basic PY information');
                                end;
                            until "HR-Employee".Next = 0;
                            ProgressWindow.Close;
                        end;



                        //CODEUNIT
                        Commit();
                        if Confirm('Processing complete. Run the Company Payslip Report for %1', true, PRPeriod."Period Name") = true then
                            Report.Run(Report::prPeriodTran, true, false);
                        //Report.Run(Report::"PR Company Payslip Summary", true, false);
                    end;
                end;
            }
            action(ProcessCurrent)
            {
                ApplicationArea = Basic;
                Caption = 'Process Current';
                Image = Period;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Process Current action.';

                trigger OnAction()
                var
                    advancelist: Record "Staff Advance Header";
                    calculatelist: Integer;

                begin

                    PRPeriod.Reset;
                    PRPeriod.SetRange(PRPeriod.Closed, false);
                    if PRPeriod.FindFirst() then begin
                        SelectedPeriod := PRPeriod."Date Opened";
                        calculatelist := 0;
                        advancelist.Reset();
                        advancelist.SetRange(advancelist."Payroll Period", SelectedPeriod);
                        advancelist.SetRange(advancelist.Status, advancelist.Status::Approved);
                        advancelist.SetRange(advancelist."Send to payroll", true);
                        advancelist.SetRange(advancelist."Payroll processed", false);
                        advancelist.SetRange(advancelist.Posted, false);
                        advancelist.SetRange("Advance Closed", false);
                        if advancelist.Find('-') then begin
                            repeat
                                calculatelist := calculatelist + 1;

                            until advancelist.next = 0;
                        end;
                        if calculatelist < 1 then begin
                            //Error('There is no advance request to process');
                        end else begin
                            error('There are ' + Format(calculatelist) + ' advance request to process.' + ' Process or close advance first');
                        end;
                    end else begin
                        Error('No Payroll period found');
                    end;

                    //Mark Employee as in In Active if Curr Period Opened is > than Date of Separtion
                    //fn_AutoDeactivateStaff;
                    //Mark Employee as in InActive if Curr Period Opened is > than Date of Separtion

                    if PRSalaryCard.Get(Rec."No.") then begin
                        if PRSalaryCard."Suspend Pay" = false then
                            
                        fnupdatearrears(Rec."No.", SelectedPeriod);
                        fnupdateacting(Rec."No.", SelectedPeriod);
                        fnupdatemedical(Rec."No.", SelectedPeriod);

                        Clear("HR-Employee");
                        ProcessPayroll.fnClearCurrentPeriod(SelectedPeriod, SelectedPeriod, Rec."No.");
                        "HR-Employee".SetRange("HR-Employee".Status, "HR-Employee".Status::Active);
                        "HR-Employee".SetRange("HR-Employee"."No.", Rec."No.");
                        if "HR-Employee".FindFirst() then begin
                            fngetsocialscheme("HR-Employee"."No.", SelectedPeriod);
                            Sleep(20);
                            ProgressWindow.Open('Processing Salary #1############################################');
                            repeat

                                "Cost Share?" := "HR-Employee"."Cost Share?";
                                ProgressWindow.Update(1, "HR-Employee"."No." + ':' + "HR-Employee"."Full Name");
                                if PRSalaryCard.Get("HR-Employee"."No.") then begin
                                    if PRSalaryCard."Suspend Pay" = false then begin
                                        ProcessPayroll.fnProcesspayroll("HR-Employee"."No.", "HR-Employee"."Date Of Joining the Company"
                                        , PRSalaryCard."Basic Pay", PRSalaryCard."Pays PAYE", PRSalaryCard."Pays pension", PRSalaryCard."Pays NHIF"
                                        , SelectedPeriod, SelectedPeriod, '', '', "HR-Employee"."Date Of Leaving the Company", true,
                                        "HR-Employee"."Global Dimension 1 Code", PRSalaryCard."Insurance Certificate?", "HR-Employee"."Cost Share?", "HR-Employee"."Process Advance", "HR-Employee"."Loan Guarantee?", "HR-Employee"."Arrears Days", "HR-Employee"."Acting job Expiry Date", "HR-Employee"."Acting job Start Date", "HR-Employee"."Joined Social Club?", "HR-Employee"."Date of Joining Social Club", "HR-Employee"."Left social Club?");
                                    end else begin
                                        Error("HR-Employee"."No." + ' ' + 'Is suspsended from pay');
                                    end;
                                end else begin
                                    //ERROR('Employee not found in PR Salary Card table, please capture Basic PY information');
                                end;

                            until "HR-Employee".Next = 0;
                            ProgressWindow.Close;
                        end;

                        Commit();
                        PRSalaryCard.SetRange("Employee Code", Rec."No.");
                        PRSalaryCard.SetRange(PRSalaryCard."Period Filter", SelectedPeriod);
                        Report.Run(50161, true, false, PRSalaryCard);

                    end;
                end;
            }
            action(ProcessCurrent2)
            {
                ApplicationArea = Basic;
                Caption = 'Process Current Group';
                Image = Period;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Process Current Group action.';

                trigger OnAction()
                var
                    EmpRec: Record "HR-Employee";
                    advancelist: Record "Staff Advance Header";
                    calculatelist: Integer;
                begin

                    PRPeriod.Reset;
                    PRPeriod.SetRange(PRPeriod.Closed, false);
                    if PRPeriod.FindFirst() then begin
                        SelectedPeriod := PRPeriod."Date Opened";
                        calculatelist := 0;
                        advancelist.Reset();
                        advancelist.SetRange(advancelist."Payroll Period", SelectedPeriod);
                        advancelist.SetRange(advancelist.Status, advancelist.Status::Approved);
                        advancelist.SetRange(advancelist."Send to payroll", true);
                        advancelist.SetRange(advancelist."Payroll processed", false);
                        advancelist.SetRange(advancelist.Posted, false);
                        advancelist.SetRange("Advance Closed", false);
                        if advancelist.Find('-') then begin
                            repeat
                                calculatelist := calculatelist + 1;

                            until advancelist.next = 0;
                        end;
                        if calculatelist < 1 then begin
                            //Error('There is no advance request to process');
                        end else begin
                            error('There are ' + Format(calculatelist) + ' advance request to process.' + ' Process or close advance first');
                        end;

                    end else begin
                        Error('No Payroll period found');
                    end;

                    //Mark Employee as in In Active if Curr Period Opened is > than Date of Separtion
                    //fn_AutoDeactivateStaff;
                    //Mark Employee as in InActive if Curr Period Opened is > than Date of Separtion

                    if PRSalaryCard.Get(Rec."No.") then begin
                        if PRSalaryCard."Suspend Pay" = false then
                            Clear("HR-Employee");
                        
                        fnupdatearrears(Rec."No.", SelectedPeriod);
                        fnupdateacting(Rec."No.", SelectedPeriod);
                        fnupdatemedical(Rec."No.", SelectedPeriod);
                        EmpRec.get(Rec."No.");

                        "HR-Employee".SetRange("HR-Employee".Status, "HR-Employee".Status::Active);
                        "HR-Employee".SetRange("HR-Employee"."Payroll Posting Group", EmpRec."Payroll Posting Group");
                        if "HR-Employee".FindFirst() then begin
                            fngetsocialscheme(Rec."No.", SelectedPeriod);
                            ProgressWindow.Open('Processing ' + EmpRec."Payroll Posting Group" + ' Salary #1############################################');
                            repeat
                                ProcessPayroll.fnClearCurrentPeriod(SelectedPeriod, SelectedPeriod, "HR-Employee"."No.");
                                ProgressWindow.Update(1, "HR-Employee"."No." + ':' + "HR-Employee"."Full Name");
                                if PRSalaryCard.Get("HR-Employee"."No.") then begin
                                    if PRSalaryCard."Suspend Pay" = false then begin
                                        ProcessPayroll.fnProcesspayroll("HR-Employee"."No.", "HR-Employee"."Date of First Appointment"
                                        , PRSalaryCard."Basic Pay", PRSalaryCard."Pays PAYE", PRSalaryCard."Pays pension", false
                                        , SelectedPeriod, SelectedPeriod, '', '', "HR-Employee"."Date Of Leaving the Company", true,
                                        "HR-Employee"."Global Dimension 1 Code", PRSalaryCard."Insurance Certificate?", "HR-Employee"."Cost Share?", "HR-Employee"."Process Advance", "HR-Employee"."Loan Guarantee?", "HR-Employee"."Arrears Days", "HR-Employee"."Acting job Expiry Date", "HR-Employee"."Acting job Start Date", "HR-Employee"."Joined Social Club?", "HR-Employee"."Date of Joining Social Club", "HR-Employee"."Left social Club?");
                                    end;
                                end else begin
                                    //ERROR('Employee not found in PR Salary Card table, please capture Basic PY information');
                                end;

                            until "HR-Employee".Next = 0;
                            ProgressWindow.Close;
                        end;

                        Commit();
                        PRSalaryCard.SetRange("Employee Code", Rec."No.");
                        PRSalaryCard.SetRange(PRSalaryCard."Period Filter", SelectedPeriod);
                        Report.Run(Report::"PR Individual Payslip - NEW", true, false, PRSalaryCard);

                    end;
                end;
            }
            action(ProcessCurrent3)
            {
                ApplicationArea = Basic;
                Caption = 'Process Salary Advance';
                Image = Period;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Process Advance List action.';

                trigger OnAction()
                var
                    EmpRec: Record "HR-Employee";
                    advancelist: Record "Staff Advance Header";
                    calculatelist: Integer;
                begin

                    PRPeriod.Reset;
                    PRPeriod.SetRange(PRPeriod.Closed, false);
                    if PRPeriod.FindFirst() then begin
                        SelectedPeriod := PRPeriod."Date Opened";
                        calculatelist := 0;
                        advancelist.Reset();
                        advancelist.SetRange(advancelist."Payroll Period", SelectedPeriod);
                        advancelist.SetRange(advancelist.Status, advancelist.Status::Approved);
                        advancelist.SetRange(advancelist."Send to payroll", true);
                        advancelist.SetRange(advancelist."Payroll processed", false);
                        advancelist.SetRange(advancelist.Posted, false);
                        advancelist.SetRange("Advance Closed", false);
                        if advancelist.Find('-') then begin
                            repeat
                                calculatelist := calculatelist + 1;

                            until advancelist.next = 0;
                        end;
                        if calculatelist < 1 then begin
                            Error('There is no advance request to process');
                        end else begin
                            Message('There are ' + Format(calculatelist) + ' advance request to process');
                        end;

                    end else begin
                        Error('No Payroll period found');
                    end;

                    //Mark Employee as in In Active if Curr Period Opened is > than Date of Separtion
                    //fn_AutoDeactivateStaff;
                    //Mark Employee as in InActive if Curr Period Opened is > than Date of Separtion

                    if PRSalaryCard.Get(Rec."No.") then begin
                        if PRSalaryCard."Suspend Pay" = false then
                            Clear("HR-Employee");
                        EmpRec.get(Rec."No.");
                        
                        fnupdatearrears(Rec."No.", SelectedPeriod);
                        fnupdateacting(Rec."No.", SelectedPeriod);
                        fnupdatemedical(Rec."No.", SelectedPeriod);

                        "HR-Employee".SetRange("HR-Employee".Status, "HR-Employee".Status::Active);
                        "HR-Employee".SetRange("HR-Employee"."Process Advance", true);
                        if "HR-Employee".FindFirst() then begin
                            fngetsocialscheme(Rec."No.", SelectedPeriod);
                            //Error('here');
                            ProgressWindow.Open('Processing ' + EmpRec."Payroll Posting Group" + ' Salary #1############################################');
                            repeat
                                //ProcessPayroll.fnClearCurrentPeriod(SelectedPeriod, SelectedPeriod, "HR-Employee"."No.");
                                ProgressWindow.Update(1, "HR-Employee"."No." + ':' + "HR-Employee"."Full Name");
                                if PRSalaryCard.Get("HR-Employee"."No.") then begin
                                    if PRSalaryCard."Suspend Pay" = false then begin
                                        ProcessPayroll.fnProcesspayroll("HR-Employee"."No.", "HR-Employee"."Date of First Appointment"
                                        , PRSalaryCard."Basic Pay", PRSalaryCard."Pays PAYE", PRSalaryCard."Pays pension", false
                                        , SelectedPeriod, SelectedPeriod, '', '', "HR-Employee"."Date Of Leaving the Company", true,
                                        "HR-Employee"."Global Dimension 1 Code", PRSalaryCard."Insurance Certificate?", "HR-Employee"."Cost Share?", "HR-Employee"."Process Advance", "HR-Employee"."Loan Guarantee?", "HR-Employee"."Arrears Days", "HR-Employee"."Acting job Expiry Date", "HR-Employee"."Acting job Start Date", "HR-Employee"."Joined Social Club?", "HR-Employee"."Date of Joining Social Club", "HR-Employee"."Left social Club?");
                                    end;
                                end else begin
                                    //ERROR('Employee not found in PR Salary Card table, please capture Basic PY information');
                                end;

                            until "HR-Employee".Next = 0;
                            ProgressWindow.Close;
                        end;

                        Commit();
                        PRSalaryCard.SetRange("Employee Code", Rec."No.");
                        PRSalaryCard.SetRange(PRSalaryCard."Period Filter", SelectedPeriod);
                        Report.Run(Report::"PR Individual Payslip - NEW", true, false, PRSalaryCard);

                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if Format(Rec.Status) = 'Active' then StyleTextExp := 'None' else StyleTextExp := 'Attention';
    end;


    var
        PRSalaryCard: Record "PR Salary Card";
        PRPeriod: Record "PR Payroll Periods";
        SelectedPeriod: Date;
        ProcessPayroll: Codeunit "PR Payroll Processing";
        "HR-Employee": Record "HR-Employee";
        ProgressWindow: Dialog;
        HREmp: Record "HR-Employee";
        StyleTextExp: Text;
        HRChangeLog: Record "HR Change Entries";

    procedure fnLastLineNo() LastLineNo: Integer
    var
        HRChangeLog_2: Record "HR Change Entries";
    begin
        HRChangeLog_2.Reset;
        if HRChangeLog_2.FindLast then begin
            LastLineNo := HRChangeLog_2."Line No";
        end else begin
            LastLineNo := 1;
        end;
    end;

    local procedure fngetsocialscheme(empno: code[20]; currpayrollperiod: date)
    var
        prSalaryArrears: Record "PR Employee Transactions";
        hremps: Record "HR-Employee";
        premptrans: record "PR Employee Transactions";
        prtrans: record "PR Period Transactions";
        previousperiod: date;
        vitalsetup: Record "PR Vital Setup Info";
        found: Boolean;
    begin
        
        vitalsetup.Get();
        vitalsetup.TestField("Social ContributioCode");
        vitalsetup.TestField("Social Cont Registation Amount");
        vitalsetup.TestField("Social Contriution Perc");

        hremps.Reset();
        hremps.SetRange(hremps."No.", empno);
        hremps.SetRange(hremps.Status, hremps.Status::Active);
        hremps.SetRange(hremps."Joined Social Club?", true);
        hremps.SetRange(hremps."Left social Club?", false);
        hremps.SetRange(hremps."Paid social Club", false);
        if hremps.FindFirst() then begin
            //Message(empno);
            if hremps."Date of Joining Social Club" = 0D then begin
                Error(empno + ' does no have the date of joining scheme defined, contact HR');
            end else begin
                prtrans.Reset();
                prtrans.SetRange(prtrans."Transaction Code", vitalsetup."Social ContributioCode");
                prtrans.SetRange(prtrans."Employee Code", empno);
                //prtrans.SetRange(prtrans.);
                if prtrans.FindFirst() then begin

                end else if not prtrans.Find() then begin
                    //delete first
                    premptrans.reset;
                    premptrans.SetRange("Employee Code",empno);
                    premptrans.SetRange(premptrans."Transaction Code",vitalsetup."Social ContributioCode");
                    premptrans.SetRange(premptrans."Payroll Period",currpayrollperiod);
                    if premptrans.FindFirst() then begin
                        premptrans.Delete;
                    end;
                    Sleep(20);
                    //then insert
                    premptrans.Init;
                    premptrans."Employee Code" := empno;
                    premptrans."Transaction Code" := vitalsetup."Social ContributioCode";
                    premptrans.Validate("Transaction Code");
                    premptrans."Payroll Period" := currpayrollperiod;
                    premptrans."Period Month" := Date2DMY(currpayrollperiod, 2);
                    premptrans."Period Year" := Date2DMY(currpayrollperiod, 3);
                    premptrans.Amount := vitalsetup."Social Cont Registation Amount";
                    premptrans.Insert;
                end;

            end;
        end;

    end;

    local procedure fnupdatearrears(empcode: code[20]; currpayrollperiod: date)
    var
        prSalaryArrears: Record "PR Employee Transactions";
        hremps: Record "HR-Employee";
        premptrans: record "PR Employee Transactions";
        prtrans: record "PR Period Transactions";
        previousperiod: date;
        vitalsetup: Record "PR Vital Setup Info";
        found: Boolean;
    begin
        vitalsetup.Get();
        previousperiod := CalcDate('<-1M>', currpayrollperiod);
        found := false;
        //Error(format(previousperiod));
        hremps.Reset();
        hremps.SetRange(hremps."No.", empcode);
        hremps.SetRange(hremps.Status, hremps.Status::Active);
        if hremps.FindFirst() then begin
            hremps."Arrears Days" := 0;
            hremps."Acting Arrears Days" := 0;
            hremps.Modify();
            Sleep(10);
            prtrans.Reset();
            prtrans.SetRange(prtrans."Employee Code", empcode);
            prtrans.SetRange(prtrans."Payroll Period", previousperiod);
            if prtrans.FindFirst() then begin

            end else if not prtrans.Find() then begin
                if (hremps."Date Of Joining the Company" > previousperiod) and (hremps."Date Of Joining the Company" < currpayrollperiod) then begin
                    hremps."Arrears Days" := currpayrollperiod - hremps."Date Of Joining the Company";
                    hremps.Modify();
                end;

            end;
            if hremps."Acting Position?" = true then begin
                prtrans.Reset();
                prtrans.SetRange(prtrans."Payroll Period", previousperiod);
                prtrans.SetRange(prtrans."Employee Code", empcode);
                if prtrans.Find('-') then begin
                    repeat
                        if (prtrans."Transaction Code" = vitalsetup."Acting Allowance") or (prtrans."Transaction Code" = vitalsetup."Acting Allowance nontax") then begin
                            found := true;
                        end;
                    until prtrans.next = 0;
                    if found = false then begin
                        if (hremps."Acting job Start Date" > previousperiod) and (hremps."Acting job Start Date" < currpayrollperiod) then begin
                            hremps."Acting Arrears Days" := currpayrollperiod - hremps."Acting job Start Date";
                            hremps.Modify();
                        end;

                    end
                end else if not prtrans.Find() then begin
                    if (hremps."Acting job Start Date" > previousperiod) and (hremps."Acting job Start Date" < currpayrollperiod) then begin

                        hremps."Acting Arrears Days" := currpayrollperiod - hremps."Acting job Start Date";
                        hremps.Modify();
                    end;

                end;


            end;

        end;



    end;

    local procedure fnupdatemedical(empcode: Code[20]; CurrPayrollPeriod: Date)
    var
        vitalset: record "PR Vital Setup Info";
        salgrades: Record "Sal Grades";
        emptransactions: record "PR Employee Transactions";
        hremps: Record "HR-Employee";
        salcard: record "PR Salary Card";
        branches: Record Branches;
        prperiods: record "PR Payroll Periods";
        claimlines: Record "Medical Claim Lines";
        claimheader: Record "Medical Claims Header";
        payrollm: Integer;
        payrolly: Integer;
    begin
        vitalset.Get();
        vitalset.TestField("Claims Code");
        prperiods.Reset();
        prperiods.SetRange(prperiods."Date Opened", CurrPayrollPeriod);
        if prperiods.FindFirst() then begin
            payrollm := prperiods."Period Month";
            payrolly := prperiods."Period Year";
        end;
        claimheader.Reset();
        claimheader.SetRange(claimheader."Payroll Period", CurrPayrollPeriod);
        claimheader.SetRange(claimheader.Status, claimheader.Status::approved);
        if claimheader.FindFirst() then begin
            claimlines.Reset();
            claimlines.SetRange(claimlines."Claim No", claimheader."Claim No");
            claimlines.SetRange(claimlines."Vendor No", claimheader."Vendor No");
            if claimlines.FindFirst() then begin
                claimlines.CalcFields("Amount paid");
                claimlines.Validate("Amount paid");
                if claimlines.Balance > 0 then begin
                    emptransactions.Reset();
                    emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Claims Code");
                    emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                    emptransactions.SetRange(emptransactions."Period Month", payrollm);
                    emptransactions.SetRange(emptransactions."Period Year", payrolly);
                    emptransactions.SetRange(emptransactions."Employee Code", empcode);
                    if emptransactions.FindFirst() then begin
                        emptransactions.Amount := claimlines.Balance;
                        emptransactions.Validate("Transaction Code");
                        emptransactions.Modify();

                    end else if not emptransactions.Find() then begin
                        emptransactions.Init();
                        emptransactions."Transaction Code" := vitalset."Claims Code";
                        emptransactions.Validate("Transaction Code");
                        emptransactions."Employee Code" := empcode;
                        emptransactions."Payroll Period" := CurrPayrollPeriod;
                        emptransactions."Period Month" := payrollm;
                        emptransactions."Period Year" := payrolly;
                        emptransactions.Amount := claimlines.Balance;
                        emptransactions.Validate(Amount);
                        emptransactions.Insert();

                    end;

                end;

            end;
        end;

    end;

    local procedure fnupdateacting(empcode: Code[20]; CurrPayrollPeriod: Date)
    var
        vitalset: record "PR Vital Setup Info";
        salgrades: Record "Sal Grades";
        emptransactions: record "PR Employee Transactions";
        hremps: Record "HR-Employee";
        salcard: record "PR Salary Card";
        branches: Record Branches;
        prperiods: record "PR Payroll Periods";
        payrollcodeunit: Codeunit "PR Payroll Processing";
        DaysofthemonthP: Integer;
        worksinbranch: Boolean;
        samejobgrade: Boolean;
        taxablebranch: Boolean;
        prmonth: Integer;
        pryear: Integer;
        bpay: Decimal;
        bpay_a: Decimal;
        hall: Decimal;
        hall_a: Decimal;
        moball: Decimal;
        moball_a: Decimal;
        represent: Decimal;
        represent_a: Decimal;
        previousmonth: Date;
        daycountmonthP: Integer;
    begin

        prperiods.Reset();
        prperiods.SetRange(prperiods."Date Opened", CurrPayrollPeriod);
        prperiods.SetRange(prperiods.Closed, false);
        if prperiods.FindFirst() then begin
            prmonth := prperiods."Period Month";
            pryear := prperiods."Period Year";
            previousmonth := CalcDate('-1M', CurrPayrollPeriod);
            DaysofthemonthP := payrollcodeunit.fnDaysInMonth(previousmonth);
        end else if not prperiods.Find() then begin

            Error('There is no current open payroll period');
        end;
        vitalset.Get();
        vitalset.TestField("Acting Allowance");
        vitalset.TestField("Acting Allowance nontax");
        vitalset.TestField("House all code");
        vitalset.TestField("House all code nontax");
        vitalset.TestField("Hardship all code");
        vitalset.TestField("Hardship all code nontax");
        vitalset.TestField("Mobi all code");
        vitalset.TestField("Mobi all code Nontax");
        vitalset.TestField("Position all code");
        vitalset.TestField("Position all code nontax");
        vitalset.TestField("Acting Representation all code");
        vitalset.TestField("Acting Representation all nontax");
        worksinbranch := false;
        samejobgrade := false;
        taxablebranch := true;
        hall := 0;
        moball := 0;
        represent := 0;
        bpay := 0;
        bpay_a := 0;
        hall_a := 0;
        moball_a := 0;
        represent_a := 0;
        moball_a := 0;
        salgrades.Reset();
        salgrades.SetRange(salgrades."Job Group", hremps."Job Group");
        salgrades.SetRange(salgrades."Salary Grade", hremps.Grade);
        if salgrades.FindFirst() then begin
            bpay_a := salgrades.Basic_salary;
            hall_a := salgrades."House Allowance";
            represent_a := salgrades."Position Allowance";
            moball_a := salgrades."Transport Allowance";
        end;

        salgrades.Reset();
        salgrades.SetRange(salgrades."Job Group", hremps."Acting Job ID");
        salgrades.SetRange(salgrades."Salary Grade", hremps."Acting Job Grade");
        if salgrades.FindFirst() then begin
            bpay := salgrades.Basic_salary;
            hall := salgrades."House Allowance";
            represent := salgrades."Position Allowance";
            moball := salgrades."Transport Allowance";
        end;
        hremps.Reset();
        hremps.SetRange(hremps."No.", empcode);
        hremps.SetRange(hremps.status, hremps.Status::Active);
        if hremps.FindFirst() then begin

            if hremps."Job Group" = hremps."Acting Job ID" then begin
                samejobgrade := true;
            end;
            if hremps."Acting job Expiry Date" <> 0D then begin
                hremps.Validate("Acting job Expiry Date");

                Sleep(20);
                branches.Reset();
                branches.SetRange(branches."Division/Branch Code", hremps."Global Dimension 3 Code");
                branches.SetRange(branches.level, branches.level::Branch);
                if branches.FindFirst() then begin
                    worksinbranch := true;
                    if branches.Taxed = true then
                        taxablebranch := false;
                end;

                //if they work in same job grade                
                if samejobgrade = true then begin
                    if hremps."No of acting Days" > 15 then begin

                        //give only acting allowance-assume taxable
                        hremps.CalcFields("Basic Pay");
                        hremps.TestField("Basic Pay");
                        emptransactions.Reset();
                        emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Allowance");
                        emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                        emptransactions.SetRange(emptransactions."Employee Code", empcode);
                        emptransactions.SetRange(emptransactions."Period Month", prmonth);
                        emptransactions.SetRange(emptransactions."Period Year", pryear);
                        if emptransactions.FindFirst() then begin
                            emptransactions.Amount := (10 / 100) * hremps."Basic Pay";
                            if hremps."Acting Arrears Days" <> 0 then begin
                                emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                            end;
                            emptransactions.Validate(Amount);
                            emptransactions.Modify();

                        end else if not emptransactions.Find() then begin
                            emptransactions.init;
                            emptransactions."Employee Code" := empcode;
                            emptransactions."Transaction Code" := vitalset."Acting Allowance";
                            emptransactions.Validate("Transaction Code");
                            emptransactions.Amount := (10 / 100) * hremps."Basic Pay";
                            if hremps."Acting Arrears Days" <> 0 then begin
                                emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                            end;
                            emptransactions."Period Month" := prmonth;
                            emptransactions."Period Year" := pryear;
                            emptransactions."Payroll Period" := CurrPayrollPeriod;
                            emptransactions.Insert;

                        end;

                    end;

                end else if samejobgrade = false then begin
                    //if not same job grade then what
                    salgrades.Reset();
                    salgrades.SetRange(salgrades."Job Group", hremps."Acting Job ID");
                    salgrades.SetRange(salgrades."Salary Grade", hremps."Acting Job Grade");
                    if salgrades.FindFirst() then begin
                        bpay := salgrades.Basic_salary;
                        hall := salgrades."House Allowance";
                        represent := salgrades."Position Allowance";
                        moball := salgrades."Transport Allowance";
                    end;
                    //1.if taxable branch
                    if (taxablebranch = true) and (worksinbranch = true) then begin
                        //if has worked more than or 3 months
                        if hremps."No of acting Days" <= 90 then begin
                            emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Allowance");
                            if emptransactions.FindFirst() then begin
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.5;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Allowance";
                                emptransactions.Validate("Transaction Code");
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.5;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;
                            if represent <> 0 then
                                emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Representation all code");
                            if emptransactions.FindFirst() then begin
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;

                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Representation all code";
                                emptransactions.Validate("Transaction Code");
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;

                        end else if (hremps."No of acting Days" >= 90) and (hremps."No of acting Days" <= 180) then begin
                            emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Allowance");
                            if emptransactions.FindFirst() then begin
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.75;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Allowance";
                                emptransactions.Validate("Transaction Code");
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.75;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;
                            if represent <> 0 then
                                emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Representation all code");
                            if emptransactions.FindFirst() then begin
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Representation all code";
                                emptransactions.Validate("Transaction Code");
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;

                        end;


                    end else if (taxablebranch = false) and (worksinbranch = true) then begin
                        //2.if non-taxable branch
                        if hremps."No of acting Days" <= 90 then begin
                            emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Allowance nontax");
                            if emptransactions.FindFirst() then begin
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.5;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Allowance nontax";
                                emptransactions.Validate("Transaction Code");
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.5;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;
                            if represent <> 0 then
                                emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Representation all nontax");
                            if emptransactions.FindFirst() then begin
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Representation all nontax";
                                emptransactions.Validate("Transaction Code");
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;

                        end else if (hremps."No of acting Days" >= 90) and (hremps."No of acting Days" <= 180) then begin
                            emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Allowance nontax");
                            if emptransactions.FindFirst() then begin
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.75;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Allowance nontax";
                                emptransactions.Validate("Transaction Code");
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.75;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;
                            if represent <> 0 then
                                emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Representation all nontax");
                            if emptransactions.FindFirst() then begin
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Representation all nontax";
                                emptransactions.Validate("Transaction Code");
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;

                        end;



                    end else if (taxablebranch = false) and (worksinbranch = false) then begin
                        //3.if does not work in branch
                        if hremps."No of acting Days" <= 90 then begin
                            emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Allowance");
                            if emptransactions.FindFirst() then begin
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.5;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Allowance";
                                emptransactions.Validate("Transaction Code");
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.5;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;
                            if represent <> 0 then
                                emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Representation all code");
                            if emptransactions.FindFirst() then begin
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Representation all code";
                                emptransactions.Validate("Transaction Code");
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;

                        end else if (hremps."No of acting Days" >= 90) and (hremps."No of acting Days" <= 180) then begin
                            emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Allowance");
                            if emptransactions.FindFirst() then begin
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.75;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Allowance";
                                emptransactions.Validate("Transaction Code");
                                emptransactions.Amount := (bpay - hremps."Basic Pay") * 0.75;
                                if emptransactions.Amount = 0 then begin
                                    emptransactions.Amount := hremps."Basic Pay" * 0.1;
                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;
                            if represent <> 0 then
                                emptransactions.Reset();
                            emptransactions.SetRange(emptransactions."Employee Code", empcode);
                            emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                            emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Acting Representation all code");
                            if emptransactions.FindFirst() then begin
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions.Modify();

                            end else if not emptransactions.Find() then begin
                                emptransactions.Init();
                                emptransactions."Employee Code" := empcode;
                                emptransactions."Transaction Code" := vitalset."Acting Representation all code";
                                emptransactions.Validate("Transaction Code");
                                if represent_a < represent then begin
                                    emptransactions.Amount := represent_a - represent;
                                end else begin
                                    emptransactions.Amount := represent;

                                end;
                                if hremps."Acting Arrears Days" <> 0 then begin
                                    emptransactions.Amount := emptransactions.Amount + (hremps."Acting Arrears Days" / DaysofthemonthP) * emptransactions.Amount;
                                end;
                                emptransactions."Payroll Period" := CurrPayrollPeriod;
                                emptransactions."Period Year" := pryear;
                                emptransactions."Period Month" := prmonth;
                                emptransactions.Insert;

                            end;

                        end;

                    end;


                end;


            end;


        end;
    end;


    local procedure fn_EnsureMandatoryTransCodesAssignedToAllStaff(CurrPayrollPeriod: Date)
    var
        PRTransCode_4: Record "PR Transaction Codes";
        PREmpTrans_4: Record "PR Employee Transactions";
        HREmp_4: Record "HR-Employee";
    begin
        PRTransCode_4.Reset();
        PRTransCode_4.SetRange(Mandatory, true);
        if PRTransCode_4.FindSet(false, false) then begin
            repeat
                HREmp_4.Reset();
                HREmp_4.SetRange(Status, Rec.Status::Active);
                if HREmp_4.FindSet(false, false) then begin
                    repeat
                        PREmpTrans_4.SetRange("Payroll Period", CurrPayrollPeriod);
                        PREmpTrans_4.SetRange("Employee Code", HREmp_4."No.");
                        PREmpTrans_4.SetRange("Transaction Code", PRTransCode_4."Transaction Code");
                        if not PREmpTrans_4.FindFirst() then begin
                            Error('[ %1 ] has not been assigned to [ %2 ] during payroll period [ %3 ]',
                                 PRTransCode_4."Transaction Name", HREmp_4."Full Name", CurrPayrollPeriod);
                        end ELSE begin
                            PREmpTrans_4.TestField(Amount);
                        end;
                    until HREmp_4.Next() = 0;
                end;

            until PRTransCode_4.Next() = 0;
        end;
    end;

    local procedure fn_AutoDeactivateStaff()
    var
        curr_MonthDate_Leaving: Integer;
        curr_YearDate_Leaving: Integer;
        curr_PayPeriod_Month: Integer;
        curr_PayPeriod_Year: Integer;
    begin
        //Mark Employee as in In Active if Curr Period Opened is > than Date of Separtion
        Clear(HREmp);
        HREmp.SetFilter(HREmp."Date Of Leaving the Company", '<>%1', 0D);

        HREmp.SetRange(HREmp.Status, HREmp.Status::Active);
        if HREmp.FindFirst() then begin
            repeat
                //Don't Disable an Employee if he is exiting in the same Month and Same Year as the current Payroll Period
                curr_MonthDate_Leaving := Date2dmy(HREmp."Date Of Leaving the Company", 2);
                curr_YearDate_Leaving := Date2dmy(HREmp."Date Of Leaving the Company", 3);

                curr_PayPeriod_Month := Date2dmy(PRPeriod."Date Opened", 2);
                curr_PayPeriod_Year := Date2dmy(PRPeriod."Date Opened", 3);

                //1. Check if the year is the same
                if curr_PayPeriod_Year = curr_YearDate_Leaving then begin
                    //Check if Month of Leaving is Same as Current Period Month and Period Year
                    if curr_MonthDate_Leaving = curr_PayPeriod_Month then begin
                        //We dont remove him
                    end else begin
                        if HREmp."Date Of Leaving the Company" < PRPeriod."Date Opened" then begin
                            HREmp.Status := HREmp.Status::InActive;
                            HREmp.Modify;

                            HRChangeLog.Init;

                            /*  HRChangeLog."Line No." := fnLastLineNo + 10;
                             HRChangeLog."Date Modified" := HREmp."Date Of Leaving the Company";
                             HRChangeLog."Modified by" := 'AUTO SYSTEM CHANGE';
                             HRChangeLog."No." := HREmp."No.";
                             HRChangeLog."Old Value" := '';
                             HRChangeLog."New Value" := Format(HREmp."Date Of Leaving the Company");
                             HRChangeLog."Field Changed" := 'Date Of Leaving the Company';
                             HRChangeLog."Payroll Period" := SelectedPeriod; */

                            HRChangeLog.Insert;
                        end;
                    end;
                end else begin
                    if HREmp."Date Of Leaving the Company" < PRPeriod."Date Opened" then begin
                        HREmp.Status := HREmp.Status::InActive;
                        HREmp.Modify;

                        HRChangeLog.Init;

                        HRChangeLog."Line No" := fnLastLineNo + 10;
                        HRChangeLog."Change Date" := HREmp."Date Of Leaving the Company";
                        HRChangeLog.UserID := 'AUTO SYSTEM CHANGE';
                        HRChangeLog."employee No" := HREmp."No.";
                        HRChangeLog."Old Value" := '';
                        HRChangeLog."New Value" := Format(HREmp."Date Of Leaving the Company");
                        //HRChangeLog."Reason for Change":=HREMP."Termination Grounds";
                        HRChangeLog."Change Description" := 'Date Of Leaving the Company';
                        // HRChangeLog.p := SelectedPeriod;

                        HRChangeLog.Insert;
                    end;
                end;
            until HREmp.Next = 0;

        end;
        //Mark Employee as in InActive if Curr Period Opened is > than Date of Separtion
    end;

    trigger OnOpenPage()
    var
        PRPayrollRights: Record "PR Payroll Access Rights";
    begin
        PRPayrollRights.Reset();
        PRPayrollRights.SetRange("User ID", UserId());
        if PRPayrollRights.IsEmpty() then begin
            Error('You are not authorized to access this page. Please contact HR department');
        end;
    end;
}

