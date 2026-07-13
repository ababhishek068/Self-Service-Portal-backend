Codeunit 50040 "Production Webportal"
{
    procedure InsertSalesOrderHeader(CustNo: Code[20]; Desc: Text) ret: Code[20]
    var
        ObjSalesOrderHeader: Record "Sales Header";
        NoSeriesMgt: Codeunit "No. Series";
        NextNo: Code[20];
        ObjSalesSetup: Record "Sales & Receivables Setup";
        ObjCust: Record Customer;
    begin
        ret := '';
        ObjSalesSetup.Reset();
        ObjSalesSetup.Get();
        ObjSalesSetup.TestField("Order Nos.");
        ObjSalesOrderHeader.Reset();
        ObjSalesOrderHeader.Init();
        NextNo := NoSeriesMgt.GetNextNo(ObjSalesSetup."Order Nos.", 0D, true);
        ObjSalesOrderHeader."No." := NextNo;
        ObjSalesOrderHeader."Document Date" := Today;
        ObjSalesOrderHeader."Document Type" := ObjSalesOrderHeader."Document Type"::Order;
        ObjSalesOrderHeader."Sell-to Customer No." := CustNo;
        ObjSalesOrderHeader."Bill-to Customer No." := CustNo;
        ObjSalesOrderHeader.Validate("Sell-to Customer No.");
        ObjSalesOrderHeader.Validate("Bill-to Customer No.");
        if ObjCust.Get(CustNo) then
            ObjSalesOrderHeader."Sell-to Phone No." := ObjCust."Phone No.";
        ObjSalesOrderHeader."Sell-to E-Mail" := ObjCust."E-Mail";
        ObjSalesOrderHeader.Insert(true);
        ret := NextNo;
    end;

    procedure InsertSalesOrderLines(OrderNo: Code[20]; ItemNo: code[20]) ret: Boolean
    var
        ObjSalesOrderHeader: Record "Sales Header";
        ObjSalesOrderLine: Record "Sales Line";
        LineNo: Integer;

    begin
        ret := false;
        ObjSalesOrderHeader.Reset();
        ObjSalesOrderHeader.SetRange("No.", OrderNo);
        ObjSalesOrderHeader.SetRange("Document Type", ObjSalesOrderHeader."Document Type"::Order);
        if ObjSalesOrderHeader.Find('-') then begin
            ObjSalesOrderLine.Reset();
            ObjSalesOrderLine.FindLast();
            LineNo := ObjSalesOrderLine."Line No." + 10000;
            ObjSalesOrderLine.Reset();
            ObjSalesOrderLine.Init();
            ObjSalesOrderLine."Document No." := OrderNo;
            ObjSalesOrderLine."Document Type" := ObjSalesOrderLine."Document Type"::Order;
            ObjSalesOrderLine.Type := ObjSalesOrderLine.Type::Item;
            ObjSalesOrderLine."Sell-to Customer No." := ObjSalesOrderHeader."Sell-to Customer No.";
            ObjSalesOrderLine."No." := ItemNo;
            ObjSalesOrderLine."Line No." := LineNo;
            ObjSalesOrderLine.validate("No.");
            ObjSalesOrderLine.Validate("Document No.");
            ObjSalesOrderLine.Validate("Sell-to Customer No.");
            ObjSalesOrderLine.Insert(true);
            ret := true;
        end else
            Error('Sales Order Does not Exist');
    end;

    procedure CreateCustomer(nationalID: Code[20]; Name: Text[300]; address1: Text[300]; address2: Text[300]; phonenumber: Code[20]; email: Text[50]) ret: Code[20]
    var
        ObjCust: Record Customer;
        NoSeriesMgt: Codeunit "No. Series";
        NextNo: Code[20];
        ObjSalesSetup: Record "Sales & Receivables Setup";
    begin
        ret := '';
        ObjSalesSetup.Reset();
        ObjSalesSetup.Get();
        ObjSalesSetup.TestField("Customer Nos.");
        ObjSalesSetup.TestField("Default Customer Posting Group");
        ObjCust.Reset();
        ObjCust.SetRange("ID No", nationalID);
        if not ObjCust.Find('-') then begin
            NextNo := NoSeriesMgt.GetNextNo(ObjSalesSetup."Customer Nos.", 0D, true);
            ObjCust.Init();
            ObjCust."No." := NextNo;
            ObjCust.Validate("No.");
            ObjCust.Name := Name;
            ObjCust."ID No" := nationalID;
            ObjCust.Address := address1;
            ObjCust."Address 2" := address2;
            ObjCust."Phone No." := phonenumber;
            ObjCust."E-Mail" := email;
            ObjCust."Customer Type" := ObjCust."Customer Type"::Customer;
            ObjCust."Customer Posting Group" := ObjSalesSetup."Default Customer Posting Group";
            ObjCust."Bill-to Customer No." := NextNo;
            ObjCust.Insert(true);
            ret := NextNo;

        end else
            Error('Customer Already Exists with ID/KRA PIN Number ' + nationalID);

    end;
}