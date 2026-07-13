Report 50147 "Goods Receipt Note(GRN)1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GoodsReceiptNoteGRN1.rdlc';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            column(ReportForNavId_1; 1) { }
            column(CompInfo; companyinfo.Name) { }
            column(CompAddr; companyinfo.Address) { }
            column(CompPhone; companyinfo."Phone No.") { }
            column(CompFax; companyinfo."Fax No.") { }
            column(No_; "Purch. Rcpt. Header"."No.") { }
            column(Project_User; "Purch. Rcpt. Header"."Buy-from Vendor No.") { }
            column(SupplierS; "Purch. Rcpt. Header"."Pay-to Vendor No.") { }
            column(Address; "Purch. Rcpt. Header"."Pay-to Address") { }
            column(Date; "Purch. Rcpt. Header"."Order Date") { }
            column(LPO_LSO; "Purch. Rcpt. Header"."Order No.") { }
            column(VendInvNo; VendInvNo) { }
            column(Supplier_Name; "Purch. Rcpt. Header"."Pay-to Name") { }
            column(DeliveryNoteNo; DeliveryNoteNo) { }
            column(TotalCost; TotalCost) { }
            column(log; companyinfo.Picture) { }
            column(VendorShipmentNo; "Purch. Rcpt. Header"."Vendor Shipment No.") { }
            column(DeptCode; "Purch. Rcpt. Header"."Shortcut Dimension 2 Code") { }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
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
                column(QuantityReceived; "Purch. Rcpt. Line"."Quantity Invoiced") { }
                column(bal; "Purch. Rcpt. Line".Quantity - "Purch. Rcpt. Line"."Quantity Invoiced") { }
            }
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Status = filter(Approved));
                column(ReportForNavId_1000000002; 1000000002) { }
                column(approverID; "Approval Entry"."Approver ID") { }
                column(DateModified; "Approval Entry"."Last Date-Time Modified") { }
            }

            trigger OnAfterGetRecord()
            begin
                /* donorCode:='';
                
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
                 END;
                
                  VendInvNo:='';
                  DeliveryNoteNo:='';
                
                PO.RESET;
                PO.SETRANGE(PO."No.","Purch. Rcpt. Header Replica"."Order No.");
                IF PO.FIND('-') THEN BEGIN
                 VendInvNo:=PO."Vendor Invoice No.";
                END;
                
                TotalCost:=0 ;
                objGRNLN.RESET;
                objGRNLN.SETRANGE(objGRNLN."Document No.","No.");
                IF objGRNLN.FIND('-') THEN REPEAT
                 TotalCost:=TotalCost+(objGRNLN.Quantity*objGRNLN."Unit Cost (LCY)");
                UNTIL objGRNLN.NEXT=0;
                
                InspectionLn.RESET;
                InspectionLn.SETRANGE(InspectionLn."Purchase Order No.","Purch. Rcpt. Header Replica"."Order No.");
                IF InspectionLn.FIND('-') THEN BEGIN
                  DeliveryNoteNo:=InspectionLn."Delivery Note";
                END;
                
                 objLogos.RESET;
                 objLogos.SETRANGE(objLogos.Code,donorCode);
                 IF objLogos.FIND('-') THEN BEGIN
                    objLogos.CALCFIELDS(objLogos.Picture);
                 END ELSE BEGIN
                    objLogos.SETRANGE(objLogos.Default,TRUE);
                    objLogos.CALCFIELDS(objLogos.Picture);
                 END;
                
                //
                //CheckReport.FormatNoText(NumberText,"Total Net Amount",'');
                 */

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
        VendInvNo: Code[30];
        DeliveryNoteNo: Code[10];
        TotalCost: Decimal;
        companyinfo: Record "Company Information";
}

