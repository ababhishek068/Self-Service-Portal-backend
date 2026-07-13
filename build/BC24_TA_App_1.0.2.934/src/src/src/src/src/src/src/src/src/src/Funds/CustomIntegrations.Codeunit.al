codeunit 50036 "Custom Integrations"
{

    trigger OnRun();
    begin
    end;

    var

    procedure StorePayment(reference: Code[50]; bank: Code[10]; student: Code[20]; amount: Decimal; paymenttype: Code[20]; datev: DateTime; extdoc: Code[50]; extdoc2: Code[50]) ReturnV: Text
    var
        banktrans: Record "Bank Transactions Buffer";
    begin
        ReturnV := '';
        if not banktrans.Get(reference) then begin
            banktrans.Init;
            banktrans."Transaction Code" := reference;
            banktrans.Description := paymenttype;
            banktrans."Cheque No" := bank;
            banktrans."Student No." := student;
            banktrans.Posted := false;
            banktrans.Date := datev;
            banktrans."Transcation Date" := CurrentDatetime;
            banktrans.Amount := amount;
            banktrans."Bank Code" := bank;
            banktrans."External Document No" := extdoc;
            banktrans."External Document No 2" := extdoc2;
            banktrans.Insert(true);

            banktrans.reset;
            banktrans.setrange("Transaction Code", reference);
            if banktrans.find('-') then begin
                Report.Run(70135612, false, false, banktrans); //  70135240
            end;
            ReturnV := 'SUCCESS';
        end;
    end;
}