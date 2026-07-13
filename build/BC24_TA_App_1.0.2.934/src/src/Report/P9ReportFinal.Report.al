Report 50320 "P9 Report (Final)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/P9ReportFinal.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Period Year Filter";
            column(ReportForNavId_8631; 8631) { }
            column(SelectedPeriod; SelectedPeriod) { }
            column(EmployerPIN; CompInf."VAT Registration No.") { }
            column(Fname; "First Name") { }
            column(MName; "Middle Name" + ' ' + "Last Name") { }
            column(Emp_No; "No.") { }
            column(PIN_No_; "TIN No.") { }
            column(Tac_Charged; "Total Tax Charged") { }
            column(TotalL; TotalL) { }
            column(TotaA; TotaA) { }
            column(TotalB; TotalB) { }
            column(totalD; totalD) { }
            column(totalC; totalC) { }
            column(TotalF; TotalF) { }
            column(TotalE3; TotalE3) { }
            column(TotalE2; TotalE2) { }
            column(TotalE1; TotalE1) { }
            column(TotalK; TotalK) { }
            column(TotalJ; TotalJ) { }
            column(TotalH; TotalH) { }
            column(TotalG; TotalG) { }
            column(Comp_Name; CompInf.Name) { }
            column(Month; SelectedPeriod) { }
            column(Logo; CompInf.Picture) { }
            column(CampanyName; CompInf.Name) { }
            column(PhoneNo; CompInf."Phone No.") { }
            column(Address; CompInf.Address) { }
            dataitem("prEmployee P9 Info"; "PR Employee P9 Info")
            {
                DataItemLink = "Employee Code" = field("No.");
                DataItemTableView = sorting("Employee Code", "Payroll Period") order(ascending);
                column(ReportForNavId_7242; 7242) { }
                column(PeriodMonth; Format("prEmployee P9 Info"."Payroll Period", 0, '<Month Text>')) { }
                column(B_Pay; "Basic Pay") { }
                column(Benefits; "Gross Pay" - "Basic Pay") { }
                column(Value_Of_Quoters; "Value Of Quarters") { }
                column(Gross; "Gross Pay") { }
                column(Owner_Occupier; "Owner Occupier Interest") { }
                column(thirty_Perc_Of_BPay; "Basic Pay" * 0.3) { }
                column(Actual; "prEmployee P9 Info".Pension + "prEmployee P9 Info".Pension) { }
                column(fixedDefContri; fixedDefContri) { }
                column(Gross_Pay__ColG; "Gross Pay" - ("prEmployee P9 Info".Pension + "prEmployee P9 Info".Pension + "Owner Occupier Interest")) { }
                column(TaxCharged; "Tax Charged") { }
                column(Tax_Relief; "Tax Relief") { }
                column(Insurance_Relief; "Insurance Relief") { }
                column(Ins_Relief; "Insurance Relief" + "Tax Relief") { }
                column(PAYE1; PAYE) { }
                column(ColG; ColG) { }
                column(Emp_Code; "Employee Code") { }
                column(Defined_Contribution; "Defined Contribution") { }
                column(Pension; Pension) { }
                column(PayPeriod; "Payroll Period") { }

                trigger OnAfterGetRecord()
                begin

                    if ("Defined Contribution" + Pension) > 20000 then begin
                        ColG := 20000 + "Owner Occupier Interest";
                        TotalG := TotalG + ColG;
                    end;

                    fixedDefContri := 20000;
                end;

                trigger OnPreDataItem()
                begin
                    "prEmployee P9 Info".SetFilter("prEmployee P9 Info"."Period Year", Format(SelectedPeriod));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if SelectedPeriod = 0 then
                    Evaluate(SelectedPeriod, "HR-Employee".GetFilter("HR-Employee"."Period Year Filter"));

                if SelectedPeriod = 0 then begin
                    Error('Specify The Year');
                end;

                PerionTrans.Reset;
                PerionTrans.SetRange(PerionTrans."Employee Code", "HR-Employee"."No.");
                //PerionTrans.setrange(PerionTrans."Payroll Period",SelectedPeriod);
                PerionTrans.SetRange(PerionTrans."Transaction Code", 'PNSR');
                if PerionTrans.Find('-') then begin
                    repeat
                        P9.Reset;
                        P9.SetRange(P9."Employee Code", "HR-Employee"."No.");
                        P9.SetRange(P9."Payroll Period", PerionTrans."Payroll Period");
                        if P9.Find('-') then begin
                            P9.Pension := PerionTrans.Amount;
                            P9.Modify;
                        end;
                    until PerionTrans.Next = 0;
                end;



                TotaA := 0;
                TotalB := 0;
                totalC := 0;
                totalD := 0;
                TotalE1 := 0;
                TotalE2 := 0;
                TotalE3 := 0;
                TotalF := 0;
                TotalG := 0;
                TotalH := 0;
                TotalJ := 0;
                TotalK := 0;
                TotalL := 0;
                P9.Reset;
                P9.SetRange(P9."Employee Code", "HR-Employee"."No.");
                P9.SetRange(P9."Period Year", SelectedPeriod);
                if P9.Find('-') then begin
                    repeat
                        TotaA := TotaA + P9."Gross Pay";
                        TotalB := TotalB + P9.Benefits;
                        totalC := totalC + P9."Value Of Quarters";
                        totalD := totalD + P9."Gross Pay";
                        TotalE1 := TotalE1 + (P9."Gross Pay" * 0.3);
                        TotalE2 := TotalE2 + (P9.Pension + P9.Pension);
                        TotalE3 := TotalE3 + 20000;
                        TotalF := TotalF + P9."Owner Occupier Interest";
                        TotalG := TotalG + (P9.Pension + P9.Pension + P9."Owner Occupier Interest");
                        if P9.Pension < 20000 then begin
                            //TotalG:=TotalG+P9.Pension;
                            TotalH := TotalH + (P9."Gross Pay" - (P9.Pension + P9.Pension + P9."Owner Occupier Interest"));
                        end else begin
                            //TotalG:=TotalG+20000;
                            TotalH := TotalH + (P9."Gross Pay" - (P9.Pension + P9.Pension + P9."Owner Occupier Interest"));
                        end;
                        //TotalJ:=TotalJ+(P9."Tax Charged"+(P9."Tax Relief"+P9."Insurance Relief"));
                        TotalJ := TotalJ + (P9."Tax Charged");
                        TotalK := TotalK + (P9."Tax Relief" + P9."Insurance Relief");
                        TotalL := TotalL + P9.PAYE;
                    until P9.Next = 0;
                end;

                "Total Tax Charged" := TotalH;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SelectedPeriodz; SelectedPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Year Filter';
                    ToolTip = 'Specifies the value of the Year Filter field.';
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        Clear(fixedDefContri);
    end;

    trigger OnPreReport()
    begin

        //IF SelectedPeriod=0 THEN BEGIN
        //ERROR('Specify The Year');
        //END;
        CompInf.Get();
        CompInf.CalcFields(Picture);

        // fixedDefContri:=20000;
    end;

    var
        CompInf: Record "Company Information";
        SelectedPeriod: Integer;
        fixedDefContri: Decimal;
        "Total Tax Charged": Decimal;
        TotaA: Decimal;
        TotalB: Decimal;
        totalC: Decimal;
        totalD: Decimal;
        TotalE1: Decimal;
        TotalE2: Decimal;
        TotalE3: Decimal;
        TotalF: Decimal;
        TotalG: Decimal;
        TotalH: Decimal;
        TotalJ: Decimal;
        TotalK: Decimal;
        TotalL: Decimal;
        P9: Record "PR Employee P9 Info";
        ColG: Decimal;
        PerionTrans: Record "PR Period Transactions";
}

