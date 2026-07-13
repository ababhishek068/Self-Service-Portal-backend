codeunit 50045 "Suppliers Portal"
{

    trigger OnRun()
    begin
    end;

    var
        NextNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        VendorBuffer: Record "Vendor User Buffer";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        TenderBids: Record "Tender Bids";
        PurchaseSetup: Record "Purchases & Payables Setup";
        Notif: Record "Shipment Notification";
        recordId1: RecordID;
        recordId2: RecordID;

    procedure CreateAccount(compname: Code[200]; compno: Code[50]; krapin: Code[30]; ownership: Integer; language: Code[30]; countries: Code[50]; cities: Code[100]; telephone: Code[30]; mobilephonenumber: Code[30]; email: Text[100]; postaladdress: Text[100]; streetaddress: Text[200]; password: Text[50]; specialgrp: Code[20]) ret: Code[20]
    var
        VendorBuffer: Record "Vendor User Buffer";
    begin
        ret := '';
        PurchaseSetup.Get();
        PurchaseSetup.testfield(PurchaseSetup."Vendor Buffer No.");
        VendorBuffer.INIT;
        NextNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Vendor Buffer No.", 0D, TRUE);
        VendorBuffer.UserID := NextNo;
        VendorBuffer."Company Name" := compname;
        VendorBuffer."Company Registration No" := compno;
        VendorBuffer.Email := email;
        VendorBuffer.City := cities;
        VendorBuffer.Country := countries;
        VendorBuffer."Kra Pin" := krapin;
        VendorBuffer.Language := language;
        VendorBuffer.Password := password;
        VendorBuffer."Street Address/Building No" := streetaddress;
        VendorBuffer."Postal Code" := postaladdress;
        VendorBuffer."Mobile Phone" := mobilephonenumber;
        VendorBuffer."Telephone No" := telephone;
        VendorBuffer.Ownership := ownership;
        VendorBuffer.Status := VendorBuffer.Status::New;
        VendorBuffer.Password := password;
        VendorBuffer."Vendor Category" := specialgrp;
        VendorBuffer."Registration Type" := VendorBuffer."Registration Type"::Corporate;
        VendorBuffer.INSERT;
        ret := NextNo;
    end;

    procedure InsertLogo(Vendor: Code[50]; Picture: BigText)
    var
        Item: Record "Vendor User Buffer";
    begin
        Item.GET(Vendor);
        // Bytes := Convert.FromBase64String(Picture);
        // MemoryStream := MemoryStream.MemoryStream(Bytes);
        // Item.Logo.IMPORTSTREAM(MemoryStream, '');
        // //Bytes := Convert.FromBase64String(Picture);
        // //MemoryStream := MemoryStream.MemoryStream(Bytes);
        // //Item.Logo.CREATEOUTSTREAM(Ostream);
        // //MemoryStream.WriteTo(Ostream);

        Item.MODIFY;
    end;

    procedure UpdateAccountStep1(userid: Code[20]; compname: Code[200]; compno: Code[50]; krapin: Code[30]; telephone: Code[30]; mobilephonenumber: Code[30]; email: Text[100]; postaladdress: Text[100]; streetaddress: Text[200]) ret: Boolean
    var
        VendorBuffer: Record "Vendor User Buffer";
    begin
        ret := FALSE;
        VendorBuffer.RESET;
        VendorBuffer.SETRANGE("Company Registration No", compno);
        IF VendorBuffer.FIND('-') THEN
            VendorBuffer."Company Name" := compname;
        VendorBuffer."Company Registration No" := compno;
        VendorBuffer.Email := email;
        VendorBuffer."Kra Pin" := krapin;

        VendorBuffer."Street Address/Building No" := streetaddress;
        VendorBuffer."Postal Code" := postaladdress;
        VendorBuffer."Mobile Phone" := mobilephonenumber;
        VendorBuffer."Telephone No" := telephone;
        //VendorBuffer.Ownership:=ownership;
        VendorBuffer.Status := VendorBuffer.Status::New;
        VendorBuffer.MODIFY;
        ret := TRUE;
    end;

    procedure addDirectorinfo(director_name: Text[250]; director_email: Text[100]; director_phone: Code[50]; nationality: Code[50]; gender: Integer; ownership: Integer; compno: Code[20]; vendno: Code[20])
    var
        Directorinfo: Record "Vendor Director Information";
    begin
        Directorinfo.INIT;
        Directorinfo."Name of Direcor" := director_name;
        Directorinfo.Email := director_email;
        Directorinfo.CompanyRegNo := compno;
        Directorinfo.Gender := gender;
        Directorinfo.Nationality := nationality;
        Directorinfo.Telephone := director_phone;
        Directorinfo.Ownership := ownership;
        Directorinfo."Vendor No" := vendno;
        Directorinfo.INSERT;
    end;

    procedure DeleteDirectorinfo(director_name: Text[250]; compno: Code[20]; vendno: Code[20])
    var
        Directorinfo: Record "Vendor Director Information";
    begin
        Directorinfo.RESET;
        Directorinfo.SETRANGE("Vendor No", vendno);
        Directorinfo.SETRANGE(CompanyRegNo, compno);
        Directorinfo.SETRANGE("Name of Direcor", director_name);
        IF Directorinfo.FIND('-') THEN Directorinfo.DELETEALL;
    end;

    procedure AddSpecialGroup(special_group: Integer; business_type: Code[100]; certificate_no: Code[50]; issue_date: Date; period: Integer; expiry_date: Date; compno: Code[50]; vendno: Code[20])
    var
        SpecialGrp: Record "Special Groups";
    begin
        SpecialGrp.INIT;
        SpecialGrp."Business Type" := business_type;
        SpecialGrp.Category := special_group;
        SpecialGrp."Certificate No" := certificate_no;
        SpecialGrp.CompanyRegNo := compno;
        SpecialGrp."Issue Date" := issue_date;
        SpecialGrp."Expiry Date" := expiry_date;
        SpecialGrp.Vendno := vendno;
        SpecialGrp.Period := period;
        SpecialGrp.INSERT;
    end;

    procedure InsertVendorAttachments(vendno: Code[20]; Url: Text; Descr: Text; expirydate: Date) ret: Boolean
    var
        RecID: RecordID;
        RecordRef: RecordRef;
        RecLink: Record "Record Link";
        DocAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
    begin
        ret := FALSE;
        VendorBuffer.GET(vendno);
        RecordRef.GETTABLE(VendorBuffer);
        RecID := RecordRef.RECORDID;
        RecLink.RESET;
        RecLink."Record ID" := RecID;
        RecLink.URL1 := Url;
        RecLink.Type := RecLink.Type::Link;
        RecLink.Company := CompanyName;
        RecLink."User ID" := USERID;
        RecLink.Created := CURRENTDATETIME;
        RecLink.Description := Descr;
        //RecLink."Expiry Date" := expirydate;
        RecLink.INSERT;
        //insert into document attachments
        CLEAR(DocAttachment);
        DocAttachment.INIT();
        DocAttachment.VALIDATE("File Extension", FileManagement.GetExtension(Url));
        DocAttachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)));
        DocAttachment.VALIDATE("Table ID", 70135631);
        DocAttachment.VALIDATE("No.", vendno);
        DocAttachment."Document Reference ID".ImportFile(COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)), 'Vendor Registration Attachments', '');
        DocAttachment.INSERT(TRUE);
        IF (STRPOS(Descr, 'AGPO')) >= 1 THEN VendorBuffer."Agpo Attached" := TRUE;
        IF (STRPOS(Descr, 'KRA')) >= 1 THEN VendorBuffer."KRA Pin Attached" := TRUE;
        IF (STRPOS(Descr, 'Compliance')) >= 1 THEN VendorBuffer."TCC Attached" := TRUE;
        IF (STRPOS(Descr, 'incorporation')) >= 1 THEN VendorBuffer."Certificate of Incorporation" := TRUE;
        IF (STRPOS(Descr, 'CR12')) >= 1 THEN VendorBuffer."CR12 Attached" := TRUE;
        IF (STRPOS(Descr, 'Audited')) >= 1 THEN VendorBuffer."Audited Accounts Attached" := TRUE;
        IF (STRPOS(Descr, 'Scan Copy of ID')) >= 1 THEN VendorBuffer."Direcort ID Attached" := TRUE;
        IF (STRPOS(Descr, 'Permit')) >= 1 THEN VendorBuffer."Business Permit Attached" := TRUE;
        VendorBuffer.MODIFY;
        ret := TRUE;
    end;

    procedure SubmitRegistration(compno: Code[20]; vendno: Code[20]) ret: Boolean
    var
        qualified: Boolean;
    begin
        ret := FALSE;
        qualified := FALSE;
        //check if all attachments have been uploaded
        VendorBuffer.RESET;
        VendorBuffer.SETRANGE(UserID, vendno);
        IF VendorBuffer.FIND('-') THEN
            IF VendorBuffer."Vendor Category" = 'None' THEN BEGIN
                IF VendorBuffer."KRA Pin Attached" = FALSE THEN ERROR('Please attach your TAX PIN Certificate');
                IF VendorBuffer."TCC Attached" = FALSE THEN ERROR('Please attach your Tax Compliance Certificate');
                IF VendorBuffer."Certificate of Incorporation" = FALSE THEN ERROR('Please attach Certificate of Incorporation');
                IF VendorBuffer."CR12 Attached" = FALSE THEN ERROR('Please attach your CR12');
                IF VendorBuffer."Audited Accounts Attached" = FALSE THEN ERROR('Please attach audited financial statement for current 2 years or current 3 months bank statement');
                IF VendorBuffer."Direcort ID Attached" = FALSE THEN ERROR('Please attach copy of Directors National ID or Password');
                IF VendorBuffer."Business Permit Attached" = FALSE THEN ERROR('Please attach a valid Business Permit/Licence');
                qualified := TRUE
            END ELSE BEGIN
                IF VendorBuffer."KRA Pin Attached" = FALSE THEN ERROR('Please attach your TAX PIN Certificate');
                IF VendorBuffer."TCC Attached" = FALSE THEN ERROR('Please attach your Tax Compliance Certificate');
                IF VendorBuffer."Certificate of Incorporation" = FALSE THEN ERROR('Please attach Certificate of Incorporation');
                IF VendorBuffer."CR12 Attached" = FALSE THEN ERROR('Please attach your CR12');
                IF VendorBuffer."Agpo Attached" = FALSE THEN ERROR('Please attach your copy of AGPO Certificate');
                IF VendorBuffer."Direcort ID Attached" = FALSE THEN ERROR('Please attach copy of Directors National ID or Password');
                IF VendorBuffer."Business Permit Attached" = FALSE THEN ERROR('Please attach a valid Business Permit/Licence');
                qualified := TRUE;
            END;
        IF qualified = FALSE THEN ERROR('Please note that your application is not complete');
        BEGIN
            VarVariant := VendorBuffer;
            IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                CustomApprovals.OnSendDocForApproval(VarVariant);
            ret := TRUE;
        END;
        EXIT(ret);
    end;

    procedure SubmitQuote(rfqno: Code[20]; vendor: Code[20]) ret: Code[20]
    var
        purchaseheader: Record "Purchase Header";
        NextNo: Code[20];
        vendort: Record Vendor;
        RFQ_Header: Record "Purchase Quote Header";
    begin
        ret := '';
        purchaseheader.RESET;
        purchaseheader.SETRANGE(purchaseheader."Request for Quote No.", rfqno);
        purchaseheader.SETRANGE("Buy-from Vendor No.", vendor);
        IF purchaseheader.FIND('-') THEN
            ERROR('You have already placed your quote on ' + rfqno) ELSE
            purchaseheader.INIT;
        //purchaseheader.SETCURRENTKEY("No.");
        PurchaseSetup.Get();
        PurchaseSetup.testfield(PurchaseSetup."Quotation Request No");
        NextNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Quotation Request No", 0D, TRUE);
        //NextNo := NoSeriesMgt.GetNextNo('P-QTE', 0D, TRUE);
        purchaseheader."Document Type" := purchaseheader."Document Type"::Quote;
        purchaseheader."Document Type 2" := purchaseheader."Document Type 2"::Quote;
        purchaseheader.DocApprovalType := purchaseheader.DocApprovalType::Quote;
        purchaseheader."No." := NextNo;
        purchaseheader."Order Date" := TODAY;
        purchaseheader."RFQ No." := rfqno;
        //Added
        RFQ_Header.RESET();
        RFQ_Header.SETRANGE("No.", rfqno);
        IF RFQ_Header.FIND('-') THEN BEGIN
            purchaseheader."Requisition No." := RFQ_Header."Internal Requisition No.";
            purchaseheader."Shortcut Dimension 1 Code" := RFQ_Header."Shortcut Dimension 1 Code";
            purchaseheader."Shortcut Dimension 2 Code" := RFQ_Header."Shortcut Dimension 2 Code";
            purchaseheader."Responsibility Center" := RFQ_Header."Responsibility Center";
            purchaseheader."Procurement Method Code" := RFQ_Header."Procuremet Methods";
            purchaseheader."Expected Closing Date" := RFQ_Header."Expected Closing Date";
            // purchaseheader."Procurement Workplan" := RFQ_Header."Procurement Plan";
        END;

        // >>> Added
        //purchaseheader.VALIDATE("RFQ No.");
        purchaseheader."Buy-from Vendor No." := vendor;
        purchaseheader."Pay-to Vendor No." := vendor;
        vendort.RESET;
        vendort.SETRANGE("No.", vendor);
        IF vendort.FIND('-') THEN BEGIN
            purchaseheader."Buy-from Vendor Name" := vendort.Name;
        END;
        //copy links
        recordId1 := vendort.RECORDID;
        recordId2 := purchaseheader.RECORDID;
        CopyRecordLinks(recordId1.TABLENO, vendor, 1, recordId2.TABLENO, NextNo, 2);
        purchaseheader.INSERT;

        ret := NextNo;
    end;

    procedure SubmitQuoteLine(rfqno: Code[20]; vendor: Code[20]; lineno: Integer; amount: Decimal; quantity: Integer; itemno: Code[20]; descriptions: Text[250]; purchasequoteno: Code[20]; itemtypes: Integer; location: Code[20]; totalamount: Decimal; procurementplan: Code[20]; expensecode: Code[20]; unitofmeasure: Code[100]; dimension1: Code[20]; dimension2: Code[20]) ret: Code[20]
    var
        purchaseline: Record "Purchase Line";
    begin
        purchaseline.reset;
        purchaseline.SetRange(purchaseline."Buy-from Vendor No.", vendor);
        purchaseline.setrange(purchaseline.Type, itemtypes);
        purchaseline.SetRange(purchaseline."No.", itemno);
        if purchaseline.find('-') then error('You have already placed your quote on ' + descriptions);
        purchaseline.INIT;
        purchaseline."Document No." := purchasequoteno;
        purchaseline.Type := itemtypes;
        purchaseline."No." := itemno;
        purchaseline.Validate("No.");
        purchaseline."Buy-from Vendor No." := vendor;
        purchaseline."Pay-to Vendor No." := vendor;
        purchaseline."Line No." := lineno;
        //purchaseline."Procurement Workplan" := procurementplan;
        purchaseline."Expense Code" := expensecode;
        purchaseline."Shortcut Dimension 1 Code" := dimension1;
        purchaseline."Shortcut Dimension 2 Code" := dimension2;
        purchaseline."Unit of Measure Code" := unitofmeasure;
        purchaseline.VALIDATE("Unit of Measure Code");
        purchaseline."Unit of Measure" := unitofmeasure;
        purchaseline.Description := descriptions;
        purchaseline.Description := descriptions;
        purchaseline."Location Code" := location;
        purchaseline.Quantity := quantity;
        purchaseline."Direct Unit Cost" := amount;
        purchaseline."Line Amount" := totalamount;
        purchaseline.INSERT;
    end;

    procedure InsertShipNotification(vendor: Code[20]; date: Date; time: Time; purchaseorder: Code[20]; location: Code[150]) ret: Code[20]
    var
        Notif: Record "Shipment Notification";
    begin
        IF date <= TODAY THEN ERROR('Please select a future date');
        ret := '';
        PurchaseSetup.Get();
        PurchaseSetup.TestField(PurchaseSetup."Shipment Notification Nos");
        Notif.INIT;
        NextNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Shipment Notification Nos", 0D, TRUE);
        Notif."Notification No" := NextNo;
        Notif.Date := date;
        Notif.Time := time;
        Notif."Purchase Order" := purchaseorder;
        Notif.Vendor := vendor;
        Notif.Location := location;
        Notif.INSERT;
        ret := NextNo;
    end;

    procedure GetProfilePicture(UserID: Text) BaseImage: Text
    // Bytes: DotNet Array;
    // Convert: DotNet Convert;
    // MemoryStream: DotNet MemoryStream;
    begin
        VendorBuffer.RESET;
        VendorBuffer.SETRANGE(VendorBuffer.UserID, UserID);

        IF VendorBuffer.FIND('-') THEN BEGIN
            IF VendorBuffer.Logo.HASVALUE THEN BEGIN
                VendorBuffer.CALCFIELDS(Logo);
                // // VendorBuffer.Logo.CREATEINSTREAM(IStream);
                // MemoryStream := MemoryStream.MemoryStream();
                // COPYSTREAM(MemoryStream, IStream);
                // Bytes := MemoryStream.GetBuffer();
                // BaseImage := Convert.ToBase64String(Bytes);
            END;
        END;
    end;

    procedure InsertTendorAttachments(vendno: Code[20]; Url: Text; Descr: Text; tenderno: Code[20]) ret: Code[20]
    var
        RecID: RecordID;
        RecordRef: RecordRef;
        RecLink: Record "Record Link";
        TenderBid: Record "Tender Bids";
        DocAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
    begin
        ret := '';
        TenderBids.RESET;
        TenderBids.SETRANGE("Tender No", tenderno);
        TenderBids.SETRANGE("Bidder No", vendno);
        IF TenderBids.FIND('-') THEN BEGIN
            TenderBid.GET(TenderBids."Bid Reference");
            RecordRef.GETTABLE(TenderBids);
            RecID := RecordRef.RECORDID;
            RecLink.RESET;
            RecLink."Record ID" := RecID;
            RecLink.URL1 := Url;
            RecLink.Type := RecLink.Type::Link;
            RecLink.Company := CompanyName;
            RecLink."User ID" := USERID;
            RecLink.Created := CURRENTDATETIME;
            RecLink.Description := Descr;
            RecLink.INSERT;
            //insert into document attachments
            CLEAR(DocAttachment);
            DocAttachment.INIT();
            DocAttachment.VALIDATE("File Extension", FileManagement.GetExtension(Url));
            DocAttachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)));
            DocAttachment.VALIDATE("Table ID", 70135632);
            DocAttachment.VALIDATE("No.", vendno);
            DocAttachment."Document Reference ID".ImportFile(COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)), TenderBids."Bid Reference", '');
            DocAttachment.INSERT(TRUE);
            ret := TenderBids."Bid Reference";
        END ELSE BEGIN
            PurchaseSetup.Get();
            PurchaseSetup.Testfield(PurchaseSetup."Tender Bid Nos");
            TenderBids.INIT;
            NextNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Tender Bid Nos", 0D, TRUE);
            TenderBids."Bid Reference" := NextNo;
            TenderBids."Tender No" := tenderno;
            TenderBids."Bidder No" := vendno;
            TenderBids.Status := TenderBids.Status::Open;
            TenderBids.INSERT;
            TenderBid.GET(NextNo);

            RecordRef.GETTABLE(TenderBid);
            RecID := RecordRef.RECORDID;
            RecLink.RESET;
            RecLink."Record ID" := RecID;
            RecLink.URL1 := Url;
            RecLink.Type := RecLink.Type::Link;
            RecLink.Company := CompanyName;
            RecLink."User ID" := USERID;
            RecLink.Created := CURRENTDATETIME;
            RecLink.Description := Descr;
            RecLink.INSERT;

            //insert into document attachments
            CLEAR(DocAttachment);
            DocAttachment.INIT();
            DocAttachment.VALIDATE("File Extension", FileManagement.GetExtension(Url));
            DocAttachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)));
            DocAttachment.VALIDATE("Table ID", 70135632);
            DocAttachment.VALIDATE("No.", vendno);
            DocAttachment."Document Reference ID".ImportFile(COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)), TenderBids."Bid Reference", '');
            DocAttachment.INSERT(TRUE);
            ret := NextNo;
        END;
    end;

    procedure DownloadLPO(filenamefromapp: Text; lpono: Code[20])
    var
        filename: Text;
        PurchaseOrder: Record "Purchase Header";
    begin
        PurchaseSetup.Get();
        PurchaseSetup.TestField(PurchaseSetup."Portal Path");
        filename := PurchaseSetup."Portal Path" + filenamefromapp;
        IF EXISTS(filename) THEN
            ERASE(filename);

        PurchaseOrder.RESET;
        PurchaseOrder.SETRANGE("No.", lpono);
        IF PurchaseOrder.FIND('-') THEN BEGIN
            REPORT.SAVEASPDF(70134887, filename, PurchaseOrder);
        END;
    end;

    procedure InsertShipmentAttachment(notifno: Code[20]; Url: Text; Descr: Text) ret: Boolean
    var
        RecID: RecordID;
        RecordRef: RecordRef;
        RecLink: Record "Record Link";
        DocAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
    begin
        ret := FALSE;
        Notif.GET(notifno);
        RecordRef.GETTABLE(Notif);
        RecID := RecordRef.RECORDID;
        RecLink.RESET;
        RecLink."Record ID" := RecID;
        RecLink.URL1 := Url;
        RecLink.Type := RecLink.Type::Link;
        RecLink.Company := CompanyName;
        RecLink."User ID" := USERID;
        RecLink.Created := CURRENTDATETIME;
        RecLink.Description := Descr;
        RecLink.INSERT;
        IF (STRPOS(Descr, 'Delivery')) >= 1 THEN Notif."Delivery Note" := TRUE;
        IF (STRPOS(Descr, 'Invoice')) >= 1 THEN Notif."Invoice Attached" := TRUE;
        Notif.MODIFY;

        //insert into document attachments
        CLEAR(DocAttachment);
        DocAttachment.INIT();
        DocAttachment.VALIDATE("File Extension", FileManagement.GetExtension(Url));
        DocAttachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)));
        DocAttachment.VALIDATE("Table ID", 70135634);
        DocAttachment.VALIDATE("No.", notifno);
        DocAttachment."Document Reference ID".ImportFile(COPYSTR(FileManagement.GetFileNameWithoutExtension(Url), 1, MAXSTRLEN(Url)), TenderBids."Bid Reference", '');
        DocAttachment.INSERT(TRUE);
        ret := TRUE;
    end;

    procedure SubmitTender(vendno: Code[20]; tenderno: Code[20]) ret: Code[20]
    begin
        ret := '';
        TenderBids.RESET;
        TenderBids.SETRANGE("Tender No", tenderno);
        TenderBids.SETRANGE("Bidder No", vendno);
        IF TenderBids.FIND('-') THEN BEGIN
            TenderBids.Status := TenderBids.Status::Submitted;
            TenderBids.MODIFY;
            ret := TenderBids."Bid Reference";
        END;
    end;

    procedure CopyRecordLinks(fromTable: Integer; primaryKey1: Code[20]; fromField: Integer; toTable: Integer; primaryKey2: Code[20]; toField: Integer) return_value: Boolean
    var
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecLink: Record "Record Link";
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        NewRecLink: Record "Record Link";
    begin
        //source table
        RecordRef1.OPEN(fromTable);
        FieldRef1 := RecordRef1.FIELD(fromField);
        FieldRef1.VALUE := primaryKey1;
        //recepient table
        RecordRef2.OPEN(toTable);
        FieldRef2 := RecordRef2.FIELD(toField);
        FieldRef2.VALUE := primaryKey2;
        RecLink.RESET;
        RecLink.SETRANGE(RecLink."Record ID", RecordRef1.RECORDID);
        IF RecLink.FINDSET THEN BEGIN
            NewRecLink.RESET;
            REPEAT
                IF (NewRecLink.FINDLAST) THEN
                    NewRecLink.NEXT := NewRecLink."Link ID" + 1
                ELSE
                    NewRecLink.INIT;
                NewRecLink.NEXT := 1;
                NewRecLink."Record ID" := RecordRef2.RECORDID;
                NewRecLink.URL1 := RecLink.URL1;
                NewRecLink.Type := RecLink.Type::Link;
                NewRecLink.Company := COMPANYNAME;
                NewRecLink."User ID" := RecLink."User ID";
                NewRecLink.Created := CURRENTDATETIME;
                NewRecLink.Description := RecLink.Description;
                NewRecLink."Link ID" := NewRecLink.NEXT;
                NewRecLink.INSERT;
            UNTIL RecLink.NEXT = 0;
        END;
    end;

    procedure CreateAccountIndi(firstname: Text; othernames: Text; krapin: Code[30]; email: Text; language: Code[50]; dob: Date; nationalid: Code[30]; nationality: Code[30]; phonenumber: Code[20]; postaladdress: Text; streetaddress: Text; password: Text; specialgroup: Integer) ret: Boolean
    begin
        VendorBuffer.RESET;
        VendorBuffer.SETRANGE(VendorBuffer."National ID", nationalid);
        IF NOT VendorBuffer.FIND('-') THEN BEGIN
            PurchaseSetup.Get();
            PurchaseSetup.testfield(PurchaseSetup."Vendor Buffer No.");
            NextNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Vendor Buffer No.", 0D, TRUE);
            VendorBuffer.INIT;
            VendorBuffer.UserID := NextNo;
            VendorBuffer."Company Name" := firstname + ' ' + othernames;
            VendorBuffer."Kra Pin" := krapin;
            VendorBuffer.Email := email;
            VendorBuffer.Language := language;
            VendorBuffer."Date of Birth" := dob;
            VendorBuffer."National ID" := nationalid;
            VendorBuffer."Company Registration No" := nationalid;
            VendorBuffer.Password := password;
            VendorBuffer.Nationality := nationality;
            VendorBuffer."Telephone No" := phonenumber;
            VendorBuffer."Mobile Phone" := phonenumber;
            VendorBuffer."Street Address/Building No" := streetaddress;
            VendorBuffer."Registration Type" := VendorBuffer."Registration Type"::Individual;
            VendorBuffer.INSERT(TRUE);
        END ELSE BEGIN
            ERROR('Could Not create account');
        END;
    end;

    procedure DownloadPPRADoc(filenamefromapp: Text; docno: code[20]; FILESPATH: Text)
    var
        RFQ: Record "Purchase Quote Header";
        filename: Text;
    //FILESPATH: Text;
    begin
        //FILESPATH := '\\192.168.88.5\c$\Portals\kma\supplier\storage\app\public\';
        filename := FILESPATH + filenamefromapp;
        IF EXISTS(filename) THEN
            ERASE(filename);

        RFQ.RESET;
        RFQ.SETRANGE("No.", docno);
        IF RFQ.FIND('-') THEN BEGIN
            REPORT.SAVEASPDF(70135667, filename, RFQ);
        END;
    end;

    procedure DeleteAllStep3(userid: code[20]) ret: Boolean
    var
        Categories: Record "Vendor Product Categories";
    begin
        ret := FALSE;
        Categories.RESET;
        Categories.SETRANGE("Vendor No", userid);
        IF Categories.FIND('-') THEN Categories.DELETEALL;
        ret := TRUE;
    end;

    procedure UpdateAccountStep3(userid: Code[20]; compname: code[40]) ret: Boolean
    var
        Categories: Record "Vendor Product Categories";
    begin
        ret := FALSE;
        Categories.RESET;
        Categories.INIT;
        Categories."Vendor No" := userid;
        //Categories.Categories := compname;
        Categories.INSERT;
        ret := TRUE;
    end;

    procedure AcknowledgeRfq(rfq_no: Code[20]; vendorno: Code[20]) ret: Boolean
    var
        ObjBidAna: Record "Bid Analysis";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ObjPurchSetp: Record "Purchases & Payables Setup";
        ObjPurchaseH: Record "Purchase Header";
    begin
        ret := false;
        ObjBidAna.Reset;
        ObjBidAna.SetRange("RFQ No.", rfq_no);
        ObjBidAna.SetRange("Vendor No.", vendorno);
        if ObjBidAna.Find('-') then begin
            ObjBidAna.Acknowledgement := true;
            ObjBidAna."Date of Acknowledgement" := CreateDateTime(Today, Time);
            ObjBidAna.Modify();
        end;
        ObjBidAna.Reset;
        ObjBidAna.SetRange("RFQ No.", rfq_no);
        ObjBidAna.SetRange("Vendor No.", vendorno);
        ObjBidAna.SetRange(Awarded, true);
        if ObjBidAna.Find('-') then begin
            ObjPurchSetp.Get();
            if ObjPurchSetp."Auto Convert Quote to Order" = true then begin
                ObjPurchaseH.Reset();
                ObjPurchaseH.SetRange("No.", ObjBidAna."Quote No.");
                ObjPurchaseH.SetRange("Document Type", ObjPurchaseH."Document Type"::Quote);
                if ObjPurchaseH.Find('-') then begin
                    if ApprovalsMgmt.PrePostApprovalCheckPurch(ObjPurchaseH) then
                        CODEUNIT.Run(CODEUNIT::"Purch.-Quote to Order", ObjPurchaseH);
                end;
            end;
        end;
        ret := true;
    end;
}

