#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 52044 Locum
{
    Caption = 'Transaction List';
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = Locum;
    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin

                          "Payroll Period":=SelectedPeriod;
                          "Period Month":=PeriodMonth;
                          "Period Year":=PeriodYear;
                    end;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Hours;Hours)
                {
                    ApplicationArea = Basic;
                }
                field(Days;Days)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Processed;Processed)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Process Locum")
            {
                ApplicationArea = Basic;
                Image = CalculateBalanceAccount;
                Promoted = true;

                trigger OnAction()
                begin
                    TestField(Processed,false);
                    if Processed=false then
                    begin

                    PREmpTrans.Init;
                    PREmpTrans."Employee Code":="Employee Code";
                    PREmpTrans."Transaction Code":="Transaction Code";
                    PREmpTrans."Transaction Name":='Locum';
                    PREmpTrans."Payroll Period":="Payroll Period";
                    PREmpTrans."Period Month":="Period Month";
                    PREmpTrans."Period Year":="Period Year";
                    PREmpTrans."Reference No":='Locum'+Format("Period Month")+Format("Period Year");
                    PREmpTrans.Amount:=Amount;
                    PREmpTrans.Insert;
                    end;
                    Message('Processed successfully');
                    Processed:=true;
                    Modify;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed,false);
        if PRPayrollPeriods.Find('-') then
        begin
            SelectedPeriod:=PRPayrollPeriods."Date Opened";
            PeriodName:=PRPayrollPeriods."Period Name";
            PeriodMonth:=PRPayrollPeriods."Period Month";
            PeriodYear:=PRPayrollPeriods."Period Year";
        end else Error('No open payroll exists');

        //Filter per period
        SetFilter("Payroll Period",Format(PRPayrollPeriods."Date Opened"));
    end;

    trigger OnOpenPage()
    begin
        SetFilter("Payroll Period",Format(PRPayrollPeriods."Date Opened"));
    end;

    var
        PRTransactionCodes: Record "PR Period Transactions";
        SelectedPeriod: Date;
        PRPayrollPeriods: Record "PR Payroll Periods";
        PeriodName: Text[30];
        PeriodMonth: Integer;
        PeriodYear: Integer;
        PREmpTrans: Record "PR Employee Transactions";
}

