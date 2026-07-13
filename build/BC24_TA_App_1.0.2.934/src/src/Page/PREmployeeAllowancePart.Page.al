Page 50399 "PR Employee Allowance Part"
{
    PageType = ListPart;
    //PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "PR Employee Transactions";
    Editable = false;
    SourceTableView = where("Transaction Type" = filter(Income));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {


                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }

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
        Rec.SetFilter("Payroll Period", Format(PRPayrollPeriods."Date Opened"));
    end;

    var
        SelectedPeriod: Date;
        PRPayrollPeriods: Record "PR Payroll Periods";
        PeriodName: Text[30];
        PeriodMonth: Integer;
        PeriodYear: Integer;

}

