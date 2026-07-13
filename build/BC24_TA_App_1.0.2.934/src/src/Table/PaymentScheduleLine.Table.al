Table 50700 "Payment Schedule Line"
{

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Payment No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Document Type" = CONST(Payment)) "Payments Header"."No." WHERE(Status = FILTER(Approved), "Payment Schedule No" = FILTER(' '), "Payment Type" = FILTER(Normal | "Petty Cash"))
            ELSE
            IF ("Document Type" = CONST(Imprest)) "Imprest Header"."No." WHERE(Status = CONST(Approved), "Fully Paid" = CONST(false))
            ELSE
            IF ("Document Type" = CONST("Staff Claim")) "Staff Claims Header"."No." WHERE(Status = CONST(Approved), "Fully Paid" = CONST(false))
            ELSE
            IF ("Document Type" = CONST("Item Cash")) "Imprest Header"."No." WHERE(Status = CONST(Approved), "imprest TYpe" = filter("Item Cash"), "Fully Paid" = CONST(false))
            else
            IF ("Document Type" = CONST(Interbank)) "InterBank Transfers".No WHERE(Status = CONST(Approved), Posted = CONST(false));

            trigger OnValidate()
            begin
                IF pH.GET("Payment No") THEN BEGIN
                    pH.CALCFIELDS("Total Net Amount");
                    pH.CALCFIELDS("Paid Amount");
                    Payee := pH.Payee;
                    Amount := pH."Total Net Amount";
                    "Cheque Amount" := pH."Total Net Amount" - pH."Paid Amount";
                    "Payment Narration" := pH."Payment Narration";
                END;
                IF ImpH.GET("Payment No") THEN BEGIN
                    ImpH.CALCFIELDS("Total Net Amount");
                    ImpH.CALCFIELDS("Paid Amount");
                    Payee := ImpH.Payee;
                    Amount := ImpH."Total Net Amount";
                    "Cheque Amount" := ImpH."Total Net Amount" - ImpH."Paid Amount";
                    "Payment Narration" := ImpH.Purpose;
                END;

                IF InterBnk.GET("Payment No") THEN BEGIN
                    InterBnk.CALCFIELDS(Amount);
                    InterBnk.CALCFIELDS("Paid Amount");
                    Payee := InterBnk.Remarks;
                    Amount := InterBnk.Amount;
                    "Cheque Amount" := InterBnk.Amount - InterBnk."Paid Amount";
                    "Payment Narration" := InterBnk.Remarks;
                END;
                IF StaffClaim.GET("Payment No") THEN BEGIN
                    StaffClaim.CALCFIELDS("Total Net Amount");
                    StaffClaim.CALCFIELDS("Paid Amount");
                    Payee := StaffClaim.Payee;
                    Amount := StaffClaim."Total Net Amount";
                    "Cheque Amount" := StaffClaim."Total Net Amount" - ImpH."Paid Amount";
                    "Payment Narration" := StaffClaim.Purpose;
                END;
            end;
        }
        field(3; Payee; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Payment Narration"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Payment,Imprest,Interbank,Staff Claim,Item Cash';
            OptionMembers = Payment,Imprest,Interbank,"Staff Claim","Item Cash";
        }
        field(7; "Cheque Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF ImpH.GET("Payment No") THEN BEGIN
                    ImpH.CALCFIELDS(ImpH."Paid Amount");
                    ImpH.CALCFIELDS(ImpH."Total Net Amount");
                    IF (ImpH."Paid Amount" + "Cheque Amount") > ImpH."Total Net Amount" THEN BEGIN
                        "Cheque Amount" := 0;
                        MESSAGE('The selected Document has been fully paid.');
                    END;
                END;
                IF PH.GET("Payment No") THEN BEGIN
                    PH.CALCFIELDS("Paid Amount");
                    PH.CALCFIELDS("Total Net Amount");
                    IF (PH."Paid Amount" + "Cheque Amount") > PH."Total Net Amount" THEN BEGIN
                        "Cheque Amount" := 0;
                        MESSAGE('The selected Document has been fully paid.');
                    END;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; No, "Payment No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        pH: Record "Payments Header";
        ImpH: Record "Imprest Header";
        InterBnk: Record "InterBank Transfers";
        StaffClaim: Record "Staff Claims Header";
}

