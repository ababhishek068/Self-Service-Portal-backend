Codeunit 50014 "Tax Calculation2"
{

    trigger OnRun()
    begin
    end;

    procedure CalculateTax(Rec: Record "Payment Line"; CalculationType: Option VAT,"W/Tax",Retention,PAYE) Amount: Decimal
    begin
        case CalculationType of
            Calculationtype::VAT:
                begin
                    Amount := (Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount;
                end;
            /*CalculationType::"W/Tax":
              BEGIN
                  Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
                  *(Rec."W/Tax Rate"/100);

              END;
              */
            Calculationtype::Retention:
                begin
                    Amount := (Rec.Amount - ((Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount))
                     * (Rec."Retention Rate" / 100);
                end;
            Calculationtype::PAYE:
                begin
                    Amount := Rec."PAYE Amount";
                end;

            Calculationtype::"W/Tax":
                begin
                    Amount := Rec."Withholding Tax Amount";

                end;
        end;

    end;
}

