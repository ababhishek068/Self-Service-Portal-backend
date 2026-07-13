Report 50022 "Payment Cheque"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PaymentCheque.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Payment Schedule"; "Payment Schedule")
        {
            RequestFilterFields = No;
            column(ReportForNavId_1; 1) { }
            column(No_PaymentSchedule; "Payment Schedule".No) { }
            column(Date_PaymentSchedule; "Payment Schedule".Date) { }
            column(PayingBankNo_PaymentSchedule; "Payment Schedule"."Paying Bank No") { }
            column(TotalAmount_PaymentSchedule; "Payment Schedule"."Total Amount") { }
            column(Payee_PaymentSchedule; "Payment Schedule".Payee) { }
            column(ChequeNo_PaymentSchedule; "Payment Schedule"."Cheque No") { }
            column(ChequeDate_PaymentSchedule; "Payment Schedule"."Cheque Date") { }
            column(Status_PaymentSchedule; "Payment Schedule".Status) { }
            column(Posted_PaymentSchedule; "Payment Schedule".Posted) { }
            column(PostedBy_PaymentSchedule; "Payment Schedule"."Posted By") { }
            column(PostingDated_PaymentSchedule; "Payment Schedule"."Posting Dated") { }
            column(NoSeries_PaymentSchedule; "Payment Schedule"."No. Series") { }
            column(ChequeFormat_PaymentSchedule; "Payment Schedule"."Cheque Format") { }
            column(NumberText_1_; NumberText[1]) { }

            trigger OnAfterGetRecord()
            begin
                NumberText1[1] := '';

                NumberText1[2] := '';

                "Payment Schedule".CalcFields("Total Amount");
                //felix
                //
                //CheckReport.FormatNoText(NumberText, ("Payment Schedule"."Total Amount"), '');

                //NumberText1[1] := DELSTR(NumberText[1],45);

                //NumberText1[2] := DELSTR(NumberText[1],1,44);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        NumberText: array[2] of Text[80];
        NumberText1: array[2] of Text[80];
}

