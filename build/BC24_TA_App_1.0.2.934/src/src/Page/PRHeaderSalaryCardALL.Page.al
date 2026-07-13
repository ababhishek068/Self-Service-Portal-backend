Page 50200 "PR Header Salary Card - ALL"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "HR-Employee";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(EmployeeDetails)
            {
                Caption = 'Employee Details';
                Editable = true;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Full Name field.';
                }

                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field("Pension No."; Rec."Pension No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the NSSF No. field.';
                }
                field(NHIFNo; Rec."NHIF No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the NHIF No. field.';
                }
                field("TIN No."; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(ContractType; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("PayrollPostingGroup"; Rec."Payroll Posting Group")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payroll Posting Group field.';
                }
                field(EmployeeType; Rec."Employee Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Type field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Cost Share?";"Cost Share?"){
                    Editable=false;
                }
                field("Cost Share Outstanding Balance";"Cost Share Outstanding Balance"){
                    Editable=false;
                }
                field("CostShare Contributions";"CostShare Contributions"){
                    Editable=false;
                }
                field("CostShare Balance";"CostShare Balance"){
                    Editable=false;
                }
                field("On Probation"; Rec."On Probation")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Probation field.';
                }
            }
            part(PaymentInfo; "PR Salary Information")
            {
                Caption = 'Payment Information';
                ShowFilter = true;
                ApplicationArea = All;
                Editable=true;
                SubPageLink = "Employee Code" = field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Transactions)
            {
                Caption = 'Employee Transactions';
                action(AssignEarningDeductions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign Earning/Deductions';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "PR Employee Transactions";
                    RunPageLink = "Employee Code" = field("No.");
                    ToolTip = 'Executes the Assign Earning/Deductions action.';
                }
                   action(overtimemanager)
                {
                    ApplicationArea = Basic;
                    Caption = 'Overtime/locum Calculator';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Overtime List";
                    RunPageLink = "Employee No."=field("No.");
                    //ToolTip = 'Executes the Assign Earning/Deductions action.';
                }
                action(TransHistory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions History';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "PR Employee Transactions Hist.";
                    RunPageLink = "Employee Code" = field("No.");
                    ToolTip = 'Executes the Transactions History action.';
                }

            }
        }
        area(processing)
        {
            action(ViewPayslip)
            {
                ApplicationArea = Basic;
                Caption = 'View Payslip';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the View Payslip action.';

                trigger OnAction()
                begin
                    PRPeriod.Reset;
                    PRPeriod.SetRange(PRPeriod.Closed, false);
                    if PRPeriod.FindFirst() then begin
                        SelectedPeriod := PRPeriod."Date Opened";
                    end else begin
                        Error('No Payroll period found');
                    end;

                    PRSalARYCard.SetRange("Employee Code", Rec."No.");
                    PRSalARYCard.SetRange(PRSalARYCard."Period Filter", SelectedPeriod);

                    Report.Run(Report::"Individual Payslips mst", true, false, PRSalARYCard);
                    //Report.Run(Report::"PR Individual Payslip", true, false, PRSalARYCard);//felix
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
                    Report.Run(Report::"PR Employee Payslip", true, false, PRPeriodTrans);
                end;
            }
        }
    }

    trigger OnInit()
    begin

        ObjPeriod.Reset;
        ObjPeriod.SetRange(ObjPeriod.Closed, false);
        if ObjPeriod.FindFirst() then begin
            SelectedPeriod := ObjPeriod."Date Opened";
            PeriodName := ObjPeriod."Period Name";
            PeriodMonth := ObjPeriod."Period Month";
            PeriodYear := ObjPeriod."Period Year";
        end;
    end;

    var
        PRPeriod: Record "PR Payroll Periods";
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodMonth: Integer;
        PeriodYear: Integer;
        ObjPeriod: Record "PR Payroll Periods";
        PRSalARYCard: Record "PR Salary Card";
}

