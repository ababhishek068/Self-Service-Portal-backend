#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50951 "Inspection Header"
{

    fields
    {
        field(1;No;Code[20])
        {
        }
        field(2;"Created By";Code[50])
        {
        }
        field(3;"LPO No";Code[20])
        {
            TableRelation="Purchase Header"."No." where("Buy-from Vendor No."=field("Supplier No."),Status=const(Released),"Vendor Shipment No."=field("D Note No."),"No."=field("LPO No"));
            trigger OnValidate()
            var
            purchlines: record "Purchase Line";
            purchheader: Record "Purchase Header";
            inspectionlines: Record "Inspection Lines";
            begin
                TestField("Supplier No.");
                TestField("D Note No.");
                TestField("LPO No");
                TestField(no);
                
                purchlines.Reset();
                purchlines.SetRange(purchlines."Document No.","LPO No");
                purchlines.SetRange(purchlines."Buy-from Vendor No.","Supplier No.");
                
                //purchlines.SetRange(purchlines.);
                if purchlines.find('-') then begin
                    repeat
                    
                    inspectionlines.Reset();
                    inspectionlines.SetRange(inspectionlines."Item No.",purchlines."No.");

                    if inspectionlines.Find('-') then begin

                    end else if not inspectionlines.Find() then begin
                        if purchlines."Qty. to Receive"<>0 then
                        inspectionlines.Init;
                        inspectionlines."No.":=No;
                        inspectionlines."Item No.":=purchlines."No.";
                        inspectionlines.LPO:="LPO No";
                        inspectionlines.Dnote:="D Note No.";
                        inspectionlines.Description:=purchlines.Description;
                        inspectionlines.Quantity:=purchlines."Qty. to Receive";
                        inspectionlines.UoM:=purchlines."Unit of Measure";
                        inspectionlines."Unit Cost":=purchlines."Unit Cost";
                        inspectionlines."Total Cost":=purchlines."Line Amount";
                        inspectionlines.Insert;
                    end;
                 until purchlines.next=0;
                end;
            end;
        }
        field(4;"Supplier No.";Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                if inspected=false then begin
                    if Supplier.Get("Supplier No.") then
                  "Supplier Name" := Supplier.Name;
                end else if inspected =true then begin
                    Error('Already inspected');
                end;
                
            end;
        }
        field(5;"Supplier Name";Text[50])
        {
        }
        field(6;Date;Date)
        {
        }
        field(7;"RFQ No.";Code[20])
        {
            TableRelation="Purchase Quote Header"."No." where("Document Type"=const("Quotation Request"));
        }
        field(8;"RFQ Date";Date)
        {
        }
        field(9;"LPO Date";Date)
        {
        }
        field(10;"Total Value";Decimal)
        {
            CalcFormula = sum("Inspection Lines"."Total Cost" where ("No."=field(No)));
            FieldClass = FlowField;
        }
        field(11;"Invoice No.";Code[20])
        {
        }
        field(12;"D Note No.";Code[20])
        {
            trigger OnValidate()
            begin
                TestField("Supplier No.");
            end;
        }
        field(13;"Completion/Delivery Date";Date)
        {
        }
        field(14;"No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(15;"Reviewed By";Text[50])
        {
        }
        field(16;Description;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17;inspected;Boolean){
            Editable=false;
        }
        field(18;"Inspected By"; Code[50]){
            Editable=false;
        }
        field(19;"Date Inspected";Date){}
        field(20;"Instructions for Inspection";text[150]){}
        
    }

    keys
    {
        key(Key1;No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if (No = '') then begin
          PurchaseSetup.Get;
          PurchaseSetup.TestField("Inspection Nos.");
          No:=NoSeriesMgt.GetNextNo(PurchaseSetup."Inspection Nos.",0D,true);
        end;
        Date := Today;
        "Created By" := UserId;
        "Completion/Delivery Date" := Today;
        "Reviewed By" := UserId;
    end;

    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Supplier: Record Vendor;
}

