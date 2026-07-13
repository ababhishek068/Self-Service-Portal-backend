Page 50409 "PR Payroll Periods"
{
    PageType = List;
    SourceTable = "PR Payroll Periods";
    ApplicationArea = All;
    Editable = true;
    InsertAllowed = true;
    // DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(PeriodMonth; Rec."Period Month")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Period Month field.';
                }
                field(PeriodYear; Rec."Period Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Period Year field.';
                }
                field(PeriodName; Rec."Period Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Period Name field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';

                }
                field(DateOpened; Rec."Date Opened")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Date Opened field.';
                }
                field(OpenedBy; Rec."Opened By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Opened By field.';
                }
                field(DateClosed; Rec."Date Closed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
                field(ClosedBy; Rec."Closed By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Closed By field.';
                }
                field(AllowViewPayslip; Rec."Allow View Payslip?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow View Payslip? field.';
                }
                field(ProrationDone; Rec."Proration Done")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proration Done field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Date Approved"; Rec."Date Approved")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Approved field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ClosePeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Close Period';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Close Period action.';

                trigger OnAction()
                begin

                    /*
                    Warn user about the consequence of closure - operation is not reversible.
                    Ask if he is sure about the closure.
                    */

                    fnGetOpenPeriod;

                    Question := 'Once a period has been closed it can NOT be opened.\It is assumed that you have PAID out salaries.\'
                    + 'Do still want to close [' + strPeriodName + ']';

                    Answer := Dialog.Confirm(Question, false);
                    if Answer = true then begin
                        Clear(objOcx);
                        objOcx.fnClosePayrollPeriod(dtOpenPeriod);
                        Message('Process Complete');
                    end else begin
                        Message('You have selected NOT to Close the period');
                    end

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //HRCodeunit.fn_HRPRAccessList(USERID);
    end;

    var
        PayPeriod: Record "PR Payroll Periods";
        strPeriodName: Text[30];
        Question: Text[250];
        Answer: Boolean;
        objOcx: Codeunit "PR Payroll Processing";
        dtOpenPeriod: Date;
    // HRCodeunit: Codeunit "HR Codeunit";

    procedure fnGetOpenPeriod()
    begin

        //Get the open/current period
        PayPeriod.SetRange(PayPeriod.Closed, false);
        if PayPeriod.FindFirst() then begin
            strPeriodName := PayPeriod."Period Name";
            dtOpenPeriod := PayPeriod."Date Opened";
        end;
    end;
}

