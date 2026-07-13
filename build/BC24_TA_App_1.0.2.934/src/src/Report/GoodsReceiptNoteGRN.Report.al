Report 50291 "Goods Receipt Note(GRN)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/GoodsReceiptNoteGRN.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            column(ReportForNavId_1; 1) { }
            column(CompInfoName; companyinfo.Name) { }
            column(CompAddr; companyinfo.Address) { }
            column(CompPhone; companyinfo."Phone No.") { }
            column(CompFax; companyinfo."Fax No.") { }
            column(No_; "Purch. Rcpt. Header"."No.") { }
            column(Project_User; "Purch. Rcpt. Header"."Buy-from Vendor No.") { }
            column(Supplier; "Purch. Rcpt. Header"."Pay-to Vendor No.") { }
            column(Address; "Purch. Rcpt. Header"."Pay-to Address") { }
            column(QuoteNo_PurchRcptHeader; "Purch. Rcpt. Header"."Quote No.") { }
            column(Date; "Purch. Rcpt. Header"."Order Date") { }
            column(Posting_Date; "Posting Date") { }
            column(LPO_LSO; "Purch. Rcpt. Header"."Order No.") { }
            column(VendInvNo; VendInvNo) { }
            column(Supplier_Name; "Purch. Rcpt. Header"."Pay-to Name") { }
            column(DeliveryNoteNo; DeliveryNoteNo) { }
            column(TotalCost; TotalCost) { }
            column(CompanyPicture; companyinfo.Picture) { }
            column(VendorShipmentNo; "Purch. Rcpt. Header"."Vendor Shipment No.") { }
            column(DeptCode; "Purch. Rcpt. Header"."Shortcut Dimension 2 Code") { }

            column(DeptName; DeptName) { }
            column(User_ID; "User ID") { }
            column(UserName; UserNam) { }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("No." = filter(<> ''));
                column(ReportForNavId_7; 7) { }
                column(ItemNo; "Purch. Rcpt. Line"."No.") { }
                column(Description; "Purch. Rcpt. Line".Description) { }
                column(UnitofMeasure; "Purch. Rcpt. Line"."Unit of Measure") { }
                column(Description2_PurchRcptLine; "Purch. Rcpt. Line"."Description 2") { }
                column(unit; "Purch. Rcpt. Line"."Unit of Measure") { }
                column(CityOrdered; "Purch. Rcpt. Line"."Location Code") { }
                column(CityReceived; "Purch. Rcpt. Line"."Location Code") { }
                column(UnitCost; "Purch. Rcpt. Line"."Direct Unit Cost") { }
                column(QuantityOrdered; "Purch. Rcpt. Line".Quantity) { }
                column(Total_Qty_Received; "Total Qty Received") { }
                column(QuantityReceived; "Purch. Rcpt. Line"."Quantity Invoiced") { }
                column(bal; "Purch. Rcpt. Line".Quantity - "Purch. Rcpt. Line"."Quantity Invoiced") { }
                column(VAT; "Purch. Rcpt. Line"."VAT Base Amount") { }
                column(Order_Qty; "Order Qty") { }
                column(Order_Qty_Archive; "Order Qty Archive") { }
                column(Order_Received_Qty; "Order Received Qty") { }

                column(Order_Amount_Including_VAT_Archive; "Order Amount Including VAT Archive") { }
                column(Ordered; Ordered) { }
                column(LineAmount; "Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost") { }
                column(QtyReceived; QtyReceived) { }
                column(VAT__; "VAT %") { }

                trigger OnAfterGetRecord()
                begin
                    QtyReceived := 0;
                    objGRNLN.reset;
                    objGRNLN.setrange("Order No.", "Purch. Rcpt. Line"."Order No.");
                    objGRNLN.setrange("No.", "Purch. Rcpt. Line"."No.");
                    objGRNLN.setfilter("GRN Filter", '%1..%2', '', "Purch. Rcpt. Line"."Document No.");
                    if objGRNLN.find('-') then begin
                        objGRNLN.CalcFields("GRN Qty Received");
                        QtyReceived := objGRNLN."GRN Qty Received";
                    end;

                    Ordered := 0;
                    PurchaseLineArchive.Reset;
                    PurchaseLineArchive.SetRange(PurchaseLineArchive."Document No.", "Purch. Rcpt. Header"."Order No.");
                    PurchaseLineArchive.SetRange(PurchaseLineArchive."Buy-from Vendor No.", "Purch. Rcpt. Line"."Buy-from Vendor No.");
                    if PurchaseLineArchive.Find('-') then begin
                        Ordered := Ordered + PurchaseLineArchive.Quantity;
                    end;
                end;
            }


            trigger OnAfterGetRecord()
            begin

                DeptName := '';

                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code, "Purch. Rcpt. Header"."Shortcut Dimension 2 Code");
                DimensionValue.SetRange(DimensionValue."Dimension Code", 'DEPARTMENT');
                if DimensionValue.Find('-') then begin
                    DeptName := DimensionValue.Name;
                end;
                If Usersetup.Get("Purch. Rcpt. Header"."User ID") then
                    UserNam := Usersetup.UserName;

                // donorCode:='';
                /* 
                 dimSetEntry.RESET;
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Set ID","Purch. Rcpt. Header Replica"."Dimension Set ID");
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Code",'DONOR');
                 IF dimSetEntry.FIND('-') THEN BEGIN
                   donorCode:=dimSetEntry."Dimension Value Code";
                 END;
                
                 dimSetEntry.RESET;
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Set ID","Purch. Rcpt. Header Replica"."Dimension Set ID");
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Code",'PROJECT');
                 IF dimSetEntry.FIND('-') THEN BEGIN
                   ProjectCode:=dimSetEntry."Dimension Value Code";
                 END; */

                VendInvNo := '';
                DeliveryNoteNo := '';

                PostedPurchaseInvoice.Reset();
                PostedPurchaseInvoice.SetRange("Order No.", "Purch. Rcpt. Header"."Order No.");
                if PostedPurchaseInvoice.Find('-') then begin
                    VendInvNo := PostedPurchaseInvoice."Vendor Invoice No.";
                end;

                TotalCost := 0;
                objGRNLN.RESET;
                objGRNLN.SETRANGE(objGRNLN."Document No.", "No.");
                IF objGRNLN.FIND('-') THEN
                    REPEAT
                        TotalCost := TotalCost + (objGRNLN.Quantity * objGRNLN."Unit Cost (LCY)");
                    UNTIL objGRNLN.NEXT = 0;

                /* InspectionLn.RESET;
                InspectionLn.SETRANGE(InspectionLn."Purchase Order No.","Purch. Rcpt. Header Replica"."Order No.");
                IF InspectionLn.FIND('-') THEN BEGIN
                  DeliveryNoteNo:=InspectionLn."Delivery Note";
                END; */

                /* 
                 objLogos.RESET;
                 objLogos.SETRANGE(objLogos.Code,donorCode);
                 IF objLogos.FIND('-') THEN BEGIN
                    objLogos.CALCFIELDS(objLogos.Picture);
                 END ELSE BEGIN
                    objLogos.SETRANGE(objLogos.Default,TRUE);
                    objLogos.CALCFIELDS(objLogos.Picture);
                 END; */

                //
                //CheckReport.FormatNoText(NumberText,"Total Net Amount",'');


            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        companyinfo.Get;
        companyinfo.CalcFields(companyinfo.Picture);
    end;

    var
        DimensionValue: Record "Dimension Value";
        DeptName: Text[100];
        VendInvNo: Code[30];
        DeliveryNoteNo: Code[10];
        TotalCost: Decimal;
        objGRNLN: Record "Purch. Rcpt. Line";
        companyinfo: Record "Company Information";
        Ordered: Decimal;
        PostedPurchaseInvoice: Record "Purch. Inv. Header";
        QtyReceived: Decimal;
        PurchaseLineArchive: Record "Purchase Line Archive";
        UserNam: Text;
        Usersetup: Record "User Setup";
}

