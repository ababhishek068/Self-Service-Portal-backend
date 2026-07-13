codeunit 50034 "Fuel Pump API CU"
{

    trigger OnRun();
    begin
    end;

    var

    procedure fnInsertExternalTxns(TransactionDate: Date; DocumentNo: Code[100]; ItemNo: Code[100]; Description: Text[250]; CustNo: Code[20]; BankNo: Code[20]; Quantity: Decimal; UnitCost: Decimal; DiscountAmount: Decimal; TotalCost: Decimal; PostedBy: Code[20]) return_value: Boolean;
    var
        ObjExternalTxns: Record "External Buffer";
    begin
        return_value := FALSE;
        ObjExternalTxns.Init();
        ObjExternalTxns.Date := TransactionDate;
        ObjExternalTxns."Document No" := DocumentNo;
        ObjExternalTxns."Item No" := ItemNo;
        ObjExternalTxns.Description := Description;
        ObjExternalTxns."Customer No" := CustNo;
        ObjExternalTxns."Bank No" := BankNo;
        ObjExternalTxns.Quantity := Quantity;
        ObjExternalTxns."Unit Amount" := UnitCost;
        ObjExternalTxns."Total Amount" := TotalCost;
        ObjExternalTxns."Discount Amount" := DiscountAmount;
        ObjExternalTxns."Posted By" := PostedBy;
        // ObjExternalTxns.Attendant:=
        // ObjExternalTxns."Station Code":=
        // ObjExternalTxns.
        ObjExternalTxns.Insert(true);
        return_value := true;
    end;
}