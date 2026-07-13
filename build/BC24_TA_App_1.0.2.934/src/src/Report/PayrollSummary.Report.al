Report 50280 "Payroll Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PayrollSummary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            RequestFilterFields = "Payroll Posting Group", "Employee Types", "Employee Contract Type";
            column(ReportForNavId_1; 1) { }
            column(PrintBy; 'PRINTED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................') { }
            column(CheckedBy; 'CHECKED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................') { }
            column(VerifiedBy; 'VERIFIED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................') { }
            column(ApprovedBy; 'APPROVED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................') { }
            column(BasicPayLbl; 'BASIC PAY') { }
            column(payelbl; 'PAYE.') { }
            column(Pensionlbl; 'Pension') { }
            column(nhiflbl; 'NHIF') { }
            column(Netpaylbl; 'Net Pay') { }
            column(payeamount; payeamount) { }
            column(Pensionam; Pensionam) { }
            column(nhifamt; nhifamt) { }
            column(NetPay; NetPay) { }
            column(pic; info.Picture) { }
            column(BasicPay; BasicPay) { }
            column(GrossPay; GrossPay) { }
            column(periods; 'PAYROLL SUMMARY for ' + Format(periods, 0, 4)) { }
            column(empName; "First Name" + ' ' + "Middle Name" + ' ' + "Last Name") { }
            column(No_; "No.") { }

            column(Salary_Grade; "Salary Grade") { }
            column(Global_Dimension_2_Name; "Global Dimension 2 Name") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Job_Title; "Job Title") { }
            column(Employee_Contract_Type; "Employee Contract Type") { }
            column(Employee_Types; "Employee Types") { }
            column(NHIFRelief; NHIFRelief) { }
            column(InsuranceRelief; InsuranceRelief) { }
            column(TaxablePay; TaxablePay) { }
            column(TransName_1_1; TransName[1, 1]) { }
            column(TransName_1_2; TransName[1, 2]) { }
            column(TransName_1_3; TransName[1, 3]) { }
            column(TransName_1_4; TransName[1, 4]) { }
            column(TransName_1_5; TransName[1, 5]) { }
            column(TransName_1_6; TransName[1, 6]) { }
            column(TransName_1_7; TransName[1, 7]) { }
            column(TransName_1_8; TransName[1, 8]) { }
            column(TransName_1_9; TransName[1, 9]) { }
            column(TransName_1_10; TransName[1, 10]) { }
            column(TransName_1_11; TransName[1, 11]) { }
            column(TransName_1_12; TransName[1, 12]) { }
            column(TransName_1_13; TransName[1, 13]) { }
            column(TransName_1_14; TransName[1, 14]) { }
            column(TransName_1_15; TransName[1, 15]) { }
            column(TransName_1_16; TransName[1, 16]) { }
            column(TransName_1_17; TransName[1, 17]) { }
            column(TransName_1_18; TransName[1, 18]) { }
            column(TransName_1_19; TransName[1, 19]) { }
            column(TransName_1_20; TransName[1, 20]) { }
            column(TransName_1_21; TransName[1, 21]) { }
            column(TransName_1_22; TransName[1, 22]) { }
            column(TransName_1_23; TransName[1, 23]) { }
            column(TransName_1_24; TransName[1, 24]) { }
            column(TransName_1_25; TransName[1, 25]) { }
            column(TransName_1_26; TransName[1, 26]) { }
            column(TransName_1_27; TransName[1, 27]) { }
            column(TransName_1_28; TransName[1, 28]) { }
            column(TransName_1_29; TransName[1, 29]) { }
            column(TransName_1_30; TransName[1, 30]) { }
            column(TransName_1_31; TransName[1, 31]) { }
            column(TransName_1_32; TransName[1, 32]) { }
            column(TransName_1_33; TransName[1, 33]) { }
            column(TransName_1_34; TransName[1, 34]) { }
            column(TransName_1_35; TransName[1, 35]) { }
            column(TransName_1_36; TransName[1, 36]) { }
            column(TransName_1_37; TransName[1, 37]) { }
            column(TransName_1_38; TransName[1, 38]) { }
            column(TransName_1_39; TransName[1, 39]) { }
            column(TransName_1_40; TransName[1, 40]) { }
            column(TransName_1_41; TransName[1, 41]) { }
            column(TransName_1_42; TransName[1, 42]) { }
            column(TransName_1_43; TransName[1, 43]) { }
            column(TransName_1_44; TransName[1, 44]) { }
            column(TransName_1_45; TransName[1, 45]) { }
            column(TransName_1_46; TransName[1, 46]) { }
            column(TransName_1_47; TransName[1, 47]) { }
            column(TransName_1_48; TransName[1, 48]) { }
            column(TransName_1_49; TransName[1, 49]) { }
            column(TransName_1_50; TransName[1, 50]) { }
            column(TransName_1_51; TransName[1, 51]) { }
            column(TransName_1_52; TransName[1, 52]) { }
            column(TransName_1_53; TransName[1, 53]) { }
            column(TransName_1_54; TransName[1, 54]) { }
            column(TransName_1_55; TransName[1, 55]) { }
            column(TransName_1_56; TransName[1, 56]) { }
            column(TransName_1_57; TransName[1, 57]) { }
            column(TransName_1_58; TransName[1, 58]) { }
            column(TransName_1_59; TransName[1, 59]) { }
            column(TransName_1_60; TransName[1, 60]) { }
            column(TransName_1_61; TransName[1, 61]) { }
            column(TransName_1_62; TransName[1, 62]) { }
            column(TransName_1_63; TransName[1, 63]) { }
            column(TransName_1_64; TransName[1, 64]) { }
            column(TransName_1_65; TransName[1, 65]) { }
            column(TransName_1_66; TransName[1, 66]) { }
            column(TransName_1_67; TransName[1, 67]) { }
            column(TransName_1_68; TransName[1, 68]) { }
            column(TransName_1_69; TransName[1, 69]) { }
            column(TransName_1_70; TransName[1, 70]) { }
            column(TransName_1_71; TransName[1, 71]) { }
            column(TranscAmount_1_1; TranscAmount[1, 1]) { }
            column(TranscAmount_1_2; TranscAmount[1, 2]) { }
            column(TranscAmount_1_3; TranscAmount[1, 3]) { }
            column(TranscAmount_1_4; TranscAmount[1, 4]) { }
            column(TranscAmount_1_5; TranscAmount[1, 5]) { }
            column(TranscAmount_1_6; TranscAmount[1, 6]) { }
            column(TranscAmount_1_7; TranscAmount[1, 7]) { }
            column(TranscAmount_1_8; TranscAmount[1, 8]) { }
            column(TranscAmount_1_9; TranscAmount[1, 9]) { }
            column(TranscAmount_1_10; TranscAmount[1, 10]) { }
            column(TranscAmount_1_11; TranscAmount[1, 11]) { }
            column(TranscAmount_1_12; TranscAmount[1, 12]) { }
            column(TranscAmount_1_13; TranscAmount[1, 13]) { }
            column(TranscAmount_1_14; TranscAmount[1, 14]) { }
            column(TranscAmount_1_15; TranscAmount[1, 15]) { }
            column(TranscAmount_1_16; TranscAmount[1, 16]) { }
            column(TranscAmount_1_17; TranscAmount[1, 17]) { }
            column(TranscAmount_1_18; TranscAmount[1, 18]) { }
            column(TranscAmount_1_19; TranscAmount[1, 19]) { }
            column(TranscAmount_1_20; TranscAmount[1, 20]) { }
            column(TranscAmount_1_21; TranscAmount[1, 21]) { }
            column(TranscAmount_1_22; TranscAmount[1, 22]) { }
            column(TranscAmount_1_23; TranscAmount[1, 23]) { }
            column(TranscAmount_1_24; TranscAmount[1, 24]) { }
            column(TranscAmount_1_25; TranscAmount[1, 25]) { }
            column(TranscAmount_1_26; TranscAmount[1, 26]) { }
            column(TranscAmount_1_27; TranscAmount[1, 27]) { }
            column(TranscAmount_1_28; TranscAmount[1, 28]) { }
            column(TranscAmount_1_29; TranscAmount[1, 29]) { }
            column(TranscAmount_1_30; TranscAmount[1, 30]) { }
            column(TranscAmount_1_31; TranscAmount[1, 31]) { }
            column(TranscAmount_1_32; TranscAmount[1, 32]) { }
            column(TranscAmount_1_33; TranscAmount[1, 33]) { }
            column(TranscAmount_1_34; TranscAmount[1, 34]) { }
            column(TranscAmount_1_35; TranscAmount[1, 35]) { }
            column(TranscAmount_1_36; TranscAmount[1, 36]) { }
            column(TranscAmount_1_37; TranscAmount[1, 37]) { }
            column(TranscAmount_1_38; TranscAmount[1, 38]) { }
            column(TranscAmount_1_39; TranscAmount[1, 39]) { }
            column(TranscAmount_1_40; TranscAmount[1, 40]) { }
            column(TranscAmount_1_41; TranscAmount[1, 41]) { }
            column(TranscAmount_1_42; TranscAmount[1, 42]) { }
            column(TranscAmount_1_43; TranscAmount[1, 43]) { }
            column(TranscAmount_1_44; TranscAmount[1, 44]) { }
            column(TranscAmount_1_45; TranscAmount[1, 45]) { }
            column(TranscAmount_1_46; TranscAmount[1, 46]) { }
            column(TranscAmount_1_47; TranscAmount[1, 47]) { }
            column(TranscAmount_1_48; TranscAmount[1, 48]) { }
            column(TranscAmount_1_49; TranscAmount[1, 49]) { }
            column(TranscAmount_1_50; TranscAmount[1, 50]) { }
            column(TranscAmount_1_51; TranscAmount[1, 51]) { }
            column(TranscAmount_1_52; TranscAmount[1, 52]) { }
            column(TranscAmount_1_53; TranscAmount[1, 53]) { }
            column(TranscAmount_1_54; TranscAmount[1, 54]) { }
            column(TranscAmount_1_55; TranscAmount[1, 55]) { }
            column(TranscAmount_1_56; TranscAmount[1, 56]) { }
            column(TranscAmount_1_57; TranscAmount[1, 57]) { }
            column(TranscAmount_1_58; TranscAmount[1, 58]) { }
            column(TranscAmount_1_59; TranscAmount[1, 59]) { }
            column(TranscAmount_1_60; TranscAmount[1, 60]) { }
            column(TranscAmount_1_61; TranscAmount[1, 61]) { }
            column(TranscAmount_1_62; TranscAmount[1, 62]) { }
            column(TranscAmount_1_63; TranscAmount[1, 63]) { }
            column(TranscAmount_1_64; TranscAmount[1, 64]) { }
            column(TranscAmount_1_65; TranscAmount[1, 65]) { }
            column(TranscAmount_1_66; TranscAmount[1, 66]) { }
            column(TranscAmount_1_67; TranscAmount[1, 67]) { }
            column(TranscAmount_1_68; TranscAmount[1, 68]) { }
            column(TranscAmount_1_69; TranscAmount[1, 69]) { }
            column(TranscAmount_1_70; TranscAmount[1, 70]) { }
            column(TranscAmount_1_71; TranscAmount[1, 71]) { }
            column(TranscAmount_1_72; TranscAmount[1, 72]) { }
            column(TransBalance_1_1; TransBalance[1, 1]) { }
            column(TransBalance_1_2; TransBalance[1, 2]) { }
            column(TransBalance_1_3; TransBalance[1, 3]) { }
            column(TransBalance_1_4; TransBalance[1, 4]) { }
            column(TransBalance_1_5; TransBalance[1, 5]) { }
            trigger OnAfterGetRecord()
            begin

                TransCount := 0;
                showdet := true;
                NetPay := 0;
                BasicPay := 0;
                Clear(TranscAmount);
                payeamount := 0;
                Pensionam := 0;
                nhifamt := 0;
                GrossPay := 0;
                TaxablePay := 0;
                NHIFRelief := 0;
                InsuranceRelief := 0;
                repeat
                begin
                    TransCount := TransCount + 1;
                    prPeriodTransactions.Reset;
                    prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", periods);
                    prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", "HR-Employee"."No.");
                    prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code", Transcode[1, TransCount]);
                    if prPeriodTransactions.Find('-') then begin
                        TranscAmount[1, TransCount] := prPeriodTransactions.Amount;
                        TransBalance[1, TransCount] := prPeriodTransactions.Balance;
                    end;
                    repeat
                    begin
                        TranscAmountTotal[1, TransCount] := ((TranscAmountTotal[1, TransCount]) + TranscAmount[1, TransCount]);
                    end;
                    until prPeriodTransactions.Next = 0;

                end;
                until TransCount = 100;//COMPRESSARRAY(TransName);



                prPeriodTransactions.Reset;
                prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", periods);
                prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", "HR-Employee"."No.");
                prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Name", 'Net Pay');
                if prPeriodTransactions.Find('-') then begin
                    NetPay := prPeriodTransactions.Amount;
                    //NetPayTotal:=(NetPayTotal+(prPeriodTransactions.Amount));

                end;


                prPeriodTransactions.Reset;
                prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", periods);
                prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", "HR-Employee"."No.");
                //prPeriodTransactions.SETRANGE(prPeriodTransactions."Transaction Name",'Net Pay');
                if prPeriodTransactions.Find('-') then begin
                    repeat
                    begin
                        if prPeriodTransactions."Transaction Code" = 'NPAY' then begin
                            NetPay := prPeriodTransactions.Amount;
                            NetPayTotal := (NetPayTotal + (prPeriodTransactions.Amount));
                        end else
                            if prPeriodTransactions."Transaction Code" = 'PAYE' then begin
                                payeamount := prPeriodTransactions.Amount;
                                ;
                                payeamountTotal := (payeamountTotal + (prPeriodTransactions.Amount));
                            end else
                                if prPeriodTransactions."Transaction Code" = 'Pension' then begin
                                    Pensionam := prPeriodTransactions.Amount;
                                    ;
                                    PensionamTotal := (PensionamTotal + (prPeriodTransactions.Amount));
                                end else
                                    if prPeriodTransactions."Transaction Code" = 'NHIF' then begin
                                        nhifamt := prPeriodTransactions.Amount;
                                        ;
                                        nhifamtTotal := (nhifamtTotal + (prPeriodTransactions.Amount));
                                    end else
                                        if prPeriodTransactions."Transaction Code" = 'BPAY' then begin
                                            BasicPay := prPeriodTransactions.Amount;
                                            ;
                                            BasicPayTotal := (BasicPayTotal + (prPeriodTransactions.Amount));
                                            ;
                                        end else
                                            if prPeriodTransactions."Transaction Code" = 'GPAY' then begin
                                                GrossPay := prPeriodTransactions.Amount;
                                                ;
                                                GrosspayTotal := (GrosspayTotal + (prPeriodTransactions.Amount));
                                                ;
                                            end;
                        if prPeriodTransactions."Transaction Code" = 'TXBP' then begin
                            TaxablePay := prPeriodTransactions.Amount;
                            //GrosspayTotal := (GrosspayTotal + (prPeriodTransactions.Amount));                                                
                        end;
                        if prPeriodTransactions."Transaction Code" = 'INSR' then begin
                            InsuranceRelief := prPeriodTransactions.Amount;

                        end;
                        if prPeriodTransactions."Transaction Code" = 'NHIF-RL' then begin
                            NHIFRelief := prPeriodTransactions.Amount;

                        end;
                    end;
                    until prPeriodTransactions.Next = 0;

                end;


                if "HR-Employee"."No." = '' then showdet := false;
                //IF ((BasicPay=0) OR ("HR-Employee"."No."='')) THEN //showdet:=FALSE;
                //       CurrReport.SKIP;
            end;

            trigger OnPreDataItem()
            begin
                // "prPayroll Periods".SETFILTER("prPayroll Periods"."Date Opened",'=%1',SelectedPeriod);
                if periods = 0D then Error('Please Specify the Period first.');
                counts := 0;
                NetPayTotal := 0;
                BasicPayTotal := 0;
                payeamountTotal := 0;
                PensionamTotal := 0;
                nhifamtTotal := 0;
                GrosspayTotal := 0;

                Clear(TranscAmountTotal);

                // Make Headers
                // Pick The Earnings First
                prtransCodes.Reset;
                prtransCodes.SetFilter(prtransCodes."Transaction Type", '=%1', prtransCodes."transaction type"::Income);
                if prtransCodes.Find('-') then begin
                    repeat
                    begin
                        prPeriodTransactions.Reset;
                        prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code", prtransCodes."Transaction Code");
                        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", periods);
                        if prPeriodTransactions.Find('-') then begin
                            counts := counts + 1;
                            TransName[1, counts] := prtransCodes."Transaction Name";
                            Transcode[1, counts] := prtransCodes."Transaction Code";
                        end;
                    end;
                    until prtransCodes.Next = 0;
                end;

                // pick the deductions Here
                prtransCodes.Reset;
                prtransCodes.SetFilter(prtransCodes."Transaction Type", '=%1', prtransCodes."transaction type"::Deduction);
                if prtransCodes.Find('-') then begin
                    repeat
                    begin

                        prPeriodTransactions.Reset;
                        prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code", prtransCodes."Transaction Code");
                        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", periods);
                        if prPeriodTransactions.Find('-') then begin
                            counts := counts + 1;
                            TransName[1, counts] := prtransCodes."Transaction Name";
                            Transcode[1, counts] := prtransCodes."Transaction Code";
                        end;
                    end;
                    until prtransCodes.Next = 0;
                end;
                info.Reset;
                if info.Find('-') then info.CalcFields(info.Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Period; periods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period:';
                    TableRelation = "PR Payroll Periods"."Date Opened";
                    ToolTip = 'Specifies the value of the Period: field.';
                }
            }
        }

        actions { }
    }

    labels { }

    var
        periods: Date;
        counts: Integer;
        prPeriodTransactions: Record "PR Period Transactions";
        TransName: array[1, 200] of Text[200];
        Transcode: array[1, 200] of Code[100];
        TransCount: Integer;
        TranscAmount: array[1, 200] of Decimal;
        TransBalance: array[1, 200] of Decimal;
        TranscAmountTotal: array[1, 200] of Decimal;
        NetPay: Decimal;
        NetPayTotal: Decimal;
        showdet: Boolean;
        payeamount: Decimal;
        payeamountTotal: Decimal;
        Pensionam: Decimal;
        PensionamTotal: Decimal;
        nhifamt: Decimal;
        nhifamtTotal: Decimal;
        BasicPay: Decimal;
        BasicPayTotal: Decimal;
        GrossPay: Decimal;
        GrosspayTotal: Decimal;
        prtransCodes: Record "PR Transaction Codes";
        info: Record "Company Information";
        TaxablePay: Decimal;
        NHIFRelief: Decimal;
        InsuranceRelief: Decimal;
}





