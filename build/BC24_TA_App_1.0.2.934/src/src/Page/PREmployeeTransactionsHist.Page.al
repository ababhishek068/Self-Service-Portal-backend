Page 50179 "PR Employee Transactions Hist."
{
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "PR Employee Transactions";
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(EmployeeCode; Rec."Employee Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }
                field(TransactionCode; Rec."Transaction Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Code field.';

                    trigger OnValidate()
                    begin
                        Rec."Payroll Period" := SelectedPeriod;
                        Rec."Period Month" := PeriodMonth;
                        Rec."Period Year" := PeriodYear;

                        curTransAmount := 0;
                    end;
                }
                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field(PayrollPeriod; Rec."Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(Installments; Rec."Total Installments")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Installments field.';
                }

                field("Loan Application Date"; Rec."Loan Application Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Loan Application Date field.';
                }
                field("Amount Borrowed"; Rec."Amount Borrowed")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Initial Loan Amount field.';
                }

                field(ReferenceNo; Rec."Reference No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reference No field.';
                }

                field("Has Insurance Certificate"; Rec."Has Insurance Certificate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Has Insurance Certificate field.';
                }

                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }

                field(StopforNextPeriod; Rec."Stop for Next Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stop for Next Period field.';
                }

                field("coop parameters"; Rec."coop parameters")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Other Categorization field.';
                }
            }
        }
    }


    actions
    {
        area(processing)
        {

            action(AssignEarningDeductions)
            {
                ApplicationArea = Basic;
                Caption = 'Repayment Schedule List';
                Image = AssessFinanceCharges;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Loan Repayment Schedule";
                RunPageLink = "Employee No" = field("Employee Code"), "Loan No" = field("Transaction Code");
                ToolTip = 'Executes the Repayment Schedule List action.';
            }

            action(LoanSheduleREport)
            {
                ApplicationArea = Basic;
                Caption = 'Preview Loan Shedule';
                Image = AssessFinanceCharges;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Preview Loan Shedule action.';
                trigger OnAction()
                var
                    LoanRepaymentShcedule: Record "Loan Repayment Schedule";
                begin
                    LoanRepaymentShcedule.Reset();
                    LoanRepaymentShcedule.SetRange("Employee No", Rec."Employee Code");
                    LoanRepaymentShcedule.SetRange("Loan No", Rec."Transaction Code");
                    if LoanRepaymentShcedule.FindFirst() then begin
                        report.Run(report::"Loan Repayment Schedule - DSL ", true, false);
                    end;
                end;
            }
        }


    }

    trigger OnInit()
    begin
        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed, false);
        if PRPayrollPeriods.FindFirst() then begin
            SelectedPeriod := PRPayrollPeriods."Date Opened";
            PeriodName := PRPayrollPeriods."Period Name";
            PeriodMonth := PRPayrollPeriods."Period Month";
            PeriodYear := PRPayrollPeriods."Period Year";
            //objEmpTrans.RESET;
            //objEmpTrans.SETRANGE("Payroll Period",SelectedPeriod);
        end;

        //Filter per period  - Dennis
        Rec.SetFilter("Payroll Period", Format(PRPayrollPeriods."Date Opened"));
        //PRPayrollPeriods.SETFILTER(PRPayrollPeriods.Closed,'FALSE');
    end;

    trigger OnOpenPage()
    begin
        // SetFilter("Payroll Period", Format(PRPayrollPeriods."Date Opened"));
    end;

    var
        SelectedPeriod: Date;
        PRPayrollPeriods: Record "PR Payroll Periods";
        PeriodName: Text[30];
        PeriodMonth: Integer;
        PeriodYear: Integer;
        curTransAmount: Decimal;

}

